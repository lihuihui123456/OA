$(function() {

	$('#myModal').on('hidden.bs.modal', function (e) {
		$('#myModal').find('.modal-body input').val("");
	})
	
	//加载表格
	initTable();
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
	$("#tapList").bootstrapTable('refresh');
}

function initTable() {
		$('#tapList').bootstrapTable({
			url : 'notice/searchNotice', // 请求后台的URL（*）
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
					fieldValue:title
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
			uniqueId : "id", // 每一行的唯一标识，一般为主键列
			showToggle : false, // 是否显示详细视图和列表视图的切换按钮
			cardView : false, // 是否显示详细视图
			detailView : false, // 是否显示父子表
			columns: [{
			        	  checkbox : true
			          }, 
			          {
			        	  field: 'Number',
			        	  title: '序号a',
	                      formatter: function (value, row, index) {
	                          return index+1;
	                      }
						},{ 
				        	  field: 'id', 
				        	  title: '文件id'
				          },{ 
			        	  field: 'filename', 
			        	  title: '文件标题'
			          },{
			        	  field: 'contents', 
			        	  title: '正文',
			  				/*formatter : function(value, row) {
			  					if (value == 1)
									return '<span class="label label-success">已送交</span>';
								if (value == 0)
									return '<span class="label label-danger">未送交</span>';
								return null;
			  				}*/
			          },{
			        	  field: 'lastModify', 
			        	  title: '创建时间'
			          }
			      ] ,
			      onDblClickRow : function(row, tr) {
						var pk = row.id;
						var options={
								"text":"通知公告-查看",
								"id": "fstz_view_"+pk,
								"pid":window,
								"href":"notice/findNoticeFsById?id="+pk+"&type=open",
						};
						
						window.parent.createTab(options);
					}
		});
}
