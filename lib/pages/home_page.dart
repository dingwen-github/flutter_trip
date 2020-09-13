import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

///滚动的最大距离
const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List _imageUrls = [
    'https://aecpm.alicdn.com/simba/img/TB1bL69LFXXXXcFXXXXSutbFXXX.jpg',
    'https://gw.alicdn.com/tfs/TB1fV8kfIieb18jSZFvXXaI3FXa-520-280.jpg',
    'https://aecpm.alicdn.com/simba/img/TB1lUZLJVXXXXXtXFXXSutbFXXX.jpg',
    'https://aecpm.alicdn.com/simba/img/TB1bL69LFXXXXcFXXXXSutbFXXX.jpg',
    'https://gw.alicdn.com/tfs/TB1cqPvUAL0gK0jSZFAXXcA9pXa-520-280.jpg'
  ];
  double _appBarAlpha = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: true,
          context: context,

          ///Stack 后面元素层叠在上面
          child: Stack(
            children: <Widget>[
              ///监听列表滚动
              NotificationListener(
                onNotification: (scrollNotification) {
                  //滚动距离是0也会触发
                  if (scrollNotification is ScrollUpdateNotification &&
                      scrollNotification.depth == 0) {
                    //滚动而且是列表滚动的时候
                    _onScroll(scrollNotification.metrics.pixels);
                  }
                },
                child: ListView(
                  children: <Widget>[
                    Container(
                      height: 160.0,
                      child: Swiper(
                        itemCount: _imageUrls.length,
                        autoplay: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Image.network(_imageUrls[index],
                              fit: BoxFit.fill);
                        },

                        ///指示器
                        pagination: SwiperPagination(),
                      ),
                    ),
                    Container(
                      height: 800.0,
                    ),
                  ],
                ),
              ),

              ///改变透明度
              ///自定义appBar
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
              ),
            ],
          )),
    );
  }

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
}
