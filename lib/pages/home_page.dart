import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/config_model.dart';
import 'package:flutter_trip/model/grid_nav_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_trip/model/sales_box_model.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widgets/grid_nav.dart';
import 'package:flutter_trip/widgets/loading_container.dart';
import 'package:flutter_trip/widgets/local_nav.dart';
import 'package:flutter_trip/widgets/sales_box.dart';
import 'package:flutter_trip/widgets/search_bar.dart';
import 'package:flutter_trip/widgets/sub_nav.dart';
import 'package:flutter_trip/widgets/webview.dart';

///滚动的最大距离
const APPBAR_SCROLL_OFFSET = 100;
const SEARCH_BAR_DEFAULT_TEXT = '网红打卡地 景点 酒店 美食';

class HomePage extends StatefulWidget {
  static ConfigModel configModel;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _appBarAlpha = 0;
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  GridNavModel gridNavModel;
  bool _isLoading = true;
  List<CommonModel> subNavList = [];
  SalesBoxModel salesBoxModel;

  @override
  void initState() {
    super.initState();

    ///开启日志DEBUG
    LogUtil.init(isDebug: true);

    ///拉取数据
    _handleFetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2f2),
      body: LoadingContainer(
        isLoading: _isLoading,

        ///Stack 后面元素层叠在上面
        child: Stack(
          children: <Widget>[
            MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: RefreshIndicator(
                onRefresh: _handleFetch,

                ///监听列表滚动
                child: NotificationListener(
                  onNotification: (scrollNotification) {
                    ///滚动距离是0也会触发
                    if (scrollNotification is ScrollUpdateNotification &&
                        scrollNotification.depth == 0) {
                      ///滚动而且是列表滚动的时候
                      _onScroll(scrollNotification.metrics.pixels);
                    }
                    return;
                  },

                  ///内容区域
                  child: _listView,
                ),
              ),
            ),

            ///自定义appBar
            _appBar,
          ],
        ),
      ),
    );
  }

  ///滚动改变透明度 alpha
  _onScroll(double offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    if (alpha < 0) {
      alpha = 0;
    } else if (alpha > 1) {
      alpha = 1;
    }
    setState(() {
      _appBarAlpha = alpha;
    });
  }

  ///从服务器拉取数据
  Future<Null> _handleFetch() async {
    try {
      HomeModel homeModel = await HomeDao.fetch();

      setState(() {
        HomePage.configModel = homeModel.config;
        localNavList = homeModel.localNavList;
        bannerList = homeModel.bannerList;
        gridNavModel = homeModel.gridNav;
        subNavList = homeModel.subNavList;
        salesBoxModel = homeModel.salesBox;
        _isLoading = false;
      });
      LogUtil.v(homeModel.toJson(), tag: 'home_page.json');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      LogUtil.v(e, tag: 'HomePage _handleFetch()');
    }
  }

  ///自定义AppBar,计算属性方式
  Widget get _appBar {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              ///AppBar渐变遮罩背景
              colors: [Color(0x66000000), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 40),
            height: 80.0,
            decoration: BoxDecoration(
                color: Color.fromARGB(
                    (_appBarAlpha * 255).toInt(), 255, 255, 255)),
            child: SearchBar(
              searchBarType: _appBarAlpha > 0.2
                  ? SearchBarType.homeLight
                  : SearchBarType.home,
              inputBoxClick: _jumpToSearch,
              speakButtonClick: _jumpToSpeak,
              defaultText: SEARCH_BAR_DEFAULT_TEXT,
              leftButtonClick: () {},
            ),
          ),
        ),
        Container(
          height: _appBarAlpha > 0.2 ? 0.5 : 0,
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 0.5)],
          ),
        ),
      ],
    );
  }

  ///ListView
  Widget get _listView => ListView(
        children: <Widget>[
          _banner,
          Padding(
            padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
            child: LocalNav(
              localNavList: localNavList,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: GridNav(
              gridNavModel: gridNavModel,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SubNav(
              subNavList: subNavList,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(7, 0, 7, 4),
            child: SalesBox(
              salesBoxModel: salesBoxModel,
            ),
          ),
        ],
      );

  ///banner
  Widget get _banner => Container(
        height: 160.0,
        child: Swiper(
          itemCount: bannerList.length,
          autoplay: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                CommonModel commonModel = bannerList[index];
                NavigatorUtil.push(
                    context,
                    WebView(
                      url: commonModel.url,
                      title: commonModel.title,
                      hideAppBar: commonModel.hideAppBar,
                    ));
              },
              child: Image.network(
                bannerList[index].icon,
                fit: BoxFit.fill,
              ),
            );
          },

          ///指示器
          pagination: SwiperPagination(),
        ),
      );

  void _jumpToSearch() {
    NavigatorUtil.push(
        context,
        SearchPage(
          hint: SEARCH_BAR_DEFAULT_TEXT,
          hideLeft: false,
        ));
  }

  //todo 待开发
  void _jumpToSpeak() {
  }
}
