var treetype;
function peopleTree(type, treeType,event) {
	//设定弹出div位置，绑定body鼠标单击事件
	var cityObj = $("#"+treeType);
	var cityOffset = $("#"+treeType).offset();
	$("#treeDiv_"+treeType).css({left:cityOffset.left + "px", top:cityOffset.top + cityObj.outerHeight() + "px"}).slideDown("fast");
	$("body").bind("mousedown",onBodyDown);
	//end
	treetype = treeType;
	var setting;
	if (type == "1") {// 拟稿人
		setting = {
			async : {
				enable : true,
				dataType : "json",
				type : "post",
				url : "orgController/getUserTree",
				autoParam : [ "id" ],
				idKey : "id",
				pIdKey : "pId",
				rootPId : 0
			},
			callback : {
				beforeClick : beforeClick,
				onDblClick : onDblclick
			}
		};
	}
	if (type == "2") {// 拟稿部门
		setting = {
			async : {
				enable : true,
				dataType : "json",
				type : "post",
				url : "systree/getDeptData?type="+treetype,
				autoParam : [ "id" ],
				idKey : "id",
				pIdKey : "pId",
				rootPId : 0
			},
			callback : {
				beforeClick : beforeClick,
				onDblClick : onDblclick
			}
		};
	}
	if (type == "3") {// 校对人
		setting = {
			async : {
				enable : true,
				dataType : "json",
				type : "post",
				url : "systree/getOrgPersonData?type="+treetype,
				autoParam : [ "id" ],
				idKey : "id",
				pIdKey : "pId",
				rootPId : 0
			},
			callback : {
				beforeClick : beforeClick,
				onDblClick : onDblclick
			}
		};
	}
	if (type == "4") {// 印刷单位
		setting = {
			async : {
				enable : true,
				dataType : "json",
				type : "post",
				url : "systree/getDeptData?type="+treetype,
				autoParam : [ "id" ],
				idKey : "id",
				pIdKey : "pId",
				rootPId : 0
			},
			callback : {
				beforeClick : beforeClick,
				onDblClick : onDblclick
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
	if(treeNode.isParent != null) {
		if(!treeNode.isParent) {
			$("#" + treetype).val(treeNode.name);
			$("#pubForm_" + treetype).val(treeNode.id);
			$("#treeDiv_" + treetype).css('display', 'none');
		}
	}
	/*if ('draftDepartment' == treeNode.typeTree) {
		$("#" + treeNode.typeTree).val(treeNode.name);
		$("#pubForm_" + treeNode.typeTree).val(treeNode.id);
		$("#treeDiv_" + treetype).css('display', 'none');
	}else if('printUnit' == treeNode.typeTree) {
		$("#" + treeNode.typeTree).val(treeNode.name);
		$("#pubForm_" + treeNode.typeTree).val(treeNode.id);
		$("#treeDiv_" + treetype).css('display', 'none');
	}else if('drafter' == treeNode.typeTree) {
		$("#" + treeNode.typeTree).val(treeNode.name);
		$("#pubForm_" + treeNode.typeTree).val(treeNode.id);
		$("#treeDiv_" + treetype).css('display', 'none');
	}else if('checkman' == treeNode.typeTree){
		$("#" + treeNode.typeTree).val(treeNode.name);
		$("#pubForm_" + treeNode.typeTree).val(treeNode.id);
		$("#treeDiv_" + treetype).css('display', 'none');
	}
	else if('people_input' == treeNode.typeTree){
		$("#" + treeNode.typeTree).val(treeNode.name);
		$("#pubForm_" + treeNode.typeTree).val(treeNode.id);
		$("#treeDiv_" + treetype).css('display', 'none');
	}*/
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
