import 'package:json_annotation/json_annotation.dart';
part 'peer_model.g.dart';

@JsonSerializable()
class PeerModel {
  int id=0;//是不是可以用clientId
  String name="";
  String localIp="";
  String ip="";
  int port=0;
  int udpPort=0;

  PeerModel(this.id,this.localIp,this.udpPort);
  String toString(){
    int up=((udpPort==null)?0:udpPort);
    return
      "PeerModel: $id| $localIp| $ip|$port|$up";
  }
  factory PeerModel.fromJson(Map<String, dynamic> json) =>
      _$PeerModelFromJson(json);

  Map<String, dynamic> toJson() => _$PeerModelToJson(this);
}

class PeerModelList {
  List<PeerModel> peerModelList;

  PeerModelList({this.peerModelList});

  factory PeerModelList.fromJson(List<dynamic> listJson) {

    List<PeerModel> peerModelList =
    listJson.map((value) => PeerModel.fromJson(value)).toList();

    return PeerModelList(peerModelList: peerModelList);
  }
}