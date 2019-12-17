<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>审批人员配置</title>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/pro.css">
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript">
var editIndex = undefined;
var thistab = undefined;

//结束当前行编辑

function endEditing(tabid) {
	var editIndex = undefined;
	var row = tabid.datagrid('getSelected');
	editIndex = tabid.datagrid('getRowIndex', row);
	if (editIndex == undefined) {
		return true
	}
	if (tabid.datagrid('validateRow', editIndex)) {
		tabid.datagrid('endEdit', editIndex);
		editIndex = undefined;
		return true;
	} else {
		return false;
	}
}

//点击单元格事件

function onClickCell(index, field) {
	thistab = $(this);
	window.event.cancelBubble = true; //阻止冒泡事件 （行点击事件）
	if (endEditing($(this))) {
		$(this).datagrid('selectRow', index).datagrid('editCell', {
			index: index,
			field: field
		});
		editIndex = index;
	}
}

//单元格编辑结束事件

function onEndEdit(index, row) {
	var ed = $(this).datagrid('getEditor', {
		index: index,
		field: 'user_type_'
	});
/*  if(ed!=null){
     row.user_type_ = $(ed.target).combobox('getText');
    } */

}

var taskNode = "";//节点
var formId = "";  //表单Id
var tableName = "";//表单类型为超链接表单时赋值
var freeFormId = "";//表单类型为自由表单时赋值
//添加自定义审批人员
function append(id, nodeid) {
	if(nodeid != taskNode) {
		if(findFormInfo(nodeid)){
			addRow(id, nodeid, "");
		};
	}else{
		addRow(id, nodeid, "");
	}
}
//添加来自表单的审批人员
function accept(id, nodeid) {
	if(nodeid != taskNode) {
		if(findFormInfo(nodeid)){
			addRow(id, nodeid, "13");
		};
	}else{
		addRow(id, nodeid, "13");
	}
}

/*添加一行数据*/
function addRow(id, nodeid, userType){
	if(formId == null || formId == ""){
		taskNode = "";
		formId = "";
		tableName = "";//表单类型为超链接表单时赋值
		freeFormId = "";//表单类型为自由表单时赋值
		window.parent.$.messager.alert('警告','业务方案未配置表单！');
		return;
	}
	if (endEditing($("#" + id))) {
		var data = {
			user_type_: userType,
			node_info_id_: nodeid,
			form_id_ : formId,
			free_form_id_ : freeFormId,
			table_name_ : tableName,
			proc_def_id_: "${procdefid}",
			sol_id_: "${solId}",
			required_: "P",
			com_user_: "P"
		}
		$("#" + id).datagrid('appendRow', data);
		editIndex = $('#' + id).datagrid('getRows').length - 1;
		$('#' + id).datagrid('selectRow', editIndex).datagrid('editCell', {
			index: editIndex,
			field: 'user_type_'
		});;
	}
}

/*获取业务绑定的表单信息*/
function findFormInfo(nodeid){
	var flag = false;
	taskNode = "";
	formId = "";
	$.ajax({
		url : "${ctx}/bizSolMgr/findTaskFormInfo",
		type : "post",
		data : {
			nodeInfoId : nodeid,
			procDefId : "${procdefid}",
			solId : "${solId}"
		},
		async: false,
		dataType : "json",
		success : function(data){
			if(data){
				if(data.flag == "true"){
					taskNode = nodeid;
					formId = data.formId;
					freeFormId = data.freeFormId;
					tableName = data.tableName;
					flag = true;
				}else{
					window.parent.$.messager.alert('警告',data.msg);
				}
			}
		}
	})
	return flag;
}

//数据表格行移除事件

function removeit(id) {
	var row = $('#' + id).datagrid('getSelected');
	var editIndex = $('#' + id).datagrid('getRowIndex', row);
	if (row) {
		if (editIndex == undefined) {
			return
		}
		$('#' + id).datagrid('cancelEdit', editIndex).datagrid('deleteRow', editIndex);
		if (row.id != '' && row.id != undefined) {
			$.ajax({
				url: "${ctx}/bizSolMgr/doDelApproveUser?id=" + row.id,
				type: 'POST',
				dataType: 'json',
				success: function(result) {
					if (result.result == "success") {
						$('#' + id).datagrid('reload');
					}
				}
			});
		}
		editIndex = undefined;
	} else {
		$.messager.alert('警告', '选择一条数据');
	}
}

//保存审批人员信息
function saveassessofc(id) {
	if (endEditing($('#' + id))) {
		var effectRow = new Object();
		effectRow[id] = JSON.stringify($('#' + id).datagrid('getData'));
		$.ajax({
			url: '${ctx}/bizSolMgr/doSaveApproveUser?actid=' + id,
			type: 'POST',
			dataType: 'json',
			data: effectRow,
			success: function(result) {
				var msg = "";
				if (result.result == "success") {
					msg = "保存成功！";
					$('#' + id).datagrid('reload');
				}else{
					msg = "保存失败！";
				}
				$.messager.show({title : '提示',msg : msg ,timeout : 2000});
			}
		});
	}
}

//审批人员批量保存事件

function saveallassessofc() {
	$("table[name='asstable']").each(function() {
		var tabid = $(this).attr("id");
		saveassessofc(tabid);
	});
}

//取消行编辑事件

function cancelEdit() {
	$("table[name='asstable']").each(function() {
		var id = $(this).attr("id");
		var row = $('#' + id).datagrid('getSelected');
		var thisindex = $('#' + id).datagrid('getRowIndex', row);
		$("#" + id).datagrid('endEdit', thisindex);
		editIndex = undefined;
	});
}

//单元格编辑前触发事件

function onBeforeEdit(index, row) {
	if (row != null) {
		if (row.user_type_ == '1') {
			row.user_name_ = '发起人';
		}else if(row.user_type_ == '14'){
			row.user_name_ = '上一节点';
		}
	}
}

//用户选择图标点击事件

function onClickIcon() {
	var row = thistab.datagrid('getSelected');
	if (row.user_type_ != '1') {
		var url = "";
		if (row.user_type_ == '3') {
			//用户组
			url = "${ctx}/userGroupController/selectUserGroup";
		} else if (row.user_type_ == '4') {
			//部门树
			url = "${ctx}/orgController/getOrgDeptTreeAsyn";
		} else if (row.user_type_ == '5') {
			//岗位
			url = "${ctx}/orgController/selectDeptPostTree";
		} else if (row.user_type_ == '6') {
			//角色
			url = "${ctx}/roleController/selectRoleList";
		} else if (row.user_type_ == '13') {
			//变量来自单
			url = "${ctx}/bizSolMgr/tofindEntityMessage?solId=${solId}";
		} else {
			//人员
			url = "${ctx}/orgController/selectOrgDeptUser";
		}
		window.parent.$('#choose_user').attr('src', url);
		window.parent.$('#chooseper').dialog({    
			title: '用户选择',
			width: 800,
			height: 450,
			closed: false,
			cache: false,
			modal: true,
			onResize: function() {
				$(this).dialog('center');
			}
		}); 
	}
}

//人员选择确定事件

function makesure(arr) {
	var row = thistab.datagrid('getSelected');
	index = thistab.datagrid('getRowIndex', row);
	var ed = thistab.datagrid('getEditor', {
		index: index,
		field: 'user_name_'
	});
	ed.target.textbox("setValue", arr[1]);
	row.user_value_ = arr[0];
	window.parent.$('#chooseper').dialog('close');
}

/**
 *1、如果变量是人员，如果只有一个人运算符用and
 *
 */
var userTypeData = [{
	type: '1',
	usertype: '发起人'
}, {
	type: '2',
	usertype: '用户'
}, {
	type: '3',
	usertype: '用户组'
}, {
	type: '4',
	usertype: '部门'
}, {
	type: '5',
	usertype: '岗位'
}, {
	type: '6',
	usertype: '角色'
}, {
	type: '7',
	usertype: '用户或组来自流程变量'
}, {
	type: '8',
	productname: '用户或组来自表单数据'
}, {
	type: '9',
	usertype: '用户或组来自脚本运算结果'
}, {
	type: '10',
	usertype: '用户来自用户关系运算结果'
}, {
	type: '11',
	usertype: '用户组来自用户与组关系运算结果'
}, {
	type: '12',
	usertype: '用户来自用户与组关系运算结果'
}, {
	type: '13',
	usertype: '变量来自表单'
}, {
	type: '14',
	usertype: '返回上一节点'
}];
</script>
</head>
<body onclick="cancelEdit()">
<div style="padding:5px">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveallassessofc()">批量保存</a>
</div>
<div style="padding:5px;">
	<table class="table-style">
		<tr>
			<th width="15%" class="Theader">审批环节</th>
			<th width="85%" class="Theader">人员配置</th>
		</tr>
		<c:choose>
	   		<c:when test="${not empty nodelist}">
	   			<c:forEach items="${nodelist}" var="node" varStatus="vs">
					<tr>
						<th>${node.actName_}</th>
						<td style="padding:10px;">
							<table id="${node.actId_}" name="asstable" class="easyui-datagrid table-inner" title="" style="width:100%;height:auto"
					            data-options=" iconCls: 'icon-edit', singleSelect: true, toolbar: '#${node.actId_}_1',
					                url: '${ctx}/bizSolMgr/findApproveUserCfg?procDefId=${procdefid}&&nodeInfoId=${node.id}&&solId=${solId}', method: 'get', 
					                onClickCell: onClickCell, onEndEdit: onEndEdit,onBeforeEdit:onBeforeEdit">
						        <thead>
						            <tr>
						            	<th data-options="field:'ck',checkbox:true,align:'center'"></th>
						            	<th data-options="field:'form_id_',hidden:true"></th>
						            	<th data-options="field:'free_form_id_',hidden:true"></th>
						            	<th data-options="field:'table_name_',hidden:true"></th>
						                <th data-options="field:'user_type_',width:'20%',align:'center',
						                        formatter:function(value,row){
						                        for (var i=0;i<userTypeData.length;i++){
							                        if (userTypeData[i].type == value) {
		            									return userTypeData[i].usertype;
		        									}
						                        }
						                        },
						                        editor:{
						                            type:'combobox',
						                            options:{
						                                valueField:'type',
						                                textField:'usertype',
						                                required:true,
						                                editable:false,
						                                data: userTypeData
						                            }
						                        }">用户类型</th>
						                <th data-options="field:'user_name_',width:'25%',align:'center',
						                				editor:{
						                					type:'textbox',
						                					options:{
						                					required:false,
	    													iconWidth:22,
										                    icons: [{
										                        iconCls:'icon-man',
										                        handler: function(e){
										                            var v = $(e.data.target).textbox('getValue');
										                        }
										                    }],
										                    onClickIcon:onClickIcon
						                					}
						                				}
						                ">用户值</th>
						                <th hidden="true" data-options="field:'user_value_',align:'center', editor:'textbox'">用户id</th>
						                <th data-options="field:'operator_',width:'20%',align:'center', formatter:function(value,row){
						                            return row.operator_;
						                        },
						                        editor:{
						                            type:'combobox',
						                            options:{
						                                valueField:'type',
						                                textField:'operator',
						                                method:'get',
						                                required:false,
						                                data: [{
															type: 'AND',
															operator: '与'
														},{
															type: 'OR',
															operator: '或'
														},{
															type: 'NOT',
															operator: '非'
														}]
						                            }
						                        }">计算逻辑</th>
						                <th data-options="field:'com_user_',width:'10%',align:'center',editor:{type:'checkbox',options:{on:'P',off:''}}">是否计算用户</th>
						                <th data-options="field:'sort_',width:'10%',align:'center',editor:'numberspinner'">序号</th>
						            </tr>
						        </thead>
					    	</table>
						    <div id="${node.actId_}_1" style="height:auto">
						        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append('${node.actId_}','${node.id}')">添加</a>
						        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="removeit('${node.actId_}')">删除</a>
						        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="accept('${node.actId_}','${node.id}')">从表单中添加</a>
						        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveassessofc('${node.actId_}')">保存</a>
						    </div>
					    </td>
					</tr>
				</c:forEach>
			</c:when>
		</c:choose>
	</table>
</div>
<!-- 弹出选人界面 -->
<div id="chooseper" class="easyui-dialog" title="My Dialog" style="width:400px;height:200px;"   
        data-options="iconCls:'icon-save',resizable:false,modal:false" closed="true" buttons="#dlg-buttons">
	<iframe id="choose_user" src=""  width="100%" height="395" frameborder="no" border="0" marginwidth="0"
					marginheight="0" scrolling="no" style=""></iframe>
	<div id="dlg-buttons" class="window-tool">
		<a class="easyui-linkbutton" data-options="plain:true" onclick="makesure()">确定sss</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#chooseper').dialog('close')" plain="true">取消</a>
	</div>
</div>
<!-- 弹出选人界面end  -->

<script type="text/javascript">
//扩展方法，点击事件触发一个单元格的编辑
$.extend($.fn.datagrid.methods, {
	editCell: function(jq,param){
		return jq.each(function(){
			var opts = $(this).datagrid('options');
			var fields = $(this).datagrid('getColumnFields',true).concat($(this).datagrid('getColumnFields'));
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor1 = col.editor;
				if (fields[i] != param.field){
					col.editor = null;
				}
			}
			$(this).datagrid('beginEdit', param.index);
			for(var i=0; i<fields.length; i++){
				var col = $(this).datagrid('getColumnOption', fields[i]);
				col.editor = col.editor1;
			}
		});
	}
});
</script>
</body>
</html>