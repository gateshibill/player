import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../global_config.dart';
import '../model/client_action.dart';
import '../resource/file_manager.dart';
import '../service/local_storage.dart';
import './task_detail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/vod_model.dart';
import '../player/video_detail.dart';
import '../utils/log_my_util.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../utils/string_util.dart';
import 'package:share/share.dart';
import '../config/config.dart';
import '../service/http_upgrade.dart';
import './pnode_page.dart';
import './login/login_page.dart';

import '../service/http_client.dart';
import '../common/widget_common.dart';
import '../model/channel_model.dart';
import '../moive/details/live_detail.dart';
import '../data/cache_data.dart';
import 'charge_page.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int viewTaskCounter = 0;
  int viewFileCounter = 0;
  int viewCleanCounter = 0;
  int viewMessageCounter = 0;
  List<VodModel> historyVodList = new List<VodModel>();
  List<ChannelModel> historyChannelList = new List<ChannelModel>();
  List<ChannelModel> guessChannelList = new List<ChannelModel>();
  int _selectDrawItemIndex = -1;

  //bool isLogin;

  @override
  Widget build(BuildContext context) {
    ClientAction ca = new ClientAction(5, "mypage", 0, "", 0, "", 1, "bowser");
    HttpClientUtils.actionReport(ca);
    return new MaterialApp(
        theme: GlobalConfig.themeData,
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          appBar: new AppBar(
//            leading: new IconButton(
//              padding: EdgeInsets.all(2.0),
//              icon: new Icon(Icons.brightness_7, color: Colors.white),
//              onPressed: () {
//                //Navigator.of(context).pop();
//              },
//            ),
            centerTitle: true,
            title: new Text("个人中心"),
            actions: <Widget>[
              new Container(
                margin: EdgeInsets.only(right: 15.0),
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Container(
//                    child: new Text("分享"),
                        child: new FlatButton(
                            onPressed: () {
//                                FlutterWechat.shareText(
//                                  text: "test",
//                                  type: 0,
//                                ); //文字分享 type 0 聊天页面 1 朋友圈
                              Share.share('live&video\n $HOME_URL');
                            },
                            child: new Text("分享"))),
                  ],
                ),
              )
            ],
          ),
          body: new SingleChildScrollView(
              child: new ConstrainedBox(
                  constraints: new BoxConstraints(
                    minHeight: 120.0,
                  ),
                  child: new Column(children: <Widget>[
                    myInfoCard(),
                    historyChannel(),
                    guess(),
                    history(),
                  ]))),
          drawer: Drawer(
            child: _onDrawViewPage(),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    //  isLogin = LocalDataProvider.getInstance().isLogin();
    historyVodList =
        LocalStorage.historyVoMap.values.toList().reversed.toList();
    historyChannelList =
        LocalStorage.historyChannelMap.values.toList().reversed.toList();
    guessChannelList.insertAll(
        0,
        sportsChannelList[0].length > 0
            ? sportsChannelList[0]
            : historyChannelList);
    guessChannelList.shuffle();
  }

  Widget myInfoCard() {
    return new Container(
      color: GlobalConfig.cardBackgroundColor,
      margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: new Column(
        children: <Widget>[
          new Container(
            margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 1.0),
            decoration: new BoxDecoration(
                //color:  new Color(0xFFF5F5F5),
                borderRadius: new BorderRadius.all(new Radius.circular(6.0))),
            child: new FlatButton(
                onPressed: () {
                  if (me.isLogin) {
                    Fluttertoast.showToast(
                        msg: '已经登录', gravity: ToastGravity.TOP);
                    return;
                  } else {
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new LoginPage();
                    }));
                  }
                },
                child: new Container(
                  child: new ListTile(
                    leading: new Container(
                      child: new CircleAvatar(
                          backgroundImage: new NetworkImage(
                              "https://pic1.zhimg.com/v2-ec7ed574da66e1b495fcad2cc3d71cb9_xl.jpg"),
                          radius: 20.0),
                    ),
                    title: new Container(
                      margin: const EdgeInsets.only(bottom: 2.0),
                      child: new Text(
                          me.isLogin ? "${me.userNickName}" : "LVPlayer"),
                    ),
                    subtitle: new Container(
                      margin: const EdgeInsets.only(top: 2.0),
                      child: new Text(me.isLogin ? "已登录" : "未登录"),
                    ),
                    trailing: new Container(
                      width: MediaQuery.of(context).size.width / 4,
                      child: new FlatButton(
                          onPressed: () {
                            setState(() {
                              if (GlobalConfig.dark == true) {
                                GlobalConfig.themeData = new ThemeData(
                                  primaryColor: Colors.white,
                                  scaffoldBackgroundColor:
                                      new Color(0xFFEBEBEB),
                                );
                                GlobalConfig.searchBackgroundColor =
                                    new Color(0xFFEBEBEB);
                                GlobalConfig.cardBackgroundColor = Colors.white;
                                GlobalConfig.fontColor = Colors.black54;
                                GlobalConfig.dark = false;
                              } else {
                                GlobalConfig.themeData = new ThemeData.dark();
                                GlobalConfig.searchBackgroundColor =
                                    Colors.white10;
                                GlobalConfig.cardBackgroundColor =
                                    new Color(0xFF222222);
                                GlobalConfig.fontColor = Colors.white30;
                                GlobalConfig.dark = true;
                              }
                            });
                          },
                          child: new Container(
                            child: new Column(
                              children: <Widget>[
                                new Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 0.0, top: 2.0),
                                  child: new CircleAvatar(
                                    radius: 16.0,
                                    child: new Icon(
                                        GlobalConfig.dark == true
                                            ? Icons.wb_sunny
                                            : Icons.brightness_2,
                                        color: Colors.white),
                                    backgroundColor: new Color(0xFFB86A0D),
                                  ),
                                ),
                                new Container(
                                  child: new Text(
                                      GlobalConfig.dark == true
                                          ? "日间模式"
                                          : "夜间模式",
                                      style: new TextStyle(
                                          color: GlobalConfig.fontColor,
                                          fontSize: 12.0)),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                )),
          ),
          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: (MediaQuery.of(context).size.width - 30.0) / 3,
                  child: new FlatButton(
                      onPressed: () {
//                        if(null==me.userId){
//
//                        }
                        Navigator.of(context)
                            .push(new MaterialPageRoute(builder: (context) {
                          return ChargePage();
                        }));
                      },
                      child: new Container(
                        height: 50.0,
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                (null == (me.vipExpire))
                                    ? "立即充值"
                                    : DateFormat('yyyy:kk:mm')
                                        .format(me.vipExpire),
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    color: GlobalConfig.fontColor),
                              ),
                            ),
                            new Container(
                              child: new Text(
                                "VIP会员",
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    color: GlobalConfig.fontColor),
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
                new Container(
                  height: 14.0,
                  width: 1.0,
                  decoration: new BoxDecoration(
                      border: new BorderDirectional(
                          start: new BorderSide(
                              color: GlobalConfig.dark == true
                                  ? Colors.white12
                                  : Colors.black12,
                              width: 1.0))),
                ),
                new Container(
                  width: (MediaQuery.of(context).size.width - 50.0) / 4,
                  child: new FlatButton(
                      onPressed: () {},
                      child: new Container(
                        height: 50.0,
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                "210",
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    color: GlobalConfig.fontColor),
                              ),
                            ),
                            new Container(
                              child: new Text(
                                "我的收藏",
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    color: GlobalConfig.fontColor),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                new Container(
                  height: 14.0,
                  width: 1.0,
                  decoration: new BoxDecoration(
                      border: new BorderDirectional(
                          start: new BorderSide(
                              color: GlobalConfig.dark == true
                                  ? Colors.white12
                                  : Colors.black12,
                              width: 1.0))),
                ),
                new Container(
                  width: (MediaQuery.of(context).size.width - 50.0) / 4,
                  child: new FlatButton(
                      onPressed: () {
                        this.viewMessageCounter++;
                        if (this.viewMessageCounter < 3) {
                          return;
                        } else {
                          Navigator.of(context)
                              .push(new MaterialPageRoute(builder: (context) {
                            return new PnodePage();
                          }));
                          this.viewMessageCounter = 0;
                        }
                      },
                      child: new Container(
                        height: 50.0,
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                "${historyChannelList.length}",
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    color: GlobalConfig.fontColor),
                              ),
                            ),
                            new Container(
                              child: new Text(
                                "我的频道",
                                style: new TextStyle(
                                    fontSize: 12.0,
                                    color: GlobalConfig.fontColor),
                              ),
                            )
                          ],
                        ),
                      )),
                ),
                new Container(
                  height: 14.0,
                  width: 1.0,
                  decoration: new BoxDecoration(
                      border: new BorderDirectional(
                          start: new BorderSide(
                              color: GlobalConfig.dark == true
                                  ? Colors.white12
                                  : Colors.black12,
                              width: 1.0))),
                ),
                new Container(
                    width: (MediaQuery.of(context).size.width - 50.0) / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          height: 50.0,
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                child: new Text(
                                  '${historyVodList.length - 1}',
                                  style: new TextStyle(
                                      fontSize: 16.0,
                                      color: GlobalConfig.fontColor),
                                ),
                              ),
                              new Container(
                                child: new Text(
                                  "最近浏览",
                                  style: new TextStyle(
                                      fontSize: 12.0,
                                      color: GlobalConfig.fontColor),
                                ),
                              )
                            ],
                          ),
                        )))
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget history() {
    return new Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Text("视频浏览",
              style: new TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left),
          Container(
            height: 300,
            padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
            child: StreamBuilder(
              builder: (context, snapshot) {
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return itemBuilder1(context, index);
                  },
                  itemCount: historyVodList.length,
                  scrollDirection: Axis.horizontal,
                );
              },
            ),
          ),
        ]);
  }

  Widget historyChannel() {
    return new Column(children: <Widget>[
      new Text("频道历史",
          style: new TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left),
      Container(
        height: 140,
        padding: const EdgeInsets.only(top: 0.0, bottom: 1.0),
        child: StreamBuilder(
          builder: (context, snapshot) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return itemBuilderChannel(context, index);
              },
              itemCount: historyChannelList.length,
              scrollDirection: Axis.horizontal,
            );
          },
        ),
      ),
    ]);
  }

  Widget guess() {
    return new Column(children: <Widget>[
      new Text("猜你喜欢",
          style: new TextStyle(
              color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left),
      Container(
        height: 150,
        padding: const EdgeInsets.only(top: 0.0, bottom: 10.0),
        child: StreamBuilder(
          builder: (context, snapshot) {
            return ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return itemBuilderGuess(context, index);
              },
              itemCount: guessChannelList.length,
              scrollDirection: Axis.horizontal,
            );
          },
        ),
      ),
    ]);
  }

  Widget _onDrawViewPage() {
    return Column(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text('联系客服'),
          accountEmail: Text('customerservice@hongxiuba.com'),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage(
              'assets/images/customerqrcode.png',
            ),
          ),
//          onDetailsPressed: () {
//            Fluttertoast.showToast(msg: '请加微信留言', gravity: ToastGravity.TOP);
//          },
          otherAccountsPictures: <Widget>[
            new CircleAvatar(
              backgroundImage: AssetImage('assets/images/drawhead.png'),
              radius: 15,
            ),
          ],
          margin: EdgeInsets.zero,
        ),
        gestureDetectorForItem(
            Icons.library_books, '设置', 0, _selectDrawItemIndex),
        gestureDetectorForItem(Icons.image, '任务', 1, _selectDrawItemIndex),
        gestureDetectorForItem(Icons.live_tv, '缓存', 2, _selectDrawItemIndex),
        gestureDetectorForItem(Icons.settings, '清理', 3, _selectDrawItemIndex),
        gestureDetectorForItem(
            Icons.settings, '版本($VERSION)', 4, _selectDrawItemIndex),
      ],
    );
  }

  GestureDetector gestureDetectorForItem(IconData icon, String title,
      int drawItemIndex, int _selectDrawItemIndex) {
    String sDCardDir;
    return GestureDetector(
      child: Container(
        color:
            _selectDrawItemIndex == drawItemIndex ? Colors.grey : Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              child: Icon(
                icon,
                color: _selectDrawItemIndex == drawItemIndex
                    ? Colors.red
                    : Colors.grey,
              ),
              margin: EdgeInsets.all(16.0),
            ),
            Container(
              child: Text(
                title,
                style: TextStyle(
                    color: _selectDrawItemIndex == drawItemIndex
                        ? Colors.red
                        : Colors.black),
              ),
              margin: EdgeInsets.all(16.0),
            )
          ],
        ),
      ),
      onTap: () {
        if (drawItemIndex == 1) {
          this.viewTaskCounter++;
          if (this.viewTaskCounter < 3) {
            return;
          } else {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new TaskDetail();
            }));
            this.viewTaskCounter = 0;
          }
        } else if (drawItemIndex == 2) {
          this.viewFileCounter++;
          if (this.viewFileCounter < 3) {
            return;
          } else {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new FileManager(sDCardDir: sDCardDir);
            }));
            this.viewFileCounter = 0;
          }
        } else if (drawItemIndex == 3) {
          viewCleanCounter++;
          if (this.viewCleanCounter < 3) {
            return;
          } else {
            LocalStorage.cleanCache();
            LocalStorage.clear();
            Fluttertoast.showToast(msg: 'clear success');
          }
        } else if (4 == drawItemIndex) {
          HttpUpgrade.showUpgrade(context);
        }
        _onDrawItemSelect(drawItemIndex);
      },
    );
  }

  _onDrawItemSelect(int drawItemIndex) {
    _selectDrawItemIndex = drawItemIndex;
    setState(() {});
  }

  Widget itemBuilder1(BuildContext context, int index) {
    String url = historyVodList[index].vodPlayUrl;
    double picWidth = 160;
    return new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              if (null == historyVodList[index].vodPlayUrl ||
                  "" == historyVodList[index].vodPlayUrl) {
                LogMyUtil.v("playUrl is blank");
              } else {
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                  return new VideoDetail(vod: historyVodList[index]);
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
                  width: picWidth,
                  // height: 110,
                  child: new CachedNetworkImage(
                    imageUrl: "${historyVodList[index].vodPic}",
                    placeholder: (context, url) => cachPlaceHolder(),
                    errorWidget: (context, url, error) =>
                        new Icon(Icons.autorenew),
                  ),

                  //),
                  margin: new EdgeInsets.only(
                      top: 6.0, bottom: 6.0, left: 10, right: 10),
                  // alignment: Alignment.topLeft
                ),
                new Container(
                  width: picWidth,
                  child: new Row(
                    children: <Widget>[
                      new Text(
                          StrUtils.subString(historyVodList[index].vodName, 9),
                          style: new TextStyle(color: GlobalConfig.fontColor)),
                      //new Text("演员: ${widgets[index].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                    ],
                  ),
                  // padding: const EdgeInsets.only(bottom: 10.0),
                ),
              ],
            ),
          ),
        ]
        // )
        );
  }

  Widget itemBuilderChannel(BuildContext context, int index) {
    double picWidth = 160;
    return new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          new GestureDetector(
            onTap: () {
              if (null == historyChannelList[index].getPlayUrl() ||
                  "" == historyChannelList[index].getPlayUrl()) {
                LogMyUtil.v("playUrl is blank");
              } else {
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                  return new LiveDetail(vod: historyChannelList[index]);
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
                  width: picWidth,
                  // height: 110,
                  child: new CachedNetworkImage(
                    imageUrl: "${historyChannelList[index].posterUrl}",
                    placeholder: (context, url) => cachPlaceHolder(),
                    errorWidget: (context, url, error) =>
                        new Icon(Icons.autorenew),
                  ),

                  //),
                  margin: new EdgeInsets.only(
                      top: 6.0, bottom: 6.0, left: 10, right: 10),
                  // alignment: Alignment.topLeft
                ),
                new Container(
                  width: picWidth,
                  child: new Row(
                    children: <Widget>[
                      new Text(
                          StrUtils.subString(
                              historyChannelList[index].getName(), 9),
                          style: new TextStyle(color: GlobalConfig.fontColor)),
                      //new Text("演员: ${widgets[index].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                    ],
                  ),
                  // padding: const EdgeInsets.only(bottom: 5.0),
                ),
              ],
            ),
          ),
        ]
        // )
        );
  }

  Widget itemBuilderGuess(BuildContext context, int index) {
    double picWidth = 160;
    return new Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        // mainAxisAlignment: MainAxisAlignment.center,

        children: <Widget>[
          new GestureDetector(
            onTap: () {
              if (null == guessChannelList[index].getPlayUrl() ||
                  "" == guessChannelList[index].getPlayUrl()) {
                LogMyUtil.v("playUrl is blank");
              } else {
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                  return new LiveDetail(vod: guessChannelList[index]);
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
                  width: picWidth,
                  // height: 110,
                  child: new CachedNetworkImage(
                    imageUrl: "${guessChannelList[index].posterUrl}",
                    placeholder: (context, url) => cachPlaceHolder(),
                    errorWidget: (context, url, error) =>
                        new Icon(Icons.autorenew),
                  ),

                  //),
                  margin: new EdgeInsets.only(
                      top: 6.0, bottom: 6.0, left: 10, right: 10),
                  // alignment: Alignment.topLeft
                ),
                new Container(
                  width: picWidth,
                  child: new Row(
                    children: <Widget>[
                      new Text(
                          StrUtils.subString(
                              guessChannelList[index].getName(), 9),
                          style: new TextStyle(color: GlobalConfig.fontColor)),
                      //new Text("演员: ${widgets[index].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                    ],
                  ),
                  // padding: const EdgeInsets.only(bottom: 5.0),
                ),
              ],
            ),
          ),
        ]
        // )
        );
  }
}
