import 'dart:io';
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
    var list = await MultiImagePicker.pickImage();
    setState(() {
      datas.addAll(list);
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
      body: Center(
        child: Wrap(
          spacing: 5,
          runSpacing: 5,
          children: _getImages(),
        ),
      ),
    );
  }

 _getImages() {
   return datas.map(
      (path) {
        File pathfile = File(path);
        return Stack(
          children: <Widget>[
            ClipRRect(
              //圆角效果
              borderRadius: BorderRadius.circular(5),
              child: Image.file(pathfile, width: 120, height: 90, fit: BoxFit.fill),
            ),
            Positioned(
              right: 5,
              top: 5,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    datas.remove(path);
                  });
                },
                child: ClipOval(
                  //圆角删除按钮
                  child: Container(
                    padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(color: Colors.black54),
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).toList();
  }
}
