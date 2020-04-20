import 'package:flutter/material.dart';
import '../moive/moive_page.dart';
import '../moive/moive_rcmd_page.dart';
import '../global_config.dart';
import '../moive/moive_page.dart';
import '../utils/log_my_util.dart';
import '../data/cache_data.dart';
import '../video/program_video_page.dart';
import './carousel_page.dart';
import '../index/search_page.dart';
import '../video/svideo_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
    LogMyUtil.v("initState setState()");
  }

  @override
  Widget build(BuildContext context) {
    // LogUtil.v("_HomePageState build()");
    return new DefaultTabController(
      length:6,
      child: new Scaffold(
        appBar: new AppBar(
          title: new TabBar(
            isScrollable: true,
            labelColor:
                GlobalConfig.dark == true ? new Color(0xFF63FDD9) : Colors.blue,
            unselectedLabelColor:
                GlobalConfig.dark == true ? Colors.white : Colors.black,
            tabs: [
              new Tab(text: "热点推荐"),
             // new Tab(text: "综合频道"),
              new Tab(text: "央视频道"),
              new Tab(text: "体育频道"),
              new Tab(text: "娱乐卫视"),
              new Tab(text: "港澳频道"),
              new Tab(text: "国际频道"),


             // new Tab(text: "美女啦啦"),
            ],
          ),
        ),
        body: new TabBarView(children: [
          new CarouselPage(),
        //  new TvRcmdPage(),
          new TVPage(type: 1),
          new TVPage(type: 2),
          new TVPage(type: 3),
          new TVPage(type: 4),
          new TVPage(type: 5),
         // new SvideoPage(),
          //new Live1Page(),
        ]),
      ),
    );
  }

  Widget barSearch() {
    return new Container(
        height: 40,
        child: new FlatButton(
            onPressed: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (context) {
                return new SearchPage();
              }));
            },
            child: new Row(
              children: <Widget>[
                new Container(
                  child: new Icon(
                    Icons.search,
                    size: 18.0,
                  ),
                  margin: const EdgeInsets.only(right: 26.0),
                ),
                new Expanded(
                    child: new Container(
                  child: new Text("世界杯 NBA 英超 中超 CBA 排球"),
                )),
                new Container(
                  child: new FlatButton(
                    onPressed: () {},
                    child: new Icon(Icons.find_in_page, size: 18.0),
                  ),
                  width: 40.0,
                ),
              ],
            )),
        decoration: new BoxDecoration(
            borderRadius: const BorderRadius.all(const Radius.circular(4.0)),
            color: GlobalConfig.searchBackgroundColor));
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }
}
