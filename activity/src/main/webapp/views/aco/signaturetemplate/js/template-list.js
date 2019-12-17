var selectionIds = [];
var reocrdId='';
var action='';
var ids ='';
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
		url : 'signatureTemplate/findTemplateList',
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
				title : $("#input-word").val()=="请输入签章名称查询"?"":$("#input-word").val(),
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
		columns : [ {
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
			title : '签章名称',	
			align : 'left',
			halign: 'left',
			valign: 'middle',
			sortable: true,
			width : '35%'
		}, {
			field : 'type_',
			title : '签章类型',
			align : 'center',
			cellStyle : cellStyle,
			valign: 'middle',
			sortable: true,
			valign: 'middle',
			formatter:function(value,row){
				if (value == "0"){
					return '公章';
				}else if (value == "1"){
					return '个人章';
				}else{
					return value;
				}
			}
		}, {
			field : 'remark_',
			title : '签章说明',
			align : 'left',
			valign: 'middle',
			sortable: true,
			width : '30%'
		}, {
			field : 'paw_',
			title : '签章密码',
			align : 'center',
			visible : false
		},{
			field : 'recordId_',
			title : '文档id',
			align : 'center',
			visible : false
		}, {
			 field: 'operate',
             title: '操作',
             halign: 'center',
             align:'center',
             width : '10%',
             events: operateEvents,
             formatter: operateFormatter
		}],
		onClickRow : function(row, tr){
			var paw=row.paw_;
			reocrdId=row.recordId_;
			action='edit';
			VerifyPaw(paw);
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
	if (title == '请输入签章名称查询'||title == "") {
		title = "";
	}
	$("#tb_departments").bootstrapTable('refresh',{
		url : "signatureTemplate/findTemplateList",
		query:{
			title : title
		}
	});
}
window.operateEvents = {
	    'click .editSubject': function (e, value, row, index) {
	    		stopPropagation(); 
	    		var paw=row.paw_;
	    		ids=row.id_;
				action='delete';
				VerifyPaw(paw);			
	    },
    'click .fordetails': function (e, value, row, index) {
    	stopPropagation();
    	var reocrdId=row.recordId_;
		var type=row.type_;
    	if(type==".doc"){
			 options={
						"text":"修改模板",
						"id":"template_update_"+reocrdId,
						"href":"signatureTemplate/templateDocumentEdit?encryption=1&&recordId="+reocrdId,
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
            '<a class="editSubject" href="javascript:void(0)" title="删除">',
            '<i class="fa fa-remove"></i>',
            '</a>  '        
    ].join('');
}

function VerifyPaw(paw){
	$("#password").val('');
	$("#paw").val(paw);
	$('#mm').modal('show');
}

function submitForm(){
	var paw=$("#paw").val();
	var password=$("#password").val();
	if(password==null||password==''){
		layerAlert("请输入签章密码！");
		return;
	}else{
		if(password!=paw){
			$("#password").val('');
			layerAlert("输入密码不正确！");
			return;
		}else{
			$('#mm').modal('hide');
			if(action=='edit'){
				editTemplate();
			}else{
				deleteTemplate();
			}
			
		}
	}
}
function editTemplate(){
	options={
			"text":"修改模板",
			"id":"template_update_"+reocrdId,
			"href":"signatureTemplate/templateDocumentEdit?encryption=1&recordId="+reocrdId+"&date="+new Date(),
			"pid":window
	};
	window.parent.createTab(options);
}
function deleteTemplate(){
	layer.confirm('确定删除吗？', {
		btn : [ '是', '否' ]
	}, function() {
		$.ajax({
			type: "POST",
			url: "signatureTemplate/doDelTemp",
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
}