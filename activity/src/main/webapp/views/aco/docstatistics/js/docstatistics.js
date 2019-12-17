var DEPT_ID,DEPT_NAME;
function initTable(){
	$('#tableList').bootstrapTable({
		url:ctx+"/docStatistics/query",
		method : 'get', // 请求方式（*）
		/*toolbar : '#toolBar', // 工具按钮用哪个容器
 */		striped : true, // 是否显示行间隔色
		 cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		 pagination : false, // 是否显示分页（*）
		 sortable : true, // 是否启用排序
		 sortOrder : "asc", // 排序方式
		 queryParams : function(params) {
			 var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
			 	parentDeptId : DEPT_ID,
				pageSize  : params.limit, // 页面大小
				pageNum : params.offset,
				deptName:DEPT_NAME,
			};
			return temp;
			 
		 }, // 传递参数（*）
		 sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		 pageNumber : 1, // 初始化加载第一页，默认第一页
		 pageSize : 10, // 每页的记录行数（*）
		 search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		 /* strictSearch : true,
		searchOnEnterKey:true, */
		 showColumns : false, // 是否显示所有的列
		 showRefresh : false, // 是否显示刷新按钮
		 showFooter:true,
		 minimumCountColumns : 2, // 最少允许的列数
		 clickToSelect : false, // 是否启用点击选中行
		 uniqueId : "deptId", // 每一行的唯一标识，一般为主键列
		 showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		 cardView : false, // 是否显示详细视图
		 detailView : false, // 是否显示父子表
		 columns : [ [ {
			 field : 'deptName',
			 title : '名称',
			 //width:'20%',
			 align:'center',
			 footerFormatter: function (row) {
			        return "<span style='font-weight:bolder;'>合计</span>";
		    }
		 },{
			 field : 'weekDraftDocAmount',
			 title : '本周-行文数',
			 align:'left',
//			 width:'13%',
			 footerFormatter: function (row) {
		        var count = 0;
		        for (var i in row) {
		        	if(row[i].weekDraftDocAmount==undefined){
		        		continue;
		        	}
	        		count += parseInt(row[i].weekDraftDocAmount);
		        }
		        return formatBolder(count);
		    }
		 },{
			 field : 'weekcommDocAmount',
			 title : '本周-流转环节数',
			 align:'left',
//			 width:'13%',
			 footerFormatter: function (row) {
			        var count = 0;
			        for (var i in row) {
			        	if(row[i].weekcommDocAmount==undefined){
			        		continue;
			        	}
		        		count += parseInt(row[i].weekcommDocAmount);
			        }
			        return formatBolder(count);
			    }
		 },{
			 field : 'monthDraftDocAmount',
			 title : '本月-行文数',
			 align:'left',
//			 width:'13%',
			 footerFormatter: function (row) {
			        var count = 0;
			        for (var i in row) {
			        	if(row[i].monthDraftDocAmount==undefined){
			        		continue;
			        	}
			            count += parseInt(row[i].monthDraftDocAmount);
			        }
			        return formatBolder(count);
			    }
		 },{
			 field : 'monthcommDocAmount',
			 title : '本月-流转环节数',
			 align:'left',
//			 width:'13%',
			 footerFormatter: function (row) {
			        var count = 0;
			        for (var i in row) {
			        	if(row[i].monthcommDocAmount==undefined){
			        		continue;
			        	}
			            count += parseInt(row[i].monthcommDocAmount);
			        }
			        return formatBolder(count);
			    }
		 },{
			 field : 'draftDocAmount',
			 title : '总行文数',
			 align:'left',
//			 width:'13%',
			 footerFormatter: function (row) {
			        var count = 0;
			        for (var i in row) {
			        	if(row[i].draftDocAmount==undefined){
			        		continue;
			        	}
			            count += parseInt(row[i].draftDocAmount);
			        }
			        return formatBolder(count);
			    }
		 },{
			 field : 'commDocAmount',
			 title : '总流转环节数',
			 align:'left',
//			 width:'13%',
			 footerFormatter: function (row) {
			        var count = 0;
			        for (var i in row) {
			        	if(row[i].commDocAmount==undefined){
			        		continue;
			        	}
			            count += parseInt(row[i].commDocAmount);
			        }
			        return formatBolder(count);
			    }
		 }] ],onClickRow:function(row,obj){
			 clickEnter(row);
		 }
		 
	});
}
function clickEnter(row){
	$.ajax({
		type: "POST",
		async: false,
		url: "docStatistics/isHasChildDept",
		data: {deptId:row.deptId},
		success: function (data) {
			if(data=="true"){
				 DEPT_ID=row.deptId;
				 $("#tableList").bootstrapTable('refresh');
			}else{
				layerAlert("已到达最下级！");
			}
			
		}
	});
	
}
$(document).ready(function(){
	$("#backButton").click(function(){
		$.ajax({
			type: "POST",
			async: false,
			url: "docStatistics/getParentDeptId",
			data: {deptId:DEPT_ID},
			success: function (parentDeptId) {
				if(parentDeptId!=""&&parentDeptId!=null){
					DEPT_ID=parentDeptId;
					$("#tableList").bootstrapTable('refresh');
				}else{
					layerAlert("已到达最上级！");
				}
				
			}
		});
		
	});
	$('#input-word').keydown(function(e){
		if(e.keyCode==13){
			search();
		}
	});
});
function formatBolder(val){
	return "<span style='font-weight:bolder'>"+val+"</span>";
}
function search(){
	DEPT_NAME=$("#input-word").val();
	if(DEPT_NAME=='请输入单位或部门名称查询'){
		DEPT_NAME='';
	}
	$("#tableList").bootstrapTable('refresh');
}