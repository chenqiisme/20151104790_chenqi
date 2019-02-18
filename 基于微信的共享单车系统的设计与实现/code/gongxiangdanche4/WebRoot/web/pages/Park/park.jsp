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
        title: '列表',
        nowrap: false,
        striped: true,
        fit: true,
        url: "<%=__APP__%>/Park!getList",
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
                {title: 'id', width: 10, field: 'id', sortable: true},
                {title: '名称', width: 100, field: 'gname', sortable: true},
                {title: '地址', width: 100, field: 'address', sortable: true},
                {title: '单车数', width: 100, field: 'count', sortable: true}
            ]
        ], toolbar: [
            {
                text: '新增',
                id: "tooladd",
                disabled: false,
                iconCls: 'icon-add',
                handler: function () {
                	managForm.reset();
                    $("#action").val("add");
                    $("#managerDialog").dialog('open');
                   
                }
            },
            '-',
            {
                text: '修改',
                id: 'tooledit',
                disabled: false,
                iconCls: 'icon-edit',
                handler: function () {
                    $("#action").val("edit");
                    var selected = $('#grid1').datagrid('getSelected');
                    if (selected) {
                        edit(selected);
                    } else {
                        $.messager.alert("提示", "请选择一条记录进行操作");
                    }
                }
            },
            '-',
            {
                text: '管理单车',
                id: 'tooledit',
                disabled: false,
                iconCls: 'icon-edit',
                handler: function () {
                    $("#action").val("edit");
                    var selected = $('#grid1').datagrid('getSelected');
                    if (selected) {
                        mgChewei(selected);
                    } else {
                        $.messager.alert("提示", "请选择一条记录进行操作");
                    }
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
    
    
    $('#grid2').datagrid({
        title: '列表',
        nowrap: false,
        striped: true,
        fit: true,
        url: "<%=__APP__%>/Park!getList",
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
                {title: 'id', width: 10, field: 'id', sortable: true},
                {title: '名称', width: 100, field: 'title', sortable: true},
                {title: '状态', width: 100, field: 'statecn', sortable: true}
            ]
        ], toolbar: [
            {
                text: '新增',
                id: "tooladd",
                disabled: false,
                iconCls: 'icon-add',
                handler: function () {
                    $("#action2").val("add");
                    $("#managerDialog2").dialog('open');
                    managForm2.reset();
                }
            },
            '-',
            {
                text: '空闲中',
                id: 'tooledit',
                disabled: false,
                iconCls: 'icon-edit',
                handler: function () {
                    $("#action2").val("edit");
                    var selected = $('#grid2').datagrid('getSelected');
                    if (selected) {
                    	changeCheweiStatus(selected.id,"空闲中");
                    } else {
                        $.messager.alert("提示", "请选择一条记录进行操作");
                    }
                }
            },
            '-',
            {
                text: '已占用',
                id: 'tooledit',
                disabled: false,
                iconCls: 'icon-edit',
                handler: function () {
                    $("#action2").val("edit");
                    var selected = $('#grid2').datagrid('getSelected');
                    if (selected) {
                    	changeCheweiStatus(selected.id,"已占用");
                    } else {
                        $.messager.alert("提示", "请选择一条记录进行操作");
                    }
                }
            },
            '-',
            {
                text: '删除',
                id: 'tooldel',
                disabled: false,
                iconCls: 'icon-remove',
                handler: function () {
                    var rows = $('#grid2').datagrid('getSelections');
                    if (rows.length) {
                        var ids = "";
                        for (var i = 0; i < rows.length; i++) {
                            ids += rows[i].id + ",";
                        }
                        ids = ids.substr(0, (ids.length - 1));
                        $.messager.confirm('提示', '确定要删除吗？', function (r) {
                            if (r) {
                                deleteItem2(ids);
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
    
    $("#typeid").combobox({
        method:"get",
        url:'<%=__APP__%>/Park!typeList',
        valueField: 'id',
        textField: 'title'
    });
});

function save() {
	var type = $("#typeid").combobox("getText");
	$("#type").val(type);
    $('#managForm').form('submit', {
        url: "<%=__APP__%>/Park!add",
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
    $("#address").val(obj.address);
    //$("#typeid").combobox("setValue", obj.typeid);
    $("#price").val(obj.price);
    $("#count").val(obj.count);
    $("#tel").val(obj.tel);
    //$("#jifen").numberbox('setValue', obj.jifen);
    $("#note").val(obj.note);
    $("#img2").val(obj.img);
    $("#managerDialog").dialog('open');
}

function deleteItem(uuid) {
    openBackGround();
    $.post("<%=__APP__%>/Park!deleteItem", {id: uuid}, function (data) {
        closeBackGround();
        closeFlush();
    });
}



function save2() {
    $('#managForm2').form('submit', {
        url: "<%=__APP__%>/Chewei!add",
        onSubmit: function () {
            return inputCheck2();
        },
        success: function (data) {
            closeBackGround();
            $.messager.alert("提示", data, "info", function () {
            	$("#managerDialog2").dialog("close");
    	        $("#grid2").datagrid("reload");
            });
        }
    });
}

function edit2(obj) {
	var id = obj.id;
    $("#id").val(id);
    $("#gname").val(obj.gname);
    $("#address").val(obj.address);
    //$("#typeid").combobox("setValue", obj.typeid);
    $("#price").val(obj.price);
    $("#count").val(obj.count);
    $("#tel").val(obj.tel);
    //$("#jifen").numberbox('setValue', obj.jifen);
    $("#note").val(obj.note);
    $("#img2").val(obj.img);
    $("#managerDialog").dialog('open');
}

function deleteItem2(uuid) {
    openBackGround();
    $.post("<%=__APP__%>/Chewei!deleteItem", {id: uuid}, function (data) {
        closeBackGround();
        $("#managerDialog2").dialog("close");
        $("#grid2").datagrid("reload");
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
    managForm.reset();
    $("#managerDialog").dialog('close');
    $("#listDialog").dialog("close");
    $("#grid1").datagrid("reload");
}

function inputCheck() {
    if (!($("#managForm").form("validate"))) {
        return false;
    }
    openBackGround();
    return true;
}

function inputCheck2() {
    if (!($("#managForm2").form("validate"))) {
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
}

var focusobj = null;
function mgChewei(obj){
	focusobj = obj;
	$("#pid").val(obj.id);
	$("#listDialog").dialog("open");
	$("#grid2").datagrid("options").url="<%=__APP__%>/Chewei!getList?pid="+obj.id;
	$("#grid2").datagrid("reload");
}

function changeCheweiStatus(id,statecn){
	 $.post("<%=__APP__%>/Chewei!changeState", {id: id,statecn:statecn}, function (data) {
	        closeBackGround();
	        $("#managerDialog2").dialog("close");
	        $("#grid2").datagrid("reload");
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
                            <label for="sgname">名称：</label>
                            <input type="text" id="sgname" name="sgname" width="100%" maxlength="32"/>
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


<div id="managerDialog" class="easyui-dialog" title="网点管理" style="width:650px;height:350px;" toolbar="#dlg-toolbar"
     buttons="#dlg-buttons2" resizable="true" modal="true" closed='true'>
    <form id="managForm" name="managForm" method="post" enctype="multipart/form-data">
        <input type="hidden" id="action" name="action"/>
        <input type="hidden" id="id" name="id"/>
        <input type="hidden" id="type" name="park.type"/>
        <table cellpadding="1" cellspacing="1" class="tb_custom1">
            <tr>
                <th width="30%" align="right"><label>名称：</label></th>
                <td width="30%">
                    <input id="gname" name="park.gname" class="easyui-validatebox"
                           style="width:200px;word-wrap: break-word;word-break:break-all;" type="text" required="true"
                           validType="length[0,100]"/>
                </td>
                <th width="30%" align="right"><label>价格：</label></th>
                <td width="30%">
                    <input id="price" name="park.price" style="width:200px;word-wrap: break-word;word-break:break-all;" />
                </td>
            </tr>
            
			<tr>
			<th width="30%" align="right"><label>地区：</label></th>
                <td width="30%">
                    <input id="typeid" name="park.typeid" style="width:200px;word-wrap: break-word;word-break:break-all;" />
                </td>
                <th width="30%" align="right"><label>地址：</label></th>
                <td width="30%">
                    <input type="text" name="park.address" id="address" style="width:200px;word-wrap: break-word;word-break:break-all;"/>
                </td>
            </tr>
            <tr>
                <th width="30%" align="right"><label>联系电话：</label></th>
                <td colspan="" width="30%">
                    <input type="text" name="park.tel" id="tel" style="width:200px;word-wrap: break-word;word-break:break-all;"/>
                </td>
                <th width="30%" align="right"><label>单车数：</label></th>
                <td width="30%">
                    <input type="text" id="count" name="park.count" style="width:200px;word-wrap: break-word;word-break:break-all;"/>
                </td>
            </tr>
            <tr>
                <th width="30%" align="right"><label>照片：</label></th>
                <td colspan="3" width="30%">
                    <input type="file" name="img" id="img" style="width:200px;word-wrap: break-word;word-break:break-all;"/>
                    <input type="hidden" name="park.img" id="img2"/>
                </td>
            </tr>

            <tr>
                <th width="30%" align="right"><label>备注：</label></th>
                <td colspan="3" width="30%">
                    <textarea rows="" cols="" style="width:100%;height: 100px;" id="note" name="park.note"></textarea>
                </td>

            </tr>
        </table>


    </form>
    <div id="dlg-buttons2">
        <a href="#" class="easyui-linkbutton" onclick="save();">保存</a>
        <a href="#" class="easyui-linkbutton" onclick="cancel();">取消</a>
    </div>
</div>



<div id="listDialog" class="easyui-dialog" title="单车列表" style="width:650px;height:350px;" toolbar="#dlg-toolbar" resizable="true" modal="true" closed='true'>
    <table id="grid2"></table>
</div>




<div id="managerDialog2" class="easyui-dialog" title="网点管理" style="width:450px;height:250px;" toolbar="#dlg-toolbar"
     buttons="#dlg-buttons3" resizable="true" modal="true" closed='true'>
    <form id="managForm2" name="managForm2" method="post" enctype="multipart/form-data">
        <input type="hidden" id="action2" name="action"/>
        <input type="hidden" id="id2" name="id"/>
        <input type="hidden" id="pid" name="chewei.pid"/>
        <table cellpadding="1" cellspacing="1" class="tb_custom1">
            <tr>
                <th width="30%" align="right"><label>编号：</label></th>
                <td width="30%" colspan="3">
                    <input id="title" name="chewei.title" class="easyui-validatebox"
                           style="width:200px;word-wrap: break-word;word-break:break-all;" type="text" required="true"
                           validType="length[0,100]"/>
                </td>
            </tr>
        </table>
    </form>
    <div id="dlg-buttons3">
        <a href="#" class="easyui-linkbutton" onclick="save2();">保存</a>
        <a href="#" class="easyui-linkbutton" onclick="cancel();">取消</a>
    </div>
</div>

</body>
</html>