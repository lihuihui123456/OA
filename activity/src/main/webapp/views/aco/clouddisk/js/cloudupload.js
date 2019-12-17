function formatChecked(value){
	if(value!="checked"){
		return "";
	}
	return value;
}
/**
 * 办公云盘上传文件
 * @param params
 * @returns {plupload.Uploader}
 */
function uploadCloud(params){
	var fileNum=0;//总文件数量，初始化就赋值
	var uploading=0;//当前上传文件进度
	var defaults={
		runtimes : 'flash,html4,html5',//指定上传方式
		browse_button:"pickFiles",//指定弹出上传文件框的按钮ID
		url:root+"/clouddiskc/fileUpload", //服务器页面地址，后面跟你想传递的参数
		prevent_duplicates:false,//是否允许上传相同文件 :用文件名和size匹配
		max_retries:0,//错误上传的重试次数
		//chunk_size: '50mb',
		multi_selection:true,//是否允许多选
		unique_names:true,//当值为true时会为每个上传的文件生成一个唯一的文件名，并作为额外的参数post到服务器端，参数明为name,值为生成的文件名。
		file_data_name:"file",//指定文件上传时文件域的名称
		container:"container", //容器的地址
		multipart:true,
		multipart_params:{},//参数，可以传递到后台。使用request.getParameter()取值
		flash_swf_url : root+'/views/aco/upload/js/Moxie.swf',//flash上传组件的url地址，如果是相对路径，则相对的是调用Plupload的html文档。当使用flash上传方式会用到该参数。
		silverlight_xap_url : root+'/views/aco/upload/js/Moxie.xap',
		init: {
			PostInit: function() {
			},
			/**
			 *  上传到后台前触发
				监听函数参数：(uploader,file)
				uploader为当前的plupload实例对象，file为触发此事件的文件对象
			 * */
			BeforeUpload:function(uploader,file){
				$(".uploading-console-filename-min").text("准备文件中...");
				$(".uploading-console-filename").text("准备文件【"+file.name+"】中...");
				uploader.settings.multipart_params.fileAttr=LEFT_NODE.fileattr;
				uploader.settings.multipart_params.fileName=file.name;
			},
			/**
			 *  当文件添加到上传队列后触发
				监听函数参数：(uploader,files)
				uploader为当前的plupload实例对象，files为一个数组，里面的元素为本次添加到上传队列里的文件对象
			 * */
			FilesAdded: function(uploader,files){
				fileNum=files.length;//初始化总文件数
				var folderId=uploader.settings.multipart_params.folderId;
				uploader.start();
			},
			FileUploaded:function(uploader,file,responseObject){
				uploading++;
			},
			/**
			 *  会在文件上传过程中不断触发，可以用此事件来显示上传进度
				监听函数参数：(uploader,file)
				uploader为当前的plupload实例对象，file为触发此事件的文件对象
			 * */
			UploadProgress:function(uploader,file){
				disabledButton(true);
				uploader.disableBrowse(true);
				var qp= uploader.total;
				var fileName_=file.name;
				if(fileName_.length>20){
					fileName_=file.name.substr(0,15)+"...";
				}
				if(qp.percent==100){
					$(".uploading-console-filename-min").text("解析文件中...");
					$(".uploading-console-filename").text("解析文件中...");
				}else{
					$(".uploading-console-filename-min").text("【"+fileName_+"】("+(uploading+1)+"/"+fileNum+")   上传速率:"+formatSize(qp.bytesPerSec)+"/s");
					$(".uploading-console-filename").text("【"+file.name+"】("+(uploading+1)+"/"+fileNum+")   上传速率:"+formatSize(qp.bytesPerSec)+"/s");
				}
				$(".progress-bar").html(qp.percent+"%").css("width",qp.percent+"%");
			}, 
			UploadComplete:function(uploader,files){
				refreshTableList();
				$(".uploading-console-filename-min").text("已完成上传");
				$(".uploading-console-filename").text("已完成上传");
				disabledButton(false);
				uploader.disableBrowse(false);
				countSec(1);
			},
			error:function(uploader,errObject){
				alert(errObject.code+","+errObject.message);
				return false;
			}
			
		}	
	};
	var params_ = $.extend({}, defaults, params);//合并上传参数
	var uploader = new plupload.Uploader(params_);//new plupload对象
	uploader.init();//初始化uploader对象
	return uploader;
}
var TIME_OUT;
function countSec(val){
	/*$("#closeUploadBtn").html("关闭("+val+")");
	if(val>0){
		val=val-1;
		TIME_OUT=window.setTimeout("countSec("+val+")",1000);
	}else{
		$("#modal_upload").fadeOut();
		$("#modal_upload_min").fadeOut();
	}*/
	$("#modal_upload").fadeOut();
	$("#modal_upload_min").fadeOut();
}
function resetProgress(){
	$("#closeUploadBtn").html("关闭");
	$(".uploading-console-filename").text("");
	$(".uploading-console-filename-min").text("");
	$(".progress-bar").html(Math.round(0,2)+"%").css("width",0+"%");
}
function disabledButton(flag){
	if(flag){
		$("#pickFiles").attr('disabled',"true");
		$("#closeUploadBtn").attr('disabled',"true");
		$("#closeModalUploadBtn").attr('disabled',"true");
		$("#buttonUpload").attr('disabled',"true");
	}else{
		$("#pickFiles").removeAttr("disabled");
		$("#closeUploadBtn").removeAttr("disabled");
		$("#closeModalUploadBtn").removeAttr("disabled");
		$("#buttonUpload").removeAttr("disabled");
	}
}
$(document).ready(function(){
	$("#closeModalUploadBtn").click(function(){
		$("#buttonUpload").removeAttr("disabled");
		$("#modal_upload").fadeOut();
	});
	/**
	 * 上传文件
	 */
	$("#buttonUpload").click(function(){
		$("#buttonUpload").attr("disabled",true);
		$("#container").html("<div class=\"btn btn-primary\" id=\"pickFiles\">" +
				"<i class=\"fa fa-cloud-upload\"></i>上传</div><button type=\"button\" " +
						"class=\"btn btn-primary\" onclick=\"closeUploadModal()\" id=\"closeUploadBtn\" >关闭</button>");
		$("#modal_upload").fadeIn();
		$("#modal_upload").css("visibility","visible");
		$("#upload_file").html("");
		resetProgress();
		uploadCloud({multipart_params:{folderId:LEFT_NODE.id}});
		$("#upLoadFileName").text(LEFT_NODE.name);
		
	});
	$("#minusModalUploadBtn").click(function(){
		$("#modal_upload").css("visibility","hidden");
		$("#modal_upload_min").fadeIn();
	});
	$("#modal_upload_min").click(function(){
		$("#modal_upload").css("visibility","visible");
		$("#modal_upload_min").fadeOut();
	});
	
});
function closeUploadModal(){
	$("#buttonUpload").removeAttr("disabled");
	$("#modal_upload").fadeOut();
}
