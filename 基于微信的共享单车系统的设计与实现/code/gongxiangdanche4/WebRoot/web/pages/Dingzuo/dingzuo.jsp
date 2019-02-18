<!DOCTYPE html>
<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%@ taglib prefix="s" uri="/struts-tags"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>


<html>
<head id="Head1">
    <%@ include file="/web/common/common.jsp" %>
<script type="text/javascript">
$(function () {
    $('#grid1').datagrid({
        title: '预订列表',
        nowrap: false,
        striped: true,
        fit: true,
        url: "<%=__APP__%>/Dingzuo!getList",
        idField: 'id',
        pagination: true,
        rownumbers: true,
        pageSize: 10,
        pageNumber: 1,
        singleSelect: true,
        fitColumns: true,
        pageList: [10, 20, 50, 100, 200, 300, 500, 1000],
        sortName: 'id',
        sortOrder: 'desc',
        columns: [
            [
                //{field: 'ck', checkbox: true},
                {title: 'id', width: 100, field: 'id', sortable: true,hidden:true},
                {title: '网点', width: 100, field: 'shopname', sortable: true},
                {title: '日期', width: 100, field: 'todate', sortable: true},
                {title: '使用人', width: 100, field: 'username', sortable: true},
                {title: '电话', width: 100, field: 'shouji', sortable: true},
                {title: '结算', width: 100, field: 'openid', sortable: true},
                {title: '备注', width: 100, field: 'beizhu',sortable: true}
            ]
        ]
         , toolbar: [
            /* {
                text: '新增',
                id: "tooladd",
                disabled: false,
                iconCls: 'icon-add',
                handler: function () {
                    $("#action").val("add");
                    $("#managerDialog").dialog('open');
                    managForm.reset();
                }
            },
            '-',*/
            {
                text: '统计图',
                id: 'tooledit',
                disabled: false,
                iconCls: 'icon-edit',
                handler: function () {
                	showChart();
                }
            },
            '-', 
            {
                text: '删除',
                id: 'tooldel',
                disabled: false,
                iconCls: 'icon-remove',
                handler: function () {
                    var rows = $('#grid1').datagrid('getSelections');
                    if (rows.length) {
                        var ids = "";
                        for (var i = 0; i < rows.length; i++) {
                            ids += rows[i].id + ",";
                        }
                        ids = ids.substr(0, (ids.length - 1));
                        $.messager.confirm('提示', '确定要删除吗？', function (r) {
                            if (r) {
                                deleteItem(ids);
                            }
                        });
                    } else {
                        $.messager.alert("提示", "请选择一条记录进行操作");
                    }
                }
            }
        ] 
    });

    document.onkeydown=function (e){
        e = e ? e : event;
        if(e.keyCode == 13){
            query();
        }
    }

});

function save() {
    $('#managForm').form('submit', {
        url: "<%=__APP__%>/Dingzuo!add",
        onSubmit: function () {
            return inputCheck();
        },
        success: function (data) {
            closeBackGround();
            $.messager.alert("提示", data, "info", function () {
                closeFlush();
            });
        }
    });
}

function edit(obj) {
	var id = obj.id;
    $("#id").val(id);
    $("#gname").val(obj.gname);
    $("#type").combobox("setValue", obj.type);
    $("#price").numberbox('setValue', obj.price);
    $("#count").numberbox('setValue', obj.count);
    $("#jifen").numberbox('setValue', obj.jifen);
    $("#note").val(obj.note);
    $("#managerDialog").dialog('open');
}

function deleteItem(uuid) {
    openBackGround();
    $.post("<%=__APP__%>/Dingzuo!deleteItem", {id: uuid}, function (data) {
        closeBackGround();
        closeFlush();
    });
}

function cancel() {
    $.messager.confirm('提示', '是否要关闭？', function (r) {
        if (r) {
            closeFlush();
        }
    });
}

function query() {
    $('#grid1').datagrid('load', serializeObject($('#searchForm')));
}


function closeFlush() {
    //managForm.reset();
    $("#managerDialog").dialog('close');
    $("#grid1").datagrid("reload");
}

function inputCheck() {
    if (!($("#managForm").form("validate"))) {
        return false;
    }
    openBackGround();
    return true;
}

function show(index) {

    var rows = $("#grid1").datagrid('getRows');
    var obj = rows[index];
    var id = obj.id;
    $("#id2").text(obj.id);
    $("#gname2").text(obj.gname);
    $("#gbrand2").text(obj.gbrand);
    $("#intime2").text(obj.intime);
    $("#gmodel2").text(obj.gmodel);
    $("#gcolor2").text(obj.gcolor);
    $("#gprice2").text(obj.gprice);
    $("#note2").text(obj.note);
    $("#gnumber2").text(obj.gnumber);

    $("#viewDialog").dialog('open');
    //});
}


function setNull(){
    searchForm.reset();
    $("#sgname").datebox("setValue","");
}




function showChart(obj){
    $("#chartdialog").dialog('open');
    refreshChart(obj);
    refreshChart2();

}

function refreshChart(obj){
    $.post(__APP__+"/Park!typeList",{},function(data){
        data = JSON.parse(data);
        var xarray = [];
        var yarray = [];
        for(var i=0;i<data.length;i++){
        	xarray.push(data[i].title);
        	yarray.push(data[i].zan);
        }
        var myChart = echarts.init(document.getElementById('mychat'));
        var option = {
            color: ['#3398DB'],
            tooltip : {
                trigger: 'axis',
                //formatter: "{a} <br/>{b}: {c} ({d}%)",
                axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                    type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                }
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
            xAxis : [
                {
                    type : 'category',
                    data : xarray,
                    axisTick: {
                        alignWithLabel: true
                    }
                }
            ],
            yAxis : [
                {
                    type : 'value'
                }
            ],
            series : [
                {
                    name:'使用次数',
                    type:'bar',
                    barWidth: '60%',
                    data:yarray
                }
            ]
        };
        myChart.setOption(option);
    });
}


function refreshChart2(){
    $.post(__APP__+"/Park!typeList2",{},function(data){
        data = JSON.parse(data);
        var xarray = [];
        var yarray = [];
        for(var i=0;i<data.length;i++){
        	xarray.push(data[i].title);
        	yarray.push(data[i].zan);
        }
        var myChart2 = echarts.init(document.getElementById('mychat2'));
        var option = {
            color: ['#3398DB'],
            tooltip : {
                trigger: 'axis',
                //formatter: "{a} <br/>{b}: {c} ({d}%)",
                axisPointer : {            // 坐标轴指示器，坐标轴触发有效
                    type : 'shadow'        // 默认为直线，可选为：'line' | 'shadow'
                }
            },
            grid: {
                left: '3%',
                right: '4%',
                bottom: '3%',
                containLabel: true
            },
            xAxis : [
                {
                    type : 'category',
                    data : xarray,
                    axisTick: {
                        alignWithLabel: true
                    }
                }
            ],
            yAxis : [
                {
                    type : 'value'
                }
            ],
            series : [
                {
                    name:'使用次数',
                    type:'bar',
                    barWidth: '60%',
                    data:yarray
                }
            ]
        };
        myChart2.setOption(option);
    });
}
</script>
</head>
<body class="easyui-layout">
<div region="north" border="false" style="height:3px;overflow: hidden"></div>
<div region="west" border="false" style="width:3px;"></div>
<div region="east" border="false" style="width:3px;"></div>
<div region="south" border="false" style="height:3px;overflow: hidden"></div>
<div region="center" border="false">
    <div id="main" class="easyui-layout" fit="true" style="width:100%;height:100%;">
        <div region="north" id="" style="height:100%;" class="" title="查询条件">
            <form action="" id="searchForm" name="searchForm" method="post">
                <table cellpadding="5" cellspacing="0" class="tb_search">
                    <tr>
                        <td width="10%">
                            <label for="sgname">日期：</label>
                            <input type="text" id="sgname" class="easyui-datebox" name="sgname" width="100%" maxlength="32"/>
                        </td>
                        <td width="10%">
                            <a href="#" onclick="query();" id="querylink" class="easyui-linkbutton"
                               iconCls="icon-search">查询</a>
                            <a href="#" onclick="setNull();" class="easyui-linkbutton" iconCls="icon-redo">重置</a>
                        </td>
                    </tr>
                </table>
            </form>
        </div>
        <div region="center" border="false" style="padding:3px 0px 0px 0px;overflow:hidden">

            <table id="grid1"></table>

        </div>
    </div>
</div>



<div id="chartdialog" class="easyui-dialog" title="柱状图" style="width:850px;height:550px;" toolbar="#dlg-toolbar"
     resizable="true" modal="true" closed='true'>

    <div id="mychat" style="width: 800px;height:400px;"></div>
    <div id="mychat2" style="width: 800px;height:400px;"></div>
</div>
<script type="text/javascript" src="<%=__APP__ %>/web/public/js/echarts.min.js"></script>

</body>
</html>