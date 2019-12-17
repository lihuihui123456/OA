<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>首页配置模板一</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/static/aco/images/favicon.ico" rel="SHORTCUT ICON" />
<link href="${ctx}/static/aco/images/favicon.ico" rel="BOOKMARK" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/views/cap/isc/theme/person/css/template.css" rel="stylesheet">
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="overflow-x:hidden;overflow-y:auto;background-color:transparent">
	<div class="modal-content">
		<div class="modal-header">
			<button type="button" class="close" onclick="window.parent.close();"
				aria-hidden="true">&times;</button>
			<h4 class="modal-title">模版选择</h4>
		</div>
		<div class="modal-body">
			<div class="row">
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 ">
					<div class="template_eg">
						<a href="javascript:;"> <input name="template_choose"
							type="radio" value="1"> <span>3个模块布局</span> <img
							src="${ctx}/views/cap/isc/theme/person/images/eg_3.png"> </a>
					</div>
				</div>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 ">
					<div class="template_eg">
						<a href="javascript:;"> <input name="template_choose"
							type="radio" value="2"> <span>3个模块布局</span> <img
							src="${ctx}/views/cap/isc/theme/person/images/eg_3.2.png"> </a>
					</div>
				</div>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 ">
					<div class="template_eg">
						<a href="javascript:;"> <input name="template_choose"
							type="radio" value="3"> <span>4个模块布局</span> <img
							src="${ctx}/views/cap/isc/theme/person/images/eg_4.png"> </a>
					</div>
				</div>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 ">
					<div class="template_eg">
						<a href="javascript:;"> <input name="template_choose"
							type="radio" value="4" disabled> <span>5个模块布局</span> <img
							src="${ctx}/views/cap/isc/theme/person/images/eg_5.png"> </a>
					</div>
				</div>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 ">
					<div class="template_eg">
						<a href="javascript:;"> <input name="template_choose"
							type="radio" value="5" disabled> <span>5个模块布局</span> <img
							src="${ctx}/views/cap/isc/theme/person/images/eg_5.2.png"> </a>
					</div>
				</div>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 ">
					<div class="template_eg">
						<a href="javascript:;"> <input name="template_choose"
							type="radio" value="6" disabled> <span>6个模块布局</span> <img
							src="${ctx}/views/cap/isc/theme/person/images/eg_6.png"> </a>
					</div>
				</div>
			</div>
		</div>
		<div align="center" style="margin-bottom: 10px;margin-top:-40px;">
			<button class="btn btn-primary" onclick="saveTemplate()">选择</button>
			<button class="btn btn-primary" onclick="window.parent.close();">关闭</button>
		</div>
	</div>
	<!-- /.modal-content -->

</body>

<!-- 引入JS文件 -->
<script src="${ctx}/views/cap/isc/theme/person/js/jquery-ui.min.js"></script>
<script src="${ctx}/views/cap/isc/theme/person/js/template.js"></script>
<script type="text/javascript">
	function saveTemplate() {
		var num = $('input[name="template_choose"]:checked').val();
		var options = {
			"text" : "模版",
			"id" : "moban",
			"href" : "${ctx}/views/aco/home/template/template-" + num
					+ ".jsp",
			"pid" : window
		};
		window.parent.createTab(options);
		
		window.parent.close();
	}
</script>
</html>