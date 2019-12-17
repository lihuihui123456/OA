<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html >
<head>
<base href="<%=basePath%>" />
<link rel="shortcut icon" href="${ctx}/static/cap/plugins/bootstrap/ico/tl-favicon.ico" type="image/x-icon" />
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="Content-Type" content="IE=EmulateIE7">
<meta name="title" content="LayoutIt! - Bootstrap可视化布局系统">
<meta name="description" content="LayoutIt! 可拖放排序在线编辑的Bootstrap可视化布局系统">
<meta name="keywords" content="可视化,布局,系统">
<title>自由表单设计器</title>
<!-- Le styles -->

<link href="${ctx}/views/cap/form/css/bootstrap-combined.min.css"
	rel="stylesheet">
<link href="${ctx}/views/cap/form/css/layoutit.css" rel="stylesheet">
<link href="${ctx}/views/cap/form/select2/dist/css/select2.css"
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
<script type="text/javascript"
	src="${ctx}/views/cap/form/select2/dist/js/select2.js"></script>
<script type="text/javascript" src="${ctx}/views/cap/form/js/change.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
</head>
<body style="min-height: 660px; cursor: auto;" class="edit">
	<div class="navbar  navbar-fixed-top" id="top" style="background-color:#0e5faa">
		<div class=" ">
			<div class="container-fluid" style="box-shadow:0px 0px 10px 2px #666;">
				<button data-target=".nav-collapse" data-toggle="collapse"
					class="btn btn-navbar" type="button">
					<span class="icon-bar"></span> <span class="icon-bar"></span> <span
						class="icon-bar"></span>
				</button>
				<!-- <a class="brand" href="javascript:void(0)	"> -->
				<a class="brand" href="javascript:void(0)	" style="padding: 8px 20px 0px;cursor:default" ><img class="logo" src="${ctx}/static/cap/images/logo2.png" alt="系统管理平台"></img></a>
				<%-- <img
					src="${ctx}/views/cap/form/img/favicon.png">同联iCAP协同应用支撑平台</a> --%>
				<div class="nav-collapse collapse">
					<ul class="nav" id="menu-layoutit" style="margin-right:10px;float:right;">
						<!-- <li class="divider-vertical"></li> -->
						<li style="line-height:55px;">
							<div class="btn-group" data-toggle="buttons-radio">
								<button type="button" id="edit" class="btn btn-primary active">
									<i class="icon-edit icon-white"></i>编辑
								</button>
								<!-- <button type="button" class="btn btn-primary" id="devpreview">
									<i class="icon-eye-close icon-white"></i>布局编辑
								</button> -->
								<button type="button" class="btn btn-primary" id="sourcepreview">
									<i class="icon-eye-open icon-white"></i>预览
								</button>
							<!-- </div>
							<div class="btn-group">
 -->								<button type="button" class="btn btn-primary"
									data-target="#downloadModal" rel="" role="button"
									data-toggle="modal">
									<i class="icon-chevron-down icon-white"></i>源码
								</button>
								<button class="btn btn-primary" href="" id="btnsave"
									role="button" data-toggle="modal" data-target="">
									<i class="icon-share icon-white"></i>保存
								</button>
								<button class="btn btn-primary" href="" id="saveRelease"
									role="button" data-toggle="modal" data-target="">
									<i class="icon-flag icon-white"></i>发布
								</button>
								<button class="btn btn-primary" href="" id="viewFile"
									role="button" data-toggle="modal" data-target="">
									<i class="icon-eye-open icon-white"></i>查看
								</button>
								<button class="btn btn-primary" href="#clear" id="clear">
									<i class="icon-trash icon-white"></i>清空
								</button>
								<button class="btn btn-primary" href="#undo" id="undo">
									<i class="icon-arrow-left icon-white"></i>撤销
								</button>
							</div>
							<!-- <div class="btn-group">
								<button class="btn btn-primary" href="#undo" id="undo">
									<i class="icon-arrow-left icon-white"></i>撤销
								</button>
								<button class="btn btn-primary" href="#redo" id="redo">
									<i class="icon-arrow-right icon-white"></i>重做
								</button> 
							</div>-->
						</li>
					</ul>

				</div>
				<!--/.nav-collapse -->
			</div>
		</div>
	</div>
	<div class="container-fluid" style="box-shadow:0px 0px 10px 2px #666;" id="content">
		<div class="row-fluid">
			<div class="">
				<div class="sidebar-nav">
					<ul class="nav nav-list accordion-group">
						<li class="nav-header">
							<!-- <div class="pull-right popover-info">
								<i class="icon-question-sign "></i>
								<div class="popover fade right">
									<div class="arrow"></div>
									<h3 class="popover-title">功能</h3>
									<div class="popover-content">在这里设置你的栅格布局, 栅格总数默认为12,
										用空格分割每列的栅格值, 如果您需要了解更多信息，请访问</div>
								</div>
							</div>  --><i class="icon-plus icon-white"></i> 布局设置
						</li>
						<li style="display: list-item;" class="rows" id="estRows">
							<div class="lyrow ui-draggable">
								<a href="#close" class="remove label label-important"><i
									class="icon-remove icon-white"></i>删除</a> <span class="drag label "
									style="display:none"><i class="icon-move"></i>拖动</span>
								<div class="preview">
									<input placeholder="输入自定义列" type="text"  style="background-color: white;" class="form-control">
								</div>
								<div class="view">
									<div class="row-fluid clearfix"></div>
								</div>
							</div>
							<div class="lyrow ui-draggable">
								<a href="#close" class="remove label label-important"><i
									class="icon-remove icon-white"></i>删除</a> <span class="drag label"><i
									class="icon-move"></i>拖动</span> <span class="configuration"><button
										type="button" class="btn btn-mini" data-target="#editorModal"
										role="button" data-toggle="modal">编辑</button> </span>
								<div class="preview">表格</div>
								<div class="view">
									<table class="black-border" border="1" cellpadding="1" cellspacing="1"
										style="width:100%;background-color:#ffffff;margin-bottom: 20px;">
										<tr>
											<td class=" column black-border"></td>
										</tr>
									</table>
								</div>
							</div>
							<div class="box box-element ui-draggable">
								<a href="#close" class="remove label label-important"><i
									class="icon-remove icon-white"></i>删除</a> <span class="drag label"><i
									class="icon-move"></i>拖动</span> <span class="configuration"><button
										type="button" class="btn btn-mini" data-target="#editorModal"
										role="button" data-toggle="modal">编辑</button> </span>
								<div class="preview">标签页<input id="tabPageCount" value="1" class="spinner" type="text" style="width:40px;background-color: white;"></div>
								<div class="view">
									<div class="tabbable" id="myTabs">
										<ul class="nav nav-tabs" role="tablist" id="myTabs_ul">  
										</ul>  
											<div class="tab-content" id="mytabs_panel">  
										</div>  
									</div>
								</div>
							</div>
						</li>
					</ul>
					<ul class="nav nav-list accordion-group">
						<li class="nav-header"><i class="icon-plus icon-white"></i> 信息组件</li>
						<li style="display: none;" class="boxes" id="elmBase">
							
						</li>
					</ul>
					<ul class="nav nav-list accordion-group">
						<li class="nav-header"><i class="icon-plus icon-white"></i> 浮动表</li>
						<li style="display: none;" class="boxes">
							<c:forEach items="${list }" var="table">
								<div class="box box-element ui-draggable">
									<a href="#close" class="remove label label-important"><i
										class="icon-remove icon-white"></i>删除</a> <span class="drag label"><i
										class="icon-move"></i>拖动</span> <span class="configuration"><button
											type="button" class="btn btn-mini" data-target="#editorModal"
											role="button" data-toggle="modal">编辑</button> </span>
									<div class="preview">${table.tableName }</div>
									<div class="view">
										<iframe id="${table.id }" name="${table.id }" src="formFloatTableController/getFloatTableData?id=${table.id }&bizid=\${param.bizId}" frameborder="0" width="100%" height="166" frameborder="no" border="0" marginwidth="0" marginheight="0" scrolling="no" allowtransparency="yes"></iframe>
									</div>
								</div>
							</c:forEach>
						</li>
					</ul>
					<ul class="nav nav-list accordion-group">
						<li class="nav-header"><i class="icon-plus icon-white"></i>
							流程组件 <!-- <div class="pull-right popover-info">
								<i class="icon-question-sign "></i>
								<div class="popover fade right">
									<div class="arrow"></div>
									<h3 class="popover-title">帮助</h3>
									<div class="popover-content">提供流程相关组件</div>
								</div>
							</div> --></li>
						<li style="display: none;" class="boxes" id="wfBase">
							<div class="box box-element ui-draggable">
								<a href="#close" class="remove label label-important"><i
									class="icon-remove icon-white"></i>删除</a> <span class="drag label"><i
									class="icon-move"></i>拖动</span> <span class="configuration"><button
										type="button" class="btn btn-mini" data-target="#editorModal"
										role="button" data-toggle="modal">编辑</button> </span>
								<div class="preview">全部意见</div>
								<div class="view">
									<div id="all_comments"
										style="height:100px;width:200px; border:1px solid red;">
										<lable></lable>
									</div>
								</div>
							</div>

						</li>
					</ul>
					<ul class="nav nav-list accordion-group">
						<li class="nav-header"><i class="icon-plus icon-white"></i>
							按钮组件
							<!-- <div class="pull-right popover-info">
								<i class="icon-question-sign "></i>
								<div class="popover fade right">
									<div class="arrow"></div>
									<h3 class="popover-title">帮助</h3>
									<div class="popover-content">提供一组表单常用按钮组件</div>
								</div>
							</div> --></li>
						<li style="display: none;" class="boxes" id="btnBase">
							<div class="box box-element ui-draggable">
								<a href="#close" class="remove label label-important"><i
									class="icon-remove icon-white"></i>删除</a> <span class="drag label"><i
									class="icon-move"></i>拖动</span> <span class="configuration"><button
										type="button" class="btn btn-mini" data-target="#editorModal"
										role="button" data-toggle="modal">编辑</button> </span>
								<div class="preview">删除</div>
								<div class="view">
									<a href="#fakelink" class="btn btn-block btn-lg btn-default"
										onclick="del()">删除</a>
								</div>
							</div>
							<div class="box box-element ui-draggable">
								<a href="#close" class="remove label label-important"><i
									class="icon-remove icon-white"></i>删除</a> <span class="drag label"><i
									class="icon-move"></i>拖动</span> <span class="configuration"><button
										type="button" class="btn btn-mini" data-target="#editorModal"
										role="button" data-toggle="modal">编辑</button> </span>
								<div class="preview">保存</div>
								<div class="view">
									<a href="#fakelink" class="btn btn-block btn-lg btn-default"
										onclick="save()">保存</a>
								</div>
							</div>
							<div class="box box-element ui-draggable">
								<a href="#close" class="remove label label-important"><i
									class="icon-remove icon-white"></i>删除</a> <span class="drag label"><i
									class="icon-move"></i>拖动</span> <span class="configuration"><button
										type="button" class="btn btn-mini" data-target="#editorModal"
										role="button" data-toggle="modal">编辑</button> </span>
								<div class="preview">取消</div>
								<div class="view">
									<a href="#fakelink" class="btn btn-block btn-lg btn-default"
										onclick="cancel()">取消</a>
								</div>
							</div>
							<div class="box box-element ui-draggable">
								<a href="#close" class="remove label label-important"><i
									class="icon-remove icon-white"></i>删除</a> <span class="drag label"><i
									class="icon-move"></i>拖动</span> <span class="configuration"><button
										type="button" class="btn btn-mini" data-target="#editorModal"
										role="button" data-toggle="modal">编辑</button> </span>
								<div class="preview">清空</div>
								<div class="view">
									<a href="#fakelink" class="btn btn-block btn-lg btn-default"
										onclick="clearAll()">清空</a>
								</div>
							</div>
						</li>
					</ul>
				</div>
			</div>
			<div class="col-lg-10" id="con_left">
				<div class="demo ui-sortable"></div>
			</div>
			<!--/span-->
			<div id="download-layout">
				<div class="container-fluid" style="box-shadow:0px 0px 10px 2px #666;padding-bottom: 20px;"></div>
			</div>
		</div>
		<!--/row-->

	</div>

	<!--/.fluid-container-->
	<!-- ckeditor容器 -->
	<div class="modal hide fade" role="dialog" id="editorModal">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>编辑</h3>
		</div>
		<div class="modal-body">
			<p>
				<textarea id="contenteditor"></textarea>
			</p>
		</div>
		<div class="modal-footer">
			<a id="savecontent" class="btn btn-primary" data-dismiss="modal">确定</a>
			<a class="btn" data-dismiss="modal">取消</a>
		</div>
	</div>
	<div class="modal hide fade" role="dialog" id="downloadModal">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>源码</h3>
		</div>
		<div class="modal-body">
			<p>已在下面生成干净的HTML, 可以复制粘贴代码到你的项目.</p>
			<div class="btn-group">
				<button type="button" id="fluidPage" class="active btn btn-info">
					<i class="icon-fullscreen icon-white"></i> 自适应宽度
				</button>
				<button type="button" class="btn btn-info" id="fixedPage">
					<i class="icon-screenshot icon-white"></i> 固定宽度
				</button>
			</div>
			<br> <br>
			<p>
				<textarea></textarea>
			</p>
		</div>
		<div class="modal-footer">
			<a class="btn" data-dismiss="modal">保存</a>
		</div>
	</div>
	<div class="modal hide fade" role="dialog" id="shareModal">
		<div class="modal-header">
			<a class="close" data-dismiss="modal">×</a>
			<h3>保存</h3>
		</div>
		<div class="modal-body">保存成功</div>
		<div class="modal-footer">
			<a class="btn" data-dismiss="modal">Close</a>
		</div>
	</div>
</body>
</html>
