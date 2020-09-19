
import 'package:flustars/flustars.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_trip/dao/search_dao.dart';
import 'package:flutter_trip/model/search_model.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widgets/search_bar.dart';
import 'package:flutter_trip/widgets/webview.dart';

const TYPES = [
  'channelgroup',
  'gs',
  'plane',
  'train',
  'cruise',
  'district',
  'food',
  'hotel',
  'huodong',
  'shop',
  'sight',
  'ticket',
  'travelgroup'
];
const URL =
    'https://m.ctrip.com/restapi/h5api/globalsearch/search?source=mobileweb&action=mobileweb&keyword=';

//TODO 等待完善
class SearchPage extends StatefulWidget {
  final String hint;
  final bool hideLeft;
  final String searchUrl;
  final String keyword;

  const SearchPage(
      {Key key, this.hint, this.hideLeft, this.searchUrl, this.keyword})
      : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  SearchModel searchModel;
  String keyword;

  @override
  void initState() {
    super.initState();
    if (widget.keyword != null) {
      _onTextChange(widget.keyword);
    }
    LogUtil.init(isDebug: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          _appBar,
          MediaQuery.removePadding(
              context: context,
              child: Expanded(
                flex: 1,
                child: ListView.builder(
                  itemBuilder: (BuildContext context, int position) {
                    return _item(position);
                  },
                  itemCount: searchModel?.data?.length ?? 0,
                ),
              )),
        ],
      ),
    );
  }

  void _onTextChange(String text) {
    keyword = text;
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }

    ///考虑到searchUrl会不定期的更新，优先服务端配置返回的searchUrl
    String url =
        (HomePage.configModel?.searchUrl ?? widget.searchUrl) + text;
    SearchDao.fetch(url, text).then((SearchModel model) {
      //只有当当前输入的内容和服务端返回的内容一致时才渲染
      if (model.keyword == keyword) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((e) => LogUtil.v(e, tag: 'SearchDao: fetch()'));
  }

  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: [Color(0x66000000), Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
          child: Container(
            padding: EdgeInsets.only(top: 50),
            height: 90.0,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            child: SearchBar(
              hint: widget.hint,
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              speakButtonClick: () {},
              rightButtonClick: () {},
              leftButtonClick: _leftButtonClick,
              onChanged: _onTextChange,
            ),
          ),
        ),
      ],
    );
  }

  Widget _item(int position) {
    if (searchModel == null || searchModel.data == null) return null;
    SearchItem searchItem = searchModel.data[position];
    return GestureDetector(
      onTap: () {
        NavigatorUtil.push(
            context,
            WebView(
              url: searchItem.url,
              title: '详情',
            ));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey)),
        ),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              child: Image(
                width: 26,
                height: 26,
                image: AssetImage(_typeImage(searchItem.type)),
              ),
            ),
            Column(
              children: <Widget>[
                Container(
                  width: 300,
                  child: _title(searchItem),
                ),
                Container(
                  width: 300,
                  margin: EdgeInsets.only(top: 5),
                  child: _subTitle(searchItem),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _typeImage(String type) {
    if (type == null) return 'images/type_travelgroup.png';
    String path = 'travelgroup';
    path = TYPES.firstWhere((item) => type.contains(item),orElse: ()=> 'travelgroup');
    return 'images/type_$path.png';
  }

  _title(SearchItem searchItem) {
    if (searchItem == null) return null;
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(searchItem.word, searchModel.keyword));
    spans.add(TextSpan(
      text: ' ${searchItem.districtName ?? ''} ${searchItem.zoneName ?? ''}'
    ));
    return RichText(
      text: TextSpan(
        children: spans,
      ),
    );
  }

  _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) return spans;

    ///搜索关键字高亮忽略大小写
    String wordL = word.toLowerCase(), keywordL = keyword.toLowerCase();
    List<String> arr = wordL.split(keywordL);
    TextStyle normalStyle = TextStyle(fontSize: 17, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 17, color: Colors.orange);
    //'wordwoc'.split('w') -> [, ord, oc] @https://www.tutorialspoint.com/tpcg.php?p=wcpcUA
    int preIndex = 0;
    for (int i = 0; i < arr.length; i++) {
      if (i != 0) {
        preIndex = wordL.indexOf(keywordL, preIndex);
        spans.add(TextSpan(
            text: word.substring(preIndex, preIndex + keyword.length),
            style: keywordStyle));
      }

      if (arr[i] != null && arr[i].length > 0) {
        spans.add(TextSpan(
          text: arr[i],
          style: normalStyle,
        ));
      }
    }

    return spans;
  }

  _subTitle(SearchItem searchItem) {
    TextStyle priceStyle = TextStyle(fontSize: 16, color: Colors.orange);
    TextStyle starStyle = TextStyle(fontSize: 12, color: Colors.grey);
    return RichText(
      text: TextSpan(
        children: <TextSpan>[
          TextSpan(
            text: searchItem.price ?? '',
            style: priceStyle,
          ),
          TextSpan(
            text: searchItem.star ?? '',
            style: starStyle,
          ),
        ],
      ),
    );
  }

  void _leftButtonClick() {
    Navigator.pop(context);
  }
}
