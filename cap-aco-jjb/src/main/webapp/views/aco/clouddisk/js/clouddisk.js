//文件夹树节点设置
var setting = {
	data: {
		simpleData: {
			enable: true,
			rootPId: "",
			idKey: "id"
		}
	},
	callback:{
		onClick:leftClick,
	}
};
/**
 * 初始化按钮
 * @param thisNode
 */
function initButton(thisNode){
	var fileAttr=thisNode.fileattr;//编辑权限
	if(fileAttr=="PUBLIC"){
		var CAddFolder=$("#CAddFolder").is(":visible");//新建文件夹权限
		var CRename=$("#CRename").is(":visible");//重命名权限
		var CUploadFile=$("#CUploadFile").is(":visible");//上传权限
		var CDeleteFile=$("#CDeleteFile").is(":visible");//删除文件权限
		var CShowLog=$("#CShowLog").is(":visible");//详情列表权限
		var btn={beforeAdd:CAddFolder,beforeRename:CRename,buttonUpload:CUploadFile,btnDelete:CDeleteFile,buttonShare:false,onShowLog:CShowLog,btnShareAuth:false};
		initialButton(btn);
	}else if(fileAttr=="SHARE"||fileAttr=="MY_SHARE"){
		var btn={beforeAdd:false,beforeRename:false,buttonUpload:false,btnDelete:false,buttonShare:false,onShowLog:false};
		initialButton(btn);
	}else{
		var btn={beforeAdd:true,beforeRename:true,buttonUpload:true,btnDelete:true,buttonShare:true,onShowLog:false};
		initialButton(btn);
	}
}
/**
 * 根据参数初始化按钮
 * @param filter
 */
function initialButton(filter){
	for(var i in filter){
		if(filter[i]){
//			$("#"+i).show();
			$("#"+i).removeAttr("disabled");// 移除disabled属性 
		}else{
//			$("#"+i).hide();
			$("#"+i).attr('disabled',"true");//添加disabled属性 
		}
	}
}

/**
 * 根据文件夹属性加载文件列表
 * @param thisNode
 * @param historyFlag
 */
function loadFileDataByFolder(row){
	if(LEFT_NODE.fileattr!="SHARE"&&LEFT_NODE.fileattr!="MY_SHARE"){
		var nodes=zTree.getNodesByParam("id",row.fileId,null);
		if(nodes!=null&&nodes&&nodes.length>0){
			LEFT_NODE=nodes[0];
			loadFolderPath(nodes[0]);
		}
	}else{
		var path="<i class=\"fa fa-angle-right\"></i>"+row.fileName;
		$(".path-location").append(path);
	}
	initTableByServer({},{parentFileId:row.fileId,fileAttr:row.fileAttr},{});
	//initButton(thisNode);
	//loadFolderPath(thisNode);
}
/**
 * 加载当前文件夹路径
 * @param thisNode
 */
function loadFolderPath(thisNode){
	var node=thisNode.getParentNode(); 
	var nodeList=new Array();
	nodeList.push(thisNode.name);
	while(node!=null){
		nodeList.push(node.name);
		node=node.getParentNode();
	}
	var path="";
	for(var i=nodeList.length;i>0;i--){
		if(i==1){
			path+=nodeList[i-1];
		}else{
			path+=nodeList[i-1]+"<i class=\"fa fa-angle-right\"></i>";
		}
	}
	$(".path-location").html(path);
}
function leftClick(event, treeId, treeNode){
	LEFT_NODE=treeNode;
	if(treeNode.fileattr=="SHARE"||treeNode.fileattr=="MY_SHARE"){
		initShareTableByServer({},treeNode.filetype,null);
	}else{
		initTableByServer({},{parentFileId:treeNode.id,fileAttr:treeNode.fileattr});
	}
	setButtonByFileId(treeNode.id,treeNode.fileattr);
	//initButton(treeNode);
	loadFolderPath(treeNode);
}
function onBodyMouseDown(event){
	if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {
		rMenu.css({"visibility" : "hidden"});
	}
}

function exit(id){
	$("#"+id).modal("hide");
}
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

function refreshTableList(){
	if(!LEFT_NODE){
		return;
	}
	initTableByServer({},{parentFileId:LEFT_NODE.id,fileAttr:LEFT_NODE.fileattr});
}
function refreshShareTableList(){
	if(!LEFT_NODE){
		return;
	}
	initShareTableByServer({},LEFT_NODE.filetype,null);
}
function refreshTree(){
	$.ajax({
		type: "POST",
		async: false,
		dataType:"text",
		url: "clouddiskc/initTree",
		success: function (datas) {
			var obj = eval(datas);
			$.fn.zTree.init($("#folderTree"), setting, obj);//初始化左侧文件夹树
			zTree = $.fn.zTree.getZTreeObj("folderTree");
		},
		error:function(){
			
		}
	});
	
}
