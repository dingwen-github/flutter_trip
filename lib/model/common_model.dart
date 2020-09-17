///common 实体
class CommonModel {
  final String icon;
  final String title;
  final String url;
  final String statusBarColor;
  final bool hideAppBar;

  CommonModel(
      {this.icon, this.title, this.url, this.statusBarColor, this.hideAppBar});

  ///json字符串转dart model
  factory CommonModel.fromJson(Map<String, dynamic> json) {
    return CommonModel(
        icon: json['icon'],
        title: json['title'],
        url: json['url'],
        statusBarColor: json['statusBarColor'],
        hideAppBar: json['hideAppBar']);
  }

  ///dart model 转为map
  Map<String, dynamic> toJson({CommonModel commonModel}) {
    if(commonModel == null){
      return {
        'icon': icon,
        'title': title,
        'url': url,
        'statusBarColor': statusBarColor,
        'hideAppBar': hideAppBar,
      };
    }else{
      return {
        'icon': commonModel.icon,
        'title': commonModel.title,
        'url': commonModel.url,
        'statusBarColor': commonModel.statusBarColor,
        'hideAppBar': commonModel.hideAppBar,
      };
    }

  }
}
