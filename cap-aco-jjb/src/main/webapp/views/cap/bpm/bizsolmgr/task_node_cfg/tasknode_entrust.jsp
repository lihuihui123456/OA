<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<title>委托配置</title>
<script type="text/javascript">
var userType='';
function chooseUser(type){
    userType=type;  
	$("#choose_user").attr("src",'${ctx}/orgController/selectOrgDeptUser');
	$('#chooseper').dialog({    
     	    title: '用户选择',  
     	    width:750,
	   	    height: 380,
	   	    cache: false,
	   	    closed : false,
	   	    onResize:function(){
	               $(this).dialog('center');
	           }
        });   
}
//人员选择确定事件
   function makesure(){
	   	var arr=document.getElementById("choose_user").contentWindow.doSaveMessage();
	   	if(userType=='1'){
	   		$('#trust_user_name').val(arr[1]);
		   	$('#trust_user_id').val(arr[0]); 
	   	}else{
		   	$('#user_name').val(arr[1]);
		   	$('#user_id').val(arr[0]); 
	   	}
	   	$('#chooseper').dialog('close');
   }
   function formSubmit(){
	   if(!$('#trustInfo').form('validate')){
		   $.messager.alert('提示', '请填写必填项！');
		   return;
	   }
	   if(!checkTime()){
		   $.messager.alert('提示', '委托开始时间不能大于结束时间！');
		   return;
	   }
		$.ajax({
			url : '${ctx}/bizSolMgr/doSaveBizTrustInfo',
			type : 'post',
			dataType : 'text',
			data : $('#trustInfo').serialize(),
			success : function(data) {
				if(data == 'Y'){
					window.parent.$.messager.show({
						title:'提示',
						msg:'保存成功',
						timeout:2000,
					});
					window.parent.closeDlg();
					window.parent.reloadTableDatas();
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
 function closeDig(){
	window.parent.closeDlg('dialog');
}
 function checkTime(){
	 var start=$('#start_time_').datetimebox("getValue");
	 var end=$('#end_time_').datetimebox("getValue");
	 if(start>end){
		 return false;
	 }else{
		 return true;
	 }
 }
</script>
</head>
<body class="easyui-layout" data-options="fit:true">
	<div data-options="region:'center',heigh:'auto'">
	<form id="trustInfo" class="window-form">
	<input type="hidden" id="act_id" name="act_id" value="${trustEntity.act_id}">
	<input type="hidden" id="pro_def_id_" name="pro_def_id_" value="${trustEntity.pro_def_id_}">
	<input type="hidden" id="id" name="id" value="${trustEntity.id}">
	<table border= "1" style="width: 100%"  class="table-style">
	<tr id="trustuser" style="height: 35px">
	    <th style="width:20%;text-align: right;">委托人<span class="input-must">*</span>:</th>
	    <td colspan="3">
	     <input type="hidden" id="trust_user_id" name="trust_user_id" value="${trustEntity.trust_user_id}">
	     <input class="easyui-validatebox" id="trust_user_name" name="trust_user_name" value="${trustEntity.trust_user_name}" style="border-style:none;width:95%;" onclick="chooseUser(1)" data-options="required:true,editable:false" >
		</td>
	</tr>
	<tr id="trustuser" style="height: 35px">
	    <th style="width:20%;text-align: right;">被委托人<span class="input-must">*</span>:</th>
	    <td colspan="3">
	     <input type="hidden" id="user_id" name="user_id" value="${trustEntity.user_id}">
	     <input class="easyui-validatebox" id="user_name" name="user_name" value="${trustEntity.user_name}" style="border-style:none;width:95%;" onclick="chooseUser(2)" data-options="required:true,editable:false" >
		</td>
	</tr>
	<tr id="trusttime" style="height: 35px">
	    <th style="width:20%;text-align: right;">委托时限<span class="input-must">*</span>:</th>
	    <td><input class="easyui-datebox" id="start_time_" name="start_time_" style="border-style:none;width:210px;" data-options="required:true,editable:false"  value="${trustEntity.start_time_.substring(0,10)}"></td>
	    <th style="width:20%;text-align: center;">至<span class="input-must">*</span>:</th>
	    <td><input class="easyui-datebox" id="end_time_" name="end_time_" style="border-style:none;width:210px;" data-options="required:true,editable:false" value="${trustEntity.end_time_.substring(0,10)}">
		</td>
	</tr>
	<tr style="height: 35px">
	    <th style="width:20%;text-align: right;">委托意见:</th>
	    <td colspan="3">
	     <input class="easyui-validatebox" type="text" id="comment_" name="comment_" value="${trustEntity.comment_}" style="border-style:none;width:95%;">
		</td>
	</tr>
	<tr style="height: 35px">
	    <th style="width:20%;text-align: right;">备注:</th>
	    <td colspan="3">
	     <input class="easyui-validatebox" type="text" id="remark_" name="remark_" value="${trustEntity.remark_}" style="border-style:none;width:95%;">
		</td>
	</tr>
	</table>
	</form>
</div>
<div data-options="region:'south'" style="height:50px;text-align: center;overflow: hidden">
		<div class="window-tool">
			<a href="javascript:void(0)" onclick="formSubmit()"
				class="easyui-linkbutton" plain="true">保存</a>
			<a href="javascript:void(0)" onclick="closeDig()"
				class="easyui-linkbutton" plain="true">关闭</a>
		</div>
	</div>
	<!-- 弹出选人界面 -->
<div id="chooseper" style="overflow:hidden;" closed="true" data-options="iconCls:'icon-save',maximizable:true,resizable:false,modal:true" buttons="#dlg-buttons">
	<iframe scrolling="no" id="choose_user" frameborder="0" border="0" marginwidth="0"
			marginheight="0" style="width:100%;height:100%;"></iframe>					
</div>
<div id="dlg-buttons" class="window-tool">
	<a class="easyui-linkbutton" data-options="plain:true" onclick="makesure()">确定</a>
	<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#chooseper').dialog('close')" plain="true">取消</a>
</div>
<!-- 弹出选人界面end  -->
</body>
</html>
