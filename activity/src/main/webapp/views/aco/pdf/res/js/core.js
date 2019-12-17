var nFileCount = 0;
var RotateIndex = 0;
var imgArr=new Array();
var folderPath = "C:\\GpyLocationImg";
var autoFolderPath = "C:\\GpyLocationImg";
var imgPdfPath = "C:\\GpyLocationImg\\PdfImg";
var pdfImgCount = 0;
var pdfPath = "D:\\mediaFile\\pdf";
var pdfName = "123.pdf";
var	strFile;
var cameraIndex=0;
$(document).ready(function(){
	var backcode = CaptureOcx.InitCamera();
	if(backcode!=null&&backcode!=0){
		setTimeout("StartVideo()",200);
	}
	
	//矫正类型->不矫正/智能矫正/手动裁切
	$('input[name=crop]').change(function () {
        var mode = $(this).val();
        CaptureOcx.SetCutType(mode);
    });
	
	//拍摄类型->彩色/灰度/黑白
    $('input[name=color]').change(function () {
        var mode = $(this).val();
        CaptureOcx.setImageColorMode(mode)
    });
    
    //打开视频属性
    $('#DevicesProperty').click(function () {
        CaptureOcx.OpenPropertyPage();
    });
});

//切换摄像头
function switchCamera() {
    cameraIndex = (cameraIndex+1)%2;
    CaptureOcx.ToggleCamera(cameraIndex);
}
    
//关闭视频
function closecamera(){
	var buf = CaptureOcx.CloseCamera();
}

//开启视频
function StartVideo(){
	CaptureOcx.OpenCamera(12801,720,RotateIndex,1);//打开视频控件 默认1280*720    旋转0度   自动剪裁
	getResolutionInfo(Reso);
}

//获得分辨率信息
function getResolutionInfo(f){
	var total = CaptureOcx.GetResolutionCount();
	for(var i = 0 ; i < total ; i++ )
	{   
		var width = CaptureOcx.GetResolutionWidth(i);
		var height = CaptureOcx.GetResolutionHeight(i); 
		var resolution = width+"X"+height;
		f.Resolution.options[i].text=resolution;
    }
//    f.Resolution.options[6].selected = true;
}

//设置分辨率
function SetResolution(){
	var obj=document.getElementById("Resolution") ;
	var index=obj.selectedIndex;
	CaptureOcx.SetResolution(index);
}

//拍摄
function Capture_IMG(){
	var _strFile = "";
	var filePath = "";
	CaptureOcx.setJpgQuanlity(80);
	strFile = folderPath + "\\Image" + nFileCount;
	_strFile = strFile;
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(!fso.FolderExists(folderPath)){
		fso.CreateFolder(folderPath);
	}
	strFile = CaptureOcx.CaptureImage(strFile);
	nFileCount ++;
	//上传Http
	filePath = httpUrl + "?filePath="+_strFile;
	CaptureOcx.UploadFileHttp(strFile,filePath,"");
	
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(!fso.FolderExists(imgPdfPath)){
		fso.CreateFolder(imgPdfPath);
	}
	var pdfFile = imgPdfPath + "\\" + nFileCount+".jpg";
	CaptureOcx.addToPdfImage(pdfFile, 80);
	imgArr.push(pdfFile);
	pdfImgCount ++;
	
	var n = nFileCount - 1;
	n = n % 4;
	$("#"+n).attr("src",ctx+"/sysLogoController/doDownLoadPicFile?picPath="+strFile);
}

var auto = false;
var autoPath = '';
//连续拍摄
function SeriesCapture_IMG(){
	var filePath = "";
	CaptureOcx.setJPGQuanlity(80);
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(!fso.FolderExists(autoFolderPath)){
		fso.CreateFolder(autoFolderPath);
	}
	autoPath = CaptureOcx.AutoCaptureImage(autoFolderPath,30);
	auto = true;
	//alert(back);
	//nFileCount ++;
	var fc = new Enumerator(fso.GetFolder(autoPath).files);
	for (; !fc.atEnd(); fc.moveNext()){
		CaptureOcx.UploadFileHttp(fc.item(),httpUrl,"");
		
		//上传Http
		filePath = httpUrl + "?filePath="+autoPath;
		CaptureOcx.UploadFileHttp(fc.item(),filePath,"");
	}
}

//左转
function LeftRotate_IMG(){
	RotateIndex++;
	if (RotateIndex == 4){
		RotateIndex = 0;
	}
	CaptureOcx.setRotate(RotateIndex);
}

//右转
function RightRotate_IMG(){
	RotateIndex--;
	if (RotateIndex == 0){
		RotateIndex = 4;
	}
	CaptureOcx.setRotate(RotateIndex);
}

//识别条码
function captureandqrcode(){
	var testpath = folderPath+"\\";
	CaptureOcx.CaptureImageAndQRCode(testpath,0,0,0);
}

//视频属性
function showSetting(){
	CaptureOcx.showSettingWin();
}

//保存pdf
function saveAsPdf(){
	if (pdfImgCount == 0 && !auto) {
		alert("请添加pdf图片！");
	}
	if (auto) {
		$.ajax({
			url : ctx+'/iWebPdf/imgToPdf',
			dataType : 'json',
			type : 'post',
			async : true,
			data : {
				autoPath : autoPath,
				imgArr : imgArr.toString()
			},
			success : function(result) {
				saveToPage();
			},
			error : function(result) {
			}
		});
	} else {
		var _pdf = pdfPath + "\\" + pdfName;
		CaptureOcx.saveToPdf(_pdf);
		
		//上传Http
		filePath = httpUrl + "?filePath="+pdfPath;
		CaptureOcx.UploadFileHttp(_pdf,filePath,"");
		saveToPage();
	}
}

function saveToPage(){
	nFileCount = 0;
	pdfImgCount = 0;
	auto = false;
	autoPath = '';
	
	var $iframeObj = $("#mainBody_pdf_iframe",window.opener.document);
	var bizId = window.opener.bizId;
	url = ctx+"/iWebPdf/toPdfDeitPage?bizId=" + bizId + "&style=edit"+ "&e_pdf=1";
	$iframeObj.attr('src', url);
	closecamera();
	window.close();
}