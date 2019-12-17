<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="cn">
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=11;IE=10;IE=9;IE=8;IE=EDGE">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <link rel="shortcut icon" href="${ctx}/static/cap/plugins/bootstrap/ico/${APP_LOGO_NAME}.ico" type="image/x-icon" />
    <meta name="language" content="en" />
    <script type="text/javascript">var NREUMQ = NREUMQ || []; NREUMQ.push(["mark", "firstbyte", new Date().getTime()]);</script>
    <title>桌面可视化布局</title>
    <link href="${ctx}/views/cap/isc/theme/person/layout/css/bootstrap.min.css" rel="stylesheet">
    <link href="${ctx}/views/cap/isc/theme/person/layout/css/layoutit.css" rel="stylesheet">
    <link href="${ctx}/views/cap/isc/theme/person/layout/css/default.css" rel="stylesheet">
    <link href="${ctx}/views/cap/isc/theme/person/layout/css/base.css" rel="stylesheet">
    <link href="${ctx}/views/cap/isc/theme/person/layout/css/list.css" rel="stylesheet">
    <link href="${ctx}/views/cap/isc/theme/person/layout/css/content.css" rel="stylesheet">
	<link href="${ctx}/static/cap/font-awesome/css/font-awesome.css" rel="stylesheet" />
	<link href="${ctx}/static/cap/font/iconfont.css" rel="stylesheet" />
    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if IE]>
	<script src="${ctx}/static/cap/plugins/bootstrap/js/html5shiv.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/js/respond.min.js"></script>
	<![endif]-->
    <script type="text/javascript" src="${ctx}/views/cap/isc/theme/person/layout/js/jquery.min.js"></script>
    <script type="text/javascript" src="${ctx}/views/cap/isc/theme/person/layout/js/jquery-ui.js"></script>
    <script type="text/javascript" src="${ctx}/views/cap/isc/theme/person/layout/js/jquery.ui.touch-punch.js"></script>
    <script type="text/javascript" src="${ctx}/views/cap/isc/theme/person/layout/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="${ctx}/views/cap/isc/theme/person/layout/js/jquery.htmlClean.js"></script>
    <script type="text/javascript" src="${ctx}/views/cap/isc/theme/person/layout/js/scripts.js"></script>
    <script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer_utils.js"></script>
    <%@ include file="/views/cap/common/theme.jsp"%>
    <script type="text/javascript">
    	var ctx = '${ctx}';
    </script>
</head>
<body class="edit">
	    <div class="navbar navbar-inverse navbar-fixed-top navbar-layoutit">
			<ul class="nav layout-btn" id="menu-layoutit">
				<li>
                 <a class="navbar-brand" title="个人桌面布局" onclick="javascript:void(0);"  style="height:100%;"><h1>桌面可视化布局</h1></a>
            	</li>
			</ul>
            <ul class="nav layout-btn" id="menu-layoutit">
                
                <li>
                        <button type="button" id="edit" class="active btn btn-sm btn-default"><i class="fa fa-edit "></i> 编辑</button>
                        <button type="button" class="btn btn-sm btn-default" id="sourcepreview"><i class="fa fa-eye"></i> 预览</button>
                    
                        <button class="btn btn-sm btn-default" id="button-share-modal" onclick="saveConfirm()" role="button" data-toggle="modal"><i class="fa fa-save"></i> 保存</button>
                        <button class="btn btn-sm btn-default" href="#clear" id="clear"><i class="fa fa-trash"></i> 清空</button>
                        <button class="btn btn-sm btn-default" id="doReturn" onclick="doReturn()"><i class="fa fa-history"></i> 返回</button>
                    
                </li>
            </ul>
       
    </div>
	<div class="container container-top" style="width:auto;">
			<div class="row">
				<div class="">
					<div class="sidebar-nav">
						<ul class="nav nav-list accordion-group">
							<li class="nav-header"><i class="fa fa-plus"></i> 布局设置
								<div class="pull-right popover-info">
									<i class="fa fa-question-circle"></i>
									<div class="popover fade right">
										<div class="arrow"></div>
										<h3 class="popover-title">提示：</h3>
										<div class="popover-content">在这里设置网页的布局,
											包含多种排版形式，可任意组合多种不同的排版布局风格。</div>
									</div>
								</div></li>
							<li class="rows" id="estRows">
								<!-- 一行一列 -->
								<div class="lyrow">
									<a rel="nofollow" href="#close"
										class="remove label label-danger"><i class="fa fa-remove"></i>
										删除</a> <span class="drag label label-default"><i
										class="fa fa-arrows"></i> 拖动</span>
									<div class="preview">
										<!-- <i class="iconfont icon-buju-1-1"></i> -->
										<input type="text" value="一行一列" class="form-control">
									</div>
									<div class="view">
										<div class="row clearfix">
											<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 column"></div>
										</div>
									</div>
								</div> <!-- 一行两列 -->
								<div class="lyrow">
									<a rel="nofollow" href="#close"
										class="remove label label-danger"><i class="fa fa-remove"></i>
										删除</a> <span class="drag label label-default"><i
										class="fa fa-arrows"></i> 拖动</span>
									<div class="preview">
										<!-- <i class="iconfont icon-buju-1-2"></i> -->
										<input type="text" value="一行两列" class="form-control">
									</div>
									<div class="view">
										<div class="row clearfix">
											<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 column"></div>
											<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 column"></div>
										</div>
									</div>
								</div> <!-- 田字布局 -->
								<div class="lyrow">
									<a rel="nofollow" href="#close"
										class="remove label label-danger"><i class="fa fa-remove"></i>
										删除</a> <span class="drag label label-default"><i
										class="fa fa-arrows"></i> 拖动</span>
									<div class="preview">
										<!-- <i class="iconfont icon-buju-1-2"></i> -->
										<input type="text" value="田字布局" class="form-control">
									</div>
									<div class="view">
										<div class="row clearfix">
											<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 column"></div>
											<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 column"></div>
										</div>
										<div class="row clearfix">
											<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 column"></div>
											<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 column"></div>
										</div>
									</div>
								</div> <!-- 品字布局 -->
								<div class="lyrow">
									<a rel="nofollow" href="#close"
										class="remove label label-danger"><i class="fa fa-remove"></i>
										删除</a> <span class="drag label label-default"><i
										class="fa fa-arrows"></i> 拖动</span>
									<div class="preview">
										<!-- <i class="iconfont icon-buju-1-2"></i> -->
										<input type="text" value="品字布局" class="form-control">
									</div>
									<div class="view">
										<div class="row clearfix">
											<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 column"></div>
										</div>
										<div class="row clearfix">
											<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 column"></div>
											<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 column"></div>
										</div>
									</div>
								</div> <!-- <div class="lyrow">
                                <a  rel="nofollow" href="#close" class="remove label label-danger"><i class="fa fa-remove"></i> 删除</a>
                                <span class="drag label label-default"><i class="fa fa-arrows"></i> 拖动</span>
                                <div class="preview">
                                	<i class="iconfont icon-buju-1-3"></i>
                                	<input type="text" value="一行三列" class="form-control">
                                </div>
                                <div class="view">
                                    <div class="row clearfix">
                                        <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12 column"></div>
                                        <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12 column"></div>
                                        <div class="col-lg-4 col-md-4 col-sm-12 col-xs-12 column"></div>
                                    </div>
                                </div>
                            </div> -->
							</li>
						</ul>
						<ul class="nav nav-list accordion-group">
							<li class="nav-header"><i class="fa fa-plus"></i> 栏目设置
								<div class="pull-right popover-info">
									<i class="fa fa-question-circle"></i>
									<div class="popover fade right">
										<div class="arrow"></div>
										<h3 class="popover-title">提示：</h3>
										<div class="popover-content">这里提供了一系列基本功能，可任意组合搭配出您喜欢的栏目。</div>
									</div>
								</div></li>
							<li class="boxes" id="elmBase" style="display:block">
								<div class="box box-element">
									<a rel="nofollow" href="#close"
										class="remove label label-danger"><i class="fa fa-remove"></i>
										删除</a> <span class="drag label label-default"><i
										class="fa fa-arrows"></i> 拖动</span>
									<div class="preview">待办事项</div>
									<div class="view">
										<iframe id="todo_iframe"
											style="width:100%;height:251px; border:1px solid #ddd;"
											frameborder="0" scrolling="no"
											src="${ctx}/views/cap/isc/theme/person/todo/todolist.jsp"></iframe>
									</div>
								</div>
								<div class="box box-element">
									<a rel="nofollow" href="#close"
										class="remove label label-danger"><i class="fa fa-remove"></i>
										删除</a> <span class="drag label label-default"><i
										class="fa fa-arrows"></i> 拖动</span>
									<div class="preview">日程管理</div>
									<div class="view">
										<iframe id="calendar_iframe"
											style="width:100%;height:251px; border:1px solid #ddd;"
											frameborder="0" scrolling="no"
											src="${ctx}/views/cap/isc/theme/person/calendar/calendar.jsp"></iframe>
									</div>
								</div>
								<div class="box box-element">
									<a rel="nofollow" href="#close"
										class="remove label label-danger"><i class="fa fa-remove"></i>
										删除</a> <span class="drag label label-default"><i
										class="fa fa-arrows"></i> 拖动</span>
									<div class="preview">通知公告</div>
									<div class="view">
										<iframe id="notice_iframe"
											style="width:100%;height:251px; border:1px solid #ddd;"
											frameborder="0" scrolling="no"
											src="${ctx}/views/cap/isc/theme/person/notice/noticelist-desk.jsp"></iframe>
									</div>
								</div>
								<div class="box box-element">
									<a rel="nofollow" href="#close"
										class="remove label label-danger"><i class="fa fa-remove"></i>
										删除</a> <span class="drag label label-default"><i
										class="fa fa-arrows"></i> 拖动</span>
									<div class="preview">跟踪事项</div>
									<div class="view">
										<iframe id="trace_iframe"
											style="width:100%;height:251px; border:1px solid #ddd;"
											frameborder="0" scrolling="no"
											src="${ctx}/views/cap/isc/theme/person/trace/tracelist.jsp"></iframe>
									</div>
								</div>
								<%-- <div class="box box-element">
									<a rel="nofollow" href="#close"
										class="remove label label-danger"><i class="fa fa-remove"></i>
										删除</a> <span class="drag label label-default"><i
										class="fa fa-arrows"></i> 拖动</span>
									<div class="preview">财务事项</div>
									<div class="view">
										<iframe id="finance_iframe"
											style="width:100%;height:251px; border:1px solid #ddd;"
											frameborder="0" scrolling="no"
											src="${ctx}/views/cap/isc/theme/person/finance/financeList.jsp"></iframe>
									</div>
								</div> --%>
					</div>
					</li>
					</ul>
				</div>
			</div>

			<!--内容区域 开始-->
			<div class="demo">${descontent }</div>

			<!--内容区域 结束-->
			<div id="download-layout">
				<!-- 可编辑内容区域 开始 -->
				<div class="container-fluid"></div>
				<!-- 可编辑内容区域 结束 -->
			</div>
		</div>
	</div>
	<script type="text/javascript">
		$(function() {

			$(window).resize(function() {
				var navbarHeight = $(".navbar").height() - 43;
				$(".sidebar-nav").css("margin-top", navbarHeight);
				$(".container").css("margin-top", navbarHeight)
			});

		})
	</script>
</body>
</html>