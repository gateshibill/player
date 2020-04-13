package com.example.video_play_flutter_app;


import android.os.Bundle;
import io.flutter.app.FlutterActivity;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.umeng.commonsdk.UMConfigure;
import com.umeng.analytics.MobclickAgent;

public class MainActivity extends FlutterActivity {

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    /**
     * 初始化common库
     * 参数1:上下文，必须的参数，不能为空
     * 参数2:友盟 app key，非必须参数，如果Manifest文件中已配置app key，该参数可以传空，则使用Manifest中配置的app key，否则该参数必须传入
     * 参数3:友盟 channel，非必须参数，如果Manifest文件中已配置channel，该参数可以传空，则使用Manifest中配置的channel，否则该参数必须传入，channel命名请详见channel渠道命名规范
     * 参数4:设备类型，必须参数，传参数为UMConfigure.DEVICE_TYPE_PHONE则表示手机；传参数为UMConfigure.DEVICE_TYPE_BOX则表示盒子；默认为手机
     * 参数5:Push推送业务的secret，需要集成Push功能时必须传入Push的secret，否则传空
     */
    //如果AndroidManifest.xml清单配置中没有设置appkey和channel，则可以在这里设置
    //        UMConfigure.init(this, "58edcfeb310c93091c000be2", "Umeng", UMConfigure.DEVICE_TYPE_PHONE, "1fe6a20054bcef865eeb0991ee84525b");
    UMConfigure.init(this,"5d78c4670cafb2b5dc0002ab","Web", UMConfigure.DEVICE_TYPE_PHONE,"");
  }
  protected void onResume() {
    super.onResume();
    MobclickAgent.onResume(this);
  }

  protected void onPause() {
    super.onPause();
    MobclickAgent.onPause(this);
  }
}
