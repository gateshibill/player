import 'package:flutter/material.dart';
import 'dart:convert';
import '../model/video_context_model.dart'; // 模型
import '../service/service_method.dart'; // 网络请求
import 'package:flutter_easyrefresh/easy_refresh.dart'; // 上下拉
import 'package:flutter_easyrefresh/bezier_circle_header.dart'; // 上下拉 头
import 'package:flutter_easyrefresh/bezier_bounce_footer.dart'; // 上下拉 尾
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart'; // 瀑布流
import '../service/http_client.dart'; // 视频详情
import 'package:flutter_bloc/flutter_bloc.dart'; // bloc
import '../bloc/counter_bloc.dart'; // bloc
import 'package:cached_network_image/cached_network_image.dart';
import '../model/client_action.dart';
import '../common/widget_common.dart';
import '../player/video_detail.dart';
import '../data/cache_data.dart';
import '../common/view_picture_page1.dart';
import '../service/http_client.dart';
import '../model/picture_model.dart';
import 'dart:math';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class LalaPage extends StatefulWidget {
  static int page = Random().nextInt(6); // 第一个数据标示
  static bool isbusy = false;

  @override
  _LalaPageState1 createState() => new _LalaPageState1();
}

class _LalaPageState1 extends State<LalaPage> {
  @override
  Widget build(BuildContext context) {
    ClientAction ca =
        new ClientAction(203, "lalaPage", 0, "", 0, "", 1, "browse");
    HttpClientUtils.actionReport(ca);

    final CounterBloc _counterBloc = BlocProvider.of<CounterBloc>(context);
    return BlocBuilder(
      bloc: _counterBloc,
      builder: (BuildContext context, Map theme) {
        return Scaffold(
          body: MainVideo(),
        );
      },
    );
  }
}

class MainVideo extends StatefulWidget {
  @override
  _MainVideoState createState() => _MainVideoState();
}

class _MainVideoState extends State<MainVideo>
    with AutomaticKeepAliveClientMixin {
//
  // List lalas = []; // 数据数组
  List<NetworkImage> networkImages = [];
  Map<int, NetworkImage> networkImageMap = new Map();

  void initState() {
    super.initState();
    LalaPage.isbusy = false;
    if (lalas.length < 1) {
      _getVideoData();
    } else {
      lalas.shuffle();
    }
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    networkImages.clear();
    return EasyRefreshView();
  }

  Widget EasyRefreshView() {
    return lalas.length < 1
        ? refreshButton(this)
        : EasyRefresh(
            child: _waterFall(),
            onRefresh: () async {
              _getVideoData();
            },
            onLoad: () async {
              _getVideoData();
            },
          );
  }

  // 没有数据时展示
  Widget _noData() {
    return Center(
      child: InkWell(
        onTap: () {
          setState(() {
            lalas = [];
          });
          LalaPage.page = 0;
          _getVideoData();
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //Text('空空无也,点我重新加载^_^'),
            refreshButton(this),
            //Image.asset('images/pages/noData.jpeg')
          ],
        ),
      ),
    );
  }

  // 瀑布流
  Widget _waterFall() {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: lalas.length,
      itemBuilder: (BuildContext context, int index) => Container(
        child: InkWell(
          onTap: () {
            print("index:${index}|lalas:${lalas.length}");
            //为了从当前位置开始浏览gallery
            List<String> networkImagesTmp = [];
            List<String> networkImagesTmp1 = [];

            //networkImagesTmp.addAll(networkImages.sublist(index));
            int i=0;
            for (int i=0;i<lalas.length;i++) {
              if (index > i) {
                networkImagesTmp1.add(lalas[i].url);
              } else {
                networkImagesTmp.add(lalas[i].url);
              }
            }
            networkImagesTmp.addAll(networkImagesTmp1);
//            if (index > 0) {
//              //加上当前位置前部分
//              networkImagesTmp.addAll(networkImages.sublist(0, index - 1));
//            }
            Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) {
              return new ViewPicturePage1(networkImages: networkImagesTmp);
            })
            );

            //为了从当前位置开始浏览gallery
//            List<NetworkImage> networkImagesTmp = [];
//            List<NetworkImage> networkImagesTmp1 = [];
//
//            //networkImagesTmp.addAll(networkImages.sublist(index));
//            for (int key in networkImageMap.keys.toList()) {
//              if (index > key) {
//                networkImagesTmp1.add(networkImageMap[key]);
//              } else {
//                networkImagesTmp.add(networkImageMap[key]);
//              }
//            }
//            networkImagesTmp.addAll(networkImagesTmp1);
////            if (index > 0) {
////              //加上当前位置前部分
////              networkImagesTmp.addAll(networkImages.sublist(0, index - 1));
////            }
//            Navigator.of(context)
//                .push(new MaterialPageRoute(builder: (context) {
//              return new ViewPicturePage(networkImages: networkImagesTmp);
//            })
//            );
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
//                    child: FadeInImage.assetNetwork(
//                      placeholder: 'images/pages/placeholder.jpg',
//                      fit: BoxFit.fill,
//                      image: lalas[index].url,
//                    ),
                child:
                    //imageContainer(index, lalas[index].url)
                    CachedNetworkImage(
                  imageUrl: lalas[index].url,
                  fit: BoxFit.fill,
                  placeholder: (context, url) => cachPlaceHolder(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),
                ),
              ),
              Text('${lalas[index].id}'),
            ],
          ),
        ),
      ),
      staggeredTileBuilder: (int index) =>
          StaggeredTile.count(2, index.isEven ? 3 : 3),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }

  Widget imageContainer(int index, String url) {
    NetworkImage networkImage = new NetworkImage(url);
    this.networkImages.add(networkImage);
    networkImageMap[index] = networkImage;
//    return PhotoView(
//      imageProvider: networkImage,
//        onTapUp:ff;
//    );
    return new Image(
      fit: BoxFit.fill,
      image: networkImage,
    );
  }
//  Widget imageCacheContainer(String url) {
//    CachedNetworkImage cni=new CachedNetworkImage(
//      imageUrl: url,
//      fit: BoxFit.fill,
//      placeholder: (context, url) => cachPlaceHolder(),
//      errorWidget: (context, url, error) => new Icon(Icons.error),
//    );
//    //cni.
//    return cni;
//  }
  // 获取视频一级数据
  void _getVideoData() async {
    if (LalaPage.isbusy) {
      return;
    }
    LalaPage.isbusy = true;
    LalaPage.page += 1;
    await HttpClientUtils.getLalas(LalaPage.page, 6).then((list) {
      if (null != list && list.length > 0) {
        lalas.addAll(list);
        //LalaPage.page = LalaPage.page + 1;
        try {
          setState(() {});
        } catch (e) {}
      } else {
        LalaPage.page-=1;
        print("fail to getLalas");
      }
      LalaPage.isbusy = false;
    });
  }
}
