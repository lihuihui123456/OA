<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>流程实例明细</title>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/metro/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.edatagrid.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
</head>
<body>
<input type="hidden" id="procinstid" value="${procinstid}"/>
<div id="tt" class="easyui-tabs" style="width:100%;">   
    <div title="流程实例基本信息" style="padding:20px;display:none;">   
       <div id="tab1">
			<iframe id="" src="${ctx}/procInst/toProcInstDetailInfo?procinstid=${procinstid}"  width="100%" height="300" frameborder="no" border="0" marginwidth="0"
					marginheight="0" scrolling="yes" style=""></iframe>
	   </div>
    </div>   
    <div title="流程关联数据" style="padding:20px;display:none;">   
        <div id="tab2">
        	<iframe id="" src="${ctx}/views/cap/bpm/procinstmgr/proc-attach-info.jsp"  width="100%" height="300" frameborder="no" border="0" marginwidth="0"
					marginheight="0" scrolling="yes" style=""></iframe>
        </div>
    </div>   
   <!--  <div title="绑定的表单" style="padding:20px;display:none;">   
       <div id="tab3">绑定的表单</div>
    </div>
    <div title="业务数据" style="padding:20px;display:none;">   
        <div id="tab4">
			
		</div>
    </div> -->
    <div title="流程图" style="padding:20px;display:none;">   
       <div id="tab5">
			<img src="${ctx}/procInst/findViewFlow?procinstid=${procinstid}">
       </div>
    </div>
    <div title="流程流转记录" style="padding:20px;display:none;">   
       <div id="tab6">
       		<iframe id="" src="${ctx}/procInst/listProcessDetails?procinstid=${procinstid}"  width="100%" height="300" frameborder="no" border="0" marginwidth="0"
					marginheight="0" scrolling="yes" style=""></iframe>
       </div>
    </div>
</div>  
</body>
</html>