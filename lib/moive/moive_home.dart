import 'package:flutter/material.dart';
import '../live/live_video_page.dart';
import '../video/moive_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // bloc
import '../bloc/counter_bloc.dart'; // bloc
import '../global_config.dart';
import '../utils/log_my_util.dart';


class moivePage extends StatefulWidget {
  @override
  _moivePageState createState() => _moivePageState();
}

class _moivePageState extends State<moivePage> {
  @override
  void initState() {
    super.initState();
    setState(() {});
    LogMyUtil.v("initState setState()");
  }


  @override
  Widget build(BuildContext context) {
    final CounterBloc _counterBloc = BlocProvider.of<CounterBloc>(context);
    return new DefaultTabController(
      length: 6,
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
            new Tab(text: "电影"),
            new Tab(text: "综艺"),
            new Tab(text: "动作片"),
            new Tab(text: "爱情片"),
            new Tab(text: "喜剧片"),
            new Tab(text: "18+直播"),


          ],
        ),
      ),
      body: new TabBarView(
          children: [
            new MoviePage(column: 0),
            new MoviePage(column: 1),
            new MoviePage(column: 2),
            new MoviePage(column: 3),
            new MoviePage(column: 4),
            new LiveVideoPage(column: 0),


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
