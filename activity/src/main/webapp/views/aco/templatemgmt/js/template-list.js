var selectionIds = [];
$(document).ready(function() {
	/**
	 * 选中事件操作数组  
	 */
	 var union = function(array,ids){  
	     $.each(ids, function (i, id_) {  
	         if($.inArray(id_,array)==-1){  
	             array[array.length] = id_;  
	         }  
	     });  
	      return array;  
	};
		/**
	  * 取消选中事件操作数组 
	  */ 
	 var difference = function(array,ids){  
	         $.each(ids, function (i, id_) {  
	              var index = $.inArray(id_,array);  
	              if(index!=-1){  
	                  array.splice(index, 1);  
	              }  
	          });  
	         return array;  
	 };    
	 var _ = {"union":union,"difference":difference};
	 /**
		 * bootstrap-table 记忆选中 
		 */
		$('#tb_departments').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
				var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
	         return row.id_;  
	     });  
	     func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	     selectionIds = _[func](selectionIds, ids);   
		});  
	$('#tb_departments').bootstrapTable({
		url : 'templateMgmt/findTemplateList',
		method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		sortable : true,
		sortOrder : "desc",
		queryParams : function(params) {
			var temp = {
				rows : params.limit,
				page : params.offset,
				title : $("#input-word").val()=="请输入模板名称查询"?"":$("#input-word").val(),
				sortName : this.sortName,
				sortOrder : this.sortOrder
			};
			return temp;
		},
		sidePagination : "server",
		pageNumber : 1,
		pageSize : 10,
		pageList : [ 10, 25, 50, 100 ],
		search : false,
		strictSearch : false,
		showColumns : false,
		showRefresh : false,
		minimumCountColumns : 2,
		clickToSelect : true,
		uniqueId : "id_",
		showToggle : false,
		cardView : false,
		detailView : false,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.id_, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [{
			checkbox : true,
			align : 'center',
			valign: 'middle',
			field: 'checkStatus'
		}, {
			field : 'id_',
			title : 'id_',
			visible : false
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			valign: 'middle',
			width : '7%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'name_',
			title : '模板名称',	
			align : 'left',
			halign: 'left',
			valign: 'middle',
			sortable: true,
			width : '35%'
		}, {
			field : 'type_',
			title : '模板类型',
			align : 'center',
			cellStyle : cellStyle,
			valign: 'middle',
			sortable: true,
			valign: 'middle'
		}, {
			field : 'remark_',
			title : '说明',
			align : 'left',
			valign: 'middle',
			sortable: true,
			width : '30%'
		}, {
			field : 'recordId_',
			title : '文档id',
			align : 'center',
			visible : false
		}],
		onClickRow : function(row, tr){
			var reocrdId=row.recordId_;
			var type=row.type_;
			if(type==".doc"){
				options={
						"text":"修改模板",
						"id":"template_update_"+reocrdId,
						"href":"templateMgmt/templateDocumentEdit?encryption=1&&recordId="+reocrdId,
						"pid":window
				};
				window.parent.createTab(options);
			}else{
				layerAlert("请选择套红模板！");
			}
		}
	});
	
	$('#input-word').bind('keypress', function (event) {
	    if (event.keyCode == "13") {
	    	search();
	       return false ;   
	    } }); 
});

function search() {
	title = $("#input-word").val();
	if (title == '请输入模板名称查询'||title == "") {
		title = "";
	}
	$("#tb_departments").bootstrapTable('refresh',{
		url : "templateMgmt/findTemplateList",
		query:{
			title : title
		}
	});
}
window.operateEvents = {
	    'click .editSubject': function (e, value, row, index) {
	    		stopPropagation();
	    		var ids = row.id_; 
	    		layer.confirm('确定删除吗？', {
	    			btn : [ '是', '否' ]
	    		}, function() {
	    			$.ajax({
	    				type: "POST",
	    				url: "templateMgmt/doDelTemp",
	    				data: {ids:ids},
	    				success: function (data) {
	    					$('#tb_departments').bootstrapTable('refresh');
	    					layerAlert("删除模板成功！");
	    				},
	    				error: function(data) {
	    					alert("error:"+data.responseText);
	    				}
	    			});
	    		});
			
	    },
    'click .fordetails': function (e, value, row, index) {
    	stopPropagation();
    	var reocrdId=row.recordId_;
		var type=row.type_;
    	if(type==".doc"){
			 options={
						"text":"修改模板",
						"id":"template_update_"+reocrdId,
						"href":"templateMgmt/templateDocumentEdit?encryption=1&&recordId="+reocrdId,
						"pid":window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true
				};
				window.parent.createTab(options); 
		 }else{
				layerAlert("请选择套红模板！");
			}
    }
};

function operateFormatter(value, row, index) {
    return [
			'<a class="fordetails" href="javascript:void(0)" title="修改">',
			'<i class="fa fa-pencil"></i>',
			'</a>   ',
            '<a class="editSubject" href="javascript:void(0)" title="删除">',
            '<i class="fa fa-remove"></i>',
            '</a>  '        
    ].join('');
}