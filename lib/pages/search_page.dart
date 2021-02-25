import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// final prefs = await SharedPreferences.getInstance();
class SearchPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<SearchPage> {
  final PageController _controller = PageController(initialPage: 0);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Text('搜索'),
    ));
  }
}
