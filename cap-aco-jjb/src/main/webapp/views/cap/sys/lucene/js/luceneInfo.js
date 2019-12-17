
/**
 * 打开添加参数窗口
 */
function addParm(){
	$('#dlg').dialog('open');
}

var flg = "";
var r_index;


/**
 * 重新加载接口类型树
 */
function reloadbytype(typeid) {
	$('#dtlist').treegrid('reload', {
		"typeid" : typeid
	});
}
/**
 * 保存参数
 */
function saveParms(){
	
	var parmName = null, sort=null,defValue=null,remark=null;
	parmName = $.trim($("#parmName").val());
	sort = $.trim($("#sort").val());
	defValue = $.trim($("#defValue").val());
	remark = $.trim($("#para_remark").val());

	 if(flg != "1"){
		 $('#tb1').datagrid('appendRow', { 
				
                "parmName": parmName,
                "sort": sort ,               
            	"defValue":defValue,
				"remark": remark             
		});
	 }else{
		 $('#tb1').datagrid('updateRow', { 
			index: r_index,
			 row: {
                 "parmName": parmName,
                 "sort": sort ,               
             	 "defValue":defValue,
 				 "remark": remark         
	         },              
		});
	 }
	 cancel();
	 flg="";
}

/**
 * 生成参数列表操作超链接
 */
function planUrl(val,row){
 	return '<a href="javascript:void(0)" onclick="updateTb(this)">编辑</a>'
		+ '&nbsp;&nbsp;<a href="javascript:void(0)" onclick="deleteTb(this)">删除</a>';
}

/**
 * 删除选中行
 */
function deleteTb(obj){
	flg = "";
	var index = $(obj).parent().parent().parent().index();
	
	$('#tb1').datagrid('selectRow', index);
	var row = $('#tb1').datagrid('getSelected');
	if (row) {
         var rowIndex = $('#tb1').datagrid('getRowIndex', row);
         $('#tb1').datagrid('deleteRow', rowIndex);  
	 }
}

/**
 * 修改选中行
 */
function updateTb(obj){
	
	r_index = $(obj).parent().parent().parent().index();
	
	$('#tb1').datagrid('selectRow', r_index);
	
	var v_rows = $('#tb1').datagrid('getSelections')[0];
		
	$("#parmName").textbox('setValue',v_rows.parmName);
	$("#sort").textbox('setValue',v_rows.sort);
	$("#defValue").textbox('setValue',v_rows.defValue);
	$("#para_remark").textbox('setValue',v_rows.remark);
	
	flg = "1";
	$('#dlg').dialog('open');
}

/**
 * 取消
 */
function cancel(){
	$("#parmName").textbox('setValue',"");
	$("#sort").textbox('setValue',"");
	$("#defValue").textbox('setValue',"");
	$("#remark").textbox('setValue',"");
	
	$('#dlg').dialog('close');
}

/**
 * 保存接口信息
 */
function doSaveIntfcInfo(type) {
	var id = $("#id").val()
	var url = $("#url").val();
	var user = $("#user").val();
	var pwd = $("#pwd").val();
	var driver = $("#driver").val();
	alert(url+":"+user+':'+pwd+':'+driver+':'+id);
	if(type == '1'){
		AjaxURL = "luceneController/doUpdateConnInfo?url="+url+"&user="+user+"&id="+id+"&pwd="+pwd+"&driver="+driver;
	}else{
		AjaxURL = "luceneController/doSaveConnInfo?url="+url+"&user="+user+"&pwd="+pwd+"&driver="+driver;
	}

	$.ajax({
		type: "POST",
		url: AjaxURL,
		async: false,
		data: $('#add_intfc_form').serialize(),
		success: function (data) {
			$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
			reloadbytype(typeid);
			if(type == '1'){
				window.parent.closeAndReloadTab('修改连接', '连接管理');
			}else{
				window.parent.closeAndReloadTab('添加连接', '连接管理');
			}
		},
		error: function(data) {
			$.messager.show({ title:'提示', msg:'保存失败', showType:'slide' });
		}
	});
}

