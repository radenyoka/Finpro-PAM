import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:watch_app/model/addcartwatch.dart';
import 'package:watch_app/screens/login_page.dart';

String CartName = 'cart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<AddCartWatch>(AddCartWatchAdapter());
  await Hive.openBox<AddCartWatch>(CartName);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Watches App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyLoginPage(),
    );
  }
}
