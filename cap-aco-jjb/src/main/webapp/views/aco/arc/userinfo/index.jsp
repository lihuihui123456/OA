<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<base href="<%=basePath%>">
<%@ include file="/views/aco/common/head.jsp"%>
<title></title>
<meta http-equiv="pragma" content="no-cache">
<meta http-equiv="cache-control" content="no-cache">
<meta http-equiv="expires" content="0">
<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
<meta http-equiv="description" content="This is my page">
<meta name="viewport" content="width=device-width, initial-scale=1.0,maximum-scale=1.0, minimum-scale=1.0, user-scalable=no" />
<script type="text/javascript">
	window.onload=function(){
		var height = window.scrlogon.height;
	 	var width = window.scrlogon.width;
	 	var erweima = document.getElementById("logo");
	 	var bgbottom = document.getElementById("bgbottom");
	 	var bgtop = document.getElementById("bgtop");
 		var width2 = width/1.4;
 		var height2 = height/2.4;
	 	erweima.style.width=width2+'px';
	 	erweima.style.height=height2+'px';
	 	var height3 = width/10;
	 	var height4 = width/3;
	 	bgbottom.style.height = height3+'px';
	 	bgtop.style.height = height4+'px';
	}

	function is_weixin(){
		var ua = navigator.userAgent.toLowerCase();
		if(ua.match(/MicroMessenger/i)=="micromessenger") {
			//document.getElementById("downloadPage").style.visibility="none";
	 	} else {
	  		window.location.assign('${ctx}/views/aco/userinfo/file/courtoa.apk');   //该句写成一行代码
	  		document.getElementById("downloadPage").style.visibility="hidden";
		}
	}
	
	function change(){
		document.getElementById("downloadPage").style.visibility="hidden";
	}
	
	
</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body onload="is_weixin()" style=" background:#efefef; text-align:center; margin-left:auto; margin-right:auto;">
	<div id="bgtop" style="height: auto;"></div>
	<img style="margin-left: auto" id="logo" width="90%" src="${ctx}/views/aco/userinfo/images/logo.png" />
	<div id="bgbottom" style="height: auto;"></div>
	<img style="margin-left: auto" id="logo" width="70%" src="${ctx}/views/aco/userinfo/images/btn1.png"/>
	<!--  
	<table id="logo" width="100%" border="0" cellspacing="0" cellpadding="0">
	    <tr>
	      <td align="center"><img src="${ctx}/views/aco/userinfo/images/logo.png" /></td>
	    </tr>
	    <tr>
	      <td align="center"><a style="text-align:center;" href="${ctx}/views/aco/userinfo/file/courtoa.apk"><img src="${ctx}/views/aco/userinfo/images/btn1.png"/></a></td>
	    </tr>
	</table>
	-->
	<!-- 
	<h1><a id="appUpload" href="${ctx}/views/aco/userinfo/file/courtoa.apk">点击下载</a></h1>
	
	<br>
	 -->
	 
	 
	<div id="downloadPage" onclick="change();" style="position:absolute; top:0px; left:0px;">
		<img style="width: 100%" src="${ctx}/views/aco/userinfo/images/xiazaiye.png"/>
	</div>
	
</body>
</html>
