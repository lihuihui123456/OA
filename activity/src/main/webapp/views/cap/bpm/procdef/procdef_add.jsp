<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>新增流程定义</title>
<style type="text/css">
.btn-div{
	height:60px;
	text-align: center;
}
.left-th{
	width: 20%;
	padding: 0px;
	margin: 0px;
}
.right-td{
	width: 30%;
	padding: 0px;
	margin: 0px;
}
</style>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/cap/easyui.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
</head>
<body class="easyui-layout" data-options="fit:true">
    <div data-options="region:'center',split:false" style="height: auto;width: 100%;padding: 5px">
    	<form id="procdsgnInfo">
			<table class="table-style" border= "1" style="width:100%;">
				<tr>
					<th class="Theader" colspan="4">流程定义信息</th>
				</tr>
				<tr>
					<th style="width: 24%">流程定义名称<span class="input-must">*</span>：</th>
					<td colspan="3">
						<input class="easyui-textbox" id="modelName_" name="modelName_"
								data-options="required:true" missingMessage="不能为空" style="width:300px" />
					</td>
				</tr>
				<tr>
					<th>流程定义类别<span class="input-must">*</span>：</th>
					<td style="width: 26%">
						<input id="modelCtlgId_" name="modelCtlgId_" value="${categoryId}" style="width:100%" />
					</td>
					<th>标识Key<span class="input-must">*</span>：</th>
					<td>
						<input class="easyui-textbox" id="key_" name="key_" 
							data-options="required:true,validType:['key_']" missingMessage="不能为空" style="width:100%" />
					</td>
				</tr>
				<tr>
					<th class="left-th">描述：</th>
					<td class="right-td" colspan="3">
						<input class="easyui-textbox" style="width:100%;height: 300px" data-options="multiline:true"  
							id="desc_" name="desc_" />
					</td>
				</tr>
			</table>
		</form>
    </div>
    
    <!-- 底部布局按钮 -->
    <div id="btn-div" data-options="region:'south',split:false">
    	<div class="window-tool">
	    	<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="save()" plain="true">保存</a></span>
			<span><a href="javascript:void(0)" class="easyui-linkbutton" onclick="closeDialog()" plain="true">关闭</a></span>
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

$(function(){
	$("#modelCtlgId_").combotree({
	    url: "${ctx}/procDefMgr/findProcdsgnCtlgTree",
	    required: true,
	    editable:false,
	    panelHeight: 150
	});
});

function save(){
	if($("#procdsgnInfo").form("validate")){
		$.ajax({
			url : "${ctx}/procDefController/doSaveProcDec",
			type : "post",
			dataType : "json",
			async: false,
			data : $("#procdsgnInfo").serialize(),
			success : function(data) {
				if(data.flag == "true"){
					var divId = "${divId}";
					window.parent.closeDialog(divId);
					if( divId == "procdsgnDlg_" ){
						window.parent.document.getElementById('iframe').contentWindow.reloadTableData();
					}else {
						window.parent.reloadTableData();
					}
					window.parent.$.messager.show({title:'提示',msg:data.msg,timeout:2000});
					openBpmDesgn(data.modelId);
				}else if(data.flag == "warn"){
					$("#key_").textbox("setValue","");
					window.parent.$.messager.alert("提示", data.msg, "info");
				}else{
					window.parent.$.messager.alert("提示", data.msg, "info");
				}
			}
		});
	}
}

function closeDialog(){
	window.parent.closeDialog("${divId}");
}
function openBpmDesgn(modelId) {
	//新打开流程设计界面
	var url = "${ctx}/views/cap/bpm/modeler.html?modelId="+modelId;
	window.open(url,'newwindow','width='+(window.screen.availWidth-10)+',height='+(window.screen.availHeight-30)+
			',top=0,left=0,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no, status=no');
}
</script>
</html>