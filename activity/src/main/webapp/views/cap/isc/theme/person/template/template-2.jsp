<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
		<title>首页配置模板二</title>
		<%@ include file="/views/aco/common/head.jsp"%>
		<link href="${ctx}/static/aco/images/favicon.ico" rel="SHORTCUT ICON" />
		<link href="${ctx}/static/aco/images/favicon.ico" rel="BOOKMARK" />
		<link href="${ctx}/views/cap/isc/theme/person/css/template.css" rel="stylesheet">
		<%@ include file="/views/cap/common/theme.jsp"%>
	</head>
	<body style="overflow-x:hidden;overflow-y:auto;">
		<!-- 左侧系统功能树 -->
		<div class="container-fluid">
			<div class="template_title">
				<label>3个模块布局：</label>
				<a href="javascript:;" class="btn btn-danger pull-right">应用</a>
			</div>
			<div class="template_menu">
				<h5>
					<i class="fa fa-th-large"></i>模版菜单
					<i class=" icon fa fa-angle-down"></i>
				</h5>
				<ul>
					<li>
						<img src="${ctx}/static/aco/images/template_eg/todo.png" class="li-img"><span>待办事项</span>
					</li>
					<li>
						<img src="${ctx}/static/aco/images/template_eg/calendar.png" class="li-img"><span>日程管理</span>
					</li>
					<li>
						<img src="${ctx}/static/aco/images/template_eg/notice.png" class="li-img"><span>通知公告</span>
					</li>
					<li>
						<img src="${ctx}/static/aco/images/template_eg/trace.png" class="li-img"><span>跟踪事项</span>
					</li>
				</ul>
				<h5>
					<i class="fa fa-th-large"></i>集成系统
					<i class="icon fa fa-angle-right"></i>
				</h5>
				<ul>
					<li>暂无内容！</li>
				</ul>
			</div>

			<!-- 右侧面板 -->
			<div class="template_con" style="width: 100%;">
				<div class="row">
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 template">
						<div class="panel"></div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 template">
						<div class="panel"></div>
					</div>
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 template">
						<div class="panel"></div>
					</div>
				</div>
			</div>
		</div>
	</body>

	<!-- 引入JS文件 -->
	<script src="${ctx}/views/cap/isc/theme/person/js/jquery-ui.min.js"></script>
	<script src="${ctx}/views/cap/isc/theme/person/js/template.js"></script>
</html>