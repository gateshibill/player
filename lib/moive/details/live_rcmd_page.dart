import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // UI适配库
import '../../data/cache_data.dart';
import '../../model/channel_model.dart';
import '../../common/player_controller.dart';

class LiveRcmdPage extends StatefulWidget {
  LiveRcmdPage({Key key, @required this.vod,this.pc,this.callback});
 PlayerController pc;
  ChannelModel vod;
  var callback;
  @override
  _LiveRcmdPageState createState() => _LiveRcmdPageState(vod: this.vod,pc:this.pc,callback:this.callback);
}

class _LiveRcmdPageState extends State<LiveRcmdPage> {
  _LiveRcmdPageState({Key key, @required this.vod,this.pc,this.callback});
  PlayerController pc;
  ChannelModel vod;
  var callback;

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
    if (tvChannelList[0].length != 0) {
      List<Widget> list = [];
      tvChannelList[0].forEach((e) {
        list.add(
          InkWell(
            onTap: () {
              pc.play(e);
              this.vod=e;
              if(null!=callback){
                print("ddddddddddddddddddddddddddddddddddddddd:${currentPlayMedia.getName()}");
                callback();
              }else{
                print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee:${currentPlayMedia.getName()}");
              }
            },
            child: Container(
              padding: EdgeInsets.all(8.0),
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
                        imageUrl: "${e.posterUrl}",
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
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
                          e.name,
                          maxLines: 1,
                        ),
//                        Text('导演：${e.name}', maxLines: 1),
//                        Text('主演：${e.desc}', maxLines: 1)
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
      return Text('没数据');
    }
  }
}
