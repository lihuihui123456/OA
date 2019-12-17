<%@page import="java.net.URLEncoder" %>
<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
	<title>插件下载</title>
 	<link rel="stylesheet" href="css/masiter.css">
 	<link rel="shortcut icon" href="${ctx}/static/cap/plugins/bootstrap/ico/tl-favicon.ico" type="image/x-icon" />
    <script src="js/jquery.min.js"></script>
    <script src="js/plugIn.js"></script>
</head>
<body style="min-width: 600px; min-height: 600px;overflow: auto;">
	<h3>插件列表</h3>
	<div class="Inclusive">
		<!-- iWebOffice2015智能文档 -->
		<div class="main">
		    <div class="left">
		        <img class="IE" src="img/word.png" style="width:58px;height:58px;">
		    </div>
		    <div class="right">
		        <a href="${ctx}/downloadFile/downPlugs?plugsName=<%=URLEncoder.encode(URLEncoder.encode("iWebOffice2015.msi", "utf-8"),"utf-8") %>">立即下载</a>
		    </div>
		    <div class="middle">
		        <div class="contain">
		            <p class="caption">iWebOffice2015智能文档</p>
		            <p class="profiles">iWebOffice2015</p>
		            <p class="describe">
						浏览器版本支持：IE8（32&64）、IE9（32&64）、IE10（32&64）、IE11（32&64）、Google chrome（32&64）、Firefox （32&64）<br/>
						文档编辑软件支持：OFFICE 2003、OFFICE 2007、OFFICE 2010（32&64）、OFFICE 2013（32&64）、OFFICE 2016（32&64）、WPS2013 *1、WPS 2016*1、永中OFFICE *2
					</p>
		            <button class="btn">
		                <span class="wenzi">展开详情</span>
		                <span><img class="down" src="img/down.jpg" alt=""></span>
		            </button>
		        </div>
		    </div>
		</div>

		<!-- iWebPDF2015在线管理中间件 -->
		<div class="main">
	        <div class="left">
	            <img class="IE" src="img/pdf.png" style="width:58px;height:58px;">
	        </div>
	        <div class="right">
	        	<a href="${ctx}/downloadFile/downPlugs?plugsName=<%=URLEncoder.encode(URLEncoder.encode("iWebPDF2015.zip", "utf-8"),"utf-8") %>">立即下载</a>
	        </div>
	        <div class="middle">
	            <div class="contain">
	                <p class="caption">iWebPDF2015在线管理中间件</p>
	                <p class="profiles" >iWebPDF2015</p>
	                <p class="describe" >浏览器版本支持：IE8、IE9、IE10、IE11</p>
	                <button class="btn">
	                	<span class="wenzi">展开详情</span>
	                	<span><img class="down"  src="img/down.jpg" alt=""></span>
	                </button>
	            </div>
	        </div>
		</div>

		<!-- iWebRevision网页签批中间件 -->
		<div class="main">
	        <div class="left">
	            <img class="IE" src="img/revision.png" style="width:58px;height:58px;">
	        </div>
	        <div class="right">
	        	<a href="${ctx}/downloadFile/downPlugs?plugsName=<%=URLEncoder.encode(URLEncoder.encode("iWebRevision.cab", "utf-8"),"utf-8") %>">立即下载</a>
	        </div>
	        <div class="middle">
	            <div class="contain">
	                <p class="caption">iWebRevision网页签批中间件</p>
	                <p class="profiles" >iWebRevision</p>
	                <p class="describe" >浏览器版本支持：IE8、IE9、IE10、IE11</p>
	                <button class="btn">
	                	<span class="wenzi">展开详情</span>
	                	<span><img class="down"  src="img/down.jpg" alt=""></span>
	                </button>
	            </div>
	        </div>
		</div>
	</div>
</body>
</html>