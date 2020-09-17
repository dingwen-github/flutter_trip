import 'package:flutter_trip/model/common_model.dart';

///sales box 实体 活动入口模型
class SalesBoxModel {
  final String icon;
  final String moreUrl;
  final CommonModel bigCard1;
  final CommonModel bigCard2;
  final CommonModel smallCard1;
  final CommonModel smallCard2;
  final CommonModel smallCard3;
  final CommonModel smallCard4;

  SalesBoxModel(
      {this.icon,
      this.moreUrl,
      this.bigCard1,
      this.bigCard2,
      this.smallCard1,
      this.smallCard2,
      this.smallCard3,
      this.smallCard4});

  ///json转dart model
  factory SalesBoxModel.fromJson(Map<String, dynamic> json) {
    return SalesBoxModel(
      icon: json['icon'],
      moreUrl: json['moreUrl'],
      bigCard1: CommonModel.fromJson(json['bigCard1']),
      bigCard2: CommonModel.fromJson(json['bigCard2']),
    );
  }

  ///dart 转 map
  Map<String, dynamic> toJson({SalesBoxModel salesBoxModel}) {
    if (salesBoxModel != null) {
      return {
        'icon': salesBoxModel.icon,
        'moreUrl': salesBoxModel.moreUrl,
        'bigCard1': CommonModel().toJson(commonModel: salesBoxModel.smallCard1),
        'bigCard2': CommonModel().toJson(commonModel: salesBoxModel.smallCard2),
        'smallCard1': CommonModel().toJson(commonModel: salesBoxModel.smallCard1),
        'smallCard2': CommonModel().toJson(commonModel: salesBoxModel.smallCard2),
        'smallCard3': CommonModel().toJson(commonModel: salesBoxModel.smallCard3),
        'smallCard4': CommonModel().toJson(commonModel: salesBoxModel.smallCard4),
      };
    } else {
      return {
        'icon': icon,
        'moreUrl': moreUrl,
        'bigCard1': CommonModel().toJson(commonModel: bigCard1),
        'bigCard2': CommonModel().toJson(commonModel: bigCard2),
        'smallCard1': CommonModel().toJson(commonModel: smallCard1),
        'smallCard2': CommonModel().toJson(commonModel: smallCard2),
        'smallCard3': CommonModel().toJson(commonModel: smallCard3),
        'smallCard4': CommonModel().toJson(commonModel: smallCard4),
      };
    }
  }
}
