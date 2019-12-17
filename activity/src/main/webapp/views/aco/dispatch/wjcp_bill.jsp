<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>文件呈批传阅笺</title>	
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
			<p class="tablestyle_title" style="font-size:25pt">文件呈批传阅笺</p>
			<input type="hidden" id="bizId_" name="bizId_">
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>来文单位<span class="star">*</span>
					</th>
					<td><input type="text"
						class="form-control validate[required] input" id="textUnit_"
						name="textUnit_"></td>
					<th>收文日期</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="receiveDate" name="receiveDate" style="width: 100%"
								class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
						</div></td>
				</tr>
				<tr>
					<th>文件标题<span class="star">*</span>
					</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input"
								id="title_" name="title_" value="" placeholder="">
						</div></td>
				</tr>
				<tr>
					<th>密级程度</th>
					<td>
						<div class="form-group">
							<select class="selectpicker select" id="securityLevel_"
								name="securityLevel_" value="" title="请选择">
								<option value="1">公开</option>
								<option value="2">内部</option>
							</select>
						</div></td>
					<th>收文份数</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="receiveNum_"
								name="receiveNum_">
						</div></td>
				</tr>
				<tr>
					<th height="180">主管经理审核</th>
					<td colspan="3">
						<div class="form-group" style="overflow-y:auto;height:380px;">
							<textarea class="form-control comment" id="commentZgjl_"
								name="commentZgjl_" style="background-color:white" rows="4"
								placeholder=""></textarea>
							<div style="padding-top: 10px">${commentZgjl_}</div>
							<%-- <div style="padding-top: 10px">
								<c:choose>
									<c:when test="${not empty commentZgjl_}">
										<c:forEach items="${commentZgjl_}" var="comment" varStatus="vs">
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
					<th height="180">收发</th>
					<td colspan="3">
						<div class="form-group" style="overflow-y:auto;height:380px;">
							<textarea class="form-control comment" id="commentSf_"
								name="commentSf_" style="background-color:white" rows="4"
								placeholder=""></textarea>
							<div style="padding-top: 10px">${commentSf_}</div>
							<%-- <div style="padding-top: 10px">
								<c:choose>
									<c:when test="${not empty commentSf_}">
										<c:forEach items="${commentSf_}" var="comment"
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
			</table>
			<div class="txm">
			<c:if test="${serialNumber!=''&&serialNumber!=null}">
				<img alt="图片未加载" src="${ctx}/bpmRuFormInfoController/getOneBarcode?barcodeNum=${serialNumber}" />
			</c:if>
			</div>
		</form>
	</div>
</body>
<script type="text/javascript">
	var map = [${keyValueMap}];
	var style = "${style}";
	var tableName = "${tableName}";
	var commentColumn = "${commentColumn}";
</script>
<script src="${ctx}/views/aco/dispatch/js/biz_form_common.js"></script>
<script src="${ctx}/views/aco/dispatch/js/signature.js"></script>
<script src="${ctx}/views/aco/dispatch/js/deptData.js"></script>
</html>