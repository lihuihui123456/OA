<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>修改数据规则</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<style type="text/css">
		 *{font-family:"微软雅黑";}
		 .tablepic{
		  border:1px #becedb solid; 
		  color:#272636;
		 }
		 .td{
		  border:1px #becedb solid; 
		  padding:5px;
		 }
		 .tablepic th{
		   background:#eff0f5;
		   border:1px #becedb solid;
		 }
		 .bmw{
		  background:#f8f9fd;
		 }
	</style>
</head>
<body> 

	<table class="excel table table-striped table-bordered tablepic" id="tb" border="1px" width="99%" cellspacing="0px" style="border-collapse:collapse">
		<tr style="height:24px;">
			<th style="width:20%;text-align:center;" class="td">
				资源名称
			</th>
			<th style="text-align:center;width:80%;" class="td">
				规则定义
			</th>
		</tr>
		<c:forEach var="map" items="${map }">
			<tr>
				<td style="text-align:center;" class="td">${map.key }</td>
    			<td class="td" width="400">
    				<div style="margin-top: 10px;">
					<div id ="rulesUpdateDiv" style="float:left;width:620px;">
						<c:forEach items="${map.value }" var="group" varStatus="groupStatus">
							<table style="float: left;">
								<c:forEach items="${group.rules }" var="rule" varStatus="ruleStatus">
									<tr>
										<td>
											<c:if test="${ruleStatus.index == 0 }">
												<span style="width:70px;display: block;"></span>
											</c:if>
											<c:if test="${ruleStatus.index != 0 }">
												<select class="easyui-combobox" data-options="editable:false" panelHeight="50" name="ruleOp" style="width:70px;" disabled>
													<option value="and" <c:if test='${rule.ruleOp =="and" }'>selected</c:if>>并且</option>
													<option value="or" <c:if test='${rule.ruleOp =="or" }'>selected</c:if>>或者</option>
												</select>
											</c:if>
										</td>
										<td>
											<select class="easyui-combobox" data-options="editable:false" name="field" style="width:100px;" disabled>
											    <option value="data_user_id" <c:if test='${rule.field =="data_user_id" }'>selected</c:if>>人员</option>
											    <option value="data_dept_id" <c:if test='${rule.field =="data_dept_id" }'>selected</c:if>>部门</option>
											    <option value="data_org_id" <c:if test='${rule.field =="data_org_id" }'>selected</c:if>>单位</option>
											</select>
										</td>
										<td>
											<select class="easyui-combobox" data-options="editable:false" name="op" style="width:100px;" disabled>
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
											<input class="easyui-textbox" value="${rule.value }" data-options="editable:false" dataType="0" name="value" style="width:360px;" disabled />
										</td>
									</tr>
								</c:forEach>
								<tr class="last">
									<td colspan="5" align="right">
										<select class="easyui-combobox" data-options="editable:false" panelHeight="50" name="op" style="width:70px;" disabled>
										    <option value="and" <c:if test='${group.op =="and" }'>selected</c:if>>并且</option>
										    <option value="or" <c:if test='${group.op =="or" }'>selected</c:if>>或者</option>
										</select>
									</td>
								</tr>
							</table>
						</c:forEach>
					</div>
					<div style="clear: both;"></div>
					</div>
    			</td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>