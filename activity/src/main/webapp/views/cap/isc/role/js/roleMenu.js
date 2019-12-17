
/**全局变量，系统ID*/
var sysRegId = "";

/**
 * 初始化加载左侧系统注册树
 * 
 * @param 无
 * @returns 无
 */
function initSysRegTree() {
	$('#sys_reg_tree').tree({
		url : 'sysRegController/findAllSysReg',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onClick : function(node) {
			sysRegId = node.id;
			if (sysRegId == "999") {
				return;
			}
			$('#sys_reg_tree').tree('expand', node.target);
			// 点击某一注册系统时，加载对应系统下的模块
			InitTreeData(sysRegId);
		}
	});
}

/**
 * 初始化系统菜单树
 */
function InitTreeData() {
	$('#menu_tree').tree({
		url : 'roleMenuController/findBySysRegId',
		animate : true,
		checkbox : true,
		formatter : formaterNodeCount,
		queryParams:{
			sysRegId:sysRegId,
			roleId : roleId
		},
		onlyLeafCheck : false,
		cascadeCheck : true,
		onBeforeLoad: function (node, param) {//onBeforeLoad,在请求载入数据之前触发，返回false将取消载入。
            $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%" }).appendTo("#menu_tree");
            $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍待。。。").appendTo("#menu_tree").css({ display: "block" });
        },
		/*onCheck : function(node, checked) {
			if (checked) {
                var parentNode = $("#menu_tree").tree('getParent', node.target);
                if (parentNode != null) {
                    $("#menu_tree").tree('check', parentNode.target);
                }
            } else {
                var childNode = $("#menu_tree").tree('getChildren', node.target);
                if (childNode.length > 0) {
                    for (var i = 0; i < childNode.length; i++) {
                        $("#menu_tree").tree('uncheck', childNode[i].target);
                    }
                }
            }
		},*/
		onLoadSuccess: function (row,data) {
			//$(".datagrid-mask").css({ display: "none"});
            //$(".datagrid-mask-msg").css({ display: "none" });
			$('#menu_tree').tree('collapseAll');
		},
		onClick : function(node) {
			// 点击展开
			$('#menu_tree').tree('expand', node.target);
		}
	});
}

/**
 * 格式化树节点下的子节点
 * 
 * @param node 当前树节点
 * @return {String} 返回
 */
function formaterNodeCount(node) {
	var s = node.text;
	if (node.dtype != 'resource') {
		return s;
	}
	//var str = '';
	mainDeptId = node.id;
	mainDeptName = node.text;
	//str = '<span style=\'color:blue\'>( 是否显示  )</span>';
	
	var isEdit = node.attributes;
	if(isEdit == "N"){
		s += '&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="'+node.id+'">是否可编辑'
	}else{
		s += '&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" id="'+node.id+'" checked>是否可编辑'
	}
	return s;
}

/**
 * 保存角色权限数据
 */
function saveData(){
	var nodes = $('#menu_tree').tree('getChecked',['checked','indeterminate']);
	if(sysRegId == ''){
		$.messager.alert('提示', '未选择注册系统！');
		return;
	}
	var parms = '';
	var fg = '';
	for(var i = 0; i < nodes.length; i++){
		if (parms != '') parms += ',';
		if ($("#"+nodes[i].id).is(':checked') == true) {
			fg = "Y";
		}else {
			fg = "N";
		}
		parms += nodes[i].id + "-" + nodes[i].dtype + "-" + fg;
	}
	if(roleId == ''){
		$.messager.alert('提示', '选择角色为空！');
		return;
	}
	$.ajax({
		url : 'roleMenuController/doSaveRoleMenu',
		type : 'post',
		async : false,
		data : {parms : parms,roleId : roleId,sysRegId : sysRegId},
		beforeSend: function () {
			$("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%" }).appendTo("#menu_tree");
            $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍待。。。").appendTo("#menu_tree").css({ display: "block" });
	    },
		success : function(data){
			$(".datagrid-mask").css({ display: "none"});
            $(".datagrid-mask-msg").css({ display: "none" });
            
			$.messager.show({ title:'提示', msg:'保存成功!', showType:'slide' });
			$("#roleMenuDialog").dialog('close');
		}
	});
}