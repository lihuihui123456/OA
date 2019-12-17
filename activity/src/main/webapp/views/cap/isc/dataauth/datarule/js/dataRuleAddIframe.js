/**
 * 全局变量
 * */
var curObj = undefined;//选人图标点击，记录当前对象，以便选完之后复制
var columns = [];//菜单对应业务表字段数组
var columnsAll = [];//下拉框加载时的数据（菜单对应业务表字段json数组）
var columnsRefUser = "";//菜单对应业务表字段关联用户json数组字符串
var tableName = "";//菜单对应业务表名称
var comboboxDom = "";//下拉框字符串，添加分组、添加规则使用
var defaultSelect = '<select class="easyui-combobox fieldSelect" data-options="editable:false,onSelect:function(){onselect($(this));}" name="field" style="width:150px;">'
	+					    '<option value="data_user_id">人员</option>'
	+					    '<option value="data_dept_id">部门</option>'
	+					    '<option value="data_org_id">单位</option>'
//	+					    '<option value="column_add">+</option>'
	+					'</select>';//默认下拉
var selects = undefined;//所有条件下拉框

/**
 * 加载菜单数据
 * @author 王建坤
 * @param comboxId 下拉框ID
 */
function createMenuData(comboxId) {
	$("#"+comboxId).combotree({
		url : "moduleController/findBySysRegId",
		queryParams : {
			sysRegId : '8a81595755e866880155e8ec40050003'
		},
		animate : true,
		checkbox : false,
		onlyLeafCheck : false,
		onBeforeSelect:function(node){
			if (!$(this).tree('isLeaf', node.target)) {
				return false;
			}
			var tabName = node.tableName;
			if (tabName == null || tabName == '' || tabName == undefined) {
				$.messager.alert('提示', '此模块未定义业务表名称，不能定义数据规则，请先为此模块定义业务表名称！','info');
				return false;
			}
        },
		onClick : function(node) {
			var tabName = node.tableName;
			if (tabName == null || tabName == '' || tabName == undefined) {
				return;
			}
			if ("N" == node.isVrtlNode) {
				var resName = node.text;
				var resCode = node.modCode;
				tableName = node.tableName;
				
				$.ajax({
					url : 'dataRuleController/isExist',
					type : 'post',
					data : {
						roleId : $("#roleRuleId").val(),
						resCode : resCode,
						tableName : tableName
					},
					dataType : 'json',
					success : function(data){
						if (data.isExist == "true") {
							$.messager.alert('提示', '同一数据角色不能对同一功能点定义多条规则！','info');
						} else {
							columns = data.columnsStr.split(",");
							columnsAll = eval("("+data.dataTableCols+")");
							columnsRefUser = data.columnsRefUser;
							comboboxDom = data.comboboxDom;
							$("#tx_ruleName").textbox("setValue",resName);
							$("#resName").val(resName);
							$("#resCode").val(resCode);
							$("#rulesAddDiv").html("");
							addGroup("rulesAddDiv");
						}
					}
				});
			} else {
				$.messager.alert('提示', '虚拟节点不能定义规则！','info');
			}
		}
	});
}

/**
 * 点击取消按钮，关闭字段列表弹出框
 * */
function closeDlg(){
	window.parent.$('#tableColDialog').dialog("close");
};

/**
 * 图标点击事件
 * 
 * @author 王建坤
 * */
function onClickIcon() {
	curObj = $(this);
	var nameStr = $(curObj).textbox("getValue");
	var idStr = $(curObj).siblings().last().val();
	/**单选标识 singleSelect 是：true ；否：false*/
	var singleSelect = "true";
	var value = $(this).parent().prev().children().eq(0).first().combobox("getValue");
	if (value == 'in' || value == 'not in') {
		singleSelect = "false";
	} 
	/** 是否包含本人、本部门或者本单位 是：true,否：false */
	var isContainSelf = "false";
	if (value == 'in') {
		isContainSelf = "true";
	}
	/** 0：人员 1：部门 2：单位 */
	var type = $(this).attr("dataType");
	var url = "";
	var title = "";
	if (type == '2') {
		title = "选择单位";
		url = "orgController/selectAllOrg?singleSelect="+singleSelect+"&nameStr="+nameStr+"&idStr="+idStr+"&isContainSelf="+isContainSelf;
	} else if (type == '1') {
		title = "选择部门";
		url = "orgController/selectAllOrgDept?singleSelect="+singleSelect+"&nameStr="+nameStr+"&idStr="+idStr+"&isContainSelf="+isContainSelf;
	} else if (type == '0') {
		title = "选择人员";
		url = "orgController/selectAllOrgDeptUser?singleSelect="+singleSelect+"&nameStr="+nameStr+"&idStr="+idStr+"&isContainSelf="+isContainSelf;
	}
	window.parent.$('#commonAddFrame').attr('src', url);
	window.parent.$('#commonAddDialog').dialog({title : title});
	window.parent.$('#commonAddDialog').dialog("open");  
}

/**
 * 人员、部门、单位选择完成后，设置文本框的值
 * 
 * @author 王建坤
 * @param arr 名称和ID的数组
 * */
function setData(arr){
	$(curObj).textbox("setValue",arr[1]);
	$(curObj).siblings().last().val(arr[0]);
	window.parent.$('#commonAddDialog').dialog("close");
}

/**
 * 通过‘+’添加、删除条件后，重新加载下拉框
 * 
 * @author 王建坤
 * */
function reloadSelect(){
	$(selects).each(function(){
		var isDelete = true;
		var value = $(this).combobox("getValue");
		$(this).combobox({
			valueField : 'enName',  
            textField : 'cnName',  
            data : columnsAll
		});
		var options = $(this).combobox("getData");
		for ( var i = 0; i < options.length; i++) {
			var enName = options[i].enName;
			if (value == enName) {
				$(this).combobox("setValue",value);
				isDelete = false;
				break;
			}
		}
		if (isDelete) {
			var inputDomDef = "";
			$(this).combobox("setValue","data_user_id");
			var opSelectValue = $(this).parent().siblings().eq(2).children().first().combobox("getValue");
			if (opSelectValue == 'eq') {
				inputDomDef = '<input class="easyui-textbox" value="本人" data-options="editable:false" dataType="0" name="value" style="width:450px;" /><input type="hidden" value="userSelf"/>';
			} else {
				inputDomDef = '<input class="easyui-textbox" value="" data-options="editable:false,iconWidth:22,icons: [{iconCls:\'icon-search\',handler: function(e){var v = $(e.data.target).textbox(\'getValue\');}}],onClickIcon:onClickIcon" dataType="0" name="value" style="width:450px;" />';
			}
			$(this).parent().siblings().eq(3).html("");
			var target = $(inputDomDef).appendTo($(this).parent().siblings().eq(3));
			$.parser.parse($(target).parent());
		}
	});
}

/**
 * 当属性下拉选择时，设置值下拉dataType属性的值
 * 
 * @author 王建坤
 * */
function onselect(obj){
	var inputDomDef = '';
	var field = $(obj).combobox("getValue");
	var valueTd = $(obj).parent().siblings().eq(3);
	var opSelectValue = $(obj).parent().siblings().eq(2).children().first().combobox("getValue");
	
	if (field == 'data_user_id') {
		if (opSelectValue == 'eq') {
			inputDomDef = '<input class="easyui-textbox" value="本人" data-options="editable:false" dataType="0" name="value" style="width:450px;" /><input type="hidden" value="userSelf"/>';
		} else {
			inputDomDef = '<input class="easyui-textbox" value="" data-options="editable:false,iconWidth:22,icons: [{iconCls:\'icon-search\',handler: function(e){var v = $(e.data.target).textbox(\'getValue\');}}],onClickIcon:onClickIcon" dataType="0" name="value" style="width:450px;" /><input type="hidden" value=""/>';
		}
		$(valueTd).html("");
		var target = $(inputDomDef).appendTo($(valueTd));
		$.parser.parse($(target).parent());
	} else if (field == 'data_dept_id') {
		if (opSelectValue == 'eq') {
			inputDomDef = '<input class="easyui-textbox" value="本部门" data-options="editable:false" dataType="1" name="value" style="width:450px;" /><input type="hidden" value="deptSelf"/>';
		} else {
			inputDomDef = '<input class="easyui-textbox" value="" data-options="editable:false,iconWidth:22,icons: [{iconCls:\'icon-search\',handler: function(e){var v = $(e.data.target).textbox(\'getValue\');}}],onClickIcon:onClickIcon" dataType="1" name="value" style="width:450px;" /><input type="hidden" value=""/>';
		}
		$(valueTd).html("");
		var target = $(inputDomDef).appendTo($(valueTd));
		$.parser.parse($(target).parent());
	} else if (field == 'data_org_id') {
		if (opSelectValue == 'eq') {
			inputDomDef = '<input class="easyui-textbox" value="本单位" data-options="editable:false" dataType="1" name="value" style="width:450px;" /><input type="hidden" value="orgSelf"/>';
		} else {
			inputDomDef = '<input class="easyui-textbox" value="" data-options="editable:false,iconWidth:22,icons: [{iconCls:\'icon-search\',handler: function(e){var v = $(e.data.target).textbox(\'getValue\');}}],onClickIcon:onClickIcon" dataType="2" name="value" style="width:450px;" /><input type="hidden" value=""/>';
		}
		$(valueTd).html("");
		var target = $(inputDomDef).appendTo($(valueTd));
		$.parser.parse($(target).parent());
	} else {
		inputDomDef = '<input class="easyui-textbox" value=""  dataType="0" name="value" style="width:450px;" /><input type="hidden" value=""/>';
		$(valueTd).html("");
		var target = $(inputDomDef).appendTo($(valueTd));
		$.parser.parse($(target).parent());
	}
}

/**
 * 条件下拉选择事件触发
 * 
 * @author 王建坤
 * */
function opOnSelect(obj) {
	var inputDomDef = '';
	var opSelectValue = $(obj).combobox("getValue");
	var field = $(obj).parent().parent().children().eq(1).children().first().combobox("getValue");
	var valueTd = $(obj).parent().parent().children().eq(4);
	if (field == 'data_user_id') {
		if (opSelectValue == 'eq') {
			inputDomDef = '<input class="easyui-textbox" value="本人" data-options="editable:false" dataType="0" name="value" style="width:450px;" /><input type="hidden" value="userSelf"/>';
		} else {
			inputDomDef = '<input class="easyui-textbox" value="" data-options="editable:false,iconWidth:22,icons: [{iconCls:\'icon-search\',handler: function(e){var v = $(e.data.target).textbox(\'getValue\');}}],onClickIcon:onClickIcon" dataType="0" name="value" style="width:450px;" /><input type="hidden" value=""/>';
		}
		$(valueTd).html("");
		var target = $(inputDomDef).appendTo($(valueTd));
		$.parser.parse($(target).parent());
	} else if (field == 'data_dept_id') {
		if (opSelectValue == 'eq') {
			inputDomDef = '<input class="easyui-textbox" value="本部门" data-options="editable:false" dataType="1" name="value" style="width:450px;" /><input type="hidden" value="deptSelf"/>';
		} else {
			inputDomDef = '<input class="easyui-textbox" value="" data-options="editable:false,iconWidth:22,icons: [{iconCls:\'icon-search\',handler: function(e){var v = $(e.data.target).textbox(\'getValue\');}}],onClickIcon:onClickIcon" dataType="1" name="value" style="width:450px;" /><input type="hidden" value=""/>';
		}
		$(valueTd).html("");
		var target = $(inputDomDef).appendTo($(valueTd));
		$.parser.parse($(target).parent());
	} else if (field == 'data_org_id') {
		if (opSelectValue == 'eq') {
			inputDomDef = '<input class="easyui-textbox" value="本单位" data-options="editable:false" dataType="1" name="value" style="width:450px;" /><input type="hidden" value="orgSelf"/>';
		} else {
			inputDomDef = '<input class="easyui-textbox" value="" data-options="editable:false,iconWidth:22,icons: [{iconCls:\'icon-search\',handler: function(e){var v = $(e.data.target).textbox(\'getValue\');}}],onClickIcon:onClickIcon" dataType="2" name="value" style="width:450px;" /><input type="hidden" value=""/>';
		}
		$(valueTd).html("");
		var target = $(inputDomDef).appendTo($(valueTd));
		$.parser.parse($(target).parent());
	}
}

/**
 * 新增保存
 */
function doSaveRule() {
	
	/**保存业务表字段*/
	var resCode = $("#resCode").val();
	if (resCode == '') {
		$.messager.alert('提示', '请选择资源！','info');
		return;
	}
	var ruleName = $("#tx_ruleName").val();
	if (ruleName == '') {
		$.messager.alert('提示', '请填入规则名称！','info');
		return;
	}
	$("#ruleName").val(ruleName);
	var ruleDef = createJsonStr("rulesAddDiv");
	if (ruleDef == '[]') {
		$.messager.alert('提示', '请定义规则！','info');
		return;
	}
	$("#ruleDef").val(ruleDef);
	
	/**保存业务表字段与人员关联数据*/
	$.ajax({
		url : "dataRuleController/doSaveDataRuleCol",
		type : "post",
		async : false,
		data : {
			tableName : tableName,
			columnsStr : columnsRefUser
		},
		success : function(data) {
			
		},
		error : function() {
			
		}
	});

	$.ajax({
		url : "dataRuleController/doSaveDataRule",
		type : "post",
		async : false,
		data : $('#ruleForm').serialize(),
		success : function(data) {
			//alert(data.msg);
			window.parent.closeDialog('ruleAddDialog');
			window.parent.reloadRule();
			initRuledldata();

			window.top.msgTip("保存成功!");
		}
	});
}

/**
 * 生成json字符串
 * @author 王建坤
 * @param divId 数据规则div的ID
 * @returns jsonStr json字符串
 */
function createJsonStr(divId){
	var jsonStr = "";
	var groupArr = [];
	$("#"+divId+" table").each(function(idx){
		var ruleLength = $(this).find("tr").length;
		var groupOp = $(this).find("tr").last().find("td").first().children().first().combobox("getValue");
		var groupJson = {};
		groupJson.op = groupOp;
		var rules = [];
		$(this).find("tr").each(function(index){
			if (index != ruleLength-1) {
				var ruleJson = {};
				var ruleOp = "";
				if (index != 0) {
					ruleOp = $(this).find("td").eq(0).children().first().combobox("getValue");
				}
				var field = $(this).find("td").eq(1).children().first().combobox("getValue");
				var op = $(this).find("td").eq(3).children().first().combobox("getValue");
				var value = $(this).find("td").eq(4).children().first().textbox("getValue");
				var hiddenValue = $(this).find("td").eq(4).children().last().val();
				ruleJson.field = field;
				ruleJson.op = op;
				ruleJson.value = value;
				ruleJson.ruleOp = ruleOp;
				ruleJson.hiddenValue = hiddenValue;
				rules[index] = ruleJson;
			}
		});
		groupJson.rules = rules;
		groupArr[idx] = groupJson;
	});
	jsonStr = JSON.stringify(groupArr);
	return jsonStr;
}

/**
 * 添加分组
 * @author 王建坤
 * @param divId 数据规则div的ID
 */
function addGroup(divId){
	if (tableName == '') {
		$.messager.alert('提示', '请先选择资源！','info');
		return;
	}
	var addSelect = defaultSelect;
	if (comboboxDom != null && comboboxDom != '') {
		addSelect = comboboxDom
	}
	var table = '<table style="float: left;"></table>';
	 var html =    '<tr>'
		+				'<td><span style="width:70px;display: block;"></span>'
		+				'</td>'
		+				'<td>'
		+					addSelect
		+				'</td>'
		+				'<td style="width:70px;display: block;margin-top: 5px;"><a href="javascript:void(0);" onclick="openDataTalbeDlg();" style="display: block;width:70px;">[添加字段]</a></td>'
		+				'<td>'
		+					'<select class="easyui-combobox" data-options="editable:false,onSelect:function(){opOnSelect($(this));}" name="op" style="width:100px;">'
		+					    '<option value="eq">等于</option>'
		+					    '<option value="ne">不等于</option>'
		+					    '<option value="gt">大于</option>'
		+					    '<option value="lt">小于</option>'
		+					    '<option value="ge">大于等于</option>'
		+					    '<option value="le">小于等于</option>'
		+					    '<option value="in">包含于</option>'
		+					    '<option value="not in">不包含于</option>'
		+					'</select>'
		+				'</td>'
		+				'<td>'
		+					'<input class="easyui-textbox" data-options="editable:false" dataType="0" name="value" value="本人" style="width:450px;" />'
		+                   '<input type="hidden" value="userSelf" />'
		+				'</td>'
		+				'<td style="display: block;width: 5px;">'
		+				'</td>'
		+			'</tr>'
		+			'<tr>'
		+				'<td colspan="5" align="right">'
		+					'<select class="easyui-combobox" data-options="editable:false,onLoadSuccess:function(){$(this).siblings().first().css(\'margin-right\',4);}" panelHeight="50" style="width:70px;">'
		+					    '<option value="and">并且</option>'
		+					    '<option value="or">或者</option>'
		+					'</select>'
		+					'<a href="javascript:void(0)" class="easyui-linkbutton" onclick="addRule(this);" plain="true" style="margin-right: 4px;">增加条件</a>'
		+					'<a href="javascript:void(0)" class="easyui-linkbutton" onclick="deleteGroup(this)" plain="true">删除分组</a>'
		+				'</td>'
		+               '<td style="display: block;width: 5px;"></td>'
		+			'</tr>';
	var target = $(html).appendTo($(table).appendTo($("#"+divId)));
	$.parser.parse($(target).parent());
	selects = $(".fieldSelect");
}
/**
 * 添加条件
 * @author 王建坤
 * @param obj 当前按钮对象
 * */
function addRule(obj){
	if (tableName == '') {
		$.messager.alert('提示', '请先选择资源！','info');
		return;
	}
	var addSelect = defaultSelect;
	if (comboboxDom != null && comboboxDom != '') {
		addSelect = comboboxDom
	}
	var tr = '<tr></tr>';
	var html =          '<td>'
		+					'<select class="easyui-combobox" data-options="editable:false" panelHeight="50" name="ruleOp" style="width:70px;">'
		+					    '<option value="and">并且</option>'
		+					    '<option value="or">或者</option>'
		+					'</select>'
		+				'</td>'
		+				'<td>'
		+					addSelect
		+				'</td>'
		+				'<td style="width:70px;display: block;margin-top: 5px;"><a href="javascript:void(0);" onclick="openDataTalbeDlg();" style="display: block;width:70px;">[添加字段]</a></td>'
		+				'<td>'
		+					'<select class="easyui-combobox" data-options="editable:false,onSelect:function(){opOnSelect($(this));}" name="op" style="width:100px;">'
		+					    '<option value="eq">等于</option>'
		+					    '<option value="ne">不等于</option>'
		+					    '<option value="gt">大于</option>'
		+					    '<option value="lt">小于</option>'
		+					    '<option value="ge">大于等于</option>'
		+					    '<option value="le">小于等于</option>'
		+					    '<option value="in">包含于</option>'
		+					    '<option value="not in">不包含于</option>'
		+					'</select>'
		+				'</td>'
		+				'<td>'
		+					'<input class="easyui-textbox" data-options="editable:false" dataType="0" name="value" value="本人" style="width:450px;" />'
		+                   '<input type="hidden" value="userSelf" />'
		+				'</td>'
		+				'<td style="display: block;width: 5px;">'
		+					'<span style="color: red;cursor: pointer;" onclick="javascript:deleteRule(this);">X</span>'	
		+				'</td>';
	var target = $(html).appendTo($(tr).insertBefore($(obj).parents("tr").eq(0)));
	$.parser.parse($(target).parent());
	selects = $(".fieldSelect");
}

/**
 * 删除规则
 * @author 王建坤
 * @param obj 当前按钮对象
 * */
function deleteRule(obj) {
	var length = $(obj).parents("tr").eq(0).siblings().length;
	if (length > 1) {
		$(obj).parents("tr").eq(0).remove();
	} else {
		$(obj).parents("table").eq(0).remove();
	}
}

/**
 * 删除分组
 * @author 王建坤
 * @param obj 当前按钮对象
 */
function deleteGroup(obj) {
	$(obj).parents("table").eq(0).remove();
}

/**
 * 添加下拉框数据
 * @author 王建坤
 * @param 
 * */
function openDataTalbeDlg() {
	if (tableName == '') {
		$.messager.alert('提示', '请先选择资源！','info');
		return;
	}
	var url = "dataRuleController/toDataTableColIframe?columnsStr="+columns+"&tableName="+tableName+"&iframeId=ruleAddFrame"+"&columnsRefUser="+columnsRefUser;
	window.parent.$('#tableColFrame').attr('src', encodeURI(encodeURI(url)));
	window.parent.$('#tableColDialog').dialog("open");
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