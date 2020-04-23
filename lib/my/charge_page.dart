import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:player/data/cache_data.dart';
import 'package:player/service/Msg.dart';
import 'package:player/service/local_storage.dart';
import '../service/http_client.dart';
import './login/register_page.dart';
import '../utils/ui_util.dart';
import '../utils/validators.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../index/index.dart';
import './login/login_btn.dart';
import './login/login_input.dart';

class ChargePage extends StatefulWidget {
  @override
  _ChargePageState createState() {
    return _ChargePageState();
  }
}

class _ChargePageState extends State<ChargePage> {
  ProgressDialog pr;
  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  String cardId="";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(30, 50, 30, 20),
          child: _buildPasswordForm(),
        ),
      ),
    );
  }

  // 密码登录的
  _buildPasswordForm() {
    return Form(
      key: _passwordFormKey,
      child: Column(
        children: <Widget>[
          Container(
            child: Text(
              '充值',
              style: TextStyle(fontSize: 24),
            ),
          ),
          LoginPut(
              save: (val) {
                cardId = val;
              },
              img: 'assets/phone.png',
              name: '充值号码'),
          LoginBtn(
            press: () {
              _charge();
            },
            bgColor: Color(0xff488aff),
            fontColor: Color(0xffffffff),
            name: '确定',
          ),
          LoginBtn(
            press: () {
              Navigator.of(context).pop();
            },
            bgColor: Color(0xffEEEEEE),
            fontColor: Color(0xff333333),
            name: '取消',
          ),
        ],
      ),
    );
  }

  _charge() async {
    //验证
    final form = _passwordFormKey.currentState;
    form.save();
    if (cardId.isNotEmpty) {
      showLoginDialog();
      HttpClientUtils.charge(me.userId,cardId).then((onValue) {
        pr.hide();
        if(Msg.SUCCESS!=onValue.code){
          UiUtil.showToast("充值失败,${onValue.desc}");
          return;
        }else{
          me=onValue.object;
          LocalStorage.setUserMe(me);
          UiUtil.showToast("充值成功,有效期:${me.vipExpire}");
          me.isLogin=true;
            Navigator.of(context)
                .pop();
        }
      });
    } else {
      UiUtil.showToast('请输入正确卡号');
    }
  }

  showLoginDialog() {
    pr = new ProgressDialog(context);
    //pr.setMessage('正在登录...');
    //pr.update(60,100,'正在登录...');
    pr.show();
  }
}
