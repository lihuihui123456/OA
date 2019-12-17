<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>接口信息</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/intfc/js/intfcInfo.js"></script>

	<script type="text/javascript">
	var typeid = "";
	$(function() {
		typeid = '${typeid}';
		$("#typeId").val(typeid);
	});
	</script>

</head>
<body>
		<div class="easyui-panel" style="padding-left:10px;">
			<form id="ff" name="ff" method="post" novalidate>
				<input type="hidden" id="rows" name="rows">
				<input type="hidden" id="typeId" name="typeId">
				<p>接口基本信息</p>
				<table class="">
					<tr>
						<td>接口名称:</td>
						<td><input class="easyui-textbox" id="intfcName" name="intfcName"
							style="height:32px"></td>
						<td>请求方式:</td>
						<td><select class="easyui-combobox" id="reqMode" name="reqMode"
							style="width:100%;height:32px" panelHeight="50">
								<option value="post">post</option>
								<option value="get">get</option>
						</select></td>
					</tr>
					<tr>
						<td>接口类型:</td>
						<td><select class="easyui-combobox" id="intfcType" name="intfcType"
							style="width:100%;height:32px" panelHeight="50">
								<option value="webservice">webservice</option>
								<option value="httpclient">httpclient</option>
						</select></td>
						<td>实现方式:</td>
						<td><select class="easyui-combobox" id="impMode" name="impMode"
							style="width:100%;height:32px" panelHeight="50">
								<option value="axis2">axis2</option>
								<option value="cxf">cxf</option>
						</select></td>
					</tr>
					<tr>
						<td>接口地址:</td>
						<td colspan="4"><input class="easyui-textbox" id="url" name="url"
							style="height:32px;width:100%"></td>
					</tr>
					<tr>
						<td>方法名称:</td>
						<td><input class="easyui-textbox" id="method" name="method"
							style="height:32px;width:100%"></td>
						<td>系统名称:</td>
						<td><input class="easyui-textbox" id="sysName" name="sysName"
							style="height:32px;width:100%"></td>
					</tr>
					<tr>
						<td>接口描述:</td>
						<td colspan="4">
							<textarea  id="remark1" rows="2" style="width:98%" name="remark"></textarea>
						</td>
					</tr>
				</table>
				
				<p>接口参数信息</p>
				<a href="javascript:void(0)" class="easyui-linkbutton"  onclick="addParm()">添加参数</a>
				<div style="height:auto;">
                    <table id="tb1" class="easyui-datagrid" style="width: 700px; height: 150px;"
							border="0"
							data-options="
					           rownumbers:false,
					           animate: true,
					           collapsible: true,
					           fitColumns: true,
					           method:'post',
							   ">
					<thead>
						<tr>
							<th data-options="field:'infoId',hidden:true">infoId</th>
							<th data-options="field:'sort',width:50,align:'center'">参数序号</th>
							<th data-options="field:'parmName',width:100,align:'center'">参数名称</th>
							<th data-options="field:'defValue',width:150,align:'center'">默认值</th>
							<th data-options="field:'remark',width:120,align:'center'">描述</th>
							<th data-options="field:'modify',width:80,align:'center',
								formatter:function(value,row){
									return planUrl(value,row);
							}">操作</th>
						</tr>
					</thead>
				</table>
				<a onclick="doSaveIntfcInfo()" class="easyui-linkbutton" iconCls="icon-ok"
					style="width:150px;height:32px">保存</a>
				</div><br>
			</form>
		</div>
		
		<div id="dlg" class="easyui-dialog" title="添加参数信息" closed="true"
		data-options="iconCls:'icon-save'"
		style="width: 430px; height: 350px; padding: 10px">
		<div class="easyui-panel" style="width: 390px; padding: 30px 60px">
			<div style="margin-bottom: 5px">
				<div>参数名称:</div>
				<input class="easyui-textbox" id="parmName"
					style="width: 100%; height: 32px">
			</div> 
			<div style="margin-bottom: 5px">
				<div>参数序号:</div>
				<input class="easyui-textbox" id="sort"
					style="width: 100%; height: 32px">
			</div>
			<div style="margin-bottom: 5px">
				<div>默认值:</div>
				<input class="easyui-textbox" id="defValue"
					style="width: 100%; height: 32px">
			</div>
			<div style="margin-bottom: 5px">
				<div>描述:</div>
				<input class="easyui-textbox" id="remark"
					style="width: 100%; height: 32px">
			</div>
			<div>
				<a href="#" onclick="saveParms()" class="easyui-linkbutton"
					iconCls="icon-ok"  height: 32px">保存</a>
					<a href="#" onclick="cancel()" class="easyui-linkbutton"
					iconCls="icon-ok"  height: 32px">取消</a>
			</div>
		</div>
	</div>
</body>
</html>