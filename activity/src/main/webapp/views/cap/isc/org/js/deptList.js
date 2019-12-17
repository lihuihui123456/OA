/**
 * 页面初始化时加载相关函数
 */
$(function() {
	initOrgTree();
});

/**
 * 初始化加载左侧树
 * 
 * @param 无
 * @return 无
 */
function initOrgTree() {
	$('#orgTree').tree({
		url : "orgController/findUnSealedChildrenNodesByIdUnderUserId",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		//formatter : formaterNodeCount,
		onClick : function(node) {
			//展开点击选中的节点
			$('#orgTree').tree('expand', node.target)
			var node = $('#orgTree').tree('getSelected');
			findDeptByOrgId(node.id);
		}
	});
}

/**
 * 加载部门树（添加上级部门）
 * 
 * @param 无
 * @return 无
 */
function initParentDeptTree(deptId){
	$("#parentDeptId").combotree({
		url:'deptController/findDeptTreeForLevel',
		queryParams:{
			orgId : $('#orgTree').tree('getSelected').id,
			deptId : deptId
		}
	});
	refuseBackspace('parentDeptId');
}

/**
 * 加载部门类型树
 * 
 * @param 无
 * @return 无
 */
function initDeptTypeTree(){
	$("#deptTypeId").combotree({
		url:'deptTypeController/findNoSealDeptTypeTree'
	});
	refuseBackspace('deptTypeId');
}
/**
 * 加载部门类型树
 * @param 无
 * @return 无
 */
function initNotSealDeptTypeTree(deptTypeId){
	$("#deptTypeId").combotree({
		url:'deptTypeController/findNoSealDeptTypeTree'+'?deptTypeId='+deptTypeId
	});
	refuseBackspace('deptTypeId');
}

/**
 * 查看组织机构图
 */
function showDeptPic() {
	//TODO
	//get tree select
	var orgId = '';
	var type = '';
	var node = $('#orgTree').tree('getSelected');
	if (node != null && node.id != '') {
		orgId = node.id;
		type = node.dtype;
	}
	
	var feature = 'FullScreen=yes,scrollbars=yes,menubar=no,resizable=yes,location=no,status=no,toolbar=no';  
	var win = window.open(path+"/orgController/findOrgDeptChart?id="+orgId+"&type="+type, '部门结构图', feature);  
	win.resizeTo(screen.width, screen.height);  
}

function findByCondition(){
	var searchValue = $("#search").searchbox('getValue');
	//筛选查询条件
	if(searchValue!=null&&searchValue.indexOf('%')>=0){
		$.messager.alert('提示', '输入非法查询字符\'%\'！', 'info');
		return;
	}
	var node = $('#orgTree').tree('getSelected');
	if(node==null){
		$.messager.alert('提示', '请选择所属单位！', 'info');
		return ;
	}
	$('#deptTreeGrid').treegrid('loadData',[]);
	$('#deptTreeGrid').treegrid({
		url : 'deptController/findByCondition',
		queryParams:{
			orgId:node.id,
			searchValue: $.trim(searchValue)
		},
		onClickRow: function(row){
			//cancel all select
			$('#deptTreeGrid').treegrid("clearChecked");
			$('#deptTreeGrid').treegrid("select",row.id);
		}/*,
		onLoadSuccess: function(row, data) {
			$.messager.show({ title:'提示', msg:'搜索到 <span style="color:red">'+data.length+'</span> 条数据', showType:'slide' });
		}*/
	});
}

/**
 * 根据当前单位ID查询下级部门
 * 
 * @param 无
 * @return 无
 */
function findDeptByOrgId(orgId){
	$('#deptTreeGrid').treegrid('loadData',[]);
	$('#deptTreeGrid').treegrid({
		url : 'deptController/findDeptTree',
		queryParams:{
			orgId:orgId
		},
		pageSize : 10,
		onClickRow: function(row){
			//cancel all select
			$('#deptTreeGrid').treegrid("clearChecked");
			$('#deptTreeGrid').treegrid("select",row.id);
		}
	});

	// 清空单位列表树选中的行 
	clearGridChecked();
}

/**
 * 新增部门信息
 * 
 * @param 无
 * @return 无
 */
function doAddDeptBefore(){
	var node = $('#orgTree').tree('getSelected');
	if(node!=null){
		initDeptDlg("新增部门");
	}else{
		layer.tips('请选择所属单位', '#btn_dept_add', { tips: 3 });
		//$.messager.alert('提示', '请选择所属单位！', 'info');
	}
}

/**
 * 修改部门信息
 * 
 * @param 无
 * @return 无
 */
function doDeleteDept(){
	var selecteds = $('#deptTreeGrid').treegrid('getSelections');
	if (selecteds == null || selecteds.length != 1) {
		layer.tips('请选择需要删除的记录', '#btn_dept_del', { tips: 3 });
		//$.messager.alert('提示', '请选择一行记录删除！', 'info');
		return;
	}else{
		var children = $('#deptTreeGrid').treegrid('getChildren',selecteds[0].id);
		if(children!=null&&children.length>0){
			layer.tips('请先删除下级部门', '#btn_dept_del', { tips: 3 });
			//$.messager.alert('提示', '请先删除下级部门！', 'info');
			return;
		}
	}
	$.messager.confirm('删除部门', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].id + ",";
			});

			ids = ids.substring(0, ids.length - 1);
			$.ajax({
				url : 'deptController/doDeleteDept',
				async : false,
				dataType : 'text',
				data : {
					ids : ids
				},
				success : function(result) {
					if(result=="true"){
						$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
						$('#deptTreeGrid').treegrid('clearSelections'); // 清空选中的行
						var node = $('#orgTree').tree('getSelected');
						findDeptByOrgId(node.id);
					}else if(result=="01"){
						$.messager.show({ title:'提示', msg:'部门下有岗位，不能删除！请先删除岗位', showType:'slide' });
					}else if(result=="false"){
						$.messager.show({ title:'提示', msg:'删除失败!', showType:'slide' });
					}
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 修改部门信息
 * 
 * @param 无
 * @return 无
 */
function doUpdateDeptBefore(){
	var nodes = $('#deptTreeGrid').treegrid('getChecked');
	if(nodes==null||nodes.length!=1){
		layer.tips('请选择一行记录进行修改', '#btn_dept_update', { tips: 3 });
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		return;
	}
	$.ajax({
		url : 'deptController/findDeptById',
		async : false,
		dataType : 'json',
		data : {
			id : nodes[0].id
		},
		success : function(dept) {
			if (dept != null) {
				initDeptModifyDlg("修改部门",dept.deptTypeId,dept.deptId);
				$(":hidden[name=deptId]").val(dept.deptId);
				$("#deptName").val(dept.deptName);
				$("#deptCode").val(dept.deptCode);
				if(dept.deptTypeId!=null&&dept.deptTypeId!=""){
					$('#deptTypeId').combotree('setValue', dept.deptTypeId);
				}
				if(dept.orgId!=null&&dept.orgId!=""){
					$('#orgId').val(dept.orgId);
					var pnode = $("#orgTree").tree("find",dept.orgId);
					$("#orgName").val(pnode==null?"":pnode.text);
				}
				if(dept.parentDeptId!=dept.orgId){
					$('#parentDeptId').combotree('setValue', dept.parentDeptId);
				}else{
					$('#parentDeptId').combotree('setValue', "0000");
				}
				//setCombotreeEditable($("#parentDeptId"),false);
				var isSeal = dept.isSeal;
				if (isSeal == "N") {
					$("#isSeal").switchbutton("check"); 
				} else {
					$("#isSeal").switchbutton("uncheck"); 
				}
				$("#deptDesc").textbox("setValue", dept.deptDesc);
				$("#deptForm").form('validate');
			}
			$('#dept_List').datagrid('clearSelections'); // 清空选中的行
		},
		error : function(result) {
			$.messager.show({ title:'提示', msg:'修改失败', showType:'slide' });
		}
	});
}

/**
 * 保存新增修改单位
 * 
 * @param 无
 * @return 无
 */
function doSaveOrUpdateDept(){
	var deptId = $("#deptId").val();
	var url = "";
	if (deptId == undefined || deptId == '') {
		url = "deptController/doSaveDept";
	} else {
		$("#parentDeptId").removeAttr("disabled");
		url = "deptController/doUpdateDept";
	}
	var is_Seal = $("#isSeal").switchbutton("options").checked;
	if (is_Seal) {
		is_Seal = "N";
	} else {
		is_Seal = "Y";
	}
	var obj = $('#deptForm').serialize()+'&'+'isSeal='+is_Seal;
	$.ajax({
		url : url,
		async : false,
		type : "post",
		data : obj,
		beforeSend : function() {
			$('input.easyui-validatebox').validatebox('enableValidation');
			return $('#deptForm').form('validate');
		},
		success : function(data) {
			
			if(data=="true"){
				if (deptId == undefined || deptId == '') {
					$.messager.show({ title:'提示', msg:'添加成功', showType:'slide' });
				}else{
					$.messager.show({ title:'提示', msg:'修改成功', showType:'slide' });
				}
				$('#deptDialog').dialog("close");
				$('#deptTreeGrid').treegrid('clearChecked');
				var node = $('#orgTree').tree('getSelected');
				findDeptByOrgId(node.id);
			}else{
				if (deptId == undefined || deptId == '') {
					$.messager.show({ title:'提示', msg:'添加失败，部门名字重复!', showType:'slide' });
				}else{
					$.messager.show({ title:'提示', msg:'修改失败，部门名字重复!', showType:'slide' });
				}
			}
			

		} 
	});
}

/**
 * 初始化用户信息编辑对话框 初始化面板 初始化数据
 * 
 * @param 无
 * @return 无
 */
function initDeptDlg(title) {
	$('#deptDialog').dialog({
		title : title
	});
	$('#deptForm').form('clear');
	if(title.indexOf("新增")!=-1){
		var node = $('#orgTree').tree('getSelected');
		if(node!=null){
			$("#orgId").val(node.id);
			$("#orgName").val(node.text);
		}
	}
	$("#createTime").parent().parent().hide();
	$("#isSeal").switchbutton("check");
	initParentDeptTree();
	initDeptTypeTree();
	
	var selecteds = $('#deptTreeGrid').treegrid('getChecked');
	if (selecteds != null && selecteds.length == 1) {
		$("#parentDeptId").combotree('setValue',selecteds[0].id);
	} else {
		$('#parentDeptId').combotree('setValue', "0000");
	}
	changeDesc();
	$('#deptDialog').dialog("open");
}
/**
 * 初始化用户信息编辑对话框 初始化面板 初始化数据
 * 
 * @param 无
 * @return 无
 */
function initDeptModifyDlg(title,deptTypeId,deptId) {
	$('#deptDialog').dialog({
		title : title
	});
	$('#deptForm').form('clear');
	if(title.indexOf("新增")!=-1){
		var node = $('#orgTree').tree('getSelected');
		$("#orgId").val(node.id);
		$("#orgName").val(node.text);
	}
	$("#createTime").parent().parent().hide();
	$("#isSeal").switchbutton("check");
	initParentDeptTree(deptId);
	initNotSealDeptTypeTree(deptTypeId);
	changeDesc();
	$('#deptDialog').dialog("open");
}

/**
 * 设置combotree是否可编辑
 * 
 * @param $obj combotree
 * @param editable 
 */
function setCombotreeEditable($obj,editable){
	if(editable){
		$obj.next("span").find("a").removeAttr("disabled");
		$obj.next("span").find("input[type=text]").removeAttr("disabled");
	}else{
		$obj.next("span").find("a").attr("disabled","disabled");
		$obj.next("span").find("input[type=text]").attr("disabled","disabled");
	}
}

/*************************** 格式化字段值 ***************************/
/**
 * 格式化部门编码
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formaterDeptCode(val, row) {
	return row.attributes.deptCode
}

/**
 * 格式化部门描述
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formaterDeptDesc(val, row) {
	return row.attributes.deptDesc
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
	return row.attributes.createTime.substring(0,10);
}

/**
 * 格式化树节点下的子节点总数
 * 
 * 返回格式如：XXX单位(4)
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

/*************************** 公共函数 *****************************/
/**
 * 上移
 * @author 张多一
 * @param modId 单位ID
 * @param parentId 父节点ID
 */
function doUpSort(deptId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	var node = $('#orgTree').tree('getSelected');
	$.ajax({
		type : 'post',
		url : 'deptController/doUpSort',
		data : {
			deptId : deptId,
			parentId : parentId,
			orgId:node.id
		},
		dataType : 'json',
		success : function(data) {
			if (data.success) {
				$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
				var node = $('#orgTree').tree('getSelected');
				findDeptByOrgId(node.id);
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
function doDownSort(deptId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	var node = $('#orgTree').tree('getSelected');
	$.ajax({
		type : 'post',
		url : 'deptController/doDownSort',
		data : {
			deptId : deptId,
			parentId : parentId,
			orgId:node.id
		},
		dataType : 'json',
		success : function(data) {
			$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
			var node = $('#orgTree').tree('getSelected');
			findDeptByOrgId(node.id);
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
	var id = row.id;
	var parentId = row.parent_id;
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
	if (row.attributes.isSeal == "Y") {
		return "<span style=\'color:red\'>是</span>";
	} else {
		return "否";
	}
}

/**
 * 清空单位列表选中的行
 * 
 * @param 无
 * @returns 无
 */
function clearGridChecked() {
	$('#deptTreeGrid').treegrid('clearChecked');
}

/**
 * 清空查询框值
 * 
 * @param 无
 * @returns 无
 */
function clearSearchBox(){
	 $("#search").searchbox("setValue","");
	 $("#org_search").searchbox("setValue","");
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#orgTree").tree('search',searchValue);
}

//分配角色
var deptId = '';
function saveRole(){
	var node = $('#orgTree').tree('getSelected');
	if(node == null){
		//$.messager.alert('提示', '请选择所属单位！', 'info');
		layer.tips('请选择所属单位', '#btn_dept_role', { tips: 3 });
		return ;
	}
	var orgId = node.id;
	var nodes = $('#deptTreeGrid').treegrid('getChecked');
	if(nodes==null||nodes.length!=1){
		$.messager.alert('提示', '请选择一行进行操作！', 'info');
		return;
	}
	deptId = nodes[0].id;
	
	//$('#select_role').datagrid('clearSelections');
	initSelectRole(orgId,deptId);
	$('#roleDialog').dialog('open');
}

function initSelectRole(orgId,deptId){
	$.ajax({
		url : 'deptController/initSelectRole',
		async : false,
		dataType : 'text',
		data : {
			orgId : orgId,
			deptId : deptId
		},
		success : function(result) {
			result = eval("("+result+")").rows;
			//$('#tb1').datagrid('loadData',result);
			var sel1 = [];//未选择角色数组
			var sel2 = [];//已选择角色数组
			var i = 0;
			var j = 0;
			$.each(result, function(index, item) {
				if(result[index].checked){
					sel2[i] = result[index];
					i++;
				}else{
					sel1[j] = result[index];
					j++;
				}
				//option = "<option value='"+result[index].roleId+"'>"+result[index].roleName+"</option>";
			});
			$('#tb1').datagrid('loadData',sel1);
			$('#tb2').datagrid('loadData',sel2);
		},
		error : function(result) {
			$.messager.show({ title:'提示', msg:'执行失败', showType:'slide' });
		}
	});
}

//分配角色
function doSaveRole(){
	var rows = $("#tb2").datagrid("getRows");
	var ids = '';
	$(rows).each(function(index) {
		ids = ids + rows[index].roleId + ",";
	});
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	
	$.ajax({
		url : 'deptController/doSaveSelectRole',
		async : false,
		dataType : 'json',
		data : {roleIds : ids,deptId : deptId},
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

function add(obj) {
	var data = $('#tb1').datagrid('getSelections');
	if (data) {
		$(data).each(function(index) {
			$('#tb2').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
			
			var rowIndex = $('#tb1').datagrid('getRowIndex', data[index]);
	        $('#tb1').datagrid('deleteRow', rowIndex);
		});
	}
}

function addAll(obj) {
	var data = $('#tb1').datagrid('getRows');
	if (data) {
		$(data).each(function(index) {
			$('#tb2').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
		});
		$('#tb1').datagrid('loadData',[]);
	}
}

function del(obj) {
	var data = $('#tb2').datagrid('getSelections');
	if (data) {
		$(data).each(function(index) {
			$('#tb1').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
			
			var rowIndex = $('#tb2').datagrid('getRowIndex', data[index]);
	        $('#tb2').datagrid('deleteRow', rowIndex);
		});
	}
}

function delAll(obj) {
	var data = $('#tb2').datagrid('getRows');
	if (data) {
		$(data).each(function(index) {
			$('#tb1').datagrid('appendRow', {
				"roleId" : data[index].roleId,
				"roleName" : data[index].roleName
			});
		});
		$('#tb2').datagrid('loadData',[]);
	}
}

function sortDept(){
	var node = $('#orgTree').tree('getSelected');
	if(node == null){
		//$.messager.alert('提示', '请选择所属单位！', 'info');
		layer.tips('请选择所属单位', '#btn_dept_sort', { tips: 3 });
		return;
	}
	
	var orgId = node.id;
	$('#tg').treegrid('loadData',[]);
	$('#tg').treegrid({
		url : 'deptController/findDeptTree',
		queryParams:{
			orgId:orgId
		},
		pageSize : 10,
		onClickRow: function(row){
			//cancel all select
			$('#tg').treegrid("clearChecked");
			$('#tg').treegrid("select",row.id);
		}
	});
	jsonArr = [];
	$('#sortDialog').dialog('open');
}

/*var editingId = undefined;
var jsonArr = [];
function edit(field,row){
	var id = row.id;
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$('#tg').treegrid("clearSelections");
	$('#tg').treegrid('select', id);
	if (endEditing()){
		//var row = $('#tg').treegrid('getSelected');
		if (id){
			editingId = id
			$('#tg').treegrid('beginEdit', editingId);
		}
	}
}

function cancel(){
	if (editingId != undefined){
		$('#tg').treegrid('endEdit', editingId);

		save(editingId);
		editingId = undefined;
	}
}

function endEditing(){
	if (editingId == undefined){return true}
	if ($('#tg').treegrid('validateRow', editingId)){
		
		var row = $('#tg').treegrid('getSelected');
		
		$('#tg').treegrid('endEdit', editingId);
		
		save(editingId);
		editingId = undefined;
		return true;
	} else {
		return false;
	}
}

function save(editingId){
	if (editingId == undefined) {
		return;
	}
	var row = $('#tg').treegrid("find",editingId);
	
	var data = {};
	data.deptId = row.id;
	data.sort = row.sort;
	jsonArr.push(data);
}

function doSaveSort(){
	*//** 取消还在编辑状态的单元格的编辑状态*//*
	if (editingId != undefined){
		$('#tg').treegrid('endEdit', editingId);

		save(editingId);
		editingId = undefined;
	}
	
	var jsonStr = JSON.stringify(jsonArr);
	if (!jsonStr) {
		return;
	}
	$.ajax({
		url : "deptController/doSaveSort",
		type : "post",
		async : false,
		data : {
			jsonStr : jsonStr
		},
		success : function(data) {
			jsonArr = [];
			if (data.success == 'true') {
				$('#tg').treegrid('load');
				window.top.msgTip("保存成功!");
			} else {
				window.top.msgTip("保存失败!");
			}
		}
	});
}*/

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
		url : "deptController/doSaveSort",
		type : "post",
		async : false,
		data : {
			jsonStr : jsonStr
		},
		success : function(data) {
			jsonArr = [];
			if (data.success == 'true') {
				$('#tg').treegrid('load');
				window.top.msgTip("保存成功!");
			} else {
				window.top.msgTip("保存失败!");
			}
		}
	});
}

var editId = undefined;//当前编辑的索引
var jsonArr = [];
/**
 * 点击单元格事件
 * */
function onClickRow(index, row){
//	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$('#tg').treegrid("clearSelections");
	if (endEditing()){
		$('#tg').datagrid('select', row.id);
		//alert(index);
		editId = row.id;
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
			if(editId == jsonArr[i].deptId){
				jsonArr[i].sort = val;
				flag = true;
				break;
			}
		}
	}
	if (!flag) {
		var data = {};
		data.deptId = editId;
		data.sort = val;
		jsonArr.push(data);
	}
}

function formaterOrgSort(val, row){
	if (jsonArr != '') {
		for (var i = 0;i < jsonArr.length;i++){
			if(row.id == jsonArr[i].deptId){
				val = jsonArr[i].sort;
				break
			}
		}
	}
	if(val == null) val='';
	return '<input type="text" onChange="changeSort(\''+row.id+'\')" id='+row.id+' value=\''+val+'\' class="datagrid-editable-input numberbox-f" style="margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 30px; line-height: 30px;width:99%">'
}

function changeSort(orgId){
	getSortData(orgId);
	editId = undefined;
}

/**
 * 监控名称的改变，描述跟着改变
 */
function changeDesc(){
    $('#deptName').textbox({
        onChange: function(value){
            var deptName = $("#deptName").textbox("getValue");
            $("#deptDesc").textbox("setValue",deptName);
        }
      });  
}