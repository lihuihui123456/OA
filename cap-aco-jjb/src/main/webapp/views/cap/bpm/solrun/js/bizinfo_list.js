$(function(){
	//加载列表数据
	initDataTable();
	/*注册按钮事件*/
	//拟稿
	var count=0;
	var id;
	
	$("#btn_new").click(function() {
		id = solId +count;
		count++;
		var options = {
			"text" : "拟稿",
			"id" : id,
			"href" : "bpmRuBizInfoController/draft?solId=" + solId,
			"pid" : window.parent
		};
		
		window.parent.parent.createTab(options);
	});

	// 修改
	$("#btn_edit").click(function() {
		var selectRow = $("#bizInfoList").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行修改！");
			return;
		}
		var state = selectRow[0].state_;
		if (state != '0') {
			layerAlert('已发的记录不能修改！');
			return;
		}
		var bizId = selectRow[0].id;
		var serialNumber = selectRow[0].serialNumber_;
		var options = {
			"text" : "修改",
			"id" : "update"+bizId,
			"href" : "bpmRuBizInfoController/update?solId=" + solId + "&bizId=" + bizId + "&serialNumber=" + serialNumber,
			"pid" : window.parent
		};
		window.parent.parent.createTab(options);
	});

	// 查看
	$("#btn_view").click(function() {
		var selectRow = $("#bizInfoList").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行修改！");
			return;
		}
		var bizId = selectRow[0].id;
		var procInstId = selectRow[0].procInstId_;
		var serialNumber = selectRow[0].serialNumber_;
		var options = {
			"text" : "查看",
			"id" : "view"+bizId,
			"href" : "bpmRuBizInfoController/view?bizId=" + bizId,
			"pid" : window.parent
		};
		window.parent.parent.createTab(options);
	});

	// 删除按钮
	$("#btn_delete").click(function() {
		var selectRow = $("#bizInfoList").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return;
		}
		var bizIds = [];
		var state = '';
		var flag = true;
		$(selectRow).each(function(index) {
			state = selectRow[index].state_;
			if(state == '0'){
				bizIds[index] = selectRow[index].id;
			}else {
				flag = false;
			}
		});
		if(flag){
			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
				// 按钮
				}, function(index) {
					$.ajax({
						url : '../bpmRuBizInfoController/doDeleteBpmRuBizInfoEntitysByBizIds',
						dataType : 'text',
						data : {
							'bizIds' : bizIds
						},
						success : function(data) {
							if (data == 'Y') {
								layerAlert("删除成功！");
								$("#bizInfoList").bootstrapTable('refresh');
							} else {
								layerAlert("删除失败！");
							}
						}
					});
					layer.close(index);
				}, function() {
					return;
			});
		}else{
			layerAlert("只能删除未发的记录！");
		}
	});
	/* 按钮方法结束 */
});

var title = "";//搜索参数
function initDataTable() {
	$('#bizInfoList').bootstrapTable({
		url : 'bpmRuBizInfoController/findBpmRuBizInfoBySolId', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					rows  : params.limit, // 页面大小
					page : params.offset, // 页码
					solId : solId,
					title : title
				};
				return temp;
			},// 传递参数（*）
        sidePagination : "server", //分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		clickToSelect : true, // 是否启用点击选中行
        idField : "id",  //指定主键列
        onDblClickRow : function (row, obj) {
        	var bizId = row.id;
    		var procInstId = row.procInstId_;
    		var options = {
    			"text" : "查看",
    			"id" : "view"+bizId,
    			"href" : "bpmRuBizInfoController/view?solId=" + solId + "&bizId=" + bizId +'&procInstId=' +procInstId,
    			"pid" : window.parent
    		};
    		window.parent.parent.createTab(options);
        }
	});
}

function search() {
	title = $("#input-word").val();
	if (title == '请输入标题查询') {
		title = "";
	}else{
		var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
		if(title.match(reg)==null){
			layerAlert("输入内容含有非法字符！");
			return;
		}
	}
	$("#bizInfoList").bootstrapTable('refresh');
}

/******************格式化方法********************/
 function indexFormatter(value, row, index) {
	return index + 1;
 }
	
 function formatterTime (value, row, index) {
	return value.substr(0,19);
}

function formatterState (value, row, index) {
	if (value == "0"){
		return '<span class="label label-danger">待发</span>';
	}else if (value == "1"){
		return '<span class="label label-warning">在办</span>';
	}else if (value == "2"){
		return '<span class="label label-success">办结</span>';
	}else if(value == "4"){
		return '<span class="label label-default">挂起</span>';
	}else{
		return "--";
	}
}

function formatterUrgency (value, row, index) {
	if (value == "1"){
		return '<span class="label label-success">平件</span>';
	}else if (value == "2"){
		return '<span class="label label-warning">急件</span>';
	}else if(value == "3"){
		return '<span class="label label-danger">特急</span>';
	}else{
		return "--";
	}
}