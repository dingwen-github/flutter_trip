import 'dart:convert';

import 'package:flustars/flustars.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:http/http.dart' as http;

///搜索接口
class SearchDao {
  static Future<SearchModel> fetch(String url, String text) async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      ///解决中文乱码
      Utf8Decoder utf8decoder = Utf8Decoder();
      var result = json.decode(utf8decoder.convert(response.bodyBytes));

      ///只有当当前输入的内容和服务端返回的内容一致时才渲染
      SearchModel searchModel = SearchModel.fromJson(result);
      searchModel.keyword = text;
      return searchModel;
    } else {
      LogUtil.init(isDebug: true);
      LogUtil.v(throw Exception('Failed to load search_page.json'),
          tag: 'search_dao:fetch()');
    }
  }
}
