import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/dao/home_dao.dart';
import 'package:flutter_app/model/common_model.dart';
import 'package:flutter_app/model/home_model.dart';
import 'package:flutter_app/model/grid_nav_model.dart';
import 'package:flutter_app/model/sales_box_model.dart';
import 'package:flutter_app/widget/grid_nav.dart';
import 'package:flutter_app/widget/loading_container.dart';
import 'package:flutter_app/widget/local_nav.dart';
import 'package:flutter_app/widget/sales_box.dart';
import 'package:flutter_app/widget/sub_nav.dart';
import 'package:flutter_app/widget/webview.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

const APPBAR_SCROLL_OFFSET = 100;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double appBarAlpha = 0;
  List<CommonModel> localNavList = [];
  List<CommonModel> bannerList = [];
  List<CommonModel> subNavList = [];
  GridNavModel gridNavModel;
  SalesBoxModel salesBoxModel;
  bool _loading = true;
  _onScroll(offset) {
    double alpha = offset / APPBAR_SCROLL_OFFSET;
    setState(() {
      appBarAlpha = alpha < 0 ? 0 : (alpha > 1 ? 1 : alpha);
    });
  }

  @override
  void initState() {
    super.initState();
    _handleRefresh();
  }

  Future<Null> _handleRefresh() async {
    try {
      HomeModel model = await HomeDao.fetch();
      print(model.localNavList);
      setState(() {
        localNavList = model.localNavList;
        subNavList = model.subNavList;
        bannerList = model.bannerList;
        salesBoxModel = model.salesBox;
        gridNavModel = model.gridNav;
        _loading = false;
      });
    } catch (e) {
      print(e);
      _loading = false;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2f2fa),
      body: LoadingContainer(
          isLoading: _loading,
          child: Stack(
            children: <Widget>[
              MediaQuery.removePadding(
                //移除padding
                removeTop: true,
                context: context,
                child: RefreshIndicator(
                    onRefresh: _handleRefresh,
                    child: NotificationListener(
                      //监听所有的子元素滚动
                      onNotification: (scrollNotification) {
                        //滚动第0个元素
                        if (scrollNotification is ScrollUpdateNotification && scrollNotification.depth == 0) {
                          _onScroll(scrollNotification.metrics.pixels);
                        }
                      },
                      child: _listView,
                    )),
              ),
              _appBar,
            ],
          )),
    );
  }

  Widget get _listView {
    return ListView(
      children: <Widget>[
        _swiper,
        _Padding(LocalNav(localNavList: localNavList)),
        _Padding(GridNav(gridNavModel: gridNavModel)),
        _Padding(SubNav(subNavList: subNavList)),
        _Padding(SalesBox(salesBox: salesBoxModel)),
      ],
    );
  }

  Widget _Padding(Widget child) {
    return Padding(
      padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
      child: child,
    );
  }

  Widget get _swiper {
    return Container(
      height: 160,
      child: Swiper(
        itemCount: bannerList.length,
        autoplay: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                CommonModel model = bannerList[index];
                return WebView(
                  url: model.url,
                  statusBarColor: model.statusBarColor,
                  title: model.title,
                  hideAppBar: model.hideAppBar,
                );
              }));
            },
            child: Image.network(
              bannerList[index].icon,
              fit: BoxFit.fill,
            ),
          );
        },
        pagination: SwiperPagination(),
      ),
    );
  }

  Widget get _appBar {
    return Opacity(
      opacity: appBarAlpha,
      child: Container(
        height: 80,
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('渐变框出来了'),
          ),
        ),
      ),
    );
  }
}
