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
import '../common/view_picture_page.dart';
import 'dart:math';

class SvideoPage extends StatefulWidget {
  @override
  _SvideoPageState1 createState() => new _SvideoPageState1();
}

class _SvideoPageState1 extends State<SvideoPage> {
  @override
  Widget build(BuildContext context) {
    ClientAction ca =
        new ClientAction(203, "svideo", 0, "", 0, "", 1, "browse");
    HttpClient.actionReport(ca);

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
  // List results = []; // 数据数组
  List<NetworkImage> networkImages = [];
  int page = Random().nextInt(8); // 第一个数据标示

  void initState() {
    super.initState();
    if (results.length < 1) {
      _getVideoData();
    } else {
      results.shuffle();
    }
  }

  // 获取视频一级数据
  void _getVideoData() async {
    await get('videoContent', formData: page).then((val) {
      var data = json.decode(val.toString());
      VideoContextModel model = VideoContextModel.fromJson(data);
      setState(() {
        results.addAll(model.results);
        page++;
      });
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return EasyRefreshView();
  }

  Widget EasyRefreshView() {
    return results.length < 1
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
            results = [];
          });
          page = 1;
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
      itemCount: results.length,
      itemBuilder: (BuildContext context, int index) => Container(
        child: InkWell(
          onTap: () {
            List<String> list = [];
            for (Results m in results) {
              list.add(m.url);
            }
//            Navigator.of(context)
//                .push(new MaterialPageRoute(builder: (context) {
//              return new ViewPicturePage(networkImages: networkImages);
//            }));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Expanded(
//                    child: FadeInImage.assetNetwork(
//                      placeholder: 'images/pages/placeholder.jpg',
//                      fit: BoxFit.fill,
//                      image: results[index].url,
//                    ),
                  child: imageContainer(results[index].url)
//                new CachedNetworkImage(
//                  imageUrl: results[index].url,
//                  fit: BoxFit.fill,
//                  placeholder: (context, url) => cachPlaceHolder(),
//                  errorWidget: (context, url, error) => new Icon(Icons.error),
//                ),
                  ),
              Text('4k美女' + '--' + results[index].desc),
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

  Widget imageContainer(String url) {
    NetworkImage networkImage = new NetworkImage(url);
    this.networkImages.add(networkImage);
    return new DecoratedBox(
      decoration: new BoxDecoration(
        image: new DecorationImage(
          image: networkImage,
        ),
      ),
    );
  }

  Widget imageCacheContainer(String url) {
    CachedNetworkImage cni=new CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.fill,
      placeholder: (context, url) => cachPlaceHolder(),
      errorWidget: (context, url, error) => new Icon(Icons.error),
    );
    //cni.
    return cni;
  }
}
