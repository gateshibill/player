//import 'package:flutter/material.dart';
//import 'package:flutter_screenutil/flutter_screenutil.dart'; // UI适配库
//
//class CommentDetail extends StatefulWidget {
//  @override
//  _CommentDetailState createState() => _CommentDetailState();
//}
//
//class _CommentDetailState extends State<CommentDetail> {
//  List commentList = [
//    {
//      "portrait":
//          "https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg",
//      "username": "马冬梅",
//      "grade": "3星",
//      "comment": "昨天下了一注赚一部苹果手机",
//      "date": "4小时前",
//    },
//    {
//      "portrait":
//          "https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg",
//      "username": "王大拿",
//      "grade": "2星",
//      "comment": "小姐姐解说声音很好听",
//      "date": "2小时前",
//    },
//    {
//      "portrait":
//          "https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg",
//      "username": "这是一个逗比",
//      "grade": "5星",
//      "comment": "曼联红魔牛B",
//      "date": "半小时前",
//    },
//    {
//      "portrait":
//          "https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg",
//      "username": "奥尼尔",
//      "grade": "5星",
//      "comment": "听说评论可以获得好运.",
//      "date": "4小时前",
//    },
//    {
//      "portrait":
//          "https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg",
//      "username": "一万卡",
//      "grade": "5星",
//      "comment":
//          "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈",
//      "date": "4小时前",
//    },
//    {
//      "portrait":
//          "https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg",
//      "username": "大卡车",
//      "grade": "5星",
//      "comment": "不想上班",
//      "date": "1天前",
//    },
//    {
//      "portrait":
//          "https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg",
//      "username": "小客车",
//      "grade": "5星",
//      "comment": "好累",
//      "date": "4小时前",
//    },
//    {
//      "portrait":
//          "https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg",
//      "username": "大卡车转丫丫",
//      "grade": "5星",
//      "comment": "这个狗尾巴有点短",
//      "date": "3小时前",
//    },
//    {
//      "portrait":
//          "https://ws1.sinaimg.cn/large/0065oQSqly1g0ajj4h6ndj30sg11xdmj.jpg",
//      "username": "奥玛",
//      "grade": "5星",
//      "comment": "默默打个卡",
//      "date": "4天前",
//    },
//  ];
//
//  double h = 50; //广告高度
//  TextEditingController _inputController = new TextEditingController();
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      // color: Color.fromRGBO(240, 240, 240, 1.0),
//      padding: EdgeInsets.all(7.0),
//      child: Stack(
//        children: <Widget>[
//          ListView(
//            children: <Widget>[
//             // adWidget(),
//             // titleWidget(),
//              commentItem()],
//          ),
////          Positioned(
////            bottom: 5.0,
////            left: 1.0,
////            child: inputWidget(),
////          ),
//        ],
//      ),
//    );
//  }
//
//  // 底部输入框
//  Widget inputWidget() {
//    return Container(
//      decoration: BoxDecoration(
//          color: Colors.white,
//          border: Border(top: BorderSide(width: 0.5, color: Colors.black))),
//      width: ScreenUtil().setWidth(750),
//      height: ScreenUtil().setHeight(80),
//      child: Row(
//        children: <Widget>[
//          Expanded(
//            child: TextField(
//              style: TextStyle(color: Colors.red),
//              controller: _inputController,
//              decoration: InputDecoration(
//                  fillColor: Colors.black12,
//                  contentPadding: EdgeInsets.all(10.0),
//                  border: OutlineInputBorder(
//                    borderRadius: BorderRadius.circular(30),
//                  ),
//                  hintText: "索点什么",
//                  filled: true),
//            ),
//            flex: 8,
//          ),
//          Expanded(
//            child: Icon(Icons.person, color: Colors.pink),
//            flex: 1,
//          )
//        ],
//      ),
//    );
//  }
//
//  // ad广告位
//  Widget adWidget() {
//    return Container(
//      height: ScreenUtil().setHeight(h),
//      color: Colors.grey,
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        crossAxisAlignment: CrossAxisAlignment.center,
//        children: <Widget>[
//          Text(
//            '   我是一条广告',
//            style: TextStyle(color: Colors.white),
//          ),
//          IconButton(
//            icon: Icon(Icons.close, color: Colors.white),
//            onPressed: () {
//              setState(() {
//                h = 0;
//              });
//            },
//          )
//        ],
//      ),
//    );
//  }
//
//  // title
//  Widget titleWidget() {
//   // return Text('评论');
//  }
//
//  // 评论item
//  Widget commentItem() {
//    List<Widget> list = [];
//    commentList.forEach((e) {
//      list.add(
//        Container(
//          decoration: BoxDecoration(
//              border:
//                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
//          padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 8.0),
//          child: Row(
//            children: <Widget>[
//              CircleAvatar(
//                radius: 20.0,
//                backgroundImage: NetworkImage(e['portrait']),
//              ),
//              Column(
//                children: <Widget>[
//                  Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    children: <Widget>[name(e), comment(e), btns(e)],
//                  )
//                ],
//              )
//            ],
//          ),
//        ),
//      );
//    });
//    return Column(
//      children: list,
//    );
//  }
//
//  // 用户名一栏
//  Widget name(e) {
//    return Container(
//      padding: EdgeInsets.only(left: 10.0),
//      width: ScreenUtil().setWidth(595),
//      child: Stack(
//        children: <Widget>[
//          Row(
//            children: <Widget>[
//              Text(
//                e['username'],
//                style: TextStyle(color: Colors.grey),
//              ),
//              Text(
//                '  ' + e['grade'],
//              )
//            ],
//          ),
//          Positioned(
//            top: 0.0,
//            right: 10.0,
//            child: Text(
//              e['date'],
//              style: TextStyle(fontSize: ScreenUtil().setSp(18)),
//            ),
//          ),
//        ],
//      ),
//    );
//  }
//
//  // 评论一栏
//  Widget comment(e) {
//    return Container(
//      padding: EdgeInsets.only(left: 10.0),
//      width: ScreenUtil().setWidth(590),
//      child: Text(e['comment'],
//          maxLines: 3,
//          overflow: TextOverflow.ellipsis,
//          style: TextStyle(fontSize: ScreenUtil().setSp(28))),
//    );
//  }
//
//  // 按钮一栏
//  Widget btns(e) {
//    return Container(
//      padding: EdgeInsets.only(left: 10.0),
//      width: ScreenUtil().setWidth(200),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//        children: <Widget>[
//          InkWell(
//              onTap: () {},
//              child: Image.asset('images/pages/star_black.png',
//                  width: ScreenUtil().setWidth(20))),
//          InkWell(
//              onTap: () {},
//              child: Image.asset('images/pages/unStar_black.png',
//                  width: ScreenUtil().setWidth(20))),
//          InkWell(
//              onTap: () {},
//              child: Image.asset('images/pages/share_black.png',
//                  width: ScreenUtil().setWidth(20))),
//        ],
//      ),
//    );
//  }
//}
