import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:chewie/chewie.dart'; // 播放
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // UI适配库
import '../../player/comment_detail.dart'; // 评论
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/counter_bloc.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import '../../global_config.dart';
import '../../model/program_model.dart';
import '../../model/client_action.dart';
import '../../service/http_client.dart';
import '../../utils/string_util.dart';
import 'bet_detail.dart';

class ProgramDetail extends StatelessWidget {
  ProgramModel pm;
  ProgramDetail({Key key, @required this.pm});

  @override
  Widget build(BuildContext context) {
    ClientAction ca=new ClientAction(3000, "programPlayPage", 0, "", this.pm.id, this.pm.name, 2, "browse");
    HttpClientUtils.actionReport(ca);

    final CounterBloc _counterBloc = BlocProvider.of<CounterBloc>(context);
    return BlocBuilder(
      bloc: _counterBloc,
      builder: (BuildContext context, Map theme) {
        return Scaffold(
          body: VideoPage(pm: this.pm),
        );
      },
    );
  }
}

class VideoPage extends StatefulWidget {
  //String playUrl;
  ProgramModel pm;

  VideoPage({Key key, @required this.pm});

  @override
  State<StatefulWidget> createState() => VideoPageState(pm: this.pm);
}

class TabTitle {
  String title;
  Widget widget;

  TabTitle(this.title, this.widget);
}

class VideoPageState extends State<VideoPage>
    with SingleTickerProviderStateMixin {
  IjkMediaController mediaController_commentator = IjkMediaController();
  IjkMediaController _mediaController = IjkMediaController();
  ProgramModel pm;
  TabController mTabController;
  PageController mPageController = PageController(initialPage: 0);
  List<TabTitle> tabList;
  var currentPage = 0;
  var isPageCanChanged = true;

  //String playUrl;

  VideoPageState({Key key, @required this.pm});

  @override
  void initState() {
    super.initState();
    initTabData();
    mTabController = TabController(
      length: tabList.length,
      vsync: this,
    );
    mTabController.addListener(() {
      //TabBar的监听
      if (mTabController.indexIsChanging) {
        //判断TabBar是否切换
        print(mTabController.index);
        onPageChange(mTabController.index, p: mPageController);
      }
    });
    print("pm.playUrl.trim:${pm.playUrl.trim()}");
    _mediaController.setNetworkDataSource(pm.playUrl.trim(), autoPlay: true);
    mediaController_commentator.setNetworkDataSource(
        "http://www.haoshi360.com/girl/1/playlist.m3u8",
        autoPlay: true);
  }

  initTabData() {
    tabList = [
      new TabTitle('讨论', CommentDetail()),
      new TabTitle('下注', BetDetail()),
    ];
  }

  onPageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      //判断是哪一个切换
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease); //等待pageview切换完毕,再释放pageivew监听
      isPageCanChanged = true;
    } else {
      mTabController.animateTo(index); //切换Tabbar
    }
  }

  @override
  void dispose() {
    super.dispose();
    mTabController.dispose();
    _mediaController.dispose();
    mediaController_commentator.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // print("VideoPageState playUrl:" + playUrl);

    return new MaterialApp(
        title: "asdaf",
        theme: GlobalConfig.themeData,
        home: new Scaffold(
//          appBar: new AppBar(
//            //title: dd(),
//          ),
          body: dd(),
          bottomSheet: ff(),
        ));

  }

  Widget dd() {
    return Column(children: <Widget>[
      cc(),
      new Container(
       // height: 10,
        child: new Text(
          "选择你喜欢的主播，陪你一起看比赛！",
          style: new TextStyle(fontSize: 12.0, color: GlobalConfig.fontColor),
        ),
//        child:new MarqueeWidget(
//          text: "选择你喜欢的主播，陪你一起看比赛！",
//          textStyle: new TextStyle(fontSize: 10.0),
//          scrollAxis: Axis.horizontal,
//        ),
      ),

    ]);
  }

  Widget ff() {
    String accomplayUrl = "http://www.haoshi360.com/girl/playlist.m3u8";

    return new Container(
      height: 100,
      child: new ListView(
          //margin: new EdgeInsets.only(top: 5.0, bottom: 5.0),
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            new Container(
              height: 100,
              //  child: new AspectRatio(
              //  aspectRatio: 1 / 2,
              child: new FlatButton(
                onPressed: () {
                  setState(() {
                    accomplayUrl =
                        "http://www.haoshi360.com/girl/7/7.mp4";
                    mediaController_commentator
                        .setNetworkDataSource(accomplayUrl, autoPlay: true);
                  });
                },
                child: new CachedNetworkImage(
                  imageUrl: "http://www.haoshi360.com/pic/girl/1.jpg",
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  // )
                ),
              ),
              // margin: new EdgeInsets.only(left: 5.0, right: 1.0),
              alignment: Alignment.center,
            ),
            new Container(
              height: 100,
              //  child: new AspectRatio(
              //  aspectRatio: 1 / 2,
              alignment: Alignment.center,
              child: new FlatButton(
                onPressed: () {
                  setState(() {
                    accomplayUrl = "http://www.haoshi360.com/girl/2/playlist.m3u8";
                    mediaController_commentator
                        .setNetworkDataSource(accomplayUrl, autoPlay: true);
                  });
                  ;
                },
                child: new CachedNetworkImage(
                  imageUrl: "http://www.haoshi360.com/pic/girl/2.jpg",
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  // )
                ),
                //margin: new EdgeInsets.only(left: 5.0, right: 1.0),
              ),
            ),
            new Container(
              height: 100,
              //  child: new AspectRatio(
              //  aspectRatio: 1 / 2,
              alignment: Alignment.center,
              child: new FlatButton(
                onPressed: () {
                  setState(() {
                    accomplayUrl =
                        "http://www.haoshi360.com/girl/3/playlist.m3u8";
                    mediaController_commentator
                        .setNetworkDataSource(accomplayUrl, autoPlay: true);
                  });
                  ;
                },
                child: new CachedNetworkImage(
                  imageUrl: "http://www.haoshi360.com/pic/girl/3.jpg",
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  // )
                ),
                // margin: new EdgeInsets.only(left: 5.0, right: 1.0),
              ),
            ),
            new Container(
              height: 100,
              //  child: new AspectRatio(
              //  aspectRatio: 1 / 2,
              alignment: Alignment.center,
              child: new FlatButton(
                onPressed: () {
                  setState(() {
                    accomplayUrl =
                        "http://www.haoshi360.com/girl/4/playlist.m3u8";
                    mediaController_commentator
                        .setNetworkDataSource(accomplayUrl, autoPlay: true);
                  });
                  ;
                },
                child: new CachedNetworkImage(
                  imageUrl: "http://www.haoshi360.com/pic/girl/4.jpg",
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  // )
                ),
                //margin: new EdgeInsets.only(left: 5.0, right: 1.0),
              ),
            ),
            new Container(
              height: 100,
              //  child: new AspectRatio(
              //  aspectRatio: 1 / 2,
              alignment: Alignment.center,
              child: new FlatButton(
                onPressed: () {
                  setState(() {
                    accomplayUrl =
                        "http://www.haoshi360.com/girl/5/playlist.m3u8";
                    mediaController_commentator
                        .setNetworkDataSource(accomplayUrl, autoPlay: true);
                  });
                  ;
                },
                child: new CachedNetworkImage(
                  imageUrl: "http://www.haoshi360.com/pic/girl/5.jpg",
                  placeholder: (context, url) =>
                      new CircularProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                  // )
                ),
                // margin: new EdgeInsets.only(left: 5.0, right: 1.0),
              ),
            )
          ]),
      //  ),
      //],
    );
  }

  Widget cc() {
    return Container(
        child: new Column(
      children: <Widget>[
        new Container(
          height: 260,
          child: IjkPlayer(
            mediaController: _mediaController,
          ),
        ),
        new Text(StrUtils.subString("${pm.name}",23),
            style: new TextStyle(color: GlobalConfig.fontColor), maxLines: 1),
        new Container(
          height: 330,
          width: 200,
          child: IjkPlayer(
            mediaController: mediaController_commentator,
          ),
        ),
      ],
    ));
  }
}

// 视频播放
class VideoContainer extends StatefulWidget {
  //String playUrl;
  ProgramModel pm;
  IjkMediaController mediaController_commentator; //= IjkMediaController();

  VideoContainer(
      {Key key, @required this.pm, @required this.mediaController_commentator})
      : super(key: key);

  @override
  _VideoContainerState createState() => _VideoContainerState(
      pm: this.pm,
      mediaController_commentator: this.mediaController_commentator);
}

class _VideoContainerState extends State<VideoContainer> {
  IjkMediaController _mediaController = IjkMediaController();
  IjkMediaController mediaController_commentator; //= IjkMediaController();
  ProgramModel pm;

  //StreamSubscription subscription;
  //String playUrl;

  _VideoContainerState(
      {Key key, @required this.pm, @required this.mediaController_commentator});

  @override
  void initState() {
    super.initState();
    //print("playUrl:" + playUrl);
    _mediaController.setNetworkDataSource(pm.playUrl, autoPlay: true);
    mediaController_commentator.setNetworkDataSource(
        "http://www.haoshi360.com/girl/playlist.m3u8",
        autoPlay: true);
//    mediaController_commentator.playFinishStream.listen((data) {
//      // _mediaController_commentator.stop();
//      // _mediaController_commentator.play(); //add this
//      //_mediaController_commentator.seekTo(0.0);
//      mediaController_commentator.setAutoPlay();
//    });
  }

  @override
  void dispose() {
    _mediaController.dispose();
    mediaController_commentator.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    return Container(
//      height: 260,
//      child: IjkPlayer(
//        mediaController: _mediaController,
//      ),
//    );

    return Container(
        child: new Column(
      children: <Widget>[
        new Container(
          height: 280,
          child: IjkPlayer(
            mediaController: _mediaController,
          ),
        ),
        new Text(pm.name,
            style: new TextStyle(color: GlobalConfig.fontColor), maxLines: 1),
        new Container(
          height: 300,
          width: 180,
          child: IjkPlayer(
            mediaController: mediaController_commentator,
          ),
        ),
      ],
    ));
  }
}
