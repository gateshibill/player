import 'package:flutter/material.dart';
import '../global_config.dart';
import './program_event_page.dart';
import '../video/svideo_page.dart';
import '../utils/log_util.dart';
import './program_page.dart';
import 'package:intl/intl.dart';
import './sports_page.dart';
import 'sportshot_page.dart';

class ProgramHome extends StatefulWidget {
  @override
  _ProgramHomeState createState() => _ProgramHomeState();
}

class _ProgramHomeState extends State<ProgramHome> {
  TabBarView mytab;

  @override
  void initState() {
    super.initState();
    setState(() {
      mytab = MyTabBarView();
      //mytab.;
    });
    LogUtil.v("initState setState()");
  }

  @override
  Widget build(BuildContext context) {
    // LogUtil.v("_ProgramHomeState build()");
    String day1 = DateFormat('MM-dd')
        .format(new DateTime.now().add(new Duration(days: 1)));
    String day2 = DateFormat('MM-dd')
        .format(new DateTime.now().add(new Duration(days: 2)));
    String day3 = DateFormat('MM-dd')
        .format(new DateTime.now().add(new Duration(days: 3)));
    String day4 = DateFormat('MM-dd')
        .format(new DateTime.now().add(new Duration(days: 4)));
    String day5 = DateFormat('MM-dd')
        .format(new DateTime.now().add(new Duration(days: 5)));
    String day6 = DateFormat('MM-dd')
        .format(new DateTime.now().add(new Duration(days: 6)));

    return new DefaultTabController(
      length: 5,
      child: new Scaffold(
        appBar: new AppBar(
          //title: barSearch(),
          title: new TabBar(
            isScrollable: true,
            labelColor:
            GlobalConfig.dark == true ? new Color(0xFF63FDD9) : Colors.blue,
            unselectedLabelColor:
            GlobalConfig.dark == true ? Colors.white : Colors.black,
            tabs: [
              new Tab(text: "综合赛事"),
              new Tab(text: "热门赛事"),
              new Tab(text: "CCTV节目"),
              new Tab(text: "篮球世界杯"),
              new Tab(text: "美女啦啦队"),
//              new Tab(text: "西甲"),
//              new Tab(text: "NBA"),
//              new Tab(text: "中超"),
//              new Tab(text: "CBA"),
            ],
          ),
        ),
        body: mytab,
      ),
    );
  }

  TabBarView MyTabBarView() {
    return new TabBarView(children: [
      new SportsPage(), //总赛事
      new SportshotPage(day: 0, name: "热门"),
      // new NewsWebPage("http://sportslive.hongxiuba.com","积分榜"),
      new ProgramPage(day: 0), //普通节目单
      new ProgramEventPage(day: 0), //世界杯
//          new ProgramPage(day: 0),
//          new ProgramPage(day: 0),
//          new ProgramPage(day: 0),
//          new ProgramPage(day: 0)
      new SvideoPage()
    ]);
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }
}
