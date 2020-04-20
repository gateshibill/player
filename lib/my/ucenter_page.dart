import 'package:flutter/material.dart';
import '../global_config.dart';
import '../index/search_page.dart';
import '../resource/file_manager.dart';
import '../resource/local_storage.dart';
import './task_detail.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../model/vod_model.dart';
import '../resource/local_storage.dart';
import '../utils/log_my_util.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => new _MyPageState();
}

class _MyPageState extends State<MyPage> {
  int viewTaskCounter = 0;
  int viewFileCounter = 0;
  int viewCleanCounter = 0;
  List<VodModel> historyVodList = new List<VodModel>();

  Widget myInfoCard() {
    return new Container(
      color: GlobalConfig.cardBackgroundColor,
      margin: const EdgeInsets.only(top: 10.0, bottom: 6.0),
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
      child: new Column(
        children: <Widget>[
          new Container(
            margin:
                const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            decoration: new BoxDecoration(
                //color:  new Color(0xFFF5F5F5),
                borderRadius: new BorderRadius.all(new Radius.circular(6.0))),
            child: new FlatButton(
                onPressed: () {},
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
                      child: new Text("LVPlayer"),
                    ),
                    subtitle: new Container(
                      margin: const EdgeInsets.only(top: 2.0),
                      child: new Text("查看&编辑"),
                    ),
                  ),
                )),
          ),
          new Container(
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Container(
                  width: (MediaQuery.of(context).size.width - 6.0) / 4,
                  child: new FlatButton(
                      onPressed: () {},
                      child: new Container(
                        height: 50.0,
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                "57",
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    color: GlobalConfig.fontColor),
                              ),
                            ),
                            new Container(
                              child: new Text(
                                "我的积分",
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
                  width: (MediaQuery.of(context).size.width - 6.0) / 4,
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
                  width: (MediaQuery.of(context).size.width - 6.0) / 4,
                  child: new FlatButton(
                      onPressed: () {},
                      child: new Container(
                        height: 50.0,
                        child: new Column(
                          children: <Widget>[
                            new Container(
                              child: new Text(
                                "18",
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    color: GlobalConfig.fontColor),
                              ),
                            ),
                            new Container(
                              child: new Text(
                                "我的消息",
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
                    width: (MediaQuery.of(context).size.width - 6.0) / 4,
                    child: new FlatButton(
                        onPressed: () {},
                        child: new Container(
                          height: 50.0,
                          child: new Column(
                            children: <Widget>[
                              new Container(
                                child: new Text(
                                  "33",
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

  Widget settingCard() {
    return new Container(
      color: GlobalConfig.cardBackgroundColor,
      margin: const EdgeInsets.only(top: 6.0, bottom: 6.0),
      padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width / 4,
            child: new FlatButton(
                onPressed: () {},
                child: new Container(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: new CircleAvatar(
                          radius: 20.0,
                          child: new Icon(Icons.invert_colors,
                              color: Colors.white),
                          backgroundColor: new Color(0xFFB88800),
                        ),
                      ),
                      new Container(
                        child: new Text("讨论",
                            style: new TextStyle(
                                color: GlobalConfig.fontColor, fontSize: 14.0)),
                      )
                    ],
                  ),
                )),
          ),
          new Container(
            width: MediaQuery.of(context).size.width / 4,
            child: new FlatButton(
                onPressed: () {},
                child: new Container(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: new CircleAvatar(
                          radius: 20.0,
                          child:
                              new Icon(Icons.golf_course, color: Colors.white),
                          backgroundColor: new Color(0xFF63616D),
                        ),
                      ),
                      new Container(
                        child: new Text("反馈",
                            style: new TextStyle(
                                color: GlobalConfig.fontColor, fontSize: 14.0)),
                      )
                    ],
                  ),
                )),
          ),
          new Container(
            width: MediaQuery.of(context).size.width / 4,
            child: new FlatButton(
                onPressed: () {
                  setState(() {
                    if (GlobalConfig.dark == true) {
                      GlobalConfig.themeData = new ThemeData(
                        primaryColor: Colors.white,
                        scaffoldBackgroundColor: new Color(0xFFEBEBEB),
                      );
                      GlobalConfig.searchBackgroundColor =
                          new Color(0xFFEBEBEB);
                      GlobalConfig.cardBackgroundColor = Colors.white;
                      GlobalConfig.fontColor = Colors.black54;
                      GlobalConfig.dark = false;
                    } else {
                      GlobalConfig.themeData = new ThemeData.dark();
                      GlobalConfig.searchBackgroundColor = Colors.white10;
                      GlobalConfig.cardBackgroundColor = new Color(0xFF222222);
                      GlobalConfig.fontColor = Colors.white30;
                      GlobalConfig.dark = true;
                    }
                  });
                },
                child: new Container(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: new CircleAvatar(
                          radius: 20.0,
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
                            GlobalConfig.dark == true ? "日间模式" : "夜间模式",
                            style: new TextStyle(
                                color: GlobalConfig.fontColor, fontSize: 14.0)),
                      )
                    ],
                  ),
                )),
          ),
          new Container(
            width: MediaQuery.of(context).size.width / 4,
            child: new FlatButton(
                onPressed: () {},
                child: new Container(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: new CircleAvatar(
                          radius: 20.0,
                          child: new Icon(Icons.perm_data_setting,
                              color: Colors.white),
                          backgroundColor: new Color(0xFF636269),
                        ),
                      ),
                      new Container(
                        child: new Text("设置",
                            style: new TextStyle(
                                color: GlobalConfig.fontColor, fontSize: 14.0)),
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget veiwCache() {
    String sDCardDir;

    return new Container(
      // color: GlobalConfig.cardBackgroundColor,
      margin: const EdgeInsets.only(top: 6.0, bottom: 6.0),
      //  padding: const EdgeInsets.only(top: 12.0, bottom: 8.0),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Container(
            width: MediaQuery.of(context).size.width / 4,
            child: new FlatButton(
                onPressed: () {
                  setState(() {
                    if (GlobalConfig.dark == true) {
                      GlobalConfig.themeData = new ThemeData(
                        primaryColor: Colors.white,
                        scaffoldBackgroundColor: new Color(0xFFEBEBEB),
                      );
                      GlobalConfig.searchBackgroundColor =
                          new Color(0xFFEBEBEB);
                      GlobalConfig.cardBackgroundColor = Colors.white;
                      GlobalConfig.fontColor = Colors.black54;
                      GlobalConfig.dark = false;
                    } else {
                      GlobalConfig.themeData = new ThemeData.dark();
                      GlobalConfig.searchBackgroundColor = Colors.white10;
                      GlobalConfig.cardBackgroundColor = new Color(0xFF222222);
                      GlobalConfig.fontColor = Colors.white30;
                      GlobalConfig.dark = true;
                    }
                  });
                },
                child: new Container(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: new CircleAvatar(
                          radius: 20.0,
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
                            GlobalConfig.dark == true ? "日间模式" : "夜间模式",
                            style: new TextStyle(
                                color: GlobalConfig.fontColor, fontSize: 14.0)),
                      )
                    ],
                  ),
                )),
          ),
          new Container(
            width: MediaQuery.of(context).size.width / 4,
            child: new FlatButton(
                onPressed: () {
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
                },
                child: new Container(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: new CircleAvatar(
                          radius: 20.0,
                          child:
                              new Icon(Icons.attach_money, color: Colors.white),
                          backgroundColor: new Color(0xFF355A9B),
                        ),
                      ),
                      new Container(
                        child: new Text("task",
                            style: new TextStyle(
                                color: GlobalConfig.fontColor, fontSize: 14.0)),
                      )
                    ],
                  ),
                )),
          ),
          new Container(
            width: MediaQuery.of(context).size.width / 4,
            child: new FlatButton(
                onPressed: () {
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
                },
                child: new Container(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: new CircleAvatar(
                          radius: 20.0,
                          child: new Icon(Icons.radio, color: Colors.white),
                          backgroundColor: Colors.blue,
                        ),
                      ),
                      new Container(
                        child: new Text("view",
                            style: new TextStyle(
                                color: GlobalConfig.fontColor, fontSize: 14.0)),
                      )
                    ],
                  ),
                )),
          ),
          new Container(
            width: MediaQuery.of(context).size.width / 4,
            child: new FlatButton(
                onPressed: () {
                  viewCleanCounter++;
                  if (this.viewCleanCounter < 3) {
                    return;
                  } else {
                    LocalStorage.cleanCache();
                    LocalStorage.clear();
                    Fluttertoast.showToast(msg: 'clear success');
                  }
                },
                child: new Container(
                  child: new Column(
                    children: <Widget>[
                      new Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: new CircleAvatar(
                          radius: 20.0,
                          child: new Icon(Icons.wifi_tethering,
                              color: Colors.white),
                          backgroundColor: new Color(0xFF029A3F),
                        ),
                      ),
                      new Container(
                        child: new Text("clear",
                            style: new TextStyle(
                                color: GlobalConfig.fontColor, fontSize: 14.0)),
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    historyVodList = LocalStorage.historyVoMap.values.toList();
    LogMyUtil.v("historyVodList:lenght:${historyVodList.length}");
    return new MaterialApp(
        theme: GlobalConfig.themeData,
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
            body: Column(
                children: <Widget>[myInfoCard(), veiwCache()])));

  }

}
