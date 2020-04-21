import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // UI适配库
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

class MoviePlayer extends StatelessWidget {
  MoviePlayer({Key key, @required this.vod});

  VodModel vod;

  @override
  Widget build(BuildContext context) {


    final CounterBloc _counterBloc = BlocProvider.of<CounterBloc>(context);
    return BlocBuilder(
      bloc: _counterBloc,
      builder: (BuildContext context, Map theme) {
        return Scaffold(
          body: MoviePlayerPage(vod: this.vod),
        );
      },
    );
  }
}

class MoviePlayerPage extends StatefulWidget {
  VodModel vod;
  PlayerController   pc;
  MoviePlayerPage({Key key, @required this.vod});

  @override
  State<StatefulWidget> createState() => MoviePlayerPageState(vod: this.vod,pc:this.pc);
}

class TabTitle {
  String title;
  Widget widget;

  TabTitle(this.title, this.widget);
}


class MoviePlayerPageState extends State<MoviePlayerPage>
    with SingleTickerProviderStateMixin {
  MoviePlayerPageState({Key key, @required this.vod,this.pc});

  TabController mTabController;
  PageController mPageController = PageController(initialPage: 0);
  List<TabTitle> tabList;
  var currentPage = 0;
  var isPageCanChanged = true;
  VodModel vod;
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
      new TabTitle('猜你喜欢', PlayRcmdPage(vod: this.vod, pc: this.pc)),
      new TabTitle('详情', MovieDescribe(vod: this.vod)),
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

  IjkMediaController _mediaController = IjkMediaController();
  VodModel vod;
  PlayerController  pc;

//  Future<void> cache() async {
//    //LogUtil.v("cache():${this.vod.toString()}");
//    await this._mediaController.getVideoInfo().then((videoInfo) {
//      vod.progress = videoInfo.progress;
//      vod.duration = videoInfo.duration;
//    });
//    LogUtil.v("cache():${this.vod.toString()}");
//    List<MetadataModel> mmList = vod.metadataList;
//    int currentProgress = 0;
//    if (vod.duration != null && vod.duration > 1 && mmList.length > 0) {
//      currentProgress = (vod.progress / vod.duration * mmList.length).toInt();
//    }
//    LogUtil.v("${vod.vodName} current play index: :$currentProgress");
//    //播放到当前的TS流顺序
//    int currentCacheIndex = 0;
//    if (null != vod.cacheIndex) {
//      currentCacheIndex = vod.cacheIndex;
//    } else {
//      vod.cacheIndex = 0;
//    }
//    //用户拖动后，缓存和当前播放进度都前移
//    if (currentCacheIndex < currentProgress) {
//      currentCacheIndex = currentProgress;
//      vod.cacheIndex = currentProgress;
//    }
//    int surplusPoolsNum =
//        currentCacheIndex - currentProgress; //max=60,play for 10 mins;
//    if (surplusPoolsNum > MOVIE_CACHE_NUM_MAX) {
//      //单部最大缓存
//      LogUtil.v("reach the max cache pool of ${vod.vodName}:$surplusPoolsNum");
//      return;
//    } else if (currentCacheIndex > mmList.length) {
//      //是否结束
//      LogUtil.v("cache end ${vod.vodName}");
//      return;
//    } else if (TOTAL_CACHE_NUM_MAX > TOTAL_CACHE_NUM_MAX) {
//      //总缓存reach max;
//      LogUtil.v("reach the total of app: $TOTAL_CACHE_NUM_MAX");
//      //这里需要增加代码，启动系统清除缓存策略；
//      //return;
//    }
//    MetadataModel mm = mmList.elementAt(currentCacheIndex);
//    CacheIsolate.startNormalThread(mm).then((onValue) {
//      //继续缓存
//      LogUtil.v("vod: ${this.vod.toString()}");
//      LocalStorage.saveVod(vod);
//      LocalStorage.saveMetadata(mm);
//      vod.cacheIndex++;
//      cache();
//    });
//  }
//缓存视频

//  Future initVOD() async {
//    if(false==vod.vodCopyright){
//      LogUtil.v("${vod.vodName} doesn't need cache!");
//      return;
//    }
//    String fileName = "playlist.m3u8"; //临时，有可能不妥
//    //        playUrl.substring(playUrl.lastIndexOf("/") + 1, playUrl.length);
//    vod.playlistFileName = fileName;
//    String dir = "$BASE_DIR/${vod.vodId.toString()}";
//    await DownloadService.download(vod.vodPlayUrl, dir, fileName)
//        .then((isSucess) async {
//      //1.解析m3u8, 2.下载电影前面三个ts
//      await DownloadService.parseM3u8(vod).then((vm) async {
//        vod.metadataList = vm.metadataList; //主要是获取ts列表
//        if (vm.metadataList.isEmpty) {
//          LogUtil.v("vm.metadataList.isEmpty");
//        } else {
//          await cache();
//        }
//      });
//    });
//  }

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
    _mediaController.setNetworkDataSource(playUrl, autoPlay: true);

    _mediaController.getVideoInfo().then((videoInfo) {
      vod.progress = videoInfo.progress;
      vod..duration = videoInfo.duration;
      _mediaController.seekTo(vod.progress);
    });

    //initVOD();

    LocalStorage.saveHistoryVod(vod);
    LocalStorage.historyVoMap[vod.vodId] = vod;
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
