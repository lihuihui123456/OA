<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>待办任务管理</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.edatagrid.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/bpm/task-wait/js/task-list.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/js/common.js"></script>
	<script type="text/javascript">
	$(function(){
		$('#cc').combobox({    
		    valueField:'id',    
		    textField:'text',
		    url:'${ctx}/views/cap/bpm/task-wait/combobox_data.json',
		    onSelect:function(param){
		    	var check=$("#cc").combobox("getValue");
		    	if(check=='id_'||check=='proc_inst_id_'||check=='biz_title_'||check=='name_'||check=='user_name'){
		    		$('#dd').combobox({    
					    valueField:'id',    
					    textField:'text',
					    data: [{    
					        "id":"center",
					        "text":"%模糊匹配%"   
					    },{    
					        "id":"left",
					        "text":"%左模糊匹配"   
					    },{    
					        "id":"right",
					        "text":"右模糊匹配%"   
					    },{    
					        "id":"equals",
					        "text":"等于"   
					    }]
			    	});
		    	}else if(check=='create_time_'||check=='due_date_'){
		    		$('#dd').combobox({    
					    valueField:'id',    
					    textField:'text',
					    data: [{    
					        "id":"equals",
					        "text":"等于(=)"   
					    },{    
					        "id":"less",
					        "text":"小于(<)"   
					    },{    
					        "id":"lessor",
					        "text":"小于等于(<=)"   
					    },{    
					        "id":"big",
					        "text":"大于(>)"   
					    },{    
					        "id":"bigor",
					        "text":"大于等于(>=)"   
					    }]
			    	});
		    	}
		    }
		}); 
	});
	
	/** 分配用户 **/
	function assignUser(){
		var row=$("#dtlist").datagrid('getSelections');
		if(row.length > 1 || row.length < 0){
			alert("选择一条数据");
		}else{
			$("#choose_assigneeuser").attr("src",'${ctx}/roleUserController/selectRoleUser');
	       	$('#assignUser').dialog({    
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
	}
	
	/** 用户选择确认（分配用户） **/
	function makesure(){
		var arr=document.getElementById("choose_assigneeuser").contentWindow.doSaveRoleUser();
		$('#assignUser').dialog("close");
		var row=$("#dtlist").datagrid('getSelections');
		var userid=arr[0];
		var taskid=row[0].id_;
		$.ajax({
			type : "POST",
			url : '${ctx}/procTask/doUpdateAssign?userId=' + arr[0] + "&&taskid=" + taskid,
			dataType : 'json',
			success : function(result) {
				if (result.result == "success") {
					alert("保存成功");
					refresh();
				}else{
					alert("保存失败");
				}
			}
		});
	}
	
	/** 解除用户 **/
	function deleteAssign(){
		var row=$("#dtlist").datagrid('getSelections');
		if(row.length > 1 || row.length < 0){
			alert("选择一条数据");
		}else{
			var taskid=row[0].id_;
			$.ajax({
				type : "POST",
				url : '${ctx}/procTask/doUpdateAssign?taskid=' + taskid,
				dataType : 'json',
				success : function(result) {
					if (result.result == "success") {
						alert("保存成功");
						refresh();
					}else{
						alert("保存失败");
					}
				}
			});
		}
	}
	
	/** 选择查询条件后查询按钮刷新列表 **/
	function datagridrefresh(){
		var field=$("#cc").combobox("getValue");
		var condition=$("#dd").combobox("getValue");
		var message=$("#message").val();
		$('#dtlist').datagrid('load',{
			field: field,
			condition: condition,
			message: message
		});
	}
	
	/** 清空查询按钮 **/
	function clearmessage(){
		$('#cc').combobox('setValue', '');
		$('#dd').combobox('setValue', '');
		$('#message').textbox("setValue","");
	}
	</script>
</head>
<body >
<div class="easyui-layout" style="padding:10px" data-options="fit:true">
	<table class="easyui-datagrid" id="dtlist"></table>
	<div id="toolbar">
		<a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" onclick="taskdetail_btn()">明细</a>
		<a href="#" id="delete" name="delete" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-remove'" onclick="deletetask()">删除</a>
		<input id="search" name="search" class="easyui-combobox" value=""> 
		<a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="assignUser()">分配用户</a>
		<a href="#" class="easyui-linkbutton" data-options="plain:true" onclick="deleteAssign()">解除用户</a>
		<hr/>
		请输入查询字段:
		<input id="cc" name="dept" class="easyui-combobox" value="">
		<input id="dd" name="dd" class="easyui-combobox" value="">
		<input id="message" class="easyui-textbox" prompt="请输入查询条件值" value="">
		
		<a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" onclick="datagridrefresh()">查询</a>
		<a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-remove'" onclick="clearmessage()">清空查询</a>
		<br/>
		<br/>
	</div>

	<div id="detail">
		<div id="detaildialog" class="easyui-dialog" data-options="inline:false" closed="true" style="padding:5px;"
			title="" iconCls="icon-ok" toolbar="" buttons="">
		</div>
	</div>
	<div id="assign">
		<div id="assignUser" class="easyui-dialog" closed="true" style="padding:5px;" title="" iconCls="icon-ok" toolbar="" buttons="">
			<a class="easyui-linkbutton" data-options="iconCls:'icon-save',plain:true" onclick="makesure()">确定</a>
			<iframe id="choose_assigneeuser" src=""  width="100%" height="300" frameborder="no" border="0" marginwidth="0"
					marginheight="0" scrolling="yes" style=""></iframe>
		</div>
	</div>
</div>	
</body>
</html>