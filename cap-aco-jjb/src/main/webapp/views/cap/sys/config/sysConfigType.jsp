<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>系统配置类型</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/config/js/sysConfigType.js"></script>
	
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;" >
	<!-- 左侧系统配置类型区域 -->
	<div data-options="region:'west',split:true,collapsible:false" style="width: 200px;" class="page_menu">
		<div class="search-tree">
			<input id="search" class="easyui-searchbox" data-options="searcher:orgTreeSearch,prompt:'输入类型'"/>
			<span class="clear" onclick="clearSearchBox()"></span>
			<!-- 左侧系统配置类型树 -->
			<ul class="easyui-tree" id="tree"></ul>
		</div>
	</div>

	<!-- 系统配置类型右键菜单 -->
	<div id="mm" class="easyui-menu" style="width: 60px;">
		<div onclick="modNote()">修改节点</div>
	</div>

	<!-- 右侧系统配置区域 -->
	<div data-options="region:'center'" class="content">
		<iframe frameborder="0" name="configFrame" id="configFrame"
			width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
	</div>
	
	<!-- 系统配置类型表单 -->
	<div id="typeDialog" class="easyui-dialog" data-options="modal:true" closed="true" style="width:470px;height:305px;" buttons="#type-buttons">
		<form id="typeForm">
			<input type="hidden" id="id" name="id">
			<table cellpadding="3">
				<tr>
					<td>系统配置类型名称<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td>
						<input class="easyui-textbox" type="text" data-options="validType:['isBlank','length[1,256]']" required="true" missingMessage="不能为空" id="name" name="typeName" style="width:300px;" />
					</td>
				</tr>
				<tr>
					<td>系统配置类型编码<span style="color:red;vertical-align:middle;">*</span>：</td>
					<td>
						<input class="easyui-textbox" type="text" data-options="validType:['isBlank','length[1,128]']" required="true" missingMessage="不能为空" id="code" name="code" style="width:300px;">
					</td>
				</tr>
				<tr>
					<td>系统配置类型描述:</td>
					<td>
						<input class="easyui-textbox" id="desc" name="typeDesc" data-options="multiline:true" validType="length[0,2000]" style="width:300px;height:60px" />
					</td>
				</tr>
			</table>
		</form>
	</div>
	<!-- 系统配置类型表单按钮 -->
	<div id="type-buttons"  class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="savetype()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#typeDialog').dialog('close')" plain="true">取消</a>
	</div>
</body>
</html>