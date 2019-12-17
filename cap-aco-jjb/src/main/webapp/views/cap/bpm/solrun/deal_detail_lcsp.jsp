<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>流程审批办理详情</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<!-- bootstrop 样式 -->
<link rel="stylesheet"
	href="${ctx}/static/cap/plugins/bootstrap/css/table.css">
<link rel="stylesheet"
	href="${ctx}/static/cap/plugins/bootstrap/css/bootstrap.min.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
<%@ include file="/views/cap/common/theme.jsp"%>
<style>
.form-group {
	padding: 5px 10px;
	margin-bottom: 0px;
}
</style>
</head>
<script type="text/javascript">
	var showtype = false;
	$(function() {
		//返回按钮事件
		$('#btn_close').click(function() {
			if (typeof window.parent.parent.closePage== 'function') {
				window.parent.parent.closePage(window, true, true, false);
			} else {
				//领导桌面使用
				window.parent.closePage(window, true, true, false);
			}
		});
	});
</script>
<body>
	<div class="panel-body"
		style="padding-bottom: 30px; border: 0; padding-left:20px; padding-right:30px;">
		<div id="toolbar" class="btn-group">
			<button id="btn_close" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-reply" aria-hidden="true"></span>返回
			</button>
		</div>
		<table class="tablestyle" width="100%" border="0" cellspacing="0">
			<tr>
				<th colspan="4">办理详情</th>
			</tr>
			<tr>
				<th width="20%">文件名称</th>
				<td width="35%"><div
						style="word-break:break-all;overflow:auto;" class="form-group">${bean.bizTitle_}</div></td>
				<th width="20%">办理状态</th>
				<c:choose>
					<c:when test="${bean.state_=='0'}">
						<td width="35%"><div class="form-group">待发</div></td>
					</c:when>
					<c:when test="${bean.state_=='1'}">
						<td width="35%"><div class="form-group">在办</div></td>
					</c:when>
					<c:when test="${bean.state_=='2'}">
						<td width="35%"><div class="form-group">办结</div></td>
					</c:when>
					<c:when test="${bean.state_=='3'}">
						<td width="35%"><div class="form-group">流程撤销</div></td>
					</c:when>
					<c:when test="${bean.state_=='4'}">
						<td width="35%"><div class="form-group">流程挂起</div></td>
					</c:when>
					<c:otherwise>
						<td width="35%"><div class="form-group">--</div></td>
					</c:otherwise>
				</c:choose>
			</tr>
			<tr>
				<th width="20%">开始时间</th>
				<td width="35%"><div class="form-group">${bean.startTime_}</div></td>
				<th width="20%">结束时间</th>
				<td width="30%"><div class="form-group">${bean.endTime_}</div></td>
			</tr>
			<tr>
				<th>任务送办人</th>
				<td><div class="form-group">${bean.userName_}</div></td>
				<th>紧急程度</th>
				<c:choose>
					<c:when test="${bean.urgency_=='1'}">
						<td><div class="form-group">平件</div></td>
					</c:when>
					<c:when test="${bean.urgency_=='2'}">
						<td><div class="form-group">急件</div></td>
					</c:when>
					<c:when test="${bean.urgency_=='3'}">
						<td><div class="form-group">特急</div></td>
					</c:when>
					<c:otherwise>
						<td><div class="form-group">--</div></td>
					</c:otherwise>
				</c:choose>
			</tr>
		</table>
		<br>
		<table class="tablestyle" width="100%" border="0" cellspacing="0">
			<tr>
				<th>办理环节</th>
				<th style="width:100px">办理人</th>
				<th style="width:100px; display:none" class="hidecolumn">代办人</th>
				<th>送达时间</th>
				<th>完成时间</th>
				<th>办理状态</th>
				<th>意见</th>
			</tr>
			<c:forEach items="${historyTask}" var="task" varStatus="index">
				<tr>
					<td><div class="form-group" style="text-align:center">${task.name_}</div></td>
					<td><div class="form-group" style="text-align:center">${task.userName_}</div></td>
					<c:choose>
						<c:when
							test="${task.delegateName=='' || task.delegateName==null || task.delegateName==task.userName_}">
							<td class="hidecolumn" style="display:none"><div
									class="form-group" style="text-align:center"></div></td>
						</c:when>
						<c:otherwise>
							<td class="hidecolumn" style="display:none"><div
									class="form-group" style="text-align:center">${task.delegateName}</div></td>
							<script type="text/javascript">
								showtype = true;
							</script>
						</c:otherwise>
					</c:choose>
					<td><div class="form-group" style="text-align:center">${task.startTime_}</div></td>
					<td><div class="form-group" style="text-align:center">${task.endTime_}</div></td>
					<c:if test="${not empty task.state_ }">
						<c:if test="${task.state_ == '0'}">
							<td><div class="form-group" style="text-align:center">已审批</div></td>
						</c:if>
						<c:if test="${task.state_ == '1'}">
							<td><div class="form-group" style="text-align:center">撤回</div></td>
						</c:if>
						<c:if test="${task.state_ == '2'}">
							<td><div class="form-group" style="text-align:center">退回</div></td>
						</c:if>
					</c:if>
					<c:if test="${empty task.state_ }">
						<c:choose>
							<c:when test="${task.endTime_==''}">
								<td><div class="form-group" style="text-align:center">待审批</div></td>
							</c:when>
							<c:otherwise>
								<td><div class="form-group" style="text-align:center">已审批</div></td>
							</c:otherwise>
						</c:choose>
					</c:if>
					<td><div class="form-group"
							style="word-break:break-all;overflow:auto;text-align:center">${task.message_}</div></td>
				</tr>
			</c:forEach>
			<script type="text/javascript">
				if (showtype) {
					$(".hidecolumn").show();
				}
			</script>
		</table>
	</div>
</body>
</html>