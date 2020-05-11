import 'package:flutter/material.dart';
import '../global_config.dart';
import '../model/client_action.dart';
import '../service/http_client.dart';
import '../service/http_client.dart';
import './search_result.dart';
import '../data/cache_data.dart';

class SearchPage extends StatefulWidget {
  @override
  SearchPageState createState() => new SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  TextEditingController _editController = TextEditingController();

  Widget searchInput() {
    return new Container(
      child: new Row(
        children: <Widget>[
          new Container(
            child: new FlatButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: new Icon(Icons.arrow_back, color: GlobalConfig.fontColor),
              label: new Text(""),
            ),
            width: 60.0,
          ),
          new Expanded(
            child: new TextField(
              controller: _editController,
              autofocus: true,
              decoration: new InputDecoration.collapsed(
                  hintText: "search",
                  hintStyle: new TextStyle(color: GlobalConfig.fontColor)),
              onSubmitted: (s) {
                // 点击确定按钮时候会调用
                String keyword = _editController.value.text.trim();
                searchVodKeyWordSet.add(keyword);
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                  return new SearchResult(keyword: keyword);
                }));
              },
            ),
          )
        ],
      ),
      decoration: new BoxDecoration(
          borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
          color: GlobalConfig.searchBackgroundColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    ClientAction ca =
        new ClientAction(110, "research", 0, "", 0, "", 1, "bowser");
    HttpClientUtils.actionReport(ca);

    return new MaterialApp(
        theme: GlobalConfig.themeData,
        home: new Scaffold(
            appBar: new AppBar(
              title: searchInput(),
            ),
            body: new SingleChildScrollView(
              child: new Column(
                children: <Widget>[
                  new Container(
                    child: new Text("",
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 2.0)),
                    margin: const EdgeInsets.only(left: 16.0, bottom: 16.0),
                    alignment: Alignment.topLeft,
                  ),
//                  new Container(
//                    child: new GestureDetector(
//                      onTap: () {
//                        Navigator.of(context)
//                            .push(new MaterialPageRoute(builder: (context) {
//                          return new SearchResult(keyword: searchHistoryList[0]);
//                        }));
//                      },
//                      child: new Row(
//                        children: <Widget>[
//                          new Container(
//                            child: new Icon(Icons.access_time,
//                                color: GlobalConfig.fontColor, size: 16.0),
//                            margin: const EdgeInsets.only(right: 12.0),
//                          ),
//                          new Expanded(
//                            child: new Container(
//                              child: new Text(
//                                searchHistoryList[0],
//                                style: new TextStyle(
//                                    color: GlobalConfig.fontColor,
//                                    fontSize: 14.0),
//                              ),
//                            ),
//                          ),
////                      new Container(
////                        child: new Icon(Icons.clear, color: GlobalConfig.fontColor, size: 16.0),
////                      )
//                        ],
//                      ),
//                    ),
//                    margin: const EdgeInsets.only(
//                        left: 16.0, right: 16.0, bottom: 10.0),
//                    padding: const EdgeInsets.only(bottom: 10.0),
//                    decoration: new BoxDecoration(
//                        border: new BorderDirectional(
//                            bottom: new BorderSide(
//                                color: GlobalConfig.dark == true
//                                    ? Colors.white12
//                                    : Colors.black12))),
//                  ),
//                  new Container(
//                    child: new GestureDetector(
//                      onTap: () {
//                        Navigator.of(context)
//                            .push(new MaterialPageRoute(builder: (context) {
//                          return new SearchResult(keyword: "权力");
//                        }));
//                      },
//                      child: new Row(
//                        children: <Widget>[
//                          new Container(
//                            child: new Icon(Icons.access_time,
//                                color: GlobalConfig.fontColor, size: 16.0),
//                            margin: const EdgeInsets.only(right: 12.0),
//                          ),
//                          new Expanded(
//                            child: new Container(
//                              child: new Text(
//                                "权力",
//                                style: new TextStyle(
//                                    color: GlobalConfig.fontColor,
//                                    fontSize: 14.0),
//                              ),
//                            ),
//                          ),
////                      new Container(
////                        child: new Icon(Icons.clear, color: GlobalConfig.fontColor, size: 16.0),
////                      )
//                        ],
//                      ),
//                    ),
//                    margin: const EdgeInsets.only(
//                        left: 16.0, right: 16.0, bottom: 10.0),
//                    padding: const EdgeInsets.only(bottom: 10.0),
//                    decoration: new BoxDecoration(
//                        border: new BorderDirectional(
//                            bottom: new BorderSide(
//                                color: GlobalConfig.dark == true
//                                    ? Colors.white12
//                                    : Colors.black12))),
//                  ),
//                  new Container(
//                    child: new GestureDetector(
//                      onTap: () {
//                        Navigator.of(context)
//                            .push(new MaterialPageRoute(builder: (context) {
//                          return new SearchResult(keyword: "玉女");
//                        }));
//                      },
//                      child: new Row(
//                        children: <Widget>[
//                          new Container(
//                            child: new Icon(Icons.access_time,
//                                color: GlobalConfig.fontColor, size: 16.0),
//                            margin: const EdgeInsets.only(right: 12.0),
//                          ),
//                          new Expanded(
//                            child: new Container(
//                              child: new Text(
//                                "玉女",
//                                style: new TextStyle(
//                                    color: GlobalConfig.fontColor,
//                                    fontSize: 14.0),
//                              ),
//                            ),
//                          ),
////                      new Container(
////                        child: new Icon(Icons.clear, color: GlobalConfig.fontColor, size: 16.0),
////                      )
//                        ],
//                      ),
//                    ),
//                    margin: const EdgeInsets.only(
//                        left: 16.0, right: 16.0, bottom: 10.0),
//                    padding: const EdgeInsets.only(bottom: 10.0),
//                    decoration: new BoxDecoration(
//                        border: new BorderDirectional(
//                            bottom: new BorderSide(
//                                color: GlobalConfig.dark == true
//                                    ? Colors.white12
//                                    : Colors.black12))),
//                  ),
                  cardList()
                ],
              ),
            )));
  }

  Widget cardList() {
    //int index = homeVodList.length ~/ 2+1;
    return RefreshIndicator(
      //onRefresh: handleRefresh,
      child: StreamBuilder(
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return itemBuilder1(context, index);
            },
            itemCount: searchVodKeyWordSet.length,
          );
        },
      ),
    );
  }

  Widget itemBuilder1(BuildContext context, int index) {
   return new Container(
      child: new GestureDetector(
        onTap: () {
          Navigator.of(context)
              .push(new MaterialPageRoute(builder: (context) {
            return new SearchResult(keyword: searchVodKeyWordSet.toList().reversed.toList()[index]);
          }));
        },
        child: new Row(
          children: <Widget>[
            new Container(
              child: new Icon(Icons.access_time,
                  color: GlobalConfig.fontColor, size: 16.0),
              margin: const EdgeInsets.only(right: 12.0),
            ),
            new Expanded(
              child: new Container(
                child: new Text(
                  searchVodKeyWordSet.toList().reversed.toList().[index],
                  style: new TextStyle(
                      color: GlobalConfig.fontColor,
                      fontSize: 14.0),
                ),
              ),
            ),
//                      new Container(
//                        child: new Icon(Icons.clear, color: GlobalConfig.fontColor, size: 16.0),
//                      )
          ],
        ),
      ),
      margin: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 10.0),
      padding: const EdgeInsets.only(bottom: 10.0),
      decoration: new BoxDecoration(
          border: new BorderDirectional(
              bottom: new BorderSide(
                  color: GlobalConfig.dark == true
                      ? Colors.white12
                      : Colors.black12))),
    );
  }

}
