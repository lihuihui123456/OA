/**
 * 操作单元格图标点击事件
 * @param index 所点击的图标所在行索引
 * @param action 动作标识 detial： 打开明细弹窗 update:打开修改弹窗 
 * 				 	   delete：执行删除操作
 */
function imgClick(index, action){
	$('#bizTrustInfoList').datagrid('clearSelections'); //清空选中的行
	$('#bizTrustInfoList').datagrid('selectRow', index); //根据行索引选中一行
	window.event.cancelBubble = true;  //阻止冒泡事件 （行点击事件）
	if(action == 'detial'){
		detail();
	}else if(action == 'update'){
		update();
	}else if(action == 'delete'){
		delele();
	}
}

/**
 * 打开明细弹窗
 */
function detail(){
	var data = $('#bizTrustInfoList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('提示', '请选择单行记录查看！', 'info');
			return;
		}
		var id = data[0].id;
		var src = 'bizSolMgr/viewBizTrustInfo?id='+id;
		$('#trustFrame').attr('src', src);
		$('#trustInfoDlg').dialog({    
		    title: '委托配置明细',
		    width: 780,
		    height: 410,
		    cache: false,
		    onResize:function(){
               $(this).dialog('center');
            }
		}); 
		$('#trustInfoDlg').dialog('open');
	}
}
/**
 * 打开委托配置基本信息弹出框
 * @param mode 新增方式  new：新建  copy：复制新增
 */
function add(){
	var src = 'bizSolMgr/addTrust?actId='+actId+'&procDefId='+procDefId;
	$('#trustFrame').attr('src', src);
	$('#trustInfoDlg').dialog({    
	    title: '新增委托',
	    width:780,
	    height: 410,
	    cache: false,
	    closed : false,
	    onResize:function(){
            $(this).dialog('center');
        }
	});
}
/**
 * 批量删除选中的流程定义基本信息
 */
function delele(){
	var datas = $('#bizTrustInfoList').datagrid('getSelections');
	if (datas == null || datas.length == 0) {
		$.messager.alert('提示', '请选择要删除的记录！', 'info');
		return;
	}
	$.messager.confirm('提示', '确定删除吗?', function(r) {
		if (r) {
			var ids = [];
			$(datas).each(function(index) {
				ids[index] = datas[index].id;
			});
			$.ajax({
				url : 'bizSolMgr/doDeleteBizTrustInfosByIds',
				dataType : 'text',
				data : {
					'ids' : ids
				},
				success : function(data){
					if( data == 'Y' ){
						$.messager.show({
							title : '提示',
							msg : '删除成功！',
							timeout : 2000
						});
						reloadTableDatas();
					}else{
						$.messager.show({
							title : '提示',
							msg : '删除失败！',
							timeout : 2000
						});
					}
				}
			});
		}
	});
}

/**
 * 打开流程定义基本信息修改弹窗
 */
function update(){
	var data = $('#bizTrustInfoList').datagrid('getChecked');
	if (data) {
		if (data.length != 1) {
			$.messager.alert('提示', '请选择单行记录修改！','info');
			return;
		}
		var id = data[0].id;
		var src = 'bizSolMgr/updateBizTrust?id='+id;
		$('#trustFrame').attr('src', src);
		$('#trustInfoDlg').window({    
		    title: '编辑委托信息',
		    width: 780,
		    height: 410,
		    cache: false,
		    closed : false,
		    onResize:function(){
               $(this).dialog('center');
            }
		}); 
	}
}
/**
 * 关闭弹出的dialog
 */
function closeDlg(){
	$('#trustInfoDlg').dialog('close');
}
/**
 * 加载流程定义列表
 */
function InitTableData() {
	$('#bizTrustInfoList').datagrid({
		url : 'bizSolMgr/findBizTrustListByactId',
		queryParams: {
			'actId': actId
		}
	});
}
/**
 * 重新加载流程定义列表数据
 */
function reloadTableDatas() {
	$('#bizTrustInfoList').datagrid('reload', {
		'actId': actId
	});
	$('#bizTrustInfoList').datagrid('clearSelections'); //清空选中的行
}
function formatterOpert (val, row, index){
	return '<table border="0" width="70%"><tr>'
			+'<td><img style="cursor:pointer" src="views/cap//bpm/bizsolmgr/img/detail.png"  title="明细" onclick="imgClick(\''+index+'\',\'detial\')"/></td>'
			+'<td><img style="cursor:pointer" src="views/cap//bpm/bizsolmgr/img/edit.png" title="编辑" onclick="imgClick(\''+index+'\',\'update\')"/></td>'
			+'<td><img style="cursor:pointer" src="views/cap//bpm/bizsolmgr/img/remove.png" title="删除" onclick="imgClick(\''+index+'\',\'delete\')"/></td>'
			+'</tr></table>';
}
function formatterTime(val, row){
	if(val!=null&&val!=''){
		return val.substring(0,10);
	}
}