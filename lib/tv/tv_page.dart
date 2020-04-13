import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global_config.dart';
import '../data/cache_data.dart';
import '../utils/log_util.dart';
import '../tv/details/live_detail.dart';
import '../resource/local_storage.dart';
import '../service/http_client.dart';
import '../model/channel_model.dart';
import '../utils/string_util.dart';
import 'package:share/share.dart';
import '../config/config.dart';
import '../service/local_data_provider.dart';
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
    if (sportsChannelList[column].length < 1) {
      handleRefresh();
    }
    LogUtil.v("channelList lenght:${sportsChannelList.length}");
    setState(() {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      });
    });
    LogUtil.v("initState setState()");
  }

  @override
  Widget build(BuildContext context) {
    ClientAction ca = new ClientAction(
        200 + column, "sportChannelPage", 0, "", 0, "", 1, "bowser");
    HttpClient.actionReport(ca);
    return (sportsChannelList[column].length < 1)
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
                  itemCount: sportsChannelList[column].length,
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
    String url = sportsChannelList[column][index].playUrl;
    return new Container(
        // margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        color: GlobalConfig.cardBackgroundColor,
        child: new Column(
          children: <Widget>[
            new Container(
              width: 360,
              child: new Row(
                children: <Widget>[
                  new Text(
                      subString(
                          "    " + sportsChannelList[column][index].name, 23),
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
              width: 320,
              child: new GestureDetector(
                onTap: () {
                  bool isLogin = LocalDataProvider.getInstance().isLogin();
                  //if (isLogin != null) {
                  //  if (isLogin) {
                  if (true) {
                    if (true) {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return new LiveDetail(
                            vod: sportsChannelList[column][index]);
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
                      imageUrl: "${sportsChannelList[column][index].posterUrl}",
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
    String url = sportsChannelList[column][index].playUrl;
    return new Container(
        // margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        color: GlobalConfig.cardBackgroundColor,
        child: new Column(
          children: <Widget>[
            new Container(
              width: 360,
              child: new Row(
                children: <Widget>[
                  new Text(
                      subString(
                          "    " + sportsChannelList[column][index].name, 23),
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
              width: 320,
              child: new GestureDetector(
                onTap: () {
                  Navigator.of(context)
                      .push(new MaterialPageRoute(builder: (context) {
                    return new LiveDetail(
                        vod: sportsChannelList[column][index]);
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
                                "${sportsChannelList[column][index].posterUrl}",
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
    LogUtil.e("_handleRefresh");
    int type = 0;
    int groupId = 0;
    switch (column) {
      case 0:
        type = 1;
        break;
      case 1: //央视体育
        type = 1;
        groupId = 5;
        break;
      case 2: //国际体育
        type = 1;
        groupId = 3;
        break;
      case 3: //地方体育
        type = 1;
        groupId = 4;
        break;
      case 4: //综合推荐
        type = 0;
        groupId = 0;
        break;
      case 5: //卫视娱乐
        type = 2;
        groupId = 0;
        break;
      case 6: //CCTV
        type = 0;
        groupId = 5;
        break;
      case 7: //港台
        type = 0;
        groupId = 2;
        break;
      case 8: //国际
        type = 0;
        groupId = 3;
        break;
      default:
        break;
    }

    await HttpClient.getChannelList(type, groupId, 0, 50).then((list) {
      if (null != list) {
        sportsChannelList[column] = list.channelModelList;
        for (ChannelModel cm in sportsChannelList[column]) {
          //缓存到本地"vod_0_"为首页栏目内容
          LocalStorage.saveChannel(cm);
        }
      } else {
        LogUtil.e("fail to get channel");
        ClientLog cl = new ClientLog(
            "live_page.dart|handleRefresh()|fail to get channel ${column}",
            "error");
        HttpClient.logReport(cl);
      }
      try {
        setState(() {});
      } catch (e) {}
    });

    return sportsChannelList;
  }

  Future _getMoreData() async {
    LogUtil.e("_getMoreData()");
  }

  Future _test() async {
    LogUtil.e("_test()");
  }
}
