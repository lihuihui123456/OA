<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<html>
<head>
	<!-- content type -->
	<meta content="text/html; charset=gb2312" http-equiv="Content-Type">
	<!-- viewport -->
	<meta content="width=device-width,initial-scale=1" name="viewport">
	<!-- title -->
	<title>领导桌面</title>
	<!-- add css -->
	<link type="text/css" href="${ctx}/views/cap/isc/theme/leader1/css/style.css" rel="stylesheet">
	<!-- add js -->
	<script src="${ctx}/views/cap/isc/theme/leader1/js/jquery.js"></script>
	<script src="${ctx}/views/cap/isc/theme/leader1/js/turn.js"></script>
	<script src="${ctx}/views/cap/isc/theme/leader1/js/jquery.fullscreen.js"></script>
	<script src="${ctx}/views/cap/isc/theme/leader1/js/jquery.address-1.6.min.js"></script>
	<script src="${ctx}/views/cap/isc/theme/leader1/js/onload.js"></script>
	<%@ include file="/views/cap/common/theme.jsp"%>
	<style>
		html, body { margin: 0; padding: 0; overflow: auto !important; }
	</style>
</head>
<body>
	<!-- BEGIN FLIPBOOK STRUCTURE -->
	<div data-template="true" data-cat="book7" id="fb7-ajax">
		<!-- BEGIN HTML BOOK -->
		<div data-current="book7" class="fb7" id="fb7">
			<!-- preloader -->
			<div class="fb7-preloader">
				<div id="wBall_1" class="wBall">
					<div class="wInnerBall"></div>
				</div>
				<div id="wBall_2" class="wBall">
					<div class="wInnerBall"></div>
				</div>
				<div id="wBall_3" class="wBall">
					<div class="wInnerBall"></div>
				</div>
				<div id="wBall_4" class="wBall">
					<div class="wInnerBall"></div>
				</div>
				<div id="wBall_5" class="wBall">
					<div class="wInnerBall"></div>
				</div>
			</div>

			<!-- background for book -->
			<div class="fb7-bcg-book"></div>
			<!-- BEGIN CONTAINER BOOK -->
			<div id="fb7-container-book">
				<!-- BEGIN deep linking -->
				<section id="fb7-deeplinking">
					<ul>
						<li data-address="page1" data-page="1"></li>
						<li data-address="page2-page3" data-page="2"></li>
						<li data-address="page2-page3" data-page="3"></li>
						<li data-address="page4-page5" data-page="4"></li>
						<li data-address="page4-page5" data-page="5"></li>
						<li data-address="page6-page7" data-page="6"></li>
						<li data-address="page6-page7" data-page="7"></li>
						<li data-address="page8-page9" data-page="8"></li>
						<li data-address="page8-page9" data-page="9"></li>
						<li data-address="end" data-page="10"></li>
					</ul>
				</section>
				<!-- END deep linking -->

				<!-- BEGIN ABOUT -->
				<%--<section id="fb7-about">
					<iframe style="width:100%;height:100%;" src="http://127.0.0.1:8080/cap-aco/views/cap/isc/theme/person/todo/todolist.jsp"></iframe>
				</section>
				--%><!-- END ABOUT -->

				<!-- BEGIN PAGES -->
				<div id="fb7-book">
					<!-- BEGIN PAGE 1 -->
					<div style="background-image:url(${ctx}/views/cap/isc/theme/leader1/images/todo.png)"
						class="fb7-noshadow">
						<!-- begin container page book -->
						<div class="fb7-cont-page-book">
							<!-- description for page -->
							<div class="fb7-page-book"></div>
						</div>
						<!-- end container page book -->
					</div>
					<!-- END PAGE 1 -->

					<!-- BEGIN PAGE 2 -->
					<div style="background-image:url()">
						<!-- begin container page book -->
						<div class="fb7-cont-page-book">
							<!-- description for page  -->
							<div class="fb7-page-book">
								<ul class="toc">
								    <li><a href="#3"></a><span class="number">03</span><span class="text">第3页</span></li>
								    <li><a href="#4"><span class="number">04</span><span class="text">第4页</span></a></li>
								    <li><a href="#5"><span class="number">05</span><span class="text">第5页</span></a></li>
								    <li><a href="#6"><span class="number">06</span><span class="text">第6页</span></a></li>
								    <li><a href="#7"><span class="number">07</span><span class="text">第7页</span></a></li>
								    <li><a href="#8"><span class="number">08</span><span class="text">第8页</span></a></li>
								    <li><a href="#9"><span class="number">09</span><span class="text">第9页</span></a></li>
								</ul>
							</div>
							<!-- begin number page -->
							<div class="fb7-meta">
								<span class="fb7-num">2</span>
							</div>
							<!-- end number page -->
						</div>
						<!-- end container page book -->
					</div>
					<!-- END PAGE 2 -->

					<!-- BEGIN PAGE 3 -->
					<div style="background-image:url()">
						<!-- begin container page book -->
						<div class="fb7-cont-page-book">
							<!-- description for page-->
							<div class="fb7-page-book">
								<iframe style="width:100%;height:100%;" src="http://127.0.0.1:8080/cap-aco/views/cap/isc/theme/person/todo/todolist.jsp"></iframe>
							</div>
							<!-- begin number page  -->
							<div class="fb7-meta">
								<span class="fb7-num">3</span>
							</div>
							<!-- end number page  -->
						</div>
						<!-- end container page book -->
					</div>
					<!-- END PAGE 3 -->

					<!-- BEGIN PAGE 4-5 -->
					<div style="background-image:url()">
						<!-- begin container page book -->
						<div class="fb7-cont-page-book">
							<!-- description for page -->
							<div class="fb7-page-book">
								<iframe style="width:100%;height:100%;" src="http://127.0.0.1:8080/cap-aco/views/cap/isc/theme/person/notice/noticelist-desk.jsp"></iframe>
							</div>
							<!-- begin number page  -->
							<div class="fb7-meta">
								<span class="fb7-num">4</span>
							</div>
							<!-- end number page  -->
						</div>
						<!-- end container page book -->
					</div>

					<div style="background-image:url()">
						<!-- begin container page book -->
						<div class="fb7-cont-page-book">
							<!-- description for page -->
							<div class="fb7-page-book">
								<iframe style="width:100%;height:100%;" src="http://127.0.0.1:8080/cap-aco/views/cap/isc/theme/person/notice/noticelist-desk.jsp"></iframe>
							</div>
							<!-- begin number page  -->
							<div class="fb7-meta">
								<span class="fb7-num">5</span>
							</div>
							<!-- end number page  -->
						</div>
						<!-- end container page book -->
					</div>
					<!-- END PAGE 4-5 -->

					<!-- BEGIN PAGE 6 -->
					<div style="background-image:url()">
						<!-- begin container page book -->
						<div class="fb7-cont-page-book">
							<!-- description for page -->
							<div class="fb7-page-book">
								<iframe style="width:100%;height:100%;" src="http://127.0.0.1:8080/cap-aco/views/cap/isc/theme/person/notice/noticelist-desk.jsp"></iframe>
							</div>
							<!-- begin number page  -->
							<div class="fb7-meta">
								<span class="fb7-num">6</span>
							</div>
							<!-- end number page  -->
						</div>
						<!-- end container page book -->
					</div>
					<!-- END PAGE 6 -->

					<!-- BEGIN PAGE 7 -->
					<div style="background-image:url()">
						<!-- begin container page book -->
						<div class="fb7-cont-page-book">
							<!-- description for page  -->
							<div class="fb7-page-book">
								<iframe style="width:100%;height:100%;" src="http://127.0.0.1:8080/cap-aco/views/cap/isc/theme/person/notice/noticelist-desk.jsp"></iframe>
							</div>
							<!-- begin number page  -->
							<div class="fb7-meta">
								<span class="fb7-num">7</span>
							</div>
							<!-- end number page  -->
						</div>
						<!-- end container page book -->
					</div>
					<!-- END PAGE 7 -->

					<!-- BEGIN PAGE 8 -->
					<div style="background-image:url()">
						<!-- begin container page book -->
						<div class="fb7-cont-page-book">
							<!-- description for page -->
							<div class="fb7-page-book">
								<iframe style="width:100%;height:100%;" src="http://127.0.0.1:8080/cap-aco/views/cap/isc/theme/person/notice/noticelist-desk.jsp"></iframe>
							</div>

							<!-- begin number page -->
							<div class="fb7-meta">
								<span class="fb7-num">8</span>
							</div>
							<!-- end number page -->
						</div>
						<!-- end container page book -->
					</div>
					<!-- END PAGE 8 -->

					<!-- BEGIN PAGE 9 -->
					<div style="background-image:url()">
						<!-- begin container page book -->
						<div class="fb7-cont-page-book">
							<!-- description for page -->
							<div class="fb7-page-book">
								<iframe id="todo_iframe" src="${ctx}/views/aco/main/calendar/calendar.jsp" width="100%" height="100%" frameborder=0 scrolling=no style="border:1px solid #ddd;"></iframe>
							</div>
							<!-- begin number page -->
							<div class="fb7-meta">
								<span class="fb7-num">9</span>
							</div>
							<!-- end number page -->
						</div>
						<!-- end container page book -->
					</div>
					<!-- END PAGE 9 -->

					<!-- BEGIN PAGE 10 -->
					<div style="background-image:url()">
						<!-- begin container page book -->
						<div class="fb7-cont-page-book">
							<!-- description for page-->
							<div class="fb7-page-book">
								<p>&nbsp;</p>
								<p>&nbsp;</p>
								<p>&nbsp;</p>
								<p>&nbsp;</p>
								<p>&nbsp;</p>
								<p>&nbsp;</p>
								<p>&nbsp;</p>
								<p>&nbsp;</p>
								<p>&nbsp;</p>
								<p>&nbsp;</p>
								<h1 style="padding-left: 150px;">&nbsp;THE END</h1>
							</div>
						</div>
						<!-- end container page book -->
					</div>
					<!-- END PAGE 10 -->
				</div>
				<!-- END PAGES -->

				<!-- arrows -->
				<a class="fb7-nav-arrow prev"></a> <a class="fb7-nav-arrow next"></a>
				<!-- shadow -->
				<div class="fb7-shadow"></div>
			</div>
			<!-- END CONTAINER BOOK -->

			<!-- BEGIN FOOTER -->
			<div id="fb7-footer" style="display:block">
				<div class="fb7-bcg-tools"></div>
				<div class="fb7-menu" id="fb7-center">
					<ul>
						<!-- margin left -->
						<li></li>
						<!-- icon download -->
						<li><a title="Pdf File Or Zip" class="fb7-download" href="#"></a>
						</li>
						<!-- icon_zoom_in -->
						<li><a title="Zoom In" class="fb7-zoom-in"></a></li>
						<!-- icon_zoom_out -->
						<li><a title="Zoom Out" class="fb7-zoom-out"></a></li>
						<!-- icon_zoom_auto -->
						<li><a title="Zoom Auto" class="fb7-zoom-auto"></a></li>
						<!-- icon_zoom_original -->
						<li><a title="Zoom Original (Scale 1:1)"
							class="fb7-zoom-original"></a></li>
						<!-- icon_allpages -->
						<li><a title="显示所有页" class="fb7-show-all"></a></li>
						<!-- icon_home -->
						<li><a title="首页" class="fb7-home"></a></li>
						<!-- icon fullscreen -->
						<li><a title="全屏" class="fb7-fullscreen"></a>
						</li>
						<!-- margin right -->
						<li></li>
					</ul>
				</div>

				<div class="fb7-menu" id="fb7-right" style="display:none;">
					<ul>
						<!-- icon page manager -->
						<li class="fb7-goto"><label for="fb7-page-number"
							id="fb7-label-page-number"></label> <input type="text"
							id="fb7-page-number">
							<button type="button">Go</button></li>
					</ul>
				</div>
			</div>
			<!-- END FOOTER -->

			<!-- BEGIN THUMBS -->
			<div id="fb7-all-pages" class="fb7-overlay">
				<section class="fb7-container-pages">
					<div id="fb7-menu-holder">
						<ul id="fb7-slider">
							<!-- PAGE 1 - THUMB -->
							<li class="1"><img alt="" src="images/1_.jpg"></li>
							<!-- PAGE 2 - THUMB -->
							<li class="2"><img alt="" src="images/2_.jpg"></li>
							<!-- PAGE 3 - THUMB -->
							<li class="3"><img alt="" src="images/3_.jpg"></li>
							<!-- PAGE 4-5 - THUMB -->
							<li class="5"><img alt="" src="images/4_5_.jpg"></li>
							<!-- PAGE 6 - THUMB -->
							<li class="6"><img alt="" src="images/6_.jpg"></li>
							<!-- PAGE 7 - THUMB -->
							<li class="7"><img alt="" src="images/7_.jpg"></li>
							<!-- PAGE 8 - THUMB -->
							<li class="8"><img alt="" src="images/8_.jpg"></li>
							<!-- PAGE 9 - THUMB -->
							<li class="9"><img alt="" src="images/9_.jpg"></li>
							<!-- PAGE 10S - THUMB -->
							<li class="10"><img alt="" src="images/end_.jpg"></li>
						</ul>
					</div>
				</section>
			</div>
			<!-- END THUMBS -->
		</div>
		<!-- END HTML BOOK -->
	</div>
	<!-- END FLIPBOOK STRUCTURE -->

	<!-- CONFIGURATION FLIPBOOK -->
	<%--<script>
	$(function(){
		$("ul.toc li").hover(function(){ 
			alert("123");
			$(this).find("span.number,span.text").animate( { "background-color": '#892667' },200);
		}, function() {
			$(this).find("span.number,span.text").animate( { "background-color": '#A6B0BB' },200);
		});
	});
	</script>
	--%><script>
	    var width = document.body.clientWidth / 2;
	    var height = document.body.clientHeight ;
		jQuery('#fb7-ajax').data('config', {
			"page_width" : width,
			"page_height" : height,
			"go_to_page" : "Page",
			"gotopage_width" : "45",
			"zoom_double_click" : "1",
			"zoom_step" : "0.06",
			"tooltip_visible" : "true",
			"toolbar_visible" : "true",
			"deeplinking_enabled" : "true",
			"double_click_enabled" : "true",
			"rtl" : "false"
		})
	</script>
	
</body>
</html>