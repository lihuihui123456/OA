<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>更新流程定义</title>
<style type="text/css">
.btn-div {
	height: 60px;
	text-align: center;
}

.left-th {
	width: 20%;
	padding: 0px;
	margin: 0px;
}

.right-td {
	width: 30% x;
	padding: 0px;
	margin: 0px;
}
.key{
	background-color:#e4e4e4;
}
</style>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/easyui/themes/cap/easyui.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
</head>
<body class="easyui-layout" data-options="fit:true">
	<div data-options="region:'center',split:false"
		style="height: auto;width: 100%;padding: 5px">
		<form id="procdsgnInfo">
			<input type="hidden" id="id" name="id" value="${entity.id }">
			<input type="hidden" id="modelId_" name="modelId_"
				value="${entity.modelId_ }"> <input type="hidden"
				id="state_" name="state_" value="${entity.state_ }"> <input
				type="hidden" id="createUserId_" name="createUserId_"
				value="${entity.createUserId_ }"> <input type="hidden"
				id="createTime_" name="createTime_" value="${entity.createTime_ }">
			<input type="hidden" id="updateUserId_" name="updateUserId_"
				value="${entity.updateUserId_ }"> <input type="hidden"
				id="updateTime_" name="updateTime_" value="${entity.updateTime_ }">
			<input type="hidden" id="ts_" name="ts_" value="${entity.ts_ }">
			<input type="hidden" id="dr_" name="dr_" value="${entity.dr_ }">
			<input type="hidden" id="mainVersion_" name="mainVersion_"
				value="${entity.mainVersion_ }"> <input type="hidden"
				id="remark_" name="remark_" value="${entity.remark_}">
			<table class="table-style" border="1" style="width:100%;">
				<tr>
					<th class="Theader" colspan="4">流程定义信息</th>
				</tr>
				<tr>
					<th style="width: 27%">流程定义名称<span class="input-must">*</span>：
					</th>
					<td class="right-td" colspan="3"><input class="easyui-textbox"
						id="modelName_" name="modelName_" value="${entity.modelName_}"
						data-options="required:true" missingMessage="不能为空"
						style="width:100%" /></td>
				</tr>
				<tr>
					<th>流程定义类别<span class="input-must">*</span>：
					</th>
					<td style="width: 20%"><input id="modelCtlgId_"
						name="modelCtlgId_" value="${entity.modelCtlgId_}"
						readonly="readonly" style="width:100%" /></td>
					<th >标识Key<span class="input-must">*</span>：
					</th>
					<td><input class="easyui-textbox" id="key_"
						name="key_" value="${entity.key_}"
						data-options="required:true,validType:['key_']"
						missingMessage="不能为空" readonly="readonly" style="width:100%" /></td>
				</tr>
				<tr>
					<th class="left-th">描述：</th>
					<td class="right-td" colspan="3"><input class="easyui-textbox"
						style="width:100%;height: 100%" data-options="multiline:true"
						id="desc_" name="desc_" value="${entity.desc_}" /></td>
				</tr>
			</table>
		</form>
	</div>

	<!-- 底部布局按钮 -->
	<div id="btn-div" data-options="region:'south',split:false">
		<div class="window-tool">
			<span><a href="javascript:void(0)" class="easyui-linkbutton"
				onclick="save()" plain="true">保存</a></span> <span><a
				href="javascript:void(0)" class="easyui-linkbutton"
				onclick="closeDialog()" plain="true">关闭</a></span>
		</div>
	</div>
</body>
<script type="text/javascript">
	$.extend($.fn.validatebox.defaults.rules, {
		key_ : {
			validator : function(value) {
				return /^[a-zA-Z][a-zA-Z0-9_]{0,15}$/i.test(value);
			},
			message : 'key格式：以字母开头，可包含数字且长度不超过16个字符'
		}
	});

	$(function() {
		$("#modelCtlgId_").combotree({
			url : "${ctx}/procDefMgr/findProcdsgnCtlgTree",
			readonly : true,
			required : true,
			editable : false,
			panelHeight : 150
		});

		$("#key_").next().find("input").addClass("key");

	});

	function save() {
		if ($("#procdsgnInfo").form("validate")) {
			$
					.ajax({
						url : "${ctx}/procDefController/doUpdateProcDec",
						type : "post",
						dataType : 'json',
						async : false,
						data : $("#procdsgnInfo").serialize(),
						success : function(data) {
							window.parent.$.messager.show({
								title : '提示',
								msg : data.msg,
								timeout : 2000
							});
							if (data.flag == "true") {
								var divId = "${divId}";
								window.parent.closeDialog(divId);
								if (divId == 'procdsgnDlg_') {
									window.parent.document
											.getElementById('iframe').contentWindow
											.reloadTableData();
								}
								window.parent.reloadTableData();
							}
						}
					});
		}
	}

	function closeDialog() {
		window.parent.closeDialog("${divId}");
	}
</script>
</html>