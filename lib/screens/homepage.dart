import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watch_app/api/api_source.dart';
import 'package:watch_app/main.dart';
import 'package:watch_app/model/addcartwatch.dart';
import 'package:watch_app/provider/watches_Impl.dart';
import 'package:watch_app/screens/cart.dart';
import 'package:watch_app/screens/detailWatch.dart';
import 'package:watch_app/screens/profile.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Map<String, dynamic>> futureProductsMenWatches;
  late Future<Map<String, dynamic>> futureProductsWomenWatches;
  late SharedPreferences sharedPreferences;
  late PageController _pageController;
  late Box<AddCartWatch> cartBox;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureProductsMenWatches = ApiSource().getMenWatches();
    futureProductsWomenWatches = ApiSource().getWomenWatches();
    cartBox = Hive.box<AddCartWatch>(CartName);
    _pageController = PageController();
    initial();
  }

  initial() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      sharedPreferences.getString('username');
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[200],
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
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              child: Text(
                'Watches App',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _pageController,
          children: [
            buildWatchesPage(),
            CartListProduct(),
            MyProfile(),
          ],
          onPageChanged: (int index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.lightBlue,
        items: const <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.shopping_cart, size: 30),
          Icon(Icons.person, size: 30),
        ],
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index,
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeIn);
          });
        },
        index: _selectedIndex,
        animationDuration: const Duration(milliseconds: 200),
        height: 50,
        animationCurve: Curves.bounceInOut,
        color: Colors.indigo,
      ),
    );
  }

  Widget buildWatchesPage() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMenPages(),
          SizedBox(height: 20),
          buildWomenWatches(),
        ],
      ),
    );
  }

  Widget buildMenPages() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Men\'s Watches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder<Map<String, dynamic>>(
          future: futureProductsMenWatches,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final products = snapshot.data!['products'] as List<dynamic>;
              return buildWatchesList(products);
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget buildWomenWatches() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Women\'s Watches',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        FutureBuilder<Map<String, dynamic>>(
          future: futureProductsWomenWatches,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final products = snapshot.data!['products'] as List<dynamic>;
              return buildWatchesList(products);
            } else if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ],
    );
  }

  Widget buildWatchesList(List<dynamic> products) {
    return Container(
      height: 280,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index] as Map<String, dynamic>;
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailWatch(
                    products: Products.fromJson(product),
                  ),
                ),
              );
            },
            child: Container(
              margin: EdgeInsets.only(left: 20),
              height: 280,
              width: 240,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.indigo,
              ),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: Center(
                        child: Image.network(
                          product['thumbnail'] as String,
                          height: 250,
                          width: 250,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        product['title'] as String,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        product['description'] as String,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        '\$${product['price']}',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
