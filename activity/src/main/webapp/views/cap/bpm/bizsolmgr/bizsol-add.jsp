<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>新增应用模型</title>
<style type="text/css">
.left-th{
	width:18%;
}
.right-td{
	width:32%;
	text-align: left;
}
</style>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
</head>
<body class="easyui-layout" data-options="fit:true">
<div data-options="region:'center',heigh:'auto'">
	<form id="bizSolInfo" class="window-form">
		<input type="hidden" id="state_" name="state_" value="${bizSolInfo.state_ }">
		<input type="hidden" id="createUserId_" name="createUserId_" value="${bizSolInfo.createUserId_ }">
		<input type="hidden" id="createTime_" name="createTime_" value="${bizSolInfo.createTime_ }">
		<input type="hidden" id="updateUserId_" name="updateUserId_" value="${bizSolInfo.updateUserId_ }">
		<input type="hidden" id="updateTime_" name="updateTime_" value="${bizSolInfo.updateTime_ }">
		<input type="hidden" id="ts_" name="ts_" value="${bizSolInfo.ts_ }">
		<input type="hidden" id="dr_" name="dr_" value="${bizSolInfo.dr_ }">
		<input type="hidden" id="remark_" name="remark_" value="${bizSolInfo.remark_}">
		<input type="hidden" id="procDefId_" name="procDefId_" value="${bizSolInfo.procDefId_}">
		<input type="hidden" id="sfwDictCode_" name="sfwDictCode_" value="${bizSolInfo.sfwDictCode_}">
		<table border= "1" style="width: 90%"  class="table-style">
			<tr style="height: 35px">
				<th class="Theader" colspan="4">应用模型信息</th>
			</tr>
			<tr style="height: 35px">
				<th style="width: 23%;">业务应用类别：</th>
				<td class="right-td">
					<input id="solCtlgId_" name="solCtlgId_" value="${bizSolInfo.solCtlgId_}" style="width:100%">
				</td>
				<th class="left-th">业务应用<span class="input-must">*</span>：</th>
				<td class="right-td">
					<input id="bizCode_" name="bizCode_" value="${bizSolInfo.bizCode_}" 
						data-options="required:true" missingMessage="不能为空" style="width:100%">
				</td>
			</tr>
			<tr style="height: 35px">
				<th class="left-th">应用模型名称<span class="input-must">*</span>：</th>
				<td class="right-td">
					<input class="easyui-textbox" id="solName_" name="solName_" value="${bizSolInfo.solName_}"
						data-options="required:true" missingMessage="不能为空" style="width: 100%">
				</td>
				<th class="left-th">标识Key<span class="input-must">*</span>：</th>
				<td class="right-td">
					<input class="easyui-textbox" id="key_" name="key_" value="${bizSolInfo.key_}"
						data-options="required:true,validType:'key_'" missingMessage="不能为空" style="width: 100%">
				</td>
			</tr>
			<!-- 新增修改：应用模型是否有工作流-->
			<tr>
				<th class="left-th">是否有流程：</th>	
				<td class="right-td" colspan="3">
					<input type="radio" id="yes" name="isProcess_" value="1" checked="checked">有&nbsp;&nbsp;&nbsp;
					<input type="radio" id="no" name="isProcess_" value="0"/>无
				</td>
			</tr>
			<tr style="height: 60px">
				<th class="left-th">描述：</th>
				<td colspan="3" >
					<input class="easyui-textbox" style="width: 100%;height: 55px" data-options="multiline:true"  
						id="desc_" name="desc_" value="${bizSolInfo.desc_}">
					<!-- <textarea id="desc_" name="desc_" style="width: 100%;border: 0px" rows="4" cols=""></textarea> -->
				</td>
			</tr>
		</table>
	</form>
</div>

<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
	<div class="window-tool">
		<a href="javascript:void(0)" onclick="formSubmit()" class="easyui-linkbutton" plain="true">保存</a>
		<a href="javascript:void(0)" onclick="closeDig()" class="easyui-linkbutton" plain="true">关闭</a>
	</div>
</div>
</body>
<script type="text/javascript">
$.extend($.fn.validatebox.defaults.rules, {  
    key_ : {
    	validator : function(value) {  
            return /[a-zA-Z][a-zA-Z0-9]$/.test(value);  
        },  
        message : 'key格式：以字母开头，由字母数字组成' 
    }
});
var solCtlgId_='${bizSolInfo.solCtlgId_}';
$(function(){
	/*  $("#checkbox").click(function(){ 
        if(document.getElementById("checkbox").checked){ 
           document.getElementById("isBizModel_").value="YES";
        }else{ 
        	document.getElementById("isBizModel_").value="NO";
        } 
    }); */
    
    //业务方案类别树
	$('#solCtlgId_').combotree({
	    url: '${ctx}/bizSolMgr/findCtlgTree',
	    panelHeight : 150,
	    editable:false,
	    required: true
	});
    $("#solCtlgId_").combobox({disabled: true});//设置下拉款为禁用
    //收发文类别树
	$('#bizCode_').combobox({
		panelHeight : 150,
		editable:false,
	    required: true
	});
	 $('#bizCode_').combobox({
	    url: '${ctx}/bizSolMgr/getSolCtlgById?solCtlgId='+solCtlgId_,
	    valueField: 'code',    
	    textField: 'solCtlgName_' 
	}); 
});

//保存表单
function formSubmit(){
	if ($('#bizSolInfo').form('validate')) {
		 $.ajax({
				url : '${ctx}/bizSolMgr/chenksolName',
				type : 'post',
				async : false,
				data : {solCtlgId_:solCtlgId_,solName_:$("#solName_").textbox('getValue')},
				success : function(data){
					if(data=="Y"){
						 $.ajax({
							 url : '${ctx}/bizSolMgr/checkKey',
								type : 'post',
								async : false,
								data : {key:$("#key_").textbox('getValue')}, 
								success : function(data){
									if(data=="Y"){
										$("#solCtlgId_").combobox({disabled: false});
										 $.ajax({
												url : '${ctx}/bizSolMgr/doSaveBizSolInfo',
												type : 'post',
												dataType : 'text',
												async: false,
												data : $('#bizSolInfo').serialize(),
												success : function(data) {
													if(data == 'Y'){
														window.parent.$.messager.show({
															title:'新增业务应用',
															msg:'新增成功',
															timeout:2000,
														});
														window.parent.closeDialog();
														window.parent.reloadTableData();
													}else if(data == "W"){
														$("#key_").textbox("setValue","");
														window.parent.$.messager.alert("提示", "标志Key已存在！", "info");
													}else{
														window.parent.$.messager.show({
															title:'新增业务应用',
															msg:'新增失败',
															timeout:2000,
														});
													}
												}
											}); 
									}else{
										$("#key_").textbox("setValue","");
										window.parent.$.messager.alert("提示", "标志Key已存在！", "info");
									}
								}
						 });
					}else{
						$("#solName_").textbox("setValue","");
						window.parent.$.messager.alert("提示", "应用模型名称不能重复！", "info");
					}
				}
			});	
	}
}
//关闭弹出对话框
function closeDig(){
	window.parent.closeDialog('dialog');
}
function chenksolName(solCtlgId_,solName_){
	$.ajax({
		url : '${ctx}/bizSolMgr/chenksolName',
		type : 'post',
		async : false,
		data : {solCtlgId_:solCtlgId_,solName_:solName_},
		success : function(data){
			if(data=="Y"){
				return true;
			}else{
				return false;
			}
		}
	});
}
</script>
</html>