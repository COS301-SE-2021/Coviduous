import 'package:flutter/material.dart';
import 'package:test_node_flutter/pages/main_page.dart';

void main(){
  runApp(App());
}

class App extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Flutter NodeJS",
      home: MainPage(),
    );
  }
}