import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:player/player/serial_detail.dart';
import '../global_config.dart';
import '../service/http_client.dart';
import '../player/video_detail.dart';
import '../utils/log_my_util.dart';
import '../utils/string_util.dart';
import '../data/cache_data.dart';
import '../common/widget_common.dart';
import '../model/vod_model.dart';
import '../player/movie_player.dart';
import '../program/details/program_detail.dart';
import '../index/search_page.dart';

class SerialPage extends StatefulWidget {
  SerialPage({Key key, @required this.column});
  int column;
  @override
  _SerialPageState createState() => _SerialPageState(column: this.column);
}

class _SerialPageState extends State<SerialPage> {
  _SerialPageState({Key key, @required this.column});
  ScrollController _scrollController = new ScrollController();
  int column;
  int page=1;

  @override
  void initState() {
    super.initState();
    setState(() {
      if(tvSerialVodList.length<1) {
        handleRefresh();
      }
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
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
          appBar: new AppBar(
            title: barSearch(),
          ),
          body: (tvSerialVodList.length < 1)
              ? refreshButton(this)
              : RefreshIndicator(
                  onRefresh: handleRefresh,
                  child: StreamBuilder(
                    //stream: _bloc.homeStream,
                    builder: (context, snapshot) {
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          //LogUtil.v("itemBuilder index:${index}");
                          return itemBuilder(context, index);
                        },
                        itemCount: tvSerialVodList.length ~/ 2,
                      );
                    },
                  ),
                )),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future handleRefresh() async {
    LogMyUtil.e("_handleRefresh");
    await HttpClientUtils.getTvSerials(0,30).then((list) {
      if (null != list) {
        tvSerialVodList = list.vodModelList;
        try {
          setState(() {});
        } catch (e) {}
      } else {
        LogMyUtil.e("fail to getTvSerials()");
      }
    });
    return;
  }

  Future _getMoreData() async {
    LogMyUtil.e("_getMoreData()");
    await HttpClientUtils.getTvSerials(page,30).then((list) {
      if (null != list) {
        List<VodModel> tmpList=list.vodModelList;
        if (tmpList != null && tmpList.length > 0) {
          tvSerialVodList.addAll(tmpList);
          page = page + 1;
          try {
            setState(() {});
          } catch (e) {}
        }
      } else {
        LogMyUtil.e("fail to get column vod");
      }
    });
    return;
  }

  Widget itemBuilder(BuildContext context, int index) {
    double width=160;
    return new Row(
         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new GestureDetector(
            onTap: () {
              if (null == tvSerialVodList[index].vodPlayUrl ||
                  "" == tvSerialVodList[index].vodPlayUrl) {
                LogMyUtil.v("playUrl is blank");
              } else {
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                      currentPlayMedia=tvSerialVodList[index];//为了显示标题
                  return new SerialDetail(vod: tvSerialVodList[index],context:this.context);
                }));
              }
            },
            child: new Column(
              children: <Widget>[
                new Container(
                  //Expanded(
                  // flex: 1,
                  // child: new AspectRatio(
                  //aspectRatio: 3.5 / 2,
                  width: width,
                  // height: 110,
                  child: new CachedNetworkImage(
                    imageUrl: "${tvSerialVodList[index * 2].vodPic}",
                    placeholder: (context, url) =>cachPlaceHolder(),
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                  ),

                  //),
                  margin: new EdgeInsets.only(top: 10.0, bottom: 6.0),
                  // alignment: Alignment.topLeft
                ),
                new Container(
                  width: width,
                  child: new Row(
                    children: <Widget>[
                      new Text(StrUtils.subString(tvSerialVodList[index * 2].vodName, 9),
                          style: new TextStyle(color: GlobalConfig.fontColor)),
                      //new Text("演员: ${widgets[index].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                    ],
                  ),
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
              ],
            ),
          ),
          new GestureDetector(
            onTap: () {
              if (null == tvSerialVodList[index * 2 + 1].vodPlayUrl ||
                  "" == tvSerialVodList[index * 2 + 1].vodPlayUrl) {
                LogMyUtil.v("playUrl is blank");
              } else {
                Navigator.of(context)
                    .push(new MaterialPageRoute(builder: (context) {
                  currentPlayMedia=tvSerialVodList[index * 2 + 1];//为了显示标题
                  return new SerialDetail(vod: tvSerialVodList[index * 2 + 1],context:this.context);
                }));
              }
            },
            child: new Column(
              children: <Widget>[
                new Container(
                    //Expanded(
                    // flex: 1,
                    // child: new AspectRatio(
                    //aspectRatio: 3.5 / 2,
                    width: width,
                    //height: 110,
                    child: new CachedNetworkImage(
                      imageUrl: "${tvSerialVodList[index * 2 + 1].vodPic}",
                      placeholder: (context, url) =>cachPlaceHolder(),
                      errorWidget: (context, url, error) =>
                          new Icon(Icons.error),
                    )

                    //),
                    // margin: new EdgeInsets.only(top: 6.0, bottom: 14.0),
                    // alignment: Alignment.topLeft
                    ),
                new Container(
                  width: width,
                  child: new Row(
                    children: <Widget>[
                      new Text(
                          StrUtils.subString(tvSerialVodList[index * 2 + 1].vodName, 9),
                          style: new TextStyle(color: GlobalConfig.fontColor)),
                      //new Text("演员: ${widgets[index].describes}", style: new TextStyle(color: GlobalConfig.fontColor))
                    ],
                  ),
                  padding: const EdgeInsets.only(bottom: 10.0),
                ),
              ],
            ),
          ),
        ]
        );
  }
  //搜索
  Widget barSearch() {
    return new Container(
        height: 38,
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
                  //child: new Text("世界杯 NBA 英超 中超 CBA 排球"),
                      child: new Text("搜索"),
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
}
