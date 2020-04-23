import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../global_config.dart';
import '../model/client_log.dart';
import '../program/details/program_detail.dart';
import '../service/http_client.dart';
import '../service/local_storage.dart';
import '../data/cache_data.dart';
import '../model/vod_model.dart';
import '../player/video_detail.dart';
import '../utils/log_my_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/string_util.dart';
import '../common/widget_common.dart';
import 'package:intl/intl.dart';
import '../model/channel_model.dart';
import '../model/media_model.dart';
import '../common/media_page.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import '../model/topic_model.dart';

class NewsPage extends StatefulWidget {
  NewsPage(this.type);
   int type;
  @override
  _HomePageState createState() => _HomePageState(this.type);
}

class _HomePageState extends State<NewsPage> {
  _HomePageState(this.type);
  int type;
  int groupNum = 1;
  List<MediaModel> mediaList = [];
  @override
  Widget build(BuildContext context) {
    return cardList();
  }

  @override
  void initState() {
    super.initState();
    if (mediaList.length == 0) {
      handleRefresh();
    }

  }

  Widget cardList() {
    //int index = homeVodList.length ~/ 2+1;
    return RefreshIndicator(
      onRefresh: handleRefresh,
      child: StreamBuilder(
        builder: (context, snapshot) {
          return ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return itemBuilder1(context, index);
            },
            itemCount: mediaList.length ~/ groupNum,
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
        },
      ),
    );
  }

  Future handleRefresh() async {
    LogMyUtil.e("_handleRefresh");
    await HttpClientUtils.getCurrentPrograms(0).then((list) {
      if (null != list) {
        currentProgramlist = list.programModelList;
      }
      try {
        setState(() {});
      } catch (e) {}
    });
    mediaList.clear();
    await HttpClientUtils.getTopics(type, 0, 10).then((list) {
      if (null != list) {
        mediaList.addAll(list);
      }
      try {
        setState(() {});
      } catch (e) {}
    });
    return;
  }
//每次刷新体育台，防止过期
  void freshChannel() async{
    int  column=1;
    await HttpClientUtils.getChannelList(column, 0, 0, 10).then((list) {
      if (null != list) {
        sportsChannelList[0] = list.channelModelList;
        for (ChannelModel cm in sportsChannelList[0]) {
          //缓存到本地"vod_0_"为首页栏目内容
          LocalStorage.saveChannel(cm);
        }
      } else {
        LogMyUtil.e("fail to get channel");
        ClientLog cl = new ClientLog(
            "live_page.dart|handleRefresh()|fail to get channel ${column}",
            "error");
        HttpClientUtils.logReport(cl);
      }
      try {
        setState(() {});
      } catch (e) {}
    });
  }


  Widget hot() {
    return new Container(
        height: 60.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          border: new Border.all(color: Colors.grey, width: 0.5), // 边色与边宽度
          //color: Color(0xFF9E9E9E), // 底色
          //        borderRadius: new BorderRadius.circular((20.0)), // 圆角度
          //borderRadius: new BorderRadius.vertical(top: Radius.elliptical(20, 50)), // 也可控件一边圆角大小
        ),
        //margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        //color: GlobalConfig.cardBackgroundColor,
        child: currentProgramlist.length == 0
            ? new Container(
                // mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                child: new Text("更多精彩节目即将播出",
                    style: new TextStyle(color: Colors.red)),
              )
            : scrollHot());
  }

  Widget scrollHot() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return hotProgram(context, index);
      },
      itemCount: currentProgramlist.length,
      separatorBuilder: (context, index) {
        return Divider();
      },
    );
  }

  Widget hotProgram(BuildContext context, int index) {
    return new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new FlatButton(
            onPressed: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new ProgramDetail(pm: currentProgramlist[index],context:this.context);
              }));
            },
            child: new Row(
              children: <Widget>[
                new Container(
                  //margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                  //日期
                  width: MediaQuery.of(context).size.width / 4,
                  child: new Column(
                    children: <Widget>[
                      new Text(
                          (DateFormat('kk:mm')
                              .format(currentProgramlist[index].startTime)),
                          style: new TextStyle(color: Colors.red)),
//                    new Text(currentProgramlist[index].channelName,
//                        style: new TextStyle(color: GlobalConfig.fontColor)),
                                new Text(currentProgramlist[index].channelName,
                                    style: new TextStyle(color: Colors.red)),
                    ],
                  ),
                  // padding: const EdgeInsets.only(top: 10.0),
                ),
                // new Container(padding: const EdgeInsets.only(top: 10.0)),
                new Container(
                  //team
                  width: MediaQuery.of(context).size.width / 2.8,
//                child:new Text(programList[index].name,
//                    style: new TextStyle(color: colorText)),
                  child: new Column(
                    children: <Widget>[
                      new Text(currentProgramlist[index].name,
                          maxLines: 3, style: new TextStyle(color: Colors.red)),
//                      new Text("",
////                            null != programList[index].guestTeamScore &&
////                                programList[index].guestTeamScore > -1)
////                            ? programList[index].guestTeamScore.toString()
////                            : "",
//                          style: new TextStyle(color: Colors.red))
                    ],
                  ),
                  //padding: const EdgeInsets.only(top: 10.0),
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
                  // padding: const EdgeInsets.only(top: 10.0),
                ),
              ],
            ),
          ),
        ]);
  }

  Widget newRecommend(BuildContext context, int index) {
    return new Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
      new FlatButton(
        onPressed: () {
          if (null == mediaList[index].getPlayUrl ||
              "" == mediaList[index].getPlayUrl) {
            LogMyUtil.v("playUrl is blank");
          } else {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new MediaPage(mediaModel: mediaList[index * groupNum],context:context);
            }));
          }
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
              width: 310,
              alignment: Alignment.topLeft,
              child: new Column(
                children: <Widget>[
                  new Text(StrUtils.subString(mediaList[index * groupNum].getName(), 50),
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                        color: GlobalConfig.fontColor,
                        fontSize: 15,
                      )),
                  //new Text("演员: ${widgets[index2].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                ],
              ),
              //  padding: const EdgeInsets.only(bottom: 10.0),
              margin: new EdgeInsets.only(top: 6.0, bottom: 6.0),
            ),
//            new Container(
//              //Expanded(
//              // flex: 1,
//              // child: new AspectRatio(
//              //aspectRatio: 3.5 / 2,
//              width: 130,
//              //height: 110,
//              child: new CachedNetworkImage(
//                imageUrl: "${mediaList[index * groupNum].getPics()[0]}",
//                placeholder: (context, url) => cachPlaceHolder(),
//                errorWidget: (context, url, error) => new Icon(Icons.autorenew),
//              ),
//              margin: new EdgeInsets.only(top: 6.0, bottom: 6.0),
//            ),
          ],
        ),
      ),
    ]
        );
  }

  Widget itemBuilder1(BuildContext context, int index) {
//    int index2 = index - 1;
    return (index < 1
        ? new Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
            // play(context,homeMediaController,'https://4kkan.com/pic/carousel/ad4.png',"assets/images/" + 'ad6.png'),
            //  hot(),
              newRecommend(context, index)])
        : (mediaList.length < 1)
            ? refreshButton(this)
            : newRecommend(context, index));
  }

  @override
  void dispose() {
    print("############################################################################33homeMediaController:${homeMediaController.ijkStatus}");
    homeMediaController.reset();
    super.dispose();
  }

  Widget _buildStatusWidget(
    BuildContext context,
    IjkMediaController controller,
    IjkStatus status,
  ) {
    if (status == IjkStatus.error) {
      return Center(
        child: new Image.asset(
          "assets/images/" + 'ad6.png',
          //scale: 2.0,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
      );
    } else if (status != IjkStatus.playing) {
      return Center(
        child: new Image.asset(
          "assets/images/" + 'ad4.png',
          //scale: 2.0,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,
        ),
      );
    }

    // you can custom your self status widget
    return IjkStatusWidget.buildStatusWidget(context, controller, status);
  }
}
