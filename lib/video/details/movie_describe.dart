import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // UI适配库
import '../../model/vod_model.dart';
import '../../utils/string_util.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // bloc
import '../../global_config.dart';

class VideoDescribe extends StatefulWidget {
  VideoDescribe({Key key, @required this.vod});

  VodModel vod;

  @override
  _VideoDescribeState createState() => _VideoDescribeState(vod: this.vod);
}

class _VideoDescribeState extends State<VideoDescribe> {
  _VideoDescribeState({Key key, @required this.vod});

  VodModel vod;
  Map infoData = {
    "personInfo": {
      "portrait":
          "https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg",
      "name": "习大大asdfsafaaafasfsf adsfassafsafsafadsfsafsafsafsdafsa",
      "fensi": 110,
      "attention": 0
    },
    "VideoDescribe": {
      "playCount": 138,
      "commentCount": 85,
      "date": "02-21",
      "order": "AV45475733",
      "title": "习大大就程序员工作作出重要指导",
      "subTitle": "哔哩哔哩~",
      "starType": 0,
      "goldType": 0,
      "collectType": 0,
      "shareType": 0,
      "starCount": 72,
      "unlikeCount": 12,
      "gold": 7,
      "collect": 22,
      "transmit": 89
    },
    "videoTag": ["动作", "历史", "高清", "科幻"],
    "moreVideo": [
      {
        "title": "西瓜不能多吃",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fze98q9ydbj30ko10wmyn",
        "up": "西瓜小子",
        "playCount": 192,
        "commentCount": 24
      },
      {
        "title": "公务员考试秘笈",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fyteamvvacj30f00qowqf",
        "up": "人民公仆",
        "playCount": 112,
        "commentCount": 134
      },
      {
        "title": "单车上写代码",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fyteb9s5hfg307i0dctpi",
        "up": "西红柿首富",
        "playCount": 129,
        "commentCount": 249
      },
      {
        "title": "2019年是个好年",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fytebchnkvg305k09wgr3",
        "up": "走马看花",
        "playCount": 142,
        "commentCount": 934
      },
      {
        "title": "1999年暴露了",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fytebllqelg30ak0irtbg",
        "up": "哒哒哒哒哒",
        "playCount": 112,
        "commentCount": 98
      },
      {
        "title": "程序员猝死几率逐年增大",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fyteaon7g6j30f00qo46p",
        "up": "大大强",
        "playCount": 102,
        "commentCount": 134
      },
      {
        "title": "程序员干不到15岁,因为死于34岁",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fze98xgwk8j30u01hggqe",
        "up": "大强",
        "playCount": 122,
        "commentCount": 204
      },
      {
        "title": "苍老师过马路",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fytebahwa1j30aq0ju41i",
        "up": "小强",
        "playCount": 19,
        "commentCount": 20
      },
      {
        "title": "今天狮子跑了",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fze98xy35jj30u00u0gnp",
        "up": "刘强",
        "playCount": 14,
        "commentCount": 24
      },
      {
        "title": "造数据好无聊",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fytebl6cj1j30qo1hcq4p",
        "up": "刘东强",
        "playCount": 10,
        "commentCount": 230
      },
      {
        "title": "今天鞋垫脏了",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fytebbuiw1j30u01o0k29",
        "up": "刘强东",
        "playCount": 1,
        "commentCount": 4
      },
      {
        "title": "嘻嘻哗啦",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fze9706gdzj30ae0kqmyw",
        "up": "马云",
        "playCount": 52,
        "commentCount": 314
      },
      {
        "title": "世界第三次大战",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fze970ocgxj30ae0ks0tc",
        "up": "化腾",
        "playCount": 122,
        "commentCount": 534
      },
      {
        "title": "走在乡间的小路上",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fze973gq93g309c0godph",
        "up": "马腾",
        "playCount": 62,
        "commentCount": 434
      },
      {
        "title": "喜马拉雅安装电梯",
        "pic": "https://ww1.sinaimg.cn/large/0073sXn7ly1fze97fxcgxj305e09mq5n",
        "up": "马化",
        "playCount": 121,
        "commentCount": 234
      }
    ]
  };

  List<Widget> listTag;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Color.fromRGBO(240, 240, 240, 1.0),
      padding: EdgeInsets.all(7.0),
      child: ListView(
        children: <Widget>[
          personInfo(),
          videoTag(),
          VideoDescribe(),
          // btnsWidget(),

          //moreVideo(),
        ],
      ),
    );
  }

  // 个人信息
  Widget personInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            // 圆角边框头像
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26, width: 1),
                  borderRadius: BorderRadius.circular(100),
                  image: DecorationImage(
                    image: NetworkImage(
                      infoData['personInfo']['portrait'],
                    ),
                    fit: BoxFit.cover,
                  )),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Column(
                children: <Widget>[
                  Text(StrUtils.subString('解说：${this.vod.vodDirector}',23),
                     // textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: ScreenUtil().setSp(26),
                      )),
                  Text(StrUtils.subString('：${this.vod.vodActor}',30),
                      style: TextStyle(fontSize: ScreenUtil().setSp(25))),
                ],
              ),
            )
          ],
        ),
        FlatButton(
          child: infoData['personInfo']['attention'] == 0
              ? Text(
                  '+ 关注',
                  style: TextStyle(color: Colors.white),
                )
              : Text(
                  '+ 取消',
                  style: TextStyle(color: Colors.white),
                ),
          color: Colors.pink[300],
          highlightColor: Colors.red[700],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.00)),
          onPressed: () {
            print('自定义样式外观');
          },
        )
      ],
    );
  }

  // 视频详情
  Widget VideoDescribe() {
    return Container(
//      child: ExpansionTile(
      child: new Column(
//        title: Text('${this.vod.vodName}',maxLines: 2),
        children: <Widget>[
//          Row(
//            children: <Widget>[
          Text('${this.vod.vodName}', maxLines: 1,
              textAlign: TextAlign.left),
          Text('${this.vod.vodContent}', maxLines: 10)
          //	],
          // )
        ],
        // initiallyExpanded: true,
      ),
    );
  }

  // 视频标签
  Widget videoTag() {
    return Container(
      child: Wrap(
          spacing: 8.0, // 主轴(水平)方向间距
          runSpacing: 4.0, // 纵轴（垂直）方向间距
          children: tag()),
    );
  }

  List<Widget> tag() {
    List<Widget> list = [];
    infoData['videoTag'].forEach((val) {
      list.add(
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
            color: Colors.black26,
            child: Text(val),
          ),
        ),
      );
    });
    return list;
  }
}
