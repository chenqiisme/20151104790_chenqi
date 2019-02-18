/**
 * Created by ideabobo on 14-6-28.
 */

var rootUrl = "http://localhost:8080/gongxiangdanche4/";
var fileurl = rootUrl+"upload/";
var clientUrl = rootUrl+"Client!";
var uploadUrl = rootUrl+"Upload";



var myObj = window.myObj||{};
var localType={
    lastmessagetime:"lastmessagetime"
}
//setInterval(function(){
//    var ts = localStorage[localType.lastmessagetime];
//    var obj = {};
//    if(ts){
//        obj.startTime = ts;
//    }
//    ajaxCallback("getMessage",obj,function(data){
//        console.log("message:"+JSON.stringify(data));
//        if(data.length){
//            for(var i=0;i<data.length;i++){
//                var msg = data[i];
//                myObj.showIntentActivityNotify && myObj.showIntentActivityNotify(msg.title,msg.note,i);
//            }
//            localStorage[localType.lastmessagetime] = data[0].ts;
//        }
//    },true);
//},5000);


function ownpage(el){
    $("#showimg").css({"left":"0px","top":"0px"});
    changePage("imgshow");
    $("#showimg").attr("src",el.src);
    var imgcontaner = document.getElementById("showimg");
    var hammertime = Hammer(imgcontaner, {
        preventDefault: true
    });
    var lastScale = 1;
    var startX = 0;
    var startY = 0;
    var changeX = 0;
    var changeY = 0;
    var currentX = 0;
    var currentY = 0;
    var hasDoubleTap = false;
    hammertime.on("transform",function(ev){
        $(imgcontaner).css({"transform":"scale("+ev.gesture.scale*lastScale+","+ev.gesture.scale*lastScale+")"});
        lastScale = ev.gesture.scale;
        $("#showimg").css({"left":"0px","top":"0px"});
    });
    hammertime.on("dragstart",function(ev){
        $(imgcontaner).css({"transition": ""});
        startX = ev.gesture.center.clientX;
        startY = ev.gesture.center.clientY;
        currentX = $(imgcontaner).css("left").split("px")[0]*1;
        currentY = $(imgcontaner).css("top").split("px")[0]*1;
    });
    hammertime.on("drag",function(ev){
        changeX = ev.gesture.center.clientX-startX;
        changeY = ev.gesture.center.clientY-startY;
        $(imgcontaner).css("left",currentX+changeX);
        $(imgcontaner).css("top",currentY+changeY);
    });
    hammertime.on("doubletap",function(ev){
        $("#showimg").css({"left":"0px","top":"0px"});
        if(hasDoubleTap){
            $(imgcontaner).css({"transform":"scale(1,1)","transition": "all 200ms ease-in"});
            hasDoubleTap = false;
        }else{
            $(imgcontaner).css({"transform":"scale(6,6)","transition": "all 200ms ease-in"});
            hasDoubleTap = true;
        }

    });

}

function getPositionByBaidu(json){
    hideLoader();
    var info = JSON.parse(json);
    var latitude = info.latitude;
    var longitude = info.longitude;
    var addr = info.addr;
    myObj.myshare("我的位置",addr);
}

function getLocation(){
    showLoader("正在获取您的位置!");
    myLocation.getLocation();
}

function saomiao() {
    scanCode(function (id){
        ajaxCallback("getPark",{id:id},function(data){
            toPark(data);
        });
    });
}


function openScanCode() { //打开微信扫一扫
    isMiniProgram(wx, (res)=>{//是否为小程序环境
         if (res) {//小程序环境
              wx.miniProgram.navigateTo({url: '../scanCode/scanCode'});//跳转到小程序调用微信扫一扫页面
          } else {//非小程序环境（公众号环境）
              //通过jssdk方法调用微信扫一扫，代码忽略
         }
      })
}
function isMiniProgram(callback) { //是否为小程序环境
     //是否在微信环境
     if (!isWeixin()) {
         callback(false);
     } else {
          //微信API获取当前运行环境
          wx.miniProgram.getEnv((res) => {
              if (res.miniprogram) {//小程序环境
                  callback(true);
              } else {
                  callback(false);
              }
         })
     }
}

function isWeixin() {
	   var ua = window.navigator.userAgent.toLowerCase();
	   if (ua.match(/MicroMessenger/i) == 'micromessenger') {
	     return true;
	   } else {
	     return false;
	   }
	 }
