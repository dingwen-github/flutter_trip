import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/config_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/sales_box_model.dart';

///home 实体
class HomeModel {
  final ConfigModel config;
  final List<CommonModel> bannerList;
  final List<CommonModel> localNavList;
  final List<CommonModel> subNavList;
  final GridNavModel gridNav;
  final SalesBoxModel salesBox;

  HomeModel(
      {this.config,
      this.bannerList,
      this.localNavList,
      this.subNavList,
      this.gridNav,
      this.salesBox});

  ///json 转 dart model
  factory HomeModel.fromJson(Map<String, dynamic> json) {
    var localNavListJson = json['localNavList'] as List;
    List<CommonModel> localNavList =
        localNavListJson.map((common) => CommonModel.fromJson(common)).toList();
    var bannerListJson = json['bannerList'] as List;
    List<CommonModel> bannerList =
        bannerListJson.map((common) => CommonModel.fromJson(common)).toList();
    var subNavListJson = json['subNavList'] as List;
    List<CommonModel> subNavList =
        subNavListJson.map((common) => CommonModel.fromJson(common)).toList();

    return HomeModel(
      config: ConfigModel.fromJson(json['config']),
      bannerList: bannerList,
      localNavList: localNavList,
      subNavList: subNavList,
      gridNav: GridNavModel.fromJson(json['gridNav']),
      salesBox: SalesBoxModel.fromJson(json['salesBox']),
    );
  }

  /// dart model 转 map
  Map<String, dynamic> toJson() {
    return {
      'config': ConfigModel().toJson(configModel: config),
      'bannerList': bannerList.map((common)=> CommonModel().toJson(commonModel: common)).toList(),
      'localNavList': localNavList.map((common) => CommonModel().toJson(commonModel: common)).toList(),
      'subNavList': subNavList.map((common) => CommonModel().toJson(commonModel: common)).toList(),
      'gridNav': GridNavModel().toJson(gridNavModel: gridNav),
      'salesBox': SalesBoxModel().toJson(salesBoxModel: salesBox),
    };
  }
}
