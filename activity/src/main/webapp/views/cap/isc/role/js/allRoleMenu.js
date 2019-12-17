$(function() {
	initOrgTree();
	initRoleList();
	//InitTreeData();
	
});

/**全局变量，角色ID*/
var orgId = "";
/**全局变量，系统ID*/
var sysRegId = "";

/**
 * 初始化加载左侧树
 */
function initOrgTree() {
	$('#org_tree').tree({
		url : "orgController/findUnSealedChildrenNodesByIdUnderUserId",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		onClick : function(node) {
			orgId = node.id;
			orgName = node.text;
			$('#org_tree').tree('expand', node.target);
			$('#roleList').datagrid('clearChecked');
			// 点击某一注册系统时，加载对应系统下的模块
			reload();
		}
		/*,
		onLoadSuccess : function (){
			$('#org_tree').tree('expandAll');
		}*/
	});
}

/**
 * 加载角色列表
 */
function initRoleList() {
	$('#roleList').datagrid({
		method : 'POST',
		idField : 'roleId',
		striped : true,
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams:{
			orgId : orgId
		},
		fitColumns : true,
		toolbar : '#toolBar',
		fit: true,
		singleSelect : true,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', checkbox : true }, 
		   { field : 'roleId', title : 'roleId', hidden : true }, 
		   { field : 'roleName', title : '角色名称', width : 110, align : 'left' },
		   { field : 'roleEname', title : '角色英文名', width : 100, align : 'left' },
		   { field : 'roleCode', title : '角色编码', width : 80, align : 'left' },
		   { field : 'createTime', title : '创建时间', width : 120, align : 'left' },
		   { field : 'roleDesc', title : '角色描述', width : 130, align : 'left'}
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#roleList').datagrid("clearChecked");
			//check the select row
			$('#roleList').datagrid("selectRow", index);
		}
	});
}

/**
 * 重新加载列表
 */
function reload() {
	var url = 'roleController/findByCondition';
	$('#roleList').datagrid({
		url : url,
		queryParams:{
			orgId : orgId
		}
	});
}

/**
 * 条件查询
 */
function findByCondition(){
	var roleName = $("#search").searchbox('getValue');
	$('#roleList').datagrid({
        url:"roleController/findByCondition",
        queryParams:{
        	orgId : orgId,
        	roleName : roleName,
        	date:new Date()
        }
    });
}

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
			InitMenuTreeData();
		}
	});
}

/**
 * 初始化系统菜单树
 */
function InitMenuTreeData() {
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
 * 角色授权
 */
function addRoleMenu(){
	var data = $('#roleList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一个角色进行添加！','info');
		layer.tips('请选择一个角色操作', '#btn_perm', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '只能选择单个角色进行添加！','info');
			return;
		}
		roleId = data[0].roleId;
	}
	
	$('#menu_tree li').remove();
	initSysRegTree();
	$('#roleMenuDialog').dialog('open');
	//window.parent.addTab("角色授权","roleMenuController/roleMenu?roleId="+v_roleId);
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

function clearSearchBox(){
	$("#search").searchbox("setValue","");
	$("#org_search").searchbox("setValue","");
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#org_tree").tree('search',searchValue);
}