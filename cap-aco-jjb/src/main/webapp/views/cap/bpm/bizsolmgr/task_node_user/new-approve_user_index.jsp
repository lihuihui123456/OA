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
<script type="text/javascript" src="${ctx}/views/cap/bpm/bizsolmgr/task_node_user/js/jquery.edatagrid.js"></script>
<script type="text/javascript">

	var userTypeData = [ {
		"type" : "1",
		"userType" : "发起人"
	}, {
		"type" : "2",
		"userType" : "用户"
	}, {
		"type" : "3",
		"userType" : "用户组"
	}, {
		"type" : "4",
		"userType" : "部门"
	}, {
		"type" : "5",
		"userType" : "岗位"
	}, {
		"type" : "6",
		"userType" : "角色"
	}, {
		"type" : "7",
		"userType" : "用户或组来自流程变量"
	}, {
		"type" : "8",
		"productname" : "用户或组来自表单数据"
	}, {
		"type" : "9",
		"userType" : "用户或组来自脚本运算结果"
	}, {
		"type" : "10",
		"userType" : "用户来自用户关系运算结果"
	}, {
		"type" : "11",
		"userType" : "用户组来自用户与组关系运算结果"
	}, {
		"type" : "12",
		"userType" : "用户来自用户与组关系运算结果"
	}, {
		"type" : "13",
		"userType" : "变量来自表单"
	}, {
		"type" : "14",
		"userType" : "返回上一节点"
	} ]

	$(function() {
		init();
	})

	var editIndex = undefined;
	var editTableObj = undefined;
	
	function init() {
		var procDefId = "${procdefid}";
		var solId = "${solId}";
		var nodeId;
		$("[name='table']").each(function(index) {
			var tableObj = $(this);
			nodeId = tableObj.attr("id").split("_")[1];
			tableObj.datagrid({
				url : "${ctx}/bizSolMgr/findApproveUserCfg",
				method : "get",
				queryParams : {
					procDefId : procDefId,
					nodeInfoId : nodeId,
					solId : solId
				},
				idField : 'id',
				singleSelect : true,
				checkOnSelect : true,
				selectOnCheck : true,
				nowrap : true,
				loadMsg : "正在加载 ...",
				columns : [ [ {
					field : 'id',
					hidden : true
				}, {
					field : 'form_id_',
					hidden : true
				}, {
					field : 'free_form_id_',
					hidden : true
				}, {
					field : 'table_name_',
					hidden : true
				}, {
					field : 'user_value_',
					hidden : true
				}, {
					field : 'ck',
					checkbox : true,
					width : '5%',
					align : 'center'
				}, {
					field : 'user_type_',
					title : '用户类型',
					width : '20%',
					align : 'center',
					formatter : userTypeFormatter,
					editor : {
						type : "combobox",
						options : {
							valueField : 'type',
							textField : 'userType',
							required : true,
							editable : false,
							data : userTypeData
						}
					}
				}, {
					field : 'user_name_',
					title : '用户值',
					width : '40%',
					align : 'center',
					editor : {
						type : "textbox",
						options : {
							editable : false,
							required : true,
							iconWidth : 22,
							icons : [ {
								iconCls : 'icon-man',
								handler : function(e) {//图标单击事件
									//var v = $(e.data.target).textbox('getValue');
									onClickIcon(tableObj, $(e.data.target));
								}
							} ],
						}
					}
				}, {
					field : 'operator_',
					title : '计算逻辑',
					width : '10%',
					align : 'center',
					editor : {
						type : "combobox",
						options : {
							valueField : 'type',
							textField : 'operator',
							required : false,
							editable : false,
							panelHeight : 70,
							data : [ {
								type : 'AND',
								operator : '与'
							}, {
								type : 'OR',
								operator : '或'
							}, {
								type : 'NOT',
								operator : '非'
							} ]
						}
					}
				}, {
					field : 'com_user_',
					title : '计算用户',
					width : '10%',
					align : 'center',
					editable : false,
					editor : {
						type : "checkbox",
						options : {
							on : 'P',
							off : ''
						}
					}
				}, {
					field : 'sort_',
					title : '序号',
					width : '5%',
					align : 'center',
					editor : "numberspinner"
				} ] ],
				onClickCell : onClickCell,
				onBeforeEdit:onBeforeEdit
			});
		})
	}

	function userTypeFormatter(value, row, index) {
		if (value) {
			if (userTypeData) {
				$(userTypeData).each(function(i) {
					if (value == this.type) {
						value = this.userType;
						return value;
					}
				})
			}
		}
		return value;
	}

	/**
	 * 插入一行记录
	 */
	function append(actId, nodeId, userType) {
		var tableId = actId + "_" + nodeId;
		var tableObj = $("#" + tableId);
		if (nodeId != taskNode) {
			if (findFormInfo(nodeId)) {
				addRow(tableObj, nodeId, userType);
			}
		} else {
			addRow(tableObj, nodeId, userType);
		}
	}

	var taskNode = "";//节点
	var formId = ""; //表单Id
	var tableName = "";//表单类型为超链接表单时赋值
	var freeFormId = "";//表单类型为自由表单时赋值
	/*获取业务绑定的表单信息*/
	function findFormInfo(nodeId) {
		var flag = false;
		taskNode = "";
		formId = "";
		$.ajax({
			url : "${ctx}/bizSolMgr/findTaskFormInfo",
			type : "post",
			data : {
				nodeInfoId : nodeId,
				procDefId : "${procdefid}",
				solId : "${solId}"
			},
			async : false,
			dataType : "json",
			success : function(data) {
				if (data) {
					if (data.flag == "true") {
						taskNode = nodeId;
						formId = data.formId;
						freeFormId = data.freeFormId;
						tableName = data.tableName;
						flag = true;
					} else {
						window.parent.$.messager.alert('警告', data.msg);
					}
				}
			}
		})
		return flag;
	}

	//添加一行数据
	function addRow(tableObj, nodeId, userType) {
		var operator;
		var userName;
		if (userType == '1' || userType == '2') {
			operator = "OR";
			userName = "发起人";
		} else {
			operator = "AND";
			userName = "请选择字段！"
		}
		//插入一行新数据
		tableObj.datagrid('insertRow', {
			row : {
				id : null,
				user_type_ : userType,
				node_info_id_ : nodeId,
				form_id_ : formId,
				free_form_id_ : freeFormId,
				table_name_ : tableName,
				proc_def_id_ : "${procdefid}",
				sol_id_ : "${solId}",
				operator_ : operator,
				com_user_ : "P"
			}
		});
		var index = tableObj.datagrid('getRows').length - 1;
		tableObj.datagrid('selectRow', index).datagrid('editCell', {
			index: index,
			field: 'user_type_'
		});;
	}

	//删除一行数据
	function remove(actId, nodeId) {
		var tableId = actId + "_" + nodeId;
		var tableObj = $("#" + tableId);
		var row = tableObj.datagrid('getSelected');
		if (row != null) {
			var index = tableObj.datagrid('getRowIndex', row);
			if (row.id == null) {
				tableObj.edatagrid('deleteRow', index);
				tableObj.datagrid('clearSelections');
			} else {
				$.ajax({
					url : "${ctx}/bizSolMgr/doDelApproveUser?id=" + row.id,
					type : 'POST',
					dataType : 'json',
					success : function(result) {
						if (result) {
							if (result.result == "success") {
								tableObj.datagrid('reload');
								tableObj.datagrid('clearSelections');
								$.messager.show({
									title : '提示',
									msg : '删除成功！',
									timeout : 2000
								});
							} else {
								$.messager.show({
									title : '提示',
									msg : '删除失败！',
									timeout : 2000
								});
							}
						}
					}
				});
			}
		} else {
			$.messager.show({
				title : '提示',
				msg : '请选择要删除的记录！',
				timeout : 2000
			});
		}
	}

	function save(actId, nodeId) {
		var tableId = actId + "_" + nodeId;
		var tableObj = $("#" + tableId);
		var rows = tableObj.datagrid('getChanges');
		if (rows) {
			var index;
			var flag = true;
			$(rows).each(
					function(i) {
						index = tableObj.datagrid('getRowIndex', rows[i]);
						if (!tableObj.datagrid('endEdit', index).datagrid(
								'validateRow', index)) {
							flag = false;
						}
					})
			if (flag) {
				var effectRow = new Object();
				effectRow[actId] = JSON.stringify(rows);
				$.ajax({
					url : "${ctx}/bizSolMgr/doSaveApproveUser?actid=" + actId,
					type : "post",
					dataType : "json",
					data : effectRow,
					success : function(result) {
						if (result) {
							var msg = "";
							if (result.result == "success") {
								msg = "保存成功！";
								tableObj.datagrid('reload');
							} else {
								msg = "保存失败！";
							}
							$.messager.show({
								title : '提示',
								msg : msg,
								timeout : 2000
							});
						}
					}
				});
			} else {
				$.messager.show({
					title : '提示',
					msg : '请完善输入项！',
					timeout : 2000
				});
			}
		}
	}

	function saveAll() {
		var tableObj;
		var actId;
		var nodeId;
		$("[name='table']").each(function(index) {
			tableObj = $(this);
			actId = tableObj.attr("id").split("_")[0];
			nodeId = tableObj.attr("id").split("_")[1];
			save(actId, nodeId);
		});
	}
</script>
</head>
<body>
<div style="padding:5px">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveAll()">批量保存</a>
</div>
<div style="padding:5px;">
	<table class="table-style">
		<thead>
			<tr>
				<th class="tache">流程环节</th>
				<th class="person">人员配置</th>
			</tr>
		</thead>
		<tbody>
		<c:if test="${nodelist != null && not empty nodelist}">
			<c:forEach var="node" items="${nodelist}" varStatus="vs">
			<!-- 当前迭代数 -->
			<c:set var="index" value="${vs.index}"></c:set>
			<!-- 环节名称-->
			<c:set var="actName" value="${node.actName_ }"></c:set>
			<!-- 节点actId-->
			<c:set var="actId" value="${node.actId_ }"></c:set>
			<!-- 节点Id-->
			<c:set var="nodeId" value="${node.id}"></c:set>
			<tr>
				<td class="tache">${actName}</td>
				<td class="person">
					<div style="padding: 2px 0px">
						<div id="${actId}" style="height:auto;margin-bottom: 2px">
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append('${actId}','${nodeId}','1')">添加</a>
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="append('${actId}','${nodeId}','13')">从表单中添加</a>
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-remove',plain:true" onclick="remove('${actId}','${nodeId}')">删除</a>
					        <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="save('${actId}','${nodeId}')">保存</a>
				    	</div>
						<table id="${actId}_${nodeId}" name="table" class="table-inner" style="width:100%;height:auto"></table>
					</div>
				</td>
			</tr>
			</c:forEach>
		</c:if>
		</tbody>
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
</body>
<script type="text/javascript">
	$.extend($.fn.datagrid.methods, {
		editCell : function(jq, param) {
			return jq.each(function() {
				var opts = $(this).datagrid('options');
				var fields = $(this).datagrid('getColumnFields', true).concat(
						$(this).datagrid('getColumnFields'));
				for (var i = 0; i < fields.length; i++) {
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor1 = col.editor;
					if (fields[i] != param.field) {
						col.editor = null;
					}
				}
				$(this).datagrid('beginEdit', param.index);
				for (var i = 0; i < fields.length; i++) {
					var col = $(this).datagrid('getColumnOption', fields[i]);
					col.editor = col.editor1;
				}
			});
		}
	});

	function endEditing() {
		if (editIndex == undefined) {
			return true
		}
		if (editTableObj.datagrid('validateRow', editIndex)) {
			editTableObj.datagrid('endEdit', editIndex);
			editIndex = undefined;
			return true;
		} else {
			return false;
		}
	}
	
	function onClickCell(index, field) {
		editTableObj = $(this);
		if (endEditing()) {
			editTableObj.datagrid('selectRow', index).datagrid('editCell', {
				index : index,
				field : field
			});
			editIndex = index;
		}
	}
	
	function onClickIcon(textboxObj) {
		var row = editTableObj.datagrid('getSelected');
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
	
	
	//人员选择确定事件
	function makesure(arr) {
		var row = editTableObj.datagrid('getSelected');
		index = editTableObj.datagrid('getRowIndex', row);
		var ed = editTableObj.datagrid('getEditor', {
			index: index,
			field: 'user_name_'
		});
		ed.target.textbox("setValue", arr[1]);
		row.user_value_ = arr[0];
		window.parent.$('#chooseper').dialog('close');
	}
</script>
</html>