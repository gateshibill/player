import 'package:player/model/media_model.dart';
import 'package:player/model/user_model.dart';

import '../model/topic_model.dart';
import '../model/vod_model.dart';
import '../model/metadata_model.dart';
import '../model/program_model.dart';
import '../model/channel_model.dart';
import '../model/anchor_model.dart';
import '../model/stype_model.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';
import '../model/picture_model.dart';

int NODE_ID=0;
String BASE_DIR="";
String latestVersion;
String downlaodLink;
String description;
bool isReport=false;
String token="";
String DeviceId;
//udp p2p
StringBuffer pNodeSesionBuffer = new StringBuffer();

UserModel me;
//浏览历史视频
List<VodModel> historyVodList = new List<VodModel>();
//浏览历史频道
List<ChannelModel> historyChannelList = new List<ChannelModel>();
//猜用户喜欢
List<ChannelModel> guessChannelList = new List<ChannelModel>();
//用户收藏
List<MediaModel> favoritesList = new List<MediaModel>();

//首页
List<VodModel> homeVodList=[];
//视频内容
List<List<VodModel>> videoVodList=[[],[],[]];

List<MetadataModel> metadataList=[];

//电视剧列表
List<VodModel> tvSerialVodList = new List<VodModel>();

//首页推荐频道
List<ChannelModel> rcmdChannellist=[];
//体育频道
List<List<ChannelModel>> sportsChannelList=[[],[],[],[],[],[],[],[],[],[]];
//电视频道,
List<List<ChannelModel>> tvChannelList=[[],[],[],[],[],[],[],[],[],[]];

//录播电视回看视频
List<List<VodModel>> sportsPlaybackVodList=[[],[],[],[],[],[],[],[],[],[],[]];
//七天电视节目单
List <List<ProgramModel>> commonProgramlist=[[],[],[],[],[],[],[]];
//赛事节目单
List<ProgramModel> eventProgramlist=[];
//当前正在播出节目单
List<ProgramModel> currentProgramlist=[];
//当前正在播出赛事节目单
List<ProgramModel> currentEventProgramlist=[];
//视频内容
List<List<VodModel>> movieList=[[],[],[],[],[],[],[],[]];
//花絮
List results = []; // 数据数组
List<PictureModel> lalas = []; // 花絮数据

//主播内容
List<AnchorModel> anchorList=[];

//体育总赛事
List<StypeModel> stypeList=[];
//热门赛事
List<ProgramModel> leagueProgramList = [];
//新闻列表
List<TopicModel> topicList=[];

//搜索历史
List<String> searchHistoryList = ["三国","复仇","人民"];
Set <String> searchVodKeyWordSet=Set<String>();

//全局播放器
IjkMediaController homeMediaController = IjkMediaController();

//当前播放内容
MediaModel currentPlayMedia;


