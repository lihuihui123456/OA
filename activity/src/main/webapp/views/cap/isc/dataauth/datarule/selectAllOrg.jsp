<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>选择部门岗位人员</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/dataauth/datarule/js/selectAllOrg.js"></script>
	<style type="text/css">
		.choose_man{
			width:100%;
			height:50px;
			position:fixed;
			z-index:11;
			bottom:0px;
			background:#fff;
			border-top:1px solid #ddd;
			padding-top:5px;
			overflow-x:hidden;
			overflow-y:auto;
		 }
		 .choose_man > a{
		 	color:#333;
		 	margin-right:10px;
		 }
		  .choose_man > a span.close_man{
		  	color:#333;
		  	opacity:0.5;
		  	margin-left:3px;
		  	font-weight:bold;
		  }
		  .choose_man > a span.close_man:hover{
		  	opacity:1;
		  	cursor:pointer;
		  }
		</style>
	
	<script type="text/javascript">
		var singleSelect = '${singleSelect}';
		var idStr = '${idStr}';
		var nameStr = '${nameStr}';
		var isContainSelf = '${isContainSelf}';
		idStr = idStr + ",";
		nameStr = nameStr + ",";
		if (singleSelect == 'true') {
			singleSelect = true;//单选
		}else {
			singleSelect = false;//多选
		} 
	</script>
</head>

<body class="easyui-layout" style="width: 100%; height: 96%;padding:10px"> 
	<div data-options="region:'west',split:true,collapsible:false" class="page_menu">
		<!-- 单位树 -->
		<div class="search-tree">
			<input id="org_search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入单位名称'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<ul class="easyui-tree" id="org_tree" ></ul>
		</div>
	</div>
	
	<div data-options="region:'center',iconCls:'icon-ok'">
		<div id="toolBar" class="clearfix">
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'输入登录帐号或真实姓名'">
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<!-- <div id="operateBtn" class="tool_btn">
				<a href="javascript:void(0)" onclick="saveUserRoles()" class="easyui-linkbutton" iconCls="icon-isc-fpjs" plain="true">保存</a>
			</div> -->
		</div>

		<!-- 单位列表 -->
		<table class="easyui-datagrid" id="orgList"></table>
	</div>
	<div data-options="region:'south'" style="height:30px;" id="southArea">
		<div class="choose_man" id="content"><span >已选单位：</span>
		</div>
	</div>
</body>
</html>