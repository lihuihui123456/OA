/**
 * 全局变量
 * 
 * json数组数据示例：[{id:'REPEAT',text:'多点重复登录'},{id:'SINGLE',text:'单点登录'},{id:'REPLACE',text:'替换登录'}]
 * */
var modifyMap = {};

/**
 * 记录修改项
 * */
function rememberData(newValue,oldValue){
	var id = $(this).attr("configId");
	modifyMap[id] = newValue;
}

/**
 * 保存修改
 * */
function doSave(){
	if (!$('#configForm').form('validate')) {
		return;
	}
	var jsonAttr = [];
	var jsonStr = "";
	if (modifyMap) {
		for (var key in modifyMap) {
			var jObj = {};
			jObj.id = key;
			jObj.proValue = modifyMap[key];
			jsonAttr.push(jObj);
		}
		jsonStr = JSON.stringify(jsonAttr);
	}
	var url = 'sysConfigController/doUpdateSysConfig?jsonStr='+jsonStr;
	$.ajax({
		type : 'post',
		url : encodeURI(encodeURI(url)),
		success : function(data){
			if (data.status == 'success') {
				$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
			} else {
				$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
			}
		}
	});
}
