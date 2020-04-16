import 'package:flutter/material.dart';
import '../data/cache_data.dart';
import '../tv/tv_page.dart';
import '../tv/tv_rcmd_page.dart';
import '../video/program_video_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // bloc
import '../bloc/counter_bloc.dart'; // bloc
import '../data/cache_data.dart';
import '../global_config.dart';
import '../utils/log_util.dart';
import '../video/program_video_page.dart';
import './live_video_page.dart';
import '../video/moive_page.dart';
import '../video/svideo_page.dart';
import '../video/lala_page.dart';


class LiveHomePage extends StatefulWidget {
  @override
  _LiveHomePageState createState() => _LiveHomePageState();
}

class _LiveHomePageState extends State<LiveHomePage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
    LogUtil.v("initState setState()");
  }

  @override
  Widget build(BuildContext context) {
    final CounterBloc _counterBloc = BlocProvider.of<CounterBloc>(context);
    return new DefaultTabController(
      length: 10,
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
              new Tab(text: "美女啦啦"),
              new Tab(text: "NBA"),
              new Tab(text: "欧冠"),
              new Tab(text: "英超"),
              new Tab(text: "中超"),
              new Tab(text: "CBA"),
              new Tab(text: "电竞"),
              new Tab(text: "足球"),
              new Tab(text: "篮球世界杯"),
              new Tab(text: "综合"),
            ],
          ),
        ),
        body: new TabBarView(children: [
         // new SvideoPage(),
          new LalaPage(),
       //new MoviePage(column: 0),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[3], type: 1004),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[4], type: 1005),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[5], type: 1006),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[6], type: 1007),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[7], type: 1008),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[8], type: 1009),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[2], type: 1003),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[1], type: 1002),
          new ProgramVideoPage(vodList: sportsPlaybackVodList[9], type: 1010),

          // new TVPage(type: 5),
          // new TVPage(type: 6),
          // new TVPage(type: 7),
          //  new TVPage(type: 8),


          //new HomeDetail()
          //new HtmlPage(),
        ]),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }
}
