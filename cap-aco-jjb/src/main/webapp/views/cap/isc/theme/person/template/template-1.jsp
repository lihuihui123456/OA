<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
    <head>
		<title>首页配置模板一</title>
		<%@ include file="/views/aco/common/head.jsp"%>
		<link href="${ctx}/static/aco/images/favicon.ico" rel="SHORTCUT ICON" />
		<link href="${ctx}/static/aco/images/favicon.ico" rel="BOOKMARK" />
		<link href="${ctx}//views/cap/isc/theme/person/css/template.css" rel="stylesheet">
		<%@ include file="/views/cap/common/theme.jsp"%>
	</head>
	<body style="overflow-x:hidden;overflow-y:auto;">
		<!-- 主容器 -->
		<div class="container-fluid">
			<div class="template_title">
				<label>3个模块布局：</label>
				<a href="javascript:;" class="btn btn-danger pull-right">应用</a>
			</div>
			<!-- 左侧系统功能树 -->
			<div class="template_menu">
				<c:choose>
					<c:when test="${not empty templSysRegList}">
						<c:forEach items="${ templSysRegList }" var="templSysReg">
							<h5>
								<i class="fa fa-th-large"></i>${ templSysReg.sysName }
								<i class=" icon fa fa-angle-down"></i>
							</h5>
							<ul>
								<c:forEach items="${ templSysReg.templFuns }" var="tempFun">
									<li>
										<img src="${ctx}${ tempFun.funContPic }" class="li-img">
										<span>${ tempFun.funName }</span>
									</li>
								</c:forEach>
							</ul>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<ul>
							<li>暂无内容！</li>
						</ul>
					</c:otherwise>
				</c:choose>
			</div>

			<!-- 右侧面板 -->
			<div class="template_con" style="width: 100%;">
				<div class="row">
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 template">
						<div class="panel" id="C1" name="C1"></div>
					</div>
					<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12 template">
						<div class="panel" id="C2" name="C2"></div>
					</div>
				</div>
				<div class="row">
					<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 template">
						<div class="panel" id="C3" name="C3"></div>
					</div>
				</div>
			</div>
		</div>
	</body>

	<!-- 引入JS文件 -->
	<script src="${ctx}/views/cap/isc/theme/person/js/jquery-ui.min.js"></script>
	<script src="${ctx}/views/cap/isc/theme/person/js/template.js"></script>
</html>