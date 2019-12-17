$(document).ready(function(){
	/**
	 * 弹出新增文件夹模态框
	 * 根据文件类型：公共文件夹/个人文件夹打开
	 */
	$("#beforeAdd").click(function(){
		$("#input_add").val("");//清空输入框
		$("#input_add_pub").val("");//清空输入框
		$("#authority_users").val("");//清空权限
		$("#modal_add").modal("show");
	});
	/**
	 * 新增文件夹
	 */
	$("#onAdd").click(function(){
		var folderName=$("#input_add").val();//从输入框获取文件夹名
		var authority_users_id=$("#authority_users_id").val();//权限 格式:xxx,xxx,xxx
		if(!LEFT_NODE||folderName==null||folderName==""){
			return;
		}
		$.ajax({
			type: "POST",
			async: false,
			url: "clouddiskc/beforeAddFolder",
			data: {folderName:folderName,//文件夹名
			 	parentFolderId:LEFT_NODE.id},//父ID
			success: function (result) {
				var obj = eval("("+result+")");
				if(obj.status==true){
					$.ajax({
						type: "POST",
						async: false,
						url: "clouddiskc/addFolder",
						data: { folderName:folderName,//文件夹名
							 	parentFolderId:LEFT_NODE.id,//父ID
							 	filetype:LEFT_NODE.filetype,//文件类型
							 	fileAttr:LEFT_NODE.fileattr,
							 	authorityUserId:authority_users_id
							 	},//权限
						success: function (data) {
							var newNode = {name:folderName,
									id:data.fileId,
									filetype:data.fileType,
									fileattr:data.fileAttr,
									editable:data.isDownload,
									authorityUserId:data.fileOwnerId,
									iconSkin:"folder-o"};
							zTree.addNodes(LEFT_NODE, newNode);
							refreshTableList();
							$("#modal_add").modal("hide");//关闭模态框
						}
					});
				}else{
					layerAlert("文件夹名称不能重复");
				}
			}
		});
	});
	/**
	 * 弹出详情列表模态框
	 */
	$("#onShowLog").click(function(){
		var obj = $('#tableList').bootstrapTable('getSelections');
		if(obj.length==0||obj.length>1){
			layerAlert("请选择一条数据");
			return;
		}
		$.ajax({
			type: "POST",
			async: false,
			url: "clouddiskc/findByFileId",
			data: {fileId:obj[0].fileId},
			success: function (datas) {
				if(datas.length>0){
					data=datas[0];
					$("#log-fileName").text(data.fileName);
					$("#log-fileSize").text(formatSize(data.fileSize));
					$("#log-fileOwnerName").text(data.fileOwnerName);
					$("#log-fileDate").text(data.fileDate);
					$("#log-fileCount").text(data.fileCount);
					$("#log-fileAuth").html(initialAuths(obj[0].auths));
					initLogTable({},data.fileId);
					$("#modal_log").modal("show");
				}
			}
		});
		
	});
	/**
	 * 弹出重命名文件模态框
	 */
	$("#beforeRename").click(function(){
		var obj = $('#tableList').bootstrapTable('getSelections');
		if(obj.length==0||obj.length>1){
			layerAlert("请选择一条数据");
			return;
		}
		$("#input_rename").val(obj[0].fileName);
		$("#modal_rename").modal("show");
	});
	/**
	 * 重命名文件
	 */
	$("#onRename").click(function(){
		var obj = $('#tableList').bootstrapTable('getSelections');
		var newName=$("#input_rename").val();
		if(newName==null||newName==""){
			layerAlert("文件夹名称不能为空");
			return;
		}
		$.ajax({
			type: "POST",
			async: false,
			url: "clouddiskc/rename",
			data: {fileId:obj[0].fileId,fileName:newName},
			success: function () {
				$("#modal_rename").modal("hide");
				refreshTableList();
				var newNode = zTree.getNodeByParam("id", obj[0].fileId, null);
				if(newNode!=null){
					newNode.name=newName;
					zTree.updateNode(newNode);
				}
			}
		});
	});
	/**
	 * 分享文件
	 */
	$("#buttonShare").click(function(){
		var obj = $('#tableList').bootstrapTable('getSelections');
		if (obj.length==0) {
			layerAlert("请选择数据");
			return false;
		}else{
			var fileArray=new Array();
			for(var i=0;i<obj.length;i++){
				fileArray.push(obj[i].fileId);
			}
			fileIds=fileArray.join(",");
			chooseUserUrl = "treeController/zMultiPurposeContacts?state=1";
			$("#chooseUser_iframe").attr("src",chooseUserUrl);
		 	$("#chooseUserDiv").modal('show');
		}
	});
	$("#onCancelShare").click(function(){
		var obj = $('#tableShareList').bootstrapTable('getSelections');
		if(obj.length==0){
			layerAlert("请选择一条数据");
			return;
		}
		for(var i=0;i<obj.length;i++){
			$.ajax({
				type: "POST",
				async: false,
				url: "cloudsharec/cancelShare",
				data: {ID_:obj[i].id},
				success: function (datas) {
					var obj = eval("("+datas+")");
					if(obj.result=="error"){
						layerAlert("取消共享出错了！");
						return;
					}
					$("#file_share_detail").modal("hide");
					refreshShareTableList({},CLICK_ROW);
					layerAlert("已取消共享！");
				}
			});
		}
	});
	/**
	 * 删除文件
	 */
	$("#btnDelete").click(function(){
		var obj = $('#tableList').bootstrapTable('getSelections');
		if(obj.length==0){
			layerAlert("请选择一条数据");
			return;
		}
		layer.confirm('确定删除文件？',{
			 btn: ['确定','取消'], //按钮
			 shade: false //不显示遮罩
		},function(index){
			layer.close(index);
			for(var i=0;i<obj.length;i++){
				$.ajax({
					type: "POST",
					async: false,
					url: "clouddiskc/delFile",
					data: {folderId:LEFT_NODE.id,fileId:obj[i].fileId},
					success: function (datas) {
						var obj = eval("("+datas+")");
						if(obj.result=="error"){
							layerAlert(obj.reMsg);
							return;
						}
						refreshTableList();
						refreshTree();
					}
				});
			}
		});
	});
	$("#btnShareAuth").click(function(){
		var obj = $('#tableList').bootstrapTable('getSelections');
		if(obj.length==0||obj.length>1){
			layerAlert("请选择一条数据");
			return;
		}
		var cloudFileId=obj[0].fileId;
		SELECT_FILE_TYPE=obj[0].fileType;
		$.ajax({
			type: "POST",
			async: false,
			url: "clouddiskq/queryAuths",
			data: {fileId:cloudFileId},
			success: function (obj) {
				$(".radio-auth").attr('checked',false);
				submitAuthJSON=new Array();
				$("#cloud-auth-console").html("");
				var auths= eval(obj);
				for(var i=0;i<auths.length;i++){
					var datas=auths[i];
					$("#cloud-auth-console").append(setUser(datas.name,datas.id,datas.type));
					var selected={
							id:datas.id,
							name:datas.name,
							type:datas.type,
							fileId:cloudFileId,
							onSee:datas.onSee,
							beforeAdd:datas.beforeAdd,
							beforeRename:datas.beforeRename,
							onShowLog:datas.onShowLog,
							buttonUpload:datas.buttonUpload,
							btnDelete:datas.btnDelete,
							btnShareAuth:datas.btnShareAuth,
							buttonDownload:datas.buttonDownload,
					}
					setUserAuth(selected,datas.id,function(){
						SELECT_FILE_ID=cloudFileId;
					});
				}
				$(".cloud-auth").css("color","#7a7c7f");
				$(".radio-auth").attr('disabled',true);
				$("#file_share_auth").modal("show");
			}
		});
	});
	$("#btnAddAll").click(function(){
		var obj = $('#tableList').bootstrapTable('getSelections');
		var id="all";
		var name="所有人";
		var selected={
				id:id,
				name:name,
				type:"all",
				fileId:obj[0].fileId,
				onSee:"ban",
				beforeAdd:"ban",
				beforeRename:"ban",
				onShowLog:"ban",
				buttonUpload:"ban",
				btnDelete:"ban",
				btnShareAuth:"ban",
				buttonDownload:"ban",
		}
		if($("#SELECTED_all").length==0){
			$("#cloud-auth-console").append(setUser(name,id,"all"));
			setUserAuth(selected,id);
		}
		
	});
	$("#btnAddDept").click(function(){
		deptTree(2,"selectDeptId_",null,function(deptId,deptName){
			var obj = $('#tableList').bootstrapTable('getSelections');
			var flag=false;
			$.each(submitAuthJSON,function(index,JSON){
				if(JSON.id==deptId){
					flag=true;
				}
			});
			if(!flag){
				var selected={
						id:deptId,
						name:deptName,
						type:"dept",
						fileId:obj[0].fileId,
						onSee:"ban",
						beforeAdd:"ban",
						beforeRename:"ban",
						onShowLog:"ban",
						buttonUpload:"ban",
						btnDelete:"ban",
						btnShareAuth:"ban",
						buttonDownload:"ban",
				}
				$("#cloud-auth-console").append(setUser(deptName,deptId,"dept"));
				setUserAuth(selected,deptId);
			}
		});
		
		
	});
	$("#btnAddUsers").click(function(){
		peopleTree(1,'selectUserId_',null,function(userId,userName){
			var obj = $('#tableList').bootstrapTable('getSelections');
			var flag=false;
			$.each(submitAuthJSON,function(index,JSON){
				if(JSON.id==userId){
					flag=true;
				}
			});
			if(!flag){
				var selected={
						id:userId,
						name:userName,
						type:"user",
						fileId:obj[0].fileId,
						onSee:"ban",
						beforeAdd:"ban",
						beforeRename:"ban",
						onShowLog:"ban",
						buttonUpload:"ban",
						btnDelete:"ban",
						btnShareAuth:"ban",
						buttonDownload:"ban",
				}
				var reVal=setUserAuth(selected,userId);
				$("#cloud-auth-console").append(setUser(userName,userId,"user"));
			}
		});
	});
	$(".radio-auth").click(function(){
		var obj = $('#tableList').bootstrapTable('getSelections');
		if(SELECT_NODE_ID==null||SELECT_NODE_ID==""){
			return;
		}
		var selected={
			id:SELECT_NODE_ID,
			name:SELECT_NODE_NAME,
			type:SELECT_NODE_TYPE,
			fileId:obj[0].fileId,
			onSee:$("input[name='onSee']:checked").val(),
			beforeAdd:$("input[name='beforeAdd']:checked").val(),
			beforeRename:$("input[name='beforeRename']:checked").val(),
			onShowLog:$("input[name='onShowLog']:checked").val(),
			buttonUpload:$("input[name='buttonUpload']:checked").val(),
			btnDelete:$("input[name='btnDelete']:checked").val(),
			btnShareAuth:$("input[name='btnShareAuth']:checked").val(),
			buttonDownload:$("input[name='buttonDownload']:checked").val(),
		}
		var reVal=setUserAuth(selected,SELECT_NODE_ID);
	});
	$("#onSaveAuth").click(function(){
		if(submitAuthJSON.length>0){
			$.ajax({
				type: "POST",
				async: false,
				url: "clouddiskc/saveAuth",
				data: {auths:JSON.stringify(submitAuthJSON)},
				success: function () {
					$("#file_share_auth").modal("hide");
					refreshTableList();
				}
			});
		}else{
			$("#file_share_auth").modal("hide");
		}
		
	});
	$("#btnRemove").click(function(){
		$.each(submitAuthJSON,function(index,JSON){
			if(JSON==null||JSON==""||JSON=="undefined"||typeof(JSON)==undefined){
				return true;
			}
			if(SELECT_NODE_ID==JSON.id){
				submitAuthJSON.splice(index,1);
				$("#SELECTED_"+SELECT_NODE_ID).remove();
			}
		});
	});
	$("#btnRemoveAll").click(function(){
		var tempArray=new Array();
		$.each(submitAuthJSON,function(index,JSON){
			if(JSON==null||JSON==""||JSON=="undefined"||typeof(JSON)==undefined){
				return true;
			}
			if(JSON.id==CLOUD_USER_ID){
				tempArray.push(submitAuthJSON[index]);
			}else{
				$("#SELECTED_"+JSON.id).remove();
			}
		});
		submitAuthJSON=tempArray;
	});
	$("#packDownload").click(function(){
		var obj = $('#tableList').bootstrapTable('getSelections');
		if(obj.length==0){
			layerAlert("请选择一条数据");
			return;
		}
		var fileIds_="";
		for(var i=0;i<obj.length;i++){
			if(i==0){
				fileIds_ +=obj[i].fileId;
			}else{
				fileIds_ +=","+obj[i].fileId;
			}
		}
		downloadPackFile(LEFT_NODE.id,fileIds_);
	});
	$("#btnSeeImages").click(function(){
		var checkRows=$('#tableList').bootstrapTable('getSelections');
		if(checkRows.length==0){
			layerAlert("请选择一条数据");
			return;
		}
		$(".carousel-indicators").html("");
		$(".carousel-inner").html("");
		var flag=true;
		for(var i=0;i<checkRows.length;i++){
			var type=checkRows[i].fileType;
			if(type!="png"&&type!="jpg"&&type!="jpeg"){
				flag=false;
			}
		}
		if(!flag){
			layerAlert("请选择图片进行预览!");
			return false;
		}
		
		$("#cloud-swiper").attr("src",ctx+"/views/aco/clouddisk/cloudswiper.jsp?time="+new Date());
		$("#cloud-swiper")[0].contentWindow.$(".swiper-wrapper").html("");
		var fileIds_="";
		for(var i=0;i<checkRows.length;i++){
			var type=checkRows[i].fileType;
			if(i==0){
				fileIds_+=checkRows[i].fileId;
			}else{
				
				fileIds_+=","+checkRows[i].fileId;
			}
		}
		$("#hidImage").val(fileIds_);
		$("#modal_images").modal("show");
	});
});
function setUserAuth(params,userId,callback){
	var icons={
		onSee:'<i class="console-icon fa fa-eye"></i>',
		beforeAdd:'<i class="console-icon fa fa-plus-square"></i>',
		beforeRename:'<i class="console-icon fa fa-pencil-square"></i>',
		onShowLog:'<i class="console-icon fa fa-list"></i>',
		buttonUpload:'<i class="console-icon fa fa-upload"></i>',
		btnDelete:'<i class="console-icon fa fa-trash"></i>',
		btnShareAuth:'<i class="console-icon fa fa-cogs"></i>',
		buttonDownload:'<i class="console-icon fa fa-download"></i>',
	}
	var defaults={
		id:"",
		name:"",
		type:"",
		fileId:"",
		onSee:"ban",
		beforeAdd:"ban",
		beforeRename:"ban",
		onShowLog:"ban",
		buttonUpload:"ban",
		btnDelete:"ban",
		btnShareAuth:"ban",
		buttonDownload:"ban",
	}
	var params_ = $.extend({}, defaults, params);//合并上传参数
	$("#ICON_"+userId).html("");
	if(params_.onSee=="allow"){
		$("#ICON_"+userId).append(icons.onSee);
	}
	if(params_.beforeAdd=="allow"){
		$("#ICON_"+userId).append(icons.beforeAdd);
	}
	if(params_.beforeRename=="allow"){
		$("#ICON_"+userId).append(icons.beforeRename);
	}
	if(params_.onShowLog=="allow"){
		$("#ICON_"+userId).append(icons.onShowLog);
	}
	if(params_.buttonUpload=="allow"){
		$("#ICON_"+userId).append(icons.buttonUpload);
	}
	if(params_.btnDelete=="allow"){
		$("#ICON_"+userId).append(icons.btnDelete);
	}
	if(params_.btnShareAuth=="allow"){
		$("#ICON_"+userId).append(icons.btnShareAuth);
	}
	if(params_.buttonDownload=="allow"){
		$("#ICON_"+userId).append(icons.buttonDownload);
	}
	var flag=false;
	$.each(submitAuthJSON,function(index,JSON){
		if(JSON==null||JSON==""||JSON=="undefined"||typeof(JSON)==undefined){
			return true;
		}
		if(params_.id==JSON.id){
			submitAuthJSON.splice(index,1);
		}
	});
	submitAuthJSON.push(params_);
	if(typeof callback == "function") {
		callback();
	} 
	return params_;
}
var AUTH_TREE;
var submitAuthJSON=new Array();
function setUser(val,id,type){
	var valIcon="";
	switch (type) {
	case "all":
		valIcon="<i class=\"fa fa-users\"></i>";
		break;
	case "dept":
		valIcon="<i class=\"fa fa-university\"></i>";
		break;
	default:
		valIcon="<i class=\"fa fa-user\"></i>";
		break;
	}
	return "<div class=\"tree-user\" onclick=\"selectNodes('"+id+"','"+val+"','"+type+"')\" id=\"SELECTED_"+id+"\"><span class=\"tree-user-span\">"+valIcon+val+"</span><span id=\"ICON_"+id+"\"></span></div>";
}
var SELECT_NODE_ID="";
var SELECT_FILE_ID="";
var SELECT_NODE_NAME="";
var SELECT_FILE_TYPE="";
function selectNodes(id,name,type){
	SELECT_NODE_ID=id;
	SELECT_NODE_NAME=name;
	SELECT_NODE_TYPE=type;
	$("#cloud-auth-console div").css("background-color","").css("color","");
	$("#SELECTED_"+id).css("background-color","#cb2320").css("color","white");
	$(".radio-auth").attr('checked',false);
	$(".cloud-auth").css("color","black");
	$(".radio-auth").removeAttr('disabled');
	$.each(submitAuthJSON,function(index,JSON){
		if(JSON.id==id){
			setCheck(JSON.onSee,"onSee");
			if(SELECT_FILE_TYPE=="folder"){
				setDisabled("beforeAdd",false);
			}else{
				setDisabled("beforeAdd",true);
			}
			setCheck(JSON.beforeAdd,"beforeAdd");
			setCheck(JSON.beforeRename,"beforeRename");
			setCheck(JSON.onShowLog,"onShowLog");
			setCheck(JSON.buttonUpload,"buttonUpload");
			setCheck(JSON.btnDelete,"btnDelete");
			setCheck(JSON.btnShareAuth,"btnShareAuth");
			setCheck(JSON.buttonDownload,"buttonDownload");
		}
	});
	if(id==CLOUD_USER_ID){
		$(".cloud-auth").css("color","#7a7c7f");
		$(".radio-auth").attr('disabled',true);
		$("#btnRemove").attr('disabled',true);
	}else{
		$("#btnRemove").attr('disabled',false);
	}
}
function setCheck(val,name){
	if(val=="allow"){
		$("input[name="+name+"]").eq(1).attr("checked",true);
	}else{
		$("input[name="+name+"]").eq(0).attr("checked",true);
	}
}
function setDisabled(name,boolean){
	if(boolean){
		$("input[name="+name+"]").attr("disabled",true);
	}else{
		$("input[name="+name+"]").removeAttr("disabled");
	}
	
	
}
function getSelectedCheckedNodes(){
	var selectedNodes=AUTH_TREE.getCheckedNodes(true);
	var nodes_= selectedNodes.filter(function(param){
		  return param.type === "user"&&param.name!=CLOUD_USER_NAME;
	});
	return nodes_;
}

/**
 * 下载文件
 * @param folderId
 * @param fileId
 */
function downloadOneFile(folderId,fileId){
	$("#folderId").val(folderId);
	$("#fileId").val(fileId);
	$("#downloadForm").submit();
}
/**
 * 批量下载文件
 * @param folderId
 * @param fileId
 */
function downloadPackFile(folderId,fileIds){
	$("#folderId").val(folderId);
	$("#fileIds").val(fileIds);
	$("#downloadPackForm").submit();
}

/**
 * 提交分享文件
 */
function makesure() {
	var arr = document.getElementById("chooseUser_iframe").contentWindow.doSaveSelectUser();
	var userName = arr[1];
	var userId = arr[0];
	$('#chooseUserDiv').modal('hide');
	$.ajax({
		type: "POST",
		async: false,
		url: "cloudsharec/shareFile",
		data: {fileIds:fileIds,receiverId:arr[0]},
		success: function () {
			refreshTableList();
			layerAlert("分享成功！");
		}
	});
}
var fileIds="";
/**
 * 批量分享文件
 * @returns {Boolean}
 */
function shareFile(){
	var obj = $('#tableList').bootstrapTable('getSelections');
	if(LEFT_NODE.id=="SHARE_SEND"||LEFT_NODE.id=="SHARE_RECEIVER"){
		obj = $('#shareTableList').bootstrapTable('getSelections');
	}
	if (obj.length==0) {
		layerAlert("请选择数据");
		return false;
	}else{
		for(var i=0;i<obj.length;i++){
			if(i==0){
				fileIds +=obj[i].fileId;
			}else{
				fileIds +=","+obj[i].fileId;
			}
		}
		chooseUserUrl = "treeController/zMultiPurposeContacts?state=1";
		$("#chooseUser_iframe").attr("src",chooseUserUrl);
	 	$("#chooseUserDiv").modal('show');
	}
}
var rowObj;
/**
 * 弹出文件/文件夹详情模态框
 * @param row
 */
function clickDetail(row){
	setValue(row);
}

/**
 * 详情赋值
 * @param row
 */
function setValue(row){
	var data;
	$.ajax({
		type: "POST",
		async: false,
		url: "clouddiskc/findByFileId",
		data: {fileId:row.fileId},
		success: function (datas) {
			if(datas.length>0){
				data=datas[0];
				$("#fileName").text(data.fileName);
				$("#fileSize").text(formatSize(data.fileSize));
				$("#fileOwnerName").text(data.fileOwnerName);
				$("#fileDate").text(data.fileDate);
				$("#fileCount").text(data.fileCount);
			}
		}
	});
	
}
