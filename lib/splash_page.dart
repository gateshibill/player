//import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './index/index.dart';
import './resource/downtime.dart';
import './service/http_upgrade.dart';

class SplashPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  showNextPage() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      SystemChrome.setEnabledSystemUIOverlays(
          [SystemUiOverlay.top, SystemUiOverlay.bottom]);
      SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
          statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
      return Index();
    }), (route) => route == null);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit:StackFit.expand,
      children: <Widget>[
        Image.asset("assets/images/" + "startup1.jpg",
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          fit: BoxFit.cover,),
//        CachedNetworkImage(
//          imageUrl: "https://sportslive.hongxiuba.com/pic/carousel/startup2.png",
//          placeholder: (context, url) =>
//          new CircularProgressIndicator(),
//          errorWidget: (context, url, error) =>
//          new Icon(Icons.error),
//            fit:BoxFit.fill,
//        ),
        Positioned(
          child: new GestureDetector(
            onTap: () {
              showNextPage();
            },
            child: Container(
              margin: EdgeInsets.all(10.0),
              child: DownTimeWidget(clors: Colors.red,
                time: 3000,
                width: 40,
                strokeWidth: 5.0,
                textStyle: TextStyle(color: Colors.black, fontSize: 8.0
                    , decoration: TextDecoration.none),
                endListener: () {
                  showNextPage();
                },),
            ),
          ),
          top: 2.0,
          right: 2.0,
        ),
      ],
    );
  }
}

