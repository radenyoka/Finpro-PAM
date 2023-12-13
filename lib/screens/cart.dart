import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';
import 'package:watch_app/main.dart';
import 'package:watch_app/model/addcartwatch.dart';

enum Currency { USD, IDR, AED, EUR }

enum TimeZone { WIB, WITA, WIT, GMT }

class CartListProduct extends StatefulWidget {
  const CartListProduct({Key? key}) : super(key: key);

  @override
  State<CartListProduct> createState() => _CartListProductState();
}

class _CartListProductState extends State<CartListProduct> {
  late Box<AddCartWatch> cartBox;
  Currency selectedCurrency = Currency.USD;
  late Timer timer;
  TimeZone selectedTimeZone = TimeZone.WIB;
  String? formattedTime;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<AddCartWatch>(CartName);
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      getTime();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: cartBox.isEmpty
            ? Center(
                child: Text('Tidak ada data yang disimpan'),
              )
            : ListView.builder(
                itemCount: cartBox.length,
                itemBuilder: (context, index) {
                  final cartProduct = cartBox.getAt(index);
                  return Dismissible(
                    key: Key(cartProduct!.title),
                    onDismissed: (direction) {
                      cartBox.deleteAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Produk dihapus dari keranjang!'),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      child: Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Card(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(height: 10),
                              _buildFormattedTime(),
                              _buildTimezoneDropdown(),
                              SizedBox(height: 10),
                              _buildProductInfo(cartProduct),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildProductInfo(AddCartWatch? cartProduct) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                // Center the title
                child: Center(
                  child: Text(
                    cartProduct?.title ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        SizedBox(
          height: 200, // Adjust the height as needed
          child: Image.network(
            cartProduct?.thumbnail ?? '',
            fit: BoxFit.cover,
          ),
        ),
        Card(
          color: Colors.indigo,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Text(
                  'Price: ${formatPrice(cartProduct!.price.toDouble())}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(width: 10),
                buildCurrencyDropdown(),
              ],
            ),
          ),
        )
      ],
    );
  }

  Widget _buildFormattedTime() {
    return Text(
      formattedTime ?? '',
      style: const TextStyle(
        fontSize: 12,
        color: Colors.black,
      ),
    );
  }

  Widget buildCurrencyDropdown() {
    return DropdownButton<Currency>(
      value: selectedCurrency,
      onChanged: (Currency? newValue) {
        if (newValue != null) {
          setState(() {
            selectedCurrency = newValue;
          });
        }
      },
      items: Currency.values.map((Currency currency) {
        return DropdownMenuItem<Currency>(
          value: currency,
          child: Text(getCurrencySymbol(currency)),
        );
      }).toList(),
    );
  }

  String formatPrice(double price) {
    switch (selectedCurrency) {
      case Currency.USD:
        return '\$${price.toStringAsFixed(2)}';
      case Currency.IDR:
        return 'IDR${(price * 1551950).toStringAsFixed(2)}';
      case Currency.AED:
        return 'AED ${(price * 3.67).toStringAsFixed(0)}';
      case Currency.EUR:
        return '€${(price * 0.93).toStringAsFixed(2)}';
    }
  }

  String getCurrencySymbol(Currency currency) {
    switch (currency) {
      case Currency.USD:
        return '\$';
      case Currency.IDR:
        return 'IDR';
      case Currency.AED:
        return 'AED';
      case Currency.EUR:
        return '€';
    }
  }

  Widget _buildTimezoneDropdown() {
    return DropdownButton<TimeZone>(
      value: selectedTimeZone,
      onChanged: (TimeZone? newValue) {
        setState(() {
          selectedTimeZone = newValue!;
          getTime();
        });
      },
      items: TimeZone.values.map((TimeZone timezone) {
        return DropdownMenuItem<TimeZone>(
          value: timezone,
          child: Text("Convert To ${timezone.toString().split('.').last}",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              )),
        );
      }).toList(),
    );
  }

  void getTime() async {
    try {
      Response response = await get(
          Uri.parse("https://worldtimeapi.org/api/timezone/Asia/Jakarta"));
      Map data = jsonDecode(response.body);

      String datetime = data['datetime'];
      String offset = data['utc_offset'].substring(1, 3);

      DateTime now = DateTime.parse(datetime);
      now = now.add(Duration(hours: int.parse(offset)));

      formattedTime = _getFormattedTime(now, selectedTimeZone);
      setState(() {});
    } catch (e) {
      print('Error fetching time: $e');
    }
  }

  String _getFormattedTime(DateTime time, TimeZone timeZone) {
    switch (timeZone) {
      case TimeZone.WIB:
        return '${time.hour}:${time.minute}:${time.second} WIB';
      case TimeZone.WITA:
        return '${time.hour + 1}:${time.minute}:${time.second} WITA';
      case TimeZone.WIT:
        return '${time.hour + 2}:${time.minute}:${time.second} WIT';
      case TimeZone.GMT:
        return '${time.hour + 7}:${time.minute}:${time.second} London';
      default:
        return '';
    }
  }
}
