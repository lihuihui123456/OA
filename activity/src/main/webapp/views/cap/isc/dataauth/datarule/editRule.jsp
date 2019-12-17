<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>修改数据规则</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/isc/dataauth/datarule/js/dataRuleUpdateIframe.js"></script>
	<script type="text/javascript">
		/**
		 * 全局变量
		 * */
		var curObj = undefined;//选人图标点击，记录当前对象，以便选完之后复制
		var columns = '${columnsStr}';//菜单对应业务表字段数组
		var columnsAllStr = '${dataTableCols}';//下拉框加载时的数据（菜单对应业务表字段关联用户json数组字符串）
		var columnsAll = eval("("+columnsAllStr+")");//下拉框加载时的数据（菜单对应业务表字段关联用户json数组）
		var columnsRefUser = '${columnsRefUser}';//菜单对应业务表字段关联用户json数组字符串
		var tableName = '${tableName}';//菜单对应业务表名称
		var comboboxDom = '${comboboxDom}';//下拉框字符串，添加分组、添加规则使用
		var defaultSelect = '<select class="easyui-combobox fieldSelect" data-options="editable:false,onSelect:function(){onselect($(this));}" name="field" style="width:150px;">'
			+					    '<option value="data_user_id">人员</option>'
			+					    '<option value="data_dept_id">部门</option>'
			+					    '<option value="data_org_id">单位</option>'
			+					    '<option value="column_add">+</option>'
			+					'</select>';//默认下拉
		var selects = undefined;//所有条件下拉框
		
		$(function(){
			createMenuData("updateCombobox");
			refuseBackspace("addCombobox");
			$("#updateCombobox").combotree("setValue", '${dataRule.resName }');
			$("#up_ruleName").textbox("setValue",'${dataRule.resName }');
			selects = $(".fieldSelect");
		});
	</script>
</head>
<body> 
	<form id="ruleUptForm" method="post" style="display: none;">
		<input type="hidden" id="rule_Id" name="ruleId" value="${dataRule.ruleId }"/>
		<input type="hidden" id="role_Id" name="roleId" value="${dataRule.roleId }"/>
		<input type="hidden" id="res_Name" name="resName" value="${dataRule.resName }" />
		<input type="hidden" id="res_Code" name="resCode" value="${dataRule.resCode }" />
		<input type="hidden" id="rule_Name" name="ruleName" value="${dataRule.ruleName }" />
		<input type="hidden" id="rule_Def" name="ruleDef" value="${dataRule.ruleDef }" />
	</form>
	<div style="margin-top: 10px;">
		<div style="float:left;width: 80px;">资源：</div>
		<div>
			<select class="easyui-combotree" id="updateCombobox" name="modCode" style="width:380px;" data-options="disabled:true,valueField:'modCode', textField:'text'"></select>
		</div>
		<div style="clear: both;"></div>
	</div>
	<div style="margin-top: 10px;">
		<div style="float:left;width: 80px;">规则名称<span style="color:red;vertical-align:middle;">*</span>：</div>
		<div>
			<input class="easyui-textbox" id="up_ruleName" style="width: 380px;"/>
			<a href="javascript:void(0)"  class="easyui-linkbutton" onclick="addGroup('rulesUpdateDiv');" plain="true">增加分组</a>
		</div>
		<div style="clear: both;"></div>
	</div>
	<div style="margin-top: 10px;">
		<div style="float:left;width: 80px;">规则定义：</div>
		<div id ="rulesUpdateDiv" style="float:left;width:620px;">
			<c:forEach items="${groupList }" var="group" varStatus="groupStatus">
				<table style="float: left;">
					<c:forEach items="${group.rules }" var="rule" varStatus="ruleStatus">
						<tr>
							<td>
								<c:if test="${ruleStatus.index == 0 }">
									<span style="width:70px;display: block;"></span>
								</c:if>
								<c:if test="${ruleStatus.index != 0 }">
									<select class="easyui-combobox" data-options="editable:false" panelHeight="50" name="ruleOp" style="width:70px;">
										<option value="and" <c:if test='${rule.ruleOp =="and" }'>selected</c:if>>并且</option>
										<option value="or" <c:if test='${rule.ruleOp =="or" }'>selected</c:if>>或者</option>
									</select>
								</c:if>
							</td>
							<td>
								<select class="easyui-combobox fieldSelect" panelHeight="150" data-options="editable:false,onSelect:function(){onselect($(this));},valueField : 'enName',textField : 'cnName',data:columnsAll,
									onLoadSuccess:function(){
										$(this).combobox('setValue','${rule.field }');
									}" name="field" style="width:150px;">
								</select>
							</td>
							<td style="width:70px;display: block;margin-top: 5px;">
								<a href="javascript:void(0);" onclick="openDataTalbeDlg();" style="display: block;width:70px;">[添加字段]</a>
							</td>
							<td>
								<select class="easyui-combobox" data-options="editable:false,onSelect:function(){opOnSelect($(this));}" name="op" style="width:100px;">
								    <option value="eq" <c:if test='${rule.op =="eq" }'>selected</c:if>>等于</option>
								    <option value="ne" <c:if test='${rule.op =="ne" }'>selected</c:if>>不等于</option>
								    <option value="gt" <c:if test='${rule.op =="gt" }'>selected</c:if>>大于</option>
								    <option value="lt" <c:if test='${rule.op =="lt" }'>selected</c:if>>小于</option>
								    <option value="ge" <c:if test='${rule.op =="ge" }'>selected</c:if>>大于等于</option>
								    <option value="le" <c:if test='${rule.op =="le" }'>selected</c:if>>小于等于</option>
								    <option value="in" <c:if test='${rule.op =="in" }'>selected</c:if>>包含于</option>
								    <option value="not in" <c:if test='${rule.op =="not in" }'>selected</c:if>>不包含于</option>
								</select>
							</td>
							<td>
								<c:choose>
									<c:when test='${rule.field =="data_user_id" }'>
										<c:choose>
											<c:when test='${rule.op =="eq" }'>
												<input class="easyui-textbox" data-options="editable:false" value="${rule.value }"  dataType="0" name="value" style="width:450px;" />
											</c:when>
											<c:otherwise>
												<input class="easyui-textbox" value="${rule.value }" data-options="editable:false,iconWidth:22,icons: [{iconCls:'icon-search',handler: function(e){var v = $(e.data.target).textbox('getValue');}}],onClickIcon:onClickIcon" dataType="0" name="value" style="width:450px;" />
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:when test='${rule.field =="data_dept_id" }'>
										<c:choose>
											<c:when test='${rule.op =="eq" }'>
												<input class="easyui-textbox" data-options="editable:false" value="${rule.value }"  dataType="0" name="value" style="width:450px;" />
											</c:when>
											<c:otherwise>
												<input class="easyui-textbox" value="${rule.value }" data-options="editable:false,iconWidth:22,icons: [{iconCls:'icon-search',handler: function(e){var v = $(e.data.target).textbox('getValue');}}],onClickIcon:onClickIcon" dataType="1" name="value" style="width:450px;" />
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:when test='${rule.field =="data_org_id" }'>
										<c:choose>
											<c:when test='${rule.op =="eq" }'>
												<input class="easyui-textbox" data-options="editable:false" value="${rule.value }"  dataType="0" name="value" style="width:450px;" />
											</c:when>
											<c:otherwise>
												<input class="easyui-textbox" value="${rule.value }" data-options="editable:false,iconWidth:22,icons: [{iconCls:'icon-search',handler: function(e){var v = $(e.data.target).textbox('getValue');}}],onClickIcon:onClickIcon" dataType="2" name="value" style="width:450px;" />
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:otherwise>
										<input class="easyui-textbox" value="${rule.value }"  dataType="0" name="value" style="width:450px;" />
									</c:otherwise>
								</c:choose>
								<input type="hidden" value="${rule.hiddenValue }"/>
							</td>
							<td style="display: block;width: 5px;">
								<c:if test="${ruleStatus.index != 0 }">
									<span style="color: red;cursor: pointer;" onclick="javascript:deleteRule(this);">X</span>
								</c:if>
							</td>
						</tr>
					</c:forEach>
					<tr class="last">
						<td colspan="5" align="right">
							<select class="easyui-combobox" data-options="editable:false" panelHeight="50" name="op" style="width:70px;">
							    <option value="and" <c:if test='${group.op =="and" }'>selected</c:if>>并且</option>
							    <option value="or" <c:if test='${group.op =="or" }'>selected</c:if>>或者</option>
							</select>
							<a href="javascript:void(0)" class="easyui-linkbutton"  onclick="addRule(this);" plain="true">增加条件</a>
							<a href="javascript:void(0)" class="easyui-linkbutton" onclick="deleteGroup(this)" plain="true">删除分组</a>
						</td>
					<td style="display: block;width: 5px;"></td>
					</tr>
				</table>
			</c:forEach>
		</div>
		<div style="clear: both;"></div>
	</div>
</body>
</html>