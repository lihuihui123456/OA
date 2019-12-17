<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>文字识别</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript" src="${ctx}/views/cap/sys/ocr/js/ocrIndex.js"></script>
</head>
<body class="easyui-layout" style="width:100%;height:98%;">
	<!-- 文字识别功能按钮区域 -->
	<div data-options="region:'north',split:false,collapsible:false" style="width: 100%; height:8%;">
		<div>
			<a href="javascript:void(0)" onclick="doOcrRead();" class="easyui-linkbutton" iconCls="icon-sys-ocr" plain="true">开始识别</a>
			<!-- 
			<a href="javascript:void(0)" onclick="" class="easyui-linkbutton" iconCls="icon-sys-copy" plain="true">复制文字</a>
			 -->
			<a href="javascript:void(0)" onclick="doExportTxt();" class="easyui-linkbutton" iconCls="icon-sys-exp-txt" plain="true">导出文本</a>
		</div>
	</div>

	<!-- 显示选择的图片区域 -->
	<div data-options="region:'west',split:false,collapsible:false" style="width: 49%; height:100%; padding-top: 5px;">
		<div id="picResDiv" class="easyui-panel" title="原始图片" style="width:98%;height:96%;padding-top:10px; border-width:1px;">
			<form id="uploadForm" action="" method="post" enctype="multipart/form-data">
				<input id="picResFile" name="picResFile" class="easyui-filebox" style="width:100%" data-options="prompt:'请选择一张图片...',onChange:picResFileOnchange" />
				<img id="picResImg" width="98%" height="85%" src="views/cap/bpm/solrun/img/uploadback.png">
			</form>
		</div>
	</div>

	<!-- 显示识别后的文字区域 -->
	<div data-options="region:'center',split:false,collapsible:false" style="width: 49%; height:100%;margin-left:1%;padding-top: 5px;">
		<div id="picResultDiv" class="easyui-panel" title="识别后的文字" style="width:98%;height:96%; border-width:1px;">
			
		</div>
	</div>
</body>
</html>