import 'dart:math';

import 'package:flutter_trip/model/common_model.dart';

///grid nav 实体
class GridNavModel {
  final GridNavItem hotel;
  final GridNavItem flight;
  final GridNavItem travel;

  GridNavModel({this.hotel, this.flight, this.travel});

  ///json 转 dart model
  factory GridNavModel.fromJson(Map<String, dynamic> json) {
    return json == null
        ? null
        : GridNavModel(
            hotel: GridNavItem.fromJson(json['hotel']),
            flight: GridNavItem.fromJson(json['flight']),
            travel: GridNavItem.fromJson(json['travel']));
  }

  ///dart model 转 map
  Map<String, dynamic> toJson({GridNavModel gridNavModel}) {
    if (gridNavModel != null) {
      return {
        'hotel': GridNavItem().toJson(gridNavItem: gridNavModel.hotel),
        'flight': GridNavItem().toJson(gridNavItem: gridNavModel.flight),
        'travel': GridNavItem().toJson(gridNavItem: gridNavModel.travel),
      };
    } else {
      return {
        'hotel': GridNavItem().toJson(gridNavItem: hotel),
        'flight': GridNavItem().toJson(gridNavItem: flight),
        'travel': GridNavItem().toJson(gridNavItem: travel),
      };
    }
  }
}

///grid nav item 实体
class GridNavItem {
  final String startColor;
  final String endColor;
  final CommonModel mainItem;
  final CommonModel item1;
  final CommonModel item2;
  final CommonModel item3;
  final CommonModel item4;

  GridNavItem(
      {this.startColor,
      this.endColor,
      this.mainItem,
      this.item1,
      this.item2,
      this.item3,
      this.item4});

  ///将json字符串转为dart model
  factory GridNavItem.fromJson(Map<String, dynamic> json) {
    return GridNavItem(
      startColor: json['startColor'],
      endColor: json['endColor'],
      mainItem: CommonModel.fromJson(json['mainItem']),
      item1: CommonModel.fromJson(json['item1']),
      item2: CommonModel.fromJson(json['item2']),
      item3: CommonModel.fromJson(json['item3']),
      item4: CommonModel.fromJson(json['item4']),
    );
  }

  ///将dart model 转为map
  Map<String, dynamic> toJson({GridNavItem gridNavItem}) {
    if (gridNavItem != null) {
      return {
        'startColor': gridNavItem.startColor,
        endColor: gridNavItem.endColor,
        'mainItem': CommonModel().toJson(commonModel: gridNavItem.mainItem),
        'item1': CommonModel().toJson(commonModel: gridNavItem.item1),
        'item2': CommonModel().toJson(commonModel: gridNavItem.item2),
        'item3': CommonModel().toJson(commonModel: gridNavItem.item3),
        'item4': CommonModel().toJson(commonModel: gridNavItem.item4),
      };
    } else {
      return {
        'startColor': startColor,
        endColor: endColor,
        'mainItem': CommonModel().toJson(commonModel: mainItem),
        'item1': CommonModel().toJson(commonModel: item1),
        'item2': CommonModel().toJson(commonModel: item2),
        'item3': CommonModel().toJson(commonModel: item3),
        'item4': CommonModel().toJson(commonModel: item4),
      };
    }
  }
}
