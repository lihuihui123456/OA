<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>新增业务表单</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/easyui-lang-zh_CN.js"></script>
</head>
<script type="text/javascript">
$(function(){
	$('#formCtlgId_').combotree({
	    url: '${ctx}/formDesignController/formCtlgTree',
	    panelHeight:'auto'
	});
	
});

function formSubmit(){
	$('#upload_fm').form('submit', {
		url : '${ctx}/formDesignController/uploadJsp',
	    onSubmit: function(){
	    	var isValid = $(this).form('validate');
			if (!isValid){
				$.messager.progress('close');	// hide progress bar while the form is invalid
			}else{
				var suffix = $('#file').filebox('getValue');
				suffix=suffix.substring(suffix.lastIndexOf('.')+1,suffix.length).toLocaleLowerCase();
				if(suffix!="jsp"){
					isValid = false;
					$.messager.alert('文件格式错误','只能上传jsp格式文件');
				}
			}
			return isValid;
	    },
	    success:function(data){
			if(data == "Y") {
				closeDig();
				window.parent.reloadTableData();
			}
	    }
	});
}

function closeDig(){
	window.parent.closeDialog('dialog');
}
</script>
<body class="easyui-layout" data-options="fit:true">
	<div data-options="region:'center',height:'auto'">
		<div title="表单上传" style="padding: 5px; overflow: hidden">
			<form id="upload_fm" method="post" enctype="multipart/form-data">
				<input type="hidden" name="sameSeries_" value="${formEntity.sameSeries_}">
				<table border="1" style="width: 100%;" class="table-style">
					<tr style="height: 35px">
						<th class="Theader" colspan="4">表单信息</th>
					</tr>
					<tr style="height: 35px">
						<th style="width: 36%;">分类：</th>
						<td style="width: 64%;text-align: left;">
							<input id="formCtlgId_" name="formCtlgId_" value="${formEntity.formCtlgId_}" style="width: 100%">
						</td>
					</tr>
					<tr style="height: 35px">
						<th style="width: 36%;">名称<span class="input-must">*</span>：
						</th>
						<td style="width: 64%;text-align: left;">
							<input class="easyui-textbox" id="formName_" name="formName_" value="${formEntity.formName_}" 
								data-options="required:true" missingMessage="不能为空" style="width: 100%">
						</td>
					</tr>
					<tr style="height: 35px">
						<th style="width: 36%;">标识键<span class="input-must">*</span>：</th>
						<td style="width: 64%;text-align: left;">
							<input class="easyui-textbox"  id="key_" name="key_" value="${formEntity.key_}" 
								data-options="required:true" missingMessage="不能为空" style="width: 100%">
						</td>
					</tr>
					<tr style="height: 35px">
						<th style="width: 36%;">表名<span class="input-must">*</span>：</th>
						<td style="width: 64%;text-align: left;">
							<input class="easyui-textbox" id="tableName_" name="tableName_" value="${formEntity.tableName_}" 
								data-options="required:true" missingMessage="不能为空" style="width: 100%">
						</td>
					</tr>
					<tr style="height: 35px">
						<th style="width: 36%;">打印模板：</th>
						<td style="width: 64%;text-align: left;">
							<input class="easyui-textbox"  id="printTemplate_" name="printTemplate_" value="${formEntity.printTemplate_}" style="width: 100%">
						</td>
					</tr>
					<tr style="height: 35px">
						<th style="width: 36%;">jsp文件<span class="input-must">*</span>：</th>
						<td style="width: 64%;text-align: left;">
							<input class="easyui-filebox" id="file" name="file" 
								data-options="required:true" missingMessage="不能为空" style="width: 100%">
						</td>
					</tr>
				</table>
			</form>
		</div>
	</div>
	
	<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<a href="javascript:void(0)" class="easyui-linkbutton" plain="true" onclick="formSubmit()">上传</a>
			<a href="javascript:void(0)" onclick="closeDig()"
					class="easyui-linkbutton" plain="true">关闭</a>
		</div>
	</div>
</body>
</html>