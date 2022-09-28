import 'package:gaussian_ahp_method/screens/about_page.dart';
import 'package:flutter/material.dart';
import 'package:gaussian_ahp_method/screens/form_page.dart';
import 'package:gaussian_ahp_method/screens/home_page.dart';
import 'package:gaussian_ahp_method/screens/matrix_page.dart';
import 'package:gaussian_ahp_method/screens/result_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gaussian AHP Method',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.blue,
        accentColor: Colors.white,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (context) => HomePage(),
        "/form": (context) => CriteriaForm(),
        "/matrix": (context) => MatrixPage(),
        "/results": (context) => ResultPage(),
        "/about": (context) => AboutPage(),
      },
    );
  }
}
