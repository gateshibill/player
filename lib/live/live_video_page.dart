import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global_config.dart';
import '../data/cache_data.dart';
import '../utils/log_my_util.dart';
import 'package:intl/intl.dart';
import '../resource/local_storage.dart';
import '../service/http_client.dart';
import '../player/anchor_player.dart';
import '../utils/string_util.dart';
import '../my/login/login_page.dart';
import '../model/client_action.dart';
import '../common/widget_common.dart';
import '../model/anchor_model.dart';

class LiveVideoPage extends StatefulWidget {
  LiveVideoPage({Key key, @required this.column});

  int column;

  @override
  _LiveVideoPageState createState() => _LiveVideoPageState(column: this.column);
}

class _LiveVideoPageState extends State<LiveVideoPage> {
  _LiveVideoPageState({Key key, @required this.column});

  ScrollController _scrollController = new ScrollController();
  int column;
  int page = 1;

  @override
  void initState() {
    super.initState();
    handleRefresh();
    LogMyUtil.v("girlLiveList lenght:${movieList.length}");
    setState(() {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      });
    });
    LogMyUtil.v("initState setState()");
  }

  @override
  Widget build(BuildContext context) {
    ClientAction ca =
        new ClientAction(500 + column, "live_video", 0, "", 0, "", 1, "bowser");
    HttpClient.actionReport(ca);
    return (anchorList.length < 1)
        ? refreshButton(this)
        : RefreshIndicator(
            onRefresh: handleRefresh,
            child: StreamBuilder(
              builder: (context, snapshot) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    // LogUtil.e("itemBuilder index:${index}");
                    return itemBuilder(context, index);
                  },
                  itemCount: anchorList.length ~/ 2,
                  controller: _scrollController,
                );
              },
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  Widget itemBuilder(BuildContext context, int index) {
    double picWidth = 160;
    return new Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Container(
              child: new GestureDetector(
            onTap: () {
              if (null == anchorList[index * 2].playUrl ||
                  "" == anchorList[index * 2].playUrl) {
                LogMyUtil.v("playUrl is blank");
              } else {
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                  return new AnchorPlayer(vod: anchorList[index * 2]);
                  ;
                }));
              }
            },
            child: new Column(
              children: <Widget>[
                new Stack(alignment: Alignment.center, children: <Widget>[
                  new Container(
                    //Expanded(
                    // flex: 1,
                    // child: new AspectRatio(
                    //aspectRatio: 3.5 / 2,
                    width: picWidth,
                    // height: 110,
                    child: new CachedNetworkImage(
                      imageUrl: "${anchorList[index * 2].posterUrl}",
                      placeholder: (context, url) => cachPlaceHolder(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),

                    //),
                    margin: new EdgeInsets.only(top: 6.0, bottom: 0.0),
                    // alignment: Alignment.topLeft
                  ),
                  Positioned(
                      child: Image.asset(
                    "assets/ad_play1.png",
                    width: 30.0,
                  ))
                ]),
                new Container(
                  width: picWidth,
                  child: new Row(
                    children: <Widget>[
                      new Text(subString(anchorList[index * 2].name, 9),
                          style: new TextStyle(color: GlobalConfig.fontColor)),
                      //new Text("演员: ${widgets[index].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                    ],
                  ),
                  padding: const EdgeInsets.only(bottom: 2.0),
                ),
              ],
            ),
          )),
          new Container(
              child: GestureDetector(
            onTap: () {
              if (null == anchorList[index * 2 + 1].playUrl ||
                  "" == anchorList[index * 2 + 1].playUrl) {
                LogMyUtil.v("playUrl is blank");
              } else {
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                  return new AnchorPlayer(vod: anchorList[index * 2 + 1]);
                  ;
                }));
              }
            },
            child: new Column(
              children: <Widget>[
                new Stack(alignment: Alignment.center, children: <Widget>[
                  new Container(
                    //Expanded(
                    // flex: 1,
                    // child: new AspectRatio(
                    //aspectRatio: 3.5 / 2,
                    width: picWidth,
                    //height: 110,

                    child: new CachedNetworkImage(
                      imageUrl: "${anchorList[index * 2 + 1].posterUrl}",
                      placeholder: (context, url) => cachPlaceHolder(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    ),

                    //),
                    margin: new EdgeInsets.only(top: 6.0, bottom: 0.0),
                    // alignment: Alignment.topLeft
                  ),
                  Positioned(
                      child: Image.asset(
                    "assets/ad_play1.png",
                    width: 30.0,
                  ))
                ]),
                new Container(
                  width: picWidth,
                  child: new Row(
                    children: <Widget>[
                      new Text(subString(anchorList[index * 2 + 1].name, 9),
                          style: new TextStyle(color: GlobalConfig.fontColor)),
                      //new Text("演员: ${widgets[index].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                    ],
                  ),
                  padding: const EdgeInsets.only(bottom: 2.0),
                ),
              ],
            ),
          ))
        ]
        // )
        );
  }

  Future handleRefresh() async {
    await HttpClient.getAnchors(0).then((list) {
      if (null != list) {
        anchorList = list;
        if (anchorList != null && anchorList.length > 0) {
          page = 1;
          try {
            setState(() {});
          } catch (e) {}
        }
      } else {
        LogMyUtil.e("fail to get column vod");
      }
    });
    return;
  }

  Future _getMoreData() async {
    LogMyUtil.e("_getMoreData()");
    await HttpClient.getAnchors(page).then((list) {
      if (null != list) {
        List<AnchorModel> tmpList = list;
        if (tmpList != null && tmpList.length > 0) {
          anchorList.addAll(tmpList);
          page = page + 1;
          try {
            setState(() {});
          } catch (e) {}
        }
      } else {
        LogMyUtil.e("fail to get column vod");
      }
    });
    return;
  }
}
