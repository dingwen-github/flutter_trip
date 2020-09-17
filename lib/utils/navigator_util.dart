import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///路由跳转工具类
class NavigatorUtil {
  ///跳转到指定页面
  static push(BuildContext context, Widget page) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => page));
  }
}
