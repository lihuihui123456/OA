/**
 * customized-upload - 自定义上传组件
 * v1.1.0
 * date: 2017-06-05
 * author:gp
 */

/**
 * @param params 自定义参数
 * @param parentDiv plupload容器
 * @param useDemo 是否使用demo true/false
 * @returns {plupload.Uploader}
 */
function upload(params,parentDiv,useDemo,pageType){
	if(parentDiv==null||parentDiv==""){
		return;
	}
	var uploader,root,id_,uploading,defaults,params_,containerId;
	root=getRootPath();//项目根目录
	id_=plupload.guid();
	containerId="parent_"+id_;
	browseId=id_;
	if(useDemo){
		initHTML(id_,parentDiv,pageType);
	}
	uploading=false;//正在上传标识
	var defaults={
			runtimes : 'flash,html4,html5',//指定上传方式
			browse_button:browseId,//指定弹出上传文件框的按钮ID
			url:root+"/upload/uploadFile", //服务器页面地址，后面跟你想传递的参数
//			filters : [{title : "文档", extensions : "zip,doc,docx,xls,xlsx,ppt,pptx,txt,pdf,sql,mp3,mp4,rmvb,avi,flash,flv,wma,rm,mid,image/jpg,image/jpeg,image/png,iso"}],
			filters: {
				max_file_size : '20mb', //最大只能上传20mb的文件
				
			},
			prevent_duplicates:false,//是否允许上传相同文件 :用文件名和size匹配
			max_retries:0,//错误上传的重试次数
			multi_selection:true,//是否允许多选
			unique_names:true,//当值为true时会为每个上传的文件生成一个唯一的文件名，并作为额外的参数post到服务器端，参数明为name,值为生成的文件名。
			file_data_name:"file",//指定文件上传时文件域的名称
			container:containerId, //容器的地址
			multipart:true,
			multipart_params:{},//参数，可以传递到后台。使用request.getParameter()取值
			flash_swf_url : root+'/views/aco/upload/js/Moxie.swf',//flash上传组件的url地址，如果是相对路径，则相对的是调用Plupload的html文档。当使用flash上传方式会用到该参数。
			silverlight_xap_url : root+'/views/aco/upload/js/Moxie.xap',
			init: {
				PostInit:function(uploader){
					if(pageType=="view"){
						uploader.disableBrowse(true);
					}else{
						uploader.disableBrowse(false);
					}
					var refId=uploader.settings.multipart_params.refId;
					var refType=uploader.settings.multipart_params.refType;
					refresh(refId,refType,id_);
				},
				/**
				 *  上传到后台前触发
					监听函数参数：(uploader,file)
					uploader为当前的plupload实例对象，file为触发此事件的文件对象
				 * */
				BeforeUpload:function(uploader,file){
					uploader.settings.multipart_params.pluploadId=file.id;//上传前重新赋值file.id
					
				},
				/**
				 *  当文件添加到上传队列后触发
					监听函数参数：(uploader,files)
					uploader为当前的plupload实例对象，files为一个数组，里面的元素为本次添加到上传队列里的文件对象
				 * */
				FilesAdded: function(uploader,files){
					var refId=uploader.settings.multipart_params.refId;
					var refType=uploader.settings.multipart_params.refType;
					plupload.each(files, function(file) {
				
						$(".list"+id_+"").append("" +
								"<tr id=\""+file.id+"\">" +
									"<td style=\"border: 0px;padding:3px 0;\">" +
										"<input type=\"hidden\" name=\"refId"+id_+"\" value=\""+refId+"\"/>" +
										"<input type=\"hidden\" name=\"refType"+id_+"\" value=\""+refType+"\"/>" +
										"<input type=\"hidden\" name=\"fileName"+id_+"\" value=\""+file.name+"\"/>" +
										"<input id=\""+file.id+"_i\" name=\"id"+id_+"\" type=\"checkbox\" value=\""+file.id+"\" />&nbsp;" +
										"<a id=\""+file.id+"_a\" onclick=\"download('"+file.id+"','"+uploading+"')\">"+file.name+"</a>" +
										"<span class=\"status\" style=\"margin-left:5px;\">"+file.status+"%</span>" +
									"</td>" +
								"</tr>");
						uploading=true;
						uploader.start();
					});
			},
				/**
				 *  当队列中的某一个文件上传完成后触发
					监听函数参数：(uploader,file,responseObject)
					uploader为当前的plupload实例对象，file为触发此事件的文件对象，responseObject为服务器返回的信息对象，它有以下3个属性：
					response：服务器返回的文本
					responseHeaders：服务器返回的头信息
					status：服务器返回的http状态码，比如200
				 * */
				FileUploaded:function(uploader,file,result){
					/*var status=result.status;
					if(status==200){
						var refId=uploader.settings.multipart_params.refId;
						var refType=uploader.settings.multipart_params.refType;
						refresh(refId,refType,id_);
					}*/
				},
				/**
				 *  会在文件上传过程中不断触发，可以用此事件来显示上传进度
					监听函数参数：(uploader,file)
					uploader为当前的plupload实例对象，file为触发此事件的文件对象
				 * */
				UploadProgress:function(uploader,file){
					$("#"+file.id).find(".status").html(file.percent+"%");
				}, 
				UploadComplete:function(uploader,files){
					var refId=uploader.settings.multipart_params.refId;
					var refType=uploader.settings.multipart_params.refType;
					refresh(refId,refType,id_);
					uploading=false;
				},
				/**
				 *  当发生触发时触发
					监听函数参数：(uploader,errObject)
					uploader为当前的plupload实例对象，errObject为错误对象，它至少包含以下3个属性(因为不同类型的错误，属性可能会不同)：
					code：错误代码，具体请参考plupload上定义的表示错误代码的常量属性
					file：与该错误相关的文件对象
					message：错误信息
				 * 
				 * */
				Error:function(uploader,errObject){
					var code=errObject.code;
					if(code==plupload.FILE_SIZE_ERROR){
						layerAlert("最大只能上传20M大小的文件！");
						return false;
					}
				}
			}
	};
	params_ = $.extend({}, defaults, params);//合并上传参数
	uploader = new plupload.Uploader(params_);//new plupload对象
	uploader.init();//初始化uploader对象
	return uploader;
}
/**
 * 是否选中一条数据
 */
function isCheck(id_) {
	var obj = window.document.getElementsByName("id"+id_);
	var num = 0;
	for (var i = 0; i < obj.length; i++) {
		if (obj[i].checked) {
			num++;
		}
	}
	if (num != 1) {
		layerAlert("请选择一个文件！");
		return false;
	}
	return true;
}
/**
 * 打开文件
 */
function openFile(id_) {
	if (isCheck(id_)) {
		var root=getRootPath();//项目根目录
		var fileId = check_val(id_);
		location.href = root+"/upload/download?fileId=" + fileId;
	}
}
/**
 * 获取选中数据
 */
function check_val(id_) {
	var obj = window.document.getElementsByName("id"+id_);
	var checked_val = "";
	for (var i = 0; i < obj.length; i++) {
		if (obj[i].checked) {
			checked_val = obj[i].value;
		}
	}
	return checked_val;
}
/**
 * 另存文件
 */
function saveAs(id_) {
	if (isCheck(id_)) {
		var root=getRootPath();//项目根目录
		var fileId = check_val(id_);
		location.href = root+"/upload/download?fileId=" + fileId;
	}
}
/**
 * 删除文件
 */
function del(id_) {
	var obj = window.document.getElementsByName("id"+id_);
	var num = 0;
	var fileIds = new Array();
	for (var i = 0; i < obj.length; i++) {
		if (obj[i].checked) {
			fileIds[num] = obj[i].value;
			num++;
		}
	}
	if (num < 1) {
		layerAlert("请选择文件！");
		return false;
	}
	var refId=$("input[name='refId"+id_+"']").val();
	var refType=$("input[name='refType"+id_+"']").val();
	if(refId==null||refId==""||!refId||refType==null||refType==""||!refType){
		return false;
	}
	var root=getRootPath();//项目根目录
	$.ajax({
		type : "POST",
		url : root+"/upload/delete",
		data : {
			refId:refId,
			refType:refType,
			fileIds : fileIds.join()
		},
		success : function(msg) {
			if ($.trim(msg) == "true") {
				refresh(refId,refType,id_);
			} else if ($.trim(msg) == "false") {
				layerAlert("操作失败！");
			}
		}
	});
}
/**
 * 弹出重命名模态框
 * @param id_
 */
function reName(id_){
	if (isCheck(id_)) {
		var fileId = check_val(id_);
		var fileName=$("input[name='fileName"+fileId+"']").val();
		$("#rename"+id_).val(fileName);
		$("#upload_rename"+id_).modal("show");
	}
}
/**
 * 确认重命名
 * @param id_
 */
function onReName(id_){
	if (isCheck(id_)) {
		var root=getRootPath();//项目根目录
		var fileId = check_val(id_);
		var fileNewName=$("#rename"+id_).val();
		$.ajax({
			type : "POST",
			url : root+"/upload/rename",
			data : {
				fileId : fileId,
				fileNewName:fileNewName
			},
			success : function() {
				var refId=$("input[name='refId"+id_+"']").val();
				var refType=$("input[name='refType"+id_+"']").val();
				if(refId==null||refId==""||!refId||refType==null||refType==""||!refType){
					return false;
				}
				refresh(refId,refType,id_);
				$("#upload_rename"+id_).modal("hide");
			}
		});
	}
}
/**
 * 上移下移
 */
function moveUpDown(upOrDown,id_) {
	var fileId = check_val(id_);
	var sort=$("input[name='sort"+fileId+"']").val();
	var refId=$("input[name='refId"+id_+"']").val();
	var refType=$("input[name='refType"+id_+"']").val();
	if (isCheck(id_)) {
		if ((upOrDown == 'up' && isTop(sort,id_))
				|| (upOrDown == 'down' && isDown(sort,id_))) {
			return;
		}
		var root=getRootPath();//项目根目录
		$.ajax({
			type : "POST",
			url : root+"/upload/moveUpOrDown",
			data : {
				refId : refId,
				refType : refType,
				sort : sort,
				status:upOrDown
			},
			success : function() {
				refresh(refId,refType,id_);
			}
		});
	}
}
/**
 * 是否是第一行
 */
function isTop(sort,id_) {
	$(".sort"+id_).each(function(index,val){
		if(index==0){
			if(sort==val.value){
				layerAlert("文件已经在第一行，不能继续上移！");
				return true;
			}
		}
	});
}
/**
 * 是否是最后一行
 */
function isDown(sort,id_) {
	$(".sort"+id_).each(function(index,val){
		if(index==($(".sort"+id_).length-1)){
			if(sort==val.value){
				layerAlert("文件已经在最后一行，不能继续下移！");
				return false;
			}
		}
	});
}
/**
 * @param id_ 上传控件id
 * @param parentDiv 父级div
 */
function initHTML(id_,parentDiv,pageType){
	var valid="";
	if(pageType=="view"){
		valid="disabled"
	}
	$("#"+parentDiv).append("" +
	//上传按钮组
	"<div class=\"panel-body\" >" +
		"<div class=\"btn-group\" role=\"group\" aria-label=\"...\" id=\"parent_"+id_+"\">" +
			"<button id=\"open\" type=\"button\"  class=\"btn btn-default\" style='margin-bottom:5px;' onclick=\"openFile('"+id_+"')\">" +
				"<i class=\"fa fa-external-link\"></i>&nbsp;打开" +
			"</button>" +
			"<button  id=\""+id_+"\" type=\"button\" "+valid+" style='margin-bottom:5px;' class=\"btn btn-default\">" +
				"<i class=\"fa fa-file-text\"></i>&nbsp;上传" +
			"</button>" +
			"<button id=\"resave\" type=\"button\" class=\"btn btn-default\" style='margin-bottom:5px;' onclick=\"saveAs('"+id_+"')\">" +
				"<i class=\"fa fa-floppy-o\"></i>&nbsp;另存" +
			"</button>" +
			"<button type=\"button\" class=\"btn btn-default\" style='margin-bottom:5px;' "+valid+" onclick=\"del('"+id_+"')\">"+
				"<i class=\"fa fa-trash-o\"></i>&nbsp;删除"+
			"</button>"+
			"<button type=\"button\" "+valid+" class=\"btn btn-default\" style='margin-bottom:5px;' onclick=\"reName('"+id_+"')\">"+
				"<i class=\"fa fa-pencil\"></i>&nbsp重命名"+
			"</button>"+
			"<button type=\"button\" "+valid+" class=\"btn btn-default\" style='margin-bottom:5px;' onclick=\"moveUpDown('up','"+id_+"')\">"+
				"<i class=\"fa fa-sort-up\"></i>&nbsp上移"+
			"</button>"+
			"<button type=\"button\" "+valid+" class=\"btn btn-default\" style='margin-bottom:5px;' onclick=\"moveUpDown('down','"+id_+"')\">"+
				"<i class=\"fa fa-sort-desc\"></i>&nbsp下移"+
			"</button>"+
		"<div>"+
		"<table cellSpacing=0 cellPadding=0 width=\"100%\" border=0 class=\"list"+id_+"\">"+
		"</table>"+
	"</div>"+
	//重命名模态框
	"<div class=\"modal fade\" id=\"upload_rename"+id_+"\" tabindex=\"-1\" role=\"dialog\" aria-labelledby=\"upload_rename\" aria-hidden=\"true\">"+
		"<div class=\"modal-dialog\">"+
			"<div class=\"modal-content\">"+
				"<div class=\"modal-header\" style=\"text-align:center\">"+
					"<button type=\"button\" class=\"close\" data-dismiss=\"modal\" aria-hidden=\"true\">×</button>"+
					"<h4 class=\"modal-title\" id=\"modal_look_title\" >重命名</h4>"+
				"</div>"+
				"<div class=\"modal-body\">"+
					"<div class=\"input-group\">"+
						"<span class=\"input-group-addon\" >文件名称</span>"+
						"<input type=\"text\" id=\"rename"+id_+"\" name=\"rename"+id_+"\" class=\"form-control\" placeholder=\"请输入文件的新名称\" >"+
					"</div>"+
				"</div>"+
				"<div class=\"modal-footer\" style=\"text-align: center;\">"+
					"<button type=\"button\" class=\"btn btn-primary\" id=\"onRename\" onclick=\"onReName('"+id_+"')\">保存</button>"+
					"<button type=\"button\" class=\"btn btn-primary\" data-dismiss=\"modal\">关闭</button>"+
				"</div>"+
			"</div>"+
		"</div>"+
	"</div>");
}
/**
 * 重新初始化文件信息
 * @param refId
 * @param refType
 * @param id_
 */
function refresh(refId,refType,id_){
	var root=getRootPath();//项目根目录
	if(refId&&refId!=null&&refId!=""&&refType&&refType!=null&&refType!=""){
		$.ajax({
			type: "POST",
			async: false,
			url: "upload/loadByRef",
			data: {refId:refId,refType:refType},
			success: function (list) {
				var rowData="";
				$(".list"+id_+"").html("");//先清空
				var filesName="";
				for(var i=0;i<list.length;i++){
					var fileEntity=list[i];
					//获取所有上传文件名称用于打印
					filesName=filesName+fileEntity.fileName+"<br>";
					$(".list"+id_+"").append("" +
						"<tr id=\""+fileEntity.fileId+"\">" +
							"<td style=\"border: 0px;padding:3px 0;\">" +
								"<input type=\"hidden\" name=\"refId"+id_+"\" value=\""+refId+"\"/>" +
								"<input type=\"hidden\" name=\"refType"+id_+"\" value=\""+refType+"\"/>" +
								"<input type=\"hidden\" name=\"fileName"+fileEntity.fileId+"\" value=\""+fileEntity.fileName+"\"/>" +
								"<input type=\"hidden\" class=\"sort"+id_+"\" name=\"sort"+fileEntity.fileId+"\" value=\""+fileEntity.sort+"\"/>" +
								"<input id=\""+fileEntity.fileId+"_i\" name=\"id"+id_+"\" type=\"checkbox\" value=\""+fileEntity.fileId+"\" />&nbsp;" +
								"<a id=\""+fileEntity.fileId+"_a\" href=\""+root+"/upload/download?fileId="+fileEntity.fileId+"\">"+fileEntity.fileName+"</a>" +
							"</td>" +
						"</tr>");
				}
				$("#fj").attr("value",filesName);
			}
		});
	}
}
function getFJName(refId,refType,id_){
	
}
/**
 * @param fileId 文件id
 * @param uploading 是否正在上传中
 * @returns {Boolean}
 */
function download(fileId,uploading){
	if(uploading){
		layerAlert("文件正在上传！");
		return true;
	}
	var root=getRootPath();
	$("#"+fileId+"_a").href=root+"/upload/download?fileId="+file.id;
	return false;
}
/**
 * 生成项目根目录
 * @returns
 */
function getRootPath(){  
    //获取当前网址，如： http://localhost:8083/uimcardprj/share/meun.jsp  
    var curWwwPath=window.document.location.href;  
    //获取主机地址之后的目录，如： uimcardprj/share/meun.jsp  
    var pathName=window.document.location.pathname;  
    var pos=curWwwPath.indexOf(pathName);  
    //获取主机地址，如： http://localhost:8083  
    var localhostPaht=curWwwPath.substring(0,pos);  
    //获取带"/"的项目名，如：/uimcardprj  
    var projectName=pathName.substring(0,pathName.substr(1).indexOf('/')+1);  
    return(localhostPaht+projectName);  
} 