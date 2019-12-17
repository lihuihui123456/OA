/**
 * 初始化函数
 */
$(function() {
	InitTreeData();
	
});

/**
 * 全局变量
 * */
var typeId = "";//系统类型配置ID

/**
 * 初始化加载左侧树
 */
function InitTreeData() {
	$('#tree').tree({
		url : 'sysConfigTypeController/findSysConfigTypes',
		animate : true,
		checkbox : false,
		onlyLeafCheck : true,
		onClick : function(node) {
			typeId = node.id;
			var url = 'sysConfigController/findSysConfigsOfSysType?typeId='+typeId+"&typeName="+node.text;
			refreshIframe(url);
		},
		onContextMenu : function(e, node) {
			e.preventDefault();
			$('#tree').tree('select', node.target);
			if (node.id == '0') {
				return;
			}
			$('#mm').menu('show', {
				left : e.pageX,
				top : e.pageY
			});
		}
	});
}

/**
 * 修改系统配置类型节点
 */
function modNote() {
	var node = $('#tree').tree('getSelected');
	if (node) {
		$("#id").val(node.id);
		$("#code").textbox('setValue', node.attributes.code);
		$("#name").textbox('setValue', node.text);
		$("#desc").textbox('setValue', node.attributes.typeDesc);
		$('#typeDialog').dialog({ title : "修改系统配置类型" });
		$('#typeDialog').dialog('open');
	}
}

/**
 * 保存系统配置类型
 */
function savetype() {

	if (!$('#typeForm').form('validate')) {
		return;
	}
	var id = $("#id").val();
	var url = '';
	if (id == '') {
		url = 'sysConfigTypeController/doSaveSysType';
	} else {
		url = 'sysConfigTypeController/doUpdateSysType';
	}
	$.ajax({
		url : url,
		type : "POST",
		async : false,
		data : $("#typeForm").serialize(),
		success : function(data) {
			if (data == '1') {
				$.messager.show({ title:'提示', msg:'编码已存在！', showType:'slide' });
				$("#code").textbox('setValue', '');
				return;
			} else if (data == 'fail') {
				$.messager.show({ title:'提示', msg:'保存失败！', showType:'slide' });
				$('#typeDialog').dialog('close');
			} else {
				$.messager.show({ title:'提示', msg:'保存成功！', showType:'slide' });
				$('#typeDialog').dialog('close');
				InitTreeData();
			}
		}
	});
}

/**
 * 刷新系统配置iframe
 * */
function refreshIframe(url){
	$("#configFrame").attr("src",encodeURI(encodeURI(url)));
}

function clearSearchBox(){
	$("#search").searchbox("setValue","");
}

function orgTreeSearch(){
	var searchValue = $("#search").searchbox('getValue');
	$("#tree").tree('search',searchValue);
}