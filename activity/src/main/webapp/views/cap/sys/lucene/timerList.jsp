<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>定时器管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/lucene/js/timerList.js"></script>
	
</head>
<body class="easyui-layout" style="width: 100%; height: 98%;">
	<div data-options="region:'center'" class="content">
		<!-- 工具栏 -->
		<div id="toolBar" class="clearfix">
			<div id="operateBtn" class="tool_btn">
				<a href="javascript:void(0)" onclick="openForm('新增定时器信息')" class="easyui-linkbutton" iconCls="icon-add" plain="true">新增</a>
				<a href="javascript:void(0)" onclick="openUpdateForm('修改定时器信息')" class="easyui-linkbutton" iconCls="icon-edit" plain="true">修改</a>
				<a href="javascript:void(0)" onclick="doDeleteTimer()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">删除</a>
				<a href="javascript:void(0)" onclick="doStartTimer()" class="easyui-linkbutton" iconCls="icon-add" plain="true">启用</a>
				<a href="javascript:void(0)" onclick="doStopTimer()" class="easyui-linkbutton" iconCls="icon-remove" plain="true">禁用</a>
			</div>
		</div>
		<!-- 列表 -->
		<table class="easyui-datagrid" id="timerList"></table>
	</div>
	<!-- Form表单 -->
	<div id="timerDialog" class="easyui-dialog"  closed="true" data-options="modal:true" title="新增定时器" style="width:470px;height:385px;" buttons="#dlg-buttons">
		<div class="easyui-panel window-body" style="height: 100%;">
			<form id="timerForm" method="post" class="window-form">
				<input type="hidden" id="id" name="id" />
				<table cellpadding="3" class="form-table">
		    		<tr>
		    			<td>定时任务名称<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" type="text" data-options="validType:['isBlank','unnormal','length[1,256]']" required="true" missingMessage="不能为空" id="timerName" name="timerName" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >定时类型<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td >
		    				<select class="easyui-combobox select_txt "  id="timerType" name="timerType" data-options="required:true,editable:false" missingMessage="不能为空">
								<option value="1">每天</option>
								<option value="2">每周</option>
								<option value="3">每月</option>
								<option value="4">自定义间隔</option>
							</select>
		    			</td>
		    		</tr>
		    		<tr>
		    			<td >定时时间<span style="color:red;vertical-align:middle;">*</span>：</td>
		    			<td>
		    				<input class="easyui-textbox" data-options="validType:['isBlank','length[1,20]']" type="text" id="timerInterval" required="true" missingMessage="不能为空" name="timerInterval" style="width:300px;" />
		    			</td>
		    		</tr>
		    		<tr>
		    			<td>定时方法:</td>
		    			<td>
		    				<input class="easyui-textbox" data-options="validType:['isBlank','length[1,256]']" type="text" id="timerUrl" name="timerUrl" style="width:300px;" />
					    </td>
		    		</tr>
		    		<tr>
		    			<td>备注:</td>
		    			<td>
		    				<input class="easyui-textbox" data-options="validType:['length[1,256]']" id="timerRemark" name="timerRemark" data-options="multiline:true" style="width:300px;height:80px" />
		    			</td>
		    		</tr>
		    	</table>
			</form>
		</div>
	</div>
	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="doSaveTimer()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" onclick="javascript:$('#timerDialog').dialog('close')" plain="true">取消</a>
	</div>

</body>
</html>