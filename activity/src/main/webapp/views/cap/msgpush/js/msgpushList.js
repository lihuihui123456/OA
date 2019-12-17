$(function() {
	//加载表格
	initTable();
});

function initTable() {
	
	var connection = parent.globalMsgPushConnection;
	var table = $('#msgTableList').bootstrapTable({
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortName: 'sendtime',
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		//sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		//pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		//strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 1, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		singleSelect : true,
		//uniqueId : "id", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		columns: [/*{
			      	  field: 'systemcode',
			    	  title: '系统',
					  align : 'center',
					  valign: 'middle'

					},
					{
			      	  field: 'systemnoticeID',
			    	  title: '系统id',
					  align : 'center',
					  valign: 'middle'
					},*/
		          {
		        	  field: 'Number',
		        	  title: '序号',
		  			  align : 'center',
		  			  valign: 'middle',
                      formatter: function (value, row, index) {
                          return index+1;
                      }
					},
					{
			      	  field: 'noticefrom',
			    	  title: '发送者标识',
					  align : 'center',
					  valign: 'middle'
					},
					{
			      	  field: 'content',
			    	  title: '标题',
					  align : 'center',
					  valign: 'middle',
					  formatter : function(val, row) {
						  //ie 8 不识别 content.title
							return row.content.title;
						}
					},
					{
				      	  field: 'sendtime',
				    	  title: '发送时间',
						  align : 'center',
						  sortable : true,
						  valign: 'middle',
						  formatter : function(val, row) {
								//格式化时间，截取年月日
								return row.sendtime.substring(0,19);
							}
					},
					{
				      	  field: 'read',
				    	  title: '查阅状态',
						  align : 'center',
						  valign: 'middle',
			  				formatter : function(value, row) {
			  					if (value == "Y")
									return '<span class="label label-success">已阅读</span>';
								if (value == "N")
									return '<span class="label label-danger">未阅读</span>';
								return null;
						}
					}					
		          ],
		          
    		onDblClickRow : function(row, tr) {
    			//tableDBClick(row, tr);
    		},
	});
	//pushMsgListTable = table;
	pushMsgListTable = $('#msgTableList');
	connection._getNoticesList('','');
	
	function tableDBClick(row, tr){
		//jquery object can be used directly
		//get the "isRead" cell
    	//$("#msgTableList").bootstrapTable("checkBy", {field:"msgId", values:[row.msgId]});
		var selectedIsRead = $(tr).find("td span.label").get(0);
		//remove the bold style
		var tds = $(tr).find("td span");
		$(tds).each(function(index) {
			$(tds[index]).removeClass("unRead_bold");
		});
		//change "unRead" to "read"
		if($(selectedIsRead).text()=="未阅读"){
			$(selectedIsRead).text("已阅读");
			$(selectedIsRead).attr("class","label label-success");
			//reduce the number of unread
			operateTotalNum(1,1,"unread_mail_count");
		}
		//set the row selected
/*		$(tr).addClass("selected");
		$(tr).find("input[type='checkbox']").attr("checked",true);*/
	}
	

}