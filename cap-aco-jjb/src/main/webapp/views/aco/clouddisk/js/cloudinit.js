var userList;
var zTree,root,usersTree,historyClick,nowIndex,initlog=0;
var LEFT_NODE,CLICK_ROW;
$(document).ready(function(){
	
	$.fn.zTree.init($("#folderTree"), setting, treeArray);//初始化左侧文件夹树
	zTree = $.fn.zTree.getZTreeObj("folderTree");
	LEFT_NODE=zTree.getNodeByParam("id","PUBLIC", null);//初始化左键.默认值为点击公共文件夹
	initButton(LEFT_NODE);//初始化按钮
	initTableByServer({},{parentFileId:"PUBLIC",fileAttr:"PUBLIC"},{});//初始化bootstrap列表
	root=getRootPath(); //初始化项目根目录
	loadFolderPath(LEFT_NODE);//初始化当前文件路径.默认值为点击公共文件夹
	refreshTree();
	$('#input-word').keydown(function(e){
		if(e.keyCode==13){
			search();
		}
	});
	var Hbody=$("body").height();
	var Hmenu=$("#cloud-menu").height();
	var Hpath=$("#path").height();
	$(".sidebar").height(Hbody-(Hmenu+Hpath+50));
	$(".main").height(Hbody-(Hmenu+Hpath+70));
});