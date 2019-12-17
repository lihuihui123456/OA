/**
 * 页面初始化时加载相关函数
 */
$(function() {
	// 初始化单位树
	initDeptTree();
	//set the datagrid only one row can be selected
	$('#postDataGrid').datagrid({
		onClickRow: function(index,row){
			//cancel all
			$('#postDataGrid').datagrid("clearChecked");
			//check the select row
			$('#postDataGrid').datagrid("selectRow", index);
		}
	});
});

/**
 * 初始化加载左侧单位树（单位+部门）
 * 
 * @param 无
 * @return 无
 */
function initDeptTree() {
	$('#org_dept_tree').tree({
		url : "orgController/findUnsealedChildOrgDeptTreeAsync",
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		//formatter : formaterNodeCount,
		onClick : function(node) {
			//展开点击选中的节点
			$('#org_dept_tree').tree('expand', node.target)
			// 点击单位节点时，加载单位下的所有部门
			var node = $('#org_dept_tree').tree('getSelected');
			if(node.dtype == null || node.dtype != '1'){
				return ;
			}
			findByDeptId(node.id);
		}
	});
}

/**
 * 加载岗位类型
 */
function initPostTypeTree(postTypeId){
	var treeNode=$('#org_dept_tree').tree('getSelected');
	
	$("#post_type_id").combotree({
		url:'postTypeController/findPostTypeTree',
		queryParams:{
			orgId: treeNode.attributes.orgId,
			postTypeId:postTypeId
		}
	});
	refuseBackspace("post_type_id");
}

function findByCondition(){
	var searchValue = $("#search").searchbox('getValue');
	//筛选查询条件
	if(searchValue!=null&&searchValue.indexOf('%')>=0){
		$.messager.alert('提示', '输入非法查询字符\'%\'！', 'info');
		return;
	}
	var node = $('#org_dept_tree').tree('getSelected');
	if(node==null){
		$.messager.alert('提示', '请选择所属单位！', 'info');
		return ;
	}
	$('#postDataGrid').datagrid({
		url : 'postController/findByCondition',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams:{
			deptId:node.id,
			searchValue: $.trim(searchValue)
		},
		onLoadSuccess: function(data) {
			//$.messager.show({ title:'提示', msg:'搜索到 <span style="color:red">'+data.rows.length+'</span> 条数据', showType:'slide' });
		}
	});
	$('#postDataGrid').datagrid('load');
}

/**
 * 查询单位下岗位
 */
function findByDeptId(deptId){
	$('#postDataGrid').datagrid({
		url : 'postController/findByCondition',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams:{
			deptId:deptId
		},
		columns : [[ {field:'ck', checkbox:true},
		             {field:'postId', hidden:true},
		             {field:'postName',title : '岗位名称', width:150, align:'left'},
		             {field:'postCode',title : '岗位编码', width:150, align:'left'},
		             {field:'postDesc',title : '岗位描述', width:150, align:'left'},
		 		    { field : 'isSeal', title : '是否封存', width :70, align : 'center',
		 		    	formatter:function(value,row){
		 		    		if(value == 'Y'){
		 		    			return "<span style=\'color:red\'>是</span>";
		 		    		}else{
		 		    			return '否';
		 		    		}
		 		    	}
		 		    },
		             {field:'createTime',title : '创建日期', width:120, align:'left', formatter:formaterCreateTime},
		             { field : 'operate', title : '操作', width : 100, align : 'center', formatter : formatOperate }
				] ]
	});
	$('#postDataGrid').datagrid('load');
	$('#postDataGrid').datagrid('clearSelections'); // 清空选中的行
}

/**
 * 新增岗位信息
 */
function doAddPostBefore(){
	var node = $('#org_dept_tree').tree('getSelected');
	if(node!=null){
		//树节点dtype 0 单位 1部门2岗位
		if(node.dtype=='0'){
			$.messager.alert('提示', '单位下不能直接挂岗位！', 'info');
			return;
		}
		if(node.dtype=='2'){
			$.messager.show({ title:'提示', msg:'岗位下不能挂岗位', showType:'slide' });
			return;
		}
		initPostDlg("新增岗位");
	}else{
		//$.messager.alert('提示', '请选择所属单位！', 'info');
		layer.tips('请选择所属单位', '#btn_post_add', { tips: 3 });
	}
}

/**
 * 删除岗位信息
 */
function doDeletePost(){
	var selecteds = $('#postDataGrid').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择操作项！', 'info');
		layer.tips('请选择操作项', '#btn_post_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除岗位', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].postId + ",";
			});

			ids = ids.substring(0, ids.length - 1);
			$.ajax({
				url : 'postController/doDeletePost',
				async : false,
				dataType : 'text',
				data : {
					ids : ids
				},
				success : function(result) {
					if(result=="true"){
						$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
						$('#postDataGrid').datagrid('clearSelections'); // 清空选中的行
						var node = $('#org_dept_tree').tree('getSelected');
						findByDeptId(node.id);
					}else if(result=="false"){
						$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
					}else if(result=="01"){
						$.messager.show({ title:'提示', msg:'删除岗位下有人员，请先删除人员！', showType:'slide' });
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
 * 修改岗位信息
 */
function doUpdatePostBefore(){
	var nodes = $('#postDataGrid').treegrid('getChecked');
	if(nodes==null||nodes.length!=1){
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		layer.tips('请选择一行进行修改', '#btn_post_edit', { tips: 3 });
		return;
	}
	$.ajax({
		url : 'postController/findPostById',
		async : false,
		dataType : 'json',
		data : {
			id : nodes[0].postId
		},
		success : function(post) {
			if (post != null) {
				var title = "修改岗位";
				$('#post_dialog').dialog({
					title : title
				});
				changeDesc();
				$('#post_dialog').dialog("open");
				$('#post_form').form('clear');
				if(title.indexOf("新增")!=-1){
					var node = $('#org_dept_tree').tree('getSelected');
					$("#dept_id").val(node.id);
					$("#dept_name").val(node.text);
				}
				$("#isSeal").switchbutton("check");
				$("#create_time").parent().parent().hide();
				initPostTypeTree(post.postTypeId);
				
				$(":hidden[name=postId]").val(post.postId);
				$("#post_name").val(post.postName);
				$("#post_code").val(post.postCode);
				if(post.postTypeId!=null&&post.postTypeId!=""){
					$('#post_type_id').combotree('setValue', post.postTypeId);
				}
//				setCombotreeEditable($("#post_type_id"),false);
				if(post.deptId!=null&&post.deptId!=""){
					$('#dept_id').val(post.deptId);
					var pnode = $("#org_dept_tree").tree("find",post.deptId);
					$("#dept_name").val(pnode==null?"":pnode.text);
				}
				setCombotreeEditable($("#parent_post_id"),false);
				var isSeal = post.isSeal;
				if (isSeal == "N") {
					$("#isSeal").switchbutton("check"); 
				} else {
					$("#isSeal").switchbutton("uncheck"); 
				}
				//$("#post_desc").val(post.postDesc);
				$("#post_desc").textbox('setValue',post.postDesc);
				$("#post_form").form('validate');
			}
			$('#post_List').datagrid('clearSelections'); // 清空选中的行
		},
		error : function(result) {
			$.messager.show({ title:'提示', msg:'修改失败', showType:'slide' });
		}
	});
}

/**
 * 保存新增修改单位
 */
function doSaveOrUpdatePost(){
	var postId = $("#post_id").val();
	var url = "";
	if (postId == undefined || postId == '') {
		url = "postController/doSavePost";
	} else {
		$("#parent_post_id").removeAttr("disabled");
		url = "postController/doUpdatePost";
	}
	var is_Seal = $("#isSeal").switchbutton("options").checked;
	if (is_Seal) {
		is_Seal = "N";
	} else {
		is_Seal = "Y";
	}
	var obj = $('#post_form').serialize()+'&'+'isSeal='+is_Seal;
	$.ajax({
		url : url,
		async : false,
		type : "post",
		data : obj,
		beforeSend : function() {
			$('input.easyui-validatebox').validatebox('enableValidation');
			return $('#post_form').form('validate');
		},
		success : function(data) {
			if(data!='false'){
				
				if (postId == undefined || postId == '') {
					$.messager.show({ title:'提示', msg:'添加成功', showType:'slide' });
				}else{
					$.messager.show({ title:'提示', msg:'修改成功', showType:'slide' });
				}
				$('#post_dialog').dialog("close");
				$('#postDataGrid').datagrid('clearChecked');
				var node = $('#org_dept_tree').tree('getSelected');
				findByDeptId(node.id);
			}else{
				$.messager.show({ title:'提示', msg:'该部门此岗位已存在！', showType:'slide' });
				
			}
		} 
	});
}

/**
 * 初始化用户信息编辑对话框 初始化面板 初始化数据
 */
function initPostDlg(title) {
	$('#post_dialog').dialog({
		title : title
	});
	changeDesc();
	$('#post_dialog').dialog("open");
	$('#post_form').form('clear');
	if(title.indexOf("新增")!=-1){
		var node = $('#org_dept_tree').tree('getSelected');
		$("#dept_id").val(node.id);
		$("#dept_name").val(node.text);
	}
	$("#isSeal").switchbutton("check");
	$("#create_time").parent().parent().hide();
	initPostTypeTree();
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
 * 格式化创建时间
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formaterCreateTime(val, row) {
	//格式化时间，截取年月日
	return val.substring(0,10);
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
	$("#org_dept_tree").tree('search',searchValue);
}

//分配角色
var postId = '';
function saveRole(){
	var node = $('#org_dept_tree').tree('getSelected');
	if(node == null){
		//$.messager.alert('提示', '请选择所属单位！', 'info');
		layer.tips('请选择所属单位', '#btn_post_role', { tips: 3 });
		return ;
	}
	var deptId = node.id;
	//var _orgId = getOrgId(node);
	var _orgId = node.attributes.orgId;
	var nodes = $('#postDataGrid').datagrid('getChecked');
	if(nodes==null||nodes.length!=1){
		//$.messager.alert('提示', '请选择一行进行操作！', 'info');
		layer.tips('请选择一行进行操作', '#btn_post_role', { tips: 3 });
		return;
	}
	postId = nodes[0].postId;
	
	//$('#select_role').datagrid('clearSelections');
	initSelectRole(_orgId,postId);
	$('#roleDialog').dialog('open');
}

function initSelectRole(orgId,postId){
	$.ajax({
		url : 'postController/initSelectRole',
		async : false,
		dataType : 'text',
		data : {
			postId : postId,
			orgId : orgId
		},
		success : function(result) {
			result = eval("("+result+")");
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

function getOrgId(node){
	var father = $('#org_dept_tree').tree("getParent",node.target);
	if (father.dtype != '0') {
		getOrgId(father);
	} else {
		return father.id;
	}
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
		url : 'postController/doSaveSelectRole',
		async : false,
		dataType : 'json',
		data : {roleIds : ids,postId : postId},
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

/**
 * 上移
 * @author 张多一
 * @param modId 单位ID
 * @param parentId 父节点ID
 */
function doUpSort(postId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		type : 'post',
		url : 'postController/doUpSort',
		data : {
			postId : postId,
			deptId : parentId
		},
		dataType : 'json',
		success : function(data) {
			if (data.success) {
				$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
				var node = $('#org_dept_tree').tree('getSelected');
				findByDeptId(node.id);
			}else{
				$.messager.show({ title:'提示', msg:'操作失败', showType:'slide' });
				var node = $('#org_dept_tree').tree('getSelected');
				findByDeptId(node.id);
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
function doDownSort(postId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		type : 'post',
		url : 'postController/doDownSort',
		data : {
			postId : postId,
			deptId : parentId
		},
		dataType : 'json',
		success : function(data) {
			if (data.success) {
				$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
				var node = $('#org_dept_tree').tree('getSelected');
				findByDeptId(node.id);
			}else{
				$.messager.show({ title:'提示', msg:'操作失败', showType:'slide' });
				var node = $('#org_dept_tree').tree('getSelected');
				findByDeptId(node.id);
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
	var id = row.postId;
	var parentId = row.deptId;
	return '<img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/up.png" onclick="doUpSort(\''+id+'\',\''+parentId+'\')"/>'
		  +'&nbsp;&nbsp;<img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/down.png" onclick="doDownSort(\''+id+'\',\''+parentId+'\')" />';
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

/**
 * 单位排序
 */
function sortPost(){
	var node = $('#org_dept_tree').tree('getSelected');
	if(node==null){
		//$.messager.alert('提示', '请选择所属单位！', 'info');
		layer.tips('请选择所属单位', '#btn_post_sort', { tips: 3 });
		return ;
	}
	$('#postSortGrid').datagrid({
		url : 'postController/findByCondition',
		view:scrollview,
		emptyMsg : '没有相关记录！',
		autoRowHeight:false,
		pageSize:10,
		queryParams:{
			deptId:node.id
		}
	});
	$('#postSortGrid').datagrid('load');

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
		url : "postController/doSaveSort",
		type : "post",
		async : false,
		data : {
			jsonStr : jsonStr
		},
		success : function(data) {
			jsonArr = [];
			if (data.success == 'true') {
				
				$('#postSortGrid').datagrid('load');
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
		$('#postSortGrid').datagrid('selectRow', index);
		//alert(index);
		editId = row.postId;
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
			if(editId == jsonArr[i].postId){
				jsonArr[i].sort = val;
				flag = true;
				break;
			}
		}
	}
	if (!flag) {
		var data = {};
		data.postId = editId;
		data.sort = val;
		jsonArr.push(data);
	}
}

function formaterPostSort(val, row){
	if (jsonArr != '') {
		for (var i = 0;i < jsonArr.length;i++){
			if(row.postId == jsonArr[i].postId){
				val = jsonArr[i].sort;
				break
			}
		}
	}
	if(val == null) val='';
	return '<input type="text" onChange="changeSort(\''+row.postId+'\')" id='+row.postId+' value=\''+val+'\' class="datagrid-editable-input numberbox-f" style="margin-left: 0px; margin-right: 0px; padding-top: 0px; padding-bottom: 0px; height: 30px; line-height: 30px;width:99%">'
}

function changeSort(postId){
	getSortData(postId);
	editId = undefined;
}

/**
 * 监控名称的改变，描述跟着改变
 */
function changeDesc(){
    $('#post_name').textbox({
        onChange: function(value){ 
            var post_name = $("#post_name").textbox("getValue");
            $("#post_desc").textbox("setValue",post_name);
        }
      });  
}