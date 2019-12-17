<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<title>同联Da3政务协同办公平台发展简史</title>
<link type="text/css" href="${ctx}/static/cap/plugins/time/css/css.css" rel="stylesheet" />
<script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jquery-1.9.1.js"></script>
</head>
<body>
	<div class="history">
		<div class="start-history">
			<p class="cc_history">发展简史</p>
			<p class="next_history">同联Da3政务协同办公平台</p>
			<div class="img_top">
				
			</div>
			<div class="history_left">
				<c:forEach items="${left }" var="history" varStatus="status">
					<c:if test="${status.index == 0 }">
						<p class="history_L year2006">
							<span class="history_2006_span <c:if test="${history.histSkin != ''}">${history.histSkin }</c:if>">
								<fmt:parseDate value="${history.histDate }" type="date" pattern="yyyy-MM-dd" var="dateObj"></fmt:parseDate>
								<fmt:formatDate value="${dateObj }" pattern="yyyy"/>
							</span> 
							<b class="history_2006_b ${history.histSkin }">
								<span class="history_l_month"><fmt:formatDate value="${dateObj }" pattern="MM"/><br />月</span>
								<span class="history_l_text">${history.histName }<br />${history.histDesc }</span>
							</b>
						</p>
					</c:if>
					<c:if test="${status.index != 0 }">
						<p class="history_L yearalmostr">
							<span class="history_2006_span <c:if test="${history.histSkin != ''}">${history.histSkin }</c:if>">
								<fmt:parseDate value="${history.histDate }" type="date" pattern="yyyy-MM-dd" var="dateObj"></fmt:parseDate>
								<fmt:formatDate value="${dateObj }" pattern="yyyy"/>
							</span> 
							<b class="history_2006_b ${history.histSkin }">
								<span class="history_l_month"><fmt:formatDate value="${dateObj }" pattern="MM"/><br />月</span>
								<span class="history_l_text">${history.histName }<br />${history.histDesc }</span>
							</b>
						</p>
					</c:if>
				</c:forEach>
			</div>
			<div class="history-img">
			</div>
			<div class="history_right">
				<c:forEach items="${right }" var="history" varStatus="status">
					<c:if test="${status.index == 0 }">
						<p class="history_R history_r_2005" style="background:url(${ctx}/static/cap/plugins/time/images/R_frist.png) no-repeat -1px -1px;">
							<span class="history_2005_span <c:if test="${history.histSkin != ''}">${history.histSkin }</c:if>">
								<fmt:parseDate value="${history.histDate }" type="date" pattern="yyyy-MM-dd" var="dateObj"></fmt:parseDate>
								<fmt:formatDate value="${dateObj }" pattern="yyyy"/>
							</span> 
							<b class="history_2005_b ${history.histSkin }">
								<span class="history_r_month"><fmt:formatDate value="${dateObj }" pattern="MM"/><br />月</span>
								<span class="history_r_text">${history.histName }<br />${history.histDesc }</span>
							</b>
						</p>
					</c:if>
					<c:if test="${status.index != 0 }">
						<p class="history_R yearalmostr">
							<span class="history_2005_span <c:if test="${history.histSkin != ''}">${history.histSkin }</c:if>">
								<fmt:parseDate value="${history.histDate }" type="date" pattern="yyyy-MM-dd" var="dateObj"></fmt:parseDate>
								<fmt:formatDate value="${dateObj }" pattern="yyyy"/>
							</span> 
							<b class="history_2005_b ${history.histSkin }">
								<span class="history_r_month"><fmt:formatDate value="${dateObj }" pattern="MM"/><br />月</span>
								<span class="history_r_text">${history.histName }<br />${history.histDesc }</span>
							</b>
						</p>
					</c:if>
				</c:forEach>
			</div>
			<div class="clear"></div>
		</div>
		<div class="clear"></div>
	</div>

	<script type="text/javascript" src="${ctx}/static/cap/plugins/time/js/new_file.js"></script>
	<script type="text/javascript">
		$(window).scroll(
			function() {
				var msg = $(".history-img");
				var item = $(".history_L");
				var items = $(".history_R");
				var windowHeight = $(window).height();
				var Scroll = $(document).scrollTop();
				if ((msg.offset().top - Scroll - windowHeight) <= 0) {
					msg.fadeIn(1500);
				}
				for ( var i = 0; i < item.length; i++) {
					if (($(item[i]).offset().top - Scroll - windowHeight) <= -100) {
						$(item[i]).animate({
							marginRight : '0px'
						}, '50', 'swing');
					}
				}
				for ( var i = 0; i < items.length; i++) {
					if (($(items[i]).offset().top - Scroll - windowHeight) <= -100) {
						$(items[i]).animate({
							marginLeft : '0px'
						}, '50', 'swing');
					}
				}
			}
		);
	</script>
</body>
</html>