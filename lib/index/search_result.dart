import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../global_config.dart';
import '../service/http_client.dart';
import '../player/video_detail.dart';
import '../utils/log_my_util.dart';
import '../utils/string_util.dart';
import '../data/cache_data.dart';
import '../common/widget_common.dart';
import '../model/vod_model.dart';
import '../index/search_page.dart';
import '../common/widget_common.dart';

class SearchResult extends StatefulWidget {
  SearchResult({Key key, @required this.keyword});

  String keyword;

  @override
  _SearchResultState createState() => _SearchResultState(keyword: this.keyword);
}

class _SearchResultState extends State<SearchResult> {
  _SearchResultState({Key key, @required this.keyword});

  String keyword;
  ScrollController _scrollController = new ScrollController();
  List<VodModel> resultList = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      handleRefresh();
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
          appBar: new AppBar(
            title: barSearch(),
          ),
          body: (resultList.length < 1)
              ? refreshButton(this)
              : RefreshIndicator(
                  onRefresh: handleRefresh,
                  child: StreamBuilder(
                    //stream: _bloc.homeStream,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          //LogUtil.v("itemBuilder index:${index}");
                          return itemBuilder(context, index);
                        },
                        itemCount: resultList.length ~/ 2,
                      );
                    },
                  ),
                )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future handleRefresh() async {
    LogMyUtil.e("_handleRefresh");
    await HttpClientUtils.fuzzyQueryVod(keyword).then((list) {
      if (null != list) {
        resultList = list;
        try {
          setState(() {});
        } catch (e) {}
      }
    });
    return;
  }

  Future _getMoreData() async {
    LogMyUtil.e("_getMoreData()");
  }

  Widget itemBuilder(BuildContext context, int index) {
    double width = 150;
    return resultList.length < 1
        ? refreshButton(this)
        : Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <
                Widget>[
            new GestureDetector(
              onTap: () {
                if (null == resultList[index].vodPlayUrl ||
                    "" == resultList[index].vodPlayUrl) {
                  LogMyUtil.v("playUrl is blank");
                } else {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return new VideoDetail(vod: resultList[index]);
                  }));
                }
              },
              child: new Column(
                children: <Widget>[
                  new Container(
                    //Expanded(
                    // flex: 1,
                    // child: new AspectRatio(
                    //aspectRatio: 3.5 / 2,
                    width: width,
                    // height: 110,
                    child: new CachedNetworkImage(
                      imageUrl: "${resultList[index * 2].vodPic}",
                      placeholder: (context, url) =>
                          new CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),

                    //),
                    margin: new EdgeInsets.only(top: 10.0, bottom: 6.0),
                    // alignment: Alignment.topLeft
                  ),
                  new Container(
                    width: width,
                    child: new Row(
                      children: <Widget>[
                        new Text(StrUtils.subString(resultList[index * 2].vodName, 9),
                            style:
                                new TextStyle(color: GlobalConfig.fontColor)),
                        //new Text("演员: ${widgets[index].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                      ],
                    ),
                    padding: const EdgeInsets.only(bottom: 10.0),
                  ),
                ],
              ),
            ),
            new GestureDetector(
              onTap: () {
                if (null == resultList[index].vodPlayUrl ||
                    "" == resultList[index].vodPlayUrl) {
                  LogMyUtil.v("playUrl is blank");
                } else {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return new VideoDetail(vod: resultList[index]);
                  }));
                }
              },
              child: new Column(
                children: <Widget>[
                  new Container(
                      //Expanded(
                      // flex: 1,
                      // child: new AspectRatio(
                      //aspectRatio: 3.5 / 2,
                      width: width,
                      //height: 110,
                      child: new CachedNetworkImage(
                        imageUrl: "${resultList[index * 2 + 1].vodPic}",
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      )

                      //),
                      // margin: new EdgeInsets.only(top: 6.0, bottom: 14.0),
                      // alignment: Alignment.topLeft
                      ),
                  new Container(
                    width: width,
                    child: new Row(
                      children: <Widget>[
                        new Text(
                            StrUtils.subString(resultList[index * 2 + 1].vodName, 9),
                            style:
                                new TextStyle(color: GlobalConfig.fontColor)),
                        //new Text("演员: ${widgets[index].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                      ],
                    ),
                    padding: const EdgeInsets.only(bottom: 10.0),
                  ),
                ],
              ),
            ),
//          new FlatButton(
//            onPressed: () {
//              if (null == girlLiveList[1][index].vodPlayUrl ||
//                  "" == girlLiveList[1][index].vodPlayUrl) {
//                LogUtil.v("playUrl is blank");
//              } else {
//                Navigator.of(context)
//                    .push(new MaterialPageRoute(builder: (context) {
//                  return new VideoDetail(vod: girlLiveList[1][index]);
//                }));
//              }
//            },
//            child: new Column(
//              children: <Widget>[
//                new Container(
//                    //Expanded(
//                    // flex: 1,
//                    // child: new AspectRatio(
//                    //aspectRatio: 3.5 / 2,
//                    width: width,
//                    //height: 110,
//                    child: new CachedNetworkImage(
//                      imageUrl: "${girlLiveList[1][index * 2 + 1].vodPic}",
//                      placeholder: (context, url) =>
//                          new CircularProgressIndicator(),
//                      errorWidget: (context, url, error) =>
//                          new Icon(Icons.error),
//                    )
//
//                    //),
//                    // margin: new EdgeInsets.only(top: 6.0, bottom: 14.0),
//                    // alignment: Alignment.topLeft
//                    ),
//                new Container(
//                  width: width,
//                  child: new Row(
//                    children: <Widget>[
//                      new Text(
//                          subString(girlLiveList[1][index * 2 + 1].vodName, 9),
//                          style: new TextStyle(color: GlobalConfig.fontColor)),
//                      //new Text("演员: ${widgets[index].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
//                    ],
//                  ),
//                  padding: const EdgeInsets.only(bottom: 10.0),
//                ),
//              ],
//            ),
//          )
          ]
            // )
            );
  }

  Widget barSearch() {
    return new Container(
        height: 40,
        child: new FlatButton(
            onPressed: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new SearchPage();
              }));
            },
            child: new Row(
              children: <Widget>[
                new Container(
                  child: new Icon(
                    Icons.search,
                    size: 18.0,
                  ),
                  margin: const EdgeInsets.only(right: 26.0),
                ),
                new Expanded(
                    child: new Container(
                  child: new Text(this.keyword),
                )),
                new Container(
                  child: new FlatButton(
                    onPressed: () {},
                    child: new Icon(Icons.find_in_page, size: 18.0),
                  ),
                  width: 40.0,
                ),
              ],
            )),
        decoration: new BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
            color: GlobalConfig.searchBackgroundColor));
  }
}
