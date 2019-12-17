<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>任务基本信息</title>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.edatagrid.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript">
	//任务所属人
	function ownerUser(){
       	$("#chooseowner_user").attr("src",'${ctx}/roleUserController/selectRoleUser');
       	$('#choose_owner').dialog({    
       	    title: '用户选择',    
       	    fit:true,  
       	    closed: false,    
       	    cache: false,    
       	    modal: true,
       	    onResize:function(){
               $(this).dialog('center');
            }
       	});   
	}
	
	//任务执行人选择
	function assignUser(){
       	$("#chooseassign_user").attr("src",'${ctx}/roleUserController/selectRoleUser');
       	$('#choose_assignee').dialog({    
       	    title: '用户选择',    
       	    fit:true,  
       	    closed: false,    
       	    cache: false,    
       	    modal: true,
       	    onResize:function(){
               $(this).dialog('center');
            }
       	});   
	}
	
	//候选用户人员
	function candidateUser(){
		$("#choosecan_user").attr("src",'${ctx}/roleUserController/selectRoleUser');
       	$('#choose_canuser').dialog({    
       	    title: '用户选择',    
       	    fit:true,  
       	    closed: false,    
       	    cache: false,    
       	    modal: true,
       	    onResize:function(){
               $(this).dialog('center');
            }
       	});
	}
	
	//候选用户组
	function candidategroup(){
		$("#choosecan_group").attr("src",'${ctx}/userGroupController/selectUserGroup');
       	$('#choose_cangroup').dialog({    
       	    title: '用户组选择',    
       	    fit:true,  
       	    closed: false,    
       	    cache: false,    
       	    modal: true,
       	    onResize:function(){
               $(this).dialog('center');
            }
       	});
	}
	
	//人员选择确定事件
    function makesure(value){
    	if(value=='owner'){
    		var arr=document.getElementById("chooseowner_user").contentWindow.doSaveRoleUser();
    		$("#owner_name_").textbox("setValue", arr[1]);
        	$("#owner_").val(arr[0]);
        	$('#choose_owner').dialog('close');
    	}else if(value=='assignee'){
    		var arr=document.getElementById("chooseassign_user").contentWindow.doSaveRoleUser();
    		$("#assignee_name_").textbox("setValue", arr[1]);
        	$("#assignee_").val(arr[0]);
        	$('#choose_assignee').dialog('close');
    	}else if(value=='candidateuser'){
    		var arr=document.getElementById("choosecan_user").contentWindow.doSaveRoleUser();
    		$("#candi_name_").textbox("setValue", arr[1]);
        	$("#candi_user_").val(arr[0]);
        	$('#choose_canuser').dialog('close');
    	}else if(value=='group'){
    		var arr=document.getElementById("choosecan_group").contentWindow.doSaveRoleUser();
    		$("#candigroup_name_").textbox("setValue", arr[1]);
        	$("#candi_group_").val(arr[0]);
        	$('#choose_cangroup').dialog('close');
    	}
    	
    }
	 
	 //保存任务人员信息
	 function savetaskinfo(){
		 $.ajax({
				type : "POST",
				url : '${ctx}/procTask/doSaveTaskInfo?taskid=${taskinfo.id_}',
				dataType : 'json',
				data : $("#taskinfo").serialize(),
				success : function(result) {
					if (result.result == "success") {
						alert("保存成功");
						window.parent.refresh();
					}else{
						alert("保存失败");
					}
				}
			});
	 }
	</script>
</head>
<body>
 <table class="table-style">
 		<tr>
			<th colspan='4'>任务信息</th>
		</tr>
		<tr>
			<th style="width:20%">事项标题</th>
			<td colspan='3'>${taskinfo.biz_title_}</td>
		</tr>
		<tr>
			<th>流程解决方案</th>
			<td colspan='3'></td>
		</tr>
		<tr>
			<th>流程定义</th>
			<td colspan='3'>${taskinfo.proc_def_id_}</td>
		</tr>
		<tr>
			<th style="width:20%">任务名称</th>
			<td style="width:30%">${taskinfo.name_}</td>
			<th style="width:20%">任务定义key</th>
			<td style="width:30%"></td>
		</tr>
		<tr>
			<th>代理状态</th>
			<td>${taskinfo.delegation_}</td>
			<th>优先级</th>
			<td>
				<div id="p" class="easyui-progressbar" data-options="value:${taskinfo.priority_}"></div>
			</td>
		</tr>
		<tr>
			<th>创建时间</th>
			<td>${taskinfo.create_time_}</td>
			<th>到期时间</th>
			<td>${taskinfo.due_date_}</td>
		</tr>
		<tr>
			<th>挂起状态</th>
			<td width="150">${taskinfo.suspension_state_}</td>
			<th>任务ID</th>
			<td width="150">${taskinfo.id_}</td>
		</tr>
	</table>
	<a class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-save'" onclick="savetaskinfo()">保存任务人员</a>
	<form id="taskinfo" action="">
		<table class="table-style">
	 		<tr>
				<th colspan='4'>任务执行人</th>
			</tr>
			<tr>
				<th style="width:20%">任务所属人 </th>
				<td style="width:30%">
					<div style="margin-bottom:20px">
			            <input id="owner_name_" class="easyui-textbox" data-options="
	                    prompt: '',
	                    value: '${taskuser.owner_name_}',
	                    icons:[{
	                        iconCls:'icon-search',
	                        handler: function(e){
	                            ownerUser();
	                        }
	                    }]
	                    " style="width:100%;height:22px;">
	                    <input id="owner_" name="owner_" type="hidden" value="${taskuser.owner_}"/>
			        </div>
				</td>
				<th style="width:20%">任务执行人</th>
				<td style="width:30%">
					<div style="margin-bottom:20px">
			            <input id="assignee_name_" class="easyui-textbox" data-options="
	                    prompt: '',
	                    value: '${taskuser.assignee_name_}',
	                    icons:[{
	                        iconCls:'icon-search',
	                        handler: function(e){
	                            assignUser();
	                        }
	                    }]
	                    " style="width:100%;height:22px;">
	                    <input id="assignee_" name="assignee_" type="hidden" value="${taskuser.assignee_}"/>
			        </div>
				</td>
			</tr>
			<tr>
				<th>候选用户</th>
				<td><div style="margin-bottom:20px">
			            <input id="candi_name_" class="easyui-textbox" data-options="
	                    prompt: '',
	                    value: '${taskuser.candi_name_}',
	                    icons:[{
	                        iconCls:'icon-search',
	                        handler: function(e){
	                            candidateUser();
	                        }
	                    }]
	                    " style="width:100%;height:22px;">
	                    <input id="candi_user_" name="candi_user_" type="hidden" value="${taskuser.candi_user_}"/>
			        </div></td>
				<th>候选用户组</th>
				<td> 
					<input id="candigroup_name_" class="easyui-textbox" data-options="
	                    prompt: '',
	                    value: '${taskuser.candigroup_name_}',
	                    icons:[{
	                        iconCls:'icon-search',
	                        handler: function(e){
	                            candidategroup();
	                        }
	                    }]
	                    " style="width:100%;height:22px;">
	                 <input id="candi_group_" name="candi_group_" type="hidden" value="${taskuser.candi_group_}"/>
	             </td>
			</tr>
		</table>
	</form>
<!-- 弹出任务所属人选人界面 -->
<div id="choose_owner" class="easyui-dialog" title="My Dialog" style="width:400px;height:200px;"   
        data-options="iconCls:'icon-save',resizable:false,modal:false" closed="true">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="makesure('owner')">确定</a>
	<iframe id="chooseowner_user" src=""  width="100%" height="300" frameborder="no" border="0" marginwidth="0"
					marginheight="0" scrolling="yes" style=""></iframe>
</div>
<!-- 弹出选人界面end  -->
<!-- 弹出任务执行人选人界面 -->
<div id="choose_assignee" class="easyui-dialog" title="" style="width:400px;height:200px;"   
        data-options="iconCls:'icon-save',resizable:false,modal:false" closed="true">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="makesure('assignee')">确定</a>
	<iframe id="chooseassign_user" src=""  width="100%" height="300" frameborder="no" border="0" marginwidth="0"
					marginheight="0" scrolling="yes" style=""></iframe>
</div>
<!-- 弹出选人界面end  -->
<!-- 弹出候选人选人界面 -->
<div id="choose_canuser" class="easyui-dialog" title="" style="width:400px;height:200px;"   
        data-options="iconCls:'icon-save',resizable:false,modal:false" closed="true">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="makesure('candidateuser')">确定</a>
	<iframe id="choosecan_user" src=""  width="100%" height="300" frameborder="no" border="0" marginwidth="0"
					marginheight="0" scrolling="yes" style=""></iframe>
</div>
<!-- 弹出选人界面end  -->
<!-- 弹出候选组界面 -->
<div id="choose_cangroup" class="easyui-dialog" title="" style="width:400px;height:200px;"   
        data-options="iconCls:'icon-save',resizable:false,modal:false" closed="true">
	<a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="makesure('group')">确定</a>
	<iframe id="choosecan_group" src=""  width="100%" height="300" frameborder="no" border="0" marginwidth="0"
					marginheight="0" scrolling="yes" style=""></iframe>
</div>
<!-- 弹出选人界面end  -->
</body>
</html>