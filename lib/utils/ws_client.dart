import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:intl/intl.dart';
import '../service/http_client.dart';
import '../data/cache_data.dart';
import './udp_client.dart';
import '../model/message_model.dart';
import '../model/metadata_model.dart';
import '../model/peer_model.dart';
import '../config/config.dart';
import '../model/peer_action.dart';


class WsClient {
  static const String LOGIN = "login";
  static const String HANDSHAKE = "handshake";
  static const String NOTYFY = "notify";
  static const String SENDUDP = "sendUdp";
  static const String PEERISREADY = "peerIsReady";
  static const String EMBRACE = "embrace";
  static const String KISS = "kiss";
  static const String HOLE = "hole";
  static const String RESPONSE = "response";

  WebSocketChannel channel;
  PeerModel peerA;
  PeerModel peerB;
  PeerModel peerMyself=new PeerModel(0, "",2288 );
  UdpClient udpClient;

  void init() {
    connect();
    listen();
    login(peerMyself);
  }

  void connect() {
    channel = new IOWebSocketChannel.connect(WS_SERVER_URL);
  }

  void close() {
    channel.sink.close();
  }
  void listen() {
    channel.stream.listen((onData) {
      print("listen:${onData.toString()}");
      pNodeSesionBuffer.write("[WR]${onData.toString()}");
      _doMessage(onData.toString());
    });
  }

  void _doMessage(String response) {
    MessageModel mm = MessageModel.fromJson(json.decode(response));
    _putRcvNodeSesionBuffer(mm.toJson().toString());
    switch (mm.event) {
      case LOGIN:
        {
          print(mm.destPeer);
          print("success login");
          PeerAction pa = new PeerAction(this.peerMyself.id,mm.toJson().toString(),LOGIN,"ws");
          HttpClient.holeReport(pa);
          break;
        }
      case NOTYFY: //
        {
          //发送UDP给服务器，先获取UDP参数，然后回调请求打洞
          print(NOTYFY);
          PeerAction pa = new PeerAction(this.peerMyself.id,mm.toJson().toString(),NOTYFY,"ws");
          HttpClient.holeReport(pa);

          String time = DateFormat('MM-dd kk:mm:ss').format(DateTime.now());
          MessageModel message =
              new MessageModel(HOLE, 0, time, peerMyself, peerB);
          udpClient.send(message.toJson().toString(), TURN_SERVER_IP,
              TRUN_UDP_SERVER_PORT);
          break;
        }
      case SENDUDP:
        {
          //这里UDP只需要给A发，不需要再给Server,正式业务是可能需要发,这里会一直发
          PeerAction pa = new PeerAction(this.peerMyself.id,mm.toJson().toString(),SENDUDP,"ws");
          HttpClient.holeReport(pa);

          int requestId = mm.requstId;
          peerA = mm.fromPeer;
          print("start udp client:" + peerA.toString());
          _sendTimeUpdMessage(HANDSHAKE, peerA);

          //告诉服务器，让转告Ａ，已经准备好了
          String time = DateFormat('MM-dd kk:mm:ss').format(DateTime.now());
          MessageModel mmToServer =
              MessageModel(PEERISREADY, requestId, "", peerMyself, peerA);
          sendMessage(mmToServer);
          break;
        }
      case PEERISREADY:
        {
          PeerAction pa = new PeerAction(this.peerMyself.id,mm.toJson().toString(),PEERISREADY,"ws");
          HttpClient.holeReport(pa);

          String time = DateFormat('MM-dd kk:mm:ss').format(DateTime.now());
          MessageModel toMessage =
              new MessageModel(EMBRACE, 0, time, this.peerMyself, mm.destPeer);
          udpClient.sendMessage(toMessage, mm.destPeer.ip, mm.destPeer.port);
          break;
        }
      case RESPONSE:
        {
          print("RESPONSE:num of clients:${mm.content}");
          PeerAction pa = new PeerAction(this.peerMyself.id,mm.toJson().toString(),RESPONSE,"ws");
          HttpClient.holeReport(pa);
          break;
        }
      default:
        print("unknow:");
        PeerAction pa = new PeerAction(this.peerMyself.id,mm.toJson().toString(),"unknow","ws");
        HttpClient.holeReport(pa);
        break;
    }
  }

  void login(PeerModel peerMyself) {
    print("wsLogin():" + peerMyself.toString());
    String time = DateFormat('MM-dd kk:mm:ss').format(DateTime.now());
    MessageModel message = MessageModel(
        "login", 0, time, peerMyself, new PeerModel(0, LOCAL_IP, 9999));
    sendMessage(message);
  }

//收到服务返回的UDP后，回调打洞
  void requestForHole(PeerModel peerMyself) {
    print("requst for hole");
    String time = DateFormat('MM-dd kk:mm:ss').format(DateTime.now());
    MessageModel toMessage = MessageModel(HOLE, 0, time, peerMyself, peerB);
    sendMessage(toMessage);
  }
  //收到服务返回的UDP后，回调打洞
  void notifyServer() {
    String time = DateFormat('MM-dd kk:mm:ss').format(DateTime.now());
    MessageModel toMessage = MessageModel(NOTYFY, 0, time, peerMyself, null);
    sendMessage(toMessage);
  }

  void _sendTimeUpdMessage(String event, peer) async {
    int count = 0;
    const period = const Duration(milliseconds: 1000);
    int updPort = peer.udpPort;
    Timer.periodic(period, (timer) {
      String time = DateFormat('MM-dd kk:mm:ss').format(DateTime.now());
      MessageModel message = new MessageModel(event, 0, time, peerMyself, peer);

      Future.delayed(const Duration(seconds: 1));
      pNodeSesionBuffer.write("[US]${message.toJson()}");

      udpClient.send(message.toJson().toString(), peer.ip, updPort);
      print("$message|${peer.ip}|$updPort");
      count++;
      //以下注释未猜端口用的，先注释
      // peer.udpPort<32768?updPort++:updPort--;
//      if(peer.udpPort<327680){
//        updPort+=1;
//      }else{
//        updPort-=1;
//      }
//      UdpClient.send(
//          message.toJson().toString(), BASE_SERVER_IP, UDP_SERVER_PORT);
      // print('peer:' + peer.toString());

//      setState(() {
//        content="$count.to|${peer.toString()}";
//      });
//      if (updPort > 65535 || updPort < 1 || handshake_succuss_flag) {
////        timer.cancel();
////        timer = null;
////      }
    });
  }

  _putRcvNodeSesionBuffer(String message) {
    pNodeSesionBuffer.writeln("[WR]$message");
  }

  _putSndNodeSesionBuffer(String message) {
    pNodeSesionBuffer.writeln("[wS]$message");
  }

  sendMessage(MessageModel message) {
    print("message:" + message.toJson().toString());
    _putSndNodeSesionBuffer(message.toJson().toString());
    channel.sink.add(message.toJson().toString());
  }
}
