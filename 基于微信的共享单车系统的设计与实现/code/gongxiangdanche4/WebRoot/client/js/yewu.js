/**
 * Created by Bowa on 2014/8/28.
 */
var parklist = [];
var tempparklist = [];
var focusobj = null;
var shoucang = "shoucang";

var isSelect = false;
var isArrive = false;
var isLeave = false;
var cheweilist = [];
var _yid="";
var _duetime=2;

$(function(){
//设置类别列表


    var p2 = {};
    p2.tpl = '<li><a href="#" onclick="toPark(%s);">'+
        '<img src="'+fileurl+'%s" class="ui-li-thumb">'+
        '<h2>%s</h2>'+
        '<p>%s</p>'+
        '</a><a onclick="removeCar(%s)"></a></li>';
    p2.colums = ["id","img","gname","note","id"];
    $("#parks").data("property",JSON.stringify(p2));
    $("#cars").data("property",JSON.stringify(p2));

    var p22 = {};
    p22.tpl = '<li onclick="toPark(%s);">'+
        '<img src="'+fileurl+'%s">'+
        '<h2>%s</h2>'+
        '<p>%s</p>'+
        '</li>';
    p22.colums = ["id","img","gname","note"];
    $("#goodlist").data("property",JSON.stringify(p22));



    var p6 = {};
    p6.tpl = '<li><a href="#" onclick="">'+
    '<h2>%s</h2>'+
    '<p>%s</p>'+
    '<p>%s</p>'+
    '</a></li>';
    p6.colums = ["ndate","note","username"];
    $("#replays").data("property",JSON.stringify(p6));

    var p666 = {};
    p666.tpl = '<li onclick="noticeDetail(%s)">'+
        '<h2>%s</h2>'+
        '<p>%s</p>'+
        '</li>';
    p666.colums = ["id","title","note"];
    $("#noticelist").data("property",JSON.stringify(p666));

});

function toMain(){
    changePage("mainpage");
    goodlist();
}

function goodlist(){
    /*ajaxCallback("listPark",{},function(data){
        parklist = data;
        $("#goodlist").refreshShowListView(data);
    });*/
    $("#goodlist").refreshShowListView(parklist);
}

function toMapPage(){
    changePage('mappage');
    if(!map){
        initMap();
    }
}


function refreshPark(title,type){
    var stype = title || $("#type").val() || "";
    ajaxCallback("listPark",{stype:stype},function(data){
        $("#parks").refreshShowListView(data);
    });
}

function listPark(sid){
    ajaxCallback("listPark",{sid:sid},function(data){
        parklist = data;
        $("#parks").refreshShowListView(data);
    });
}

function list3Park(sid){
    ajaxCallback("listPark",{sid:sid},function(data){
        parklist = data;
        var newlist = [];
        for(var i=0;i<3;i++){
            newlist.push(data[i]);
        }
        $("#parks").refreshShowListView(newlist);
    });
}

function toFabu(){
    changePage("fabupage");
}

function savePark(){
    var fdata = serializeObject($("#goodform"));
    fdata.sid = userinfo.id;
    fdata.shop = userinfo.username;

    uplaodImg(function(img){
        fdata.img = img;
        ajaxCallback("savePark",fdata,function(){
            showTipTimer("分享成功!",function (){
                toMain();
            });
        });
    });
}


function listType(){
    ajaxCallback("listType",{},function(data){
        $("#type").empty();
        var html = "<option value=''>请选择</option>";
        $("#type").append(html);
        for(var i=0;i<data.length;i++){
            var obj = data[i];
            var html = "<option value='"+obj.id+"'>"+obj.title+"</option>";
            $("#type").append(html);
        }
    });
}

function toList(flag){
    changePage("parklistpage");
    if(flag == 1){
        listPark();
    }else{
        list3Park();
    }

}

function toPark(obj){
    if(typeof  obj != "object"){
        obj = getParkById(obj);
    }

    focusobj = obj;

    changePage("parkpage");
    $("#gname2").text("网点名称:"+obj.gname);
    $("#gimg2").attr("src",fileurl+obj.img);
    $("#gnote2").text("介绍:"+obj.note);
    $("#address").text("地址:"+obj.address);


    showButtons();

    listReplay();
    ajaxCallback("listChewei",{pid:obj.id},function(data){
        cheweilist = data;
        $("#count").text("剩余单车数:"+cheweilist.length||0);
        $("#chewei").refreshShowSelectMenu(data,"显示空闲单车","id","title");

        ajaxCallback("listType2",{},function(data){
            $("#shijian").refreshShowSelectMenu(data,"选择时间","id","title");
        });
    });

}

function showButtons(){
    $("#likai").hide();
    $("#yidaoda").hide();
    $("#yuyue").hide();
    $("#yydiv").hide();

    if(isSelect){
        if(isArrive){
            if(isLeave){
                $("#likai").hide();
            }else{
                $("#likai").show();
            }

        }else{
            $("#yidaoda").show();
        }
    }else{
        $("#yuyue").show();
    }
}

function arrived(){
    isArrive = true;
    showLoader("已到达开始计时",true);
    cal();
    showButtons();
    ajaxCallback("daoda",{id:_yid,arrivetime:Date.now()},function(){

    });
    startRestTimmer();
}
var _totalmoney = 0;
function likai(){
    $("#likai").hide();
    $("#yidaoda").hide();
    $("#yuyue").hide();
    showLoader("已离开请发布你的评价",true);
    isLeave = true;
    reset();

    $("#paymoney").text("请付款："+_totalmoney);
    ajaxCallback("left",{id:_yid,arrivetime:Date.now()},function(){
        changePage('paypage');
        //toMain();
    });
    ajaxCallback("cheweiState",{id:focusobj.chewei,statecn:"空闲中"},function(data){

    });
}

function paybill(){
    /*if(userinfo.money<_totalmoney){
        showLoader("余额不足!",true);
        return;
    }*/
    ajaxCallback("payBillMoney",{money:_totalmoney,uid:userinfo.id},function(data){
        if(data.info!="-1"){
            userinfo = data;
            showTipTimer("付款成功!",function(){
                toMain();
            });
        }else{
            showTipTimer("操作失败!",function(){

            });
        }

    });


}

function jiaoyajin(){
    ajaxCallback("jiaoyajin",{money:299,uid:userinfo.id},function(data){
        if(data.info!="-1"){
            userinfo = data;
            showTipTimer("付款成功!",function(){
                toMain();
            });
        }else{
            showTipTimer("操作失败!",function(){

            });
        }

    });


}




function yuyue(){
    /*if(userinfo.isyajin!="是"){
        changePage('paypage2');
        return;
    }*/
    if(cheweilist.length){

    }else{
        showLoader("没有剩余单车!",true);
        return;
    }
    /*if(userinfo.money=='undefined' || !userinfo.money){
        showLoader("余额不足,无法预约!",true);
        return;
    }*/

    var point = document.getElementById("mark"+focusobj.id);
    if(point){
        point.style.backgroundImage="url('images/pfocus.png')";
    }
    isSelect = true;
    showButtons();
    focusobj.username = userinfo.username;
    focusobj.tel = userinfo.tel;
    focusobj.shijian = $("#shijian").val();
    focusobj.chewei = $("#chewei").val();
    if(focusobj.chewei==""){
        if(cheweilist.length){
            focusobj.chewei = cheweilist[0].id;
        }else{
            showLoader("没有剩余单车!",true);
            return;
        }
    }
    focusobj.uid = userinfo.id;
    focusobj.username = userinfo.username;
    ajaxCallback("yuyue",focusobj,function(data){
        _yid = data.info;
        //toMapPage();
    });

    /*var duretime = $("#duetime").val();
    _duetime = duretime&&duretime*1||0;
    myObj.showIntentActivityNotify("停车提醒","您已预定单车,请及时前往",100);*/



    ajaxCallback("zan",{id:focusobj.typeid},function(data){
        var id2 = $("#shijian").val();
        ajaxCallback("zan2",{id:id2},function(data){

        });
    });


}
var _restTimmer = null;
var _count = 0;
function startRestTimmer(){
    clearInterval(_restTimmer);
    _count=0;
    _restTimmer = setInterval(function (){
        _count++;
        if(_count>=_duetime*60){
            myObj.showIntentActivityNotify("停车提醒","已到达预设的租车时间",100);
            clearInterval(_restTimmer);
        }
    },60000);
}

function cancely(){
    isSelect = false;
    ajaxCallback("cheweiState",{id:focusobj.chewei,statecn:"空闲中"},function(data){

    });
    changePage("mainpage");
}

function getParkById(id){
    for(var i=0;i<parklist.length;i++){
        var park = parklist[i];
        if(park.id == id){
            return park;
        }
    }
    return null;
}

function addFav(){
    var str = localStorage[shoucang];
    var list = [];
    if(str){
        list = JSON.parse(str);
    }
    var flag = true;
    for(var i=0;i<list.length;i++){
        if(focusobj.id==list[i].id){
            flag = false;
            break;
        }
    }
    if(flag){
        list.push(focusobj);
        localStorage[shoucang] = JSON.stringify(list);
    }

    showLoader("添加收藏成功!",true);
    $("#delshoucang").show();
    $("#shoucang").hide();
}

function showCar(){
    changePage("carspage");
    carlist();
}

function toSearch(){
    changePage("searchpage");
}


function carlist(){
    var str = localStorage[shoucang];
    var list = [];
    if(str){
        list = JSON.parse(str);
    }
    $("#cars").refreshShowListView(list);
}

function removeCar(id){
    var id = id || focusobj.id;
    var str = localStorage[shoucang];
    var list = [];
    var newlist = [];
    if(str){
        list = JSON.parse(str);
        for(var i=0;i<list.length;i++){
            var obj = list[i];
            if(obj.id == id){
                continue;
            }
            newlist.push(obj);
        }
        localStorage[shoucang] = JSON.stringify(newlist);
        showLoader("移出收藏成功!",true);
        $("#cars").refreshShowListView(newlist);
    }
}

function checkCar(id){
    var str = localStorage[shoucang];
    var list = [];
    if(str){
        list = JSON.parse(str);
        for(var i=0;i<list.length;i++){
            var obj = list[i];
            if(obj.id == id){
                return true;
            }
        }
    }else{
        return false;
    }
}


function listReplay(){
    ajaxCallback("listReplay",{pid:focusobj.id},function(data){
        $("#replays").refreshShowListView(data);
    });
}
function addReplay(){
    var note = $("#rnote").val();
    ajaxCallback("addReplay",{pid:focusobj.id,uid:userinfo.id,username:userinfo.username,note:note},function(data){
        listReplay();
    });
}





var timecount=-1;
var gltimer;
function cal(){
    gltimer=setInterval(function(){
        timecount+=1;
        $("#timmerlabel").text("点击归还(已使用:"+timecount+"秒,距离1米)");
    },1000);
}
function reset(){
    if(gltimer!=null){
        var m = Math.ceil(timecount/3600);
        _totalmoney = m*focusobj.price;
        timecount=-1;
        clearInterval(gltimer);
    }
}


function toFankui(){
    changePage('fankuipage');
}

function saveFankui(){
    var note = $("#note22").val();
    ajaxCallback("addReplay",{pid:100000,uid:userinfo.id,username:userinfo.username,note:note},function(data){
        showLoader("操作成功!",true);
    });
}



var focuslist = null;
function toNotice(){
    changePage('noticepage');
    listNotice();
}

function listNotice(){
    ajaxCallback("listNotice",{},function(data){
        focuslist = data;
        $("#noticelist").refreshShowListView(data);
    });
}

function noticeDetail(id){
    var obj = getObjectById(id,focuslist);
    changePage('noticedetailpage');
    $("#vtitle").text(obj.title);
    $("#vnote").text(obj.note);
    $("#vndate").text("时间:"+obj.ndate);

}