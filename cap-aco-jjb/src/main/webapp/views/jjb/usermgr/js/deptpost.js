
var treetype;
var style;
function postTree(type, treeType,event) {
	//设定弹出div位置，绑定body鼠标单击事件
	var cityObj = $("#"+treeType.replace("Id","Name"));
	var cityOffset = $("#"+treeType.replace("Id","Name")).offset();
	$("#treeDiv_"+treeType).css({left: "10px", top: cityObj.outerHeight() + "px"}).slideDown("fast");
	$("body").bind("mousedown",onBodyDown);
	//end
	treetype = treeType;
	style = type;
	var setting;
	if (type == "0") {// 拟稿部门
		setting = {
			async : {
				enable : true,
				dataType : "json",
				type : "post",
				url : "deptController/getDeptTree",
				autoParam : [ "id" ],
				idKey : "id",
				pIdKey : "pId",
				rootPId : 0
			},
			callback : {
				beforeClick : beforeClick,
				onDblClick : onDblclick,
				onAsyncSuccess: getOrgUserExpand
			}
		};
	}
	if (type == "1") {
		setting = {
			async : {
				enable : true,
				dataType : "json",
				type : "post",
				url : "treeController/findDeptPost",
				autoParam : [ "id","pId","type","hasChild" ],
				idKey : "id",
				pIdKey : "pId",
				rootPId : 0
			},
			callback : {
				beforeClick : beforeClick,
				onDblClick : onDblclick,
				onAsyncSuccess: getOrgUserExpand
			}
		};
	}
	$.fn.zTree.init($("#groupTree_" + treeType), setting);
}
var className = "dark";
function beforeClick(treeId, treeNode, clickFlag) {
	className = (className === "dark" ? "" : "dark");
	return (treeNode.click != false);
}
function onDblclick(event, treeId, treeNode, clickFlag) {
		if(style == "1"){
			if(treeNode.isParent != null) {
				if(!treeNode.isParent) {
					$("#"+treetype.replace("Id","Name")).val(treeNode.name);
					$("#" + treetype).val(treeNode.id);
					$("#treeDiv_" + treetype).css('display', 'none');
				}
			}
		}else {
			$("#"+treetype.replace("Id","Name")).val(treeNode.name);
			$("#" + treetype).val(treeNode.id);
			$("#treeDiv_" + treetype).css('display', 'none');
		}
}
function hideMenu() {
	$("#treeDiv_"+treetype).fadeOut("fast");
	$("body").unbind("mousedown", onBodyDown);
}
function onBodyDown(event) {
	if (!(event.target.id == treetype || event.target.id == "treeDiv_"+treetype || $(event.target).parents("#treeDiv_"+treetype).length>0)) {
		hideMenu();
	}
}
//异步加载成功回调函数  
function getOrgUserExpand(event, treeId, treeNode, msg) {
	var treeObj = $.fn.zTree.getZTreeObj("groupTree_"+treetype);
    var nodes = treeObj.getNodes();
    for (var i = 0; i < nodes.length; i++) { //设置节点展开
        treeObj.expandNode(nodes[i], true, false, false);
    }
};