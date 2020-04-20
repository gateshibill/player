import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // UI适配库
import 'package:cached_network_image/cached_network_image.dart';
import '../model/vod_model.dart';
import 'package:intl/intl.dart';
import '../global_config.dart';
import '../service/http_client.dart';
import '../common/widget_common.dart';
import '../common/player_controller.dart';
import '../utils/string_util.dart';
import '../utils/log_my_util.dart';

class PlayRcmdPage extends StatefulWidget {
  PlayRcmdPage({Key key, @required this.vod, this.pc});

  VodModel vod;
  PlayerController pc;

  @override
  _PlayRcmdPageState createState() =>
      _PlayRcmdPageState(vod: this.vod, pc: this.pc);
}

class _PlayRcmdPageState extends State<PlayRcmdPage> {
  _PlayRcmdPageState({Key key, @required this.vod, this.pc});

  VodModel vod;
  PlayerController pc;
  List<VodModel> rcmdList = [];

  @override
  void initState() {
    super.initState();
    handleRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color.fromRGBO(240, 240, 240, 1.0),
      padding: EdgeInsets.all(7.0),
      child: ListView(
        children: <Widget>[
          moreVideo(),
        ],
      ),
    );
  }

  // 下方列表
  Widget moreVideo() {
    if (rcmdList.length != 0) {
      List<Widget> list = [];
      rcmdList.forEach((e) {
        list.add(
          InkWell(
            onTap: () {
              this.pc.play(e.vodPlayUrl, e.vodName);
              this.vod = e;
            },
            child: Container(
              padding: EdgeInsets.all(2.0),
              margin: new EdgeInsets.only(top: 0.0, bottom: 6.0),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(width: 0.5, color: Colors.black26))),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4.0),
//                    child: Image.network('${e.vodPic}',
//                        width: ScreenUtil().setWidth(220),
//                        height: ScreenUtil().setHeight(100),
//                        fit: BoxFit.cover
//                    ),
                    child: new CachedNetworkImage(
                        imageUrl: "${e.vodPic}",
                        placeholder: (context, url) =>cachPlaceHolder(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                        width: ScreenUtil().setWidth(220),
                        height: ScreenUtil().setHeight(100),
                        fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          subString(e.vodName, 16),
                          maxLines: 1,
                        ),
                        Text(subString('观看次数：${e.vodHits}', 17), maxLines: 1),
                        Text(
                            subString(
                                " 上影时间：${DateFormat('yyyy-MM-dd kk:mm').format(new DateTime.fromMicrosecondsSinceEpoch(vod.vodTime * 1000 * 1000))}",
                                22),
                            maxLines: 1)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      });
      return Column(children: list);
    } else {
      return refreshButton(this);
    }
  }

  Future handleRefresh() async {
    LogMyUtil.e("_handleRefresh");
    await HttpClient.getRcmdVods(vod).then((list) {
      if (null != list) {
        rcmdList = list;
        try {
          setState(() {});
        } catch (e) {}
      } else {
        LogMyUtil.e("list is null");
      }
    });
    return;
  }
}
