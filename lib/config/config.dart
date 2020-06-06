const servicePath = {
   'videoContent':'http://gank.io/api/data/%E7%A6%8F%E5%88%A9/10/', // 视频一级
   'audioList':'http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.billboard.billList&type=2&size=10&offset=0', // 音乐列表
   'audioWords':'http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.song.lry&songid=213508', // 歌词列表
   'audioInfo':'http://tingapi.ting.baidu.com/v1/restserver/ting?method=baidu.ting.song.play', // 歌曲信息
};

const String DefaultChannleUrl= "https://ss1.bdstatic.com/70cFuXSh_Q1YnxGkpoWK1HF6hhy/it/u=2768348726,1854484849&fm=11&gp=0.jpg";


String VERSION="1.0.0";
const int LOG_LEVEL=0;
const int APP_ID=1;
const int WAY=1;//渠道
const int DOWNLOAD_THREAD_NUM=3;
const int TOTAL_CACHE_NUM_MAX=500;
const int MOVIE_CACHE_NUM_MAX=30;
const int STARTUP_SECONDES  = 3;

const String ASSETS_IMG = 'assets/images/';
String LOCAL_IP="";
String EXTERNAL_IP="";
String DEVICE_ID;
String DEVICE_BRAND;
//int USER_ID;
int WS_PORT=8416;
const int TRUN_UDP_SERVER_PORT=9999;
const int TRUN_WS_SERVER_PORT=8181;
int LOCAL_UDP_PORT=12136;
const int HTTP_SERVER_PORT=12017;
const String PLAYLIST_M3U8 ="playlist.m3u8";//零时预定，有可能不妥
const String VIDEO_SERVER_IP="119.28.188.181";
const String TURN_SERVER_IP="119.28.188.181";
const String MAIN_SERVER_URL="https://feikantec.com";

const String BASE_SERVER_URL="http://video.feikantec.com/pvideo";


const String BASE_VIDEO_URL="http://$VIDEO_SERVER_IP";
const String LOCAL_VIDEO_URL="http://127.0.0.1:$HTTP_SERVER_PORT";
const String GET_MOVIES_URL="/video/getMovies.do?columnId=";
const String GET_SERIALS_URL="$BASE_SERVER_URL/video/getTvSerials.do?";
const String GET_SEQUELS_URL="$BASE_SERVER_URL/video/getTvSequels.do?";
const String GET_SERIAL_URL="$BASE_SERVER_URL/video/getTvSerial.do?";
const String GET_VODS_URL="$BASE_SERVER_URL/video/getVods.do?typeId=";
const String GET_SPORTSVODS_URL="$BASE_SERVER_URL/video/getSportsVods.do?typeId=";
const String GET_CHANNELS_URL="/video/getChannels.do?type=";
const String GET_PROGRAMS_URL="/video/getPrograms.do?type=";
const String GET_PROGRAMSBYDAY_URL="$BASE_SERVER_URL/video/getProgramsByDay.do?day=";
const String GET_PROGRAMSBYEVENT_URL="$BASE_SERVER_URL/video/getProgramsByEvent.do?event=worldcup";
const String GET_CURRENT_PROGRAMS_URL="$BASE_SERVER_URL/video/getCurrentPrograms.do?";
const String GET_HOT_PROGRAMS_URL="$BASE_SERVER_URL/video/getHotPrograms.do?";
const String GET_GET_LEAGUE_PROGRAMS_URL="$BASE_SERVER_URL/video/getLeaguePrograms.do?";
const String GET_ANCHORS_URL="$BASE_SERVER_URL/video/getAnchors.do?";
const String GET_SPORTS_TYPES_URL="$BASE_SERVER_URL/video/getSportsTypes.do?";
const String GET_TOPICS_URL="$BASE_SERVER_URL/video/getTopics.do?";
const String GET_LALAS_URL="$BASE_SERVER_URL/video/getPictures.do?";
const String ADD_SOURCE_URL="/video/addSource.do?";
const String FUZZY_QUERY_URL="$BASE_SERVER_URL/video/fuzzyQueryVods.do?";
const String GET_VERSION_URL="$MAIN_SERVER_URL/version";
//const String DOWNLOAD_URL="$MAIN_SERVER_URL/strawberry.apk";
const String HOME_URL="$MAIN_SERVER_URL/home.html";
const String LOGIN_URL="$BASE_SERVER_URL/client/login.do?";
const String REGISTER_URL="$BASE_SERVER_URL/client/register.do?";
const String GUEST_URL="$BASE_SERVER_URL/client/guest.do?";//访客
const String ACTION_REPORT_URL="$BASE_SERVER_URL/client/clientReport.do?";
const String HOLE_REPORT_URL="$BASE_SERVER_URL/client/peerReport.do?";
const String LOG_REPORT_URL="$BASE_SERVER_URL/client/logReport.do?";
const String GET_RCMD_VODS_URL="$BASE_SERVER_URL/video/getRcmdVods.do?";
const String GET_RCMD_CHANNELS_URL="$BASE_SERVER_URL/video/getRcmdChannels.do?";
//充值
const String user_charge_URL="$BASE_SERVER_URL/client/charge.do?";


const String WS_SERVER_URL="ws://$TURN_SERVER_IP:$TRUN_WS_SERVER_PORT";




