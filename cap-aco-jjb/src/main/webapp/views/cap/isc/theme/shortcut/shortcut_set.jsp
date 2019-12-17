<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>自定义常用菜单</title>
		<%@ include file="/views/aco/common/head.jsp"%>
		<link href="${ctx}/views/cap/isc/theme/shortcut/css/shortcut.css" rel="stylesheet">
		<script type="text/javascript" src="${ctx}/views/cap/isc/theme/shortcut/js/shortcut.js"></script>
		<%@ include file="/views/cap/common/theme.jsp"%>
	</head>
	<body>
		<div class="shortcut-menu">
			<c:forEach var="module" items="${rootList }">
				<c:set var="id" value="${module.modId }"></c:set>
				<div class="menu-box">
					<h4>${module.modName}</h4>
					<c:forEach var="child" items="${moduleMap[id] }">
						<a title="${child.modName}" id="${child.modId}" onclick="getSelectData('${child.modId}','${child.modName}','${child.modIcon}','${child.modUrl}')">
							<c:choose>
								<c:when test="${empty child.modIcon }">
									<i class="iconfont icon-bookmark"></i>
								</c:when>
								<c:otherwise>
									<i class="${child.modIcon}"></i>
								</c:otherwise>
							</c:choose>
							<span>${child.modName}</span>
							<span class="${child.checked}"></span>
						</a>
					</c:forEach>
				</div>
			</c:forEach>
			<div class="menu-box">
				<h4>更多</h4>
				<c:forEach var="module" items="${otherList}">
					<a title="${module.modName}" id="${module.modId}" onclick="getSelectData('${module.modId}','${module.modName}','${module.modIcon}','${module.modUrl}')">
						<c:choose>
							<c:when test="${empty module.modIcon }">
								<i class="iconfont icon-bookmark"></i>
							</c:when>
							<c:otherwise>
								<i class="${module.modIcon}"></i>
							</c:otherwise>
						</c:choose>
						<span>${module.modName}</span>
						<span class="${module.checked}"></span>
					</a>
				</c:forEach>
			</div>
		</div>	
	</body>
	<script>
	var pageNum = '${pageNum}';
	var total = '${total}';
	$(function(){
		$(".shortcut-menu a").each(function(index){
			var checkHas = $(this).find("span");
			 if(checkHas.hasClass("unchecked")){
				$(this).css({
					"opacity":"0.6",
					"filter":"alpha(opacity = 60)"
				});
			}else{
				$(this).css({
					"opacity":"1",
					"filter":"alpha(opacity = 100)"
				});
			}
		});
		$(".shortcut-menu a").bind("click",function(){
			var checkHas = $(this).find("span");
			 if(checkHas.hasClass("unchecked")){
				$(this).children("span:last-child").removeClass("unchecked").addClass("checked");
				$(this).css({
					"opacity":"1",
					"filter":"alpha(opacity = 100)"
				});
			}else{
				$(this).children("span:last-child").removeClass("checked").addClass("unchecked");
				$(this).css({
					"opacity":"0.6",
					"filter":"alpha(opacity = 60)"
				});
			}
		});
	});
	
	</script>
</html>