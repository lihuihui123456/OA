$(function() {

	$('#myModal').on('hidden.bs.modal', function (e) {
		$('#myModal').find('.modal-body input').val("");
	})
	
	//加载表格
	initTable();
	
	$('#btn_open').click(function () {
		var pk = "";
		var bid = "";
		//alert($('#tapList').bootstrapTable('getSelections'));
		var obj =$('#tapList').bootstrapTable('getSelections');
			if (obj.length>1 || obj.length == 0) {
				layerAlert("请选择一条数据");
				return false;
			}
			
			pk = obj[0].id;
			bid = obj[0].bid;
			var options={
					"text":"文件传阅-查看",
					"id":"wjjs_view_"+pk,
					"href":"circularize/queryBasicById_js?id="+pk+"&type=open&bid="+bid,
					"pid": window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			
			window.parent.createTab(options);
	});
	
})

var title = "";
function search(){
	title = $(".form-control").val();
	if(title == '请输入标题查询'){
		title = "";
	}
	if (title != '' && title.indexOf('%') != -1) {
		layerAlert("输入包含非法字符！");
		return;
	}
	$("#tapList").bootstrapTable('refresh',{
		url : 'circularize/getAllBasicinfoJs',
		query:{
			query:title
		}
	});
}

function initTable() {
	$('#tapList').bootstrapTable({
		url : 'circularize/getAllBasicinfoJs', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				query:$("#input-word").val()=="请输入标题查询"?"":$("#input-word").val()
			};
			return temp;
		}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		pageList : [ 10, 25, 50, 100 ], // 可供选择的每页的行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		//strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		singleSelect : true,
		uniqueId : "id", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		columns: [{
		        	  checkbox : true
		          }, {
		        	  field: 'Number',
		        	  title: '序号',
		        	  valign: 'middle',
		        	  width:'5%',
                      formatter: function (value, row, index) {
                          return index+1;
                      }
					},{ 
		        	  field: 'title', 
		        	  title: '文件标题',
		        	  valign: 'middle',
		        	  width:'50%'
		          }, {
		        	  field: 'priority', 
		        	  title: '紧急程度',
		        	  valign: 'middle',
		        	  formatter : function(value, row) {
							if (value == '普通')
								return '<span class="label label-success">普通</span>';
							if (value == '急件')
								return '<span class="label label-warning">急件</span>';
							if (value == '特急')
								return '<span class="label label-danger">特急</span>';
							return null;
		  			 }
		          }, {
		        	  field: 'status', 
		        	  title: '办理状态',
		        	  valign: 'middle',
		  				formatter : function(value, row) {
		  					if (value == 1)
								return '<span class="label label-success">已阅读</span>';
							if (value == 0)
								return '<span class="label label-danger">未阅读</span>';
							return null;
					}},{
			        	  field: 'creation_time', 
			        	  title: '创建时间',
			        	  valign: 'middle',
			        	  formatter : function(value, row) {
			        		  var date = new Date();
			        		  date.setTime(value);
			        		  var year=date.getFullYear();
			        		  var month=date.getMonth() + 1;
			        		  var day=date.getDate();
			        		  var hour=date.getHours();
			        		  var minutes=date.getMinutes();
			        		  var seconds=date.getSeconds();
			        		  if(month<10){
			        			  month='0'+month;  
			        		  }if(day<10){
			        			  day='0'+day;  
			        		  }if(hour<10){
			        			  hour='0'+hour;  
			        		  }
			        		  if(minutes<10){
			        			  minutes='0'+minutes;  
			        		  }
			        		  if(seconds<10){
			        			  seconds='0'+seconds;  
			        		  }
/*			        		  return  year + "-" + month + "-" +day + " " + hour + ":" + minutes + ":" + seconds;
*/									        		  return  year + "-" + month + "-" +day;

			        		  }
					}] ,
					onClickRow : function(row, tr) {
						var pk = row.id;
						var bid = '';
						var options={
								"text":"文件传阅-查看",
								"id":"wjjs_view_"+pk,
								"href":"circularize/queryBasicById_js?id="+pk+"&type=open&bid="+bid,
								"pid": window
						};
						
						window.parent.createTab(options);
					}
		});
}


