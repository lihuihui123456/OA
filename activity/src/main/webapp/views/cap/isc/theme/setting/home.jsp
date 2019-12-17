<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
	<head>
	    <title>办公系统</title>		
		<%@ include file="/views/aco/common/head.jsp"%>
		<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
		<style type="text/css">
			html, head ,body {
			   height: 100%;
			   border:0;
			   padding:0;
			   margin:0;
			} 
			html{ overflow:auto;} 
			body{ overflow:hidden;} 
		</style>
	</head>
	<body style="padding:10px 10px 0px 0px;" id="allArea">
		<div class="container-fluid ">
	        <div class="row">
				<div class=" col-lg-6 col-md-6 col-sm-6 col-xs-12">
					<!-- 待办事项-->
					<iframe id="imgPic1" width="100%" frameborder=0 scrolling=no style="border:1px solid #ddd;">
					</iframe>
					<!-- 待办事项 end-->
				</div><!--/.col-->	
				<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
						<!--<div id="calendar"></div>-->
						<iframe id="imgPic2" width="100%" frameborder=0 scrolling=no  style="border:1px solid #ddd;">
						</iframe>
				</div>
			</div>	
			<div class="row">	
				<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
				
					<!-- 通知公告 -->
					<iframe id="imgPic3" width="100%" frameborder=0 scrolling=no style="border:1px solid #ddd;">
					</iframe> 
					<!-- 通知公告 end-->
				</div><!--/col-->
				<div class="col-lg-6 col-md-6  col-sm-6 col-xs-12">
					<!-- 事项跟踪 -->
					<iframe id="imgPic4" width="100%" frameborder=0 scrolling=no style="border:1px solid #ddd;">
					</iframe>
					<!-- end事项跟踪 -->
				</div><!--/col-->
			</div>
		</div>
		
	</body>
  	<script type="text/javascript">
		$(document).ready(function(){
			var list = '${list}';
			list = eval("("+list+")");
			 jQuery.each(list, function(i,item){  
				 if ("menuTree" != item.pageId) {
					 $("#"+item.pageId).attr("src",'${ctx}'+item.modUrl);
			     }
		     });  
			//alert( liCounts());
			var iframeH = liCounts() * 42 + 39;
			$("#imgPic1").height(iframeH + 2);
			//var todoH = $("#todo_iframe").contents().find("#todoPanel").height();
			$("#imgPic2").height(iframeH);
			$("#imgPic3").height(iframeH + 2);
			$("#imgPic4").height(iframeH + 2) ;
			//异步刷新--begin
			//$("#todo_iframe").attr("src","${ctx}/views/aco/home/todo/todolist.jsp");//待办事项
			///$("#calendar_iframe").attr("src","${ctx}/views/aco/main/calendar/calendar.jsp");//日历
			//$("#notice_iframe").attr("src","${ctx}/views/aco/home/notice/noticelist-desk.jsp");//通知公告
			//$("#trace_iframe").attr("src","${ctx}/views/aco/home/trace/tracelist.jsp");//跟踪事项
			//定时刷新页面
		  	/* setInterval(function() {
				$("#todo_iframe").attr("src","${ctx}/views/aco/home/todo/todolist.jsp");//待办事项
				$("#calendar_iframe").attr("src","${ctx}/views/aco/main/calendar/calendar.jsp");//日历
				$("#notice_iframe").attr("src","${ctx}/views/aco/home/notice/noticelist-desk.jsp");//通知公告
				$("#trace_iframe").attr("src","${ctx}/views/aco/home/trace/tracelist.jsp");//跟踪事项
			},60000);  */
			//异步刷新--end
			//当主页显示一列时
			if(document.body.offsetWidth < 768){
				$("#allArea").height( iframeH * 4 + 40);
			}
		});
		function liCounts(){
			var mainH= $("#myTabContent",window.parent.document).height()-10;
			//var titleH = $("#todo_iframe").contents().find(".panel-heading").height();
			var titleH = 39 ;
			if(!isIE()){
				var liCounts = Math.floor((mainH / 2 - titleH) / 42)-1;
			}else{
				var liCounts = Math.floor((mainH / 2 - titleH) / 42);
			}
			if(liCounts < 5){
				liCounts = 5 ;
			}
			return liCounts ;
		}
		function   isIE(){ 
		    if   (window.navigator.userAgent.toString().toLowerCase().indexOf("msie") >=1)
		      return   true;
		    else
		      return   false;
		}
	</script>
</html>