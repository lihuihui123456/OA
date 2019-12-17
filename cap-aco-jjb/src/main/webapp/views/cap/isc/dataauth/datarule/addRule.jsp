<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>修改数据规则</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/dataauth/datarule/js/dataRuleAddIframe.js"></script>
	<script type="text/javascript">
		$(function(){
			$("#roleRuleId").val('${roleId}');
			createMenuData("addCombobox");
			refuseBackspace("addCombobox");
			initRuledldata();
		});
	</script>
</head>
<body> 
	<form id="ruleForm" method="post" style="display: none;">
		<input type="hidden" id="ruleId" name="ruleId" />
		<input type="hidden" id="roleRuleId" name="roleId" />
		<input type="hidden" id="resName" name="resName" />
		<input type="hidden" id="resCode" name="resCode" />
		<input type="hidden" id="ruleName" name="ruleName" />
		<input type="hidden" id="ruleDef" name="ruleDef" />
	</form>
	<div style="margin-top: 10px;">
		<div style="float:left;width: 80px;">资源<span style="color:red;vertical-align:middle;">*</span>：</div>
		<div>
			<select class="easyui-combotree" id="addCombobox" name="modCode" style="width:380px;" data-options="valueField:'modCode', textField:'text'"></select>
		</div>
		<div style="clear: both;"></div>
	</div>
	<div style="margin-top: 10px;">
		<div style="float:left;width: 80px;">规则名称<span style="color:red;vertical-align:middle;">*</span>：</div>
		<div>
			<input class="easyui-textbox" id="tx_ruleName" style="width: 380px;"/>
			<a href="javascript:void(0)"  class="easyui-linkbutton" onclick="addGroup('rulesAddDiv');" plain="true">增加分组</a>
		</div>
		<div style="clear: both;"></div>
	</div>
	<div style="margin-top: 10px;">
		<div style="float:left;width: 80px;">规则定义：</div>
		<div id ="rulesAddDiv" style="float:left;width:620px;">
			<table style="float: left;">
				<tr>
					<td><span style="width:70px;display: block;"></span></td>
					<td>
						<select class="easyui-combobox fieldSelect" data-options="editable:false,onSelect:function(){onselect($(this));}" name="field" style="width:150px;">
						    <option value="data_user_id">人员</option>
						    <option value="data_dept_id">部门</option>
						    <option value="data_org_id">单位</option>
						    <!-- <option value="column_add">+</option> -->
						</select>
					</td>
					<td style="width:70px;display: block;margin-top: 5px;">
						<a href="javascript:void(0);" onclick="openDataTalbeDlg();" style="display: block;width:70px;">[添加字段]</a>
					</td>
					<td>
						<select class="easyui-combobox" data-options="editable:false,onSelect:function(){opOnSelect($(this));}" name="op" style="width:100px;">
						    <option value="eq">等于</option>
						    <option value="ne">不等于</option>
						    <option value="gt">大于</option>
						    <option value="lt">小于</option>
						    <option value="ge">大于等于</option>
						    <option value="le">小于等于</option>
						    <option value="in">包含于</option>
						    <option value="not in">不包含于</option>
						</select>
					</td>
					<td>
						<input class="easyui-textbox" data-options="editable:false" dataType="0" name="value" value="本人" style="width:450px;" />
						<input type="hidden" value="userSelf"/>
					</td>
					<td style="display: block;width: 5px;"></td>
				</tr>
				<tr class="last">
					<td colspan="5" align="right">
						<select class="easyui-combobox" data-options="editable:false" style="width:70px;">
						    <option value="and">并且</option>
						    <option value="or">或者</option>
						</select>
						<a href="javascript:void(0)" class="easyui-linkbutton"  onclick="addRule(this);" plain="true">增加条件</a>
						<a href="javascript:void(0)" class="easyui-linkbutton" onclick="deleteGroup(this)" plain="true">删除分组</a>
					</td>
					<td style="display: block;width: 5px;"></td>
				</tr>
			</table>
		</div>
		<div style="clear: both;"></div>
	</div>
</body>
</html>