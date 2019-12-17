<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <title>办公系统</title>
	<%@ include file="/views/aco/common/head.jsp"%>
	<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<link rel="stylesheet" type="text/css" media="screen" href="${ctx}/views/cap/isc/theme/shortcut/css/all-examples.css">
	<noscript>
		<style type="text/css">
			#dock { top: 0; left: 100px; }
			a.dock-item { position: relative; float: left; margin-right: 10px; }
			.dock-item span { display: block; }
			.stack { top: 0; }
			.stack ul li { position: relative; }
		</style>
	</noscript>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/shortcut/js/jquery.mousewheel.min.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/fusion/js/jquery.touchSwipe.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/shortcut/js/fisheye-iutil.min.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/shortcut/js/dock-example1.js"></script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/shortcut/js/stack-1.js"></script>
	<style type="text/css">
		html, head ,body { height: 100%; border:0; padding:0; margin:0; } 
		body{ overflow:auto;}
	</style>
	<link href="${ctx}/views/cap/isc/theme/shortcut/css/shortcut.css" rel="stylesheet">
	<script type="text/javascript" src="${ctx}/views/cap/isc/theme/shortcut/js/shortcut_desk.js"></script>
	<%@ include file="/views/cap/common/theme.jsp"%>
	
	<script type="text/javascript">
		var ret = '${ret}';
	</script>
</head>
<body id="shortcut" onmousewheel="return false;">
	<div class="shortcut" id="btnCon">
		<div id="myCarousel" class="carousel slide" data-ride="carousel">
			<!-- PC端-底部菜单导航栏 -->
			<ol id="mainPoint" class="carousel-indicators" style="bottom:-15px\9;border:1px solid #ccc\9;height:56px\9;">
				<c:forEach var="list" items="${pageRoot }" varStatus="status">
					<li data-target="#myCarousel" data-slide-to="${status.index}" <c:if test="${list.pageNum == 0}">class="active"</c:if>>
						<span>${list.pageName }</span>
						<i title="${list.pageName }" class="${list.pageIcon }"></i>
					</li>
				</c:forEach>
				<li class='btn-add-del'><span></span><i class="fa fa-plus color_add add-item" onclick="addPageBefore();"></i>
					<i class="fa fa-remove color_del remove-item" onclick="delPage();"></i></li>
			</ol>

			<div id="mainPage" class="carousel-inner" role="listbox">  
				<c:forEach var="module" items="${rootList }">
					<c:set var="id" value="${module.id }"></c:set>
					<c:set var="pageNum" value="${module.pageNum }"></c:set>
					<div id="sortable${pageNum}" pageNum="${pageNum}" class="item <c:if test="${pageNum == 0}">active</c:if>">
						<c:set var="total" value="${fn:length(moduleMap[id])}"></c:set>
						<c:forEach var="child" items="${moduleMap[id] }">
							<a title="${child.modName}" id="${child.modId }" pageNum="${pageNum}" 
								onclick="addTab('${child.modId}','${child.modName}','${child.modIcon}','${child.modUrl}')">
								<c:choose>
									<c:when test="${empty child.modIcon }">
										<i class="iconfont icon-bookmark"></i>
									</c:when>
									<c:otherwise>
										<i class="${child.modIcon}"></i>
									</c:otherwise>
								</c:choose>
								<span>${child.modName}</span>
							</a>
						</c:forEach>
						<a title="新增" id="${pageNum }" class="add-btn ui-state-disabled" onclick="showSet('${pageNum}', '${total}')">
						<i class="iconfont icon-liansuoqudaoxinzeng"></i>
					</a>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>

	<!-- 垃圾桶位置 -->
	<div id="trash" class="trash"></div>

	<!-- 移动端-底部菜单导航栏 -->
	<div id="mobileNavDiv" class="stack">
		<img src="${ctx}/views/cap/isc/theme/shortcut/images/stacks/stack.png" alt="stack"/>
		<ul id="stack">
			<c:forEach var="list" items="${pageRoot }" varStatus="status">
				<li data-target="#myCarousel" data-slide-to="${status.index}" <c:if test="${list.pageNum == 0}">class="active"</c:if>>
					<a href="javascript:void(0);">
						<span>${list.pageName }&nbsp;</span>
						<i title="${list.pageName }" class="${list.pageIcon }"></i>
					</a>
				</li>
			</c:forEach>
		</ul>
	</div>

	<!-- 自定义常用菜单 -->
	<div class="modal fade" id="setModal" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">自定义常用菜单</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="setFrame" name="setFrame" height="340" width="100%" frameborder=0 scrolling=auto allowTransparency="true"> </iframe>
					</div>
				</div>
				<div class="modal-footer">
					<button class="btn btn-primary btn-sm" onclick="saveSelectMod()">确定</button>
					<button type="button" class="btn btn-primary btn-sm"  onclick="closeSetDialog()">关闭</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 添加页modal -->
	<div class="modal fade" id="addPageModal">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title">新增页</h4>
				</div>
				<div class="modal-body" style="margin-left: 20px">
					<form id="add_form" method="post" class="form-horizontal " target="_top">
						<input type="hidden" name="pageNum" id="pageNum">
						<div class="row">
							<label class="col-sm-2 control-label" 
								style="text-align: right;">页名称</label>
							<div class="col-sm-8">
								<input type="text" id="pageName" name="pageName"
									class="form-control" placeholder="">
							</div>
						</div>
						<br />
						<div class="row">
							<label class="col-sm-2 control-label" style="text-align: right;">页图标</label>
							<div class="col-sm-8">
								<input type="text" id="pageIcon" name="pageIcon" class="form-control" placeholder="" onfocus="this.blur()" onclick="openFunIconDialog()">
							</div>
						</div>
					</form>
				</div>
				<div align="center" style="margin-bottom: 20px;">
					<button class="btn btn-primary" onclick="addPage()">保存</button>
					<button type="button" class="btn btn-primary"" onclick="closeAddDialog()">关闭 </button>
				</div>
			</div>
		</div>
	</div>

	<!-- 选择图标 -->
	<div class="modal fade" id="funIconDialog" tabindex="-1" role="dialog" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">选择图标</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="setIconFrame" name="setIconFrame" height="340" width="100%" frameborder=0 scrolling=auto allowTransparency="true"> </iframe>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-primary btn-sm"  onclick="closeFunIconDialog()">关闭</button>
				</div>
			</div>
		</div>
	</div>
</body> 
</html>