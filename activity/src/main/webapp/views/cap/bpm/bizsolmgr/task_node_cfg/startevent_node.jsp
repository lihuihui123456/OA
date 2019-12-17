<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>开始节点配置</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<script type="text/javascript">
var exeUser_ = '${bpmReNodeCfg.exeUser_}';
 $(function(){
	if(exeUser_ == '1'){
		document.getElementById("exeUser_").checked = true;
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
			<input type="hidden" id="freeSelect_" name="freeSelect_" value="${bpmReNodeCfg.freeSelect_}">
			<input type="hidden" id="attachment_" name="attachment_" value="${bpmReNodeCfg.attachment_}">
			<input type="hidden" id="mainBody_" name="mainBody_" value="${bpmReNodeCfg.mainBody_}">
			<input type="hidden" id="notice_" name="notice_" value="${bpmReNodeCfg.notice_}">
			<input type="hidden" id="redPrint_" name="redPrint_" value="${bpmReNodeCfg.redPrint_}">
			<table border= "1" style="width: 100%"  class="table-style">
				<tr style="height: 35px">
					<th style="width:20%;text-align: right;">允许选择执行人:</th>
					<td style="width:30%;text-align: left;">
						<input type="checkbox" id="exeUser_" name="exeUser_" value="1"></input>
					</td>
					<th style="width:20%;text-align: right;">允许选择执行路径:</th>
					<td style="width:30%;text-align: left;">
					</td>
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