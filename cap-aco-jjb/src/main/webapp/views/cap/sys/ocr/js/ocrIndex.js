// 当前选择的图片服务器路径
var curPicPath = "";

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
		url : 'ocrController/doUploadPicFile',
	    success:function(data){
	    	var retval = eval("("+data+")");
	    	curPicPath = retval.filePath;

	    	// 从服务器下载当前上传的图片路径，并赋值到IMG控件中
			$("#picResImg").attr("src", "doDownLoadPicFile?picPath=" + curPicPath);
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
		url : 'ocrController/doOcrRead',
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
		url : 'ocrController/doExportTxt'
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