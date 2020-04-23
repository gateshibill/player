
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
import '../model/client_log.dart';

class ProgramPage extends StatefulWidget {
  ProgramPage({Key key, @required this.day});

  int day = 0;

  @override
  _ProgramPageState createState() => _ProgramPageState(day: this.day);
}

class _ProgramPageState extends State<ProgramPage> {
  _ProgramPageState({Key key, @required this.day});

  ScrollController _scrollController = new ScrollController();
  int day = 0;
  List<ProgramModel> programList = [];

  @override
  void initState() {
    super.initState();
    print("day:$day");
    if (null == commonProgramlist[day]||0==commonProgramlist[day].length) {
    handleRefresh();
    } else {
      this.programList = commonProgramlist[day];
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
    ClientAction ca=new ClientAction(300+day, "programListPage", 0, "", 0, "", 1, "browse");
    HttpClientUtils.actionReport(ca);
    print("programList.length:${programList.length}");
    return (programList.length<1) ? refreshButton(this):RefreshIndicator(
      onRefresh: handleRefresh,
      child: StreamBuilder(
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              // LogUtil.e("itemBuilder index:${index}");
              return itemBuilder1(context, index);
            },
            itemCount: programList.length,
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
    String url = programList[index].playUrl;
    //String url="$LOCAL_VIDEO_URL/10001/playlist.m3u8";
    DateTime date = new DateTime.now();
    DateTime startTime = programList[index].startTime;
    DateTime endTime = programList[index].endTime;
    String textStatus = "欢迎收看";
    String text1="预约";
    String text2="比赛投注";
    Color colorText = GlobalConfig.fontColor;
    if (startTime.isBefore(date) && endTime.isAfter(date)) {
      textStatus = "正在播出";
      text1="点击收看";
      text2="立即下注";
      colorText = Colors.red;
    } else if (startTime.isAfter(date)) {
      textStatus = "预约收看";
      text1="预约";
      colorText = Colors.black;
    } else if (endTime.isBefore(date)) {
      text1="回看";
      textStatus = "精彩回看";
      text2="竞猜结束";
    }

    return new Container(
        margin: const EdgeInsets.only(top: 10.0, bottom: 0.0),
        color: GlobalConfig.cardBackgroundColor,
        child: new FlatButton(
          onPressed: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new ProgramDetail(pm: programList[index],context:this.context);
            }));
          },
          child: new Row(
            children: <Widget>[
              new Container(
                //日期
                width: MediaQuery.of(context).size.width / 4,
                child: new Column(
                  children: <Widget>[
                    new Text((
                        DateFormat('kk:mm')
                            .format(programList[index].startTime)),
                        style: new TextStyle(color: colorText)),
//                    new Text("",
//                        style: new TextStyle(color: GlobalConfig.fontColor)),
                    new Text((null==programList[index].channelName)?"":programList[index].channelName,
                        style: new TextStyle(color: colorText)),

                  ],
                ),
                padding: const EdgeInsets.only(top: 10.0),
              ),
              new Container(
                //team
                width: MediaQuery.of(context).size.width / 2.8,
//                child:new Text(programList[index].name,
//                    style: new TextStyle(color: colorText)),
                child: new Column(
                  children: <Widget>[
                    new  Text(programList[index].name,
                        style: new TextStyle(color: colorText)),
                    new Text(textStatus,
//                            null != programList[index].guestTeamScore &&
//                                programList[index].guestTeamScore > -1)
//                            ? programList[index].guestTeamScore.toString()
//                            : "",
                        style: new TextStyle(color: colorText))
                  ],
                ),
                padding: const EdgeInsets.only(top: 10.0),
              ),
              new Container(
                //tip
                width: MediaQuery.of(context).size.width / 3.3,
                child: new Column(
                  children: <Widget>[
                    new Text(text2,
                        style: new TextStyle(color: colorText)),
//                    new Text(programList[index].guestTeam,
//                        style: new TextStyle(color: GlobalConfig.fontColor)),

                  ],
                ),
                padding: const EdgeInsets.only(top: 10.0),
              ),
            ],
          ),
        ));
  }
  Future handleRefresh() async {
    LogMyUtil.e("_handleRefresh");
    await HttpClientUtils.getProgramByDayList(this.day).then((list) {
      if (null != list) {
        programList = list.programModelList;
        commonProgramlist[day] = programList;
        LogMyUtil.e(" program_list[day] :${commonProgramlist[day]}");
        for (ProgramModel pm in programList) {
          //缓存到本地"vod_0_"为首页栏目内容
          LocalStorage.saveProgram(pm);
        }
      } else {
        LogMyUtil.e("fail to get column vod");

        ClientLog cl = new ClientLog(
            "program_page.dart|handleRefresh()|fail to getProgramByDayList ${day}", "error");
        HttpClientUtils.logReport(cl);
      }
      try {
        setState(() {});
      }catch(e){
        LogMyUtil.e(e);
      }
    });
    return programList;
  }

  Future _getMoreData() async {
    LogMyUtil.e("_getMoreData()");
  }

}
