import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // UI适配库
//import './comment_detail.dart'; // 评论
//import './video_describe.dart'; // 简介
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/counter_bloc.dart';
import '../model/vod_model.dart';
import '../model/metadata_model.dart';
import '../config/config.dart';
import '../utils/log_util.dart';
import '../data/cache_data.dart';
import '../resource/cache_isolate.dart';
import '../resource/local_storage.dart';
import '../service/http_client.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import '../service/download_service.dart';
import '../model/client_action.dart';
import '../model/anchor_model.dart';
import '../common/player_controller.dart';

class AnchorPlayer extends StatelessWidget {
  AnchorPlayer({Key key, @required this.vod});
  AnchorModel vod;
  @override
  Widget build(BuildContext context) {

    final CounterBloc _counterBloc = BlocProvider.of<CounterBloc>(context);
    return BlocBuilder(
      bloc: _counterBloc,
      builder: (BuildContext context, Map theme) {
        return Scaffold(
          body: AnchorPlayerPage(vod: this.vod),
        );
      },
    );
  }
}

class AnchorPlayerPage extends StatefulWidget {
  AnchorModel vod;
  PlayerController   pc;
  AnchorPlayerPage({Key key, @required this.vod});

  @override
  State<StatefulWidget> createState() => AnchorPlayerPageState(vod: this.vod,pc:this.pc);
}

class TabTitle {
  String title;
  Widget widget;

  TabTitle(this.title, this.widget);
}


class AnchorPlayerPageState extends State<AnchorPlayerPage>
    with SingleTickerProviderStateMixin {
  AnchorPlayerPageState({Key key, @required this.vod,this.pc});

  TabController mTabController;
  PageController mPageController = PageController(initialPage: 0);
  List<TabTitle> tabList;
  var currentPage = 0;
  var isPageCanChanged = true;
  AnchorModel vod;
  PlayerController   pc;
  VideoContainer videoContainer;

  @override
  void initState() {
    super.initState();
    pc=   PlayerController();
    videoContainer = new VideoContainer(vod:this.vod,pc:this.pc);
    initTabData();
  }

  initTabData() {
    print("VideoPageState:" + vod.toString());
    tabList = [
      //new TabTitle('猜你喜欢', PlayRcmdPage(vod: this.vod, pc: this.pc)),
      //new TabTitle('比赛详情', VideoDescribe(vod: this.vod)),
    ];
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
  }

  @override
  Widget build(BuildContext context) {
    ClientAction ca=new ClientAction(5000, "livedetail", 0, "", this.vod.id, this.vod.name, 2, "watch");
    HttpClient.actionReport(ca);

    return Column(
      children: <Widget>[
        videoContainer,
        Container(
          color: new Color(0xfff4f5f6),
          height: 38.0,
          width: ScreenUtil().setWidth(750),
          child: TabBar(
            // isScrollable: true,
            controller: mTabController,
            indicatorSize: TabBarIndicatorSize.label,
            labelColor: Colors.red,
            unselectedLabelColor: Color(0xff666666),
            labelStyle: TextStyle(fontSize: 16.0),
            tabs: tabList.map((item) {
              return Tab(
                text: item.title,
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: PageView.builder(
            itemCount: tabList.length,
            onPageChanged: (index) {
              if (isPageCanChanged) {
                //由于pageview切换是会回调这个方法,又会触发切换tabbar的操作,所以定义一个flag,控制pageview的回调
                onPageChange(index);
              }
            },
            controller: mPageController,
            itemBuilder: (BuildContext context, int index) {
              return tabList[index].widget;
            },
          ),
        )
      ],
    );
  }
}

// 视频播放
class VideoContainer extends StatefulWidget {
  VideoContainer({Key key, @required this.vod,this.pc});
  AnchorModel vod;
  PlayerController  pc;
  play(String playUrl) {}

  @override
  _VideoContainerState createState() => _VideoContainerState(vod: this.vod,pc:this.pc);
}

class _VideoContainerState extends State<VideoContainer> {
  _VideoContainerState({Key key, @required this.vod,this.pc});

  IjkMediaController _mediaController = IjkMediaController();
  AnchorModel vod;
  PlayerController  pc;


  @override
  void initState() {
    super.initState();
    this.pc.mc=_mediaController;
    String playUrl = this.vod.playUrl;

    LogUtil.v("playUrl:" + playUrl);
    _mediaController.setNetworkDataSource(playUrl, autoPlay: true);

    _mediaController.getVideoInfo().then((videoInfo) {
    });
  }

  @override
  void dispose() {
    _mediaController.dispose();
    super.dispose();
  }

  @override
  void play(String playUrl) {
    print("replay");
    _mediaController.setNetworkDataSource(playUrl, autoPlay: true);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: new Column(
      children: <Widget>[
        new Container(
          height: 260,
          child: IjkPlayer(
            mediaController: _mediaController,
          ),
        ),
//        new Text("${this.vod.vodId.toString()}.${this.vod.vodName}",
//            style: new TextStyle(color: GlobalConfig.fontColor))
      ],
    ));
  }
}
