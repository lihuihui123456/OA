<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>文字识别</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
	<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css">
	<script type="text/javascript" src="${ctx}/views/cap/bpm/solrun/js/ocrIndex.js"></script>
<script type="text/javascript">
//当前选择的图片服务器路径
var curPicPath = "";
var bizid = '<%=request.getParameter("bizId") %>';
/**
 * 选择文件后，将文件上传到服务器，再将服务器生成的文件下载到客户端
 * 注：为了防止浏览器无法读取本地文件，故需要上传文件到客户端后再读取
 */
function picResFileOnchange() {
	/*accept="image/gif, image/jpeg, image/jpg, image/png"
		
		$('#file').filebox({
			accept: 'image/*'
		});*/
	
	var picSrc = $('#picResFile').filebox('getValue');
	if (picSrc.indexOf(".jpg") < 0 && picSrc.indexOf(".jpeg") <0 && picSrc.indexOf(".png") < 0 && picSrc.indexOf(".bmp") < 0) {
		$.messager.alert('提示', '仅支持jpg、jpeg、png、bmp格式图片，请重新选择！', 'info');
		//$("#picResFile").filebox('setValue', '');
		return;
	}

	// 当选择图片后上传图片到服务器，再下载
	// 注：未放置不能读取本地文件故需先上传后再下载写入到IMG控件中
	$('#uploadForm').form('submit', {
		url : '${ctx}/ocrController/doUploadPicFile',
	    success:function(data){
	    	var retval = eval("("+data+")");
	    	curPicPath = retval.filePath;

	    	// 从服务器下载当前上传的图片路径，并赋值到IMG控件中
			$("#picResImg").attr("src", "${ctx}/ocrController/doDownLoadPicFile?picPath=" + curPicPath);
	    }
	});
}

/**
 * 开始识别图片文字
 */
function doOcrRead() {
	// 如果没有选择或取消选择图片，则返回不做处理
	var picSrc = $("#picResImg")[0].src;
	if (picSrc.indexOf("uploadback.png") > 0) {
		$.messager.alert('提示', '请选择需要识别的图片！', 'info');
		return;
	}

	// 清空识别的文字
	$("#picResultDiv").html('');
	
	// 开启开始识别遮罩层
	onloading("正在识别，请稍后...");

	$.ajax({
		url : '${ctx}/ocrController/doOcrRead',
		type : 'post',
		data : {picPath: curPicPath},
		success : function(data){
			removeload();

			if (data == "") {
				$("#picResultDiv").html('识别错误');
				$.messager.show({ title:'提示', msg:'识别错误', showType:'slide' });
			} else {
				$("#picResultDiv").html(data);
				$.messager.show({ title:'提示', msg:'识别成功', showType:'slide' });
			}
		},
		error : function(data) {
			removeload();
			$.messager.show({ title:'提示', msg:'识别错误', showType:'slide' });
		}
	});
}

//获取识别后的文字
function getValue(){
	var picSrc = $("#picResultDiv").text();
	return picSrc;
}

/**
 * 导出识别后的文字到txt文件中
 */
function doExportTxt() {
	var picSrc = $('#picResFile').filebox('getValue');
	if (picSrc == '' && picSrc.length == 0) {
		$.messager.alert('提示', '没有可导出的图片文字！', 'info');
		return;
	}

	// 当选择图片后上传图片到服务器，再下载
	// 注：未放置不能读取本地文件故需先上传后再下载写入到IMG控件中
	$('#uploadForm').form('submit', {
		url : '${ctx}/ocrController/doExportTxt'
	});
}

/**
 * 显示正在识别遮罩层
 */
function onloading(msg){
    $("<div class=\"datagrid-mask\" style=\"z-index:9999\"></div>").css({display:"block",width:"100%",height:$(window).height()}).appendTo("body");
    $("<div class=\"datagrid-mask-msg\" style=\"z-index:9999\"></div>").html(msg).appendTo("body").css({display:"block",left:($(document.body).outerWidth(true) - 190) / 2,top:($(window).height() - 45) / 2}); 
}

/**
 * 移除正在识别遮罩层
 */
function removeload(){
   $(".datagrid-mask").remove();
   $(".datagrid-mask-msg").remove();
}
function add(){ 
	picurl = '${ctx}/userManager/uploadImg';
	var resultStr = window
			.showModalDialog(
				"${ctx}/media/plupload?chunk=false&url=${ctx}/media/uploadZW?tableId="+bizid,
				window,
				"dialogWidth:500px; dialogHeight: 310px; help: no; scroll: no; status: no");
	refreshPicture(resultStr);
}
function refreshPicture(fileName) {
	if(fileName != null){
		$("#picResImg").attr('src', '${ctx}/uploader/uploadfile?pic=' + fileName);
	}
}

</script>
<style>
.l-btn {
  color: #fc5656;
  border-radius: 4px;
  border: 1px solid #fc5656;
}
.l-btn:hover {
  background: #fc5656;
  border: 1px solid #fc5656;
}
.icon-sys-ocr {
  background: url(views/cap/bpm/solrun/img/icon-sys-ocr.png) no-repeat center center;
}
.icon-sys-exp-txt {
  background: url(views/cap/bpm/solrun/img/icon-sys-exp-txt.png) no-repeat center center;
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="easyui-layout" style="width:100%;height:98%;">
	<!-- 文字识别功能按钮区域 -->
	<div data-options="region:'north',split:false,collapsible:false" style="width: 100%; height:8%;overflow:hidden;">
		<div style="margin-top:-10px;">
			<a style="height: 30px" href="javascript:void(0)" onclick="add();" class="btn btn-default" iconCls="icon-sys-ocr" plain="true">上传图片</a>
			
			<a style="height: 30px" href="javascript:void(0)" onclick="doOcrRead();" class="btn btn-default" iconCls="icon-sys-ocr" plain="true">开始识别</a>
			<!-- 
			<a href="javascript:void(0)" onclick="" class="easyui-linkbutton" iconCls="icon-sys-copy" plain="true">复制文字</a>
			 -->
			<a style="height: 30px" href="javascript:void(0)" onclick="doExportTxt();" class="btn btn-default" iconCls="icon-sys-exp-txt" plain="true">导出文本</a>
		</div>
	</div>

	<!-- 显示选择的图片区域 -->
	<div data-options="region:'west',split:false,collapsible:false" style="width: 49%; height:100%; padding-top: 5px;">
		<input type="hidden" id="tableId" value="${tableId}" />
		<div id="picResDiv" class="easyui-panel" title="原始图片" style="width:98%;height:96%;padding-top:10px; border-width:1px;">
			<form id="uploadForm" action="" method="post" enctype="multipart/form-data">
				<!-- <button type="button" class="btn btn-default" onclick="add()">
					<i class="fa fa-file-text"></i>&nbsp;上传
				</button> -->
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