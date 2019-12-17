<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html style="width: 100%; height: 100%;">
<head>
	<title>日程节假日管理</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/aco/calendar/js/holiday-list.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/datagrid-scrollview.js"></script>
</head>
<body  class="easyui-layout" style="width: 100%; height: 98%;">
	<div data-options="region:'center'" class="content">
		<div id="toolbar" class="clearfix" >
			<div class="search-input">
				<input id="search" class="easyui-searchbox" data-options="searcher:findByCondition,prompt:'请输入节日名称查询'"></input>
				<span class="clear" onclick="clearSearchBox()"></span>
			</div>
			<shiro:hasPermission name="add:bizCalendarController:goToHodidayIndex">
				<a href="javascript:void(0)" onclick="doAddHoliday()" class="easyui-linkbutton" id="btn_holiday_add" iconCls="icon-add" plain="true">新增</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="modify:bizCalendarController:goToHodidayIndex">
				<a href="javascript:void(0)" onclick="doUpdate()" class="easyui-linkbutton" id="btn_holiday_modify" iconCls="icon-edit" plain="true">修改</a>
			</shiro:hasPermission>
			<shiro:hasPermission name="delete:bizCalendarController:goToHodidayIndex">
				<a href="javascript:void(0)" onclick="doDel()" class="easyui-linkbutton" id="btn_holiday_delete" iconCls="icon-remove" plain="true">删除</a>
			</shiro:hasPermission>
		</div>
		
		<table class="easyui-datagrid" id="holidayDataGrid" data-options="
			idField:'id', toolbar:'#toolbar', striped:true, fit:true, fitColumns:true, singleSelect:false,
			selectOnCheck:true, checkOnSelect:true, rownumbers:true,showFooter:true, pagination:true, nowrap:false">
		</table>
	</div>
		
	<!-- 模态框 -->
	<div id="holiday_dialog" class="easyui-dialog" title="日程管理-节假日" data-options="modal:true" closed="true" style="width:500px;height:400px;padding:10px" buttons="#dlg-buttons">
		<form action="" id="holiday_form" >
			<input type="hidden" id="ID" name="ID">
			<table cellpadding="10" class="form-table" style="margin:auto">
				<tr>
					<td align="right">
						<span style="color:red;vertical-align:left;">*</span>节日 <input class="easyui-validatebox" type="text" required="true" missingMessage="不能为空"  data-options="validType:['isBlank','unnormal','length[1,128]']" id="HOLIDAY_NAME" name="HOLIDAY_NAME" style="width:340px;line-height: 30px;" />
					</td>
				</tr>
				<tr>
					<td align="right">
						开始日期 <input class="easyui-datebox input_txt" style="width:132px;" id="HOLIDAY_START_DATE" name="HOLIDAY_START_DATE" data-options="editable:false">
						<span style="vertical-align:left;">~</span>结束日期 <input class="easyui-datebox input_txt" style="width:132px;" id="HOLIDAY_END_DATE" name="HOLIDAY_END_DATE" data-options="editable:false">
					</td>
				</tr>
				<tr>
					<td align="right">
						天数 <input class="easyui-validatebox" type="text" onclick="getDays()" required="true" missingMessage="不能为空"  data-options="validType:['isBlank','unnormal','length[1,128]']" id="HOLIDAY_NUM" name="HOLIDAY_NUM" style="width:340px;line-height: 30px;" />
					</td>
				</tr>
				<tr>
					<td align="right">
						备注 <input class="easyui-textbox" data-options="multiline:true" id="HOLIDAY_REMARK" name="HOLIDAY_REMARK"  data-options="multiline:true " style="width:340px;height:60px;">
					</td>
				</tr>
			</table>
		</form>
	</div>

	<div id="dlg-buttons" class="window-tool">
		<a href="javascript:void(0)" class="easyui-linkbutton" id="saveBtn" onclick="doSaveOrUpdateHoliday()" plain="true">保存</a>
		<a href="javascript:void(0)" class="easyui-linkbutton" id="closeBtn" onclick="javascript:$('#holiday_dialog').dialog('close')" plain="true">取消</a>
	</div>

</body>
</html>