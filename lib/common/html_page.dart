import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'media_page.dart';
import '../model/media_model.dart';
import '../model/topic_model.dart';

class HtmlPage  extends MediaPage{
  HtmlPage({Key key, @required this.mediaModel,this.context});
  MediaModel mediaModel;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
//      title: 'Flutter Demo',
//      theme: new ThemeData(
//        primarySwatch: Colors.blue,
//      ),
      home: new MyHomePage(mediaModel: mediaModel,context:context),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.mediaModel,this.context}) : super(key: key);
  //MediaPage({Key key, @required this.mediaModel});
  //final String title;
  MediaModel mediaModel;
  BuildContext context;
  @override
  _MyHomePageState createState() => new _MyHomePageState(mediaModel: mediaModel,context: this.context);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({Key key, this.mediaModel,this.context});
  TopicModel mediaModel;
  BuildContext context;
  @override
  Widget build(BuildContext context) {
    String content="<h1>${mediaModel.getName()}</h1>  " + mediaModel.topicContent;

    return new Scaffold(
      appBar: new AppBar(
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(this.context).pop(),
        ),
        title: new Text(mediaModel.getName()),
      ),
      body: new Center(
        child: SingleChildScrollView(
          child: Html(
            data:content,
//            data: """
//<div id="article_body" class="jsx-1273719342 unpack">
//<div class="jsx-513965227"><div class="jsx-513965227 video">
//<div class="jsx-513965227 video-inner" style="background-image: url(&quot;//inews.gtimg.com/newsapp_ls/0/10326935418_640480/0&quot;);"><i data-vid="u00325i2eer" data-boss="video&amp;modular=content" class="jsx-513965227 play-icon"></i></div>
//<div class="jsx-513965227 desc">视频：曝中国男篮主帅李楠已提交辞职申请 曾坦言失利难辞其咎，时长约1分1秒</div></div>
//<p class="jsx-513965227 text">世界杯偃旗息鼓，中国篮坛却又平地起惊雷。</p>
//<p class="jsx-513965227 text">有消息称，男篮主帅李楠已申请辞职，目前正等待总局批复。虽然此事尚无官方消息，但如若李楠离开，继任者一事便不得不提上日程。</p>
//<div data-boss="pic&amp;modular=content" class="jsx-513965227 pic"><div class="jsx-513965227 responsive-image" style="max-width: 641px;"><div class="jsx-513965227 sizer" style="padding-top: 66.77%;"></div><div class="jsx-513965227 image-wrap"><img src="http://inews.gtimg.com/newsapp_bt/0/10221552998/641" alt="李楠离任真的可以拯救一切吗？" class="jsx-513965227"></div></div><div class="jsx-513965227 desc">李楠离任真的可以拯救一切吗？</div></div><p class="jsx-513965227 text">而既然说到换帅，就难免提到我国三大球近30年间永远在讨论、永远没结论的“路线之争”——继续起用本土教头，还是再花重金去网罗国外名帅？</p><p class="jsx-513965227 text">此前中国男篮3次跻身奥运八强，以及由此发散的，上世纪90年代和本世纪头10年这两段“黄金年代”，恰巧分别是土帅和洋帅执教的成功范例。</p><p class="jsx-513965227 text">然而在亚洲、世界赛事那些惨痛的失败中，在主帅位置上短暂尝试而并不成功的，也同样既有土帅，又有洋帅，所以很难简单地分出高下来。</p>
//<p class="jsx-513965227 text">结合本世纪以来中国男篮在主帅聘用上成功与失败的例证，并结合业内资深专家的剖析，我们不妨摆出男篮换帅各种可能的优劣与可能性权重，做一番理性的讨论。</p><p class="jsx-513965227 text">当然，比起单纯好与坏的评判，“适合”才是更难拿捏，也是更至关重要的标准。</p><p class="jsx-513965227 text"><h2>延续土帅？没有联赛经历才是硬伤</h2></p><p class="jsx-513965227 text">虽然本届世界杯“倒李”之声愈演愈烈，但去年的这个时候，可正是李楠作为男篮红队教练，声望正值鼎盛之时。率领着没有易建联的中国队战胜韩国，时隔8年后重夺亚运会金牌，也成了他在与杜峰PK中胜出，最终成为国家队主帅的一大砝码。</p><div data-boss="pic&amp;modular=content" class="jsx-513965227 pic"><div class="jsx-513965227 responsive-image" style="max-width: 641px;"><div class="jsx-513965227 sizer" style="padding-top: 65.05%;"></div><div class="jsx-513965227 image-wrap"><img src="http://inews.gtimg.com/newsapp_bt/0/10238864884/641" alt="李楠率领中国男篮亚运会夺冠" class="jsx-513965227"></div></div><div class="jsx-513965227 desc">李楠率领中国男篮亚运会夺冠</div></div>
//<p class="jsx-513965227 text">由于姚明在上任后分组红蓝两队，在主帅人选上也采取聘用制，这让国内教练中诸多年富力强、颇具声望、俱乐部执教经验丰富的名帅都不愿参与，而最终参与竞聘的只有上述两位加上崔万军。这3人中李楠的年纪虽然排在中间，却是唯一没有CBA联赛主教练经验的。</p>
//<p class="jsx-513965227 text">上世纪末至今执掌过中国男篮教鞭的本土主帅中，很少有不是从俱乐部教练岗位一路走上来的。</p>
//<p class="jsx-513965227 text">从女篮转战男篮的宫鲁鸣可能是唯一例外，其余主帅中，早年的蒋兴权、王非自不必说，与李楠年龄相仿的郭士强，以及当初选帅前进入公众讨论范畴的李春江、李秋平等，都是在CBA争冠级的强队中磨砺而出的。</p><p class="jsx-513965227 text">即便是竞聘中输给李楠，比他小了7岁的杜锋，从2013年起就担任广东男篮的主教练，期间还曾与中国男篮前主帅尤纳斯搭档。</p>
//<div data-boss="pic&amp;modular=content" class="jsx-513965227 pic"><div class="jsx-513965227 responsive-image" style="max-width: 641px;"><div class="jsx-513965227 sizer" style="padding-top: 66.61%;"></div><div class="jsx-513965227 image-wrap"><img src="http://inews.gtimg.com/newsapp_bt/0/10238873591/641" alt="李楠没有CBA执教经验" class="jsx-513965227"></div></div><div class="jsx-513965227 desc">李楠没有CBA执教经验</div></div><p class="jsx-513965227 text">李楠近10年间的执教履历中，除了早年担任八一青年队主帅，其后就一直在国家队教练组辅佐邓华德、扬纳基斯和宫鲁鸣3任主帅，直至2016年担任国奥主帅，另外还担任过2017全运会山东男篮的主帅。</p><p class="jsx-513965227 text">履历虽然丰富，但是每一项都不足以支撑作为国家队主帅的重责，尤其是担任主要领导的经历匮乏，也都展现为他本届世界杯执教时应对困难局面的准备不足、办法不多。</p>
//<p class="jsx-513965227 text">毕竟作为CBA一线队的主教练，除了临场的指挥和应变外，整个赛季与全队征战南北过程中的融合、全年训练比赛引援等多方面计划的参与，再到赛季中各种突发情况的压力测试，都远比李楠此前执教履历中任何一项都强化得多，也真实地多。</p>
//<p class="jsx-513965227 text">在目前李楠帅位岌岌可危之际，又一次进入替换人选讨论的，包括过去两个赛季有率队打总决赛经验的李春江和郭士强，以及在本届男篮担任助教、在CBA北京队执教口碑颇好的雅尼斯等。无论继任者是土是洋，都很难想象会有下个没有“地方工作经验”，而直接从教练组中扶正的例子。</p><div data-boss="pic&amp;modular=content" class="jsx-513965227 pic"><div class="jsx-513965227 responsive-image" style="max-width: 641px;"><div class="jsx-513965227 sizer" style="padding-top: 66.61%;"></div><div class="jsx-513965227 image-wrap"><img src="http://inews.gtimg.com/newsapp_bt/0/10238893122/641" alt="如果要换，谁将是最佳人选？" class="jsx-513965227"></div></div><div class="jsx-513965227 desc">如果要换，谁将是最佳人选？</div></div><p class="jsx-513965227 text"><h2>重寻洋帅？池子广阔大鱼多，但犯错空间非常小</h2></p><p class="jsx-513965227 text">中国男篮距离上一任外籍主教练离去已经整整6年了，而当时扬纳基斯离开时也曾闹得很不愉快。</p><p class="jsx-513965227 text">纵观中国男篮的洋帅聘用史，美国的德尔-哈里斯到立陶宛的尤纳斯，然后从美国的邓华德到希腊的扬纳基斯，美—欧—美—欧的路线并看不出太具体的思路。</p>
//<p class="jsx-513965227 text">这其中尤纳斯当然是执教时间最长、口碑最好、各方面综合评定最成功的一位。但他后来在广东男篮并不成功的尝试证明，这位老帅距离时代的要求已经渐行渐远了。</p><div data-boss="pic&amp;modular=content" class="jsx-513965227 pic"><div class="jsx-513965227 responsive-image" style="max-width: 641px;"><div class="jsx-513965227 sizer" style="padding-top: 133.85%;"></div><div class="jsx-513965227 image-wrap"><img src="http://inews.gtimg.com/newsapp_bt/0/10238905510/641" alt="再次选择国际名帅？" class="jsx-513965227"></div></div><div class="jsx-513965227 desc">再次选择国际名帅？</div></div>
//<p class="jsx-513965227 text">就中国男篮是否需要重新寻找、聘用国际名帅的话题，腾讯体育邀请对于国内、美国、欧洲市场均有深入了解的中国篮球资深专家发表了见解。</p>
//<p class="jsx-513965227 text">关于潜在的选帅方向，据该专家介绍，目前中国篮协与立陶宛、塞尔维亚两国篮协的交流密切，关系较好。再加上此前和尤纳斯的长期合作也较为愉快，而国内队塞尔维亚教练也开始有所涉猎（譬如四川男篮已聘用塞尔维亚国青队主帅托米斯拉夫为助教）。</p><p class="jsx-513965227 text">本着用熟不用生的原则，在这两个目的地国寻找国家队新主帅有一定可能性。</p><p class="jsx-513965227 text">除了着眼于传统较为相近的中东欧，该专家还建议不妨继续拓宽视野，朝西班牙、美国等头部阵营的篮球强国找找方向。尤其是随着我们与NBA交往合作的日益密切，再加上姚明作为篮协主席的广博人脉，可以考虑暂无教职的NBA主教练这一丰富的资源。</p><p class="jsx-513965227 text">此前中国男篮也使用过美国主帅，但哈里斯合作时间短，且他当时在NBA主要担任助教工作，而邓华德早年也并无太过突出的执教履历。从名气到实力，以及对中国篮球的熟悉度，在NBA并非没有合适的候选。</p><p class="jsx-513965227 text">选择洋帅的“池子”虽大，“大鱼”也多，但给中国篮协试错的空间却很小。该专家认为，主要原因之一是合同签订方面，通常一签就是一个奥运周期，若是在合同存续期间发现不合适或出现各类突发状况，即便能换，整个过程也会引发诸多连续性的问题。</p><p class="jsx-513965227 text">除此之外，毕竟中国男篮已经6年没有聘用外籍主帅了，而与扬纳基斯当时的不欢而散也难免对于当下的选择产生警示的效果。</p><div data-boss="pic&amp;modular=content" class="jsx-513965227 pic"><div class="jsx-513965227 responsive-image" style="max-width: 641px;"><div class="jsx-513965227 sizer" style="padding-top: 66.61%;"></div><div class="jsx-513965227 image-wrap"><img src="http://inews.gtimg.com/newsapp_bt/0/10238925768/641" alt="与扬纳基斯的合作最后不欢而散" class="jsx-513965227"></div></div><div class="jsx-513965227 desc">与扬纳基斯的合作最后不欢而散</div></div><p class="jsx-513965227 text">像外教在语言文化、生活习俗、情感交流上迟迟无法融入球队和居住环境，已经是老生常谈的话题了，虽然也是因人而异，但若处理不好，选帅的努力前功尽弃。</p><p class="jsx-513965227 text">此外，该专家还强调了训练、比赛理念上的一处明显差异。根据球员的体验，国际级、高水平的洋帅带队之后主抓的通常都是战术、执行力和纪律这一类的问题。</p><p class="jsx-513965227 text">对于个人的技术问题，外教会默认球员已经没有问题，不需要在这个层面接受指导。然而所有战术的执行最终还是得落实到个人的基本功和战术素养，而在这一层面即便是我们的国家队球员，也很难说个个过关。一来二去，先进理念和不扎实的技术之间的落差，就显现得尤为明显了。</p><p class="jsx-513965227 text"><h2>结语</h2></p><p class="jsx-513965227 text">据腾讯体育得到的消息，篮协主席姚明如今对李楠依旧信任，这也和姚明世界杯时的表态和发声相吻合，但由于男篮未能实现最低目标，有些事已非姚明一人能够掌控。</p><p class="jsx-513965227 text">事实上，对于中国男篮来说，无论李楠是否真的下课，又或继任者选择洋帅还是土帅，更重要的一点，在于姚明提及中国男篮与世界诸强不断拉大的差距时，说的那一句：“睁眼看世界”。</p><p class="jsx-513965227 text">这不仅表现在国家队、国内球员积极走出去，适应世界顶尖的比赛节奏、强度的过程，教练组本身的理念方法、临场应对、科学决策、团队建设等必备技能，也应该瞧出与世界强队的差距。</p><p class="jsx-513965227 text">中国篮球，任重道远。</p><p class="jsx-513965227 text">（Rayingfish）</p><div class="jsx-513965227 video-wrapper" style="display: none; top: 0px;"><div id="mod_player" class="jsx-513965227 video-player"></div></div></div>
//<div data-boss-expo="end&amp;modular=content" data-boss-once="true" class="jsx-1273719342"></div></div>
//  """,
            //Optional parameters:
            padding: EdgeInsets.all(8.0),
            linkStyle: const TextStyle(
              color: Colors.redAccent,
              decorationColor: Colors.redAccent,
              decoration: TextDecoration.underline,
            ),
            onLinkTap: (url) {
              print("Opening $url...");
            },
            onImageTap: (src) {
              print(src);
            },
            //Must have useRichText set to false for this to work
            customRender: (node, children) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "custom_tag":
                    return Column(children: children);
                }
              }
              return null;
            },
            customTextAlign: (dom.Node node) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "p":
                    return TextAlign.justify;
                }
              }
              return null;
            },
            customTextStyle: (dom.Node node, TextStyle baseStyle) {
              if (node is dom.Element) {
                switch (node.localName) {
                  case "p":
                    return baseStyle.merge(TextStyle(height: 2, fontSize: 20));
                }
              }
              return baseStyle;
            },
          ),
        ),
      ),
    );
  }
}
