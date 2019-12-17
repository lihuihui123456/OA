var selectionIds = [];
$(function() {

	$('#input-word').bind('keypress', function (event) {
        if (event.keyCode == "13") {
        	search();
           return false ;   
        } });
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
		$('#tapList').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
	var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
	            return row.id_;  
	        });  
	        func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	        selectionIds = _[func](selectionIds, ids);   
	});  
	
	$('#myModal').on('hidden.bs.modal', function (e) {
		$('#myModal').find('.modal-body input').val("");
	})
	
	//加载表格
	initTable();
	//注册按钮事件
	$('#btn_add').click(function (){
		var options={
				"text":"通知公告-拟稿",
				"id": "fstz_add",
				"href":"notice/addToListFSNotice",
			    "pid":window
		};
		window.parent.createTab(options);
	});

	
	$('#btn_open').click(function () {
		//alert($('#tapList').bootstrapTable('getSelections'));
		var obj =$('#tapList').bootstrapTable('getSelections');
			if (obj.length>1 || obj.length == 0) {
				layerAlert("请选择一条数据");
				return false;
			}
			
			var pk = obj[0].id_;
			var options={
					"text":"通知公告-查看",
					"id": "fstz_view_"+pk,
					"pid":window,
					"isDelete":true,
	    			"isReturn":true,
	    			"isRefresh":true,
					"href":"notice/editFindNoticeFsById?id="+pk+"&type=open",
			};
			
			window.parent.createTab(options);
	});
	
	$('#btn_edit').click(function () {
		var obj =$('#tapList').bootstrapTable('getSelections');
			if (obj.length>1 || obj.length == 0) {
				layerAlert("请选择一条数据");
				return false;
			}
			
			if(obj[0].status == '1'){
				layerAlert("数据已经送交，不可修改！");
				return false;
			}
			
			var pk = obj[0].id_;
			var options={
					"text":"通知公告-修改",
					"id": "fstz_edit_"+pk,
					"href":"notice/editFindNoticeFsById?id="+pk+"&type=edit",
				    "pid":window
			};
			window.parent.createTab(options);
	});
	
	$('#to_save').click(function () {
		var id = $('#id').val();
		var AjaxURL= "";
		if(id != null && id != ""){
			AjaxURL= "tabssave";  
		}else{
			AjaxURL= "tabsinsert";    
		}
		
		$.ajax({
			type: "POST",
			url: AjaxURL,
			data: $('#ff').serialize(),
			success: function (data) {
				$('#modal_close').click();
				/*$('#tapList').bootstrapTable('refresh');*/
				refreshTable('tapList','notice/findAllNoticeList')
			},
			error: function(data) {
				alert("error:"+data.responseText);
			}
		});
	});
	
	$('#btn_delete').click(function (){
		var obj =$('#tapList').bootstrapTable('getSelections');
		if (obj.length == 0) {
			layerAlert("请选择操作项");
			return false;
		}
		layer.confirm('确定删除吗？', {
			btn : [ '是', '否' ]
		}, function() {
			var ids = '';
			var flag = false;
			$(obj).each(function(index) {
		/*		if(obj[index].status == '1'){
					flag = true;
					return false;
				}*/
				ids = ids + obj[index].id_ + ",";
			});
	/*		if(flag){
				layerAlert("只能删除未送交的数据！");
				return;
			}*/
			
			ids = ids.substring(0, ids.length - 1);
			
			var AjaxURL= "notice/doDeleteNoticeById";
			var pk = obj[0].id_;
			$.ajax({
				type: "POST",
				url: AjaxURL,
				data: {ids:ids},
				success: function (data) {
					/*$('#tapList').bootstrapTable('refresh');*/
					refreshTable('tapList','notice/findAllNoticeList')
					layerAlert("删除成功！");
				},
				error: function(data) {
					alert("error:"+data.responseText);
				}
			});
		});
	});
	
	$('#btn_send').click(function () {
			/*$("#btn_send").attr("disabled","true")*/;
			var obj =$('#tapList').bootstrapTable('getSelections');
			var flag = "Y";
			if (obj.length>1 || obj.length == 0) {
				layerAlert("请选择一条数据");
				return false;
			}
			
			if(obj[0].status == '1'){
				layerAlert("数据已经送交！");
				flag = "N";
			}
			
			var AjaxURL= "notice/doSaveNoticeAtList";
			var pk = obj[0].id_;
			if(flag == "Y"){
				$.ajax({
					type: "POST",
					url: AjaxURL,
					data: {id:pk},
					success: function (data) {
						layerAlert("送交成功！");
						/*$('#tapList').bootstrapTable('refresh');*/
						refreshTable('tapList','notice/findAllNoticeList')
						/*$("#btn_send").attr( "disabled" , false );*/
					},
					error: function(data) {
						alert("error:"+data.responseText);
					}
				});
			}
	});
})

var title = "";
function search(){
	document.getElementById("ff").reset();
	title = $("#input-word").val();
/*	if(title == '请输入标题查询'){
		title = "";
	}
	if (title != '' && title.indexOf('%') != -1) {
		layerAlert("输入包含非法字符！");
		return;
	}*/
	$("#tapList").bootstrapTable('refresh',{
		url : "notice/findAllNoticeList",
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
			url : 'notice/findAllNoticeList', // 请求后台的URL（*）
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
					sortName : this.sortName,
					sortOrder : this.sortOrder,
					"queryPams":$("#ff").serialize()
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
			uniqueId : "id_", // 每一行的唯一标识，一般为主键列
			showToggle : false, // 是否显示详细视图和列表视图的切换按钮
			cardView : false, // 是否显示详细视图
			detailView : false, // 是否显示父子表
			maintainSelected:true,
			responseHandler:function(res){
				$.each(res.rows, function (i, row) {
					 row.checkStatus  = $.inArray(row.id_, selectionIds) !== -1;
					});
					return res;	
			},
			columns: [{
			        	  checkbox : true,
			        	  field: 'checkStatus',
			        	  width: '4%'
			          }, 
			          {
			        	  field: 'Number',
			        	  title: '序号',
			        	  halign: 'center',
			  			  align:'center',
			  			  valign: 'middle',
			  			  width: '7%',
	                      formatter: function (value, row, index) {
	                          return index+1;
	                      }
						},{ 
			        	  field: 'title', 
			        	  title: '文件标题',
			        	  valign: 'middle',
			  			  halign: 'left',
			  			  width: '50%',
			  			  sortable:true,
			  			  /*events: onTdClickTab,*/
			  			  formatter: onTdClickTabFormatter
			          }, {
			        	  field: 'status', 
			        	  title: '办理状态',
			        	  halign: 'center',
			        	  cellStyle : cellStyle,
			  			  sortable:true,
			  			  align:'center',
			  			  width : '10%',
			  			  valign: 'middle',
			  				formatter : function(value, row) {
			  					if (value == 1)
									return '<span class="label label-success">已送交</span>';
								if (value == 0)
									return '<span class="label label-danger">未送交</span>';
								return null;
			  				}
			          },{
			        	  field: 'create_time', 
			        	  title: '创建时间',
			        	  cellStyle : cellStyle,
			        	  halign: 'center',
			  			  valign: 'middle',
			  			  align:'center',
			  			  width : '10%',
			  			  sortable:true,
				   			formatter:function(value,row){
				 				if (value == null){
									return '-';
								}else{
									return value.substring(0,10);

								}			
						}
			          }, {
			 			 field: 'operate',
			             title: '操作',
			             halign: 'center',
			             align:'center',
			             width : '10%',
			             events: operateEvents,
			             formatter: operateFormatter
					}
			      ] ,
			      onClickRow : function(row, tr) {
						var pk = row.id_;
						var options={
								"text":"通知公告-查看",
								"id": "fstz_view_"+pk,
								"pid":window,
								"isDelete":true,
				    			"isReturn":true,
				    			"isRefresh":true,
								"href":"notice/editFindNoticeFsById?id="+pk+"&type=open",
						};
						
						window.parent.createTab(options);
					}
		});
		
		laydate.skin('dahong');	
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
							"id": "fstz_view_"+pk,
							"pid":window,
							"isDelete":true,
			    			"isReturn":true,
			    			"isRefresh":true,
							"href":"notice/editFindNoticeFsById?id="+pk+"&type=open",
					};
					
					window.parent.createTab(options);
				}
	}


	/**
	 * 高级搜索模态框
	 */
	function upperSearch(){
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
			url : "notice/findAllNoticeList",
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
			url : "notice/findAllNoticeList",
			query:{
				"queryPams":$("#ff").serialize()
			}
		});
	}
	
	window.operateEvents = {
		    /*'click .editSubject': function (e, value, row, index) {
		    		stopPropagation();
		    		var AjaxURL= "notice/doDeleteNoticeById";
		    		var ids = row.id_; 
					if(row.status == '1'){
						layerAlert("只能删除未送交的数据！");
						return;
					}else{
						$.ajax({
							type: "POST",
							url: AjaxURL,
							data: {ids:ids},
							success: function (data) {
								$('#tapList').bootstrapTable('refresh');
								refreshTable('tapList','notice/findAllNoticeList')
								layerAlert("删除成功！");
							},
							error: function(data) {
								alert("error:"+data.responseText);
							}
						});
					}
				
		    },*/
	    'click .fordetails': function (e, value, row, index) {
	    	stopPropagation();
	    	if(row.status == '1'){
				layerAlert("数据已经送交，不可修改！");
				return false;
			}
	    	var pk = row.id_;
	    	var options={
					"text":"通知公告-修改",
					"id": "fstz_edit_"+pk,
					"href":"notice/editFindNoticeFsById?id="+pk+"&type=edit",
				    "pid":window
			};
			window.parent.createTab(options);
	    }
	};

	function operateFormatter(value, row, index) {
	    return [
	            /*'<a class="editSubject" href="javascript:void(0)" title="删除">',
	            '<i class="fa fa-remove"></i>',
	            '</a>  ',*/
	        '<a class="fordetails" href="javascript:void(0)" title="修改">',
	        '<i class="fa fa-pencil"></i>',
	        '</a>'
	    ].join('');
	}
