
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '../global_config.dart';
import '../service/http_client.dart';
import '../player/video_detail.dart';
import '../utils/log_my_util.dart';
import '../utils/string_util.dart';
import '../data/cache_data.dart';
import '../common/widget_common.dart';
import '../model/vod_model.dart';
import '../resource/local_storage.dart';
import '../program/details/program_detail.dart';

class VodPage extends StatefulWidget {
  @override
  _VodPageState createState() => _VodPageState();
}

class _VodPageState extends State<VodPage> {
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    setState(() {
      handleRefresh();
      _scrollController.addListener(() {
        if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
          _getMoreData();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (movieList[1].length<1) ? refreshButton(this):RefreshIndicator(
      onRefresh: handleRefresh,
      child: StreamBuilder(
        //stream: _bloc.homeStream,
        builder: (context, snapshot) {
          return ListView.builder(
            itemBuilder: (BuildContext context, int index) {
              //LogUtil.v("itemBuilder index:${index}");
              return itemBuilder1(context, index);
            },
            itemCount: movieList[1].length,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
  Future handleRefresh() async {
    LogMyUtil.e("_handleRefresh");
    await HttpClient.getVodList(1).then((list) {
      if (null != list) {
        movieList[1] = list.vodModelList;
        for (VodModel m in movieList[1]) {
          //缓存到本地"vod_0_"为首页栏目内容
         // LocalStorage.saveVod(m,column:500);
        }
        try {
          setState(() {});
        } catch (e) {}
      } else {
        LogMyUtil.e("fail to get column vod");
      }
    });
    return;
  }
  Future _getMoreData() async {
    LogMyUtil.e("_getMoreData()");
  }

  Widget itemBuilder1(BuildContext context, int index) {
    return new Container(
        // margin: const EdgeInsets.only(top: 5.0, bottom: 5.0),
        color: GlobalConfig.cardBackgroundColor,
        child: new FlatButton(
          onPressed: () {
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new VideoDetail(vod: movieList[1][index]);
            }
            )
            );
          },
          child: new Column(
            children: <Widget>[
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Text(subString("${movieList[1][index].vodName}",23),
                        style: new TextStyle(color: GlobalConfig.fontColor)),
                  ],
                ),
                padding: const EdgeInsets.only(top: 10.0),
              ),
              new Container(
                  child: new AspectRatio(
                      aspectRatio: 3.5 / 2,
                      child: new CachedNetworkImage(
                        imageUrl: "${movieList[1][index].vodPic}",
                        placeholder: (context, url) =>
                            new CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                      )
                  ),
                  margin: new EdgeInsets.only(top: 10.0, bottom: 4.0),
                  alignment: Alignment.topLeft
              ),
              new Container(
                child: new Row(
                  children: <Widget>[
                    new Text(
                        DateFormat('yyyy-MM-dd kk:mm').format(new DateTime.fromMicrosecondsSinceEpoch(movieList[1][index].vodTime*1000*1000)),
                        style: new TextStyle(color: GlobalConfig.fontColor),
                        textAlign: TextAlign.center),
                    new Text("${movieList[1][index].vodActor}",
                        style: new TextStyle(color: GlobalConfig.fontColor),
                        textAlign: TextAlign.right),
                    new Icon(Icons.star, color: Colors.white),
                    new Icon(Icons.input, color: Colors.white),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
