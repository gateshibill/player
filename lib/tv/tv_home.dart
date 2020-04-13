import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // bloc
import '../bloc/counter_bloc.dart'; // bloc
import '../global_config.dart';
import '../program/program_page.dart';
import '../utils/log_util.dart';
import '../tv/tv_rcmd_page.dart';
import '../tv/tv_page.dart';
import '../home/news_page.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
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
      length: 5,
      child: new Scaffold(
        appBar: new AppBar(
          //title: barSearch(),
          title: new TabBar(
              isScrollable: true,
              labelColor: GlobalConfig.dark == true ? new Color(0xFF63FDD9) :
          Colors.blue,
          unselectedLabelColor: GlobalConfig.dark == true
              ? Colors.white
              : Colors.black,
          tabs: [
            new Tab(text: "精选体育频道"),
            new Tab(text: "央视体育频道"),
            new Tab(text: "国际体育频道"),
            new Tab(text: "地方体育频道"),
            new Tab(text: "综合频道"),
           // new Tab(text: "卫视娱乐"),
           // new Tab(text: "CCTV频道"),
           // new Tab(text: "港台频道"),
          //  new Tab(text: "国际频道"),
           // new Tab(text: "电视节目单"),
           // new Tab(text: "美女啦啦"),
          ],
        ),
      ),
      body: new TabBarView(
          children: [
            new TVPage(type: 0),
            new TVPage(type: 1),
            new TVPage(type: 2),
            new TVPage(type: 3),
            new TvRcmdPage(),
           // new TVPage(type: 5),
           // new TVPage(type: 6),
           // new TVPage(type: 7),
          //  new TVPage(type: 8),

            //new ProgramPage(day: 0),


            //new HomeDetail()
          ]
      ),
    ),);
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }


}
