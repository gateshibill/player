import 'package:flutter/material.dart';
import '../global_config.dart';
import '../utils/log_util.dart';
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
    LogUtil.v("initState setState()");
  }

  @override
  Widget build(BuildContext context) {
    // LogUtil.v("_HomePageState build()");
    return new DefaultTabController(
      length: 10,
      child: new Scaffold(
        appBar: new AppBar(
          title: new TabBar(
            isScrollable: true,
            labelColor:
                GlobalConfig.dark == true ? new Color(0xFF63FDD9) : Colors.blue,
            unselectedLabelColor:
                GlobalConfig.dark == true ? Colors.white : Colors.black,
            tabs: [
              new Tab(text: "热点"),
              new Tab(text: "NBA"),
              new Tab(text: "欧冠"),
              new Tab(text: "英超"),
              new Tab(text: "中超"),
              new Tab(text: "CBA"),
              new Tab(text: "电竞"),
              new Tab(text: "足球"),
              new Tab(text: "篮球世界杯"),
              new Tab(text: "综合"),
             // new Tab(text: "美女啦啦"),
            ],
          ),
        ),
        body: new TabBarView(children: [
          new CarouselPage(),
          // new LivePage(),
          //  new ProgramPage(),

          // new ProgramVideoPage(vodList: programVodList[0], type: 1001),

          new ProgramVideoPage(vodList: sportsPlaybackVodList[3], type: 1004),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[4], type: 1005),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[5], type: 1006),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[6], type: 1007),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[7], type: 1008),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[8], type: 1009),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[2], type: 1003),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[1], type: 1002),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[9], type: 1010),
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
