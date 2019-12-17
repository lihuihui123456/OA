<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>函件报批单</title>	
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css">
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
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
	<div class="paper-inner">
		<form id="myFm">
			<p class="tablestyle_title" style="font-size:25pt">函件报批单</p>
			<input type="hidden" id="bizId_" name="bizId_">
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>标题(内容)<span class="star">*</span>
					</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input"
								id="title_" name="title_" maxlength="256" value="" placeholder="">
						</div></td>
				</tr>
				<tr>
					<th width="20%">来函单位<span class="star">*</span>
					</th>
					<td width="30%"><input type="text"
						class="form-control validate[required] input" id="textUnit_"
						name="textUnit_"></td>
					<th width="20%">来函者姓名<span class="star">*</span></th>
					<td width="30%"><input type="text"
						class="form-control validate[required] input" id="textName_"
						name="textName_"></td>
				</tr>
				<tr>
					<th>收函部门<span class="star">*</span></th>
					<td>
						<input id="receiveDepartId_" class="form-control"
						name="receiveDepartId_" type="hidden"
						style="width: 100%; height: 29; border: 0;"
						value="<shiro:principal property='deptId'/>" /> 
						<input id="receiveDepartIdName_" name="receiveDepartIdName_"
						class="validate[required] form-control select"
					   type="text"  style="width: 100%; height: 29; border: 0;"
						onclick="deptTree(2,'receiveDepartId_');"
						value="<shiro:principal property='deptName'/>" />
<%-- 						<div id="treeDiv_receiveDepartId_" class="treeDiv" style="z-index:2">
							<div id="treeDemo_receiveDepartId_" class="ztree"
								style="width:240px;height:120px; margin-top:25px; overflow:auto;font-size: 13px;">
								<ul id="groupTree_receiveDepartId_" class="ztree"
									style="margin-top: 5px;"></ul>
							</div>
						</div> 
						<input id="receiveDepartId_" class="form-control" name="receiveDepartId_"
							type="hidden" style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='deptId'/>" />
						<input id="receiveDepartIdName_" name="receiveDepartIdName_"
							class="validate[required] form-control select" onclick="peopleTree(2,'receiveDepartId_')"; 
							 type="text" style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='deptName'/>" /> --%>
					</td>
					<th>收函日期</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="receiveDate_" name="receiveDate_" style="width: 100%"
								class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
						</div></td>
				</tr>
				<tr>
					<th height="180">院领导批示意见</th>
					<td colspan="3">
						<div class="form-group" style="word-break:break-all;overflow:auto;overflow-y:auto;height:230px;">
							<textarea class="form-control comment" id="commentYld_"
								name="commentYld_" style="background-color:white" rows="4"
								placeholder="" onpropertychange="if(value.length>2048) value=value.substr(0,2048)"></textarea>
							<div style="padding-top: 10px">${commentYld_}</div>
							<%-- <div style="padding-top: 10px">
								<c:choose>
									<c:when test="${not empty commentYld_}">
										<c:forEach items="${commentYld_}" var="comment" varStatus="vs">
											<c:if test="${comment.message_!=''}">
												<label
													style="color:#2a2a2a;margin-top:8px;padding-left:10px;">${comment.message_}</label>
												<br>
												<label
													style="color:#888;padding-left:10px;margin-top:5px;margin-bottom:5px;">&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;</label>
												<label style="color:#888;"><fmt:formatDate
														value="${comment.time_ }" type="both"
														pattern="yyyy-MM-dd HH:mm:ss" /> </label>
												<br>
											</c:if>
										</c:forEach>
									</c:when>
								</c:choose>
							</div> --%>
						</div></td>
				</tr>
				<tr>
					<th height="180">局领导批示意见</th>
					<td colspan="3">
						<div class="form-group" style="word-break:break-all;overflow:auto;overflow-y:auto;height:230px;">
							<textarea class="form-control comment" id="commentJld_"
								name="commentJld_" style="background-color:white" rows="4"
								placeholder="" onpropertychange="if(value.length>2048) value=value.substr(0,2048)"></textarea>
							<div style="padding-top: 10px">${commentJld_}</div>
							<%-- <div style="padding-top: 10px">
								<c:choose>
									<c:when test="${not empty commentJld_}">
										<c:forEach items="${commentJld_}" var="comment"
											varStatus="vs">
											<c:if test="${comment.message_!=''}">
												<label
													style="color:#2a2a2a;margin-top:8px;padding-left:10px;">${comment.message_}</label>
												<br>
												<label
													style="color:#888;padding-left:10px;margin-top:5px;margin-bottom:5px;">&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;</label>
												<label style="color:#888;"><fmt:formatDate
														value="${comment.time_ }" type="both"
														pattern="yyyy-MM-dd HH:mm:ss" /> </label>
												<br>
											</c:if>
										</c:forEach>
									</c:when>
								</c:choose>
							</div> --%>
						</div></td>
				</tr>
				<tr>
					<th height="180">部门负责人意见</th>
					<td colspan="3">
						<div class="form-group" style="word-break:break-all;overflow:auto;overflow-y:auto;height:230px;">
							<textarea class="form-control comment" id="commentBm_"
								name="commentBm_" style="background-color:white" rows="4"
								placeholder="" onpropertychange="if(value.length>2048) value=value.substr(0,2048)"></textarea>
							<div style="padding-top: 10px">${commentBm_}</div>
							<%-- <div style="padding-top: 10px">
								<c:choose>
									<c:when test="${not empty commentBm_}">
										<c:forEach items="${commentBm_}" var="comment" varStatus="vs">
											<c:if test="${comment.message_!=''}">
												<label
													style="color:#2a2a2a;margin-top:8px;padding-left:10px;">${comment.message_}</label>
												<br>
												<label
													style="color:#888;padding-left:10px;margin-top:5px;margin-bottom:5px;">&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;</label>
												<label style="color:#888;"><fmt:formatDate
														value="${comment.time_ }" type="both"
														pattern="yyyy-MM-dd HH:mm:ss" /> </label>
												<br>
											</c:if>
										</c:forEach>
									</c:when>
								</c:choose>
							</div> --%>
						</div></td>
				</tr>
			</table>
			<div class="txm">
			<c:if test="${serialNumber!=''&&serialNumber!=null}">
				<img alt="图片未加载" src="${ctx}/bpmRuFormInfoController/getOneBarcode?barcodeNum=${serialNumber}" />
			</c:if>
			</div>
		</form>
	</div>
</body>
<%@ include file="/views/aco/common/selectionPeople_tree.jsp"%>
<%@ include file="/views/aco/common/selectionDept_tree.jsp"%>
<script type="text/javascript">
	var map = [${keyValueMap}];
	var style = "${style}";
	var tableName = "${tableName}";
	var commentColumn = "${commentColumn}";
	$(function(){
		getNowData();
	});
	function getNowData(){
		var date = new Date();
	    var seperator1 = "-";
	    var seperator2 = ":";
	    var month = date.getMonth() + 1;
	    var strDate = date.getDate();
	    if (month >= 1 && month <= 9) {
	        month = "0" + month;
	    }
	    if (strDate >= 0 && strDate <= 9) {
	        strDate = "0" + strDate;
	    }
	    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate;
	    $("#receiveDate_").val(currentdate);
	}
</script>
<script src="${ctx}/views/aco/dispatch/js/biz_form_common.js"></script>
<script src="${ctx}/views/aco/dispatch/js/signature.js"></script>
<%-- <script src="${ctx}/views/aco/dispatch/js/deptData.js"></script>
 --%></html>