<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<title>办公云盘</title>
<link href="${ctx}/views/aco/clouddisk/css/swiper-3.4.2.min.css" rel="stylesheet">
<style type="text/css">
	.swiper-slide {background-position: center;background-size: cover;}
</style>
</head>
<body>
	<div class="swiper-container">
		<div class="swiper-wrapper">
		</div>
		 <!-- 如果需要分页器 -->
	    <div class="swiper-pagination"></div>
	    
	    <!-- 如果需要导航按钮 -->
	    <div class="swiper-button-prev"></div>
	    <div class="swiper-button-next"></div>
	</div>
<script type="text/javascript" src="${ctx}/views/aco/clouddisk/js/swiper-3.4.2.min.js"></script>
<script type="text/javascript">
var fileIds=$('#hidImage', window.parent.document).val();
if(fileIds!=null&&fileIds!=""){
	var fileIdArray=fileIds.split(",");
	$(".swiper-wrapper").html("");
	for(var i=0;i<fileIdArray.length;i++){
		if(fileIdArray[i]!="FILEID_"){
			$(".swiper-wrapper").append("" +
				"<div class=\"swiper-slide\" " +
				"style=\"background-image:url("+ctx+"/clouddiskq/showImage?fileId="+fileIdArray[i]+")\">" +
			"</div>");
		}
	}
}
var mySwiper = new Swiper('.swiper-container',{
   	loop: true,
	autoplay: 3000,
	// 如果需要分页器
	pagination: '.swiper-pagination',
   
   	// 如果需要前进后退按钮
   	nextButton: '.swiper-button-next',
   	prevButton: '.swiper-button-prev',

 });
</script>
</body>
</html>