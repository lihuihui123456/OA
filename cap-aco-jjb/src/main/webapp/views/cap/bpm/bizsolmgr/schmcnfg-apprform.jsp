<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>业务表单</title>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/datagrid-groupview.js"></script>
</head>
<body>
<div style="padding:5px;">
		<a href="javascript:void(0)" onclick="saveData()" class="easyui-linkbutton"
			data-options="plain:true">保存</a>
</div>
<div style="padding:5px;">
    <table id="formList" class="easyui-datagrid" style="width: 99%"
            data-options="url:'${ctx}/bizSolMgr/findFormConfigureBySolId?solId=${solId}&isProcess_=${isProcess_}',
                view:groupview, groupField:'scope_', groupFormatter: formattergroup,
                fitColumns:true,rownumbers:true,nowrap:false,striped:true">
        <thead frozen="true">
			<tr>
                <th data-options="field:'id',width:150,align:'right',formatter:formatterOpert">操作状态&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</th>
                <th data-options="field:'solId_',hidden:true"></th>
                <th data-options="field:'procDefId_',hidden:true">></th>
                <th data-options="field:'nodeInfoId_',hidden:true"></th>
                <th data-options="field:'formId_',hidden:true"></th>
                <th data-options="field:'scope_',hidden:true"></th>
			</tr>
		</thead>
        <thead>
            <tr>
                <th data-options="field:'nodeInfoName_',width:100,align:'center'">节点名称</th>
                <th data-options="field:'formKey_',width:80">表单视图</th>
                <th data-options="field:'formName_',width:80">表单名称</th>
            </tr>
        </thead>
        	<tr>
        		<th>1</td>
        		<th>2</td>
        		<th>3</td>
        		<th>4</td>
        	</tr>
    </table>
</div>
</body>
<script type="text/javascript">
/* $('#formList').datagrid({
	rowStyler: function(index,row){
		if(index % 2 == 0){
			return 'background-color:#6293BB;color:#fff;'; // return inline style
		}
			// the function can return predefined css class and inline style
			// return {class:'r1', style:{'color:#fff'}};	
	}
}); */
var isProcess_ = "${isProcess_}";
function saveData(){
	var datas = $('#formList').datagrid('getData');
	var effectRow = new Object();
	effectRow["formNodeBeans"] = JSON.stringify(datas);
	$.ajax({
		url : '${ctx}/bizSolMgr/doSaveBpmReFormNodeEntity',
		type : 'post',
		dataType :  'text',
		data : effectRow,
		success : function(data){
			if(data) {
				window.parent.removeUrl('apprForm');
				$.messager.show({title:'提示',msg:'保存成功！',timeout:2000,});
			}else{
				$.messager.show({title:'提示',msg:'保存失败！',timeout:2000,});
			}
			$('#formList').datagrid('reload');
		}
	});
}

function formattergroup(value,rows){
	var groupName = '';
	if(value == "1")
		groupName = '节点表单';
	if(value == "2")
		groupName = '明细表单';
	if(value == "3")
		groupName = '开始表单';
	if(value == "4")
		groupName = '全局表单';
	if(value == "5")
		groupName = '业务操作模板';
    return groupName;
}

//表单授权点击事件
function detail(index){
	 var rows = $('#formList').datagrid('getRows');
	 var row = rows[index];
	 var id = row.id;
	 if(id == null && id == ""){
		 alert("请先为业务方案配置表单并保存！");
		 return;
	 }else{
		$.ajax({
			url: "${ctx}/bizSolMgr/findRuleCfg",
			type:"post",
			dataType:"json",
			data:{
				id : id
			},
			success : function(data){
				if(data){
					if(data.formId != "" && data.id != ""){
						var src = "";
						if(data.formType == "2"){
							src = "${ctx}/formServeUserRuleController/ruletablecolindex?formId="+data.formId+"&serviceId="+data.id;
						}else{
							src = ""
						}
						openFormRule(src);
					}
				}
			}
		})
	 }
	
}

//打开表单授权窗口
function openFormRule(src){
	window.parent.$('#iframe_formrule').attr('src', src);
	window.parent.$('#dialog_formrule').dialog({    
	    title: '表单授权',
	    width: 800,
	    height: 430,
	    cache: false,
	    closed : false,
	    onResize:function(){
           window.parent.$(this).dialog('center');
        }
	});
}

// 打开业务表单选择页面
function selectForm(index){
	var src = '${ctx}/bizSolMgr/toFormSelectPage?index='+index;
	window.parent.$('#iframe').attr('src', src);
	window.parent.$('#dialog').dialog({    
	    title: '业务表单',
	    width: 800,
	    height: 430,
	    cache: false,
	    closed : false,
	    onResize:function(){
           window.parent.$(this).dialog('center');
        }
	});
}
//清空所选表单
function removeForm(index){
	var row = $('#formList').datagrid('getData').rows[index];
	row.formId_ = '';
	row.formName_ = '';
	row.formKey_ = '';
	updateRow(index, row);
}

/**
 * 更新行数据
 * @param index 行索引
 * @param data   数据
 */
 function updateRow(index, row){
	var num = parseInt(index);
	$('#formList').datagrid('updateRow',{
		index : num,
		row: row
	});
	$('#formList').datagrid('refreshRow',num);
}

/**
 * 操作单元格图标点击事件
 * @param index 所点击的图标所在行索引
 * @param action 动作标识 detial： 打开明细弹窗 update:打开修改弹窗 
 * 				 	   delete：执行删除操作
 */
function imgClick(index, action){
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if(action == 'bdsq'){
		detail(index);
	}else if(action == 'szbd'){
		selectForm(index);
	}else if(action == 'bdqk'){
		removeForm(index);
	}else if(action == 'configure'){
		configureForm(index);
	}
}

function formatterOpert(val, row, index){
	if(row.scope_=='5'){
		return '<table border="0" width="100%"><tr>'
		+'<td style="width:70px"></td>'
		+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/bizsolmgr/css/images/form.png" title="设置属性" onclick="imgClick(\''+index+'\',\'configure\')"/></td>'
		+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/bizsolmgr/css/images/icon-grant.png"  title="表单授权" onclick="imgClick(\''+index+'\',\'bdsq\')"/></td>'
		+'<td><img style="cursor:pointer" src="${ctx}/views/cap//bpm/bizsolmgr/img/detail.png" title="设置表单" onclick="imgClick(\''+index+'\',\'szbd\')"/></td>'
		+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/bizsolmgr/css/images/clear.png" title="表单清空" onclick="imgClick(\''+index+'\',\'bdqk\')"/></td>'
		+'</tr></table>';
	}else{
		return '<table border="0" width="100%"><tr>'
		+'<td style="width:70px"></td>'
		+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/bizsolmgr/css/images/icon-grant.png"  title="表单授权" onclick="imgClick(\''+index+'\',\'bdsq\')"/></td>'
		+'<td><img style="cursor:pointer" src="${ctx}/views/cap//bpm/bizsolmgr/img/detail.png" title="设置表单" onclick="imgClick(\''+index+'\',\'szbd\')"/></td>'
		+'<td><img style="cursor:pointer" src="${ctx}/views/cap/bpm/bizsolmgr/css/images/clear.png" title="表单清空" onclick="imgClick(\''+index+'\',\'bdqk\')"/></td>'
		+'</tr></table>';
	}	
}
//打开选择是否正文、关联文档、是否档案信息页面
function configureForm(index){
	var row = $('#formList').datagrid('getData').rows[index];
	if(row.id!=null&&row.id!=''){
		var src = '${ctx}/bizSolMgr/toConfigurePage?id='+row.id;
		window.parent.$('#iframe').attr('src', src);
		window.parent.$('#dialog').dialog({    
		    title: '业务表单',
		    width: 500,
		    height: 200,
		    cache: false,
		    closed : false,
		    onResize:function(){
	           window.parent.$(this).dialog('center');
	        }
		});
	}else{
		window.parent.$.messager.alert("提示", "请先设置表单！", "info");
	}	
}
</script>
</html>