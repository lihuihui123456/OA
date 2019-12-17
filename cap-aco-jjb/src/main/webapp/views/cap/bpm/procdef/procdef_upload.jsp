<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>上传流程定义</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/easyui-lang-zh_CN.js"></script>
</head>
<script type="text/javascript">
function formSubmit(){
	$('#upload_fm').form('submit', {
		url : "${ctx}/procDefController/importBpmn",
	    onSubmit: function(){
	    	var isValid = false;
			var suffix = $('#file').filebox('getValue');
			if(suffix == null || suffix == ""){
				window.parent.$.messager.alert('提示','请选择要上传的文件！');
			}else{
				suffix=suffix.substring(suffix.lastIndexOf('.')+1,suffix.length).toLocaleLowerCase();
				if(suffix!="zip"){
					window.parent.$.messager.alert('提示','请上传zip格式文件');
				}else{
					isValid = true;
				}
			}
			return isValid;
	    },
	    success:function(data){
	    	if(data == "true"){
				closeDig();
				window.parent.reloadTableData();
				window.parent.$.messager.show({title:'提示',msg:"上传成功！",timeout:2000});
	    	}else{
	    		window.parent.$.messager.show({title:'提示',msg:"上传失败！",timeout:2000});
	    	}
	    }
	});
}

function closeDig(){
	window.parent.closeDialog('procdsgnDlg');
}
</script>
<body class="easyui-layout" data-options="fit:true">
	<div data-options="region:'center',height:'auto'">
		<div title="表单上传" style="padding: 5px; overflow: hidden">
			<form id="upload_fm" method="post" enctype="multipart/form-data">
			<input type="hidden" name="procCtlgId" value="${procCtlgId}">
				<div style="margin-bottom:20px">
					<div>请选择文件</div>
					<input class="easyui-filebox" id="file" name="file" data-options="prompt:'请选择zip格式的文件'" style="width:100%">
				</div>
				<!-- <label>请选择文件：</label>
				<input class="easyui-filebox" id="file" name="file" 
					data-options="required:true" style="width: 100%"> -->
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