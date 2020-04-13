import 'package:flutter/material.dart';
import 'navigation_icon_view.dart';
import '../my/my_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../config/i18n/i18n.dart';
import '../home/home_page.dart';
import '../tv/tv_home.dart';
import '../program/program_home.dart';
import '../live/live_home_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../service/http_upgrade.dart';
import '../data/cache_data.dart';
import 'package:flutter/services.dart';

class Index extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: new AppBar(
//        title: new Text("p2player"),
//      ),
      body: MainPageWidget(),
    );
  }
}

class MainPageWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MainPageState();
  }
}

class MainPageState extends State<MainPageWidget>
    with TickerProviderStateMixin {
  int _currentIndex = 0;
  List<NavigationIconView> _navigationViews;
  List<Widget> _pageList;
  StatefulWidget _currentPage;
  String sDCardDir;
  DateTime lastPopTime;

  @override
  void initState() {
    super.initState();
    HttpUpgrade.showUpgrade(context);
    _navigationViews = <NavigationIconView>[
//      new NavigationIconView(
//        icon: new Icon(Icons.assignment),
//        title: new Text("首页"),
//        vsync: this,
//      ),
      new NavigationIconView(
        icon: new Icon(Icons.home),
        title: new Text(currentI18n.bottonNavigateHome),
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.date_range),
        title: new Text(currentI18n.bottonNavigateSchedule),
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.live_tv),
        title: new Text(currentI18n.bottonNavigateTv),
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.child_care),
        title: new Text(currentI18n.bottonNavigateTricks),
        vsync: this,
      ),
      new NavigationIconView(
        icon: new Icon(Icons.perm_identity),
        title: new Text(currentI18n.bottonNavigateMy),
        vsync: this,
      ),
    ];
    for (NavigationIconView view in _navigationViews) {
      view.controller.addListener(_rebuild);
    }
    //print("inddex sDCardDir"+sDCardDir);
    _pageList = <Widget>[
      //new CarouselPage(),
      new HomePage(),
      new ProgramHome(),
      new VideoPage(),
      new LiveHomePage(),
      new MyPage()
    ];
    _currentPage = _pageList[_currentIndex];
  }

  void _rebuild() {
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    for (NavigationIconView view in _navigationViews) {
      view.controller.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    final BottomNavigationBar bottomNavigationBar = new BottomNavigationBar(
        items: _navigationViews
            .map((NavigationIconView navigationIconView) =>
                navigationIconView.item)
            .toList(),
        currentIndex: _currentIndex,
        fixedColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _navigationViews[_currentIndex].controller.reverse();
            _currentIndex = index;
            _navigationViews[_currentIndex].controller.forward();
            _currentPage = _pageList[_currentIndex];
          });
        });
    return new WillPopScope(
      onWillPop:() async{
        // 点击返回键的操作
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime) > Duration(seconds: 2)) {
          lastPopTime = DateTime.now();
          Fluttertoast.showToast(msg: '再按一次退出', gravity: ToastGravity.BOTTOM);
        } else {
          return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('是否退出应用？'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('否'),
                ),
                new FlatButton(
                  onPressed: () {
                   // print("exit-------------------------------------eixt");
                    homeMediaController.reset();
                   // SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                    //SystemChannels.
                    Navigator.of(context).pop(true);

                  },
                  child: new Text('是'),
                ),
              ],
            ),
          ) ??
              false;
        }

      },
      // return new MaterialApp(
      child: new Scaffold(
        body: new Center(child: _currentPage),
        bottomNavigationBar: bottomNavigationBar,
      ),
      // theme: GlobalConfig.themeData
    );
  }
}
