$(function(){
	getdicdata();
})
function getdicdata() {
	$('#dtlist').datagrid({
		url : 'listProcInst',
		method : 'POST',
		idField : 'id_',
		striped : true,
		fitColumns : true,
		singleSelect : true,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		fit:true,
		toolbar : '#toolbar1',
		pageSize : 10,
		showFooter : true,
		loadMsg:"please waiting",
		columns : [ [ {
			field : 'ck',
			checkbox : true
		}, {
			field : 'id_',
			title : '主键',
			hidden : true
		}, {
			field : 'aa',
			title : '操作',
			width: 10,
			align : 'center',
			formatter: function(value,row,index){
				var str="";
				str="<img src='../views/cap/bpm/procinstmgr/js/pic/detail.png' title='明细' onmouseover=\"this.style.cursor='hand'\" onclick=\"showdetaildialog('" + row.id_ + "')\"/>";
				return str;
			}
		}, {
			field : 'biz_title_',
			title : '事项',
			width: 25,
			align : 'left'
		}, {
			field : 'state_',
			title : '运行状态',
			width: 8,
			align : 'left',
			formatter: function(value,row,index){
				var str="";
				if(value=='4'){
					str="<img src='../views/cap/bpm/procinstmgr/js/pic/icon-running.png' title='挂起'/>";
				}else if(value=='1'){
					str="<img src='../views/cap/bpm/procinstmgr/js/pic/icon-bpm-draft.png' title='在办'/>";
				}else if(value=='2'){
					str="<img src='../views/cap/bpm/procinstmgr/js/pic/icon-success-end.png' title='办结'/>";
				}
				return str;
			}
		}, {
			field : 'proc_def_id_',
			title : '版本',
			width: 8,
			align : 'left',
			formatter: function(value,row,index){
				if(value!=null && value !=''){
					var val=value.split(":");
					return val[1];
				}
			}
		}, {
			field : 'create_user_name',
			title : '发起人',
			width: 10,
			align : 'left',
			formatter: function(value,row,index){
				var str="";
				str="<img src='../views/cap/bpm/procinstmgr/js/pic/male.png'/>";
				str += value;
				return str;
			}
		}, {
			field : 'start_time_',
			title : '创建时间',
			width: 15,
			align : 'left',
			formatter: function(value,row,index){
				return formatTimestamp(value);
			}
		}, {
			field : 'end_time_',
			title : '结束时间',
			width: 15,
			align : 'left',
			formatter: function(value,row,index){
				return formatTimestamp(value);
			}
		} ] ],
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

/** 流程实例明细查看 **/
function showdetaildialog(procinst){
	$('#detaildialog').dialog({    
	    title: '流程实例明细',
	    href: 'toProcInstDetail?procinstid=' + procinst,
	    width: 800,    
	    height: 500,    
	    closed: false,
	    cache: false,
	    modal: true,
	    shadow:true,
	    fit:true,
	    draggable:true,
	    collapsible:true,
	    minimizable:true,
	    maximizable:true,
	    resizable:true,
	    left:0,
	    top:0
	});
}

/** 流程示例明细按钮点击事件 **/
function showdetaildialog_btn(){
	var procinstid=getselect('detail');
	if(procinstid!="" && procinstid != null){
		$('#detaildialog').dialog({    
		    title: '流程实例明细',
		    href: 'toProcInstDetail?procinstid=' + procinstid,
		    width: 800,    
		    height: 500,    
		    closed: false,
		    cache: false,
		    modal: true,
		    shadow:true,
		    fit:true,
		    draggable:true,
		    collapsible:true,
		    minimizable:true,
		    maximizable:true,
		    resizable:true,
		    left:0,
		    top:0
		});
	}
}

/**
 * 删除流程实例
 */
function deleteProcinst(){
	var procinstid=getselect('btn_del');
	if(procinstid!="" && procinstid != null){
	$.messager.confirm('提示', '确定删除吗?', function(r)  {
		if (r){
			//删除当前选择的数据
			$.ajax({
				type : "POST",
				url : 'doDeleteProcInst?processid='+procinstid,
				dataType : 'json',
				success : function(result) {
					if (result.result == "success") {
						$.messager.alert('提示', '删除成功!');
						$('#dtlist').datagrid('clearSelections'); 
						$('#dtlist').datagrid('reload');
					}else{
						$.messager.alert('提示', '操作失败!');
					}
				}
			});
		}	
	});
}
}
/**
 * 删除流程实例 button事件
 */
function deleteProcinst_btn(){
	var procinstid=getselect('btn_del');
	if(procinstid!="" && procinstid != null){
		$.messager.confirm('提示', '确定结束实例吗?', function(r)  {
			if (r){
				//删除当前选择的数据
				$.ajax({
					type : "POST",
					url : 'doDeleteProcInst?processid='+procinstid,
					dataType : 'json',
					success : function(result) {
						if (result.result == "success") {
							$.messager.alert('提示', '结束实例成功!');
							$('#dtlist').datagrid('clearSelections');   
							$('#dtlist').datagrid('reload');
						}else{
							$.messager.alert('提示', '结束实例失败!');
						}
					}
				});
			}		
		});
	}
}

/**
 * 获取选中数据
 */
function getselect(btnId){
	var getselect=$('#dtlist').datagrid('getSelections');
	
	if(getselect.length!=1){
		//$.messager.alert('提示', '选择一条数据!');
		layer.tips('选择一条数据', '#'+btnId, { tips: 3 });
		return;
	}else{
		return getselect[0].id_;
	}
}

/**
 * 流程挂起
 */
function suspendprocess(){
	var procinstid=getselect('btn_suspend');
	if(procinstid!="" && procinstid != null){
		$.ajax({
			type : "POST",
			url : 'doSuspendProcInst?processid='+procinstid,
			dataType : 'json',
			success : function(result) {
				if (result.result == "success") {
					$.messager.alert('提示', '流程挂起成功!');
					$('#dtlist').datagrid('reload');
				}else{
					$.messager.alert('提示', '流程挂起失败!');
				}
			}
		});
	}
}

/**
 * 流程激活
 */
function activeProcinst(){
	var procinstid=getselect('btn_active');
	if(procinstid!="" && procinstid != null){
		$.ajax({
			type : "POST",
			url : 'doActiveProcinst?processid='+procinstid,
			dataType : 'json',
			success : function(result) {
				if (result.result == "success") {
					$.messager.alert('提示', '流程激活成功!');
					$('#dtlist').datagrid('reload');
				}else{
					$.messager.alert('提示', '流程激活失败!');
				}
			}
		});
	}
}
