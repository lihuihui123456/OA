$(function() {
	getListdata();
});

var typeid = "";

var nodeid = "";

function getListdata() {
	$('#dtlist').treegrid({
		url : 'luceneController/findConnList',
		method : 'POST',
		idField : 'luce_id',
		fit : true,
		striped : true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolBar',
		showFooter : true,
		columns : [ [ 
		    { field : 'ck', checkbox : true }, 
		    { field : 'luce_id', title : 'id', hidden : true }, 
		    { field : 'name', title : '数据库名', width : 40, align : 'center'},
		    { field : 'luce_data', title : 'url', width : 120, align : 'center'},
		    { field : 'luce_name', title : '用户名', width : 40, align : 'center'},
		    { field : 'luce_pass', title : '密码', width : 50, align : 'center'},
		    { field : 'luce_driver', title : '数据库驱动', width : 60, align : 'center'},
		    { field : 'caozuo',
				formatter : function(value, row) {
					return '<a href="javascript:testConnUrl()">';
				}
		    },
		    { field : 'chakan',
		    	formatter : function(value, row) {
					return '<a href="javascript:findSqls()"';
				}
		    }  ] ],
		onBeforeLoad : function(param) {
		},
		onLoadSuccess : function(data) {

		},
		onLoadError : function() {

		},
		onClickCell : function(rowIndex, field, value) {

		}
	});
}

/**
 * 重新加载接口类型树
 */
function reloadbytype(typeid) {
	$('#dtlist').treegrid('reload', {
		"typeid" : typeid
	});
}

/**
 * 新增弹出接口信息页面
 */
function saveInfo() {
	$("#name").textbox('setValue', "");
	$("#url").textbox('setValue', "");
	$("#user").textbox('setValue', "");
	$("#pwd").textbox('setValue', "");
	nodeid = '';
	$('#ff').dialog({title: "添加数据库信息"});
	$('#ff').dialog('open');
}

/**
 * 修改弹出接口信息页面
 */
function updateInfo() {
	var data = $('#dtlist').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('提示', '请选择一行进行修改！');
		layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('提示', '请选择一行进行修改！');
			layer.tips('请选择一行进行修改', '#btn_edit', { tips: 3 });
			return;
		}
		nodeid = data[0].luce_id;
		$("#name").textbox('setValue', data[0].name);
		$("#url").textbox('setValue', data[0].luce_data);
		$("#user").textbox('setValue', data[0].luce_name);
		$("#pwd").textbox('setValue', data[0].luce_pass);
		$("#driver").textbox('setValue', data[0].luce_driver);
		$('#ff').dialog({title: "修改数据库信息"});
		$('#ff').dialog('open');
	}
}

/**
 * 删除接口信息
 */
function deleteInfo() {
	var selecteds = $('#dtlist').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		//$.messager.alert('删除数据库数据', '请选择操作项！');
		layer.tips('请选择操作项', '#btn_del', { tips: 3 });
		return;
	}
	$.messager.confirm('删除数据库数据', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].luce_id + ",";
			});

			ids = ids.substring(0, ids.length - 1);

			$.ajax({
				url : 'luceneController/doDeleteConnInfo',
				dataType : 'json',
				data : {ids : ids},
				success : function(result) {
					var msg = result;
					$.messager.show({ title:'提示', msg:'删除成功', showType:'slide' });
					reloadbytype(typeid);
					$('#dtlist').datagrid('clearSelections'); // 清空选中的行
					$('#dtlist').datagrid('clearChecked'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 弹出测试接口信息页面
 */
function testConnUrl(){
	var data = $('#dtlist').datagrid('getChecked');
	if (data == "") {
		//$.messager.alert('测试连接', '请选择一行测试！');
		layer.tips('请选择一行测试', '#btn_test', { tips: 3 });
		return;
	}
	if (data) {
		if (data.length > 1) {
			//$.messager.alert('测试连接', '请选择一行测试！');
			layer.tips('请选择一行测试', '#btn_test', { tips: 3 });
			return;
		}
		var selecteds = $('#dtlist').datagrid('getSelections');
		var id = selecteds[0].luce_id;
	    var luceData = selecteds[0].luce_data;
	    var luceName = selecteds[0].luce_name;
	    var lucePass = selecteds[0].luce_pass;
	    var luceDriver = selecteds[0].luce_driver;
		$.ajax({
			type: "POST",
			url: "luceneController/testIfConn",
			async: false,
			data: {url:luceData, username:luceName,passwd:lucePass,classDriver:luceDriver},
			success: function (data) {
				if(data=='连接成功'){
					 $.messager.alert('提示', "连接成功！");
				     }else if (data=='url错误'){
				    	 $.messager.alert('提示', "连接失败,url错误！");
				     }else if (data=='驱动错误'){
				    	 $.messager.alert('提示', "连接失败,驱动错误！");
				     }else if (data=='用户名或密码错误'){
				    	 $.messager.alert('提示', "连接失败,用户名或密码错误！");
				     }
			}
		});
	}
}
/**
 * 弹出sql语句信息页面
 */
function findSqls(){
	var selecteds = $('#dtlist').datagrid('getSelections');
	var id = selecteds[0].luce_id;
	var name = selecteds[0].name;
	var luceData = selecteds[0].luce_data;
	var luceName = selecteds[0].luce_name;
	var lucePass = selecteds[0].luce_pass;
	var luceDriver = selecteds[0].luce_driver;
	window.parent.addTab("查看数据库"+name+"的sql语句","luceneController/showSqls?id="+id+"&url="+luceData+"&user="+luceName+"&pwd="+lucePass+"&driver="+luceDriver);
}

/**
 * 保存接口信息
 */
function doSaveIntfcInfo(type) {	
	if (!$('#tableForm').form('validate')) {
		return;
	}
	var name = $("#name").textbox('getValue');
	var url = $("#url").textbox('getValue');
	var user = $("#user").textbox('getValue');
	var pwd = $("#pwd").textbox('getValue');
	var driver = $("#driver").textbox('getValue');
	if(nodeid == ''){
		$.ajax({
			type: "POST",
			url: "luceneController/doSaveConnInfo",
			async: false,
			data: {name:name,url:url,user:user,pwd:pwd,driver:driver},
			success: function (data) {
				$.messager.show({ title:'提示', msg:'保存成功', showType:'slide' });
				reloadbytype(typeid);
			    $('#ff').dialog('close');
			},
			error: function(data) {
				$.messager.show({ title:'提示', msg:'保存失败', showType:'slide' });
			}
		});
	}else{
		$.ajax({
			type: "POST",
			url:  "luceneController/doUpdateConnInfo",
			async: false,
			data: {id:nodeid,name:name,url:url,user:user,pwd:pwd,driver:driver},
			success: function (data) {
				$.messager.show({ title:'提示', msg:'修改成功', showType:'slide' });
				reloadbytype(typeid);
			    $('#ff').dialog('close');
			},
			error: function(data) {
				$.messager.show({ title:'提示', msg:'修改失败', showType:'slide' });
			}
		});
	}
}
/**
 * 测试接口信息
 */
function test(){
		if (!$('#tableForm').form('validate')) {
			return;
		}
		var url = $("#url").textbox('getValue');
		var user = $("#user").textbox('getValue');
		var pwd = $("#pwd").textbox('getValue');
		var driver = $("#driver").textbox('getValue');
		$.ajax({
			type: "POST",
			url: "luceneController/testIfConn",
			async: false,
			data: {url:url, username:user,passwd:pwd,classDriver:driver},
			success: function (data) {
				if(data=='连接成功'){
					 $.messager.alert('提示', "连接成功！");
				     }else if (data=='url错误'){
				    	 $.messager.alert('提示', "url错误！");
				     }else if (data=='驱动错误'){
				    	 $.messager.alert('提示', "驱动错误！");
				     }else if (data=='用户名或密码错误'){
				    	 $.messager.alert('提示', "用户名或密码错误！");
				     }
			}
		});
}

$.extend($.fn.textbox.defaults.rules, {
	checkUrl: {
        validator: function (value) {
        	var falg=1;
        	for(var i = 0;i < value.length; i++){
        		if(value.charCodeAt(i) > 255){
        			falg=0;
        		}
        	}      
        	if(falg==0){
	               return false;
             }else{
	               return true;
              }
        },
        message: 'URL格式不正确'
    },
	checkName: {
        validator: function (value) {
        	var reg=/^[u4e00-u9fa5]+$/;
 		   if(reg.test(value)){
            	return true;
            }else{
            	return false;
            } 
        },
        message: '不能包含中文'
    }
});

