import 'package:flutter/material.dart';
import '../service/http_client.dart';
import '../data/cache_data.dart';
import '../utils/log_my_util.dart';
import '../model/client_action.dart';
import './program_page.dart';
import './league_page.dart';
import '../common/widget_common.dart';

class SportsPage extends StatefulWidget {
  @override
  _SportsPageState createState() => _SportsPageState();
}

class _SportsPageState extends State<SportsPage> {
  ScrollController _scrollController = new ScrollController();
  int day = 0;
  String dateStr = "";
  int page = 1;

//  List data = new List();
//
//  initData() {
//    for (var i = 0; i < 5; i++) {
//      data.add({
//        "title": "我是标题$i",
//        "subTitle": "我是副标题$i",
//        "imgUrl": "https://avatars3.githubusercontent.com/u/6915570?s=460&v=4"
//      });
//    }
//  }

  @override
  void initState() {
    super.initState();
    // initData();

    if (null == stypeList || 0 == stypeList.length) {
      handleRefresh();
    }
    setState(() {});
    LogMyUtil.v("initState setState()");
  }

  @override
  Widget build(BuildContext context) {
    ClientAction ca =
        new ClientAction(300 + day, "sportsPage", 0, "", 0, "", 1, "browse");
    HttpClientUtils.actionReport(ca);

    return (stypeList.length < 1)
        ? refreshButton(this)
        : ListView.separated(
            itemCount: stypeList.length,
            itemBuilder: (context, index) {
              return ListTile(
                  onTap: () {
                    Navigator.of(context)
                        .push(new MaterialPageRoute(builder: (context) {
                      return new LeaguePage(
                          day: 0, name: stypeList[index].name);
                    }));
                  },
                  leading: Image.network(stypeList[index].url),
                  title:
                      Text("${stypeList[index].name}"),
                 // Text("${stypeList[index].name}(${stypeList[index].num})"),
                  // subtitle: Text("${stypeList[index].num}"),
                  trailing: Icon(Icons.chevron_right));
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          );
  }

  @override
  void dispose() {
    super.dispose();
    //_controller.dispose();
  }

  Future handleRefresh() async {
    LogMyUtil.e("_handleRefresh");
    //List<ProgramModel> programList = [];
    await HttpClientUtils.getSportsTypes().then((list) {
      if (null != list) {
        stypeList = list;
        if (stypeList != null && stypeList.length > 0) {
          page = 1;
//          for (ProgramModel pm in programList) {
//            //缓存到本地"vod_0_"为首页栏目内容
//            LocalStorage.saveProgram(pm);
//          }
        }
        LogMyUtil.e("getSportsTypes lengh :${eventProgramlist.length}");
      } else {
        LogMyUtil.e("fail to getSportsTypes");
      }
      try {
        setState(() {});
      } catch (e) {
        LogMyUtil.e(e);
      }
    });
    // return programList;
  }
}
