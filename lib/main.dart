import 'package:chaotot/scaffold/authen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chao TOT',
      debugShowCheckedModeBanner: false,
      home: Authen(),
    );
  }
}
