<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>党组发文</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css"  href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
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
.form-group{
	margin-bottom:0;
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
.paper-outer{
	background-color: #bebebe; 
	padding:3% 5% 3% 5%;
}
.paper-inner{
	background-color: white;
	padding:3% 5% 3% 5%;
}
.tablestyle th{
	text-align:center;
	vertical-align:middle;
}
.bootstrap-select > .dropdown-toggle {
  width: 100%;
  padding-right: 25px;
  border-width:0;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
	<div class="paper-inner">
		<form id="myFm">
			<p class="tablestyle_title" style="font-size:25pt">党组发文稿纸</p>
			<input type="hidden" id="bizId_" name="bizId_">
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>标题<span class="star">*</span></th>
					<td colspan="5">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input" id="title_" name="title_" maxlength="256">
						</div>
					</td>
				</tr>
				<tr>
					<th width="16%">发文字号<span class="star">*</span></th>
					<td width="16%">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input" id="fwzh_"
								name="fwzh_" value="" placeholder="">
						</div>
					</td>
					<th width="16%">紧急程度</th>
					<td width="16%">
						<div class="form-group">
							<select class="selectpicker select" id="urgencyLevel_"
								name="urgencyLevel_" value="" title="请选择">
								<option value="1">平件</option>
								<option value="2">急件</option>
								<option value="3">特急</option>
							</select>
						</div>
					</td>
					<th>密 级</th>
					<td width="20%"> 
						<div class="form-group">
							<select class="selectpicker select" id="securityLevel_"
								name="securityLevel_" value="" title="请选择">
								<option value="1">公开</option>
								<option value="2">内部</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th height="145">处室意见</th>
					<td colspan="5">
						<div class="form-group" style="word-break:break-all;overflow:auto;overflow-y:auto;height:145px;">
							<textarea class="form-control comment" id="commentCsyj_" name="commentCsyj_" onpropertychange="if(value.length>2048) value=value.substr(0,2048)" 
							style="background-color: white" rows="4" placeholder="">${submission.depart_instruction}</textarea>
							<div style="padding-top: 10px">${commentCsyj_}</div>
							<%-- <div style="padding-top: 10px">
								<c:choose>
									<c:when test="${not empty commentCsyj_}">
										<c:forEach items="${commentCsyj_}" var="comment" varStatus="vs">
											<c:if test="${comment.message_!=''}">
												<label style="color:#2a2a2a;margin-top:8px;padding-left:10px;">${comment.message_}</label>
												<br>
												<label
													style="color:#888;padding-left:10px;margin-top:5px;margin-bottom:5px;">&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;</label>
												<label style="color:#888;"><fmt:formatDate
														value="${comment.time_ }" type="both"
														pattern="yyyy-MM-dd HH:mm:ss" />
												</label>
												<br>
											</c:if>
										</c:forEach>
									</c:when>
								</c:choose>
							</div> --%>
						</div>
					</td>
				</tr>
				<tr>
					<th height="145">审核意见</th>
					<td colspan="5">
						<div class="form-group" style="word-break:break-all;overflow:auto;overflow-y:auto;height:145px;">
							<textarea class="form-control comment" id="commentShyj_" name="commentShyj_" onpropertychange="if(value.length>2048) value=value.substr(0,2048)" 
							style="background-color: white" rows="4" placeholder="">${submission.bur_instruction}</textarea>
							<div style="padding-top: 10px">${commentShyj_}</div>
							<%-- <div style="padding-top: 10px">
								<c:choose>
									<c:when test="${not empty commentShyj_}">
										<c:forEach items="${commentShyj_}" var="comment" varStatus="vs">
											<c:if test="${comment.message_!=''}">
												<label style="color:#2a2a2a;margin-top:8px;padding-left:10px;">${comment.message_}</label>
												<br>
												<label
													style="color:#888;padding-left:10px;margin-top:5px;margin-bottom:5px;">&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;</label>
												<label style="color:#888;"><fmt:formatDate
														value="${comment.time_ }" type="both"
														pattern="yyyy-MM-dd HH:mm:ss" />
												</label>
												<br>
											</c:if>
										</c:forEach>
									</c:when>
								</c:choose>
							</div> --%>
						</div>
					</td>
				</tr>
				<tr>
					<th height="145">局意见</th>
					<td colspan="5">
						<div class="form-group" style="word-break:break-all;overflow:auto;overflow-y:auto;height:145px;">
							<textarea class="form-control comment" id="commentJyj_" name="commentJyj_" onpropertychange="if(value.length>2048) value=value.substr(0,2048)" 
							style="background-color: white" rows="4" placeholder="">${submission.depart_instruction}</textarea>
							<div style="padding-top: 10px">${commentJyj_}</div>
							<%-- <div style="padding-top: 10px">
								<c:choose>
									<c:when test="${not empty commentJyj_}">
										<c:forEach items="${commentJyj_}" var="comment" varStatus="vs">
											<c:if test="${comment.message_!=''}">
												<label style="color:#2a2a2a;margin-top:8px;padding-left:10px;">${comment.message_}</label>
												<br>
												<label
													style="color:#888;padding-left:10px;margin-top:5px;margin-bottom:5px;">&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;</label>
												<label style="color:#888;"><fmt:formatDate
														value="${comment.time_ }" type="both"
														pattern="yyyy-MM-dd HH:mm:ss" />
												</label>
												<br>
											</c:if>
										</c:forEach>
									</c:when>
								</c:choose>
							</div> --%>
						</div>
					</td>
				</tr>
				<tr>
					<th height="145">签发意见</th>
					<td colspan="5">
						<div class="form-group" style="word-break:break-all;overflow:auto;overflow-y:auto;height:145px;">
							<textarea class="form-control comment" id="commentQfyj_"
								name="commentQfyj_" style="background-color:white" rows="4"
								placeholder="" onpropertychange="if(value.length>2048) value=value.substr(0,2048)"></textarea>
							<div style="padding-top: 10px">${commentQfyj_}</div>
							<%-- <div style="padding-top: 10px">
								<c:choose>
									<c:when test="${not empty commentQfyj_}">
										<c:forEach items="${commentQfyj_}" var="comment" varStatus="vs">
											<c:if test="${comment.message_!=''}">
												<label style="color:#2a2a2a;margin-top:8px;padding-left:10px;">${comment.message_}</label>
												<br>
												<label
													style="color:#888;padding-left:10px;margin-top:5px;margin-bottom:5px;">&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;</label>
												<label style="color:#888;"><fmt:formatDate
														value="${comment.time_ }" type="both"
														pattern="yyyy-MM-dd HH:mm:ss" />
												</label>
												<br>
											</c:if>
										</c:forEach>
									</c:when>
								</c:choose>
							</div> --%>
						</div>
					</td>
				</tr>
				<tr>
					<th>主送单位</th>
					<td colspan="5">
						<div class="form-group">
							<input type="text" class="form-control input" id="mainSend_" name="mainSend_">
						</div>
					</td>
				</tr>
				<tr>
					<th>抄送单位</th>
					<td colspan="5">
						<div class="form-group">
							<input type="text" class="form-control input" id="copySend_" name="copySend_">
						</div>
					</td>
				</tr>
				<tr>
					<th>拟稿部门<span class="star">*</span></th>
					<td>
						<input id="draftDeptId_" class="form-control"
						name="draftDeptId_" type="hidden"
						style="width: 100%; height: 29; border: 0;"
						value="<shiro:principal property='deptId'/>" /> 
						<input id="draftDeptIdName_" name="draftDeptIdName_"
						class="validate[required] form-control select" type="text"
						style="width: 100%; height: 29; border: 0;"
						onclick="deptTree(2,'draftDeptId_');"
						value="<shiro:principal property='deptName'/>" />
					</td>
					<th>拟稿人<span class="star">*</span></th>
					<td>
						<input id="draftUserId_" class="form-control" name="draftUserId_"
							type="hidden" style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='id'/>" />
						<input id="draftUserIdName_" name="draftUserIdName_"
							class="validate[required] form-control select" onclick="peopleTree(1,'draftUserId_')"; 
							 type="text" style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='name'/>" />
					</td>
					<th>印刷份数</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="printNumber_" name="printNumber_">
						</div>
					</td>
				</tr>
				<tr>
					<th>印刷单位<span class="star">*</span></th>
					<td>
						<div class="form-group">
							<input type="text" class="validate[required] form-control input" id="printDeptIdName_" name="printDeptIdName_">
						</div>
					</td>
					<th>核稿人</th>
					<td>
						<input id="checkUserId_" class="form-control" name="checkUserId_"
						type="hidden" style="width: 100%; height: 29; border: 0;" value="" />
						<input id="checkUserIdName_" name="checkUserIdName_"
						class="form-control select" onclick="peopleTree(1,'checkUserId_')"; 
						 type="text" style="width: 100%; height: 29; border: 0;"
						value="" />
					</td>
					<th>印制时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="printTime_" name="printTime_" value="" style="width: 100%"
								class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />

						</div>
					</td>
				</tr>
			</table>
			<div class="txm">
			<c:if test="${serialNumber!=''&&serialNumber!=null}">
				<img alt="图片未加载" src="${ctx}/bpmRuFormInfoController/getOneBarcode?barcodeNum=${serialNumber}" />
			</c:if>
			</div>
		</form>
	</div>
<%@ include file="/views/aco/common/selectionPeople_tree.jsp"%>
<%@ include file="/views/aco/common/selectionDept_tree.jsp"%>
</body>
<script type="text/javascript">
	var map = [${keyValueMap}];
	var style = "${style}";
	var tableName = "${tableName}";
	var commentColumn = "${commentColumn}";
</script>
<script src="${ctx}/views/aco/dispatch/js/biz_form_common.js"></script>
<script src="${ctx}/views/aco/dispatch/js/signature.js"></script>
</html>