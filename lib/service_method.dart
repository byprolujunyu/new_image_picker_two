import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

/**
 *使用平台通道调用原生代码
 */
import 'package:flutter/material.dart';

import 'picker.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List datas = List();
  bool isType = false;

  void _getGallery() async {
    var list = await MultiImagePicker.pickImageAndVideo();
    setState(() {
      datas = list;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("相册"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.movie_creation),
            onPressed: _getGallery,
          )
        ],
      ),
      body: GridView.count(
        crossAxisCount: 4,
        padding: EdgeInsets.all(5.0),
        children: datas.map((path) {
          return getWidges(path);
        }).toList(),
      ),
    );
  }

 Widget getWidges(path) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: new EdgeInsets.symmetric(horizontal: 5.0),
        child: Image.file(
          File(path),
          width: MediaQuery.of(context).size.width / 4,
          height: 200,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
