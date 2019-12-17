<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程实例管理</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/css/style.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.edatagrid.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/bpm/procinstmgr/js/procinst-list.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/js/common.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>
	<script type="text/javascript">
	
	$(function(){
		/** 多条件查询下拉列表 **/
		$('#field').combobox({    
		    valueField:'id',    
		    textField:'text',
		    url:'${ctx}/views/cap/bpm/procinstmgr/combobox_data.json',
		    onSelect:function(param){
		    	var check=$("#field").combobox("getValue");
		    	if(check=='id_'||check=='user_name'||check=='biz_title_'||check=='state_'){
		    		$('#condition').combobox({    
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
		    	}else if(check=='start_time_'||check=='end_time_'){
		    		$('#condition').combobox({    
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
	
	/** datagrid多条件查询刷新 **/
	function datagridrefresh(){
		var field=$("#field").combobox("getValue");
		var condition=$("#condition").combobox("getValue");
		var message=$("#message").val();
		$('#dtlist').datagrid('load',{
			field: field,
			condition: condition,
			message: message
		});
	}
	
	/** 清除多条件查询条件 **/
	function clearmessage(){
		$('#field').combobox('setValue', '');
		$('#condition').combobox('setValue', '');
		$('#message').textbox("setValue","");
		datagridrefresh();
	}
	</script>
</head>
<body>
	<div class="easyui-layout" style="width:100%;padding:10px" data-options="fit:true">
		<!-- 隐藏域 当前选择流程实例id -->
		<div id="toolbar1">
			<input type="hidden" id="procinstid"/>
			<a id="detail" name="delete" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" onclick="showdetaildialog_btn()">明细</a>
		<!-- 	<a href="#" id="delete" name="delete" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-remove'" onclick="deleteProcinst()">删除</a> -->
			
			<!-- <a href="javascript:void(0)" id="cx" class="easyui-menubutton"     
		        data-options="plain:true,menu:'#gjcx'">高级查询方案</a>   
			<div id="gjcx" style="width:150px;">   
			    <div>新建查询方案</div>   
			    <div class="menu-sep"></div>   
			    <div>查询方案列表</div>   
			</div>  
		
			<a href="javascript:void(0)" id="fj" class="easyui-menubutton"     
		        data-options="plain:true,menu:'#fjxx'">附件</a>   
			<div id="fjxx" style="width:150px;">   
			    <div>新建附件</div>   
			    <div class="menu-sep"></div>   
			    <div>预览所有附件</div>
			    <div class="menu-sep"></div>   
			    <div>下载附件列表</div>
			</div>  -->
			<a class="easyui-linkbutton" data-options="plain:true" onclick="deleteProcinst_btn()" id="btn_del">结束实例</a>
			<a class="easyui-linkbutton" data-options="plain:true" onclick="suspendprocess()" id="btn_suspend">挂起实例</a>
			<a class="easyui-linkbutton" data-options="plain:true" onclick="activeProcinst()" id="btn_active">恢复实例</a>
			<hr/>
			请输入查询字段：
			<input id="field" name="field" class="easyui-combobox" value="" >
			<input id="condition" name="condition" class="easyui-combobox" value="">
			<input id="message" class="easyui-textbox" prompt="请输入查询条件值">
			
			<a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-search'" onclick="datagridrefresh()">查询</a>
			<a href="#" class="easyui-linkbutton" data-options="plain:true,iconCls:'icon-remove'" onclick="clearmessage()">清空查询</a>
			
			<br/>
			<br/>
		</div>
		<table class="easyui-datagrid" id="dtlist"></table>
		<div id="detail">
			<div id="detaildialog" class="easyui-dialog" closed="true" style="padding:5px;"
				title="My Dialog" iconCls="icon-ok" toolbar="" buttons="">
			</div>
		</div>
	</div>
</body>
</html>