var operatorFlag = 'save';
$(function() {
	initOrgTree();
	//set the datagrid only one row can be selected
	$('#postTypeList').datagrid({
		onClickRow: function(index,row){
			//cancel all
			$('#postTypeList').datagrid("clearChecked");
			//check the select row
			$('#postTypeList').datagrid("selectRow", index);
		}
	});
});
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
			//展开点击选中的节点
			$('#org_tree').tree('expand', node.target);
			orgTreeOnClickhandler();
		}
	});
}
/**
 * 左侧树点击事件
 * @param node
 */
function orgTreeOnClickhandler(node){
	findByOrgId();
}
/**
 * 初始化岗位类型信息编辑对话框 初始化面板 初始化数据
 */
function initPostTypeDlg(title) {
	$('#postTypeForm').form('clear');
	var node = $('#org_tree').tree('getSelected');
	if( node!=null && node.id!='' ) {
		$("#org_id").val(node.id);
		$("#org_name").textbox("setValue", node.text);
	}else{
		//$.messager.alert('添加用户', '请先选择所属单位!');
		layer.tips('请选择所属单位', '#btn_post_add', { tips: 3 });
		return;
	}
	$('#postTypeDlg').dialog({
		title : title
	});
	changeDesc();
	$('#postTypeDlg').dialog("open");
	if( operatorFlag == 'save' ) {
		$("#isSeal").switchbutton("check");
	}
}
function closePostTypeDlg() {
	$('#deppostTypem').form('clear');
	$('#postTypeDlg').dialog("close");
}
/**
 * 添加岗位类型对话框弹出
 */
function doAddPostTypeBefore() {
	operatorFlag = 'save';
	initPostTypeDlg("新增岗位类型");
}
/**
 * 添加修改岗位类型保存方法
 */
function doSaveOrUpdatePostType() {
	var url = "";
	if (operatorFlag == 'save') {
		url = "postTypeController/doSavePostType";
	} else {
		url = "postTypeController/doUpdatePostType";
	}
	var is_Seal = $("#isSeal").switchbutton("options").checked;
	if (is_Seal) {
		is_Seal = "N";
	} else {
		is_Seal = "Y";
	}
	var obj = $('#postTypeForm').serialize()+'&'+'isSeal='+is_Seal;
	$.ajax({
		url : url,
		async : false,
		type : "post",
		data : obj,
		beforeSend : function() {
			$('input.easyui-validatebox').validatebox('enableValidation');
			return $('#postTypeForm').form('validate');
		},
		success : function(data) {

			if (operatorFlag == 'save') {
				if(data == "true"){
					$.messager.show({ title:'提示', msg:'添加成功', showType:'slide' });
					$('#postTypeDlg').dialog('close');
					findByOrgId();
					$('#postTypeList').datagrid('clearSelections'); // 清空选中的行
				}else{
					$.messager.show({ title:'提示', msg:'添加失败,类型名字重名!', showType:'slide' });
				}
			} else {
				if(data == "true"){
					$.messager.show({ title:'提示', msg:'修改成功', showType:'slide' });
					$('#postTypeDlg').dialog('close');
					findByOrgId();
					$('#postTypeList').datagrid('clearSelections'); // 清空选中的行
				}else{
					$.messager.show({ title:'提示', msg:'修改失败,类型名字重名!', showType:'slide' });
				}
			}

		}
	});
}
/**
 * 修改对话框弹出
 */
function doUpdatePostTypeBefore() {
	operatorFlag = 'update';
	var data = $('#postTypeList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示','请选择一行进行修改！', 'info');
		layer.tips('请选择一行进行修改', '#btn_post_edit', { tips: 3 });
		return;
	}
	if (data.length > 1) {
		$.messager.alert('提示','请选择一行进行修改！', 'info');
		return;
	}
	var postTypeId = data[0].postTypeId;
	$.ajax({
		url : 'postTypeController/findPostTypeById',
		async : false,
		dataType : 'json',
		data : {
			id : postTypeId
		},
		success : function(postType) {
			if (postType != null) {
				initPostTypeDlg("修改岗位类型");
				$("#postTypeId").val(postType.postTypeId);
				$("#postTypeCode").val(postType.postTypeCode);
				$("#postTypeName").textbox("setValue", postType.postTypeName);
				var isSeal = postType.isSeal;
				if (isSeal == "N") {
					$("#isSeal").switchbutton("check"); 
				} else {
					$("#isSeal").switchbutton("uncheck"); 
				}
				$("#postTypeDesc").textbox("setValue",postType.postTypeDesc);
				$("#postTypeForm").form('validate');
			}
		},
		error : function(result) {
			$.messager.alert('提示','修改失败！', 'error');
		}
	});
}
/**
 * 删除岗位类型
 */
function doDeletePostType() {
	var selecteds = $('#postTypeList').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示','请选择一行进行删除！', 'info');
		layer.tips('请选择一行进行删除', '#btn_post_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除岗位类型', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].postTypeId + ",";
			});

			ids = ids.substring(0, ids.length - 1);
			$.ajax({
				url : 'postTypeController/doDeletePostType',
				async : false,
				dataType : 'json',
				data : {
					ids : ids
				},
				success : function(result) {
					$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
					findByOrgId();
					$('#postTypeList').datagrid('clearSelections'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
				}
			});
		}
	});
}
/**
 * 条件查询
 */
function findByOrgId() {
	var node = $('#org_tree').tree('getSelected');
	var orgId = '0';
	if( node!=null && node.id!='' ) {
		orgId = node.id;
		$("#org_id").val(node.id);
		$("#org_name").val(node.text);
	}
	$('#postTypeList').datagrid({
		url : "postTypeController/findByCondition",
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams : {
			orgId : orgId,
		}
	});
	$('#postTypeList').datagrid('clearSelections'); // 清空选中的行
}
/**
 * 条件查询
 */
function findByCondition() {
	var searchValue = $("#search").searchbox('getValue');
	//筛选查询条件
	if(searchValue!=null&&searchValue.indexOf('%')>=0){
		$.messager.alert('提示', '输入非法查询字符\'%\'！', 'info');
		return;
	}
	var node = $('#org_tree').tree('getSelected');
	var orgId = '0';
	if( node!=null && node.id!='' ) {
		orgId = node.id;
		$("#org_id").val(node.id);
		$("#org_name").val(node.text);
	}
	$('#postTypeList').datagrid({
		url : "postTypeController/findByCondition",
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		queryParams : {
			orgId : orgId,
			searchValue : searchValue
		}/*,
		onLoadSuccess: function(data) {
			$.messager.show({ title:'提示', msg:'搜索到 <span style="color:red">'+data.rows.length+'</span> 条数据', showType:'slide' });
		}*/
	});
	$('#postTypeList').datagrid('clearSelections'); // 清空选中的行
}

function validExist(){
	var postTypeCode = $.trim($("#postTypeCode").val());
	if(postTypeCode==''){
		return;
	}
	$.ajax({
		url : 'postTypeController/findPostTypeByCode',
		async : false,
		dataType : 'json',
		data : {
			id : postTypeCode
		},
		success : function(result) {
			if(result){
				if(result.postTypeId && result.postTypeId!=''){
					$.messager.alert('提示', '岗位类型代码已存在！', 'info');
					$("#postTypeCode").val("");
					$("#postTypeForm").form('validate');
				}
			}
		},
		error : function(result) {
			$.messager.alert('提示','岗位类型代码验证失败！', 'error');
		}
	});
}
function clearSearchBox(){
	 $("#search").searchbox("setValue","");
	 $("#org_search").searchbox("setValue","");
}

/**
 * 上移
 * @author 张多一
 * @param modId 单位ID
 * @param parentId 父节点ID
 */
function doUpSort(postTypeId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		type : 'post',
		url : 'postTypeController/doUpSort',
		data : {
			postTypeId : postTypeId
		},
		dataType : 'json',
		success : function(data) {
			if (data.success) {
				$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
				findByOrgId();
			}else{
				$.messager.show({ title:'提示', msg:'操作失败', showType:'slide' });
				findByOrgId();
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
function doDownSort(postTypeId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		type : 'post',
		url : 'postTypeController/doDownSort',
		data : {
			postTypeId : postTypeId
		},
		dataType : 'json',
		success : function(data) {
			if (data.success) {
				$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
				findByOrgId();
			}else{
				$.messager.show({ title:'提示', msg:'操作失败', showType:'slide' });
				findByOrgId();
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
	var id = row.postTypeId;
	var parentId = null;
	return '<img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/up.png" onclick="doUpSort(\''+id+'\',\''+parentId+'\')"/>'
		  +'&nbsp;&nbsp;<img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/down.png" onclick="doDownSort(\''+id+'\',\''+parentId+'\')" />';
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#org_tree").tree('search',searchValue);
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
function formaterIsSeal(val, row) {
	if (val == "Y") {
		return "<span style=\'color:red\'>是</span>";
	} else {
		return "否";
	}
}

/**
 * 监控名称的改变，描述跟着改变
 */
function changeDesc(){
    $('#postTypeName').textbox({
        onChange: function(value){
            var postTypeName = $("#postTypeName").textbox("getValue");
            $("#postTypeDesc").textbox("setValue",postTypeName);
        }
      });  
}