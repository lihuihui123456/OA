/**
 * 页面初始化时加载相关函数
 */
$(function() {
	// 初始化左侧单位树
	initOrgTree();
	
	//set the datagrid only one row can be selected
	$('#orgTreeGrid').datagrid({
		onClickRow: function(index,row){
			//cancel all select
			$('#orgTreeGrid').datagrid("clearChecked");
			//check the select row
			$('#orgTreeGrid').datagrid("selectRow", index);
		}
	});
	
});

/**
 * 查看组织机构图
 */
function showOrgPic() {
	//get tree select
	var orgId = '';
	var node = $('#orgTree').tree('getSelected');
	if (node != null && node.id != '') {
		orgId = node.id;
	}

	var feature = 'FullScreen=yes,scrollbars=yes,menubar=no,resizable=yes,location=no,status=no,toolbar=no';  
	var win = window.open(path+"/orgController/orgPic?orgId="+orgId, '单位结构图', feature);  
	win.resizeTo(screen.width, screen.height);  
}

/**
 * 初始化左侧单位树
 * 
 * @param 无
 * @returns 无
 */
function initOrgTree(nodeId) {
	var parameter ='';
	$('#orgTree').tree({
		//url : "orgController/findOrgTreeByUserId",// get all tree node data at one time
		url : "orgController/findChildrenNodesByIdUnderUserId",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		queryParams:{
			type : parameter
		},
		//formatter : formaterNodeCount,
		onClick : function(node) {
			//展开点击选中的节点
			$('#orgTree').tree('expand', node.target);
			// 点击树节点时，根据选择的单位节点查询下级单位
			findByOrgId();
			// 清空单位列表选中的行
			clearGridChecked();
			
		},
		onContextMenu: function(e, node){ //给结点添加右键菜单
            e.preventDefault();  //阻止右键默认事件  
            var root = $('#orgTree').tree('getParent', node.target)//判断该结点有没有父结点  
                if(root == null){//若成立则为根结点，添加一个右键样式，可以添加子节点  
                    $('#parentNode').menu('show', {    
                        left: e.pageX,
                        top: e.pageY 
                    });  
                }
            
        },
		onBeforeExpand: function(node){
			$('#orgTree').tree('options').queryParams.type = node.dtype;
		},
		onLoadSuccess: function(node,data){
			//自动选择上次选择的树节点
			//注意： 树节点必须全部加载，否则会出现找不到节点的情况
			if(nodeId!=null){
				var node = $('#orgTree').tree('find', nodeId);
				if(node!=null){
					$('#orgTree').tree('expandTo', node.target).tree('select', node.target); 
				}
			}
		}
	});
}

/**
 * 右键修改根节点名称
 */
function updateRootNode(){
	$('#rootDialog').dialog("open");
	$('#rootForm').form('clear');
}

/**
 * 解决IE8不支持trim函数去除空格的问题
 */
String.prototype.trim = function() {
	return this.replace(/(^\s*)|(\s*$)/g, "");
}

/**
 * 保存根节点名称
 */
function doUpdateRoot(){
	var rootName = $("#rootName").val().trim();
	if(rootName==null||rootName.length==0){
		$.messager.alert('提示', '名称不能为空！', 'info');
		$('#rootForm').form('clear');
		return;
	}
	$.ajax({
		url : 'orgController/doUpdateRoot',
		async : false,
		dataType : 'json',
		data : {
			rootName : rootName
		},
		success : function(data) {
			if (data == true) {
				$('#rootDialog').dialog('close');
				$.messager.show({ title:'提示', msg:'修改成功！', showType:'slide' });
				initOrgTree();
			}
		}, error : function(data) {
			$.messager.show({ title:'提示', msg:'修改失败！', showType:'slide' });
		}
	});
}

/**
 * 新增单位信息
 */
function doAddOrgBefore(){
	var root = $('#orgTree').tree('getRoot');
	var length = $('#orgTree').tree('getChildren',root.target).length;
	if (length >= 1) {
		layer.tips('已有组织机构,不能添加更多!', '#btn_org_add', { tips: 3 });
		return;
	}
	var node = $('#orgTree').tree('getSelected');
	if (node != null) {
		if (!checkParentSeal($('#orgTree'), node)) {
			return;
		} else {
			initOrgDlg("新增单位");
		}
	} else {
		layer.tips('请选择所属单位', '#btn_org_add', { tips: 3 });
		//$.messager.alert('提示', '请选择所属单位！', 'info');
	}
}

/**
 * 递归查询本节点和父节点是否封存
 * @param treeObj easyui树对象 例如：$('#orgTree')
 * @param node easyui树的节点
 * @returns true：本节点和本节点的所有父节点没有被封存
 * 			false： 本节点或者父节点中有被封存
 */
function checkParentSeal(treeObj, node){
	if(node.attributes.isSeal=='Y'){
		$.messager.alert('提示', '父节点：'+'<span style="color: red">'+node.text+'</span>已经封存！', 'info');
		return false;
	}
	var parentNode = treeObj.tree('getParent',node.target);
	if(parentNode!=null){
		return checkParentSeal(treeObj, parentNode);
	}else{
		return true;
	}
}

/**
 * 根据单位ID查询单位信息
 */
function findByOrgId(){
	// 组装查询条件
	var orgId = '0';
	var node = $('#orgTree').tree('getSelected');
	if (node != null && node.id != '') {
		orgId = node.id;
	}

	// 加载组织机构列表树
	$('#orgTreeGrid').datagrid({
		url : 'orgController/findChildrenById',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams : {
			orgId : orgId
		},
		pageSize : 10
	});
	//直接从第一页加载
	$('#orgTreeGrid').datagrid('load');
}

/**
 * 单位高级查询
 */
function findByCondition(){
	// 组装查询条件
	var searchValue = $("#search").searchbox('getValue');
	//筛选查询条件
	if(searchValue!=null&&searchValue.indexOf('%')>=0){
		$.messager.alert('提示', '输入非法查询字符\'%\'！', 'info');
		return;
	}
	var orgId = '0';
	var node = $('#orgTree').tree('getSelected');
	if (node != null && node.id != '') {
		orgId = node.id;
	}

	// 加载组织机构列表树
	$('#orgTreeGrid').datagrid({
		url : 'orgController/findChildrenById',
		queryParams : {
			orgId : orgId,
			searchValue : $.trim(searchValue)
		},
		pageSize : 10,
		onLoadSuccess: function(data) {
			//$.messager.show({ title:'提示', msg:'搜索到 <span style="color:red">'+data.rows.length+'</span> 条数据', showType:'slide' });
		}
	});
	//直接从第一页加载
	$('#orgTreeGrid').datagrid('load');
}

/**
 * 删除单位信息
 * 
 * @param 无
 * @returns 无
 */
function doDeleteOrg() {
	var selecteds = $('#orgTreeGrid').treegrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		layer.tips('请选择一行记录删除', '#btn_org_del', { tips: 3 });
		//$.messager.alert('提示', '请选择一行记录删除！', 'info');
		return;
	} 
//	else {
//		//TODO
//		var children = $('#orgTreeGrid').treegrid('getChildren', selecteds[0].orgId);
//		if (children != null && children.length > 0) {
//			$.messager.alert('提示', '请先删除下级单位！', 'info');
//			return;
//		}
//	}

	$.messager.confirm('删除单位', '确定删除选中单位吗?', function(r) {
		if (r) {
			var ids = '';
			for(var index=0;index<selecteds.length;index++){
				ids = ids + selecteds[index].orgId + ",";
				if(selecteds[index].isHasChld!=null&&selecteds[index].isHasChld=='Y'){
					$.messager.show({ title:'提示', msg:'所删除的单位 '+selecteds[index].orgName+' 有下属单位或者部门', showType:'slide' });
					return;
				}
			}
			ids = ids.substring(0, ids.length - 1);
			$.ajax({
				url : 'orgController/doDeleteOrg',
				async : false,
				dataType : 'text',
				data : {
					ids : ids
				},
				success : function(result) {
					if(result=="true"){
						// 如果删除单位成功提示用户，并更新单位列表和左侧单位树
						$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
					}else if(result=="false"){
						$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
					}else if(result.indexOf("01")==0){
						var message = result.split("+");
						$.messager.show({ title:'提示', msg:'所删除的单位 '+message[1]+' 有下属单位', showType:'slide' });
					}else if(result.indexOf("02")==0){
						var message = result.split("+");
						$.messager.show({ title:'提示', msg:'所删除的单位 '+message[1]+' 有下属部门', showType:'slide' });
					}
					var node = $('#orgTree').tree('getSelected');
					// 更新左侧单位树
					//initOrgTree(node.id);
					freshTreeNode('orgTree',node,'orgController/findChildrenNodesByIdUnderUserId');
					// 更新单位列表
					findByOrgId();
					// 清空单位列表选中的行
					clearGridChecked();
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'请求失败！', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 修改单位信息
 */
function doUpdateOrgBefore(){
	var nodes = $('#orgTreeGrid').treegrid('getChecked');
	if(nodes==null||nodes.length!=1){
		layer.tips('请选择一行记录进行修改', '#btn_org_update', { tips: 3 });
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		return;
	}

	$.ajax({
		url : 'orgController/findOrgById',
		async : false,
		dataType : 'json',
		data : {
			id : nodes[0].orgId
		},
		beforeSend : function(){
			
		},
		success : function(org) {
			if (org != null) {
				initOrgDlg("修改单位");
				$(":hidden[name=orgId]").val(org.orgId);
				//set orgcode
				$(":hidden[name=orgCode]").val(org.orgCode);
				
				$("#orgUniqId").textbox("setValue", org.orgUniqId);
				$("#orgName").textbox("setValue", org.orgName);
				if (org.parentOrgId != null && org.parentOrgId != "") {
					$('#parentOrgId').combotree('setValue', org.parentOrgId);
				}
				setCombotreeEditable($('#parentOrgId'), true);
				var isSeal = org.isSeal;
				if (isSeal == "N") {
					$("#isSeal").switchbutton("check"); 
				} else {
					$("#isSeal").switchbutton("uncheck"); 
				}
				$("#orgDesc").textbox("setValue", org.orgDesc);
				$("#orgForm").form('validate');
			}

			// 清空单位列表选中的行
			clearGridChecked();
		}, error : function(result) {
			$.messager.show({ title:'提示', msg:'请求失败！', showType:'slide' });
		}
	});
}

/**
 * 保存新增修改单位
 */
function doSaveOrUpdateOrg(){
	var orgId = $("#orgId").val();
	var url = "";
	if (orgId == undefined || orgId == '') {
		url = "orgController/doSaveOrgReturn";
	} else {
		$("#orgUniqId").removeAttr("disabled");
		$("#parent_dept_id").removeAttr("disabled");
		url = "orgController/doUpdateOrg";
	}
	
	var is_Seal = $("#isSeal").switchbutton("options").checked;
	if (is_Seal) {
		is_Seal = "N";
	} else {
		is_Seal = "Y";
	}
	var obj = $('#orgForm').serialize()+'&'+'isSeal='+is_Seal;
	//获取当前选中的树节点
	var node = $('#orgTree').tree('getSelected');
	var temp='';
	if(node!=null&&node.id!=''){
		temp = $('#orgTree').tree('find', node.id);
	}
	
	$.ajax({
		url : url,
		async : false,
		type : "post",
		dataType:"json",
		data : obj,
		beforeSend : function() {
			$('input.easyui-validatebox').validatebox('enableValidation');
			if($('#orgForm').form('validate')){
				//disable the form to prevent repeat submit
				$('#saveBtn').linkbutton('disable');    //禁用按钮
				$('#closeBtn').linkbutton('disable');    //禁用按钮
//				 $("<div class=\"datagrid-mask\"></div>").css({ display: "block", width: "100%", height: "100%" }).appendTo("#orgDialog");
//	             $("<div class=\"datagrid-mask-msg\"></div>").html("正在处理，请稍待。。。").appendTo("#orgDialog").css({ display: "block" });
				return true;
			}else{
				return false;
			}
		},
		success : function(data) {

			if(data.result){
				//去除重复提交背景css
				$(".datagrid-mask").css({ display: "none"});
	            $(".datagrid-mask-msg").css({ display: "none" });
	            
				if (orgId == undefined || orgId == '') {
					$.messager.show({ title:'提示', msg:'添加成功', showType:'slide' });
				}else{
					$.messager.show({ title:'提示', msg:'修改成功', showType:'slide' });
				}
				$('#orgDialog').dialog("close");
				
				// 清空单位列表选中的行
				clearGridChecked();
				
				// 更新单位列表
				findByOrgId();
				
				// 更新单位树
//				if(node!=null){
//					initOrgTree(node.id);
//				}else{
//					initOrgTree();
//				}
				//manual refresh children of specified tree node
				freshTreeNode('orgTree',node,'orgController/findChildrenNodesByIdUnderUserId');
			}else{
				$('#saveBtn').linkbutton('enable');    //禁用按钮
				$('#closeBtn').linkbutton('enable');    //禁用按钮
				$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
			}
		},
		error : function(result) {
//			$(".datagrid-mask").css({ display: "none"});
//            $(".datagrid-mask-msg").css({ display: "none" });
			$.messager.show({ title:'提示', msg:'请求失败', showType:'slide' });
		}
	});
}

/**
 * 初始化用户信息编辑对话框 初始化面板 初始化数据
 */
function initOrgDlg(title) {
	$('#orgDialog').dialog({
		title : title
	});
	changeDesc();
	$('#orgDialog').dialog("open");
	$('#orgForm').form('clear');
	if(title.indexOf("新增")!=-1){
	}
	$("#isSeal").switchbutton("check");
	$('#saveBtn').linkbutton('enable');    //禁用按钮
	$('#closeBtn').linkbutton('enable');    //禁用按钮
	initParentOrgTree();
}

/**
 * 加载单位树（添加上级单位）
 */
function initParentOrgTree(){
	$("#parentOrgId").combotree({
		url:'orgController/findOrgTreeByUserId',
		queryParams:{
			orgId : $("#orgId").val()
		},
		onLoadSuccess:function(){
			var node = $('#orgTree').tree('getSelected');
			if(node!=null&&node.id!=''){
				$("#parentOrgId").combotree('setValue',node.id);
				setCombotreeEditable($('#parentOrgId'),false);
			}else{
				setCombotreeEditable($('#parentOrgId'),true);
			}
		}
	});
}

/**
 * 设置combotree是否可编辑
 * 
 * @param $obj combotree
 * @param editable 
 */
function setCombotreeEditable($obj,editable){
	if(editable){
		$obj.next("span").find("a").show();
		$obj.next("span").find("input[type=text]").removeAttr("disabled");
	}else{
		$obj.next("span").find("a").hide();
		$obj.next("span").find("input[type=text]").attr("disabled","disabled");
	}
}

//分配角色
function saveRole(){
	/*var node = $('#org_tree').tree('getSelected');
	var orgId = node.id;
	if(node==null||node.id==''){
		$.messager.alert('提示', '请先选择所属单位!');
		return;
	}*/
	var data = $('#orgTreeGrid').datagrid('getChecked');
	if (data == "") {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	var orgId = data[0].orgId;
	
	$('#select_role').datagrid('clearSelections');
	initSelectRole(orgId);
	$('#roleDialog').dialog('open');
}

function initSelectRole(orgId){
	$('#select_role').datagrid({
		url : 'orgController/initSelectRole',
		method : 'POST',
		idField : 'roleId',
		striped : true,
		queryParams:{
			orgId : orgId
		},
		fitColumns : true,
		fit: true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', checkbox : true }, 
		   { field : 'roleId', title : 'roleId', hidden : true }, 
		   { field : 'roleName', title : '角色名称', width : 80, align : 'left' },
		   { field : 'roleEname', title : '角色英文名', width : 120, align : 'left' },
		   { field : 'roleCode', title : '角色编码', width : 120, align : 'left' },
		   //{ field : 'createTime', title : '创建时间', width : 120, align : 'left' },
		   { field : 'roleDesc', title : '角色描述', width : 150, align : 'left'}
		]],
		onLoadSuccess : function(data) {
			if (data != null && data.rows[0] != null) {
				for(var i = 0;i < data.rows.length;i++){
					if(data.rows[i].checked == true){
						 $('#select_role').datagrid('selectRow',i);
					}
				}
            }
		},
	});
}

//分配角色
function doSaveRole(){
	var selecteds = $('#select_role').datagrid('getSelections');
	
	var ids = '';
	$(selecteds).each(function(index) {
		ids = ids + selecteds[index].roleId + ",";
	});
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	
	var data = $('#orgTreeGrid').datagrid('getChecked');
	var orgId = data[0].orgId;

	$.ajax({
		url : 'orgController/doSaveSelectRole',
		async : false,
		dataType : 'json',
		data : {roleIds : ids,orgId : orgId},
		success : function(result) {
			var msg = result;
			$('#roleDialog').dialog('close');
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			//reloadRoleList(userId);
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

/*************************** 格式化字段值 ***************************/
/**
 * 格式化单位编码
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formaterOrgCode(val, row) {
	return row.orgCode
}

/**
 * 格式化单位描述
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formaterOrgDesc(val, row) {
	return row.orgDesc
}

/**
 * 格式化创建时间
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formaterCreateTime(val, row) {
	//格式化时间，截取年月日
	return row.createTime.substring(0,10);
}

/**
 * 格式化树节点下的子节点总数
 * 
 * @param node 当前树节点
 * @return {String} 返回当前节点下的总数
 */
function formaterNodeCount(node) {
	var s = node.text;
	if (node.children) {
		s += '&nbsp;<span style=\'color:blue\'>('+ node.children.length + ')</span>';
	} else {
		s += '&nbsp;<span style=\'color:blue\'>(0)</span>';
	}

	return s;
}

/**
 * 上移
 * @author 张多一
 * @param modId 单位ID
 * @param parentId 父节点ID
 */
function doUpSort(orgId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		type : 'post',
		url : 'orgController/doUpSort',
		data : {
			orgId : orgId,
			parentId : parentId
		},
		dataType : 'json',
		success : function(data) {
			if (data.success) {
				$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
				//refresh the org list
				findByOrgId();
				//refresh the tree selected node
				freshTreeNode('orgTree',$('#orgTree').tree('getSelected'),'orgController/findChildrenNodesByIdUnderUserId');
			}
		}
	});
}

/**
 * 下移
 * @author 张多一
 * @param modId 模块ID
 * @param parentId 父节点ID
 */
function doDownSort(orgId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		type : 'post',
		url : 'orgController/doDownSort',
		data : {
			orgId : orgId,
			parentId : parentId,
			orgId : orgId
		},
		dataType : 'json',
		success : function(data) {
			if (data.success) {
				$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
				//refresh the org list
				findByOrgId();
				//refresh the tree selected node
				freshTreeNode('orgTree',$('#orgTree').tree('getSelected'),'orgController/findChildrenNodesByIdUnderUserId');
			}

		}
	});
}

/**
 * 格式化上移下级操作
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatOperate(val, row) {
	var id = row.orgId;
	var parentId = row.parentOrgId;
	return '<img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/up.png" onclick="doUpSort(\''+id+'\',\''+parentId+'\')"/>'
		  +'&nbsp;&nbsp;<img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/down.png" onclick="doDownSort(\''+id+'\',\''+parentId+'\')" />';
}

/**
 * 格式化树节点下的子节点总数
 * 
 * @param node 当前树节点
 * @return {String} 返回当前节点下的总数
 */
function formaterIsSeal(val, row) {
	if (val == "Y") {
		return "<span style=\'color:red\'>是</span>";
	} else {
		return "否";
	}
}


/*************************** 公共函数 *****************************/
/**
 * 清空单位列表选中的行
 * 
 * @param 无
 * @returns 无
 */
function clearGridChecked() {
	$('#orgTreeGrid').datagrid('clearChecked');
}

/**
 * 清空查询框值
 * 
 * @param 无
 * @returns 无
 */
function clearSearchBox(){
	 $("#search").searchbox("setValue", "");
	 $("#org_search").searchbox("setValue","");
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	
	$("#orgTree").tree('search',searchValue);
}

/**
 * 单位排序
 */
function sortOrg(){
	var node = $('#orgTree').tree('getSelected');
	if (node == null) {
		//$.messager.alert('提示', '请选择所属单位！', 'info');
		layer.tips('请选择所属单位', '#btn_org_sort', { tips: 3 });
		return;
	} 
	
	// 组装查询条件
	var orgId = '0';
	var node = $('#orgTree').tree('getSelected');
	if (node != null && node.id != '') {
		orgId = node.id;
	}

	// 加载组织机构列表树
	$('#orgSortGrid').datagrid({
		url : 'orgController/findChildrenById',
		view:scrollview,
		emptyMsg : '没有相关记录！',
		autoRowHeight:false,
		pageSize:10,
		queryParams : {
			orgId : orgId,
		},
	});
	//直接从第一页加载
	$('#orgTreeGrid').datagrid('load');
	jsonArr = [];
	
	$('#sortDialog').dialog('open');
}

/**
 * 保存
 * */
function doSaveSort(){
	/** 取消还在编辑状态的单元格的编辑状态*/
	if (endEditing()) {
		getSortData(editId);
		editId = undefined;
	}
	
	var jsonStr = JSON.stringify(jsonArr);
	if (!jsonStr) {
		return;
	}
	//alert(jsonStr);return;
	$.ajax({
		url : "orgController/doSaveSort",
		type : "post",
		async : false,
		data : {
			jsonStr : jsonStr
		},
		success : function(data) {
			jsonArr = [];
			if (data.success == 'true') {
				
				$('#orgSortGrid').datagrid('load');
				window.top.msgTip("保存成功!");
			} else {
				window.top.msgTip("保存失败!");
			}
		}
	});
}

function fetch(page,row){
	if (row == '') {
		return;
	}
	if (editId != undefined) {
		getSortData(editId);
		editId = undefined;
	}
}

var editId = undefined;//当前编辑的索引
var jsonArr = [];
/**
 * 点击单元格事件
 * */
function onClickRow(index, row){
//	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if (endEditing()){
		$('#orgSortGrid').datagrid('selectRow', index);
		//alert(index);
		editId = row.orgId;
	}
}

/**
 * 结束编辑状态
 * */
function endEditing(){
	if (editId == undefined){return true};
	getSortData(editId);
	editId = undefined;
	return true;
}

/**
 * 取消行编辑事件
 * */
function cancelEdit(){
	if (endEditing()) {
		getSortData(editId);
		editId = undefined;
	}
}

function getSortData(editId){
	if (editId == undefined) {
		return;
	}
	var val = $("#"+editId).val();
	if (isNaN(val)){
		$.messager.alert('提示', '请输入数字！','info');
		$("#"+editId).val("");
		return;
	}
	var flag = false; 
	if (jsonArr != '') {
		for (var i = 0;i < jsonArr.length;i++){
			if(editId == jsonArr[i].orgId){
				jsonArr[i].sort = val;
				flag = true;
				break;
			}
		}
	}
	if (!flag) {
		var data = {};
		data.orgId = editId;
		data.sort = val;
		jsonArr.push(data);
	}
}

function formaterOrgSort(val, row){
	if (jsonArr != '') {
		for (var i = 0;i < jsonArr.length;i++){
			if(row.orgId == jsonArr[i].orgId){
				val = jsonArr[i].sort;
				break
			}
		}
	}
	if(val == null) val='';
	return '<input type="text" onChange="changeSort(\''+row.orgId+'\')" id='+row.orgId+' value=\''+val+'\' class="datagrid-editable-input numberbox-f" style="margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 30px; line-height: 30px;width:99%">'
}

function changeSort(orgId){
	getSortData(orgId);
	editId = undefined;
}

/**
 * 监控名称的改变，描述跟着改变
 */
function changeDesc(){
    $('#orgName').textbox({
        onChange: function(value){ 
            var orgName = $("#orgName").textbox("getValue");
            $("#orgDesc").textbox("setValue",orgName);
        }
      });  
}