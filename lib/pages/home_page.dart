import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_trip/dao/home_dao.dart';
import 'package:flutter_trip/model/common_model.dart';
import 'package:flutter_trip/model/config_model.dart';
import 'package:flutter_trip/model/home_model.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter_trip/utils/navigator_util.dart';
import 'package:flutter_trip/widgets/loading_container.dart';
import 'package:flutter_trip/widgets/local_nav.dart';
import 'package:flutter_trip/widgets/webview.dart';

///滚动的最大距离
const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  static ConfigModel configModel;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _appBarAlpha = 0;
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  bool _isLoading = true;

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
  //todo 组件未完成开发
  Widget get _appBar {
    return

        ///改变透明度
        Opacity(
      opacity: _appBarAlpha,
      child: Container(
        height: 80.0,
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Text('首页'),
          ),
        ),
      ),
    );
  }

  ///ListView
  Widget get _listView => ListView(
        children: <Widget>[
          _banner,
          Padding(
            padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
            child: LocalNav(localNavList: localNavList,),
          ),
          Container(
            height: 800.0,
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
}
