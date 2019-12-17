$(function() {
	// 初始化单位树
	initDeptTree();
	$('#dtlist').datagrid({
		onClickRow: function(index,row){
			//cancel all
			$('#dtlist').datagrid("clearChecked");
			//check the select row
			$('#dtlist').datagrid("selectRow", index);
		}
	});
	$("input",$(".prefix").next("span")).blur(function(){  
		setPreview();
	});
	
	$("#nature_number").combobox({
		onChange: function (n,o) {
			setPreview();
		}
		});
});

var nodeid = "";
/**
 * 初始化加载左侧单位树（单位+部门+表单）
 * 
 * @param 无
 * @return 无
 */
function initDeptTree() {
	$('#doc_num_tree').tree({
		url : "docNumMgrController/findAllDocType",
		animate : true,//开启折叠动画
		checkbox : false,
		onlyLeafCheck : true,
		//树加载成功后回调函数（用于初始化列表）
		onClick : function(node) {
			//展开点击选中的节点
			$('#doc_num_tree').tree('expand', node.target)
			// 点击单位节点时，加载单位下的所有部门
			var node = $('#doc_num_tree').tree('getSelected');
			findByDeptId(node.id);
		},
		onContextMenu : function(e, node) {
			e.preventDefault();
			$('#doc_num_tree').tree('select', node.target);
			var nodes = $('#doc_num_tree').tree('getSelected', 'info');
			if(nodes.id == '3'){
				$("#addMenu").show();
				$("#editMenu").hide();
				$("#delMenu").hide();
				//打开菜单
				$('#mm').menu('show', {
					left : e.pageX,
					top : e.pageY
				});
			}else if(nodes.parentId=='3'){
				$("#addMenu").hide();
				$("#editMenu").show();
				$("#delMenu").show();
				//打开菜单
				$('#mm').menu('show', {
					left : e.pageX,
					top : e.pageY
				});
			}else{
				$("#addMenu").hide();
				$("#editMenu").hide();
				$("#delMenu").hide();
			}	
			
		}
	});
}
/**
 * 增加自由表单树节点
 */
function addNote() {
	$("#name_").textbox('setValue', "");
	$("#code_").textbox('setValue', "");
	$("#remark_").textbox('setValue', "");
	$("#code_").textbox('enable');
	nodeid = '';
	//收发文类别树
	$('#code_').combobox({
		panelHeight : 150,
		editable:false,
	    required: true
	});
	//加载收发文类型
	 $('#code_').combobox({
		    url: 'bizSolMgr/getAllSolCtlg',
		    valueField: 'code',    
		    textField: 'solCtlgName_' 
		}); 
	$('#formTableDialog').dialog({title: "新增节点"});
	$('#formTableDialog').dialog('open');
}

/**
 * 删除自由表单树节点
 */
function delNote() {
	var nodes = $('#doc_num_tree').tree('getSelected', 'info');
	if (nodes == null) {
		$.messager.alert('提示', '请选择操作项！');
		return;
	} else if (nodes.id == '0') {
		$.messager.alert('提示', '父级节点不可删除！');
		return;
	} else {
		$.messager.confirm('提示', '确定删除'+nodes.text+'吗?', function(r) {
			if (r) {
		   			$.post("docNumMgrController/doDeleteDocType", {
							"id" : nodes.id
						}, function(data) {
							initDeptTree();
						});     
			}
		});	  
	}
}
/**
 * 修改自由表单树节点
 */
function modNote() {
	var node = $('#doc_num_tree').tree('getSelected');
	if (node) {
		nodeid = node.id;
		$("#name_").textbox('setValue', node.text);
		$("#code_").textbox('setValue', node.code);
		$("#code_").textbox('disable');
		$("#remark_").textbox('setValue', node.remark);
		$('#formTableDialog').dialog({title: "修改节点"});
		$('#formTableDialog').dialog('open');
	}
}

/**
 * 保存自由表单树节点
 */
function savetype() {
	if (!$('#tableDoc').form('validate')) {
		return;
	}
	var name = $("#name_").textbox('getValue');
	var code = $("#code_").textbox('getValue');
	var remark = $("#remark_").textbox('getValue');
	var url = "";
	var docNumType = {
			id_ : nodeid,
			code_ : code,
			name_ : name,
			remark_ : remark
		};
   		    url = "docNumMgrController/doSaveDocType";
   		    $.ajax({
   			url : url,
   			type : "POST",
   			data : docNumType,
   			success : function(data) {
   					if (data == 'true') {
   						$.messager.alert('提示', '保存成功');
   						$('#formTableDialog').dialog('close');
   						initDeptTree();
   					}
   				}
   		});		
}

function findByDeptId(dept_id) {
	$('#dtlist').datagrid({
		url : 'docNumMgrController/findAllDocList',
		emptyMsg : '没有相关记录！',
		method : 'POST',
		idField : 'serial_id',
		treeField : 'serial_id',
		striped : true,
		fitColumns : true,
		singleSelect : true,
		rownumbers : true,
		pagination : true,
		fit : true,
		nowrap : false,
		toolbar : '#toolBar',
		pageSize : 10,
		showFooter : true,
		queryParams:{
			dept_id:dept_id
		},
		columns : [ [ 
		    { field : 'ck', checkbox : true }, 
		    { field : 'serial_id', title : 'serial_id', hidden : true },
		    { field : 'dept_id', title : 'dept_id', hidden : true },
		    { field : 'serial_number_name', title : '文号名称', width : 200, align : 'left'},
		    { field : 'preview_effect', title : '预览效果', width : 200, align : 'left'},
		    { field : 'enable', title : '是否启用', width : 100, align : 'center',
		    	formatter : function(value, row) {
					if (value == 0)
						return '启用';
					if (value == 1)
						return "<span style=\'color:red\'>禁用</span>";
				}
             }
          ] ]
	});
	$('#dtlist').datagrid('load');
	$('#dtlist').datagrid('clearSelections'); // 清空选中的行
}

function orgTreeSearch(){
	var searchValue = $("#org_search").searchbox('getValue');
	$("#doc_num_tree").tree('search',searchValue);
}
/**
 * 重新加载接口类型树
 */
function reloadbytype(dept_id) {
	$('#dtlist').datagrid({
		url : 'docNumMgrController/findAllDocList',
		queryParams: {
			'dept_id': dept_id
		}
	});
}

function setPreview(){
	 var date = new Date();
	 var seperator1 = "-";
	 var seperator2 = ":";
	 var month = date.getMonth() + 1;
	 var strDate = date.getDate();
	 if (month >= 1 && month <= 9) {
	     month = "0" + month;
	 }
	 if (strDate >= 0 && strDate <= 9) {
	     strDate = "0" + strDate;
	 }
	 var myDate = date.getFullYear() + seperator1 + month + seperator1 + strDate;
	var name='';
	var num='';
	var length='';
	var prefix1=$("#prefix_value_one").textbox('getValue');
	var prefix2=$("#prefix_value_two").textbox('getValue');
	var suffix1=$("#suffix_value_one").textbox('getValue');
	var suffix2=$("#suffix_value_two").textbox('getValue');
	
		prefix1=prefix1.replace('[YYYY]',myDate.substring(0,4)).replace('[MM]',myDate.substring(5,7)).replace('[DD]',myDate.substring(8,10)); 
		prefix2=prefix2.replace('[YYYY]',myDate.substring(0,4)).replace('[MM]',myDate.substring(5,7)).replace('[DD]',myDate.substring(8,10)); 
		suffix1=suffix1.replace('[YYYY]',myDate.substring(0,4)).replace('[MM]',myDate.substring(5,7)).replace('[DD]',myDate.substring(8,10)); 
		suffix2=suffix2.replace('[YYYY]',myDate.substring(0,4)).replace('[MM]',myDate.substring(5,7)).replace('[DD]',myDate.substring(8,10));  

	if($("#nature_number").textbox('getValue')=='1'||$("#nature_number").textbox('getValue')=='否'){
		num=$("#initial_value").textbox('getValue');
		length=$("#serial_number_length").textbox('getValue');
		if(length==''||num==''){
			name=prefix1+$("#prefix_object").textbox('getValue')+prefix2
			     +suffix1+$("#suffix_object").textbox('getValue')+suffix2;			
		}else{
		if(num.length<length){
			while(num.length<length){
				num='0'+num;
			}
		}else{
			num=num.substring(0,length);
		}
		name=prefix1+$("#prefix_object").textbox('getValue')+prefix2+num
		     +suffix1+$("#suffix_object").textbox('getValue')+suffix2;
		}
	}else{
		name=prefix1+$("#prefix_object").textbox('getValue')+prefix2+$("#initial_value").textbox('getValue')
		     +suffix1+$("#suffix_object").textbox('getValue')+suffix2;	
	}	 
	$("#preview_effect").textbox('setValue',name);
}

/**
 * 字典数据条件查询
 */
function searchList() {
	var doc_name = $("#doc_name").textbox('getValue');
	var node = $('#doc_num_tree').tree('getSelected');
	if(node==null){
		$.messager.alert('提示', '请选择所属单位！', 'info');
		return ;
	}
	$('#dtlist').datagrid({
		url : "docNumMgrController/findAllDocList",
		queryParams : {
			dept_id : node.id,
			doc_name : doc_name
		}
	});
}
/**
 * 新增弹出接口信息页面
 */
function saveInfo() {
	var node = $('#doc_num_tree').tree('getSelected');
	if(node == null){
		layer.tips('请选择文号类型', '#btn_add', { tips: 3 });
		return;
	}
	$("#dept_id").val(node.id);
	$("#serial_number_name").textbox('setValue', "");
	$("#prefix_value_one").textbox('setValue', "");
	$("#prefix_object").textbox('setValue', "");
	$("#prefix_value_two").textbox('setValue', "");
	$("#serial_number_length").textbox('setValue', "4");
	$("#initial_value").textbox('setValue', "1");
	$("#nature_number").textbox('setValue', "否");
	$("#suffix_value_one").textbox('setValue', "");
	$("#suffix_object").textbox('setValue', "");
	$("#suffix_value_two").textbox('setValue', "");
	$("#preview_effect").textbox('setValue', "0001");
	$("#enable").textbox('setValue', "是");
	nodeid = '';
	$('#ff').dialog('open');
}

/**
 * 修改弹出接口信息页面
 */
function updateInfo() {
	var data = $('#dtlist').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('修改接口数据', '请选择一行进行修改！');
		layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('修改接口数据', '请选择一行进行修改！');
			layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 }); 
			return;
		}
		nodeid = data[0].serial_id;
		$.ajax({
			url: 'docNumMgrController/findDocInfoById/'+nodeid,
			dataType:'json',
			success: function(data){
				setValue(data);
				$('#ff').dialog('open');
			}
		});		
	}
}

/**
 * 删除接口信息
 */
function deleteInfo() {
	var selecteds = $('#dtlist').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('删除文号', '请选择操作项！');
		layer.tips('请选择操作项', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除文号', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			var deptid='';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].serial_id + ",";
				deptid=selecteds[index].dept_id;
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'docNumMgrController/doDeleteDocInfo',
				dataType : 'json',
				data : {ids : ids},
				success : function(result) {
					var msg = result;
					$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
					reloadbytype(deptid);
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
				}
			});
		}
	});
}



/**
 * 保存文号信息
 */
function doSaveDocInfo(type) {	
	if (!$('#tableForm').form('validate')) {
		return;
	}
	var dept=$("#dept_id").val();
	alert(dept);
	if(nodeid == ''){
		$.ajax({
			type: "POST",
			url: "docNumMgrController/doSaveDocInfo",
			async: false,
			data: $('#tableForm').serialize(),
			success: function (data) {
				$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
			    $('#ff').dialog('close');
			    reloadbytype(dept);
			},
			error: function(data) {
				$.messager.show({ title:'提示', msg:'保存失败', showType:'slide' });
			}
		});
	}else{
		$.ajax({
			type: "POST",
			url:  "docNumMgrController/doUpdateDocInfo?id="+nodeid,
			async: false,
			data: $('#tableForm').serialize(),
			success: function (data) {
				$.messager.show({ title:'提示', msg:'修改成功', showType:'slide' });
			    $('#ff').dialog('close');
			    reloadbytype(dept);
			},
			error: function(data) {
				$.messager.show({ title:'提示', msg:'修改失败', showType:'slide' });
			}
		});
	}
}
function setValue(data){
	$("#dept_id").val(data.dept_id);
	$("#serial_number_name").textbox('setValue', data.serial_number_name);
	$("#prefix_value_one").textbox('setValue', data.prefix_value_one);
	$("#prefix_object").textbox('setValue', data.prefix_object);
	$("#prefix_value_two").textbox('setValue', data.prefix_value_two);
	$("#serial_number_length").textbox('setValue', data.serial_number_length);
	$("#initial_value").textbox('setValue', data.initial_value);
	$("#suffix_value_one").textbox('setValue', data.suffix_value_one);
	$("#suffix_object").textbox('setValue', data.suffix_object);
	$("#suffix_value_two").textbox('setValue', data.suffix_value_two);
	$("#preview_effect").textbox('setValue', data.preview_effect);
	if(data.nature_number=='1'){
		$("#nature_number").textbox('setValue',"否");
	}else if( data.nature_number=='0'){
		$("#nature_number").textbox('setValue', "是");
	}
	if(data.enable=='1'){
		$("#enable").textbox('setValue',"否");
	}else if(data.enable=='0'){
		$("#enable").textbox('setValue', "是");
	}
	
}

$.extend($.fn.textbox.defaults.rules, {
	checkNumber: {
		validator: function(value){
    		var reg=/^[0-9]*$/;
    		   if(reg.test(value)){
               	return true;
               }else{
               	return false;
               } 
    	},
        message: '只能输入数字'
    }
});

function formaterState(val, row){
	if (value == 0)
		return '<span class="label label-default">启用</span>';
	if (value == 1)
		return '<span class="label label-warning">禁用</span>';

}
$.extend($.fn.textbox.defaults.rules, {
	checkcode:{
    	validator: function(value){  
    		var falg=1;
    		$.ajax({
    			url:"docNumMgrController/checkcode",
    			type:"post",
    			async:false,
    			cache : false,
    			data:{"code":value},
    			success:function(data){
    		         if('N'==data){
    			       falg=0;
    			       }
    		         }
    			});
                if(falg==0){
	               return false;
                }else{
	               return true;
                 }
    	},
    	message:'code重复'
    } 
});
function initDict(dictArr,showAll){
	for(var code in dictArr)  {
		$('#' + code).combobox({  
		    url: "dictController/findDictByTypeCode?showAll="+showAll+"&dictTypeCode=" + dictArr[code], 
		    valueField: 'dictCode',    
		    textField: 'dictVal'   
		});
		refuseBackspace(code);
	}
}
function refuseBackspace(id){
	 var _input = $("#"+id).siblings().eq(0).children().eq(1);
	 $(_input).keydown(function (e) {
        if (e.keyCode == 8) {
            return false;
        }
    });
}