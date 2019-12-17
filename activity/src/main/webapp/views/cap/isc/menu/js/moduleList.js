/**
 * 页面初始化时加载相关函数
 */
$(function() {
	initSysRegTree();
	initModuleTreeGrid("0");
	disableAddUrl();
	disableModUrl();
});

/** 全局变量：
 *  系统ID ：sysRegId
 *  链  接 ：moduleUrl
 *  移动的模块ID ：moveModId
 * */
var sysRegId = "";
var moduleUrl = "";
var moveModId = "0";
var oldParentId = "";
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
			// 点击某一注册系统时，加载对应系统下的模块
			initModuleTreeGrid(sysRegId);
			//清空资源列表
			$('#resc_datagrid').datagrid('loadData', { total: 0, rows: [] });
			//清除模块选中状态
			$('#module_treegrid').treegrid('clearChecked');
		}
	});
}

/**
 * 初始化模块列表树
 * 
 * @param sysRegId 注册系统ID
 * @param 无
 */
function initModuleTreeGrid(sysRegId) {
	$('#module_treegrid').treegrid({
		url : 'moduleController/findBySysRegId',
		rowStyler: function(row) {
			if (row.isVrtlNode == "Y") {
				return 'background-color:#c2c8ce;font-weight:bold;';
			}
		},
		queryParams:{
			sysRegId:sysRegId
		},
		columns : [[ 
			{ field : 'ck',checkbox : true}, 
			{ field : 'id',  title : '模块ID',hidden : true}, 
			{ field : 'modCode',  title : '模块ID',hidden : true}, 
			{ field : 'isBpmDeploy',  title : '是否bpm发布',hidden : true}, 
			{ field : 'tableName',  title : '表格名称',hidden : true}, 
			{ field : 'parent_id',  title : '父模块ID',hidden : true},
			{ field : 'iconCls',  title : '图标',hidden : true},
			{ field : 'isExpand',  title : '是否展开',hidden : true},
			{ field : 'text',title : '模块名称', width : 200,align : 'left'},
			{ field : 'url',title : '模块链接', width : 280,align : 'left'},
			{ field : 'isSeal', title : '封存',  width : 50, align : 'left', formatter : formatIsSeal },
			{ field : 'isVrtlNode', title : '虚拟节点',  width : 60, align : 'left', formatter : formatIsVrtlNode },
			/*{ field : 'isAudi', title : '审计', width : 60, align : 'left', formatter : formatIsAudi },
			{ field : 'isContr', title : '监控性能', width : 60, align : 'left', formatter : formatIsContr },*/
			{ field : 'operate', title : '操作', width : 60, align : 'center', formatter : formatOperate },
			{ field : 'res', title : '资源详情', width : 80, align : 'center', formatter : formatRes }
		] ],
		onClickRow : function(row){
			$('#module_treegrid').treegrid('expand',row.id);
		}
//		,//IE8下加载慢，先注释掉
//		onLoadSuccess: function (row,data) {
//			$('#module_treegrid').treegrid('collapseAll');
//			$('#module_treegrid').treegrid('expand',moveModId);
//			moveModId = "0";
//		}
	});
}

/**
 * 重新加载模块树
 * @param sysRegId 系统ID
 * @param modId 当前操作的模块
 */
function reload(sysRegId) {
	$('#module_treegrid').treegrid('reload', {
		"sysRegId" : sysRegId
	});
}

/**
 * 打开添加模块窗口
 */
function addModule() {
	if (sysRegId == "") {
		layer.tips('请选择注册系统', '#btn_module_add', { tips: 3 });
		//$.messager.alert('提示', '请选择注册系统！', 'info');
	} else {
		$('#modurl').textbox('textbox').attr('readonly',false);
		$("input",$("#modurl").next("span")).attr("onclick","");
		$("#addForm").form("clear");
		$("#isSeal").switchbutton("uncheck");
		$("#isVrtlNode").switchbutton("uncheck");
		$("#isAudi").switchbutton("check");
		$("#isContr").switchbutton("check");
		$("#isExpand").switchbutton("uncheck");
		$("#mod_icon_add").textbox("disable");
//		$("#isVrtlNodeN").prop("checked","checked");
//		$("#isAudiY").prop("checked","checked");
//		$("#isContrY").prop("checked","checked");
		/*判断原来是否为虚拟节点，如果是则链接不可编辑*/
		var isDisable = $("#isVrtlNode").switchbutton("options").checked;
		if (isDisable) {
			$("#modurl").textbox("disable");
		} else {
			$("#modurl").textbox("enable");
		}
		$('#file1').filebox('setValue',"")
		$("#picResImg1").attr("src", "");
		$('#file1_s').filebox('setValue',"")
		$("#picResImg1_s").attr("src", "");
		
		$('#addDialog').dialog('open');
		$("#sys_id").val(sysRegId);
		createParentData(0);
		//选中仅一个模块时，将该模块带入添加弹出框中的父节点中
		var data = $('#module_treegrid').datagrid('getChecked');
		if (data != null && data.length == 1) {
			if ("Y" == data[0].isVrtlNode) {
				var id = data[0].id;
				$("#addCombobox").combotree("setValue",id);
				var t = $("#addCombobox").combotree("tree");
				var node = t.tree("getSelected");
				//此节点到根节点全部展开
				t.tree("expandTo",node.target);
			}
		}
	}
}

/**
 * 保存模块
 */
function doSave(){
	if (!$("#addForm").form('validate')) {
		return;
	}
	$("#modurl").textbox("enable");
	$("#mod_icon_add").textbox("enable");
	var isSeal = $("#isSeal").switchbutton("options").checked;
	if (isSeal) {
		isSeal = "Y";
	} else {
		isSeal = "N";
	}
	var isVrtlNode = $("#isVrtlNode").switchbutton("options").checked;
	if (isVrtlNode) {
		isVrtlNode = "Y";
	} else {
		isVrtlNode = "N";
	}
	var isAudi = $("#isAudi").switchbutton("options").checked;
	if (isAudi) {
		isAudi = "Y";
	} else {
		isAudi = "N";
	}
	var isContr = $("#isContr").switchbutton("options").checked;
	if (isContr) {
		isContr = "Y";
	} else {
		isContr = "N";
	}
	var isExpand = $("#isExpand").switchbutton("options").checked;
	if (isExpand) {
		isExpand = "Y";
	} else {
		isExpand = "N";
	}
	var isBpm;
	if (document.getElementById("isBpm").checked) {
		isBpm = "Y";
	} else {
		isBpm = "N";
	}
	$.ajax({
		url : 'moduleController/doSaveModule',
		type : 'post',
		async : false,
		data : $("#addForm").serialize()+'&isSeal='+isSeal+'&isVrtlNode='+isVrtlNode+'&isAudi='+isAudi+'&isContr='+isContr+'&isExpand='+isExpand+'&isBpmDeploy='+isBpm,
		success : function(data){
			if (data != null) {
				$.messager.show({ title:'提示', msg:'保存成功！', showType:'slide' });
				$('#addDialog').dialog('close');
				if (data.parentModId == "" || data.parentModId == null) {
					$('#module_treegrid').treegrid('append',{
						parent : null,
						data : [{
							id : data.modId,
							parent_id : data.parentModId,
							iconCls : data.modIcon,
							text : data.modName,
							url : data.modUrl,
							isVrtlNode : data.isVrtlNode,
							isAudi : data.isAudi,
							isContr : data.isContr,
							isExpand : data.isExpand,
							operate : data.modId
						}]
					});
				} else {
					$('#module_treegrid').treegrid('append',{
						parent : data.parentModId,
						data : [{
							id : data.modId,
							parent_id : data.parentModId,
							iconCls : data.modIcon,
							text : data.modName,
							url : data.modUrl,
							isVrtlNode : data.isVrtlNode,
							isAudi : data.isAudi,
							isContr : data.isContr,
							isExpand : data.isExpand,
							operate : data.modId
						}]
					});
					$('#module_treegrid').treegrid('expandTo',data.modId);
				}
				//reload(sysRegId);
			} else {
				$.messager.show({ title:'提示', msg:'保存失败！', showType:'slide' });
				$('#addDialog').dialog('close');
			}
		}
	});
}

/**
 * 删除功能
 */
function delModule() {
	var selecteds = $('#module_treegrid').treegrid('getChecked');
	if (selecteds == null || selecteds.length == 0) {
		layer.tips('请选择需要删除的记录', '#btn_module_del', { tips: 3 });
		//$.messager.alert('提示', '请选择操作项！', 'info');
		return;
	}
	for ( var i = 0; i < selecteds.length; i++) {
		var isVrtlNode = selecteds[0].isVrtlNode;
		if (isVrtlNode == "Y") {
			var children = $('#module_treegrid').treegrid("getChildren",selecteds[0].id);
			if (children != null && children.length > 0) {
				layer.tips('请先删除子节点', '#btn_module_del', { tips: 3 });
				//$.messager.alert('提示', '请先删除子节点！', 'info');
				return;
			}
		}
	}
	$.messager.confirm('删除接口数据', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].id + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'moduleController/doDeleteModule',
				async : false,
				dataType : 'json',
				data : {ids : ids},
				success : function(result) {
					if (result != null) {
						$.messager.show({ title:'提示', msg:'删除成功！', showType:'slide' });
						$('#module_treegrid').treegrid('remove',result.modId);
						$('#module_treegrid').datagrid('clearChecked');
						$('#resc_datagrid').datagrid('loadData', { total: 0, rows: [] });
						
					} else {
						$.messager.show({ title:'提示', msg:'删除失败！', showType:'slide' });
						$('#module_treegrid').datagrid('clearChecked');
					}
					//reload(sysRegId);
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 打开修改模块窗口
 */
function modModule(){
	var data = $('#module_treegrid').datagrid('getChecked');
	if (data == "") {
		layer.tips('请选择一行记录进行修改', '#btn_module_update', { tips: 3 });
		//$.messager.alert('提示', '请选择一行进行修改！', 'info');
		return;
	}
	if (data) {
		if (data.length > 1) {
			layer.tips('请选择一行记录进行修改', '#btn_module_update', { tips: 3 });
			//$.messager.alert('提示', '请选择一行进行修改！', 'info');
			return;
		}
		
		$('#file1').filebox('setValue',"")
		$("#picResImg1").attr("src", "");
		$('#file1_s').filebox('setValue',"")
		$("#picResImg1_s").attr("src", "");
		$("#mod_icon").textbox("disable");
		
		$("#modifyForm").form("clear");
		createParentData(1);
		$("#isVrtlNode0N").prop("disabled",false);
		var module = data[0];
		$("#mod_id").val(module.id);
		$("#mod_name").textbox('setValue',module.text);
		$("#table_name").textbox("setValue",module.tableName);
		$.ajax({
			type : 'post',
			url : 'moduleController/getIcon',
			data : {
				id : module.id
			},
			dataType : 'json',
			success : function(data){
				$("#mod_icon").textbox("setValue",data.modIcon);
			}
		});
//		$("#mod_code").textbox('setValue',module.modCode);
		$("#mod_url").textbox('setValue',module.url);
		$("#modCombobox").combotree("setValue", module.parent_id);
		//记录修改之前的父节点ID
		oldParentId = module.parent_id;
		if (module.isSeal == 'Y') {
			$("#isSeal0").switchbutton("check");
		} else {
			$("#isSeal0").switchbutton("uncheck");
		}
		if (module.isVrtlNode == 'Y') {
			$("#isVrtlNode0").switchbutton("check");
		} else {
			$("#isVrtlNode0").switchbutton("uncheck");
		}
		if (module.isAudi == 'Y') {
			$("#isAudi0").switchbutton("check");
		} else {
			$("#isAudi0").switchbutton("uncheck");
		}
		if (module.isContr == 'Y') {
			$("#isContr0").switchbutton("check");
		} else {
			$("#isContr0").switchbutton("uncheck");
		}
		if (module.isExpand == 'Y') {
			$("#isExpand0").switchbutton("check");
		} else {
			$("#isExpand0").switchbutton("uncheck");
		}
		if (module.isBpmDeploy == 'Y') {
			document.getElementById("is_Bpm1").checked=true;
			$('#mod_url').textbox('textbox').attr('readonly',true);
			$("input",$("#mod_url").next("span")).attr("onclick","selectBizSol('mod_url');");
		} else {
			document.getElementById("is_Bpm1").checked=false;
			$('#mod_url').textbox('textbox').attr('readonly',false);
			$("input",$("#mod_url").next("span")).attr("onclick","");
		}
		/*$("#isVrtlNode0"+module.isVrtlNode).prop("checked","checked");
		$("#isAudi0"+module.isAudi).prop("checked","checked");
		$("#isContr0"+module.isContr).prop("checked","checked");*/
		/*判断原来是否为虚拟节点，如果是则链接不可编辑*/
		var isVrtlNode = $("#isVrtlNode0").switchbutton("options").checked;
		if (isVrtlNode) {
			$("#urlSpanModify").hide();
			$("#mod_url").removeAttr("required");
			$("#mod_url").removeAttr("missingMessage");
			$("#mod_url").textbox("disable");
			//如果节点下有子节点，则不能修改‘是否虚拟节点’
			var children = $('#module_treegrid').treegrid("getChildren",module.id);
			if (children != null && children.length > 0) {
//				$("#isVrtlNode0N").prop("disabled",true);
				$("#isVrtlNode0").switchbutton("disable");
			}
		} else {
			$("#mod_url").textbox("enable");
			$("#urlSpanModify").show();
			$("#mod_url").attr("required",true);
			$("#mod_url").attr("missingMessage","不能为空");
		}
		
		$("#modifyForm #modImg").val(module.modImg);
		$("#modifyForm #modImgSmall").val(module.modImgSmall);
		
		$("#picResImg").attr("src", "ocrController/doDownLoadPicFile?picPath=" + module.modImg + "&r="+new Date());
		$("#picResImg_s").attr("src", "ocrController/doDownLoadPicFile?picPath=" + module.modImgSmall + "&r="+new Date());
		$('#modifyDialog').dialog('open');
	}
}

/**
 * 修改模块
 */
function doModify(){
	if (!$("#modifyForm").form('validate')) {
		return;
	}
	$("#mod_url").textbox("enable");
	$("#mod_icon").textbox("enable");
	var isSeal = $("#isSeal0").switchbutton("options").checked;
	if (isSeal) {
		isSeal = "Y";
	} else {
		isSeal = "N";
	}
	var isVrtlNode = $("#isVrtlNode0").switchbutton("options").checked;
	if (isVrtlNode) {
		isVrtlNode = "Y";
	} else {
		isVrtlNode = "N";
	}
	var isAudi = $("#isAudi0").switchbutton("options").checked;
	if (isAudi) {
		isAudi = "Y";
	} else {
		isAudi = "N";
	}
	var isContr = $("#isContr0").switchbutton("options").checked;
	if (isContr) {
		isContr = "Y";
	} else {
		isContr = "N";
	}
	var isExpand = $("#isExpand0").switchbutton("options").checked;
	if (isExpand) {
		isExpand = "Y";
	} else {
		isExpand = "N";
	}
	var isBpm1;
	if (document.getElementById("is_Bpm1").checked) {
		isBpm1 = "Y";
	} else {
		isBpm1 = "N";
	}
	$.ajax({
		url : 'moduleController/doUpdateModule',
		type : 'post',
		async : false,
		data : $("#modifyForm").serialize()+'&isSeal='+isSeal+'&isVrtlNode='+isVrtlNode+'&isAudi='+isAudi+'&isContr='+isContr+'&isExpand='+isExpand+'&isBpmDeploy='+isBpm1,
		success : function(data){
			if (data != null) {
				$.messager.show({ title:'提示', msg:'修改成功！', showType:'slide' });
				$('#modifyDialog').dialog('close');
				/**如果修改没有改变父节点，那么直接修改该条记录*/
				if (oldParentId == data.parentModId) {
					$('#module_treegrid').treegrid('update',{
						id: data.modId,
						row: {
							text: data.modName,
							url: data.modUrl,
							isSeal : data.isSeal,
							isVrtlNode : data.isVrtlNode,
							isAudi : data.isAudi,
							isContr : data.isContr,
							isExpand : data.isExpand,
							modImg : data.modImg,
							modImgSmall : data.modImgSmall,
							tableName : data.tableName
						}
					});
				} else {/**如果改变了父节点，在前端删掉这条行，在新的父节点后面追加该条记录*/
					if (data.parentModId == "" || data.parentModId == null) {
						$('#module_treegrid').treegrid('remove',data.modId);
						$('#module_treegrid').datagrid('clearChecked');
						$('#module_treegrid').treegrid('append',{
							parent : null,
							data : [{
								id : data.modId,
								parent_id : data.parentModId,
								iconCls : data.modIcon,
								text : data.modName,
								url : data.modUrl,
								isVrtlNode : data.isVrtlNode,
								isAudi : data.isAudi,
								isContr : data.isContr,
								isExpand : data.isExpand,
								operate : data.modId,
								modImg : data.modImg,
								modImgSmall : data.modImgSmall,
								tableName : data.tableName
							}]
						});
					} else {
						$('#module_treegrid').treegrid('remove',data.modId);
						$('#module_treegrid').datagrid('clearChecked');
						$('#module_treegrid').treegrid('append',{
							parent : data.parentModId,
							data : [{
								id : data.modId,
								parent_id : data.parentModId,
								iconCls : data.modIcon,
								text : data.modName,
								url : data.modUrl,
								isVrtlNode : data.isVrtlNode,
								isAudi : data.isAudi,
								isContr : data.isContr,
								isExpand : data.isExpand,
								operate : data.modId,
								modImg : data.modImg,
								modImgSmall : data.modImgSmall,
								tableName : data.tableName
							}]
						});
						$('#module_treegrid').treegrid('expandTo',data.modId);
					}
				}
			} else {
				$.messager.show({ title:'提示', msg:'修改失败！', showType:'slide' });
				$('#modifyDialog').dialog('close');
			}
			//reload(sysRegId);
		}
	});
}

/**
 * 加载父级节点数据
 * 
 * @param 新增：0
 *            修改：1
 */
function createParentData(type) {
	$("#addCombobox").combotree("loadData","");
	$.ajax({
		type : "post",
		url : "moduleController/findVrtlNodeBySysRegId",
		async : false,
		data : {
			sysRegId : sysRegId
		},
		async : false,
		dataType : "json",
		success : function(data) {
			if (type == 0) {
				$("#addCombobox").combotree("loadData", data);
				//解决IE8删除键回退bug
				refuseBackspace("addCombobox");
			} else {
				$("#modCombobox").combotree("loadData", data);
				//解决IE8删除键回退bug
				refuseBackspace("modCombobox");
			}
		}
	});
}

/**
 * 绑定添加模块窗口中模块链接是否可编辑，是否虚拟：是（不可编辑），否（可编辑）
 * */
function disableAddUrl(){
	 $('#isVrtlNode').switchbutton({
         onChange: function(checked){
             if (checked) {
            	 moduleUrl = $("#modurl").textbox("getValue");
         		$("#modurl").textbox("setValue","/");
         		$("#modurl").textbox("disable");
         		$("#isAudiN").prop("checked","checked");
         		$("#isContrN").prop("checked","checked");
         		$("#urlSpanAdd").hide();
         		$("#modurl").removeAttr("required");
         		$("#modurl").removeAttr("missingMessage");
			} else {
				$("#modurl").textbox("setValue",moduleUrl);
				$("#modurl").textbox("enable");
				$("#isAudiY").prop("checked","checked");
				$("#isContrY").prop("checked","checked");
				$("#urlSpanAdd").show();
				$("#modurl").attr("required",true);
				$("#modurl").attr("missingMessage","不能为空");
			}
         }
     })
	/*$("#isVrtlNodeY").click(function(){
		moduleUrl = $("#modurl").textbox("getValue");
		$("#modurl").textbox("setValue","/");
		$("#modurl").textbox({"readonly" : true});
		$("#isAudiN").prop("checked","checked");
		$("#isContrN").prop("checked","checked");
		$("#urlSpanAdd").hide();
		$("#modurl").removeAttr("required");
		$("#modurl").removeAttr("missingMessage");
	});
	$("#isVrtlNodeN").click(function(){
		$("#modurl").textbox("setValue",moduleUrl);
		$("#modurl").textbox({"readonly" : false});
		$("#isAudiY").prop("checked","checked");
		$("#isContrY").prop("checked","checked");
		$("#urlSpanAdd").show();
		$("#modurl").attr("required",true);
		$("#modurl").attr("missingMessage","不能为空");
	});*/
}

/**
 * 绑定修改模块窗口中模块链接是否可编辑，是否虚拟：是（不可编辑），否（可编辑）
 * */
function disableModUrl(){
	$('#isVrtlNode0').switchbutton({
        onChange: function(checked){
            if (checked) {
            	moduleUrl = $("#mod_url").textbox("getValue");
        		$("#mod_url").textbox("setValue","/");
        		$("#mod_url").textbox("disable");
        		$("#isAudi0N").prop("checked","checked");
        		$("#isContr0N").prop("checked","checked");
        		$("#urlSpanModify").hide();
        		$("#mod_url").removeAttr("required");
        		$("#mod_url").removeAttr("missingMessage");
			} else {
				$("#mod_url").textbox("setValue",moduleUrl);
				$("#mod_url").textbox("enable");
				$("#isAudi0Y").prop("checked","checked");
				$("#isContr0Y").prop("checked","checked");
				$("#urlSpanModify").show();
				$("#mod_url").attr("required",true);
				$("#mod_url").attr("missingMessage","不能为空");
			}
        }
    })
	/*$("#isVrtlNode0Y").click(function(){
		moduleUrl = $("#mod_url").textbox("getValue");
		$("#mod_url").textbox("setValue","/");
		$("#mod_url").textbox({"readonly" : true});
		$("#isAudi0N").prop("checked","checked");
		$("#isContr0N").prop("checked","checked");
		$("#urlSpanModify").hide();
		$("#mod_url").removeAttr("required");
		$("#mod_url").removeAttr("missingMessage");
	});
	$("#isVrtlNode0N").click(function(){
		$("#mod_url").textbox("setValue",moduleUrl);
		$("#mod_url").textbox({"readonly" : false});
		$("#isAudi0Y").prop("checked","checked");
		$("#isContr0Y").prop("checked","checked");
		$("#urlSpanModify").show();
		$("#mod_url").attr("required",true);
		$("#mod_url").attr("missingMessage","不能为空");
	});*/
}

/**
 * 上移
 * @author 王建坤
 * @param modId 模块ID
 * @param parentId 父节点ID
 */
function doUpSort(modId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		type : 'post',
		url : 'moduleController/doUpSort',
		async : false,
		data : {
			modId : modId,
			parentId : parentId,
			sysRegId : sysRegId
		},
		dataType : 'json',
		success : function(data) {
			if (data.success == 'true') {
				$.messager.show({ title:'提示', msg:'操作成功', showType:'slide' });
				reload(sysRegId);
				var modId = data.modId;
				var parentNode = $('#module_treegrid').treegrid('getParent',modId);
				moveModId = parentNode.id;
			} else {
				$.messager.show({ title:'提示', msg:'操作失败', showType:'slide' });
			}
		}
	});
}

/**
 * 下移
 * @author 王建坤
 * @param modId 模块ID
 * @param parentId 父节点ID
 */
function doDownSort(modId,parentId){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	$.ajax({
		type : 'post',
		url : 'moduleController/doDownSort',
		async : false,
		data : {
			modId : modId,
			parentId : parentId,
			sysRegId : sysRegId
		},
		dataType : 'json',
		success : function(data) {
			reload(sysRegId);
			var modId = data.modId;
			var parentNode = $('#module_treegrid').treegrid('getParent',modId);
			moveModId = parentNode.id;
		}
	});
}

/**
 * 查询系统注册树
 * */
function sysTreeSearch(){
	var searchValue = $("#sys_search").searchbox('getValue');
	
	$("#sys_reg_tree").tree('search',searchValue);
}

/**
 * 查询条件
 * */
function findByModuleName() {
	var url = "";
	var moduleName = $("#search").searchbox('getValue');
	if ($.trim(moduleName) == '') {
		url = "moduleController/findBySysRegId";
		$('#module_treegrid').treegrid({
			url : url,
			queryParams : {
				sysRegId : sysRegId,
				moduleName : moduleName
			}
		});
	} else {
		url = "moduleController/findByModuleName";
		$('#module_treegrid').treegrid({
			url : url,
			queryParams : {
				sysRegId : sysRegId,
				moduleName : moduleName
			}
		});
	}
}

/*************************** 格式化字段值 ***************************/
/**
 * 格式化是否封存节点
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIsSeal(val, row) {
	if (val == "Y") {
		return "<span style=\'color:red\'>是</span>";
	} else {
		return "否";
	}
}

/**
 * 格式化是否虚拟节点
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIsVrtlNode(val, row) {
	if (val == "Y") {
		return "是";
	} else {
		return "否";
	}
}

/**
 * 格式化是否审计
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIsAudi(val, row) {
	if (val == "Y") {
		return "是";
	} else {
		return "否";
	}
}

/**
 * 格式化是否监控性能
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIsContr(val, row) {
	if (val == "Y") {
		return "是";
	} else {
		return "否";
	}
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
 * 格式化资源详情
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatRes(val, row) {
	var id = row.id;
	var parentId = row.parent_id;
	/*如果是虚拟节点，不刷新资源列表*/
	/*if (row.isVrtlNode == "Y") {
		return "";
	}else{
		return '<a href="javascript:viewInfo(\''+id+'\')" class="easyui-linkbutton">查看详情</a>';
	}*/
	return '<a href="javascript:viewInfo(\''+id+'\')" class="easyui-linkbutton">资源详情</a>';
}

function viewInfo(id){
	//全局变量，模块ID，在resource.js中定义
	moduleId = id;
	//清除资源选中状态
	$('#resc_datagrid').datagrid('clearChecked');
	reloadResourceList();
	$('#resDialog').dialog('open');
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
	 $("#sys_search").searchbox("setValue","");
}

/**
 * 选择文件后，将文件上传到服务器，再将服务器生成的文件下载到客户端
 * 注：为了防止浏览器无法读取本地文件，故需要上传文件到客户端后再读取
 */
function fileOnchange() {
	var id = $(this).attr("id");
	/*accept="image/gif, image/jpeg, image/jpg, image/png"
		
		$('#file').filebox({
			accept: 'image/*'
		});*/
	var formId = $('#'+id).parent().parent().parent().parent().parent().attr('id');
	var picSrc = $('#'+id).filebox('getValue');
	if (picSrc == undefined || picSrc == '') {
		return;
	}
	if (picSrc.indexOf(".jpg") < 0 && picSrc.indexOf(".jpeg") <0 && picSrc.indexOf(".png") < 0 && picSrc.indexOf(".bmp") < 0) {
		//$.messager.alert('提示', '仅支持jpg、jpeg、png、bmp格式图片，请重新选择！', 'info');
		//$("#file").filebox('setValue', '');
		return;
	}

	// 当选择图片后上传图片到服务器，再下载
	// 注：未放置不能读取本地文件故需先上传后再下载写入到IMG控件中
	$('#'+formId).form('submit', {
		url : 'moduleController/upfileImg?id='+id,
	    success:function(data){
	    	var retval = eval("("+data+")");
	    	var curPicPath = retval.filePath;
	    	if ("file" == id) {
	    		$("#"+formId +" #modImg").val(curPicPath);
	    	}
	    	if ("file_s" == id) {
	    		$("#"+formId +" #modImgSmall").val(curPicPath);
	    	}
	    	if ("file1" == id) {
	    		$("#"+formId +" #modImg").val(curPicPath);
	    	}
	    	if ("file1_s" == id) {
	    		$("#"+formId +" #modImgSmall").val(curPicPath);
	    	}
	    	
	    	// 从服务器下载当前上传的图片路径，并赋值到IMG控件中
			//$("#picResImg").attr("src", "");
	    	var viewId = $('#'+id).parent().parent().next().find('img').attr('id');
	    	$("#"+viewId).attr("src", "ocrController/doDownLoadPicFile?picPath=" + curPicPath + "&r="+new Date());
	    },
	    error:function(data){
	    	alert("执行出现异常");
	    }
	});
	
}

/**
 * 打开流程定义基本信息修改弹窗
 */
function selectBizSol(inputId){
	var url = $('#'+inputId).textbox('getValue');
	var src = 'bpmBizDeployController/selectBizSol?inputId='+inputId+"&url=" + url;
	$('#iframe').attr('src', src);
	$('#bizSolDlg').dialog({    
	    title: '选择应用模型',
	    width: 800,
	    height: 500,
	    cache: false,
	    closed : false
	}); 
}

function setUrl(url,inputId) {
	$('#'+inputId).textbox('setValue', url);
}

/*
 * 一键展开
 */
function spreadModule() {
	if(sysRegId == ''){
		layer.tips('请选择注册系统', '#btn_module_spread', { tips: 3 });
		return;
	}
	$('#module_treegrid').treegrid('expandAll');
}

/*
 * 一键关闭
 */
function closeModule() {
	if(sysRegId == ''){
		layer.tips('请选择注册系统', '#btn_module_close', { tips: 3 });
		return;
	}
	$('#module_treegrid').treegrid('collapseAll');
}

function sortModule(){
	if(sysRegId == ''){
		//$.messager.alert('提示', '请选择注册系统！', 'info');
		layer.tips('请选择注册系统', '#btn_module_sort', { tips: 3 });
		return;
	}
	
	$('#tg').treegrid('loadData',[]);
	$('#tg').treegrid({
		url : 'moduleController/findBySysRegId',
		queryParams:{
			sysRegId:sysRegId
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
		url : "moduleController/doSaveSort",
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
			if(editId == jsonArr[i].modId){
				jsonArr[i].sort = val;
				flag = true;
				break;
			}
		}
	}
	if (!flag) {
		var data = {};
		data.modId = editId;
		data.sort = val;
		jsonArr.push(data);
	}
}

function formaterModuleSort(val, row){
	if (jsonArr != '') {
		for (var i = 0;i < jsonArr.length;i++){
			if(row.id == jsonArr[i].modId){
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