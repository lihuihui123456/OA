var checktreeId="";
var menu;
function OnRightClick(event, treeId, treeNode) {
	checktreeId=treeNode.id;
	if(checktreeId==shareFold){
		return ;
	}
	var firId=checktreeId.substr(0,4);
	if(checktreeId.length>4){
		menu="rMenuForRole";
	}else{
		menu="rMenu";
	}
	//$("#h_checkTreeId").val(checktreeId);
	if (!treeNode && event.target.tagName.toLowerCase() != "button" && $(event.target).parents("a").length == 0) {
		zTree.cancelSelectedNode();
		showRMenu("root", event.clientX, event.clientY);
	} else if (treeNode && !treeNode.noR) {
		zTree.selectNode(treeNode);
		showRMenu("node", event.clientX, event.clientY);
	}
}

function showRMenu(type, x, y) {
	$("#"+menu).css({"top":y+"px", "left":x+"px", "visibility":"visible"});
	$("body").bind("mousedown", onBodyMouseDown);
}

function hideRMenu() {
	if (rMenu) rMenu.css({"visibility": "hidden"});
	if (rMenuForRole) rMenuForRole.css({"visibility": "hidden"});
	$("body").unbind("mousedown", onBodyMouseDown);
}

function onBodyMouseDown(event){
	if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {
		rMenu.css({"visibility" : "hidden"});
	}
	if (!(event.target.id == "rMenuForRole" || $(event.target).parents("#rMenuForRole").length>0)) {
		rMenuForRole.css({"visibility" : "hidden"});
	}
}
		