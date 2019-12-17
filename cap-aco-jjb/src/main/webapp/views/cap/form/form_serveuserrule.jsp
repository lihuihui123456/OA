<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>表单权限设置</title>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/css/style.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/css/pro.css">
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="${ctx}/views/cap/form/js/formserveuserrole.js"></script>

<style>
.datagrid-header-inner, .datagrid-body, .datagrid-header {
	width: 100% !important;
}

.datagrid-htable, .datagrid-btable, .datagrid-view, .datagrid {
	width: 100% !important;
}

.datagrid-view2, .datagrid-wrap {
	width: 100% !important;
}

.datagrid-body table {
	width: 100% !important;
}

.datagrid-body {
	overflow: hidden;
}
</style>

</head>
<body onclick="cancelEdit()">
	
	<!-- <a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="saveallassessofc()">批量保存</a>
 -->
	<table class="table-style" style="margin-top:10px;">
		<tr>
			<th width="15%" class="Theader">字段</th>
			<th width="85%" class="Theader">权限配置</th>
		</tr>
		<c:forEach items="${list}" var="col" varStatus="index">
		<tr>
			
			<th><input id="col_tableid_${index.index }" value="${col.table_id}" style="display:none">
	<input id="col_colid_${index.index }" value="${col.col_id}" style="display:none;">${col.col_name}</th>
			<td style="padding:10px;">
				<table id="tb_rule_${index.index }" name="asstable"
					class="easyui-datagrid table-inner" title=""
					style="width:100%;height:auto"
					data-options=" iconCls: 'icon-edit', singleSelect: true, toolbar: '#btn_${index.index }',
				                url: '${ctx}/formServeUserRuleController/getRulelist?colid=${col.col_id}&serveid=${serveid }', method: 'get', 
				                onClickCell: onClickCell, onEndEdit: onEndEdit,onBeforeEdit:onBeforeEdit">
					<thead>
						<tr>
							<th data-options="field:'ck',checkbox:true,align:'center'"></th>
							<th
								data-options="field:'control_type',width:'15%',align:'center',
					                        formatter:function(value,row){
											var temp=initDict('control_type');
					                        for (var i=0;i<temp.length;i++){
						                        if (temp[i].dictCode==value) {
													return temp[i].dictVal;
	        									}
					                        }
					                       	},
					                        editor:{
					                            type:'combobox',
					                            options:{
					                               	valueField:'dictCode',
		                                			textField:'dictVal',
					                                required:true,
					                                data:initDict('control_type')
					                            }
					                        }">权限类型</th>
							<th
								data-options="field:'rule_type',width:'22%',align:'center',
					                        formatter:function(value,row){
											var temp=initDict('userruletype');
					                        for (var i=0;i<temp.length;i++){
						                        if (temp[i].dictCode==value) {
													return temp[i].dictVal;
	        									}
					                        }
					                       	},
					                        editor:{
					                            type:'combobox',
					                            options:{
					                               	valueField:'dictCode',
		                                			textField:'dictVal',
					                                required:true,
					                                data:initDict('userruletype')
					                            }
					                        }">用户类型</th>
							<th
								data-options="field:'rule_id_val',width:'50%',align:'center',
					                				editor:{
					                					type:'textbox',
					                					options:{
					                					required:true,
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
							<th hidden="true"
								data-options="field:'rule_id',align:'center', editor:'textbox'">用户id</th>
							<!-- <th data-options="field:'operator_',width:'20%',align:'center', formatter:function(value,row){
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
					                <th data-options="field:'sort_',width:'10%',align:'center',editor:'numberspinner'">序号</th> -->
						</tr>
					</thead>
				</table>
				<div id="btn_${index.index }" style="height:auto">
					<a href="javascript:void(0)" class="easyui-linkbutton"
						data-options="iconCls:'icon-add',plain:true"
						onclick="append('tb_rule_${index.index }','${col.col_id}','${col.table_id}','${serveid }','0')">添加</a> <a
						href="javascript:void(0)" class="easyui-linkbutton"
						data-options="iconCls:'icon-remove',plain:true"
						onclick="removeit('tb_rule_${index.index }')">删除</a>
					<!-- <a href="javascript:void(0)" class="easyui-linkbutton" data-options="iconCls:'icon-add',plain:true" onclick="accept()">从表单中添加</a> -->
					<a href="javascript:void(0)" class="easyui-linkbutton"
						data-options="iconCls:'icon-save',plain:true"
						onclick="saveassessofc('tb_rule_${index.index }','${col.col_id}','${col.table_id}')">保存</a>
				</div>
			</td>
		</tr>
		</c:forEach>
	</table>

	<!-- 弹出选人界面 -->
	<div id="chooseper" class="easyui-dialog" title="My Dialog"
		style="width:400px;height:400px;"
		data-options="iconCls:'icon-save',resizable:false,modal:false"
		closed="true" buttons="#dlg-buttons">
		<iframe id="choose_user" src="" width="100%" height="280px"
			frameborder="no" border="0" marginwidth="0" marginheight="0"
			scrolling="no" style=""></iframe>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a class="easyui-linkbutton" data-options="plain:true"
			onclick="makesure()">确定</a> <a href="javascript:void(0)"
			class="easyui-linkbutton"
			onclick="javascript:$('#chooseper').dialog('close')" plain="true">取消</a>
	</div>
	<!-- 弹出选人界面end  -->
</body>
</html>
