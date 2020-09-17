///config 实体
class ConfigModel {
  final String searchUrl;

  ConfigModel({this.searchUrl});

  ///将json字符串转为dart model
  factory ConfigModel.fromJson(Map<String, dynamic> json) {
    return ConfigModel(searchUrl: json['searchUrl']);
  }

  ///将dart model 转为map
  Map<String, dynamic> toJson({ConfigModel configModel}) {
    if (configModel != null) {
      return {
        'searchUrl': configModel.searchUrl,
      };
    } else {
      return {'searchUrl': searchUrl};
    }
  }
}
