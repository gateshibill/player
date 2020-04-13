import 'dart:io';
import 'dart:convert';
import '../model/peer_model.dart';
import '../model/message_model.dart';
import '../model/peer_model.dart';
import '../config/config.dart';
import '../data/cache_data.dart';
import '../service/http_client.dart';
import '../model/peer_action.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'ws_client.dart';

class UdpClient {
  int udpClientPort = LOCAL_UDP_PORT;
  RawDatagramSocket us;
  WsClient wsClient;

  void connect() {
    var data = "Hello, World";
    List<int> dataToSend = _getUdpSendDataPkg(data);
    var addressesIListenFrom = InternetAddress.anyIPv4;
    RawDatagramSocket.bind(addressesIListenFrom, 0)
        .then((RawDatagramSocket udpSocket) {
      us = udpSocket;

      //这里需要改造为登录的消息模式
      String time = DateFormat('MM-dd kk:mm:ss').format(DateTime.now());
      MessageModel message =
      new MessageModel(WsClient.LOGIN, 0, time, new PeerModel(0, "", 2228), new PeerModel(0, "", 2228));
      //us.send(dataToSend, new InternetAddress(TURN_SERVER_IP), TRUN_UDP_SERVER_PORT);
      sendMessage(message, TURN_SERVER_IP, TRUN_UDP_SERVER_PORT);

      print('Did send data on the stream..');
      udpSocket.forEach((RawSocketEvent event) {
        print("event:" + event.toString());
        if ((event == RawSocketEvent.read)) {
          Datagram dg = udpSocket.receive();
          String ip = dg.address.address;
          int port = dg.port;
          print("udp receive ip:$ip,port:$port");
          String response = _getUdpReceiveMessage(dg.data);
          if (response == null) {
            String message = 'udp receive:null|$ip|$port';
            print(message);
            _putRcvNodeSesionBuffer(message);
          } else {
            String message = 'udp receive:$response|$ip|$port';
            print(message);
            _putRcvNodeSesionBuffer(message);
            doMessage(response, dataToSend, ip, port);
          }
        }
      });
    });
  }
  void login(){
    String time = DateFormat('MM-dd kk:mm:ss').format(DateTime.now());
    MessageModel message =
    new MessageModel(WsClient.LOGIN, 0, time, wsClient.peerMyself, wsClient.peerB);
    sendMessage(message, TURN_SERVER_IP, TRUN_UDP_SERVER_PORT);
  }
  void doMessage(String response, List<int> dataToSend, String ip, int port) {
    try {
      MessageModel mm = MessageModel.fromJson(json.decode(response));
      String event = mm.event;
      PeerModel pm = mm.destPeer;
      //print(mm.toString());
      switch (event) {
        case WsClient.LOGIN:
          {
            PeerAction pa = new PeerAction(wsClient.peerMyself.id,mm.toJson().toString(),WsClient.LOGIN,"udp");
            HttpClient.holeReport(pa);
            //先登录UDP或者参数，再登录注册参数；
            print(mm.destPeer);
            wsClient.peerMyself.udpPort = mm.destPeer.udpPort;
            wsClient.peerMyself.ip = mm.destPeer.ip;
            //ws connect login
            wsClient.login(wsClient.peerMyself);
            break;
          }
        case WsClient.HOLE:// send hole to server;
          {
            PeerAction pa = new PeerAction(wsClient.peerMyself.id,mm.toJson().toString(),WsClient.HOLE,"udp");
            HttpClient.holeReport(pa);
            //这是服务回调命令打洞
            wsClient.peerMyself.udpPort = pm.udpPort;
            wsClient.peerMyself.ip = pm.ip;
            wsClient.requestForHole(wsClient.peerMyself);
            break;
          }
        case WsClient.HANDSHAKE:
          {//处理接受A的握手请求
            PeerAction pa = new PeerAction(wsClient.peerMyself.id,mm.toJson().toString(),WsClient.HANDSHAKE,"udp");
            HttpClient.holeReport(pa);
            String time = DateFormat('MM-dd kk:mm:ss').format(DateTime.now());
            MessageModel message =
            new MessageModel(WsClient.KISS, 0, time, wsClient.peerMyself, wsClient.peerB);
            sendMessage(message, ip, port);
            break;
          }
        case WsClient.EMBRACE:
          {//处理接受B的握手请求
            PeerAction pa = new PeerAction(wsClient.peerMyself.id,mm.toJson().toString(),WsClient.EMBRACE,"udp");
            HttpClient.holeReport(pa);

            String time = DateFormat('MM-dd kk:mm:ss').format(DateTime.now());
            MessageModel message =
            new MessageModel(WsClient.KISS, 0, time, wsClient.peerMyself, wsClient.peerB);
            sendMessage(message, ip, port);
            break;
          }
        case WsClient.KISS:
          {
            PeerAction pa = new PeerAction(wsClient.peerMyself.id,mm.toJson().toString(),WsClient.KISS,"udp");
            HttpClient.holeReport(pa);
            //结束上报结果;
            _putRcvNodeSesionBuffer(mm.toJson().toString());
            //上报记录数据；
            break;
          }
        case "transferfile":
          {
            _transferFile(ip, port);
            break;
          }
        case "receivefile":
          {
            _receiveFile();
            break;
          }
        default:
          {
            print("unknow:");
            _putRcvNodeSesionBuffer(mm.toJson().toString());
            break;
          }
      }
    } catch (e) {
      print("convert error:" + e.toString());
    }
  }
  sendMessage(MessageModel message, String destServerIp, int port) {
    send(message.toJson().toString(),destServerIp,port);
  }
  send(String message, String destServerIp, int port) {
    _putSndNodeSesionBuffer(message);
    var dataToSend = _getUdpSendDataPkg(message);
    us.send(dataToSend, new InternetAddress(destServerIp), port);
  }

  List<int> _getUdpSendDataPkg(String data) {
    var codec = new Utf8Codec();
    List<int> dataToSend = codec.encode(data);
    return dataToSend;
  }

  String _getUdpReceiveMessage(List<int> data) {
    var codec = new Utf8Codec();
    String message = codec.decode(data);
    return message;
  }
  _putRcvNodeSesionBuffer(String message) {
    pNodeSesionBuffer.writeln("[UR]$message");
  }
  _putSndNodeSesionBuffer(String message) {
    pNodeSesionBuffer.writeln("[US]$message");
  }
  void _transferFile(String ip, int port) {
    print("transferfile:");
    int size = 1024 * 100;
    int start = 1;
    int end = 2;
    Stream<List<int>> stream = new File('Data.txt').openRead(start, end);
    stream.listen((onData) {
      Duration threeSecond = const Duration(seconds: 3);
      us.timeout(threeSecond);
      int counter = 0; //控制重试次数
      while (true) {
        us.send(onData, new InternetAddress(ip), port);
        us.receive();
        print("send ok");
        break;
      }
      int length = onData.length;
      if (length < 1000) {
        //文件传输完了
        send("end", wsClient.peerA.ip, wsClient.peerA.port);
        //isNormal=true;
      }
    });
  }
  void _receiveFile() {
    // isNormal=false;
    print("receivefile");
    send("receive ok", wsClient.peerA.ip, wsClient.peerA.port);
    Datagram dg = us.receive();
    var file = File("");
    if (dg.data.length < 1024) {
      print("receivefile end");
      //isNormal=true;
      if (_getUdpReceiveMessage(dg.data) == "end") {
        //传输结束
        //continue;
      } else {
        //结束了
        file.writeAsBytes(dg.data, mode: FileMode.write, flush: true);
      }
      // return;
    } else {
      file.writeAsBytes(dg.data);
    }
  }
}
