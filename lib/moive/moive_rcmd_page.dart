import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global_config.dart';
import '../data/cache_data.dart';
import '../utils/log_my_util.dart';
import '../player/live_detail.dart';
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

class TvRcmdPage extends StatefulWidget {
 // TvRcmdPage({Key key, @required this.type});
 int type=0;
  int group=0;

  @override
  _TvRcmdPageState createState() => _TvRcmdPageState(column: this.type);
}

class _TvRcmdPageState extends State<TvRcmdPage> {
  _TvRcmdPageState({Key key, @required this.column});

  ScrollController _scrollController = new ScrollController();
  int column;


  @override
  void initState() {
    super.initState();
    handleRefresh();
    LogMyUtil.v("channelList lenght:${sportsChannelList.length}");
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
    ClientAction ca=new ClientAction(200+column, "sportChannelPage", 0, "", 0, "", 1, "bowser");
    HttpClientUtils.actionReport(ca);
    return (tvChannelList[0].length<2) ? refreshButton(this):RefreshIndicator(
      onRefresh: handleRefresh,
      child: StreamBuilder(
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              // LogUtil.e("itemBuilder index:${index}");
              return itemBuilder1(context, index);
            },
            itemCount: tvChannelList[0].length,
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
    String url = tvChannelList[0][index].playUrl;
    return new Container(
        // margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        color: GlobalConfig.cardBackgroundColor,
        child: new Column(
          children: <Widget>[
            new Container(
              width: 420,
              child: new Row(
                children: <Widget>[
                  new Text(
                      StrUtils.subString("    " + tvChannelList[0][index].name, 23),
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
              width: 420,
              child: new FlatButton(
                onPressed: () {
                 // bool isLogin = LocalDataProvider.getInstance().isLogin();
                  //if (isLogin != null) {
                  //  if (isLogin) {
                  if (true) {
                    if (true) {
                      Navigator.of(context)
                          .push(new MaterialPageRoute(builder: (context) {
                        return new LiveDetail(vod: tvChannelList[0][index]);
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
                      imageUrl: "${tvChannelList[0][index].posterUrl}",
                      placeholder: (context, url) =>cachPlaceHolder(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    )
                ),
                //   margin: new EdgeInsets.only(top: 6.0, bottom: 14.0),
                //   alignment: Alignment.topLeft
              ),
            )
          ],
        ));
  }

  Future <void>handleRefresh() async {
    LogMyUtil.e("_handleRefresh");
    int type = 0;
    int groupId=0;
    switch (column) {
      case 0:
        type = 1;
        break;
      case 1://央视体育
        type = 1;
        groupId=5;
        break;
      case 2://国际体育
        type = 1;
        groupId=3;
        break;
      case 3://地方体育
        type = 1;
        groupId=4;
        break;
      case 4://综合推荐
        type = 0;
        groupId=0;
        break;
      case 5://卫视娱乐
        type = 2;
        groupId=0;
        break;
      case 6://CCTV
        type = 0;
        groupId=5;
        break;
      case 7://港台
        type = 0;
        groupId=2;
        break;
      case 8://国际
        type = 0;
        groupId=3;
        break;
      default:
        break;
    }

    await HttpClientUtils.getRcmdChannels(0, 50).then((list) {
      if (null != list) {
        tvChannelList[0] = list;
        for (ChannelModel cm in tvChannelList[0]) {
          //缓存到本地"vod_0_"为首页栏目内容
          LocalStorage.saveChannel(cm);
        }
      } else {
        LogMyUtil.e("fail to get channel");
        ClientLog cl = new ClientLog(
            "tv_rcmd_page.dart|handleRefresh()|fail to getRcmdChannels", "error");
        HttpClientUtils.logReport(cl);
      }
      this.setState(() {});
    });
  }

  Future _getMoreData() async {
    LogMyUtil.e("_getMoreData()");
  }

  Future _test() async {
    LogMyUtil.e("_test()");
  }
}
