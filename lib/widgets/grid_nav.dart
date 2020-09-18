import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widgets/webview.dart';

///网格卡片
class GridNav extends StatelessWidget {
  final GridNavModel gridNavModel;

  const GridNav({Key key, @required this.gridNavModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PhysicalModel(
      color: Colors.transparent,
      borderRadius: BorderRadius.all(Radius.circular(6)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: _items(context),
      ),
    );
  }

  ///上中下三个item列表
  List<Widget> _items(BuildContext context) {
    List<Widget> widgets = [];
    if (gridNavModel == null) {
      return widgets;
    }
    if (gridNavModel.hotel != null) {
      widgets.add(_item(
          context: context, gridNavItem: gridNavModel.hotel, isFirst: true));
    }
    if (gridNavModel.flight != null) {
      widgets.add(_item(
          context: context, gridNavItem: gridNavModel.flight, isFirst: false));
    }
    if (gridNavModel.travel != null) {
      widgets.add(_item(
          context: context, gridNavItem: gridNavModel.travel, isFirst: false));
    }
    return widgets;
  }

  ///左中右三个item组成一个上中下item
  Widget _item({BuildContext context, GridNavItem gridNavItem, bool isFirst}) {
    List<Widget> widgets = [];
    widgets
      ..add(_itemChildMain(context, gridNavItem.mainItem))
      ..add(_itemChildDouble(context, gridNavItem.item1, gridNavItem.item2))
      ..add(_itemChildDouble(context, gridNavItem.item3, gridNavItem.item4));
    List<Widget> expandItems = widgets
        .map((item) => Expanded(
              child: item,
              flex: 1,
            ))
        .toList();
    Color endColor = Color(int.parse('0xff' + gridNavItem.endColor));
    Color startColor = Color(int.parse('0xff' + gridNavItem.startColor));
    return Container(
      height: 88,
      margin: isFirst ? null : EdgeInsets.only(top: 3),
      decoration: BoxDecoration(
        ///线性渐变
        gradient: LinearGradient(colors: [startColor, endColor]),
      ),
      child: Row(
        children: expandItems,
      ),
    );
  }

  ///左边第一个子项
  Widget _itemChildMain(BuildContext context, CommonModel commonModel) {
    return _wrapGesture(
        context,
        Stack(
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Image.network(
              commonModel.icon,
              fit: BoxFit.contain,
              height: 88,
              width: 121,
              alignment: AlignmentDirectional.bottomEnd,
            ),
            Container(
              margin: EdgeInsets.all(11),
              child: Text(
                commonModel.title,
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ),
          ],
        ),
        commonModel);
  }

  ///右边两个子项
  Widget _itemChildDouble(
      BuildContext context, CommonModel topItem, CommonModel bottomItem) {
    return Column(
      children: <Widget>[
        Expanded(
          child: _itemChildDoubleItem(
              context: context, commonModel: topItem, isFirst: true),
        ),
        Expanded(
          child: _itemChildDoubleItem(
              context: context, commonModel: bottomItem, isFirst: false),
        ),
      ],
    );
  }

  ///点击打开页面
  _wrapGesture(BuildContext context, Widget widget, CommonModel commonModel) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            WebView(
              url: commonModel.url,
              statusBarColor: commonModel.statusBarColor,
              title: commonModel.title,
              hideAppBar: commonModel.hideAppBar,
            ));
      },
      child: widget,
    );
  }

  ///右边两个子项的上下两个子项
  _itemChildDoubleItem(
      {BuildContext context, CommonModel commonModel, bool isFirst}) {
    BorderSide borderSide = BorderSide(width: 0.8, color: Colors.white);
    return FractionallySizedBox(
      //撑满屏幕宽度
      widthFactor: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            left: borderSide,
            bottom: isFirst ? borderSide : BorderSide.none,
          ),
        ),
        child: _wrapGesture(
            context,
            Center(
              child: Text(
                commonModel.title,
                style: TextStyle(fontSize: 14, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            commonModel),
      ),
    );
  }
}
