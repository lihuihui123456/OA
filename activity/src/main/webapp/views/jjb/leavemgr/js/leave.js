var url;
var action;
var checkId = -1;
$(document).ready(function(){
	initTable();
	$("#mt_btn_new").click(function() {
		var options = {
				"text" : "登记",
				"id": "qjgl_add",
				"href" : "leaveManager/draft",
				"pid" : window
			};
			window.parent.createTab(options);
	});

	// 修改按钮
	$("#mt_btn_edit").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行修改！");
			return flse;
		}
		var state = selectRow[0].state;
		if(state != '1'){
			layerAlert('已提交的记录不能修改！');
			return;
		}
		var id = selectRow[0].id;
		checkId = id;
		var options = {
				"text" : "修改",
				"id": "qjgl_edit_"+id,
				"href" : "leaveManager/update?bizId=" + id,
				"pid" : window
			};
			window.parent.createTab(options);
	});
	
	// 查看
	$("#mt_btn_view").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行查看！");
			return flse;
		}
		var bizId = selectRow[0].id;
		var options = {
			"text" : "查看",
			"id": "qjgl_view_"+bizId,
			"href" : "leaveManager/view?bizId=" + bizId,
			"pid" : window
		};
		window.parent.createTab(options);
	});
	// 提交
	$("#mt_btn_send").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		var falg='0';
		var ids = [];
		$(selectRow).each(function(index) {
			ids[index] = selectRow[index].id;
			if(selectRow[index].state=='0'){
				falg='1';
			}
		});
		if(falg=='1'){
			layerAlert("已提交的记录不能重复提交！");
			return flse;
		}
		layer.confirm('确定提交吗？', {
			btn : [ '是', '否' ]
		}, function() {
			$.ajax({
				url : 'leaveManager/doSendLeaveInfo',
				dataType : 'json',
				data : {
					ids : ids
				},
				success : function(data) {
					if(data != 0){
						layerAlert("提交失败");
					} else{
						layerAlert("提交成功");
					}
					$("#dtlist").bootstrapTable('refresh',{
						url : 'leaveManager/findAllLeaveInfo',
						query:{
							searchInfo : searchInfo
						}
					});
				},
				error : function(result) {
					layerAlert(result);
				}
			});
		});
	});
	// 删除按钮
	$("#mt_btn_del").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		var ids = [];
		var flag = true;
		$(selectRow).each(function(index) {
			if(selectRow[index].state!='0'){
				ids[index] = selectRow[index].id;
			}else{
				flag = false;
			}
		});
		if(flag){
			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
			}, function() {
				$.ajax({
					url : 'leaveManager/doDelLeaveInfo',
					dataType : 'json',
					data : {
						ids : ids
					},
					success : function(data) {
						if(data != 0){
							layerAlert("删除失败");
						} else{
							layerAlert("删除成功");
						}
						$("#dtlist").bootstrapTable('refresh',{
							url : 'leaveManager/findAllLeaveInfo',
							query:{
								searchInfo : searchInfo
							}
						});
					},
					error : function(result) {
						layerAlert(result);
					}
				});
			});
		}else{
			layerAlert("已提交的记录不能删除！");
		}		
	});
	// 删除按钮
	$("#mt_btn_delete").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		var ids = [];
		$(selectRow).each(function(index) {
			ids[index] = selectRow[index].id;
		});
			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
			}, function() {
				$.ajax({
					url : 'leaveManager/doDelLeaveInfo',
					dataType : 'json',
					data : {
						ids : ids
					},
					success : function(data) {
						if(data != 0){
							layerAlert("删除失败");
						} else{
							layerAlert("删除成功");
						}
						$("#dtlist").bootstrapTable('refresh',{
							url : 'leaveManager/findAllLeaveInfo',
							query:{
								searchInfo : searchInfo
							}
						});
					},
					error : function(result) {
						layerAlert(result);
					}
				});
			});	
	});
	$("#mt_btn_export").click(function() {
		var search=searchInfo;
        if(search==''){
        	search="search";
        }
		var action="leaveManager/exportLeaveInfoToExcel/"+search;
		$("#exportLeaveInfoToExcel").attr("action",action);
		$("#exportLeaveInfoToExcel").submit();
	});
	/* 按钮方法结束 */

	
	//开启表单验证引擎(修改部分参数默认属性)
	$('#ff').validationEngine({
		promptPosition:'topRight', //提示框的位置 
		autoHidePrompt:true, //是否自动隐藏提示信息 默认为false
		autoHideDelay:100000, //自动隐藏提示信息的延迟时间 (ms)
		maxErrorsPerField:false,//单个元素显示错误提示的最大数量，值设为数值。默认 false 表示不限制。
		showOneMessage:false, //是否只显示一个提示信息
		onValidationComplete:submitForm,//表单提交验证完成时的回调函数 function(form, valid){}，参数：form：表单元素 valid：验证结果（ture or false）使用此方法后，表单即使验证通过也不会进行提交，交给定义的回调函数进行操作。
	});
});

var searchInfo = '';
function initTable(){
	$('#dtlist').bootstrapTable({
		url : 'leaveManager/findAllLeaveInfo', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					rows : params.limit, // 页面大小
					page : params.offset, // 页码
					searchInfo : $("#input-word").val()=="请输入姓名查询"?"":$("#input-word").val()
				};
				return temp;
			}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		pageList : [ 10, 25, 50, 100 ], // 可供选择的每页的行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		strictSearch : false,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		singleSelect : false,
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "id", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		columns : [ {
			field : 'ck',
			checkbox : true
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			formatter : function(value, row, index) {
				return index + 1;
			}
		},{
			field : 'id',
			title : '主键',
			visible:false
		}, {
			field : 'user_name',
			title : '姓名',
			align : 'left'
		}, {
			field : 'dept_name',
			title : '所在部门',
			align : 'left'
		}, {
			field : 'post_name',
			title : '职务',
			align : 'left'
		}, {
			field : 'state',
			title : '状态',
			align : 'center',
			formatter:function(value,row){
				if (value == "1"){
					return '<span class="label label-danger">未提交</span>';
				}else if (value == "0"){
					return '<span class="label label-success">已提交</span>';
				}
			}		
		},{
			field : 'leave_type',
			title : '请假类型',
			align : 'center'
		},{
			field : 'startTime',
			title : '开始时间',
			align : 'center'
		},{
			field : 'endTime',
			title : '结束时间',
			align : 'center'
		},{
			field : 'qingjia_days',
			title : '请假天数',
			align : 'center'
		},{
			field : 'leave_capital',
			title : '出京',
			align : 'center'
		},{
			field : 'leave_country',
			title : '出境',
			align : 'center'
		},{
			field : 'sendTime',
			title : '提交时间',
			align : 'center'
		}],
		onClickRow : function(row, tr) {
			var bizId = row.id;
			var options = {
				"text" : "查看",
				"href" : "leaveManager/view?bizId=" + bizId,
				"pid" : window
			};
			window.parent.createTab(options);
		}
	});
}

function searchLeaveInfo() {
	searchInfo = $("#input-word").val();
	if(searchInfo == '请输入姓名查询'){
		searchInfo="";
	}else{
		var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
		if(searchInfo.match(reg)==null){
			layerAlert("输入内容含有非法字符！");
			return;
		}
	}
	$("#dtlist").bootstrapTable('refresh',{
		url : 'leaveManager/findAllLeaveInfo',
		query:{
			searchInfo : searchInfo
		}
	});
}

function submitForm(form, valid){
	$(this).focus();
	submitTimeout(form, valid);
}

function submitTimeout(form, valid){
	if(valid){
		$.ajax({
			type : "POST",
			url : url,
			data: form.serialize(),
			success : function(data) {
				if(data=='true'){
					$('#myModal').modal('hide');
					$("#dtlist").bootstrapTable('refresh');
					checkId = -1;
				}
				if(data=='warn'){
					layerAlert("数据格式不正确，请重新输入！");
				}
				if(data=='false'){
					layerAlert("后台异常，数据保存失败!");
				}
			}
		});
	}
}

//重置表单
function clearForm(){
	document.getElementById("ff").reset();
}

function showOrHideModal(action){
	if(action =='open'){
		$('input,select,textarea',$('form[id="ff"]')).attr('readonly',false);
		$('#btnDiv').show();
		$('#btnDiv1').hide();
	}else{
		$('input,select,textarea',$('form[id="ff"]')).attr('readonly',true);
		$(window.frames["mainFrame"].document).find("button").attr("disabled","disabled");
		$('#btnDiv').hide();
		$('#btnDiv1').show();
	}
	$('#myModal').modal({
		backdrop : 'static',
		keyboard : false
	});
}
//生成uuid
function generateUUID() { 
	var d = new Date().getTime(); 
	var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, 
	function(c) {   
		var r = (d + Math.random()*16)%16 | 0;   d = Math.floor(d/16);   
		return (c=='x' ? r : (r&0x3|0x8)).toString(16); 
	}); 
	return uuid; 
}
