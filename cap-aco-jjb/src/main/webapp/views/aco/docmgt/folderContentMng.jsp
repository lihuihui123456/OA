<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>个人文件夹</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">

<link
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css"
	rel="stylesheet">
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.exedit-3.5.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.js"></script>
<link rel="stylesheet" type="text/css"
	href="${ctx}/views/aco/docmgt/css/zTreeRightClick.css" />
<script src="${ctx}/views/aco/docmgt/js/zTreeRightClick.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
  <script src="${ctx}/views/aco/docmgt/js/plupload.full.min.js"></script>
  
<script type="text/javascript">
var userId="${userId}";
var chooseNode="";
var unitFold="0000";
var deptFold="3000";
var mainFold="7000";
var shareFold="6000";
var doc_type=1;
var selectionIds = [];//记忆选中
var setting = {
	data: {
		simpleData: {
			enable: true,
			idKey: "id",
			pIdKey: "pId",
			rootPId: 0
		}
	},
	callback:{
		onClick:zTreeOnClick,
		onRightClick: OnRightClick,
	}
};
$(function(){
	
	
	
	//回车查询
	$('#input-word').keydown(function(event){ 
		if(event.keyCode==13){ 
			search();
		} 
	}); 
	
});	

function zTreeOnClick(event,treeId,treeNode){
	chooseNode=treeNode.id;
	$("#input-word").val("请输入文件名查询");
	showAndhiddenButton(chooseNode.substr(0,4));
	if(chooseNode==shareFold){
		$("#folderContent th").each(function(){
			if($(this).attr("data-field")=="uploadTime"){
				$(this).find(".th-inner ").text("共享时间");
			}
		});
	}else{
		$("#folderContent th").each(function(){
			if($(this).attr("data-field")=="uploadTime"){
				$(this).find(".th-inner ").text("上传时间");
			}
		});
	}
	$("#folderContent").bootstrapTable('refresh');
}
//共享文件夹隐藏按钮上传和删除文件  
function showAndhiddenButton( chooseNodeId){
	var isShare=false;
	if(chooseNodeId==shareFold){
		$("#btn_upload").hide();
		$("#btn_delete").hide();
	}else if(chooseNodeId==unitFold||chooseNodeId==deptFold){
		var admin_role=$("#r_add").is(":visible");
		if(admin_role){
			$("#btn_upload").show();
			$("#btn_delete").show();
		}else{
			$("#btn_upload").hide();
			$("#btn_delete").hide();
		}
	}else{
		$("#btn_upload").show();
		$("#btn_delete").show();
	}
}

//增加节点
function addTreeNode() {
	hideRMenu();
	$("#folder_name_").val("");
	$("#nodeModal").modal("show");
	//$('#newnode').attr("src","${ctx}/docmgt/toNewNodeInfo");
}
function modifyTreeNode() {
	hideRMenu();
	var id=zTree.getSelectedNodes()[0].id;
	if(id==mainFold){
		layerAlert("不能修改主目录！");
		return false;
	}
	if(id==shareFold){
		layerAlert("不能修改共享文件！");
		return false;
	}
	var name_=zTree.getSelectedNodes()[0].name;
	$("#folder_name_m").val(name_);
	$("#nodeModalModify").modal("show");
}
function modifyFolderInfo(){
	var id=zTree.getSelectedNodes()[0].id;
	var AjaxURL= "${ctx}/docmgt/modifyFolder";
	var name=$("#folder_name_m").val();
	if(name==null||name==""){
		layerAlert("节点名称不能为空！");
		return false;
	}
	$.ajax({
		type: "POST",
		url: "${ctx}/docmgt/doCheckFolderRepat",
		data: {folderId:id,folderName:name},
		success: function (reId) {
			if(reId=='Y'){
				layerAlert("名称重复！");
				return false;
			}else{
				$.ajax({
					type: "POST",
					url: AjaxURL,
					data: {folderId:id,folderName:name},
					success: function () {
					}
				});
			    if (zTree.getSelectedNodes()[0]) {
			    	zTree.getSelectedNodes()[0].name=name;
			    	zTree.updateNode(zTree.getSelectedNodes()[0]);
			    }
				$("#nodeModalModify").modal("hide");
				 layer.msg("修改节点成功!",{icon:1});
			}
			}
		});
}
//保存节点信息
function saveFolderInfo(){
	$('#folderContent').bootstrapTable('refresh');
	var name=$("#folder_name_").val();
	var id=zTree.getSelectedNodes()[0].id;
	var AjaxURL= "${ctx}/docmgt/addFolder";
	var flag=false;
	if(name==null||name==""){
		layerAlert("节点名称不能为空！");
		return false;
	}
	$.ajax({
		type: "POST",
		url: "${ctx}/docmgt/doCheckFolderName",
		data: {folderId:id,folderName:name},
		success: function (reId) {
			if(reId=='Y'){
				layerAlert("名称重复！");
				return false;
			}else{
				$.ajax({
					type: "POST",
					url: AjaxURL,
					data: {parentFolderId:id,folderName:name},
					success: function (reId) {
						id=reId;
						if(name!=""&&name!=null){
							var newNode = {name:name,id:id};
							if (zTree.getSelectedNodes()[0]) {
								newNode.checked = zTree.getSelectedNodes()[0].checked;
								zTree.addNodes(zTree.getSelectedNodes()[0], newNode);
							} else {
								zTree.addNodes(null, newNode);
							}
						}
						$("#nodeModal").modal("hide");
						layer.msg("新增节点成功!",{icon:1});
					},
					error: function(){
					    alert(arguments[1]);
					}
				});
			}
		}
		});
	
}
function deleteTreeNodeBefore(){
	hideRMenu();
	var id=zTree.getSelectedNodes()[0].id;
	if(id==mainFold||id==shareFold||id==unitFold||id==deptFold){
		layerAlert("不能删除主目录！");
		return false;
	}
	$.ajax({
		type: "POST",
		url: "${ctx}/docmgt/doDelFolder",
		data: {folderId:id},
		success: function (reId) {
			if(reId=='Y'){
				layerAlert("包含子节点,不能删除！");
				return false;
			}else{
			$.ajax({
		type: "POST",
		url: "${ctx}/docmgt/doFolderDel",
		data: {folderId:id},
		success: function (reId) {
			if(reId=='Y'){
				layerAlert("包含上传文件,不能删除！");
				return false;
			}else{
				layer.confirm('确定删除节点？',{
					 btn: ['确定','取消'], //按钮
				},function(index){
					deleteTreeNode(id);
					layer.close(index);
					$("#folderContent").bootstrapTable('refresh');
				});
			}
		}
	});
			}
		}
	});
	
}

var zTree, rMenu,rMenuForRole;
//删除节点
function deleteTreeNode(id){
	
	var AjaxURL= "${ctx}/docmgt/deleteFolder";
	$.ajax({
		type: "POST",
		url: AjaxURL,
		data: {folderId:id},
		success: function () {
			
		}
	});
	
    //选中节点  
    var nodes = zTree.getSelectedNodes();  
	var l;
    for (var i=0,l=nodes.length; i < l; i++)   
    {  
        //删除选中的节点  
        zTree.removeNode(nodes[i]);  
    }  
	$("#nodeModal").modal("hide");
	layer.msg("删除节点成功!",{icon:1});
}
$(document).ready(function() {
	
	/**
	    * 选中事件操作数组  
	    */
	    var union = function(array,ids){  
	        $.each(ids, function (i, id_) {  
	            if($.inArray(id_,array)==-1){  
	                array[array.length] = id_;  
	            }  
	        });  
	         return array;  
		};
	/**
	     * 取消选中事件操作数组 
	     */ 
	    var difference = function(array,ids){  
	            $.each(ids, function (i, id_) {  
	                 var index = $.inArray(id_,array);  
	                 if(index!=-1){  
	                     array.splice(index, 1);  
	                 }  
	             });  
	            return array;  
	};    
	var _ = {"union":union,"difference":difference};

	/**
		 * bootstrap-table 记忆选中 
		 */
		$('#folderContent').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
			var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
	            return row.id_;  
	        });  
	        func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	        selectionIds = _[func](selectionIds, ids);   
	});
	
	
	//ztree初始化
	$.fn.zTree.init($("#folderTree"), setting,${treeList});
	zTree = $.fn.zTree.getZTreeObj("folderTree");
	//默认展开树节点
	var nodes = zTree.getNodes();
	for (var i = 0; i < nodes.length; i++) { //设置节点展开
	     if(nodes[i].pId=="0000"){
	     zTree.expandNode(nodes[i], true, false, false);
	     }		
	}
	rMenu = $("#rMenu");
	rMenuForRole=$("#rMenuForRole");
	//bootstrapTable初始化
	$('#folderContent').bootstrapTable({
		url : '${ctx}/docmgt/findFolderContent',
		method : 'get', // 请求方式（*）
/* 		toolbar : '#toolBar', // 工具按钮用哪个容器
 */		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				folder_id_: chooseNode,
				doc_type : doc_type,
				folder_name_:$("#input-word").val()=="请输入文件名查询"?"":$("#input-word").val()
			};
			return temp;
		}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		//strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "id_", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id_, selectionIds) !== -1;
			});
			return res;	
		},
		columns : [ 
 			 {
			field : 'checkStatus',
			checkbox : true
		}, 
 		    { field : 'Number', title: '序号',width:'10%',
 				align: 'center',
 		    	formatter: function (value, row, index) {
                    return index+1;
                },
                width:'45px'
 		    }, 
 		   { 
 		    	field : '', 
 		    	title : '<center>文件名</center>',
 		    	width:'60%',
 		    	formatter:function(value,row){
 		    		if(row.folderId==6000){//分享的可以下载
	 				return '<a style="word-break:break-all" href="${ctx}/downLoadMedia/downloadMedia?id='+row.id_+'">'+row.fileName+'</a>';
					}else{//公共目录
						if(row.folderId!=00000002){//规章制度不是本人上传不能下载，只能查看
			 				return '<a style="word-break:break-all" href="${ctx}/downLoadMedia/downloadMedia?id='+row.id_+'">'+row.fileName+'</a>';
						}else{
						//判断是否是本人
						if(userId==row.uploadUserId){
	 						return '<a style="word-break:break-all" href="${ctx}/downLoadMedia/downloadMedia?id='+row.id_+'">'+row.fileName+'</a>';
						}else{
	 						return '<span style="word-break:break-all"  onclick="viewFile('+"'"+row.fileType+"'"+','+"'"+row.filePath+"'"+','+"'"+row.fileId+"'"+')">'+row.fileName+'</span>';	
						}}
					}
 				}
 		    },
 		    { field : '', title : '上传人员',align: 'center',width:'10%',
 		    	formatter:function(value,row){
					if(row.folderId==6000){
						return row.shareUserName;
					}else{
						return row.uploadUserName;
					}
				}
 		    }, 
 		    { field : 'uploadTime', title : '上传时间',align: 'center',width:'20%',
 		    	formatter:function(value,row){
					if(row.folderId==6000){
						return row.shareTime;
					}else{
						return row.uploadTime;
					}
				}}
 		]
	});
});
function viewFile(fileType,mFilePath,mFileName){
	var myDate = new Date();
	var text="";
	var operateUrl="";
	var id=myDate.getTime(); 
	if(fileType==".doc"||fileType==".docx"){
		text="查看word";
	 operateUrl = "onlineViewController/openWordDocument?mFilePath="+mFilePath  + "&mFileName=" + mFileName + "&mRecordID=" + mFileName+"&fileType=" + fileType;

	}else if(fileType==".xls"||fileType==".xlsx"){
		 text="查看Excel";
		 operateUrl = "onlineViewController/openWordDocument?mFilePath="+mFilePath  + "&mFileName=" + mFileName + "&mRecordID=" + mFileName+"&fileType=" + fileType;

	}else if(fileType==".pdf"){
		 text="查看pdf";
		 operateUrl = "onlineViewController/openPdfDocument?mFilePath="+mFilePath  + "&mFileName=" + mFileName + "&mRecordID=" + mFileName+"&fileType=" + fileType;
	
	}else if(fileType==".png"||fileType==".jpg"){
		 text="查看图片";
		 operateUrl = "onlineViewController/openPhotoDocument?mFilePath="+mFilePath  + "&mFileName=" + mFileName +"&fileType=" + fileType;
	
	}else{
		return;
	}
		var options = {
			"text" : text,
			"id" : "view"+id,
			"href" : operateUrl,
			"pid" : window,
			"isDelete":true,
			"isReturn":true,
			"isRefresh":true
		};
		window.parent.parent.createTab(options);
}
function deleteFile(id){
	var AjaxURL= "${ctx}/docmgt/deleteFile";
	$.ajax({
		type: "POST",
		url: AjaxURL,
		data: {id:id},
		success: function () {
			 layer.msg("删除成功!",{icon:1});
			$('#folderContent').bootstrapTable('refresh');
		}
	});
}
function search() {
	$("#folderContent").bootstrapTable('refresh');
}

//查询正文和附件信息
function findMediaInfo(){
	var obj = $('#folderContent').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
		layerAlert("请选择一条数据");
		return false;
	}else{
		var docInfoId = obj[0].id;
		$('#myModal').modal('show');
		$('#media').attr("src","${ctx}/docmgt/toLoadMediaList?docInfoId="+docInfoId);
	}
}

function changeType(){
	doc_type=$("#changeType").val();
	$('#folderContent').bootstrapTable('refresh');
}
var parent_url="";
function getParentUrl(){
	return parent_url;
}
function uploadFile(){
	if(chooseNode==""||chooseNode==null){
		layerAlert("请选择文件夹");
		return false;
	}
	var id=zTree.getSelectedNodes()[0].id;
	if(id==shareFold){
		layerAlert("不能上传到共享文件夹!");
		return false;
	}
	//释放but触发点击事件
    document.getElementById("btn_upload").click();
	$("#btn_upload").click();
	hideRMenu();
	var chunk=false;
	var url = "${ctx}/docmgt/docUpload?chooseNode="+chooseNode;
	parent_url=url;
	/* var resultStr = window.showModalDialog("${ctx}/docmgt/index?chunk="+chunk+"&url="+url,
			window,"dialogWidth:500px; dialogHeight: 310px; help: no; scroll: no; status: no"); */
	//$("#iframe_upload").attr("src",ctx+"/views/aco/docmgt/fileUpload.jsp");
	//$("#modal_upload").modal("show");

}
$(function(){
	var url = '';
	if(url == '' || url == null){
		url ="${ctx}/docmgt/docUpload";
	}
	uploadfile(url,"btn_upload");
});
function BeforeUploadFunc(up, file){
	if(chooseNode==""||chooseNode==null){
		layerAlert("请选择文件夹");
		return false;
	}
	var id=zTree.getSelectedNodes()[0].id;
	if(id==shareFold){
		layerAlert("不能上传到共享文件夹!");
		return false;
	}
	hideRMenu();
	var url = "${ctx}/docmgt/docUpload?chooseNode="+chooseNode;
	parent_url=url;
	uploader.settings.multipart_params.chooseNode=chooseNode;
}
var uploader;
function uploadfile(url,butId){
	var root=getRootPath();//项目根目录
	 uploader = new plupload.Uploader({
		        // General settings
		        runtimes : 'flash,html4,html5',
				browse_button :butId, // you can pass in id...
		        url : url,
		        unique_names : true  ,
		        filters : {
		            max_file_size : '20mb'
		        },
		// container:"mycontainer", //容器的地址
		multipart:true,
		multipart_params:{},
		flash_swf_url : root+'/views/aco/upload/js/Moxie.swf',//flash上传组件的url地址，如果是相对路径，则相对的是调用Plupload的html文档。当使用flash上传方式会用到该参数。
		silverlight_xap_url : root+'/views/aco/upload/js/Moxie.xap',
		  
		        // PreInit events, bound before the internal events
		        preinit : {
		            Init: function(up, info) {
		                log('[Init]', 'Info:', info, 'Features:', up.features);
		            },
		 
		            UploadFile: function(up, file) {
		                log('[UploadFile]', file);
		 
		                // You can override settings before the file is uploaded
		                // up.setOption('url', 'upload.php?id=' + file.id);
		                // up.setOption('multipart_params', {param1 : 'value1', param2 : 'value2'});
		            }
		        },
		 
		        // Post init events, bound after the internal events
		        init : {
					PostInit: function() {
						// Called after initialization is finished and internal event handlers bound
			/* 			log('[PostInit]');
						
						document.getElementById('uploadfiles').onclick = function() {
							uploader.start();
							return false;
						}; */
					},

					Browse: function(up) {
		                // Called when file picker is clicked
		                log('[Browse]');
		            },

		            Refresh: function(up) {
		                // Called when the position or dimensions of the picker change
		                log('[Refresh]');
		            },
		 
		            StateChanged: function(up) {
		                // Called when the state of the queue is changed
		                log('[StateChanged]', up.state == plupload.STARTED ? "STARTED" : "STOPPED");
		            },
		 
		            QueueChanged: function(up) {
		                // Called when queue is changed by adding or removing files
		                log('[QueueChanged]');
		            },

					OptionChanged: function(up, name, value, oldValue) {
						// Called when one of the configuration options is changed
						log('[OptionChanged]', 'Option Name: ', name, 'Value: ', value, 'Old Value: ', oldValue);
					},
					BeforeChunkUpload:function(uploader,file,POST,current,current){					
					},
		 			BeforeUpload:BeforeUploadFunc,
		            UploadProgress: function(up, file) {
		                // Called while file is being uploaded
		                log('[UploadProgress]', 'File:', file, "Total:", up.total);
		            },

					FileFiltered: function(up, file) {
						// Called when file successfully files all the filters
		                log('[FileFiltered]', 'File:', file);
					},
		 
		            FilesAdded: function(up, files) {
			             uploader.start();
		            },
		 
		            FilesRemoved: function(up, files) {
		                // Called when files are removed from queue
		                log('[FilesRemoved]');
		 
		                plupload.each(files, function(file) {
		                    log('  File:', file);
		                });
		            },
		 
		            FileUploaded: function(up, file, info) {
		                // Called when file has finished uploading
		                log('[FileUploaded] File:', file, "Info:", info);
		            },
		 
		            ChunkUploaded: function(up, file, info) {
		                // Called when file chunk has finished uploading
		                log('[ChunkUploaded] File:', file, "Info:", info);
		            },

					UploadComplete: function(up, files) {
						$('#folderContent').bootstrapTable('refresh');
					},

					Destroy: function(up) {
						// Called when uploader is destroyed
		                log('[Destroy] ');
					},
		 
		            Error: function(up, args) {
		                // Called when error occurs
		                log('[Error] ', args);
		            }
		        }
		    });


			uploader.init();
}
function log() {

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
function closeUploadModal(){
	$("#modal_upload").modal("hide");
	$('#folderContent').bootstrapTable('refresh');
}
//文件发布给指定用户
var folderIds=new Array();
function releaseFileValidation(){
	if(chooseNode==""||chooseNode==null){
		layerAlert("请选择数据");
		return false;
	}
	var obj = $('#folderContent').bootstrapTable('getSelections');
	if (obj.length=='') {
		layerAlert("请选择数据");
		return false;
	}else{
		for(var i=0;i<obj.length;i++){
			folderIds[i] = obj[i].id_;
		}
		chooseUserUrl = "treeController/zMultiPurposeContacts?state=1";
		choseUser(chooseUserUrl);
	}
	
}
//弹出选择办理人窗口
function choseUser(chooseUserUrl) { 
	$("#chooseUser_iframe").attr("src",chooseUserUrl);
 	$("#chooseUserDiv").modal('show');
}
//选人确定按钮
function makesure() {
	var arr = document.getElementById("chooseUser_iframe").contentWindow
			.doSaveSelectUser();
	var userName = arr[1];
	var userId = arr[0];
	$('#chooseUserDiv').modal('hide');
	for(var i=0;i<folderIds.length;i++){
		releaseFileStart(userId,folderIds[i]);
	}
	//layer.msg("共享成功");
}
//共享
function releaseFileStart(userId,folderId){
	//赋值方法
	var AjaxURL = "docmgt/shareFile";
	$.ajax({
		type: "POST",
		url: AjaxURL,
		dataType:"json",
		data: {docInfoId:folderId,userId:userId,shareFold:shareFold},
		success: function (data) {
			 if(data.result=='1'){
				layerAlert("共享成功");
			}
		},
		error: function(data) {
			return false;
		}
	});
}
function deleteUploadFile(){
	if(chooseNode==""||chooseNode==null){
		layerAlert("请选择一条数据");
		return false;
	}
	var obj = $('#folderContent').bootstrapTable('getSelections');
	var id=zTree.getSelectedNodes()[0].id;
	if(id==shareFold){
		layerAlert("不能删除共享文件!");
		return false;
	}
	if (obj.length=='') {
		layerAlert("请选择一条数据");
		return false;
	}else if(obj.length>1){
		layer.confirm('确定删除文件？',{
			 btn: ['确定','取消'], //按钮
			 shade: false //不显示遮罩
		},function(index){
			for(var i=0;i<obj.length;i++){
				folderId = obj[i].id_;
				deleteFile(folderId);
			}
		});
	}else{
		layer.confirm('确定删除文件？',{
			 btn: ['确定','取消'], //按钮
			 shade: false //不显示遮罩
		},function(index){
			folderId = obj[0].id_;
			deleteFile(folderId);
		});
	}
}
function cancel(divName){
	$("#"+divName).modal("hide");
}
</script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="background:#f2f4f8;">
<input type="hidden" id="privateVal"/>
	<div id="rMenu">
		<ul>
			<li id="m_add" onclick="addTreeNode();">增加节点</li>
			<li id="m_modify" onclick="modifyTreeNode();">修改节点</li>
			<li id="m_delete" onclick="deleteTreeNodeBefore();">删除节点</li>
			<!--  <li id="m_upload" onclick="uploadFile();">上传文件</li>-->

		</ul>
	</div>
	<div id="rMenuForRole">
		<ul>
			<shiro:hasPermission name="add:docmgt:toFolderContentTree">
				<li id="r_add" onclick="addTreeNode();">增加节点</li>
			</shiro:hasPermission>
			<shiro:hasPermission name="modify:docmgt:toFolderContentTree">
				<li id="r_modify" onclick="modifyTreeNode();">修改节点</li>
			</shiro:hasPermission>
			<shiro:hasPermission name="delete:docmgt:toFolderContentTree">
				<li id="r_delete" onclick="deleteTreeNodeBefore();">删除节点</li>
			</shiro:hasPermission>
		</ul>
	</div>
	<div class="container-fluid content">
		<!-- start: Main Menu -->
		<div class="sidebar " >
			<div class="sidebar-collapse" style="height:100%">
				<div id="sidebar-menu" class="sidebar-menu" style="height:100%;overflow:auto;" >
					<ul id="folderTree" class="ztree"></ul>
				</div>
			</div>
		</div>
		<!-- end: Main Menu -->
		<!-- start: Content -->
		<div class="main" id="main">
			<div id="search_div"
				style="width: 300px; float: right; padding-bottom: 10px;padding-top: 10px;">
				<div class="input-group">
					<input type="text" id="input-word" class="form-control input-sm"
						value="请输入文件名查询" onFocus="if (value =='请输入文件名查询'){value=''}"
						onBlur="if (value ==''){value='请输入文件名查询'}"> <span
						class="input-group-btn">
						<button type="button" class="btn btn-primary btn-sm"
							style="margin-right: 0px" onclick="search()">
							<i class="fa fa-search"></i> 查询
						</button>
					</span>
				</div>
			</div>
			<div id="btn-div">
				<div id="toolbar" class="btn-group" style="margin-top:10px;">
					<button id="btn_release" type="button"
						class="btn btn-default btn-sm" onclick="releaseFileValidation()">
						<span class="fa fa-share-square-o" aria-hidden="true"></span> 分享
					</button>
<!-- 					<button id="btn_upload" type="button" class="btn btn-default btn-sm"
						onclick="uploadFile()">
						<span class="fa fa-upload" aria-hidden="true"></span> 上传文件
					</button> -->
						<button id="btn_upload" type="button" class="btn btn-default btn-sm">
						<span class="fa fa-upload" aria-hidden="true"></span> 上传文件
					</button>
					<button id="btn_delete" type="button" class="btn btn-default btn-sm"
						onclick="deleteUploadFile()" >
						<span class="fa fa-times" aria-hidden="true"></span> 删除文件
					</button>
				  <!-- <div id="mycontainer"></div>	 -->
			</div>
			<table id="folderContent"></table>
		</div>
		<!-- end: Content -->
		<!--/container-->
	</div>
	<!-- 节点新增 -->
	<div class="modal fade" id="nodeModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="nodeModalLabel">新增节点</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<input type="text" id="folder_name_" name="folder_name_" value=""
							class="form-control" />
					</div>
					<div class="modal-footer" style="text-align: center;">
						<button type="button" class="btn btn-primary"
							onclick="saveFolderInfo()">保存</button>
						<button type="button" class="btn btn-primary"
							onclick="cancel('nodeModal')">取消</button>
					</div>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<div class="modal fade" id="nodeModalModify" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="nodeModalLabel">修改节点</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<input type="text" id="folder_name_m" name="folder_name_m"
							value="" class="form-control" />
					</div>
					<div class="modal-footer" style="text-align: center;">
						<button type="button" class="btn btn-primary"
							onclick="modifyFolderInfo()">保存</button>
						<button type="button" class="btn btn-primary"
							onclick="cancel('nodeModalModify')">取消</button>
					</div>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- 选择人员 -->
	<div class="modal fade" id="chooseUserDiv" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="c">人员选择</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="chooseUser_iframe" runat="server" src="" width="100%"
							height="450" frameborder="no" border="0" marginwidth="0"
							marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
					</div>
					<div class="modal-footer" style="text-align: center;">
						<button type="button" class="btn btn-primary btn-sm" onclick="makesure()">确认</button>
						<button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
					</div>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	 <div class="modal fade" id="modal_upload" tabindex="-1" role="dialog" 
	aria-labelledby="modal_upload" aria-hidden="true" data-backdrop="static" data-keyboard="false">
	<div class="modal-dialog">
		<div class="modal-content">
			 <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">×</button>
				<h4 class="modal-title" id="modal_detail_title">上传文件</h4>
				
			</div> 
			<div class="modal-body">
			 <div id="uploader">&nbsp;</div>
				<iframe width="100%" height="310px"src="" id="iframe_upload" frameborder="0" scrolling="no"></iframe>
			</div>
		</div>
	</div>
</div> 
	<div class="clearfix"></div>
</body>
<style type="text/css">


.sidebar {
	position: fixed;
	z-index: 11;
	top: 10px;
	width: 300px;
	background-color: #fff;
	border: 1px solid #ddd;
	padding-bottom: 10px;
}

.sidebar .sidebar-menu {
	width: 300px;
}

.main {
	padding: 0;
	padding-left: 300px;
}

.dept_post_tree {
	font-size: 14px;
	overflow-y: auto;
}

.dept_post_tree a {
	font-size: 14px;
	padding-left: 5px;
}

.dept_post_tree li:hover {
	background-color: #fcf1f1 !important;
	color: #576069 !important;
}

.dept_post_tree li.node-selected {
	background-color: #fcf1f1 !important;
	color: #576069 !important;
}

.node-dept_post_tree {
	border-width: 0 !important;
	background-color: #fff !important;
	color: #576069 !important;
}

.list-group-item {
	padding: 10px;
}

.tablepic td {
	border: 1px #becedb solid;
	padding: 5px;
}

.tablepic th {
	background: #eff0f5;
	border: 1px #becedb solid;
}

.bmw {
	background: #f8f9fd;
}
.modal-body {
    padding: 0;
}
</style>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>