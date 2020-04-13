//import 'dart:async';
//import 'dart:convert';
//import '../config/config.dart';
//import './base_api_provider.dart';
//
////import './http_client.dart';
////import '../resource/local_data_provider.dart';
////import '../lib/model/user_model.dart';
//
//class NetworkProvider extends BaseApiProvider {
//
//  // 首页
//  Future<String> getFeeds() async {
//    final response = await get('https://imoocqa.gugujiankong.com/api/feeds/get');
//    return response.toString();
//  }
//
//  // 发现
//  Future<String> getQuestions(Map<String, dynamic> params) async {
//    final response = await get('https://imoocqa.gugujiankong.com/api/question/list', params);
//    return response.toString();
//  }
//
//  // 登录
//  Future<String> login(Map<String, dynamic> params) async {
//    final response = await get('https://imoocqa.gugujiankong.com/api/account/login', params);
//    return response.toString();
//  }
//
//  // 登录
//  Future<String> login1(Map<String, dynamic> params) async {
//    final response = await post(LOGIN_URL, params);
//    print(response);
//    String res2Json=json.encode(response.data);
//    return res2Json;
//  }
//  // 注册
//  Future<String> register1(Map<String, dynamic> params) async {
//    final response = await post(REGISTER_URL, params);
//    print(response);
//    //var data = json.decode(response);
//    String res2Json = json.encode(response.data);
//    return res2Json;
//  }
//
//
//  // 提问
//  Future<String> saveQuestion(Map<String, dynamic> params) async {
//    final response = await get('https://imoocqa.gugujiankong.com/api/question/save', params);
//    return response.toString();
//  }
//
//  // 我的提问 关注 回答
//  Future<String> getUserQuestionList(Map<String, dynamic> params) async {
//    final response = await get('https://imoocqa.gugujiankong.com/api/account/getuserquestionlist', params);
//    return response.toString();
//  }
//
//}