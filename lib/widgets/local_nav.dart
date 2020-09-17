import 'package:flutter/material.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widgets/webview.dart';

///Local nav
class LocalNav extends StatelessWidget {
  final List<CommonModel> localNavList;

  const LocalNav({Key key, @required this.localNavList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      child: Padding(
        padding: EdgeInsets.all(7),
        child: _items(context),
      ),
    );
  }

  ///构建local
  _items(BuildContext context) {
    if (localNavList == null) {
      return;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: localNavList.map((common) => _item(context, common)).toList(),
    );
  }

  Widget _item(BuildContext context, CommonModel common) {
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            WebView(
              url: common.url,
              statusBarColor: common.statusBarColor,
              hideAppBar: common.hideAppBar,
            ));
      },
      child: Column(
        children: <Widget>[
          Image.network(
            common.icon,
            width: 32,
            height: 32,
          ),
          Text(
            common.title,
            style: TextStyle(fontSize: 12.0),
          )
        ],
      ),
    );
  }
}
