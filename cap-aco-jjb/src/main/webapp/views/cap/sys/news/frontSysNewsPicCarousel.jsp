<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
		<%@ include file="/views/cap/common/easyui-head.jsp"%>
		<script type="text/javascript" src="${ctx}/views/cap/sys/news/js/html5zoo.js"></script>
		<script type="text/javascript" src="${ctx}/views/cap/sys/news/js/frontLovelygallery.js"></script>
		<script type="text/javascript" src="${ctx}/views/cap/sys/news/js/sysNewsPicCarousel.js"></script>
</head>
	
<body>
	<div style="">
	    <div id="html5zoo-1" style="display:block;position:relative;">
	        <ul id="sysNewsPicCarouselList" class="html5zoo-slides" style="display:none;">
	        	<c:forEach var="sysNewslist" items="${sysNewsPicList}">
					<li>
						<c:choose>
						   <c:when test="${sysNewslist.isOutside=='N' }"> 
						    <a href="<%=basePath %>${sysNewslist.picUrl }" target="_Blank"><img src="${sysNewslist.picPath}" alt="${sysNewslist.picTitle}" data-description="${sysNewslist.picDes}" style="width:400px;height:200px;" /></a> 
						   </c:when>
						   <c:otherwise>
						    <a href="${sysNewslist.picUrl }" target="_Blank"><img src="${sysNewslist.picPath}" alt="${sysNewslist.picTitle}" data-description="${sysNewslist.picDes}" style="width:400px;height:200px;" /></a>
						   </c:otherwise>
						</c:choose>
					</li>
				</c:forEach>
	        </ul>
	    </div>
	</div>
</body>
</html>