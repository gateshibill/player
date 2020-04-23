import 'package:flutter/material.dart';
import '../service/http_client.dart';
import '../global_config.dart';
import '../data/cache_data.dart';
import '../utils/log_my_util.dart';
import '../service/local_storage.dart';
import '../common/widget_common.dart';
import '../model/program_model.dart';
import '../program/details/program_detail.dart';
import '../model/client_action.dart';
import 'package:intl/intl.dart';
import '../utils/string_util.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ProgramEventPage extends StatefulWidget {
  ProgramEventPage({Key key, @required this.day});

  int day = 0;

  @override
  _ProgramEventPageState createState() => _ProgramEventPageState(day: this.day);
}

class _ProgramEventPageState extends State<ProgramEventPage> {
  _ProgramEventPageState({Key key, @required this.day});

  ScrollController _scrollController = new ScrollController();
  int day = 0;
  //List<ProgramModel> programList = [];
  String dateStr = "";
  int page = 1;

  @override
  void initState() {
    super.initState();
    print("day:$day");
    if (null == commonProgramlist[day] || 0 == commonProgramlist[day].length) {
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
    ClientAction ca = new ClientAction(
        300 + day, "programListPage", 0, "", 0, "", 1, "browse");
    HttpClientUtils.actionReport(ca);

    return (eventProgramlist.length < 1)
        ? refreshButton(this)
        : RefreshIndicator(
            onRefresh: handleRefresh,
            child: StreamBuilder(
              builder: (context, snapshot) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    // LogUtil.e("itemBuilder index:${index}");
                    return itemBuilderContainer(context, index);
                  },
                  itemCount: eventProgramlist.length,
                  controller: _scrollController,
                );
              },
            ),
          );
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }

  Widget itemBuilder1(BuildContext context, int index) {

    DateTime date = new DateTime.now();
    DateTime startTime = eventProgramlist[index].startTime;
    DateTime endTime = eventProgramlist[index].endTime;
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

    return new Container(
        margin: const EdgeInsets.only(top: .0, bottom: 5.0),
        // color: GlobalConfig.cardBackgroundColor,
        child: new FlatButton(
          onPressed: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new ProgramDetail(pm: eventProgramlist[index],context:this.context);
            }));
          },
          child: new Row(
            children: <Widget>[
              new Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 4,
                child: new Column(
                  children: <Widget>[
                    new Text(
                        (DateFormat('kk:mm')
                            .format(eventProgramlist[index].startTime)),
                        style: new TextStyle(
                            color: colorText,
                            fontSize: 14,
                            fontWeight: FontWeight.normal)),
//                    new Text("",
//                        style: new TextStyle(color: GlobalConfig.fontColor)),
                    new Text(StrUtils.subString("${eventProgramlist[index].name}", 10),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        style: new TextStyle(
                            color: colorText,
                            fontSize: 10,
                            fontWeight: FontWeight.normal)),
                  ],
                ),
                padding: const EdgeInsets.only(top: 0.0, bottom: 0.0),
              ),
              new Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width / 2.9,
                child: new Column(
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
                                    imageUrl:
                                    eventProgramlist[index].homeTeamLogoUrl,
                                    placeholder: (context, url) =>cachPlaceHolder(),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  )),
                              margin: new EdgeInsets.only(
                                  top: 2.0, bottom: 0.0, right: 5.0),
                              alignment: Alignment.topLeft),
                          new Text(StrUtils.subString("${eventProgramlist[index].homeTeam}", 8),
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
                                    imageUrl:
                                    eventProgramlist[index].guestTeamLogoUrl,
                                    placeholder: (context, url) =>cachPlaceHolder(),
                                    errorWidget: (context, url, error) =>
                                        new Icon(Icons.error),
                                  )),
                              margin: new EdgeInsets.only(
                                  top: 2.0, bottom: 0.0, right: 5.0),
                              alignment: Alignment.topLeft),
                          new Text(StrUtils.subString("${eventProgramlist[index].guestTeam}", 8),
                              style: new TextStyle(color: colorText)),
                        ]),
                  ],
                ),
                //   padding: const EdgeInsets.only(top: 10.0),
              ),
              new Container(
                width: MediaQuery.of(context).size.width / 10,
                child: new Column(
                  children: <Widget>[
                    new Text(
                        eventProgramlist[index].homeTeamScore < 0
                            ? "-"
                            : "${eventProgramlist[index].homeTeamScore}",
                        style: new TextStyle(color: colorText)),
                    new Text(
                        eventProgramlist[index].guestTeamScore < 0
                            ? "-"
                            : "${eventProgramlist[index].guestTeamScore}",
                        style: new TextStyle(color: colorText)),
                  ],
                ),
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
    this.dateStr = DateFormat('MM-dd').format(eventProgramlist[index].startTime);
    return new Container(
      alignment: Alignment.topLeft,
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
    await HttpClientUtils.getProgramByEventList(0).then((list) {
      if (null != list) {
        programList = list.programModelList;
        if(programList!=null&&programList.length>0){
          page=1;
          eventProgramlist = programList;
          for (ProgramModel pm in programList) {
            //缓存到本地"vod_0_"为首页栏目内容
            LocalStorage.saveProgram(pm);
          }
        }
        LogMyUtil.e("eventProgramlist lengh :${eventProgramlist.length}");
      } else {
        LogMyUtil.e("fail to get column vod");
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
    await HttpClientUtils.getProgramByEventList(this.page).then((list) {
      if (null != list) {
        programList = list.programModelList;
        if (programList != null && programList.length > 0) {
            page = page + 1;
          eventProgramlist.addAll(programList);

          for (ProgramModel pm in programList) {
            //缓存到本地"vod_0_"为首页栏目内容
            LocalStorage.saveProgram(pm);
          }
          LogMyUtil.e("eventProgramlist lengh :${eventProgramlist.length}");
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
