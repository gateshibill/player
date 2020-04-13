import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../service/local_data_provider.dart';
import '../../service/http_client.dart';
import './register_page.dart';
import '../../utils/ui_util.dart';
import '../../utils/validators.dart';
import 'package:progress_dialog/progress_dialog.dart';
import '../../index/index.dart';
import 'login_btn.dart';
import 'login_input.dart';
import '../../model/user_model.dart';
import '../../service/local_data_provider.dart';

class PasswordLoginInfo {
  String phone = "18565826288";
  String password = "sdad8888";
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() {
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
 // final _apiClient = NetworkProvider();
  ProgressDialog pr;

  GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  PasswordLoginInfo passwordLoginInfo = PasswordLoginInfo();

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
              '登录',
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
                passwordLoginInfo.password = val;
              },
              img: 'assets/lock.png',
              name: '密码'),
          LoginBtn(
            press: () {
              _loginByPassword();
            },
            bgColor: Color(0xff488aff),
            fontColor: Color(0xffffffff),
            name: '登录',
          ),
          LoginBtn(
            press: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => RegisterPage()));
            },
            bgColor: Color(0xffEEEEEE),
            fontColor: Color(0xff333333),
            name: '注册',
          ),
        ],
      ),
    );
  }

  _loginByPassword() async {
    //验证
    final form = _passwordFormKey.currentState;
    form.save();
    if (Validators.phone(passwordLoginInfo.phone) &&
        Validators.required(passwordLoginInfo.password)) {
      showLoginDialog();
      HttpClient.login({
        'userPhone': passwordLoginInfo.phone,
        'userPwd': passwordLoginInfo.password
      }).then((response) {
        pr.hide();
        //String res2Json = json.encode(response);
        if(null==response){
          UiUtil.showToast("fail to login,$response");
          return;
        }
        final Map parsed = json.decode(response);
        String code = parsed["code"].toString();
        final Map objectJson = parsed["object"];
        if (code == '200') {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Index()));
        } else {
          UiUtil.showToast("fail to login,$response");
        }
      });
    } else if (!Validators.phone(passwordLoginInfo.phone)) {
      UiUtil.showToast('请输入正确的手机号码');
    } else {
      UiUtil.showToast('请输入验证码');
    }
  }

  showLoginDialog() {
 //   pr = new ProgressDialog(context);
    //pr.setMessage('正在登录...');
    //pr.update(60,100,'正在登录...');
    //pr.show();
  }
}
