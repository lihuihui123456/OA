<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>事项监控办理详情</title>
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
<style>
.form-group {
	padding: 5px 10px;
	margin-bottom: 0px;
}
</style>
<script type="text/javascript">
	var showtype = false;
	var bizId;
	var state = '${state}';
	var taskId = '${taskId}';
	var procInstId = '${procInstId}';
	var solId = '${solId}';
	$(function() {
		if (state == '4') {
			$("#activitiProcess").css("display", "block");
		} else {
			$("#suspendProcess").css("display", "block");
		}

		//返回按钮事件
		$('#btn_close').click(function() {
			window.parent.parent.closePage(window, true, true, true);
		});
	});
	//流程挂起
	function suspendProcess() {
		if (${bean.state_=='2'}) {
			layerAlert("已办结事项不能挂起");
			return;
		}
		$.ajax({
			type : 'post',
			url : '${ctx}/bpm/doSuspend?procInstId=' + procInstId,
			dataType : 'text',
			async : false,
			success : function(data) {
				if (data == '1') {
					layerAlert("流程挂起成功！");
					$("#suspendProcess").css("display", "none");
					$("#activitiProcess").css("display", "block");
					$("#doState").html("流程挂起");
				} else {
					layerAlert("流程挂起失败！");
				}
			}
		});
	}

	//流程激活
	function activitiProcess() {
		$.ajax({
			type : 'post',
			url : '${ctx}/bpm/doActive?procInstId=' + procInstId,
			dataType : 'text',
			async : false,
			success : function(data) {
				if (data == '1') {
					layerAlert("流程激活成功！");
					$("#activitiProcess").css("display", "none");
					$("#suspendProcess").css("display", "block");
					$("#doState").html("在办");
				} else {
					layerAlert("流程激活失败！");
				}
			}
		});
	}
	//撤销流程
	function showRemovePromodel() {
		if (${bean.state_=='2'}) {
			layerAlert("已办结事项不能撤销");
			return;
		}
		$('#removeProcessmodel').modal('show');
	}

	//撤销流程确定按钮事件
	function rollback() {
		layer.confirm('是否确定撤销流程', {
			btn : [ '是', '否' ]
		}, function() {
			//撤销流程
			$.ajax({
				type : 'post',
				url : '${ctx}/bpm/doUndone',
				dataType : 'text',
				data : {
					procInstId : procInstId,
					deleteReason : $("#deleteReason").val()
				},
				success : function(data) {
					if (data == '1') {
						$('#removeProcessmodel').modal('hide');
						layerAlert("撤销成功");
						window.parent.closePage(window, true, true, true);
					} else {
						layerAlert("撤销失败");
					}
				}
			});
		});
	}

	//打开选择转办人窗口
	function showdelegateModel() {
		var isState = $("#doState").html();
		var ishq = $("input[name='ishq']").val();
		if (ishq == 1) {
			layerAlert("会签节点无法转办");
		} else if (${bean.state_=='2'}) {
			layerAlert("已办结文件无法转办");
		} else if ("流程挂起" == isState) {
			layerAlert("流程挂起文件无法转办");
		} else {
			$('#delegateModel').modal('show');
			//加载人员信息 
			$('#group').attr('src',
					'treeController/zSinglePurposeContacts?state=0');
			//$('#group').attr('src','treeController/zMultiPurposeContacts?state=0');
		}
	}

	//转办确定按钮事件
	function makesurePerson() {
		var arr = document.getElementById("group").contentWindow
				.doSaveSelectUser();
		var userId = arr[0];
		if (!checkUserId(userId)) {
			layerAlert("请重新选择人员");
		} else {
			$.ajax({
				type : 'post',
				url : '${ctx}/bpm/doDelegate',
				dataType : 'text',
				async : true,
				data : {
					'taskId' : taskId,
					'userId' : userId,
					'solId' : solId
				},
				success : function(data) {
					if (data == '1') {
						layerAlert("转办成功");
						$('#delegateModel').modal('hide');
					} else {
						layerAlert("转办失败");
					}
				}
			});
		}
	}

	//检查选择的人员是否为一个
	function checkUserId(userId) {
		var flag = false
		var userIds = userId.split(",");
		if (userIds != null && userIds.length == 1) {
			flag = true;
		}
		return flag;
	}
</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="panel-body"
		style="padding-bottom: 30px; border: 0; padding-left:20px; padding-right:30px;margin-bottom:10px\9;">
		<div id="toolbar" class="btn-group">
			<button id="rollback_btn" class="btn btn-default btn-sm"
				onclick="showRemovePromodel()">
				<span class="fa fa-times" aria-hidden="true"></span>撤销流程
			</button>
			<button class="btn btn-default btn-sm" id="suspendProcess"
				onclick="suspendProcess()" style="display:none">
				<i class="fa fa-ban"></i>&nbsp;挂起流程
			</button>
			<button class="btn btn-default btn-sm" id="activitiProcess"
				onclick="activitiProcess()" style="display:none">
				<i class="fa fa-key"></i>&nbsp;激活流程
			</button>
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
						<td width="35%"><div id="" class="form-group">
								<span id="doState">待发</span>
							</div></td>
					</c:when>
					<c:when test="${bean.state_=='1'}">
						<td width="35%"><div id="" class="form-group">
								<span id="doState">在办</span>
							</div></td>
					</c:when>
					<c:when test="${bean.state_=='2'}">
						<td width="35%"><div id="" class="form-group">
								<span id="doState">办结</span>
							</div></td>
					</c:when>
					<c:when test="${bean.state_=='3'}">
						<td width="35%"><div id="" class="form-group">
								<span id="doState">流程撤销</span>
							</div></td>
					</c:when>
					<c:when test="${bean.state_=='4'}">
						<td width="35%"><div id="" class="form-group">
								<span id="doState">流程挂起</span>
							</div></td>
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
		<div id="toolbar" class="btn-group">
			<button id="taskdelegate" class="btn btn-default btn-sm"
				onclick="showdelegateModel()">
				<span class="fa fa-mail-forward" aria-hidden="true"></span>转办
			</button>
		</div>
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
					<td><div style="word-break:break-all;text-align:center">${task.message_}</div></td>
				</tr>
			</c:forEach>
			<script type="text/javascript">
				if (showtype) {
					$(".hidecolumn").show();
				}
			</script>
		</table>
	</div>
	<!-- 撤销流程  模态框 -->
	<div class="modal fade" id="removeProcessmodel" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title">撤销原因</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<textarea class="form-control" id="deleteReason"
						name="deleteReason" rows="6"></textarea>
				</div>
				<div class="modal-footer" style="text-align:center;">
					<button type="button" class="btn btn-primary" onclick="rollback()">保存</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 事项监控—转办选择人员  -->
	<div class="modal fade" id="delegateModel" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">选择人员</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="group" runat="server" src="" width="100%" height="350"
							frameborder="no" border="0" marginwidth="0" marginheight="0"
							scrolling="auto" allowtransparency="yes"></iframe>
					</div>
					<div class="modal-footer" style="text-align:center;">
						<button type="button" class="btn btn-primary"
							onclick="makesurePerson()">确定</button>
						<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>