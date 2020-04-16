import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:player/config/config.dart';
import 'package:player/utils/ui_util.dart';
import '../global_config.dart';
import '../model/client_log.dart';
import '../program/details/program_detail.dart';
import '../service/http_client.dart';
import '../resource/local_storage.dart';
import '../data/cache_data.dart';
import '../model/vod_model.dart';
import '../player/video_detail.dart';
import '../utils/log_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/string_util.dart';
import '../common/widget_common.dart';
import 'package:intl/intl.dart';
import '../model/channel_model.dart';
import '../model/media_model.dart';
import '../common/media_page.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

class CarouselPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CarouselPage> {
  //List<VodModel> homeVodList = new List<VodModel>();
  int groupNum = 4;
  List<MediaModel> mediaList = [];

  // IjkMediaController homeMediaController = IjkMediaController();

  @override
  Widget build(BuildContext context) {
    return cardList();
  }

  @override
  void initState() {
    super.initState();
    String playUrl = "http://121.31.30.91:8081/ysten-business/live/cctv-3/1.m3u8";
    freshChannel();
//    if (null != sportsChannelList[0] && sportsChannelList[0].length > 0) {
//      HttpClient.getChannelPlayUrl(sportsChannelList[0][0]).then((onValue) {
//        print("onValue:$onValue");
//        String playUrlTmp = onValue;
//        if (null != playUrlTmp && playUrlTmp != "") {
//          playUrl = playUrlTmp;
//        }
        homeMediaController.setNetworkDataSource(playUrl, autoPlay: true);
        print("playUrling:${playUrl}");
//        LocalStorage.historyChannelMap[sportsChannelList[0][0].id] =
//            sportsChannelList[0][0];
//        LocalStorage.saveHistoryChannel(sportsChannelList[0][0]);
     // });
  //  } else {
      //homeMediaController.setNetworkDataSource(playUrl, autoPlay: true);
   // }
    //mediaList.addAll(topicList);
    mediaList.addAll(tvChannelList[0]);
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
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              return itemBuilder1(context, index);
            },
            itemCount: mediaList.length ~/ groupNum,
          );
        },
      ),
    );
  }

  Future handleRefresh() async {
    LogUtil.e("_handleRefresh");
    await HttpClient.getCurrentPrograms(0).then((list) {
      if (null != list) {
        currentProgramlist = list.programModelList;
      }
      try {
        setState(() {});
      } catch (e) {}
    });
    mediaList.clear();
    await HttpClient.getTopics(1, 0, 3).then((list) {
      if (null != list) {
        topicList = list;
        //clear old when fresh success
//        int len = mediaList.length;
////        List<MediaModel> mediaListTmp = [];
////        mediaListTmp.addAll(mediaList);
////        for (int i = 0; i < len; i++) {
////          if (MediaType.Topic == mediaListTmp[i].getMediaType()) {
////            mediaList.removeAt(i);
////          }
////        }
        mediaList.addAll(list);
      }
      try {
        setState(() {});
      } catch (e) {}
    });
    await HttpClient.getVodList(100).then((list) {
      if (null != list) {
        homeVodList = list.vodModelList;
        //clear old when fresh success
//        int len = mediaList.length;
//        for (int i=0; i < len; i++) {
//          if (MediaType.Video == mediaList[i].getMediaType()) {
//            mediaList.removeAt(i);
//          }
//        }
        mediaList.addAll(homeVodList);
        try {
          setState(() {});
        } catch (e) {}
        for (VodModel m in homeVodList) {
          LocalStorage.saveVod(m, column: 100);
        }
      } else {
        LogUtil.e("fail to get column vod");
        ClientLog cl = new ClientLog(
            "carousel_page.dart|handleRefresh()|fail to get 100 column vod",
            "error");
        HttpClient.logReport(cl);
      }
    });
    return;
  }
//每次刷新体育台，防止过期
  void freshChannel() async{
    int  column=1;
    await HttpClient.getChannelList(column, 0, 0, 10).then((list) {
      if (null != list) {
        sportsChannelList[0] = list.channelModelList;
        for (ChannelModel cm in sportsChannelList[0]) {
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
  }
//  Widget carousel() {
//    return new Container(
//        height: 180.0,
//        margin: new EdgeInsets.only(top: 0.0, bottom: 0),
//        padding: const EdgeInsets.only(top: 0.0),
//        child: CarouselSlider(
//          height: 180.0,
//          viewportFraction: 1.0,
//          autoPlay: true,
//          items: [
//            'http://sportslive.hongxiuba.com/pic/carousel/ad1.png?1',
//            'http://sportslive.hongxiuba.com/pic/carousel/ad2.png?2',
//            'http://sportslive.hongxiuba.com/pic/carousel/ad3.png',
//            'http://sportslive.hongxiuba.com/pic/carousel/ad4.png',
//            'http://sportslive.hongxiuba.com/pic/carousel/ad6.png',
//            //'http://sportslive.hongxiuba.com/pic/carousel/ad1.png',
//            'http://sportslive.hongxiuba.com/pic/carousel/chinafoot.png',
//            // 'http://sportslive.hongxiuba.com/pic/carousel/ad2.png',
//          ].map((i) {
//            return Builder(
//              builder: (BuildContext context) {
////                return new FlatButton(
////                  onPressed: () {
////                    Navigator.of(context)
////                        .push(new MaterialPageRoute(builder: (context) {
////                      return new LiveDetail(vod: channelList[2][3]);
////                    }));
////                  },
//                //child:
//                return new CachedNetworkImage(
//                  imageUrl: i,
//                  placeholder: (context, url) => cachPlaceHolder(),
//                  errorWidget: (context, url, error) => new Icon(Icons.error),
//                  // ),
//                );
//              },
//            );
//          }).toList(),
//        ));
//  }

//  Widget play() {
//    return new Container(
//      height: 215.0,
//      margin: new EdgeInsets.only(top: 0.0, bottom: 0),
//      padding: const EdgeInsets.only(top: 0.0),
//      child: IjkPlayer(
//        mediaController: homeMediaController,
//        statusWidgetBuilder: _buildStatusWidget,
//      ),
//    );
//  }

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
//    return new ListView(
//      // This next line does the trick.
//      scrollDirection: Axis.horizontal,
//      children: <Widget>[hotProgram(), hotProgram(), hotProgram()],
//    );
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return hotProgram(context, index);
      },
      itemCount: currentProgramlist.length,
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
                return new ProgramDetail(pm: currentProgramlist[index]);
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
            LogUtil.v("playUrl is blank");
          } else {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new MediaPage(mediaModel: mediaList[index * groupNum]);
            }));
          }
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
              width: 190,
              alignment: Alignment.center,
              child: new Column(
                children: <Widget>[
                  new Text(subString(mediaList[index * groupNum].getName(), 50),
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
            new Container(
              //Expanded(
              // flex: 1,
              // child: new AspectRatio(
              //aspectRatio: 3.5 / 2,
              width: 130,
              //height: 110,
              child: new CachedNetworkImage(
                imageUrl: "${mediaList[index * groupNum].getPics()[0]}",
                placeholder: (context, url) => cachPlaceHolder(),
                errorWidget: (context, url, error) => defaultCacheNetworkImage(DefaultChannleUrl),
              ),
              margin: new EdgeInsets.only(top: 6.0, bottom: 6.0),
            ),
          ],
        ),
      ),
      new FlatButton(
        onPressed: () {
          if (null == mediaList[index].getPlayUrl ||
              "" == mediaList[index].getPlayUrl) {
            LogUtil.v("playUrl is blank");
          } else {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new MediaPage(mediaModel: mediaList[index * groupNum + 1],context:context);
            }));
          }
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
              width: 190,
              child: new Column(
                children: <Widget>[
                  new Text(
                      subString(mediaList[index * groupNum + 1].getName(), 50),
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          color: GlobalConfig.fontColor, fontSize: 15)),
                  //new Text("演员: ${widgets[index2].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                ],
              ),
              //padding: const EdgeInsets.only(bottom: 10.0),
              margin: new EdgeInsets.only(top: 6.0, bottom: 6.0),
            ),
            new Container(
              //Expanded(
              // flex: 1,
              // child: new AspectRatio(
              //aspectRatio: 3.5 / 2,
              width: 130,
              //height: 110,
              child: new CachedNetworkImage(
                imageUrl: "${mediaList[index * groupNum + 1].getPics()[0]}",
                placeholder: (context, url) => cachPlaceHolder(),
                errorWidget: (context, url, error) => defaultCacheNetworkImage(DefaultChannleUrl),
              ),
              margin: new EdgeInsets.only(top: 6.0, bottom: 6.0),
            ),
          ],
        ),
      ),
      new FlatButton(
        onPressed: () {
          if (null == mediaList[index].getPlayUrl ||
              "" == mediaList[index].getPlayUrl) {
            LogUtil.v("playUrl is blank");
          } else {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new MediaPage(mediaModel: mediaList[index * groupNum + 2]);
            }));
          }
        },
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            new Container(
              width: 190,
              child: new Column(
                children: <Widget>[
                  new Text(
                      subString(mediaList[index * groupNum + 2].getName(), 50),
                      maxLines: 3,
                      textAlign: TextAlign.left,
                      style: new TextStyle(
                          color: GlobalConfig.fontColor, fontSize: 15)),
                  //new Text("演员: ${widgets[index2].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                ],
              ),
              padding: const EdgeInsets.only(bottom: 10.0),
              margin: new EdgeInsets.only(top: 6.0, bottom: 6.0),
            ),
            new Container(
              //Expanded(
              // flex: 1,
              // child: new AspectRatio(
              //aspectRatio: 3.5 / 2,
              width: 130,
              //height: 110,
              child: new CachedNetworkImage(
                imageUrl: "${mediaList[index * groupNum + 2].getPics()[0]}",
                placeholder: (context, url) => cachPlaceHolder(),
               // errorWidget: (context, url,error) => cachPlaceHolder(),
               errorWidget: (context, url, error) => defaultCacheNetworkImage(DefaultChannleUrl),
              ),
              margin: new EdgeInsets.only(top: 6.0, bottom: 6.0),
            ),
          ],
        ),
      ),
      new FlatButton(
        onPressed: () {
          if (null == mediaList[index].getPlayUrl ||
              "" == mediaList[index].getPlayUrl) {
            LogUtil.v("playUrl is blank");
          } else {
            homeMediaController.reset();
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new MediaPage(mediaModel: mediaList[index * groupNum + 3]);
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
              width: 400,
              // height: 110,
              child: new CachedNetworkImage(
                imageUrl: "${mediaList[index * groupNum + 3].getPics()[0]}",
                placeholder: (context, url) => cachPlaceHolder(),
                errorWidget: (context, url, error) => defaultCacheNetworkImage(DefaultChannleUrl),
                fit: BoxFit.fill,
              ),
              //),
              margin: new EdgeInsets.only(top: 6.0, bottom: 14.0),
               alignment: Alignment.topLeft
            ),
            new Container(
              width: 400,
              child: new Column(
                children: <Widget>[
                  new Text(
                      subString(mediaList[index * groupNum + 3].getName(), 50),
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      style: new TextStyle(color: GlobalConfig.fontColor)),
                  //new Text("演员: ${widgets[index2].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                ],
              ),
              //  padding: const EdgeInsets.only(bottom: 10.0),
              alignment: Alignment.center,
              margin: new EdgeInsets.only(top: 0.0, bottom: 6.0),
            ),
          ],
        ),
      ),
    ]
        // )
        );
  }

  Widget itemBuilder1(BuildContext context, int index) {
//    int index2 = index - 1;
    return (index < 1
        ? new Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
             play(context,homeMediaController,'https://4kkan.com/pic/carousel/ad4.png',"assets/images/" + 'ad6.png'),
              hot(),
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
