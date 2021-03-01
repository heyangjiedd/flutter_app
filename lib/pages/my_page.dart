import 'package:flutter/material.dart';
import 'package:flutter_app/widget/webview.dart';

class MyPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<MyPage> {
  final PageController _controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: WebView(
      url: 'https://m.ctrip.com/webapp/myctrip/',
      hideAppBar: true,
      backForbid: true,
      statusBarColor: '4c5bca',
    ));
  }
}
