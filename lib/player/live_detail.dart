import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // UI适配库
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import '../service/http_client.dart';
import '../utils/log_my_util.dart';
import '../model/client_action.dart';
import '../model/channel_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/cache_data.dart';
import './details/live_rcmd_page.dart';
import 'comment_detail.dart';
import '../common/player_controller.dart';
import '../service/local_storage.dart';

class LiveDetail extends StatefulWidget {
  LiveDetail({Key key, @required this.vod,this.context,this.mediaController});
  IjkMediaController mediaController;
  BuildContext context;
  ChannelModel vod;

  @override
  _LiveDetailState createState() => _LiveDetailState(channel: vod,context: context,mediaController: this.mediaController);
}

class TabTitle {
  String title;
  Widget widget;

  TabTitle(this.title, this.widget);
}

class _LiveDetailState extends State<LiveDetail>
    with SingleTickerProviderStateMixin {
  _LiveDetailState({Key key, @required this.channel,this.context,this.mediaController});
  BuildContext context;

  TextEditingController editingController = TextEditingController();
  IjkMediaController mediaController;
  ChannelModel channel;
  String playUrl;
  List<String> listSource = new List();
  int index = 0;
  String channelName;
  TabController mTabController;
  PageController mPageController = PageController(initialPage: 0);
  List<TabTitle> tabList;
  var isPageCanChanged = true;
  PlayerController pc;
  String title;

  @override
  void initState() {
    super.initState();
    LocalStorage.historyChannelMap[channel.id]=channel;
    LocalStorage.saveHistoryChannel(channel);

    pc = PlayerController();
    pc.mc = mediaController;
    //editingController.text =vod.name;
    LogMyUtil.v(channel.toString());
    playUrl = channel.playUrl;
    channel.reserveUrlList = new List();

    //备选播放串
    if (null != channel.reserveUrls) {
      channel.reserveUrlList = channel.reserveUrls.split(',');
    }
    channel.reserveUrlList.add(playUrl.trim());
    LogMyUtil.v("channel.reserveUrlList:${channel.reserveUrlList.length}");
    channelName = channel.name;
    startPlay(playUrl.trim());

    currentPlayMedia= channel;
    LocalStorage.savaCurrentMedia(currentPlayMedia);
    initTabData();
  }

  void fresh(){
    print("vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv:${currentPlayMedia.getName()}");
    try {
      setState(() {
        this.title=currentPlayMedia.getName();
      });
    } catch (e) {}
  }

  initTabData() {
    print("VideoPageState:" + channel.toString());
    tabList = [
      new TabTitle('猜你喜欢', LiveRcmdPage(vod: this.channel, pc: this.pc,callback: this.fresh)),
      new TabTitle('讨论区', CommentDetail()),
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
    this.mediaController.pause();
    mTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ClientAction ca = new ClientAction(2000, "liveplaydetail", 0, "",
        this.channel.id, this.channel.name, 2, "watch");
    HttpClientUtils.actionReport(ca);
    title= currentPlayMedia.getName();
    int row = sportsChannelList.length ~/ 2 - 1;
    print("row:$row");
    return Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(this.context).pop(),
        ),
        title: new Text(title),
      ),
      body: Column(
//        padding:
//            const EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5, right: 5),
        children: <Widget>[
          Container(
            height: 250,
            child: IjkPlayer(
              mediaController: mediaController,
            ),
          ),
//          Row(
//            children: <Widget>[
//              Expanded(
//                child: Text(channelName),
//              ),
////              FlatButton(
////                child: Text(currentI18n.play),
////                onPressed: _playInput,
////              ),
//            ],
//          ),
          Container(
            height: 35,
            width: MediaQuery.of(context).size.width - 140,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(width: 1, color: Color(0xffe5e5e5)))),
            child: new DropdownButtonHideUnderline(
                child: new DropdownButton(
              items: generateItemList(),
              hint: new Text('please choose'),
              onChanged: (value) {
                setState(() {
                  playUrl = value;
                  startPlay(playUrl);
                });
              },
//              isExpanded: true,
              value: playUrl,
              elevation: 24,
              //设置阴影的高度
              style: new TextStyle(
                //设置文本框里面文字的样式
                color: Color(0xff4a4a4a),
                fontSize: 12,
              ),
//              isDense: false,//减少按钮的高度。默认情况下，此按钮的高度与其菜单项的高度相同。如果isDense为true，则按钮的高度减少约一半。 这个当按钮嵌入添加的容器中时，非常有用
              iconSize: 40.0,
            )),
          ),
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
      ),
    );
  }

  Widget itemBuilder1(BuildContext context, int index) {
    // String url = programList[index].playUrl;
    return new Container(
      // color: GlobalConfig.cardBackgroundColor,
      margin: const EdgeInsets.only(top: 10.0, bottom: 0.0, left: 5, right: 5),
      // padding: const EdgeInsets.only(top: 12.0, bottom: 8.0, left: 5, right: 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new GestureDetector(
              onTap: () {
                print("Container clicked");
                startPlay(sportsChannelList[0][index * 2].playUrl);
                channelName = sportsChannelList[0][index * 2].name;
                channel = sportsChannelList[0][index * 2];
              },
              child: new Column(
                children: <Widget>[
                  new Container(
                      // child: new AspectRatio(
                      //   aspectRatio: 2.0 / 1,
                      width: 160,
                      child: new CachedNetworkImage(
                        imageUrl:
                            "${sportsChannelList[0][index * 2].posterUrl}",
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      )
                      // ),
                      //  margin: new EdgeInsets.only(top: 6.0, bottom: 14.0),
                      //alignment: Alignment.topLeft
                      ),
                  new Container(
                    child: new Text(sportsChannelList[0][index * 2].name),
                    //style: new TextStyle(
                    //color: GlobalConfig.fontColor, fontSize: 14.0)),
                  )
                ],
              )
              //)),
              ),
          new Container(
              child: new Column(
            children: <Widget>[
              new Container(
                //height: 100,
                width: 20,
//                    child: IjkPlayer(
//                      mediaController: mediaController,
//                    ),
              ),
            ],
          )
              //)),
              ),
          new GestureDetector(
              onTap: () {
                print("Container clicked");
                startPlay(sportsChannelList[0][index * 2 + 1].playUrl);
                channelName = sportsChannelList[0][index * 2 + 1].name;
                channel = sportsChannelList[0][index * 2 + 1];
              },
              child: new Column(
                children: <Widget>[
                  new Container(
                      width: 160,
                      //  margin: new EdgeInsets.only(top: 10.0, bottom: 0.0),
                      // child: new AspectRatio(
                      //  aspectRatio: 2.0 / 1.0,
                      child: new CachedNetworkImage(
                        imageUrl:
                            "${sportsChannelList[0][index * 2 + 1].posterUrl}",
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      )
                      // ),
                      //margin: new EdgeInsets.only(top: 10.0, bottom: 0.0),
                      // alignment: Alignment.topLeft
                      ),
                  new Container(
                    child: new Text(sportsChannelList[0][index * 2 + 1].name),
                    //style: new TextStyle(
                    //color: GlobalConfig.fontColor, fontSize: 14.0)),
                  )
                ],
              )),
        ],
      ),
    );
  }

  List<DropdownMenuItem> generateItemList() {
    List<DropdownMenuItem> items = new List();
    int counter = 0;
    for (String playUrl in channel.reserveUrlList) {
      print("channel.reserveUrlList: ${counter}:${playUrl}");
      if (null == playUrl || playUrl.length < 1) {
        continue;
      }
      counter++;
      DropdownMenuItem item = new DropdownMenuItem(
          value: playUrl, child: new Text('source$counter'));
      items.add(item);
    }
    return items;
  }

  Widget recommend() {
    if (index > sportsChannelList.length - 2) {
      index = 0;
    }
    return new Container(
      // color: GlobalConfig.cardBackgroundColor,
      margin: const EdgeInsets.only(top: 10.0, bottom: 0.0, left: 5, right: 5),
      // padding: const EdgeInsets.only(top: 12.0, bottom: 8.0, left: 5, right: 5),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new GestureDetector(
              onTap: () {
                print("Container clicked");
              },
              child: new Column(
                children: <Widget>[
                  new Container(
                      // child: new AspectRatio(
                      //   aspectRatio: 2.0 / 1,
                      width: 160,
                      child: new CachedNetworkImage(
                        imageUrl: "${sportsChannelList[0][index++].posterUrl}",
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      )
                      // ),
                      //  margin: new EdgeInsets.only(top: 6.0, bottom: 14.0),
                      //alignment: Alignment.topLeft
                      ),
                  new Container(
                    child: new Text(sportsChannelList[0][index].name),
                    //style: new TextStyle(
                    //color: GlobalConfig.fontColor, fontSize: 14.0)),
                  )
                ],
              )
              //)),
              ),
          new Container(
              child: new Column(
            children: <Widget>[
              new Container(
                //height: 100,
                width: 20,
//                    child: IjkPlayer(
//                      mediaController: mediaController,
//                    ),
              ),
            ],
          )
              //)),
              ),
          new GestureDetector(
              onTap: () {
                print("Container clicked");
              },
              child: new Column(
                children: <Widget>[
                  new Container(
                      width: 160,
                      //  margin: new EdgeInsets.only(top: 10.0, bottom: 0.0),
                      // child: new AspectRatio(
                      //  aspectRatio: 2.0 / 1.0,
                      child: new CachedNetworkImage(
                        imageUrl: "${sportsChannelList[0][index++].posterUrl}",
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      )
                      // ),
                      //margin: new EdgeInsets.only(top: 10.0, bottom: 0.0),
                      // alignment: Alignment.topLeft
                      ),
                  new Container(
                    child: new Text(sportsChannelList[0][index].name),
                    //style: new TextStyle(
                    //color: GlobalConfig.fontColor, fontSize: 14.0)),
                  )
                ],
              )),
        ],
      ),
    );
  }

  void startPlay(String playUrl) async {
    index = 0;
    await _playInput(playUrl);
  }

  Future _playInput(String playUrl) async {
    //mediaController.dispose();
    // mediaController.stop();
    if(null==mediaController){
      mediaController = new IjkMediaController();
      await mediaController.setNetworkDataSource(playUrl, autoPlay: true);
    }else {
      await mediaController.play();
    }
  }
}
