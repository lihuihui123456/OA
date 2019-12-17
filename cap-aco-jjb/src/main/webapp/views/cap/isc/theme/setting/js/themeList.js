/**
 * 初始化函数
 */
$(function() {
	//InitTreeData();
	initThemeList();
});


var typeid = "";
var typeName = "";

/**
 * 初始化加载左侧树
function InitTreeData() {
	$('#tree').tree({
		url : 'themeTypeController/getAllThemeType',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onClick : function(node) {
			$('#tree').tree('expand', node.target);
			typeid = node.id;
			typeName = node.text;
			if (typeid == '0') {
				return;
			}
			reload(typeid);
		},
		onContextMenu : function(e, node) {
			e.preventDefault();
			$('#tree').tree('select', node.target);
			$('#mm').menu('show', {
				left : e.pageX,
				top : e.pageY
			});
		}
	});
}
 */
/**
 * 增加数据主题数节点
 */
function addNote() {

	$("#themeTypeCode").textbox('setValue', "");
	$("#themeTypeName").textbox('setValue', "");
	$("#isValid").switchbutton("check");

	nodeid = '';
	$('#themeTypeDialog').dialog('open');
}

/**
 * 删除主题类型
 */
function delNote() {
	var nodes = $('#tree').tree('getSelected', 'info');
	
	var ids = '';
	if (nodes == null) {
		$.messager.alert('提示', '请选择操作项！', 'info');
		return;
	} else if (nodes.id == '0') {
		$.messager.alert('提示', '父级节点不可删除！', 'info');
		return;
	} else if(!$('#tree').tree('isLeaf',nodes.target)){
		$.messager.alert('提示', '父级节点不可删除！', 'info');
		return;
	}else {
		$.messager.confirm('删除主题类型', '确定删除吗?', function(r) {
			if (r) {
				ids = nodes.id;

				$.post("themeController/findByCondition", {
					"typeId" : ids
				}, function(data) {
					if (data == null || data.total != '0') {
						$.messager.alert('删除主题类型', '此类型下包含数据,不可删除')
						return;
					} else {
						$.post("themeTypeController/doDeleteThemeType", {
							"id" : ids
						}, function(data) {
							InitTreeData();
						});
					}
				});
			}
		});
	}
}

var nodeid = "";
/**
 * 修改数据主题数节点
 */
function modNote() {
	var node = $('#tree').tree('getSelected');
	if (node) {
		nodeid = node.id;

		if (nodeid == '0') {
			$.messager.alert('提示', '父级节点不可修改！', 'info');
			return;
		}
		
		$("#themeTypeId").val(node.id);
		$("#themeTypeCode").textbox('setValue', node.code);
		$("#themeTypeName").textbox('setValue', node.text);
		var isValid = node.isValid;
		if (isValid == "Y") {
			$("#isValid").switchbutton("check"); 
		} else {
			$("#isValid").switchbutton("uncheck"); 
		}
		$('#themeTypeDialog').dialog({ title : "修改主题类型" });
		$('#themeTypeDialog').dialog('open');
	}
}

/**
 * 保存数据主题数节点
 */
function savetype() {

	if (!$('#typeForm').form('validate')) {
		return;
	}
	var url = "";
	if (nodeid == '') {
		url = "themeTypeController/doSaveThemeType";
	} else {
		url = "themeTypeController/doUpdateThemeType";
	}
	var isValid = $("#isValid").switchbutton("options").checked;
	if (isValid) {
		isValid = "Y";
	} else {
		isValid = "N";
	}

	$.ajax({
		url : url,
		type : "POST",
		async : false,
		data : $("#typeForm").serialize()+'&isValid='+isValid,
		success : function(data) {
			if (data == '1') {
				$.messager.alert('提示', '主题类型名称已存在', 'info');
				$("#themeTypeName").textbox('setValue', '');
				return;
			} else if (data == '2') {
				$.messager.alert('提示', '主题类型编码已存在', 'info');
				$("#themeTypeCode").textbox('setValue', '');
				return;
			} else {
				$.messager.alert('提示', '保存成功', 'info');
				$('#themeTypeDialog').dialog('close');
				InitTreeData();
			}
		}
	});
}

var themeId = "";
var uuid = "";
/**
 * 初始化系统主题列表
 * 
 * @param 无
 * @param 无
 */
function initThemeList() {
	$('#themeList').datagrid({
		url : 'themeController/findByCondition',
		view : dataGridExtendView,
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'themeId',
		striped : true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		fit: true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		columns : [[
		   { field : 'ck', 			width : 50	,		checkbox : true }, 
		   { field : 'themeId', 	title : '主题ID', 	hidden : true }, 
		   { field : 'themeName', 	title : '主题名称', 	width : 100, 	align : 'left'},
		   { field : 'themeCode',   title : '主题编码',	width : 100, 	align : 'left'},
		   { field : 'isValid',     title : '状态',	    width : 100, 	align : 'left',
			    formatter : function(value, row) {
				if (value == 'Y') {
					return '启用';
				}   
				return '禁用';
		   }},
		   { field : 'isDefault',   title : '是否默认',	width : 100, 	align : 'left',
			   formatter : function(value, row) {
				if (value == 'Y') {
					return '是';
				}   
				return '否';
			}}
		]],
		onClickRow: function(index,row){
			//cancel all select
			$('#themeList').datagrid("clearChecked");
			//check the select row
			$('#themeList').datagrid("selectRow", index);
		}
	});
}

/**
 * 保存
 */
function doSaveTheme() {
	
	if(!$('#themeForm').form('validate')){
		return;
	}
	
	/*var data = $('#themeList').datagrid('getChecked');
	if (data != '' && data != undefined) {
		themeId = data[0].themeId;
	}*/
	var url = "";
	if (themeId == undefined || themeId == '') {
		url = "themeController/doSaveTheme";
		$("#themeId").val(uuid);
	} else {
		url = "themeController/doUpdateTheme";
	}
	
	var isValid = $("#is_valid").switchbutton("options").checked;
	if (isValid) {
		isValid = "Y";
	} else {
		isValid = "N";
	}
	var isDefault = $("#isDefault").switchbutton("options").checked;
	if (isDefault) {
		isDefault = "Y";
		
		$.messager.confirm('保存', '确定将当前主题设为默认吗?', function(r) {
			if (r) {
				$.ajax({
					url : url,
					type : "post",
					async : false,
					data : $('#themeForm').serialize()+"&themeTypeId="+typeid+"&isValid="+isValid+"&isDefault="+isDefault,
					success : function(data) {
						
						if (data.state == '1') {
							$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
						} else {
							$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
							$('#themeDialog').dialog('close');
							reload();
							initdldata();
						}
					}
				});
			}
		});
	} else {
		isDefault = "N";
		
		$.ajax({
			url : url,
			type : "post",
			async : false,
			data : $('#themeForm').serialize()+"&themeTypeId="+typeid+"&isValid="+isValid+"&isDefault="+isDefault,
			success : function(data) {
				
				if (data.state == '1') {
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
				} else {
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
					$('#themeDialog').dialog('close');
					reload();
					initdldata();
				}
			}
		});
	}
}

/**
 * 新增
 * 
 * @param 无
 * @param 无
 */
function openForm(title) {
//	if (typeid == "" || typeid == '0') {
//		//$.messager.alert('提示', '请选主题类型！', 'info');
//		layer.tips('请选主题类型', '#btn_add', { tips: 3 });
//		return;
//	}
	$('#themeDialog').dialog({
		title : title
	});
	themeId = "";
	initdldata();
	
	//生成uuid用户上传头像
	$.ajax({
		url : "userController/createUserId",
		type : "post",
		async : false,
		data : {},
		success : function(data) {
			uuid = data;
		}
	});
	$("#picResImg").attr("src", "");
	$('#themeDialog').dialog('open');
}

/**
 * 修改
 * 
 * @param 无
 * @param 无
 */
function openUpdateForm(title) {
	$('#themeDialog').dialog({
		title : title
	});
	initdldata();
	var data = $('#themeList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行进行修改！', 'info');
			layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
			return;
		}
		var theme = data[0];
		themeId = theme.themeId;
		$("#themeName").textbox('setValue',theme.themeName);
		$("#themeCode").textbox('setValue',theme.themeCode);
		$("#themeUrl").textbox('setValue',theme.themeUrl);
		$("#viewUrl").textbox('setValue',theme.viewUrl);
		
		var isValid = theme.isValid;
		if (isValid == "Y") {
			$("#is_valid").switchbutton("check"); 
		} else {
			$("#is_valid").switchbutton("uncheck"); 
		}
		var isDefault = theme.isDefault;
		if (isDefault == "Y") {
			$("#isDefault").switchbutton("check"); 
		} else {
			$("#isDefault").switchbutton("uncheck"); 
		}
		
		$("#themeId").val(themeId);
		
		//$("#picResImg").attr("src","uploader/uploadfile?pic="+themeId+".png");
		$("#picResImg").attr("src", "ocrController/doDownLoadPicFile?picPath=" + theme.themePic);
		$('#themeDialog').dialog('open');
	}
}

/**
 * 删除
 * 
 * @param 无
 * @param 无
 */
function doDeleteTheme() {
	var selecteds = $('#themeList').datagrid('getChecked');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择需要删除的记录！', 'info');
		layer.tips('请选择需要删除的记录', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除系统消息', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].themeId + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'themeController/doDeleteTheme',
				async : false,
				dataType : 'json',
				data : {ids : ids},
				success : function(result) {
					var msg = result;
					$.messager.show({ title:'提示', msg:'删除成功!', showType:'slide' });
					reload();
					$('#themeList').datagrid('clearSelections'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败!', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 重新加载列表
 * 
 * @param 无
 * @param 无
 */
function reload() {
	$('#themeList').datagrid('clearChecked');
	$('#themeList').datagrid('reload', {
		"typeId" : typeid
	});
}

/**
 * 初始化dialog清空数据
 * 
 * @param 无
 * @param 无
 */
function initdldata() {
	$("#themeName").textbox('setValue',"");
	$("#themeCode").textbox('setValue',"");
	$("#themeUrl").textbox('setValue',"");
	$("#viewUrl").textbox('setValue',"");
	
	$("#is_valid").switchbutton("check");
	$("#isDefault").switchbutton("uncheck");
	
	$("#themeType").textbox('setValue', typeName);
	$('#file').filebox('setValue',"")
}

//当前选择的图片服务器路径
var curPicPath = "";

/**
 * 选择文件后，将文件上传到服务器，再将服务器生成的文件下载到客户端
 * 注：为了防止浏览器无法读取本地文件，故需要上传文件到客户端后再读取
 */
function fileOnchange() {
	/*accept="image/gif, image/jpeg, image/jpg, image/png"
		
		$('#file').filebox({
			accept: 'image/*'
		});*/
	var picSrc = $('#file').filebox('getValue');
	if (picSrc.indexOf(".jpg") < 0 && picSrc.indexOf(".jpeg") <0 && picSrc.indexOf(".png") < 0 && picSrc.indexOf(".bmp") < 0) {
		$.messager.alert('提示', '仅支持jpg、jpeg、png、bmp格式图片，请重新选择！', 'info');
		//$("#file").filebox('setValue', '');
		return;
	}

	if (themeId == undefined || themeId == '') {
		$("#themeId").val(uuid);
	} 
	
	// 当选择图片后上传图片到服务器，再下载
	// 注：未放置不能读取本地文件故需先上传后再下载写入到IMG控件中
	$('#themeForm').form('submit', {
		url : 'themeController/upfileImg',
	    success:function(data){
	    	var retval = eval("("+data+")");
	    	curPicPath = retval.filePath;
	    	$("#themePic").val(curPicPath);

	    	// 从服务器下载当前上传的图片路径，并赋值到IMG控件中
			//$("#picResImg").attr("src", "");
	    	$("#picResImg").attr("src", "ocrController/doDownLoadPicFile?picPath=" + curPicPath + "&r="+new Date());
	    },
	    error:function(data){
	    	alert("执行出现异常");
	    }
	});
}

function clearSearchBox(){
	$("#search").searchbox("setValue","");
	$("#type_search").searchbox("setValue","");
	$("#theme_name").searchbox("setValue","");
}

function typeTreeSearch(){
	var searchValue = $("#type_search").searchbox('getValue');
	$("#tree").tree('search',searchValue);
}

/**
 * 重新加载列表
 * 
 * @param 无
 * @param 无
 */
function searchList() {
	$('#themeList').datagrid('clearChecked');
	$('#themeList').datagrid('reload', {
		"typeId" : typeid,
		"theme_name" : $("#theme_name").textbox('getValue')
	});
}

//分配角色
function openRole(){
	var data = $('#themeList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行操作！', 'info');
		layer.tips('请选择一行进行操作', '#btn_role', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行进行操作！', 'info');
			layer.tips('请选择一行进行操作', '#btn_role', { tips: 3 });
			return;
		}
		var theme = data[0];
		themeId = theme.themeId;
	
		initOrgTree();
		
		//initSelectRole('5a4cbd7261394d369a3c7e166fdd3df2');
		/*var data = [{
			roleId: '111',
			roleName: '字符串'
		}];*/
		$('#tb1').datagrid('loadData', []);
		$('#tb2').datagrid('loadData',[]);
		
		$('#roleDialog').dialog('open');
	}
}

var orgId = '';
var orgName = '';
var roleId = '';
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
			initSelectRole(themeId);
		}
	});
}

function initSelectRole(themeId){
	$.ajax({
		url : 'themeController/initSelectRole',
		async : false,
		dataType : 'text',
		data : {
			themeId : themeId,
			orgId : orgId
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
function doSaveRole(close){
	var rows = $("#tb2").datagrid("getRows");
	var ids = '';
	$(rows).each(function(index) {
		ids = ids + rows[index].roleId + ",";
	});
	if(ids != ''){
		ids = ids.substring(0, ids.length - 1);
	}
	
	$.ajax({
		url : 'themeController/doSaveSelectRole',
		async : false,
		dataType : 'json',
		data : {roleIds : ids,themeId : themeId,orgId:orgId},
		success : function(result) {
			var msg = result;
			if (close == 'close') {
				$('#roleDialog').dialog('close');
			}
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

//主题设置
function setTheme(){
	var data = $('#themeList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		layer.tips('请选择一行进行操作', '#btn_set', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行进行修改！', 'info');
			layer.tips('请选择一行进行操作', '#btn_set', { tips: 3 });
			return;
		}
		var theme = data[0];
		var themeUrl = theme.themeUrl;
		var themeId = data[0].themeId;
		$("#themeId").val(themeId);
		
		$("#themeFrame").attr("src",path + themeUrl+"?themeId="+themeId);
		$('#setThemeDialog').dialog('open');
	}
}

//主题预览
function viewTheme(){
	var data = $('#themeList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行操作！', 'info');
		layer.tips('请选择一行进行操作', '#btn_view', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行进行操作！', 'info');
			layer.tips('请选择一行进行操作', '#btn_view', { tips: 3 });
			return;
		}
		var theme = data[0];
		var themeUrl = theme.themeUrl;
		var themeId = data[0].themeId;
		var viewUrl = data[0].viewUrl;
		$("#themeId").val(themeId);
		
		//$("#themeFrame").attr("src",path + themeUrl+"?themeId="+themeId);
		window.open(path+viewUrl+"?themeId="+themeId, '主题预览');
	}
}