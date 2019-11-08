

/**
 *使用平台通道调用原生代码
 */
import 'package:flutter/material.dart';

import 'service_method.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),

    );
  }
}
