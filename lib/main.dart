

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fyp/screen/login.dart';





void main() async {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {


// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginScreen(),
    );
  }
}

