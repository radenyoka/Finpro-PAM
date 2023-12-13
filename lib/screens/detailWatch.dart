import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:watch_app/main.dart';
import 'package:watch_app/model/addcartwatch.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:watch_app/provider/watches_Impl.dart';

class DetailWatch extends StatefulWidget {
  const DetailWatch({Key? key, required this.products}) : super(key: key);

  final Products products;

  @override
  State<DetailWatch> createState() => _DetailWatchState();
}

class _DetailWatchState extends State<DetailWatch> {
  late Box<AddCartWatch> cartBox;

  @override
  void initState() {
    super.initState();
    cartBox = Hive.box<AddCartWatch>(CartName);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void addToCart() {
    cartBox.add(AddCartWatch(
      title: widget.products.title!,
      description: widget.products.description!,
      price: widget.products.price!,
      rating: widget.products.rating!,
      thumbnail: widget.products.thumbnail!,
    ));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Produk ditambahkan ke keranjang'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.blueGrey],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      title: Text('Detail Watches',
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
       ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 300,
                child: CarouselSlider(
                  items: widget.products.images?.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.indigo[300],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              i,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 300,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    aspectRatio: 16 / 9,
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enableInfiniteScroll: true,
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    viewportFraction: 0.8,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.products.title!,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      widget.products.description!,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      'Price: \$${widget.products.price}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Category: ${widget.products.category}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Brand: ${widget.products.brand}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Rating: ${widget.products.rating}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Stock: ${widget.products.stock}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Discount Percentage: ${widget.products.discountPercentage}',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addToCart,
        child: Icon(Icons.shopping_cart_outlined),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
