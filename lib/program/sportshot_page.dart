import 'package:flutter/material.dart';
import '../service/http_client.dart';
import '../global_config.dart';
import '../data/cache_data.dart';
import '../utils/log_my_util.dart';
import '../resource/local_storage.dart';
import '../common/widget_common.dart';
import '../model/program_model.dart';
import '../program/details/program_detail.dart';
import '../model/client_action.dart';
import 'package:intl/intl.dart';
import '../utils/string_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:share/share.dart';
import '../config/config.dart';
import '../common/widget_common.dart';

class SportshotPage extends StatefulWidget {
  SportshotPage({Key key, @required this.day, @required this.name});

  String name;
  int day = 0;

  @override
  _SportshotPageState createState() =>
      _SportshotPageState(day: this.day, name: this.name);
}

class _SportshotPageState extends State<SportshotPage> {
  _SportshotPageState({Key key, @required this.day, @required this.name});

  ScrollController _scrollController = new ScrollController();
  String name;
  int day = 0;
  String dateStr = "";
  int page = 1;

  @override
  void initState() {
    super.initState();
    print("day:$day");
    if (null == leagueProgramList || 0 == leagueProgramList.length) {
      handleRefresh();
    }
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
        new ClientAction(300 + day, "leaguePage", 0, "", 0, "", 1, "browse");
    HttpClient.actionReport(ca);

    return new MaterialApp(
        theme: GlobalConfig.themeData,
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
//          appBar: new AppBar(
//            centerTitle: true,
//            title: new Text(name),
//          ),
          body: (leagueProgramList.length < 2)
              ? refreshButton(this)
              : RefreshIndicator(
                  onRefresh: handleRefresh,
                  child: StreamBuilder(
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          return itemBuilderContainer(context, index);
                        },
                        itemCount: leagueProgramList.length,
                        controller: _scrollController,
                      );
                    },
                  ),
                ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }

  Widget itemBuilder1(BuildContext context, int index) {
    DateTime date = new DateTime.now();
    DateTime startTime = leagueProgramList[index].startTime;
    DateTime endTime = leagueProgramList[index].endTime;
    String textStatus = "欢迎收看";
    String text1 = "预约";
    String text2 = "比赛投注";
    Color colorText = GlobalConfig.fontColor;
    if (startTime.isBefore(date) && endTime.isAfter(date)) {
      textStatus = "正在播出";
      text1 = "点击收看";
      text2 = "立即下注";
      colorText = Colors.red;
    } else if (startTime.isAfter(date)) {
      textStatus = "预约收看";
      text1 = "预约";
      colorText = Colors.black;
    } else if (endTime.isBefore(date)) {
      text1 = "回看";
      textStatus = "精彩回看";
      text2 = "精彩回看";
    }

    if (null == leagueProgramList[index].playUrl ||
        leagueProgramList[index].playUrl.length < 1) {
      //textStatus="";
    }

    bool isGame = true;
    if (leagueProgramList[index].homeTeam == null ||
        leagueProgramList[index].homeTeam.length < 1) {
      isGame = false;
    }

    return new Container(
        margin: const EdgeInsets.only(top: .0, bottom: 5.0),
        // color: GlobalConfig.cardBackgroundColor,

        child: new FlatButton(
          onPressed: () {
            if (null == leagueProgramList[index].playUrl ||
                leagueProgramList[index].playUrl.length < 1) {
              return;
            }
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new ProgramDetail(pm: leagueProgramList[index]);
            }));
          },
          child: new Row(
            children: <Widget>[
              new Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 4,
                child: (isGame
                    ? new Column(
                        children: <Widget>[
                          new Text(
                              (DateFormat('kk:mm')
                                  .format(leagueProgramList[index].startTime)),
                              style: new TextStyle(
                                  color: colorText,
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal)),
//                    new Text("",
//                        style: new TextStyle(color: GlobalConfig.fontColor)),
                          new Text(
                              subString("${leagueProgramList[index].name}", 10),
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: new TextStyle(
                                  color: colorText,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal)),
                        ],
                      )
                    : new Text(
                        (DateFormat('kk:mm')
                            .format(leagueProgramList[index].startTime)),
                        style: new TextStyle(
                            color: colorText,
                            fontSize: 14,
                            fontWeight: FontWeight.normal))),
                padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
              ),
              new Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2.8,
                child: (isGame
                    ? new Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //mainAxisSize: MainAxisSize.max,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        //verticalDirection: VerticalDirection.down,
                        children: <Widget>[
                          new Row(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // mainAxisSize: MainAxisSize.max,
                              //crossAxisAlignment: CrossAxisAlignment.,
                              children: <Widget>[
                                new Container(
                                    height: 20,
                                    child: new AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: new CachedNetworkImage(
                                          imageUrl: leagueProgramList[index]
                                              .homeTeamLogoUrl,
                                          placeholder: (context, url) => cachPlaceHolder(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        )),
                                    margin: new EdgeInsets.only(
                                        top: 2.0, bottom: 0.0, right: 5.0),
                                    alignment: Alignment.topLeft),
                                new Text(
                                    subString(
                                        "${leagueProgramList[index].homeTeam}",
                                        8),
                                    style: new TextStyle(color: colorText)),
                              ]),
                          new Row(
                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              // mainAxisSize: MainAxisSize.max,
                              //crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                new Container(
                                    height: 20,
                                    child: new AspectRatio(
                                        aspectRatio: 0.1 / 0.1,
                                        child: new CachedNetworkImage(
                                          imageUrl: leagueProgramList[index]
                                              .guestTeamLogoUrl,
                                          placeholder:(context, url) => cachPlaceHolder(),
                                          errorWidget: (context, url, error) =>
                                              new Icon(Icons.error),
                                        )),
                                    margin: new EdgeInsets.only(
                                        top: 2.0, bottom: 0.0, right: 5.0),
                                    alignment: Alignment.topLeft),
                                new Text(
                                    subString(
                                        "${leagueProgramList[index].guestTeam}",
                                        8),
                                    style: new TextStyle(color: colorText)),
                              ]),
                        ],
                      )
                    : new Text(
                        subString("${leagueProgramList[index].name}", 10),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: colorText,
                            fontSize: 14,
                            fontWeight: FontWeight.bold))),
                //   padding: const EdgeInsets.only(top: 10.0),
              ),
              new Container(
                width: MediaQuery.of(context).size.width / 12,
                child: (isGame
                    ? new Column(
                        children: <Widget>[
                          new Text(
                              leagueProgramList[index].homeTeamScore < 0
                                  ? ""
                                  : "${leagueProgramList[index].homeTeamScore}",
                              style: new TextStyle(color: colorText)),
                          new Text(
                              leagueProgramList[index].guestTeamScore < 0
                                  ? ""
                                  : "${leagueProgramList[index].guestTeamScore}",
                              style: new TextStyle(color: colorText)),
                        ],
                      )
                    : new Container()),
                padding: const EdgeInsets.only(top: 10.0),
              ),
              new Container(
                width: MediaQuery.of(context).size.width / 5,
                child: new Column(
                  children: <Widget>[
                    new Text(textStatus,
                        style: new TextStyle(color: colorText, fontSize: 12)),
                  ],
                ),
                padding: const EdgeInsets.only(top: 10.0),
              ),
            ],
          ),
        ));
  }

  Widget itemBuilderContainer(BuildContext context, int index) {
    String lastDate = dateStr;
    this.dateStr =
        DateFormat('MM-dd').format(leagueProgramList[index].startTime);
    return new Container(
      alignment: Alignment.topLeft,
      decoration: BoxDecoration(color: Colors.white, boxShadow: <BoxShadow>[
        BoxShadow(
          color: Colors.grey[300],
        ),
      ]),
      child: (lastDate == dateStr)
          ? itemBuilder1(context, index)
          : new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Text(
                    "   $dateStr                                                                                     ",
                    style: new TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        backgroundColor: Colors.black12)),
                itemBuilder1(context, index),
              ],
            ),
    );
  }

  Future handleRefresh() async {
    LogMyUtil.e("_handleRefresh");
    List<ProgramModel> programList = [];
    await HttpClient.getLeagueProgramList(name, 0, 20).then((list) {
      if (null != list) {
        programList = list.programModelList;
        if (programList != null && programList.length > 0) {
          page = 1;
          leagueProgramList.clear();
          leagueProgramList.addAll(programList);
//          for (ProgramModel pm in programList) {
//            //缓存到本地"vod_0_"为首页栏目内容
//            LocalStorage.saveProgram(pm);
//          }
        }
        LogMyUtil.e("leagueProgramList lengh :${leagueProgramList.length}");
      } else {
        LogMyUtil.e("fail to leagueProgramList");
      }

      try {
        setState(() {});
      } catch (e) {
        LogMyUtil.e(e);
      }
    });
    return programList;
  }

  Future _getMoreData() async {
    LogMyUtil.e("_getMoreData()");
    List<ProgramModel> programList = [];
    await HttpClient.getLeagueProgramList(this.name, page, 20).then((list) {
      if (null != list) {
        programList = list.programModelList;
        if (programList != null && programList.length > 0) {
          page = page + 1;
          leagueProgramList.addAll(programList);

          for (ProgramModel pm in programList) {
            //缓存到本地"vod_0_"为首页栏目内容
            LocalStorage.saveProgram(pm);
          }
          LogMyUtil.e("leagueProgramList lengh :${leagueProgramList.length}");
        }
      } else {
        LogMyUtil.e("no more data!");
      }
      try {
        setState(() {});
      } catch (e) {
        LogMyUtil.e(e);
      }
    });
    return programList;
  }
}
