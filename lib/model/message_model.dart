import 'package:json_annotation/json_annotation.dart';
import 'peer_model.dart';
part 'message_model.g.dart';


@JsonSerializable()
class MessageModel {
  int requstId;//是不是可以用clientId
  String event;
  String content;
  PeerModel fromPeer;
  PeerModel destPeer;

  MessageModel(this.event,this.requstId,this.content,this.fromPeer,this.destPeer);
//  String toString(){
//    String f=((fromPeer==null)?"":fromPeer.toString());
//    String d=((destPeer==null)?"":destPeer.toString());
//    return
//      "msgmodel: $requstId| $event| $content|$f|$d";
//  }
  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);

  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}

class MessageModelList {
  List<MessageModel> messageModelList;

  MessageModelList({this.messageModelList});

  factory MessageModelList.fromJson(List<dynamic> listJson) {

    List<MessageModel> messageModelList =
    listJson.map((value) => MessageModel.fromJson(value)).toList();

    return MessageModelList(messageModelList: messageModelList);
  }
}