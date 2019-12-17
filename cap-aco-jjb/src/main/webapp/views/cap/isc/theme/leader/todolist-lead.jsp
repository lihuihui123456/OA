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
				<li id="tasks" role="presentation" class="active">
					<a href="#tasks" aria-controls="tasks" role="tab" data-toggle="tab"
					 	onclick="getToDoTasks('total')"><b>待办事项(<span id="totalcount"></span>条)</b></a>
			 	</li>
				<li role="presentation">
					<a href="#reads" aria-controls="reads" role="tab" data-toggle="tab"
						onclick="getToDoTasks('read')"><b>待阅文件(<span id="daiyuecount"></span>)</b></a>
				</li>
			</ul>
			<div class="tab-content">
				<div class="tab-pane active">
					<table class="table table-hover table_td">
						<thead>
							<tr>
								<th style='width:4%;'>
									<input id='checkAll' name='checkAll' type='checkbox' onclick="checkAll(this);">
								</th>
								<th style='width:49%;'>标题</th>
								<th style='width:13%;text-align:center;'>拟稿人</th>
								<th style='width:24%;text-align:center;' class='time'>送办时间</th>
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
function getPageSize() {
	var H = $("#todo_iframe", window.parent.document).height();
	var liCounts = Math.floor(H / 42) - 1;
	return liCounts;
}

//初始化页面数据
function init(){
	//打开个人桌面时初始化数据展示
	getToDoTasks("total");
	//查询待办数量
	getToDoTasksNums();
	
	var $li = $('#tasks');
	if( !$li.hasClass("active")) {
		$li.addClass('active').siblings().removeClass("active");
	}
}

/**
 * 加载待办/待阅数据
 */
function getToDoTasks(tasktype) {
	$("#todoArea").html("");
	var url = "${ctx}/leadDeskTopQueryController/getLeaderToDos";
	var params = {
		"pageSize" : getPageSize(),
		"taskType" : tasktype
	};
	$.post(url, params, function(data) {
		if(null != data) {
			if(data.flag == "1") {
				var json = data.result;
				var taskValue = "";
				var title;
				var url;
				$.each(json, function(index, obj) {
					if(obj.title != null && obj.title.length > 28) {
						title = obj.title.substring(0,27)+"....";
					}else {
						title = obj.title;
					}
					if(tasktype == 'total'){
						url = "/bizRunController/getBizOperate?status=3&solId=" + obj.solId + "&taskId=" + obj.taskid+ "&bizId="+ obj.bizid;
						taskValue = taskValue + "<tr><td style='width:4%;overflow:visible;'><input id='"+obj.bizid+"' name='deal' type='checkbox' onclick='checkOne(this);'/></td>"
								+"<td style='width:66%;' title="+obj.title+" onclick='opentab(\"" + obj.title + "\",\"" + obj.bizid + "\",\"" + url + "\")\'>";
					}else{
						url = "/bpmCirculate/findCirculate?bizid="+obj.bizid+"&id="+obj.taskid+"&solId="+ obj.solId;
						taskValue = taskValue + "<tr><td style='width:4%;overflow:visible;'><input id='"+obj.bizid+"' name='deal' type='checkbox' onclick='checkOne(this);'/></td>"
								+"<td style='width:66%;' title="+obj.title+" onclick='opentab(\"" + obj.title + "\",\"" + obj.bizid + "\",\"" + url + "\")\'>";
					}
					if (index == 0) {// 红色处理
						taskValue = taskValue +"<span style='margin-left:0px;' class='count red'>" + (index + 1) + "</span>"+ title +"</td>";
					} else if (index == 1) {// 绿色处理
						taskValue = taskValue +"<span style='margin-left:0px;' class='count green'>" + (index + 1) + "</span>"+ title +"</td>";
					} else if (index == 2) {// 蓝色处理
						taskValue = taskValue +"<span style='margin-left:0px;' class='count blue'>" + (index + 1) + "</span>"+ title +"</td>";
					} else {// 默认的灰色
						taskValue = taskValue +"<span style='margin-left:0px;' class='count'>" + (index + 1) + "</span>"+ title +"</td>";
					}
					taskValue = taskValue + "<td style='width:10%;text-align:center;'>" + obj.creator + "</td>"
						+ "<td width='10%' class='time'>" +formatTime(obj.endtime)+ "</td>"
						+ "<td style='width:10%;text-align:center;'>"
						+ "<a style='color:#167495;' href='javascript:void(0)' title='办理详情' onclick='blxq(\"" + obj.bizid + "\")'><i class='fa fa-list-ul'></i> "
						+ "<a style='color:#167495;' href='javascript:void(0)' title='查看流程图' onclick='cklct(\"" + obj.bizid + "\")'><i class='fa fa-sitemap'></i>"
						+ "</td></tr>";
				});
				$("#todoArea").html(taskValue);
			}
		}
	}, "json");
}

//格式化时间
function formatTime(time) {
	if (time != null && time != '') {
		var oldTime = (new Date(time.replace(/-/g, "/"))).getTime();
		var curTime = new Date(oldTime).format("yyyy-MM-dd hh:mm:ss");
		return curTime;
	} else {
		return time;
	}
}
Date.prototype.format = function (fmt) {
	var o = {
		"M+": this.getMonth() + 1, //月份
		"d+": this.getDate(), //日
		"h+": this.getHours(), //小时
		"m+": this.getMinutes(), //分
		"s+": this.getSeconds(), //秒
		"q+": Math.floor((this.getMonth() + 3) / 3), //季度
		"S": this.getMilliseconds() //毫秒
	};
	if (/(y+)/.test(fmt)) {
		fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
	}
	for (var k in o) {
		if (new RegExp("(" + k + ")").test(fmt)) {
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
		}
	}
	return fmt;
}

//获取待办、待阅条目数
function getToDoTasksNums() {
	var url = "${ctx}/leadDeskTopQueryController/getLeaderToDosNum";
	var params;
	$.post(url, params, function(data) {
		if(null != data) {
			if(data.flag == '1') {
				var json = data.result;
				var dbsl = 0;//待办数量
				var jjsl = 0;//急件数量
				var qtsl = 0;//其他
				var yjsl = 0;//阅件数量
				$.each(json, function(index, obj) {
					if(obj.tasktype=='2' || obj.tasktype=='3') {
						//急件数量
						jjsl = parseInt(jjsl) + parseInt(obj.nums);
					}else if(obj.tasktype=='read'){
						//阅件数量
						yjsl = parseInt(yjsl) + parseInt(obj.nums);
					}else{
						//其他
						qtsl = parseInt(qtsl) + parseInt(obj.nums);
					}
				});
				dbsl = parseInt(jjsl) + parseInt(qtsl);
				$("#daiyuecount").html(yjsl);//设置待阅数量
				$("#totalcount").html(dbsl);//设置待办总数量
			}
		}
	}, "json");
}


//刷新操作
function refresh() {
	$("#checkAll").attr("checked", false);
	init();
}

$(function () {
	//首次加载
	init();
	//定时加载
	setInterval(init, 60000);
	$("#todoPanel").height($("#todo_iframe", window.parent.document).height() - 2);
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

//一键审阅提交事件
function submitForOnce() {
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

//查看流程图
function cklct(bizId) {
	var options = {
		"text": "查看流程图",
		"id": "cklct" + bizId,
		"href": "${ctx}/bpmRuBizInfoController/toFlowChart?bizid=" + bizId,
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

// 一键审阅
function openForOnce() {
	var count = 0;
	var datas = "";
	var name = "";
	$('#todoArea TD input').each(function () {
		if (this.checked) {
			var id = this.id;
			name = this.name;
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
		} else if (name == 'read') {
			$.ajax({
				url: "${ctx}/leaddtpflow/findCirculate",
				type: 'post',
				dataType: 'json',
				data: {
					ids: datas
				},
				success: function (data) {
					getToDoTasks("read");
				}
			});
		} else {
			return;
		}
	}
}
</script>
</html>