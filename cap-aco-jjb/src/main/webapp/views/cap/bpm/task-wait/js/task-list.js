$(function(){
	getdicdata();
})

/** 初始化datagrid数据 **/
function getdicdata() {
	$('#dtlist').datagrid({
		url : 'listTask',
		method : 'POST',
		idField : 'id_',
		striped : true,
		fit:true,
		fitColumns : true,
		singleSelect : false,
		rownumbers : true,
		pagination : true,
		nowrap : false,
		toolbar : '#toolbar',
		pageSize : 10,
		showFooter : true,
		columns : [ [ {
			field : 'ck',
			checkbox : true
		}, {
			field : 'id_',
			title : '任务id',
			hidden : true
		}, {
			field : 'proc_inst_id_',
			title : '流程实例id',
			hidden : true
		}, {
			field : 'aa',
			title : '操作',
			width : 8,
			align : 'center',
			formatter: function(value,row,index){
				var str="";
				str="<img src='../views/cap/bpm/task-wait/js/pic/detail.png' title='明细' onmouseover=\"this.style.cursor='hand'\" onclick=\"showdetaildialog('" + row.id_ + "','" + row.proc_inst_id_ + "')\"/>";
				str+="&nbsp;&nbsp;&nbsp;<img src='../views/cap/bpm/task-wait/js/pic/handle.png' title='办理' onmouseover=\"this.style.cursor='hand'\" onclick=\"deleteProcinst('"+row.id_+"')\"/>";
				return str;
			}
		}, {
			field : 'biz_title_',
			title : '事项',
			width : 20,
			align : 'center'
		}, {
			field : 'name_',
			title : '审批环节',
			width : 10,
			align : 'center'
		}, {
			field : 'owner_',
			title : '所属人',
			width : 10,
			align : 'center'
		}, {
			field : 'assignee_',
			title : '执行人',
			width : 10,
			align : 'center'
		}, {
			field : 'delegation_',
			title : '代理人',
			width : 10,
			align : 'center'
		}, {
			field : 'priority_',
			title : '优先级',
			width : 10,
			align : 'center',
			formatter: function(value,row,index){
				 var htmlstr = "<div class='easyui-progressbar' data-options='value:100'></div>";  
				 return htmlstr; 
			}
		}, {
			field : 'create_time_',
			title : '创建时间',
			width : 20,
			align : 'center',
			formatter: function(value,row,index){
				if(value != '' && value != null){
					return formatTimestamp(value);
				}
			}
		}, {
			field : 'due_date_',
			title : '到期时间',
			width : 20,
			align : 'center',
			formatter: function(value,row,index){
				if(value != '' && value != null){
					return formatTimestamp(value);
				}
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

/**
 * table中明细按钮
 */
function showdetaildialog(taskid,processid){
	$('#detaildialog').dialog({    
	    title: '流程任务明细',
	    href: 'toTaskDetail?taskid=' + taskid +'&&processid=' + processid,
	    fit:true,    
	    closed: false,
	    cache: false,
	    modal: true,
	    shadow:true,
	    inline:false,
	    draggable:true,
	    collapsible:true,
	    minimizable:true,
	    maximizable:true,
	    resizable:true,
	    top:0,
	    left:0
	});
}

/**
 * 查看明细按钮
 */
function taskdetail_btn(){
	var processid=getselect_proid();
	var taskid=getselect_taskid();
	if(processid!="" && processid != null){
		$('#detaildialog').dialog({    
		    title: '流程任务明细',
		    href: 'toTaskDetail?taskid=' + taskid +'&&processid=' + processid,
		    fit:true,   
		    closed: false,
		    cache: false,
		    modal: true,
		    shadow:true,
		    draggable:true,
		    collapsible:true,
		    minimizable:true,
		    maximizable:true,
		    inline:false,
		    resizable:true,
		    top:0,
		    left:0
		});
	}else{
		alert("选择一条数据");
	}
}

/**
 * 获取选中数据(流程实例id)
 */
function getselect_proid(){
	var getselect=$('#dtlist').datagrid('getSelections');
	if(getselect.length>1||getselect.length<=0){
		return;
	}else{
		return getselect[0].proc_inst_id_;
	}
}

/**
 * 获取选中数据（任务id）
 */
function getselect_taskid(){
	var getselect=$('#dtlist').datagrid('getSelections');
	if(getselect.length>1||getselect.length<=0){
		return;
	}else{
		return getselect[0].id_;
	}
}

/** 删除任务 **/
function deletetask(){
	var taskid=getselect_taskid();
	if(taskid!="" && taskid != null){
		$.ajax({
			type : "POST",
			url : 'doDeleteTask?taskid='+taskid,
			dataType : 'json',
			success : function(result) {
				if (result.result == "success") {
					alert("删除任务成功");
					$('#dtlist').datagrid('reload');
				}else{
					alert("删除任务失败");
				}
			}
		});
	}else{
		alert("选择一条数据");
	}
}

/** datagrid列表刷新 **/
function refresh(){
	$('#dtlist').datagrid('reload');
}