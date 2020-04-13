import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../global_config.dart';
import '../resource/local_storage.dart';
import '../player/video_detail.dart';
import '../service/http_client.dart';
import '../model/vod_model.dart';
import '../data/cache_data.dart';
import '../utils/log_util.dart';
import 'package:intl/intl.dart';
import '../utils/string_util.dart';
import '../common/widget_common.dart';
import '../model/client_action.dart';
import '../model/client_log.dart';
import '../program/details/program_detail.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class ProgramVideoPage extends StatefulWidget {
  ProgramVideoPage({Key key, @required this.vodList, @required this.type});

  List<VodModel> vodList = [];
  int type;

  @override
  _ProgramVideoPageState createState() =>
      _ProgramVideoPageState(type: this.type, vodList: this.vodList);
}

class _ProgramVideoPageState extends State<ProgramVideoPage> {
  _ProgramVideoPageState(
      {Key key, @required this.vodList, Key key2, @required this.type});

  List<VodModel> vodList = [];
  List<IjkMediaController> mediaControllerList = [];
  List<bool> statusList = [];
  int type;

  @override
  void initState() {
    int index = type % 1000 - 1;//待优化
    vodList = sportsPlaybackVodList[index];
    super.initState();
    if (vodList.length == 0) {
      setState(() {
        handleRefresh();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ClientAction ca =
        new ClientAction(400 + type, "contest", 0, "", 0, "", 1, "bowser");
    HttpClient.actionReport(ca);

    return (vodList.length < 1)
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
                  itemCount: vodList.length,
                );
              },
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
    for (IjkMediaController mc in this.mediaControllerList) {
      mc.dispose();
    }
  }

  Widget hot() {
    return new Container(
        //height: 100.0,
        margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        color: GlobalConfig.cardBackgroundColor,
        child: currentEventProgramlist.length == 0
            ? new Text("精彩节目即将播出", style: new TextStyle(color: Colors.red))
            : new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    program(0),
                    (currentEventProgramlist.length > 1
                        ? program(1)
                        : new Container()),
                    currentEventProgramlist.length > 2
                        ? program(2)
                        : new Container(),
                    currentEventProgramlist.length > 3
                        ? program(3)
                        : new Container(),
                    currentEventProgramlist.length > 4
                        ? program(4)
                        : new Container(),
                    currentEventProgramlist.length > 5
                        ? program(5)
                        : new Container()
                  ]));
  }

  Widget program(int index) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new ProgramDetail(pm: currentEventProgramlist[index]);
              }));
            },
            child: new Row(
              children: <Widget>[
                new Container(
                  margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  //日期
                  width: MediaQuery.of(context).size.width / 4,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                          (DateFormat('kk:mm').format(
                              currentEventProgramlist[index].startTime)),
                          style: new TextStyle(color: Colors.red)),
//                    new Text("",
//                        style: new TextStyle(color: GlobalConfig.fontColor)),
                      new Text(currentEventProgramlist[index].name,
                          style: new TextStyle(color: Colors.red)),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 10.0),
                ),
                new Container(padding: const EdgeInsets.only(top: 10.0)),
                new Container(
                  //team
                  width: MediaQuery.of(context).size.width / 2.8,
//                child:new Text(programList[index].name,
//                    style: new TextStyle(color: colorText)),
                  child: new Column(
                    children: <Widget>[
                      new Text(currentEventProgramlist[index].name,
                          style: new TextStyle(color: Colors.red)),
                      new Text("",
//                            null != programList[index].guestTeamScore &&
//                                programList[index].guestTeamScore > -1)
//                            ? programList[index].guestTeamScore.toString()
//                            : "",
                          style: new TextStyle(color: Colors.red))
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 10.0),
                ),
                new Container(
                  //tip
                  width: MediaQuery.of(context).size.width / 3.3,
                  child: new Column(
                    children: <Widget>[
                      new Text("正在播出", style: new TextStyle(color: Colors.red)),
//                    new Text(programList[index].guestTeam,
//                        style: new TextStyle(color: GlobalConfig.fontColor)),
                    ],
                  ),
                  padding: const EdgeInsets.only(top: 10.0),
                ),
              ],
            ),
          ),
        ]);
  }

  Widget itemBuilder(BuildContext context, int index) {
//    int index2 = index - 1;
    return (index < 1 && this.type == 1002
        ? new Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[hot(), itemBuilder1(context, index)])
        : (homeVodList.length < 1)
            ? refreshButton(this)
            : itemBuilder1(context, index));
  }

  Widget itemBuilder1(BuildContext context, int index) {
    print(" vodList[index].vodTime:${vodList[index].vodTime}");
    IjkMediaController mediaController = IjkMediaController();
    this.mediaControllerList.add(mediaController);
    bool status = false;
    statusList.add(status);
    return new Container(
        // margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        color: GlobalConfig.cardBackgroundColor,
        child: new GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new VideoDetail(vod: vodList[index]);
            }));

//            setState(() {
//              if (statusList[index]) {//处于播放状态
//                this.mediaControllerList[index].reset();
//                statusList[index]=false;
//              } else {
//                for (IjkMediaController mc in this.mediaControllerList) {
//                  mc.reset();
//                }
//                for (bool s in this.statusList) {
//                  s = false;
//                }
//                statusList[index] = true;
//                mediaController.setNetworkDataSource(vodList[index].getPlayUrl(),
//                    autoPlay: true);
//                //  play(mediaController, vodList[index].vodPic);
//              }
//            });
          },
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Text(subString(vodList[index].vodName, 28),
                        maxLines: 2,
                        // softWrap: true,
                        style: new TextStyle(color: GlobalConfig.fontColor)),
                    //new Text("演员: ${widgets[index].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                  ],
                ),
                margin: new EdgeInsets.only(left: 10.0, bottom: 4.0),
                padding: const EdgeInsets.only(top: 10.0),
              ),
              new Stack(alignment: Alignment.center, children: <Widget>[
                new Container(
                    child: new AspectRatio(
                        aspectRatio: 3.5 / 2,
                        child: new CachedNetworkImage(
                          imageUrl: "${vodList[index].vodPic}",
                          placeholder: (context, url) => cachPlaceHolder(),
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                        )),
                  //  child: play(mediaController, vodList[index].vodPic),
                    margin: new EdgeInsets.only(top: 10.0, bottom: 4.0),
                    alignment: Alignment.topLeft),
                Positioned(
                    // child: Icon(Icons.play_circle_outline),
                    child: Offstage(
                        offstage: false,
                        child: Image.asset(
                          "assets/play1.png",
                          width: 45.0,
                        )
                    )
                ),
              ]),
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Text(
                        //'${vodList[index].vodTime}',
                        DateFormat('yyyy-MM-dd kk:mm').format(
                            new DateTime.fromMicrosecondsSinceEpoch(
                                vodList[index].vodTime * 1000 * 1000)),
                        style: new TextStyle(color: GlobalConfig.fontColor),
                        textAlign: TextAlign.center),
                    new Text("         播放次数：${vodList[index].vodHits}",
                        style: new TextStyle(color: GlobalConfig.fontColor),
                        textAlign: TextAlign.right)
                  ],
                ),
                margin: new EdgeInsets.only(left: 10.0, bottom: 4.0),
              )
            ],
          ),
        ));
  }

  Future handleRefresh() async {
    LogUtil.e("_handleRefresh");
    await HttpClient.getHotPrograms().then((list) {
      if (null != list) {
        currentEventProgramlist = list.programModelList;
      }
      LogUtil.e(
          "currentEventProgramlist length:${currentEventProgramlist.length}");
      try {
        setState(() {});
      } catch (e) {}
    });
    await HttpClient.getSportsVodList(type).then((list) {
      int index = type % 1000 - 1; //临时方案，这样不好
      if (null != list) {
        sportsPlaybackVodList[index] = list.vodModelList;
        vodList = sportsPlaybackVodList[index];
        try {
          setState(() {});
        } catch (e) {}
        for (VodModel m in sportsPlaybackVodList[index]) {
          //缓存到本地"vod_0_"为首页栏目内容
          LocalStorage.saveVod(m, column: type);
        }
      } else {
        LogUtil.e("fail to get column vod");

        ClientLog cl = new ClientLog(
            "program_video_page.dart|handleRefresh()|fail to get column ${type} vod",
            "error");
        HttpClient.logReport(cl);
      }
    });
    return;
  }

  Future _getMoreData() async {
    LogUtil.e("_getMoreData()");
  }
}
