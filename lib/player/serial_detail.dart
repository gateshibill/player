import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // UI适配库
import 'package:player/player/serial_choice_page.dart';
import 'package:player/video/serial_page.dart';
import '../player/comment_detail.dart'; // 评论
import './movie_describe.dart'; // 简介
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/counter_bloc.dart';
import '../model/vod_model.dart';
import '../model/metadata_model.dart';
import '../config/config.dart';
import '../utils/log_my_util.dart';
import '../data/cache_data.dart';
import '../resource/cache_isolate.dart';
import '../service/local_storage.dart';
import '../service/http_client.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import '../service/download_service.dart';
import '../model/client_action.dart';
import '../player/play_rcmd_page.dart';
import '../common/player_controller.dart';

class SerialDetail extends StatefulWidget {
  VodModel vod;
  BuildContext context;
  IjkMediaController mediaController;
  SerialDetail({Key key, @required this.vod,this.context,this.mediaController});

  @override
  State<StatefulWidget> createState() => SerialDetailState(vod: this.vod,context:this.context,mediaController: this.mediaController);
}

class TabTitle {
  String title;
  Widget widget;

  TabTitle(this.title, this.widget);
}


class SerialDetailState extends State<SerialDetail>
    with SingleTickerProviderStateMixin {
  SerialDetailState({Key key, @required this.vod,this.pc,this.context,this.mediaController});
  BuildContext context;
  TabController mTabController;
  IjkMediaController mediaController;
  PageController mPageController = PageController(initialPage: 0);
  List<TabTitle> tabList;
  var currentPage = 0;
  var isPageCanChanged = true;
  VodModel vod;
  PlayerController   pc;
  VideoContainer videoContainer;
  String title;

  @override
  void initState() {
    super.initState();
    pc=   PlayerController();
    pc.mc=mediaController;
    videoContainer = new VideoContainer(vod:this.vod,pc:this.pc);
    this.vod.getMediaType();
    initTabData();
  }

  void fresh(){
    try {
      setState(() {
        this.title=currentPlayMedia.getName();
      });
    } catch (e) {}
  }

  initTabData() {
    print("VideoPageState:" + vod.toString());
    tabList = [
      new TabTitle('详细续集', SerialChoicePage(vod: this.vod, pc: this.pc,callback: this.fresh)),
      new TabTitle('猜你喜欢', PlayRcmdPage(vod: this.vod, pc: this.pc)),
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
    ClientAction ca=new ClientAction(1000, "videoplaydetail", 0, "", this.vod.vodId, this.vod.vodName, 2, "watch");
    HttpClientUtils.actionReport(ca);

    final CounterBloc _counterBloc = BlocProvider.of<CounterBloc>(context);
    title= currentPlayMedia.getName();
    return BlocBuilder(
      bloc: _counterBloc,
      builder: (BuildContext context, Map theme) {
        return Scaffold(
          appBar: new AppBar(
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.of(this.context).pop(),
              ),
              title: new Text(title)
          ),
          body: mybody(),
        );
      },
    );
  }

  Column mybody() {
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
  VodModel vod;
  PlayerController  pc;
  play(String playUrl) {}

  @override
  _VideoContainerState createState() => _VideoContainerState(vod: this.vod,pc:this.pc);
}

class _VideoContainerState extends State<VideoContainer> {
  _VideoContainerState({Key key, @required this.vod,this.pc});

  IjkMediaController _mediaController ;
  VodModel vod;
  PlayerController  pc;

  @override
  void initState() {
    super.initState();
    this.pc.mc=_mediaController;
    String playUrl = this.vod.vodPlayUrl;
    if (this.vod.vodCopyright) {
      playUrl =
          "$LOCAL_VIDEO_URL/${this.vod.vodId.toString()}/${this.vod.playlistFileName}";
    }
    LogMyUtil.v("playUrl:" + playUrl);
    //_mediaController.setNetworkDataSource(playUrl, autoPlay: true);
//    _mediaController.getVideoInfo().then((videoInfo) {
//      vod.progress = videoInfo.progress;
//      vod..duration = videoInfo.duration;
//      _mediaController.seekTo(vod.progress);
      currentPlayMedia= this.vod;
      LocalStorage.savaCurrentMedia(currentPlayMedia);
  //  });

    //initVOD();

    LocalStorage.saveHistoryVod(vod);
    LocalStorage.historyVoMap[vod.vodId] = vod;
  }

  @override
  void dispose() {
   // _mediaController.dispose();
    _mediaController.pause();
    super.dispose();
  }

  @override
  void play(String playUrl) {
    print("replay");
    if(null==_mediaController){
      _mediaController= new IjkMediaController();
      _mediaController.setNetworkDataSource(playUrl, autoPlay: true);
    }else{
      _mediaController.play();
    }

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
