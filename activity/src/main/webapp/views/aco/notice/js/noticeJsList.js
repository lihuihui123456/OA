$(function() {
	$('#myModal').on('hidden.bs.modal', function (e) {
		$('#myModal').find('.modal-body input').val("");
	})
	
	//加载表格
	initTable();
	
	$('#input-word').bind('keypress', function (event) {
        if (event.keyCode == "13") {
        	search();
           return false ;   
        } });
	
	$('#btn_open').click(function () {
		var pk = "";
		var bid = "";
		//alert($('#tapList').bootstrapTable('getSelections'));
		var obj =$('#tapList').bootstrapTable('getSelections');
			if (obj.length>1 || obj.length == 0) {
				layerAlert("请选择一条数据");
				return false;
			}
			
			pk = obj[0].id_;
			var options={
					"text":"通知公告-查看",
					"id":"jstz_view"+pk,
					"href":"notice/findJsNoticeById?id="+pk+"&type=open",
					"pid": window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			
			window.parent.createTab(options);
			//TODO
			//minus one record in the notice-bell list
			if(window.parent.setReadNotice){
				window.parent.setReadNotice("cap-aco",pk);
			}
			
	});
	
})

var title = "";
function search(){
	/*clearForm();*/
	document.getElementById("ff").reset();
	title = $(".form-control").val();
	/*if(title == '请输入标题查询'){
		title = "";
	}
	if (title != '' && title.indexOf('%') != -1) {
		layerAlert("输入包含非法字符！");
		return;
	}*/
	$("#tapList").bootstrapTable('refresh',{
		url : "notice/findJsNoticeListBean",
		query:{
			query : $("#input-word").val()=="请输入标题查询"?"":$("#input-word").val()
		}
	});
	
}

function showOrHide(){
	var display =$('#upperSearch').css('display');
	if(display == "none") {
		$("#upperSearch").show();
	}else {
		$("#upperSearch").hide();
	}
}

function qxButton(){
	$("#upperSearch").hide();	
}

function getT(){
	var titleS = $("#input-word").val()=="请输入标题查询"?"":$("#input-word").val();
	if(titleS != ""){
		document.getElementById("ff").reset();
	}
	return titleS;
}

function initTable() {
	$('#tapList').bootstrapTable({
		url : 'notice/findJsNoticeListBean', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				query:getT(),
				"queryPams":$("#ff").serialize(),
				sortName : this.sortName,
				sortOrder : this.sortOrder
			};
			return temp;
		}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		//strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		singleSelect : true,
		uniqueId : "id_", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		columns: [ {
		        	  field: 'Number',
		        	  title: '序号',
		  			  align : 'center',
		  			  valign: 'middle',
		  			  width : '6%',
                      formatter: function (value, row, index) {
                          return index+1;
                      }
					},{ 
		        	  field: 'title', 
		        	  title: '文件标题',
		  			  align : 'left',
		  			  valign: 'middle',
		  			  width: '50%',
		  			  sortable:true,
		  			  /*events: onTdClickTab,*/
		  			  formatter: onTdClickTabFormatter
		          },{
		        	  field: 'sender', 
		        	  title: '发送人',
		  			  align : 'left',
		  			  sortable:true,
		  			  width: '8%',
		  			  valign: 'middle'
		          }, {
		        	  field: 'status', 
		        	  title: '办理状态',
		  			  align : 'center',
		  			  cellStyle : cellStyle,
		  			  sortable:true,
		  			  width: '11%',
		  			  valign: 'middle',
		  				formatter : function(value, row) {
		  					if (value == 1)
								return '<span class="label label-success">已阅读</span>';
							if (value == 0)
								return '<span class="label label-danger">未阅读</span>';
							return null;
					}},{
			        	  field: 'create_time', 
			        	  title: '发送时间',
			  			  align : 'center',
			  			  cellStyle : cellStyle,
			  			  sortable:true,
			  			  valign: 'middle',
			  			  width: '12%',
			   			formatter:function(value,row){
			 				if (value == null){
								return '-';
							}else{
								return value.substring(0,10);

							}			
					}
			        }],
			        onClickRow : function(row, tr) {
						var pk = row.id_;
						var options={
								"text":"通知公告-查看",
								"id":"jstz_view"+pk,
								"href":"notice/findJsNoticeById?id="+pk+"&type=open",
								"pid": window,
								"isDelete":true,
								"isReturn":true,
								"isRefresh":true
						};
						
						window.parent.createTab(options);
						//minus one record in the notice-bell list
						if(window.parent.setReadNotice){
							window.parent.setReadNotice("cap-aco",pk);
						}
						
					}
		});
}

/**
 * 标题格式化
 * @param value
 * @param row
 * @param index
 * @returns {String}
 */
function onTdClickTabFormatter(value, row, index){
	/**
	 * 格式化标题
	 */
	if(null != value && "" != value){
		if(value.length>40){
			return "<span class='tdClick' title='"+value+"'>"+value.substring(0,49)+"...</span>"
		}else{
			return "<span class='tdClick'>"+value+"</span>"
		}
	}else{
		return "<span class='tdClick'>-</span>"
	}
}

/*
 * table 点击标题弹出查看/办理页面
 */
window.onTdClickTab = {
	 'click .tdClick': function (e, value, row, index) {
		 var pk = row.id_;
			var options={
					"text":"通知公告-查看",
					"id":"jstz_view"+pk,
					"href":"notice/findJsNoticeById?id="+pk+"&type=open",
					"pid": window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			
			window.parent.createTab(options);
			//minus one record in the notice-bell list
			if(window.parent.setReadNotice){
				window.parent.setReadNotice("cap-aco",pk);
			}		
	 }
}

/**
 * 高级搜索模态框
 */
function upperSearch(){
	/*clearForm();*/
	$('#upperSearch').modal({
		backdrop : 'static',
		keyboard : false
	});
}

//重置高级搜索表单
function clearForm(){
	document.getElementById("ff").reset();
	$("#input-word").val("请输入标题查询");
	$("#tapList").bootstrapTable('refresh',{
		url : 'notice/findJsNoticeListBean',
		query:{
			"queryPams" : $("#ff").serialize(),
		}
	});
	$("#upperSearch").modal('hide');
}

//高级搜索
function submitForm(){
	$("#input-word").val("请输入标题查询");
	searchModel();
	$('#upperSearch').modal('hide');
}

function searchModel(){
	var startTime,endTime;
	startTime = $("#CREATE_TIME_START_").val();
	endTime = $("#CREATE_TIME_END_").val();
	if(startTime != "" && endTime != "") {
		if(endTime <= startTime) {
			layer.msg("结束时间必须大于开始时间！");
			return;
		}
	}
	$("#tapList").bootstrapTable('refresh',{
		url : 'notice/findJsNoticeListBean',
		query:{
			"queryPams":$("#ff").serialize()
		}
	});
}
