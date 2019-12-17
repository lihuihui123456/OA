<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>会议纪要</title>
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
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
	<div class="paper-inner">
		<form id="mtgSummFormView" name="mtgSummFormView" >
			<p class="tablestyle_title" style="font-size:25pt">会议纪要档案登记单</p>
			<input type="hidden" id="arcId" name="arcId" value="${arcMtgSummAll.arcId}">
					<input type="hidden" id="Id" name="Id" value="${arcMtgSummAll.id}">
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
						</div> <input id="draftUserId_" class="form-control" name="draftUserId_"
						type="hidden" style="width: 100%; height: 29; border: 0;"
						value="<shiro:principal property='id'/>" /> <input
						id="draftUserIdName_" name="regUser"
						class="validate[required] form-control select"
						onclick="peopleTree(1,'draftUserId_')" ; 
							 type="text"
						style="width: 100%; height: 29; border: 0;"
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
						type="hidden" style="width: 100%; height: 29; border: 0;"
						value="<shiro:principal property='deptId'/>" /> <input
						id="draftDeptIdName_" name="regDept"
						class="validate[required] form-control select"
						name="draft_depart_name" type="text"
						style="width: 100%; height: 29; border: 0;"
						onclick="peopleTree(2,'draftDeptId_');"
						value="<shiro:principal property='deptName'/>" />
					</td>
				</tr>
				<tr>
					<th>登记日期</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="regTime" name="regTime"  value="<fmt:formatDate value='${arcMtgSummAll.regTime}'  pattern='yyyy-MM-dd HH:mm:ss'/>"
								style="width: 100%" class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
					<th>档案类型</th>
					<td>
						<div class="form-group">
							<select class="validate[required]  selectpicker select"
								id="arcType" name="arcType" value="${arcMtgSummAll.arcType}" title="请选择">
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>会议类型<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<select class="validate[required]  selectpicker select" 
								id="amsType" name="amsType" value="${arcMtgSummAll.amsType}" title="请选择">
								<option value="0">党委</option>
								<option value="1">纪委</option>
								<option value="2">董事会</option>
								<option value="3">监事会</option>
								<option value="4">总经理办公会</option>
								<option value="5">其他会议</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>文件标题<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input"
								id="arcName" name="arcName" value="${arcMtgSummAll.arcName}" >
						</div>
					</td>
				</tr>
				<tr>
					<th>会议名称</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class=" form-control input"
								id="amsName" name="amsName" value="${arcMtgSummAll.amsName}">
						</div>
					</td>
				</tr>
				<tr>
					<th>会议时间</th>
					<td>
						<div class="form-group date">
								<input type="text" id="amsTime" name="amsTime"  value="<fmt:formatDate value='${arcMtgSummAll.amsTime}'  pattern='yyyy-MM-dd HH:mm:ss'/>"
								style="width: 100%" class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
							
						</div>
					</td>
					<th>主持人</th>
					<td>
						<div class="input-group " style="width: 100%">
							<input type="text" class="form-control input" id="amsEmcee"
								name="amsEmcee" value="${arcMtgSummAll.amsEmcee}">
						</div>
					</td>
				</tr>
				<tr>
					<th>会议地点</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" id="amsAdd"
								name="amsAdd" value="${arcMtgSummAll.amsAdd}">
						</div>
					</td>
				</tr>
				<tr>
					<th>会议议题</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" id="amsTopic"
								name="amsTopic" value="${arcMtgSummAll.amsTopic}">
						</div>
					</td>
				</tr>
				<tr>
					<th>召集部门</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="smdDept"
								name="smdDept" value="${arcMtgSummAll.smdDept}">
						</div>
					</td>
					<th>参与部门</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="iltDept"
								name="iltDept" value="${arcMtgSummAll.iltDept}">
						</div>
					</td>
				</tr>
				<tr>
					<th>有效期</th>
					<td colspan="3">
						<div class="form-group">
							<select class="validate[required]  selectpicker select"
								id="expiryDate" name="expiryDate" value="" title="请选择">
									 <c:choose>
                                <c:when test="${arcMtgSummAll.expiryDate==10}">
                                   <option value="10" selected="selected">10年</option>                              
                                </c:when>
                                <c:otherwise>
                                <option value="10" >10年</option>
                                </c:otherwise>
                                </c:choose>
                                 <c:choose>
                                <c:when test="${arcMtgSummAll.expiryDate==30}">
                                   <option value="30" selected="selected">30年</option>                              
                                </c:when>
                                <c:otherwise>
                                <option value="30" >30年</option>
                                </c:otherwise>
                                </c:choose>		
                                 <c:choose>
                                <c:when test="${arcMtgSummAll.expiryDate==0}">
                                   <option value="0" selected="selected">永久有效</option>                              
                                </c:when>
                                <c:otherwise>
                                <option value="0" >永久有效</option>
                                </c:otherwise>
                                </c:choose>
							</select>
						</div>
					</td>
				</tr>

				<tr>
					<th>存放位置<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input"
								id="depPos" name="depPos" value="${arcMtgSummAll.depPos}">
						</div>
					</td>
				</tr>
				<tr>
					<th>归档人</th>
					<td>
						<div id="treeDiv_draftUserId_" class="treeDiv" style="z-index:2">
							<div id="treeDemo_draftUserId_" class="ztree"
								style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
								<ul id="groupTree_draftUserId_" class="ztree"
									style="margin-top: 10px;"></ul>
							</div>
						</div> <input id="fileUserId" class="form-control" name="fileUserId"
						type="hidden" style="width: 100%; height: 29; border: 0;"
						value="<shiro:principal property='id'/>" /> <input
						id="fileUser" name="fileUser"
						class="form-control select"
						onclick="peopleTree(1,'draftUserId_')" ; 
							 type="text"
						style="width: 100%; height: 29; border: 0;"
						value="${arcMtgSummAll.fileUserName}" />
					</td>
					<th>归档日期</th>
					<td colspan="3">
						<div class="input-group date" style="width: 100%">
							<input type="text" id="fileTime" name="fileTime" value="<fmt:formatDate value='${arcMtgSummAll.fileTime}'  pattern='yyyy-MM-dd HH:mm:ss'/>"
								style="width: 100%" class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
<%-- <script src="${ctx}/views/arc/userinfo/js/deptData.js"></script>
 --%><script src="${ctx}/views/aco/arc/mtgsumm/js/mtgSumm_form_view.js"></script>
</html>