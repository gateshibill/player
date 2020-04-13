import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import '../data/cache_data.dart';
import '../config/config.dart';
import '../service/http_client.dart';
import '../model/client_action.dart';
import '../model/client_log.dart';
import '../service/http_client.dart';
import '../utils/udp_client.dart';
import '../utils/ws_client.dart';

class PnodePage extends StatefulWidget {
  final WebSocketChannel channel;
  static StreamController messageStreamController;

  PnodePage({@required this.channel});

  @override
  PnodePageState createState() {
    return new PnodePageState();
  }
}

class PnodePageState extends State<PnodePage> {
  final TextEditingController editingController = new TextEditingController();

  WebSocketChannel channel;
  static bool isCheck = false;

  void _connect() {
    channel = new IOWebSocketChannel.connect("ws://$TURN_SERVER_IP:8181");
  }

  @override
  void initState() {
    super.initState();
    _connect();
    channel.stream.listen((onData) {
      print("listen:${onData.toString()}");
      setState(() {
        pNodeSesionBuffer.writeln(onData.toString());
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ClientAction ca =
        new ClientAction(505, "pnodePage", 0, "", 0, "", 1, "bowser");
    //HttpClient.actionReport(ca);

    return new MaterialApp(
        //theme: GlobalConfig.themeData,
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
            appBar: new AppBar(
              leading: new IconButton(
                padding: EdgeInsets.all(2.0),
                icon: new Icon(Icons.blur_on, color: Colors.white),
                onPressed: () {
                  setState(() {
                    getNode();
                  });
                },
              ),
              centerTitle: true,
              title: new Form(
                child: new TextFormField(
                  decoration: new InputDecoration(labelText: "message"),
                  controller: editingController,
                ),
              ),
              actions: <Widget>[
                new Container(
                  //width:50,
                  // margin: EdgeInsets.only(right: 5.0),
                  child: new Row(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Container(
                          width: 80,
                          child: new FlatButton(
                              onPressed: () {
                                setState(() {
                                  p2pCheck();
                                  //requestHole();
                                });
                              },
                              child: new Text("send"))),
                      new Container(
                          width: 80,
                          child: new FlatButton(
                              onPressed: isCheck
                                  ? null
                                  : () {
                                      setState(() {
                                        if (isCheck) {
                                          return;
                                        }
                                        timeCheck();
                                      });
                                    },
                              child: new Text("check"))),
                    ],
                  ),
                )
              ],
            ),
            body: new SingleChildScrollView(
                child: new ConstrainedBox(
                    constraints: new BoxConstraints(
                      minHeight: 120.0,
                    ),
                    child: new Column(children: <Widget>[
                      new Padding(
                        padding: const EdgeInsets.all(20.0),
                        // child: new Text(pNodeSesionBuffer.toString()),
                      ),
                      new Container(
                        child: Column(
                          //动态创建一个List<Widget>
                          children: pNodeSesionBuffer
                              .toString()
                              .split("/n")
                              //每一个字母都用一个Text显示,字体为原来的两倍
                              .map((c) => Text(c,
                                  textScaleFactor: 1.0,
                                  textAlign: (c.startsWith("[ME]")
                                      ? TextAlign.right
                                      : TextAlign.justify)))
                              .toList(),
                        ),
                      ),
                    ]))),
            floatingActionButton: new FloatingActionButton(
              onPressed: () {
                setState(() {
                  isCheck = false;
                  pNodeSesionBuffer.clear();
                });
              },
              child: new Text("clear"),
            )
        )
    );
  }

  @override
  void dispose() {
    super.dispose();
    channel.sink.close();
  }

  void getNode() {
    print("[ME]getNode()");
    pNodeSesionBuffer.writeln("[ME]getNode()");
  }

  void requestHole() {
    print("requstHole()");
    pNodeSesionBuffer.writeln("[WR]:${editingController.text}");
  }

  void timeCheck() async {
    pNodeSesionBuffer.clear();
    isCheck = true;
    HttpClient.test_check().then((onValue) {
      isCheck = false;
    });
    int count = 0;
    const period = const Duration(seconds: 1);
    Timer.periodic(period, (timer) {
      try {
        setState(() {
          count += 1;
        });
        if (count >= 600) {
          isCheck = true;
          timer.cancel();
          timer = null;
        }
      } catch (e) {}
    });
  }
}
 void p2pCheck()  async {
print("p2pCheck");
// try {
UdpClient udpClient = new UdpClient();
WsClient wsClient = new WsClient();
udpClient.wsClient = wsClient;
wsClient.udpClient = udpClient;

wsClient.init();
udpClient.connect();

wsClient.notifyServer();
}
