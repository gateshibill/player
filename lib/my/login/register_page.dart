import 'dart:convert';
import 'package:player/data/cache_data.dart';
import 'package:player/service/Msg.dart';
import '../../model/client_action.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../service/http_client.dart';
import './login_page.dart';
import '../../utils/validators.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../utils/ui_util.dart';
import 'login_btn.dart';
import 'login_input.dart';
import '../../model/user_model.dart';


class PasswordLoginInfo {
  String phone;
  String password;
  String nickname;
  String confirm;
}

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  //final _apiClient = NetworkProvider();
  ProgressDialog pr;

  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  PasswordLoginInfo passwordLoginInfo = PasswordLoginInfo();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ClientAction ca=new ClientAction(501, "register", 0, "", 0, "", 1, "bowser");
    HttpClientUtils.actionReport(ca);

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
              '注册',
              style: TextStyle(fontSize: 24),
            ),
          ),
          LoginPut(
              save: (val) {
                passwordLoginInfo.phone = val;
              },
              img: 'assets/phone.png',
              name: '手机号码'),
          LoginPut(
              save: (val) {
                passwordLoginInfo.nickname = val;
              },
              img: 'assets/message.png',
              name: '昵称'),
          LoginPut(
              save: (val) {
                passwordLoginInfo.password = val;
              },
              img: 'assets/lock.png',
              name: '密码'),
          LoginPut(
              save: (val) {
                passwordLoginInfo.confirm = val;
              },
              img: 'assets/lock.png',
              name: '确认密码'),
          LoginBtn(
            press: () {
              _registerByPassword();
            },
            bgColor: Color(0xff488aff),
            fontColor: Color(0xffffffff),
            name: '注册',
          ),
          LoginBtn(
            press: () {
              Navigator.of(context).pop();
            },
            bgColor: Color(0xffEEEEEE),
            fontColor: Color(0xff333333),
            name: '返回登录',
          ),
        ],
      ),
    );
  }

  _registerByPassword() async {
    //验证
    final form = _passwordFormKey.currentState;
    form.save();
    if (Validators.phone(passwordLoginInfo.phone) &&
        Validators.required(passwordLoginInfo.password)) {
      showLoginDialog();
      HttpClientUtils.register({
        "userPhone": passwordLoginInfo.phone,
        "userNickname": passwordLoginInfo.nickname,
        "userPwd": passwordLoginInfo.password
      }).then((onValue) {
        pr.hide();
        if (Msg.SUCCESS == onValue.code) {
          me=onValue.object;
          UiUtil.showToast('恭喜您，注册成功！');
              passwordLoginInfo.password;//保存原始密码
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => LoginPage()));
        } else {
          UiUtil.showToast("fail to register,$onValue");
        }
      });
    } else if (!Validators.phone(passwordLoginInfo.phone)) {
      UiUtil.showToast('请输入正确的手机号码');
    } else if (passwordLoginInfo.password != passwordLoginInfo.confirm) {
      UiUtil.showToast('输入密码不一致，请确认密码');
    } else {
      UiUtil.showToast('请输入验证码');
    }
  }

  showLoginDialog() {
   // pr = new ProgressDialog(context);
    //pr.setMessage('正在登录...');
   // pr.show();
  }
}
