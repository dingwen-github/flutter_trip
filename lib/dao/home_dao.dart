import 'dart:async';
import 'dart:convert';
import 'package:flustars/flustars.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_trip/model/home_model.dart';

///首页Dao
const HOME_URL = 'http://www.devio.org/io/flutter_app/json/home_page.json';

class HomeDao {
  static Future<HomeModel> fetch() async {
    final response = await http.get(HOME_URL);
    if(response.statusCode == 200){
      ///解决中文乱码
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      return HomeModel.fromJson(result);
    }else{
      LogUtil.init(isDebug: true);
      LogUtil.v('Failed load home_page.json',tag: 'HomeDao fetch()');
      throw Exception('Failed load home_page.json');
    }
  }
}
