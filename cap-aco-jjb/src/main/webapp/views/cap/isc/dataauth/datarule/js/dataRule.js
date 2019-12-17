/**
 * 新增保存
 */
function doSaveRule() {
	window.frames["ruleAddFrame"].doSaveRule();
}

/**
 * 修改保存
 */
function doSaveUptRule() {
	window.frames["ruleUptFrame"].doSaveUptRule();
}

/**
 * 关闭弹出框
 * @author 王建坤
 * @param id 弹出框ID
 * */
function closeDialog(id){
	$('#'+id).dialog('close');
}

/**
 * 新增
 */
function openRuleForm() {
	var url = "dataRuleController/toAddRuleIframe?roleId="+roleId;
	$("#ruleAddFrame").attr("src",url);
	$('#ruleAddDialog').dialog("open");
}

/**
 * 修改
 */
function openUpdateRuleForm() {
	var data = $('#ruleList').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！','info');
		layer.tips('请选择一行进行修改', '#btn_rule_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			$.messager.alert('提示', '请选择一行进行修改！','info');
			layer.tips('请选择一行进行修改', '#btn_rule_edit', { tips: 3 });
			return;
		}
		var rule = data[0];
		var ruleId = data[0].ruleId;
		var url = "dataRuleController/toUpdateRuleIframe?id="+ruleId+"&roleId="+roleId;
		$("#ruleUptFrame").attr("src",url);
		$('#ruleUptDialog').dialog("open");
	}
}

/**
 * 删除
 */
function doDeleteRule() {
	var selecteds = $('#ruleList').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('提示', '请选择操作项！','info');
		layer.tips('请选择操作项', '#btn_rule_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除规则', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].ruleId + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'dataRuleController/doDeleteDataRule',
				dataType : 'json',
				async : false,
				data : {ids : ids},
				success : function(result) {
					var msg = result;
					if (msg) {
						$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
						reloadRule();
						$('#ruleList').datagrid('clearSelections'); // 清空选中的行
					} else {
						$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
					}
				},
				error : function(result) {
					$.messager.alert('提示', "删除失败！",'error');
				}
			});
		}
	});
}

/**
 * 重新加载列表
 */
function reloadRule() {
	var url = 'dataRuleController/findByCondition';
	$('#ruleList').datagrid({
		url : url,
		queryParams:{
			roleId : roleId
		}
	});
}

/**
 * 初始化dialog清空数据
 */
function initRuledldata() {
	$("#ruleId").val("");
	$("#resName").val("");
	$("#resCode").val("");
	$("#ruleName").val("");
	$("#ruleDef").val("");
}

/**
 * 条件查询
 */
function findRulesByCondition(){
	var ruleName = $("#ruleSearch").searchbox('getValue');
	$('#ruleList').datagrid({
        url:"dataRuleController/findByCondition",
        queryParams:{
        	orgId : orgId,
        	ruleName : ruleName
        }
    });
}

/**
 * 清空搜索框
 * */
function clearRuleSearchBox(){
	$("#ruleSearch").searchbox("setValue","");
}

/**
 * 新增数据规则选人、部门、单位
 * 
 * @author 王建坤
 */
function doSaveAddSelect(){
	var arr = document.getElementById("commonAddFrame").contentWindow.doSaveData();
	document.getElementById("ruleAddFrame").contentWindow.setData(arr);
}

/**
 * 修改数据规则选人、部门、单位
 * 
 * @author 王建坤
 */
function doSaveUptSelect(){
	var arr = document.getElementById("commonUptFrame").contentWindow.doSaveData();
	document.getElementById("ruleUptFrame").contentWindow.setData(arr);
}

/**
 * 修改下拉框，数据表关联人用户
 * 
 * @author 王建坤
 */
function doUseDataRuleCol(){
	var iframeId = window.frames["tableColFrame"].doUseDataRuleCol();
	document.getElementById(iframeId).contentWindow.reloadSelect();
}

/**
 * 点击取消按钮，关闭字段列表弹出框
 * 
 * @author 王建坤
 */
function closeDlg(){
	window.frames["tableColFrame"].closeDlg();
}

/**
 * 判断规则是否存在
 */
function isExist(roleId,resCode) {
	$.ajax({
		url : 'dataRuleController/isExist',
		type : 'post',
		data : {
			roleId : roleId,
			resCode : resCode
		},
		dataType : 'json',
		success : function(data){
			if (data) {
				$.messager.alert('提示', '同一数据角色不能对同一功能点定义多条规则！','info');
				
			}
		}
	});
}