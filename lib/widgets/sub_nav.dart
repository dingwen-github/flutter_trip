import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widgets/webview.dart';

///活动入口
class SubNav extends StatelessWidget {
  final List<CommonModel> subNavList;

  const SubNav({Key key, @required this.subNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  Widget _items(BuildContext context) {
    ///养成良好的编程习惯，使用数据之前一定做null处理
    if (subNavList == null) {
      return null;
    }
    List<Widget> widgets =
        subNavList.map((item) => _item(context, item)).toList();

    ///计算出第一行显示的数量
    int separate = (subNavList.length / 2 + 0.5).toInt();
    return Column(
      children: <Widget>[
        ///数组截取
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widgets.sublist(0, separate),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: widgets.sublist(separate, subNavList.length),
        ),
      ],
    );
  }

  Widget _item(BuildContext context, CommonModel commonModel) {
    ///撑满垂直高度，达到居中的效果
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: () {
          NavigatorUtil.push(
              context,
              WebView(
                url: commonModel.url,
                statusBarColor: commonModel.statusBarColor,
                hideAppBar: commonModel.hideAppBar,
              ));
        },
        child: Column(
          children: <Widget>[
            Image.network(
              commonModel.icon,
              width: 18,
              height: 18,
            ),
            Padding(
              padding: EdgeInsets.only(top: 3),
              child: Text(
                commonModel.title,
                style: TextStyle(fontSize: 12),
              ),
            )
          ],
        ),
      ),
    );
  }
}
