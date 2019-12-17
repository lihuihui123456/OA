<%@ page contentType="text/html;charset=UTF-8"%><%@ include
	file="/views/cap/common/taglibs.jsp"%><!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="title" content="LayoutIt! - Bootstrap???????">
<meta name="description" content="LayoutIt! ??????????Bootstrap???????">
<meta name="keywords" content="???,??,??">
<title>IUAP???????</title>
<link href="${ctx}/views/cap/form/css/bootstrap-combined.min.css"
	rel="stylesheet">
<link href="${ctx}/views/cap/form/css/layoutit.css" rel="stylesheet">
<link href="${ctx}/views/cap/form/select2/dist/css/select2.css"
	rel="stylesheet">
<link href="${ctx}/views/cap/form/colpick/css/colpick.css"
	rel="stylesheet">
<link rel="shortcut icon" href="${ctx}/views/cap/form/img/favicon.png">
<script type="text/javascript"
	src="${ctx}/views/cap/form/js/jquery-2.0.0.min.js"></script>
<script type="text/javascript"
	src="${ctx}/views/cap/form/js/bootstrap.min.js"></script>
<script type="text/javascript"
	src="${ctx}/views/cap/form/js/jquery-ui.js"></script>
<script type="text/javascript"
	src="${ctx}/views/cap/form/js/jquery.ui.touch-punch.min.js"></script>
<script type="text/javascript"
	src="${ctx}/views/cap/form/js/jquery.htmlClean.js"></script>
<script type="text/javascript"
	src="${ctx}/views/cap/form/ckeditor/ckeditor.js"></script>
<script type="text/javascript"
	src="${ctx}/views/cap/form/ckeditor/config.js"></script>
<script type="text/javascript" src="${ctx}/views/cap/form/js/scripts.js"></script>
<script type="text/javascript" src="${ctx}/views/cap/form/js/form.js"></script>
<script type="text/javascript"
	src="${ctx}/views/cap/form/select2/dist/js/select2.js"></script>
<script type="text/javascript"
	src="${ctx}/views/cap/form/colpick/js/colpick.js"></script>
<script type="text/javascript" src="${ctx}/views/cap/form/js/change.js"></script>
<script type="text/javascript" src="${ctx}/views/cap/form/js/method.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
</head>
<body style="min-height: 660px; cursor: auto;"
	class="devpreview sourcepreview">

	<div class="container-fluid">
		<div class="demo ui-sortable" style="min-height: 507px;">
			<div class="lyrow ui-draggable" style="display: block;">


				<div class="view">
					<div class="row-fluid clearfix">
						<div class="span12 column ui-sortable"
							onresize="resizeHeight(this)">
							<div class="box box-element ui-draggable" style="display: block;">


								<div class="view">
									<h1 style="text-align: center;">
										<span style="color:#ff0000">文件报批单</span>
									</h1>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="lyrow ui-draggable" style="display: block;">


				<div class="view">
					<div class="row-fluid clearfix">
						<div class="span4 column ui-sortable">
							<div class="box box-element ui-draggable" style="display: block;">


								<div class="view">
									<p style="text-align: center;">
										<span style="color:#ff0000">申请人</span>
									</p>
								</div>
							</div>
						</div>
						<div class="span8 column ui-sortable">
							<div class="box box-element ui-draggable" style="display: block;">
								<div class="view">
									<input type="text" id="user_name" name="用户名"
										class="validate[required] form-control" placeholder=""
										maxlength="10" onclick="buttonEvents(this)">
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="lyrow ui-draggable" style="display: block;">


				<div class="view">
					<div class="row-fluid clearfix">
						<div class="span4 column ui-sortable">
							<div class="box box-element ui-draggable" style="display: block;">
								<div class="view">
									<p style="text-align: center;">
										<span style="color:#ff0000">审批时间</span>
									</p>
								</div>
							</div>
						</div>
						<div class="span8 column ui-sortable">
							<div class="box box-element ui-draggable" style="display: block;">
								<div class="view">
									<input width="100%" type="text" id="reg_time" name="创建日期"
										class="validate[required] form-control" enable="false"
										onclick="laydate({istime: true, format:'YYYY-MM-DD'})">
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>

	</div>

</body>
</html>