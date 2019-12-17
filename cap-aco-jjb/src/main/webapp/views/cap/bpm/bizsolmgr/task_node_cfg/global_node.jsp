<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>全局节点配置</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<script type="text/javascript">
var freeSelect_ = '${bpmReNodeCfg.freeSelect_}';
var attachment_ = '${bpmReNodeCfg.attachment_}';
var mainBody_ = '${bpmReNodeCfg.mainBody_}';
 $(function(){
	if(freeSelect_ == '1'){
		document.getElementById("freeSelect_").checked = true;
	}
	if(mainBody_ == '1'){
		document.getElementById("mainBody_").checked = true;
	}
	if(attachment_ == '1'){
		document.getElementById("attachment_").checked = true;
	}
});
function formSubmit(){
	$.ajax({
		url : '${ctx}/bizSolMgr/doSaveBpmReNodeCfgEntity',
		type : 'post',
		dataType : 'text',
		data : $('#bpmReNodeCfgFm').serialize(),
		success : function(data) {
			if(data == 'Y'){
				window.parent.$.messager.show({
					title:'提示',
					msg:'保存成功',
					timeout:2000,
				});
				closeDialog();
				window.parent.document.getElementById("nodeconfigure").contentWindow.reloadTableData();
			}else{
				window.parent.$.messager.show({
					title:'提示',
					msg:'保存失败',
					timeout:2000,
				});
			}
		}
	});
}

/**
 * 关闭弹出的dialog
 */
function closeDialog(){
	window.parent.closeDialog('dialog');
}
</script>
<body class="easyui-layout" data-options="fit:true">
	<div data-options="region:'center',heigh:'auto'">
		<form id="bpmReNodeCfgFm" class="window-form">
			<input type="hidden" id="id" name="id" value="${bpmReNodeCfg.id}">
			<input type="hidden" id="nodeInfoId_" name="nodeInfoId_" value="${bpmReNodeCfg.nodeInfoId_}">
			<input type="hidden" id="procDefId_" name="procDefId_" value="${bpmReNodeCfg.procDefId_}">
			<input type="hidden" id="solId_" name="solId_" value="${bpmReNodeCfg.solId_}">
			<input type="hidden" id="exeUser_" name="exeUser_" value="${bpmReNodeCfg.exeUser_}">
			<input type="hidden" id="notice_" name="notice_" value="${bpmReNodeCfg.notice_}">
			<input type="hidden" id="redPrint_" name="redPrint_" value="${bpmReNodeCfg.redPrint_}">
			<input type="hidden" id="mainBody_" name="mainBody_" value="">
			<input type="hidden" id="attachment_" name="attachment_" value="">
			<table border= "1" style="width: 100%"  class="table-style">
				<tr style="height: 35px">
					<th style="width:18%;text-align: right;">参数配置</th>
					<td colspan="3">
						<input type="checkbox" id="freeSelect_" name="freeSelect_" value="1">允许自由跳转</input>
						<!-- <input type="checkbox" id="mainBody_" name="mainBody_" value="1">正文</input>
						<input type="checkbox" id="attachment_" name="attachment_" value="1">附件</input> -->
					</td>
				</tr>
				<tr style="height: 35px">
					<th style="width:20%;text-align: right;">流程启动前置处理器:</th>
					<td style="width:30%;text-align: left;"></td>
					<th style="width:20%;text-align: right;">流程启后前置处理器:</th>
					<td style="width:30%;text-align: left;"></td>
				</tr>
				<tr style="height: 35px">
					<th style="width:20%;text-align: right;">流程结束处理器:</th>
					<td style="text-align: left;" colspan="3"></td>
				</tr>
				<tr style="height: 35px">
					<th style="width:20%;text-align: right;">流程实例标题规则:</th>
					<td style="text-align: left;" colspan="3"></td>
				</tr>
			</table>
		</form>
	</div>
	
	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<span>
				<a href="javascript:void(0)" onclick="formSubmit()"
						class="easyui-linkbutton" plain="true">保存</a>
			</span>
			<span>
				<a href="javascript:void(0)" onclick="closeDialog()"
						class="easyui-linkbutton" plain="true">关闭</a>
			</span>
		</div>
	</div>
</body>
</html>