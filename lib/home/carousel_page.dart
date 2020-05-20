import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:player/config/config.dart';
import 'package:player/utils/ui_util.dart';
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

class CarouselPage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<CarouselPage> {
  static const String TAG = "CarouselPage";

  // int groupNum = 4;
  List<MediaModel> mediaList = [];

  @override
  Widget build(BuildContext context) {
    return (mediaList.length < 1)
        ? refreshButton(this):cardList();
  }

  @override
  void initState() {
    //LogMyUtil.d(me.detail());
    super.initState();
    String playUrl =
        "http://121.31.30.91:8081/ysten-business/live/cctv-3/1.m3u8";
    if (null == currentPlayMedia){
      currentPlayMedia = tvChannelList[0][0];
    }
    homeMediaController.setNetworkDataSource(currentPlayMedia.getPlayUrl(), autoPlay: true);

    if (tvChannelList[0].length > 0) {
      mediaList.clear();
      currentPlayMedia??mediaList.insert(0, currentPlayMedia);
      mediaList = tvChannelList[0].sublist(1, tvChannelList[0].length - 1);
    }
    //mediaList.shuffle();
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
              return itemBuilder(context, index);
            },
            itemCount: mediaList.length,
          );
        },
      ),
    );
  }
  Widget carouselPlay() {
    return new Container(
      color: GlobalConfig.cardBackgroundColor,
      child: new GestureDetector(
        onTap: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              homeMediaController.pause();
              return new MediaPage(
                  mediaModel: currentPlayMedia, context: context,mediaController:homeMediaController);
            }));
        },
//        child:play(
//            context,
//            homeMediaController,
//            'https://4kkan.com/pic/carousel/ad4.png',
//            "assets/images/" + 'ad6.png'),
        child: new Column(
          children: <Widget>[
            new Stack(alignment: Alignment.center, children: <Widget>[
              new Container(
                  child: play(
            context,
            homeMediaController,
            'https://4kkan.com/pic/carousel/ad4.png',
            "assets/images/" + 'ad6.png')),
              Positioned(
                // child: Icon(Icons.play_circle_outline),
                  child: Offstage(
                      offstage: false,
                      child:
                      new Text(StrUtils.subString(currentPlayMedia?.getName(), 50),
                          maxLines: 1,
                          textAlign: TextAlign.center,
                          style: new TextStyle(color: Colors.white24,fontSize:26)
                      ),
                  )
              ),
            ]),
//            new Container(
//              // width: 400,
//              child: new Column(
//                children: <Widget>[
//                  new Text(StrUtils.subString(currentPlayMedia.getName(), 50),
//                      maxLines: 1,
//                      textAlign: TextAlign.center,
//                      style: new TextStyle(color: GlobalConfig.fontColor)
//                  ),
//                  //new Text("演员: ${widgets[index2].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
//                ],
//              ),
//              //  padding: const EdgeInsets.only(bottom: 10.0),
//              alignment: Alignment.center,
//              margin: new EdgeInsets.only(top: 0.0, bottom: 6.0),
//            ),
          ],
        ),
      ),
    );
  }

  Future handleRefresh() async {
    LogMyUtil.d("_handleRefresh");
    await HttpClientUtils.init().then((onValue) {
      try {
        setState(() {});
      } catch (e) {}
    });
    return;
  }

  Widget hot() {
    return new Container(
        height: 70.0,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          border: new Border.all(color: Colors.grey, width: 0.5), // 边色与边宽度
        ),
        child: currentProgramlist.length == 0
            ? new Container(
                // mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                child: new Text("更多精彩节目即将播出",
                    style: new TextStyle(color: Colors.red)),
              )
            : scrollHot());
  }

  Widget scrollHot() {
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
    return new Container(
      color: GlobalConfig.cardBackgroundColor,
      child: new GestureDetector(
        onTap: () {
          if (null == mediaList[index].getPlayUrl ||
              "" == mediaList[index].getPlayUrl) {
            LogMyUtil.v("playUrl is blank");
          } else {
            if(null==me.vipExpire||!me.vipExpire.isAfter(DateTime.now())){
              UiUtil.showToast('您的VIP已到期,请到个人中心充值！');
              return;
            }
            homeMediaController.reset();
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new MediaPage(
                  mediaModel: mediaList[index], context: context);
            }));
          }
        },
        child: new Column(
          children: <Widget>[
            new Stack(alignment: Alignment.center, children: <Widget>[
              new Container(
                  child: new AspectRatio(
                      aspectRatio: 3.5 / 2,
                      child: new CachedNetworkImage(
                        imageUrl: "${mediaList[index].getPics()[0]}",
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
                      ))),
            ]),
            new Container(
              // width: 400,
              child: new Column(
                children: <Widget>[
                  new Text(StrUtils.subString(mediaList[index].getName(), 50),
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
      //]
      // )
    );
  }

  Widget itemBuilder(BuildContext context, int index) {
//    int index2 = index - 1;
    return (index < 1
        ? new Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              carouselPlay(),
              hot(),
                newRecommend(context, index)
              ])
        : (mediaList.length < 1)
            ? refreshButton(this)
            : newRecommend(context, index));
  }

  @override
  void dispose() {
    print("33homeMediaController:${homeMediaController.ijkStatus}");
    homeMediaController.reset();
    super.dispose();
  }
}
