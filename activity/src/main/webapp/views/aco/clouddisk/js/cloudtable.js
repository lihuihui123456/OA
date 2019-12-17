var selectionIds = [];
function formatSize(value){
	var B=1024;
	var KB=1024*1024;
	var MB=1024*1024*1024;
	var GB=1024*1024*1024*1024;
	if(value!=null&&value!=""){
		if(value<=B){
			return value+"B";
		}else if(value>B&&value<=KB){
			var reValue=(value/B).toFixed(2);
			if(reValue.substring(reValue.indexOf(".")+1)=="00"){
				reValue=(value/B).toFixed(0);
			}
			return reValue+"KB";
		}else if(value>KB&&value<=MB){
			var reValue=(value/KB).toFixed(2);
			if(reValue.substring(reValue.indexOf(".")+1)=="00"){
				reValue=(value/KB).toFixed(0);
			}
			return  reValue+"MB";
		}else if(value>MB&&value<=GB){
			var reValue=(value/MB).toFixed(2);
			if(reValue.substring(reValue.indexOf(".")+1)=="00"){
				reValue=(value/MB).toFixed(0);
			}
			return  reValue+"GB";
		}
	}else{
		return "0B";
	}
}
function initLogTable(init,folderId){
	initlog=1;
	var defaults={
		url:"clouddiskc/findLog",
		method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		sortable : true,
		sortOrder : "DESC",
		queryParams : function(params) {
			var temp = {
					rows : params.limit,
					page : params.offset,
					sortName : this.sortName,
					sortOrder : this.sortOrder,
//					folderId: LEFT_NODE.id,
					folderId:folderId
				};
				return temp;
		}, // 传递参数（*）
		sidePagination : "server",
		pageNumber : 1,
		pageSize : 5,
		pageList : [ 5,10, 25, 50, 100 ],
		search : false,
		strictSearch : false,
		showColumns : false,
		showRefresh : false,
		minimumCountColumns : 2,
		clickToSelect : false,
		uniqueId : "actId",
		showToggle : false,
		cardView : false,
		detailView : false,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id_, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ [ {
			checkbox : true
		},{
			field : 'act',
			title : '操作详情',
			width:'200px',
			align:'center'
		},{
			field : 'ts',
			title : '时间',
			width:'100px',
			cellStyle : cellStyle,
			align:'center'
		},{
			field : 'actUserName',
			title : '操作用户',
			width:'50px',
			align:'left'
		},] ],onClickRow:function(row,obj){
	      }
		
	};
	var init_ = $.extend({}, defaults, init);//合并上传参数
	$('#logList').bootstrapTable('destroy');
	$('#logList').bootstrapTable(init_);
}

function operateFormatter(value, row, index) {
    return [
		"<a title=\"文件详情\" style='color:#167495;' class=\"operation-icon fa fa-list contacts-star\"></a>",
    ].join('');
}
function operateFormatterShare(value, row, index) {
    return [
		"<a title=\"分享详情\" style='color:#167495;' class=\"operation-icon fa fa-share-alt contacts-star\"></a>",
    ].join('');
}
window.operateEvents = {
		'click .fa-list': function (e, value, row, index) {
			stopPropagation();
			setValue(row);
			$("#modal_detail").modal("show");
	    },
	    'click .downloadFileByName':function (e, value, row, index) {
			stopPropagation();
			if(row.fileType!="folder"){
				downloadOneFile(LEFT_NODE.id,row.fileId);
			}
	    },
	    'click .fa-share-alt':function (e, value, row, index) {
			stopPropagation();
			CLICK_ROW=row;
			initShareDetailTableByServer({},row);
			if(LEFT_NODE.fileattr=="MY_SHARE"){
				$("#onCancelShare").show();
			}else{
				$("#onCancelShare").hide();
			}
			$("#file_share_detail").modal("show");
	    },
};
function search(){
	var filters=$("#input-word").val();
	if(LEFT_NODE==null||LEFT_NODE.id==""||LEFT_NODE.id==null){
		return;
	}
	if(filters=="请输入文件名查询"){
		filters="";
	}else{
		filters = window.encodeURI(filters);
	}
	var params={parentFileId:LEFT_NODE.id,fileAttr:LEFT_NODE.fileattr};
	initTableByServer({},params,filters);
}
function formatIcon(type){
	var reValue;
	function tag(val){
		return "<i class=\"icon-file fa fa-"+val+"\"></i>";
	}
	switch(type)
	{
	case "png":
	case "jpg":
	case "jpeg":
	case "bmp":
		reValue= tag("photo");
		break;
	case "folder":
		reValue= tag("folder");
		break;
	case "zip":
	case "rar":
		reValue= tag("tasks");
		break;
	case "xls":
	case "xlsx":
		reValue= tag("file-excel-o");
		break;
	case "doc":
	case "docx":
		reValue= tag("file-word-o");
		break;
	case "txt":
		reValue=tag("file-powerpoint-o");
		break;
	case "pdf":
		reValue=tag("file-pdf-o");
		break;
	default:
		reValue= tag("file");
	}
	return reValue;
}
function initialAuths(auths){
	if(auths==null||auths==""){
		return "";
	}
	var authStr=auths.split(",");
	var icons="";
	for(var i=0;i<authStr.length;i++){
		icons+=setAuthIcon(authStr[i]);
	}
	return icons;
}
function setAuthIcon(authName){
	function setIcon(icon,title){
		return "<i title=\""+title+"\" class=\"console-icon fa "+icon+"\"></i>";
	}
	switch (authName) {
	case "onSee":
		return setIcon("fa-eye","查看权限");
		break;
	case "beforeAdd":
		return setIcon("fa-plus-square","新增文件夹权限");
		break;
	case "beforeRename":
		return setIcon("fa-pencil-square","重命名文件权限");
		break;
	case "onShowLog":
		return setIcon("fa-list","查看文件详情权限");
		break;
	case "buttonUpload":
		return setIcon("fa-upload","上传文件权限");
		break;
	case "btnDelete":
		return setIcon("fa-trash","删除文件权限");
		break;
	case "btnShareAuth":
		return setIcon("fa-cogs","更改文件权限");
		break;
	case "buttonDownload":
		return setIcon("fa-download","下载文件权限");
		break;
	default:
		return "";
		break;
	}
}
function setButtonAuth(authName,btn){
	switch (authName) {
	case "beforeAdd":
		btn.beforeAdd=true;
		break;
	case "beforeRename":
		btn.beforeRename=true;
		break;
	case "onShowLog":
		btn.onShowLog=true;
		break;
	case "buttonUpload":
		btn.buttonUpload=true;
		break;
	case "btnDelete":
		btn.btnDelete=true;
		break;
	case "btnShareAuth":
		btn.btnShareAuth=true;
		break;
	default:
		return btn;
		break;
	}
	return btn;
}
/**
 * @param init
 * @param filters 如{a=1,b=2}
 */
function initTableByServer(init,filters,orFilters){
	var defaults={
		url:"clouddiskq/queryFiles",
		method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		sortable : true,
		sortOrder : "DESC",
		queryParams : function(params) {
			var temp = {
					rows : params.limit,
					page : params.offset,
					sortName : this.sortName,
					sortOrder : this.sortOrder,
					filters: $.param(filters),
					orFilters:orFilters,
				};
				return temp;
		}, // 传递参数（*）
		sidePagination : "server",
		pageNumber : 1,
		pageSize : 10,
		pageList : [ 10, 25, 50, 100 ],
		search : false,
		strictSearch : false,
		showColumns : false,
		showRefresh : false,
		minimumCountColumns : 2,
		clickToSelect : false,
		uniqueId : "ID",
		showToggle : false,
		cardView : false,
		detailView : false,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id_, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ [ {
			checkbox : true
		}, {
			field : 'fileId',
			title : '序号',
			align:'center',
			visible:false
		},{
			field : 'fileName',
			title : '文件名',
			sortable : true,
			width:'30%',
			align:'left',
			events: operateEvents,
			formatter:function(value, row, index){
				if(row.fileType=="folder"){
					return "<span style='color:#ecc849;' class='downloadFileByName'>"+formatIcon(row.fileType)+"</span>"+value;
				}else{
					if(row.auths==null){
						return "<span style='color:#167495;' class='downloadFileByName' >"+formatIcon(row.fileType)+value+"</span>";
					}
					if(row.auths.indexOf("buttonDownload")!=-1){
						return "<span style='color:#167495;' class='downloadFileByName' >"+formatIcon(row.fileType)+value+"</span>";
					}else{
						return "<span>"+formatIcon(row.fileType)+value+"</span>";
					}
				}
			}
		},{
			field : 'fileSize',
			title : '文件大小',
			width:'20%',
			sortable : true,
			align:'left',
			formatter :  function(value, row, index) {
				if(row.fileType=="folder"){
					return '';
				}
				return formatSize(value);
			}
		},{
			field : 'fileOwnerName',
			title : '上传用户',
			align:'left',
			sortable : true,
			width:'15%',
			formatter :  function(value, row, index) {
				return value==null?"":value;
			}
		},{
			field : 'fileDate',
			title : '上传时间',
			cellStyle : cellStyle,
			align:'center',
			width:'20%',
			sortable : true,
			formatter :  function(value, row, index) {
				return value.substring(0,10);
			}
		},{
			field:'auths',
			title:'权限',
			width:"20%",
			align:'left',
			formatter:function(value,row,index){
				CLOUD_FILE_AUTH.push({fileId:row.fileId,fileAttr:row.fileAttr,fileAuths:row.auths});
				return initialAuths(row.auths);
			}
			
		}/*{
			field : 'fileOwnerName',
			title : '上传用户',
			align:'left',
			sortable : true,
			width:'15%',
			formatter :  function(value, row, index) {
				return value==null?"":value;
			}
		},{
			field : 'fileDate',
			title : '上传时间',
			cellStyle : cellStyle,
			align:'center',
			width:'20%',
			sortable : true,
			formatter :  function(value, row, index) {
				return value.substring(0,10);
			}
		},{
			field : 'fileCount',
			title : '下载次数',
			cellStyle : cellStyle,
			width:'15%',
			align:'center',
			sortable : true,
			formatter :  function(value, row, index) {
				return value==null?"":value;
			}
		}*/] ],onClickRow:function(row,obj){
			if(row.fileType=="folder"){
				loadFileDataByFolder(row);
				setButtonByFileId(row.fileId,row.fileAttr);
			}
		},onCheck:function(row,obj){
			setButtonByFileId(row.fileId,row.fileAttr,"clickCheckbox");
		},onUncheck:function(row,obj){
			setButtonByFileId(row.parentFileId,row.fileAttr);
		},onCheckAll:function(rows){
			if(rows.length==0){
				return false;
			}
			setButtonByFileId(rows[0].fileId,rows[0].fileAttr,"clickCheckbox");
		},onUncheckAll:function(rows){
			if(rows.length==0){
				return false;
			}
			setButtonByFileId(rows[0].parentFileId,rows[0].fileAttr);
		}
		
	};
	var init_ = $.extend({}, defaults, init);//合并上传参数
	$('#tableList').bootstrapTable('destroy');
	$('#tableList').bootstrapTable(init_);
}
var CLOUD_FILE_AUTH=new Array();
function initShareTableByServer(init,shareType,filters){
	var defaults={
		url:"cloudsharec/getShareFile",
		method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		sortable : true,
		sortOrder : "DESC",
		queryParams : function(params) {
			var temp = {
					rows : params.limit,
					page : params.offset,
					sortName : this.sortName,
					sortOrder : this.sortOrder,
					shareType:shareType,
				};
				return temp;
		}, // 传递参数（*）
		sidePagination : "server",
		pageNumber : 1,
		pageSize : 10,
		pageList : [ 10, 25, 50, 100 ],
		search : false,
		strictSearch : false,
		showColumns : false,
		showRefresh : false,
		minimumCountColumns : 2,
		clickToSelect : false,
		uniqueId : "ID",
		showToggle : false,
		cardView : false,
		detailView : false,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id_, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ [ {
			checkbox : true
		}, {
			field : 'fileId',
			title : '文件ID',
			width:'25px',
			align:'center',
			visible:false
		},{
			field : 'fileName',
			title : '文件名',
			sortable : true,
			width:'40%',
			align:'left',
			events: operateEvents,
			formatter:function(value, row, index){
				if(row.fileType=="folder"){
					return "<span style='color:#ecc849;' class='downloadFileByName'>"+formatIcon(row.fileType)+"</span>"+value;
				}else{
					return "<span style='color:#167495;' class='downloadFileByName' >"+formatIcon(row.fileType)+value+"</span>";
				}
			}
		},{
			field : 'fileSize',
			title : '文件大小',
			width:'10%',
			sortable : true,
			align:'center',
			formatter :  function(value, row, index) {
				if(row.fileType=="folder"){
					return '';
				}
				return formatSize(value);
			}
		},{
			field : 'fileCount',
			title : '下载次数',
			width:'10%',
			align:'center',
			formatter :  function(value, row, index) {
				return value==null?"":value;
			}
		},{
			field : 'fileType',
			title : '文件类型',
			visible:false,
		},{
			field : '',
			title : '分享详情',
			align:'center',
			width:'80px',
			events: operateEvents,
			formatter: operateFormatterShare,
		}] ],onClickRow:function(row,obj){
			if(row.fileType=="folder"){
				loadFileDataByFolder(row);
			}
		}
		
	};
	var init_ = $.extend({}, defaults, init);//合并上传参数
	$('#tableList').bootstrapTable('destroy');
	$('#tableList').bootstrapTable(init_);
}
function initShareDetailTableByServer(init,row){
	var defaults={
		url:"cloudsharec/getShareFileNotGroupBy",
		method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		sortable : true,
		sortOrder : "DESC",
		queryParams : function(params) {
			var temp = {
					shareType:LEFT_NODE.filetype,
					fileId: row.fileId,
					rows : params.limit,
					page : params.offset,
					sortName : this.sortName,
					sortOrder : this.sortOrder,
				};
				return temp;
		}, // 传递参数（*）
		sidePagination : "server",
		pageNumber : 1,
		pageSize : 10,
		pageList : [ 10, 25, 50, 100 ],
		search : false,
		strictSearch : false,
		showColumns : false,
		showRefresh : false,
		minimumCountColumns : 2,
		clickToSelect : true,
		uniqueId : "id",
		showToggle : false,
		cardView : false,
		detailView : false,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id_, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ [ {
			checkbox : true
		}, {
			field : 'id',
			title : '主键ID',
			visible:false
		},{
			field : 'fileId',
			title : '序号',
			width:'25px',
			align:'center',
			visible:false
		},{
			field : 'senderId',
			title : '分享用户ID',
			visible:false,
		},{
			field : 'senderName',
			title : '分享者',
			align:'left',
			sortable : true,
			width:'80px',
			formatter :  function(value, row, index) {
				return value==null?"":value;
			}
		},{
			field : 'receiverId',
			title : '分享用户ID',
			visible:false,
		},{
			field : 'receiverName',
			title : '分享对象',
			align:'left',
			sortable : true,
			width:'80px',
			formatter :  function(value, row, index) {
				return value==null?"":value;
			}
		},{
			field : 'shareTime',
			title : '分享时间',
			cellStyle : cellStyle,
			align:'center',
			width:'80px',
			sortable : true,
			formatter :  function(value, row, index) {
				return value.substring(0,19);
			}
		},] ],onClickRow:function(row,obj){
			if($("#hideValShare").val()==""||$("#hideValShare").val()==null){
				$("#hideValShare").val(row.fileId);
			}else{
				$("#hideValShare").val($("#hideValShare").val()+","+row.fileId);
			}
		}
	};
	var init_ = $.extend({}, defaults, init);//合并上传参数
	$('#tableShareList').bootstrapTable('destroy');
	$('#tableShareList').bootstrapTable(init_);
}
function setButtonByFileId(fileId,fileAttr,clickType){
	if(fileAttr=="PUBLIC"){
		var CAddFolder=$("#CAddFolder").is(":visible");//新建文件夹权限
		var CRename=$("#CRename").is(":visible");//重命名权限
		var CUploadFile=$("#CUploadFile").is(":visible");//上传权限
		var CDeleteFile=$("#CDeleteFile").is(":visible");//删除文件权限
		var CShowLog=$("#CShowLog").is(":visible");//详情列表权限
		var btn={beforeAdd:CAddFolder,beforeRename:CRename,buttonUpload:CUploadFile,btnDelete:CDeleteFile,buttonShare:false,onShowLog:CShowLog,btnShareAuth:true,packDownload:true};
		var checkRows=$('#tableList').bootstrapTable('getSelections');
		if(checkRows.length>0){
			for(var i=0;i<checkRows.length;i++){
				var perAuth=checkRows[i].auths;
				btn=setCheckSomeAuths(perAuth,btn);
			}
		}
		if(clickType=="clickCheckbox"){
			var btn_={
					beforeAdd:$("beforeAdd").is(":visible"),
					buttonUpload:$("buttonUpload").is(":visible"),
			}
			btn = $.extend({}, btn, btn_);//合并上传参数
		}
		initialButton(btn);
	}else if(fileAttr=="PRIVATE"){
		var btn={beforeAdd:true,beforeRename:true,buttonUpload:true,btnDelete:true,buttonShare:true,onShowLog:true,btnShareAuth:false};
		initialButton(btn);
	}else if(fileAttr=="SHARE"||fileAttr=="MY_SHARE"){
		var btn={beforeAdd:false,beforeRename:false,buttonUpload:false,btnDelete:false,buttonShare:false,onShowLog:false,btnShareAuth:false};
		initialButton(btn);
	}
}
function setCheckSomeAuths(authJson,btn){
	if(authJson==null||authJson==""){
		return btn;
	}
	if(authJson.indexOf("beforeAdd")==-1){
		btn.beforeAdd=false;
	}
	if(authJson.indexOf("beforeRename")==-1){
		btn.beforeRename=false;
	}
	if(authJson.indexOf("buttonUpload")==-1){
		btn.buttonUpload=false;
	}
	if(authJson.indexOf("btnDelete")==-1){
		btn.btnDelete=false;
	}
	if(authJson.indexOf("buttonShare")==-1){
		btn.buttonShare=false;
	}
	if(authJson.indexOf("onShowLog")==-1){
		btn.onShowLog=false;
	}
	if(authJson.indexOf("btnShareAuth")==-1){
		btn.btnShareAuth=false;
	}
	if(authJson.indexOf("buttonDownload")==-1){
		btn.packDownload=false;
	}
	return btn;
}