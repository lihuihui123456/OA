<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>领导桌面待办列表</title>		
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/views/cap/isc/theme/common/css/pages.css" rel="stylesheet">
<link href="${ctx}/views/cap/isc/theme/common/css/skin-red.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/skin/layer.css" rel="stylesheet">
<style type="text/css">
body {
	background-color: #FFF;
}

.panel-other {
	border: 1px solid transparent;
}

.todo_tabs {
	position: absolute;
	top: 7px;
	left: 50px;
}

.refresh {
	position: absolute;
	top: 2px;
	right: 160px;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="panel panel-other" id="todoPanel">
		<!-- 按钮栏 -->
		<div class="panel-heading">
			<h2>
				<i class="iconfont icon-daibanshixiang" style="top:5px"></i>
			</h2>
			<div class="refresh">
				<a href="javascript:void(0);" class="fa fa-refresh" onclick="refresh()"></a>
			</div>
			<div class=" more more1">
				<a href="javascript:void(0);" onclick="openForOnce()">一键审阅</a>
			</div>
			<div class="more">
				<a  href="javascript:void(0);" onclick="opentab('待办事项','8a816d115691473c0156920bfaf90001','/bpmQuery/toTaskTodoList');">MORE</a>
			</div>
		</div>
		<div class="panel-body" style="padding:0;">
			<ul class="nav nav-tabs small_tabs todo_tabs" role="tablist">
				<li role="presentation" class="active">
					<a href="#urgent" aria-controls="urgent" role="tab" data-toggle="tab"
					 	onclick="deskprocesstask('total')"><b>待办事项(<spanid="totalcount"></span>条)</b></a>
			 	</li>
				<li role="presentation">
					<a href="#urgent" aria-controls="urgent" role="tab" data-toggle="tab"
						onclick="desktask('daiyue')"><b>待阅文件(<span id="daiyuecount"></span>)</b></a>
				</li>
			</ul>
			<div class="tab-content">
				<div class="tab-pane active">
					<table class="table table-hover table_td">
						<thead>
							<tr>
								<th style='width:4%;'><input id='checkAll' name='checkAll'
									type='checkbox' onclick="checkAll(this);"></th>
								<th style='width:63%;'>标题</th>
								<th style='width:10%;text-align:center;'>拟稿人</th>
								<!-- <th width='15%' class='time'>送交时间</th> -->
								<th style='width:10%;text-align:center;'>操作</th>
							</tr>
						</thead>
						<tbody id="todoArea">

						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
<script type="text/javascript">
//获取查询条目数
var H = $("#todo_iframe", window.parent.document).height();
var liCounts = Math.floor(H / 42) - 1;
//页签类型
var refreshType = "";

//setInterval与ajax结合,异步刷新不闪烁
function intervalLoadData() {
	var num = liCounts;
	$.ajax({
		url: '${ctx}/deskQuery/findLeadDeskListTask?num=' + num,
		type: 'post',
		dataType: 'json',
		data: {
			tasktype: 'urgent'
		},
		success: function (data) {
			$("#todoArea").html(data.result);
			/*				$("#urgentcount").html(data.urgentcount);
			$("#flatcount").html(data.flatcount); */
			/*				$("#circularscount").html(data.circularscount); */
			$("#totalcount").html(data.lstcount);
			$("#daiyuecount").html(data.readcount);
			/* $("#hasdonecount").html(data.hasdonecount); */
		}
	});
}

//加载待办事项
function deskprocesstask(tasktype) {
	refreshType = tasktype;
	$("#todoArea").html("");
	var num = liCounts;
	$.ajax({
		url: '${ctx}/deskQuery/findLeadDeskListTask?num=' + num,
		type: 'post',
		dataType: 'json',
		data: {
			tasktype: tasktype
		},
		success: function (data) {
			$("#todoArea").html(data.result);
			$("#totalcount").html(data.lstcount);
		}
	});
}

//加载待阅事项
function desktask(tasktype) {
	refreshType = tasktype;
	$("#todoArea").html("");
	var num = liCounts;
	$.ajax({
		url: '${ctx}/deskQuery/findLeadDeskTask?num=' + num,
		type: 'post',
		dataType: 'json',
		data: {
			tasktype: tasktype
		},
		success: function (data) {
			$("#todoArea").html(data.result);
			$("#daiyuecount").html(data.lstcount);
		}
	});
}

//刷新操作
function refresh() {
	if (refreshType == "total") {
		deskprocesstask(refreshType);
	} else if (refreshType == "daiyue") {
		desktask(refreshType);
	} else {
		intervalLoadData();
	}
}

$(function () {
	//首次加载
	intervalLoadData();
	//定时加载
	setInterval(intervalLoadData, 60000);

	var H = $("#todo_iframe", window.parent.document).height();
	$("#todoPanel").height(H - 2);

	$("#dropdownMenu1")
	.click(
		function () {
		$("#myFrame").show();
		$("#myFrame").html("");
		$
		.ajax({
			url: '${ctx}/leaddtp/findAllComment',
			type: 'post',
			dataType: 'json',
			success: function (data) {
				$
				.each(
					data,
					function (index,
						value) {
					$("#myFrame")
					.append(
						"<li role=\"presentation\"><a onclick=\"evaluation('"
						 + value.leaderComment
						 + "')\" role=\"menuitem\" tabindex=\"-1\" >"
						 + value.leaderComment
						 + "</a></li>")
				});
			}
		});
	});
	$("#dropdownMenu1").blur(function () {
		$("#myFrame").hide("slow");
	});
});

// 全选
function checkAll(target) {
	if (target.checked) {
		$("input[name=daiyue]").attr("checked", true);
		$("input[name=deal]").attr("checked", true);
	} else {
		$("input[name=daiyue]").attr("checked", false);
		$("input[name=deal]").attr("checked", false);
	}
}

// 勾选是判断是否全选
function checkOne(target) {
	var name = target.name;
	if ($("input[name=" + name + "]").length == $("input[name=" + name
			 + "]:checked").length) {
		$("#checkAll").attr("checked", true);
	} else {
		$("#checkAll").attr("checked", false);
	}
}

var com;
function evaluation(data) {
	var dropdownMenu1 = $("#dropdownMenu1").val(data);
}

function submitForOnce() {
	/* var dropdownMenu1 = $("#dropdownMenu1").val();
	if("" == dropdownMenu1||dropdownMenu1 ==null){
	layerAlert("处理意见为空");
	return;
	} */
	var count = 0;
	var datas = "";
	$('#todoArea TD input').each(function () {
		if ($(this).attr('checked') == "checked") {
			var id = $(this).attr("id");
			if (count == 0) {
				datas += id;
			} else {
				datas += "," + id;
			}
			count++;
		}
	});
	if (count == 0) {
		layerAlert("请选择一条数据");
		return;
	} else {
		$.ajax({
			url: '${ctx}/leaddtpflow/reviewForOnce',
			type: 'post',
			dataType: 'json',
			data: {
				"ids": datas
			},
			success: function (data) {
				alert("处理成功！");
			}
		});
	}

}

//办理详情
function blxq(bizId) {
	var options = {
		"text": "办理详情",
		"id": "ldzm" + bizId,
		"href": "${ctx}/bpmRuBizInfoController/toDealDetialPage?bizId="
		 + bizId,
	};
	window.parent.parent.createTab(options);
}

//打开新页签
function opentab(title, id, url) {
	var params = {
		"id": id,
		"href": '${ctx}' + url,
		"text": title
	};
	window.parent.parent.createTab(params);
}

// 意见审阅
function openForOnce() {
	var count = 0;
	var datas = "";
	var name = "";
	$('#todoArea TD input').each(function () {
		if ($(this).attr('checked') == "checked") {
			var id = $(this).attr("id");
			name = $(this).attr("name");
			if (count == 0) {
				datas += id;
			} else {
				datas += "," + id;
			}
			count++;
		}
	});
	if (count == 0) {
		layerAlert("请选择数据！");
		return;
	} else {
		if (name == 'deal') {
			window.parent.openForOnce("${ctx}/leaddtpflow/openForOnce?ids="
				 + datas);
		} else if (name == 'daiyue') {
			$.ajax({
				url: "${ctx}/leaddtpflow/findCirculate",
				type: 'post',
				dataType: 'json',
				data: {
					ids: datas
				},
				success: function (data) {
					desktask('daiyue');
				}
			});
		} else {
			return;
		}
	}
}
</script>
</html>