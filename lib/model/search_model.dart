///搜索实体
class SearchModel {
  String keyword;
  final List<SearchItem> data;

  SearchModel({this.data});

  ///json转dart model
  factory SearchModel.fromJson(Map<String, dynamic> json) {
    var dataJson = json['data'] as List;
    List<SearchItem> data =
        dataJson.map((item) => SearchItem.fromJson(item)).toList();
    return SearchModel(data: data);
  }

  ///dart model 转 map
  Map<String, dynamic> toJson({SearchModel searchModel}) {
    return {
      'data': data.map((item) => SearchItem().toJson(searchItem: item)).toList()
    };
  }
}

///搜索子项实体
class SearchItem {
  final String word;
  final String type;
  final String price;
  final String star;
  final String zoneName;
  final String districtName;
  final String url;

  SearchItem(
      {this.word,
      this.type,
      this.price,
      this.star,
      this.zoneName,
      this.districtName,
      this.url});

  ///json转dart model
  factory SearchItem.fromJson(Map<String, dynamic> json) {
    return SearchItem(
        word: json['word'],
        type: json['type'],
        price: json['price'],
        star: json['star'],
        zoneName: json['zonename'],
        districtName: json['districtname'],
        url: json['url']);
  }

  ///dart model 转 map
  Map<String, dynamic> toJson({SearchItem searchItem}) {
    if (searchItem != null) {
      return {
        'word': searchItem.word,
        'type': searchItem.type,
        'price': searchItem.price,
        'star': searchItem.star,
        'zoneName': searchItem.zoneName,
        'districtName': searchItem.districtName,
        'url': searchItem.url
      };
    } else {
      return {
        'word': word,
        'type': type,
        'price': price,
        'star': star,
        'zoneName': zoneName,
        'districtName': districtName,
        'url': url
      };
    }
  }
}
