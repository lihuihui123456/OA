<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>其他档案登记</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/css/table.css"
	rel="stylesheet">
<script
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<style>
.btn-default {
	color: #333;
	background-color: #fff;
	border-color: #fff;
}

.btn-default.focus,.btn-default:focus {
	color: #333;
	background-color: #e6e6e6;
	border-color: #fff
}

.btn-default:hover {
	color: #333;
	background-color: #e6e6e6;
	border-color: #fff
}

.btn-default.active,.btn-default:active,.open>.dropdown-toggle.btn-default
	{
	color: #333;
	background-color: #e6e6e6;
	border-color: #fff
}

.btn-default.active.focus,.btn-default.active:focus,.btn-default.active:hover,.btn-default:active.focus,.btn-default:active:focus,.btn-default:active:hover,.open>.dropdown-toggle.btn-default.focus,.open>.dropdown-toggle.btn-default:focus,.open>.dropdown-toggle.btn-default:hover
	{
	color: #333;
	background-color: #d4d4d4;
	border-color: #fff
}

.form-control {
	border: 1px #fff solid;
	-webkit-box-shadow: none;
	box-shadow: none;
}

.form-group {
	margin-bottom: 0;
}

.treeDiv {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	margin-top: 20px;
	display: none;
	position: absolute;
	margin-top: -160px;
	background-image: url('${ctx}/views/aco/dispatch/img/treeImg.png');
	background-color: black;
}

.paper-outer {
	background-color: #bebebe;
	padding: 3% 5% 3% 5%;
}

.paper-inner {
	background-color: white;
	padding: 3% 5% 3% 5%;
}

.tablestyle th {
	text-align: center;
	vertical-align: middle;
}
.bootstrap-select > .dropdown-toggle {
  width: 100%;
  padding-right: 25px;
  border-width:0;
}
</style>
<script type="text/javascript">
 $(function(){
	 $("#arcName").focus();
	 $('#guidangDiv').find('input').attr('readonly',true).attr('disabled',true);
});

</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
	<div class="paper-inner">
		<form id="pubInfoForm" name="pubInfoForm" >
			<p class="tablestyle_title" style="font-size:25pt">其他档案登记单</p>
			<input type="hidden" id="arcId" name="arcId">
			<input type="hidden" id="typeId" name="typeId" value="${typeId}"/>
			<input type="hidden" id="pId" name="pId" value="${pId}"/>	
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>登记人<span class="star">*</span></th>
					<td>
						<div id="treeDiv_draftUserId_" class="treeDiv" style="z-index:2">
							<div id="treeDemo_draftUserId_" class="ztree"
								style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
								<ul id="groupTree_draftUserId_" class="ztree"
									style="margin-top: 10px;"></ul>
							</div>
						</div> 
						<input id="draftUserId_" class="form-control" name="draftUserId_"
						type="hidden" style="width: 100%; height: 29px; border: 0;"
						value="<shiro:principal property='id'/>" /> <input
						id="draftUserIdName_" name="regUser"
						class="validate[required]  select"
						onclick="peopleTree(1,'draftUserId_')" ; 
							 type="text" readonly="readonly"
						style="width: 100%; height: 29px; border: 0;padding:7px 12px;"
						value="<shiro:principal property='name'/>" />
					</td>
					<th>登记部门<span class="star">*</span></th>
					<td>
						<div id="treeDiv_draftDeptId_" class="treeDiv">
							<div id="treeDemo_draftDeptId_" class="ztree"
								style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
								<ul id="groupTree_draftDeptId_" class="ztree"
									style="margin-top: 10px;"></ul>
							</div>
						</div> <input id="draftDeptId_" class="form-control" name="draftDeptId_"
						type="hidden" style="width: 100%; height: 29px; border: 0;"
						value="<shiro:principal property='deptId'/>" /> <input
						id="draftDeptIdName_" name="regDept" readonly="readonly"
						class="validate[required]  select"
						name="draft_depart_name" type="text"
						style="width: 100%; height: 29px; border: 0;padding:7px 12px;"
						onclick="peopleTree(2,'draftDeptId_');"
						value="<shiro:principal property='deptName'/>" />
					</td>
				</tr>
				<tr>
					<th>登记日期<span class="star">*</span></th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="regTime" name="regTime"  value="${nowDate}"
								style="width: 100%" class="validate[required] form-control input"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
					<th>档案类型<span class="star">*</span></th>
					<td>
						<div class="form-group">
							<select class="validate[required]  selectpicker select"
								id="arcType" name="arcType" value="" title="请选择">
							</select>
						</div>
					</td>
				</tr>
<%-- 				<tr>
					<th>会议类型<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<select class="validate[required]  selectpicker select" 
								id="amsType" name="amsType" value="0" title="请选择">
									<c:forEach items="${resultList}" var="arcTypeEntity">
										 <c:choose>
                                <c:when test="${arcTypeEntity.id==typeId}">
									<option value="${arcTypeEntity.id}" selected="selected">${arcTypeEntity.typeName}</option>						
                                </c:when>
                                <c:otherwise>
									<option value="${arcTypeEntity.id}">${arcTypeEntity.typeName}</option>						
                                </c:otherwise>
                                </c:choose>
									</c:forEach>
							</select>
						</div>
					</td>
				</tr> --%>
				<tr>
					<th>文件标题<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input"
								id="arcName" name="arcName">
						</div>
					</td>
				</tr>
				<tr>
					<th>关键字</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class=" form-control input"
								id="keyWord" name="keyWord">
						</div>
					</td>
				</tr>
	
				<tr>
					<th>存放位置<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input"
								id="depPos" name="depPos">
						</div>
					</td>
				</tr>

	

				<tr>
					<th>有效期<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<select class="validate[required]  selectpicker select"
							id="expiryDate" name="expiryDate" value="" title="请选择">
								<option value="0">永久有效</option>
								<option value="10">10年</option>
								<option value="30">30年</option>							
							</select>
						</div>
					</td>
				</tr>
		<tr>
					<th>备注</th>
					<td colspan="3">
						<div class="form-group" >
							<textarea class=" form-control input" name="remarks" id="remarks" ></textarea>
						</div>
					</td>
				</tr>
				<tr id="guidangDiv">
					<th>归档人</th>
					<td>
						<input type="text" class="form-control input" id="fileUser" name=""fileUser"">
					</td>
					<th>归档日期</th>
					<td colspan="3">
							<div class="input-group date" style="width: 100%">
							<input type="text" id="fileTime" name="fileTime" value="" style="width: 100%"
								class="form-control select" />
						</div>
					</td>
				</tr>
				
				
	<%-- 			<tr>
					<th>归档人</th>
						<td>
						<div id="treeDiv_checkUserId_" class="treeDiv">
							<div id="treeDemo_checkUserId_" class="ztree"
								style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
								<ul id="groupTree_checkUserId_" class="ztree"
									style="margin-top: 10px;"></ul>
							</div>
						</div> <input id="checkUserId_" class="form-control" name="checkUserId_"
						type="hidden" style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='id'/>" />
						<input id="checkUserIdName_" name="fileUser"
						class=" select" onclick="peopleTree(1,'checkUserId_')"; readonly="readonly"
						 type="text" style="width: 100%; height: 29; border: 0;padding:12px;"
						value="" />
					</td>
					<th>归档日期</th>
					<td colspan="3">
						<div class="input-group date" style="width: 100%">
							<input type="text" id="fileTime" name="fileTime" value="${nowDate}"
								style="width: 100%" class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
				</tr> --%>
			</table>
		</form>
	</div>
</body>
<script src="${ctx}/views/aco/dispatch/js/deptData.js"></script>
<script src="${ctx}/views/aco/arc/pubinfo/js/pubInfo_form.js"></script>
</html>