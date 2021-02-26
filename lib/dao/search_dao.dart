import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/model/search_model.dart';
import 'package:http/http.dart' as http;

class SearchDao {
  static Future<SearchModel> fetch(String url, String text) async {
    final response = await http.get(url + text);
    if (response.statusCode == 200) {
      Utf8Decoder utf8decoder = Utf8Decoder(); //修复中文乱码
      var result = json.decode(utf8decoder.convert(response.bodyBytes));
      SearchModel searchModel = SearchModel.formJson(result);
      searchModel.keyword = text;
      return searchModel;
    } else {
      throw Exception('加载失败');
    }
  }
}
