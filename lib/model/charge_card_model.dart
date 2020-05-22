import 'package:json_annotation/json_annotation.dart';
import 'source_model.dart';
import 'metadata_model.dart';
import '../data/cache_data.dart';

part 'charge_card_model.g.dart';

@JsonSerializable()
class ChargeCardModel {
  String cardId; //
  int userId; //
  int type; //0临时卡，1月卡，2季卡，3年卡
  String name; //
  double price;
  int validate;
  int used; //0未使用，1已使用，2已过期
  DateTime createTime;
  DateTime usedTime;
  DateTime expire;

  ChargeCardModel();

  String detail() {
    return "card: ${name}|${cardId}| ${type}| ${used}| ${createTime}";
  }

  factory ChargeCardModel.fromJson(Map<String, dynamic> json) =>
      _$ChargeCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$ChargeCardModelToJson(this);
}

class ChargeCardModelList {
  List<ChargeCardModel> chargeCardModelList;

  ChargeCardModelList({this.chargeCardModelList});

  factory ChargeCardModelList.fromJson(List<dynamic> listJson) {
    List<ChargeCardModel> chargeCardModelList =
        listJson.map((value) => ChargeCardModel.fromJson(value)).toList();

    return ChargeCardModelList(chargeCardModelList: chargeCardModelList);
  }
}
