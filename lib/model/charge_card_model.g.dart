// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'charge_card_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChargeCardModel _$ChargeCardModelFromJson(Map<String, dynamic> json) {
  return ChargeCardModel()
    ..cardId = json['cardId'] as String
    ..userId = json['userId'] as int
    ..type = json['type'] as int
    ..name = json['name'] as String
    ..price = (json['price'] as num)?.toDouble()
    ..validate = json['validate'] as int
    ..used = json['used'] as int
    ..createTime = json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String)
    ..usedTime = json['usedTime'] == null
        ? null
        : DateTime.parse(json['usedTime'] as String)
    ..expire = json['expire'] == null
        ? null
        : DateTime.parse(json['expire'] as String);
}

Map<String, dynamic> _$ChargeCardModelToJson(ChargeCardModel instance) =>
    <String, dynamic>{
      'cardId': instance.cardId,
      'userId': instance.userId,
      'type': instance.type,
      'name': instance.name,
      'price': instance.price,
      'validate': instance.validate,
      'used': instance.used,
      'createTime': instance.createTime?.toIso8601String(),
      'usedTime': instance.usedTime?.toIso8601String(),
      'expire': instance.expire?.toIso8601String()
    };
