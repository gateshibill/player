import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global_config.dart';
import '../data/cache_data.dart';
import '../utils/log_my_util.dart';
import './details/live_detail.dart';
import '../service/local_storage.dart';
import '../service/http_client.dart';
import '../model/channel_model.dart';
import '../utils/string_util.dart';
import 'package:share/share.dart';
import '../config/config.dart';

import '../my/login/login_page.dart';
import '../model/client_action.dart';
import '../common/widget_common.dart';
import '../model/client_log.dart';
import '../common/widget_common.dart';

class TVPage extends StatefulWidget {
  TVPage({Key key, @required this.type});

  int type;
  int group;

  @override
  _TVPageState createState() => _TVPageState(column: this.type);
}

class _TVPageState extends State<TVPage> {
  _TVPageState({Key key, @required this.column});

  ScrollController _scrollController = new ScrollController();
  int column;

  @override
  void initState() {
    super.initState();
    if (tvChannelList[column].length < 1) {
      handleRefresh();
    }
    LogMyUtil.v("channelList lenght:${tvChannelList.length}");
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
    ClientAction ca = new ClientAction(
        200 + column, "sportChannelPage", 0, "", 0, "", 1, "bowser");
    HttpClientUtils.actionReport(ca);
    return (tvChannelList[column].length < 1)
        ? refreshButton(this)
        : RefreshIndicator(
            onRefresh: handleRefresh,
            child: StreamBuilder(
              builder: (context, snapshot) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    // LogUtil.e("itemBuilder index:${index}");
                    return itemPlayerBuilder(context, index);
                  },
                  itemCount: tvChannelList[column].length,
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

  Widget itemBuilder1(BuildContext context, int index) {
    String url = tvChannelList[column][index].playUrl;
    return new Container(
        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        color: GlobalConfig.cardBackgroundColor,
        child: new Column(
          children: <Widget>[
            new Container(
             // width: 400,
              child: new Row(
                children: <Widget>[
                  new Text(
                      StrUtils.subString(
                          "    " + tvChannelList[column][index].name, 23),
                      style: new TextStyle(color: GlobalConfig.fontColor)),
                  new Expanded(
                    child: new Text("       "),
                  ),
                  new Expanded(
                    child: new Text("   "),
                  ),
                  new Expanded(
                    child: new Text("   "),
                  ),
                  new Expanded(
                    child: new Text("   "),
                  ),
                  new Expanded(
                      child: new FlatButton(
                    onPressed: () {
                      Share.share('live&video\n $HOME_URL');
                    },
                    child: new Icon(Icons.share, color: Colors.white),
                  )),
                ],
              ),
              padding: const EdgeInsets.only(top: 10.0),
            ),
            new Container(
              //width: 400,
              child: new GestureDetector(
                onTap: () {
                //  bool isLogin = LocalDataProvider.getInstance().isLogin();
                  //if (isLogin != null) {
                  //  if (isLogin) {
                  if (true) {
                    if (true) {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return new LiveDetail(
                            vod: tvChannelList[column][index],context: context);
                      }));
                    } else {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return new LoginPage();
                      }));
                    }
                  } else {
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new LoginPage();
                    }));
                  }
                },
                child: new AspectRatio(
                    aspectRatio: 3.5 / 2,
                    child: new CachedNetworkImage(
                      imageUrl: "${tvChannelList[column][index].posterUrl}",
                      placeholder: (context, url) => cachPlaceHolder(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    )),
                //   margin: new EdgeInsets.only(top: 6.0, bottom: 14.0),
                //   alignment: Alignment.topLeft
              ),
            )
          ],
        ));
  }

  Widget itemPlayerBuilder(BuildContext context, int index) {
    String url = tvChannelList[column][index].playUrl;
    return new Container(
        // margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        color: GlobalConfig.cardBackgroundColor,
        child: new Column(
          children: <Widget>[
            new Container(
              //width: 360,
              child: new Row(
                children: <Widget>[
                  new Text(
                      StrUtils.subString(
                          "    " + tvChannelList[column][index].name, 23),
                      style: new TextStyle(color: GlobalConfig.fontColor)),
                  new Expanded(
                    child: new Text("       "),
                  ),
                  new Expanded(
                    child: new Text("   "),
                  ),
                  new Expanded(
                    child: new Text("   "),
                  ),
                  new Expanded(
                    child: new Text("   "),
                  ),
                  new Expanded(
                      child: new FlatButton(
                    onPressed: () {
                      Share.share('live&video\n $HOME_URL');
                    },
                    child:
                        new Icon(Icons.share, color: Colors.black45, size: 20),
                  )),
                ],
              ),
              padding: const EdgeInsets.only(top: 10.0),
            ),
            new Container(
            //  width: 320,
              child: new GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                        currentPlayMedia=tvChannelList[column][index];
                    return new LiveDetail(
                        vod: tvChannelList[column][index],context: context);
                  }));
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      child: new AspectRatio(
                          aspectRatio: 3.5 / 2,
                          child: new CachedNetworkImage(
                            imageUrl:
                                "${tvChannelList[column][index].posterUrl}",
                            placeholder: (context, url) => cachPlaceHolder(),
                            errorWidget: (context, url, error) =>
                                new Icon(Icons.error),
                          )),
                      // color: Colors.red,
                    ),
                    Positioned(
                        // child: Icon(Icons.play_circle_outline),
                        child: Image.asset(
                      "assets/play1.png",
                      width: 45.0,
                    )),
                  ],
                ),

                //   margin: new EdgeInsets.only(top: 6.0, bottom: 14.0),
                //   alignment: Alignment.topLeft
              ),
            )
          ],
        ));
  }

  Future handleRefresh() async {
    LogMyUtil.e("_handleRefresh");
    HttpClientUtils.init();
  }

  Future _getMoreData() async {
    LogMyUtil.e("_getMoreData()");
  }
}
