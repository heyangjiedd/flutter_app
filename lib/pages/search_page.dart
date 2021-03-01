import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/dao/search_dao.dart';
import 'package:flutter_app/model/search_model.dart';
import 'package:flutter_app/widget/search_bar.dart';
import 'package:flutter_app/widget/webview.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// final prefs = await SharedPreferences.getInstance();
const URL = 'https://m.ctrip.com/restapi/h5api/searchapp/search?source=mobileweb&action=autocomplete&contentType=json&keyword=';
const TYPES = ['channelgroup', 'gs', 'plane', 'train', 'cruise', 'district', 'food', 'hotel', 'huodong', 'shop', 'sight', 'ticket', 'travelgroup'];

class SearchPage extends StatefulWidget {
  final bool hideLeft;
  final String searchUrl;
  final String keyword;
  final String hint;

  const SearchPage({Key key, this.hideLeft, this.searchUrl = URL, this.keyword, this.hint}) : super(key: key);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String keyWord;
  SearchModel searchModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(),
        body: Column(
      children: <Widget>[
        _appBar(),
        MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: searchModel?.data?.length ?? 0,
                  itemBuilder: (BuildContext context, int position) {
                    return _item(position);
                  },
                )))
      ],
    ));
  }

  _item(int position) {
    if (searchModel == null || searchModel.data == null) return null;
    SearchItem searchItem = searchModel.data[position];
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return WebView(
            url: searchItem.url,
            title: '详情',
          );
        }));
      },
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(width: 0.3, color: Colors.grey))),
        child: Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(1),
              child: Image(
                height: 26,
                width: 26,
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
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  _title(SearchItem item) {
    if (item == null) return null;
    List<TextSpan> spans = [];
    spans.addAll(_keywordTextSpans(item.word, searchModel.keyword));
    spans.add(TextSpan(text: ' ' + (item.districtname ?? '' + ' ' + (item.zonename ?? '')), style: TextStyle(fontSize: 16, color: Colors.grey)));
    return RichText(text: TextSpan(children: spans));
  }

  _subTitle(SearchItem item) {
    return RichText(
        text: TextSpan(children: <TextSpan>[
      TextSpan(text: item.price ?? '', style: TextStyle(fontSize: 16, color: Colors.orange)),
      TextSpan(text: ' ' + (item.type ?? ''), style: TextStyle(fontSize: 12, color: Colors.grey)),
    ]));
  }

  _keywordTextSpans(String word, String keyword) {
    List<TextSpan> spans = [];
    if (word == null || word.length == 0) return spans;
    List<String> arr = word.split(keyWord);
    TextStyle normalStyle = TextStyle(fontSize: 16, color: Colors.black87);
    TextStyle keywordStyle = TextStyle(fontSize: 16, color: Colors.orange);
    for (int i = 0; i < arr.length; i++) {
      if ((i + 1) % 2 == 0) {
        spans.add(TextSpan(text: keyWord, style: keywordStyle));
      }
      String val = arr[i];
      if (val != null && val.length > 0) {
        spans.add(TextSpan(text: val, style: normalStyle));
      }
    }
    return spans;
  }

  _appBar() {
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0x66000000), Colors.transparent], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
          child: Container(
            padding: EdgeInsets.only(top: 20),
            height: 80,
            decoration: BoxDecoration(color: Colors.white),
            child: SearchBar(
              hideLeft: widget.hideLeft,
              defaultText: widget.keyword,
              hint: widget.hint,
              leftButtonClick: () {
                Navigator.pop(context);
              },
              onChanged: _onTextChange,
            ),
          ),
        )
      ],
    );
  }

  _onTextChange(text) {
    keyWord = text;
    if (text.length == 0) {
      setState(() {
        searchModel = null;
      });
      return;
    }
    SearchDao.fetch(widget.searchUrl, text).then((SearchModel model) {
      if (keyWord == model.keyword) {
        setState(() {
          searchModel = model;
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  _typeImage(String type) {
    if (type == null) return 'images/type_travelgroup.png';
    String path = 'travelgroup';
    for (final val in TYPES) {
      if (type.contains(val)) {
        path = val;
        break;
      }
    }
    return 'images/type_${path}.png';
  }
}
