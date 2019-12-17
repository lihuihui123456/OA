/**
 * 白金
 */
var myArr = "";
var myArr2 = "";
//收文选中ID
var selectionIds = [];
//发文选中ID
var selectionIdsFw = [];
$(function() {
		//  laydate.skin('dahong');
		  initTable2();
		  initTable();
		$('#myTab a').click(function (e) {
			e.preventDefault()
			$(this).tab('show')
		});
		
		$('#input-word').keydown(function(event){ 
			if(event.keyCode==13){ 
				search_fw();
			} 
		}); 
		
		$('#input-word-sw').keydown(function(event){ 
			if(event.keyCode==13){ 
				search();
			} 
		}); 
	
	//记忆选中
		/**
	    * 选中事件操作数组  
	    */
	    var union = function(array,ids){  
	        $.each(ids, function (i, ID_) {  
	            if($.inArray(ID_,array)==-1){  
	                array[array.length] = ID_;  
	            }  
	        });  
	         return array;  
	    };
		/**
	     * 取消选中事件操作数组 
	     */ 
	    var difference = function(array,ids){  
	            $.each(ids, function (i, ID_) {  
	                 var index = $.inArray(ID_,array);  
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
	            return row.ID_;  
	        });  
	        func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	        selectionIds = _[func](selectionIds, ids);   
	}); 
		
		//发文记忆选中
		$('#tapList2').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
			var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
			            return row.ID_;  
			        });  
			        func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
			        selectionIdsFw = _[func](selectionIdsFw, ids);   
			}); 

	
	//收文导出Excel
	$("#btn_excel").click(function(){
		if(selectionIds.length <= 0){
			selectionIds = [1,2];
		}
		$("#hideSelectionIdssw").val(selectionIds);
		var temp = window.encodeURI(window.encodeURI($("#input-word-sw").val()=="请输入标题查询"?"":$("#input-word-sw").val()))
		$("#hideInputWordsw").val(temp);
		var action = "docquery/exportExcel?"+$("#search_form_sw").serialize();
		/*var aLink = document.createElement('a');
	    aLink.href =action;
	    aLink.click();*/
		 window.location.href= conn+"/"+action;
	    refreshTable('tapList','docquery/getAllBasicinfo');
	})
	
	//发文导出Excel
	$("#btn_excel_fw").click(function(){
		if(selectionIdsFw.length <= 0){
			selectionIdsFw = [1,2];
		}
		$("#hideSelectionIdsfw").val(selectionIdsFw);
		var temp = window.encodeURI(window.encodeURI($("#input-word").val()=="请输入标题查询"?"":$("#input-word").val()))
		$("#hideInputWordfw").val(temp);
		var action = "docquery/exportExcel_fw?"+$("#search_form").serialize();
		/*var aLink = document.createElement('a');
	    aLink.href =action;
	    aLink.click();*/
	    window.location.href= conn+"/"+action;
	    refreshTable('tapList2','docquery/getAllBasicinfo_fw');
	})
	
	//收文重置
	$("#btn_reset").click(function(){
		$("#draftUser2IdName_").val("");
		$("#gwbt").val("");
		$("#sfgd option:first").attr("selected","selected");
		$("#bwzt option:first").attr("selected","selected");
		/*$("#jjcd option:first").attr("selected","selected");*/
		myArr = "";
		search();
	})
	
	//发文重置
	$("#btn_reset_fw").click(function(){
		$("#gwbt_fw").val("");
		$("#draftDeptIdName_").val("");
		$("#draftUserIdName_").val("");
		$("#bwzt_fw option:first").attr("selected","selected");
		$("#jjcd_fw option:first").attr("selected","selected");
		$("#sfgd_fw option:first").attr("selected","selected");
		myArr2 = "";
		search_fw();
	})
})


function showOrHideSw(){
	var display =$('#upperSearchsw').css('display');
	if(display == "none") {
		$("#upperSearchsw").show();
	}else {
		$("#upperSearchsw").hide();
	}
}

function qxButtonSw(){
	$("#upperSearchsw").hide();	
}

function showOrHideFw(){
	var display =$('#upperSearch').css('display');
	if(display == "none") {
		$("#upperSearch").show();
	}else {
		$("#upperSearch").hide();
	}
}

function qxButtonFw(){
	$("#upperSearch").hide();	
}
//收文查询
function search (){
	document.getElementById("search_form_sw").reset();
	$("#tapList").bootstrapTable('refresh',{
		url : "docquery/getAllBasicinfo",
		query:{
			gwbt_fw : window.encodeURI(window.encodeURI($("#input-word-sw").val()=="请输入标题查询"?"":$("#input-word-sw").val()))
		}
	});
}

//发文查询
function search_fw(){
	document.getElementById("search_form").reset();
	$("#tapList2").bootstrapTable('refresh',{
		url : "docquery/getAllBasicinfo_fw",
		query:{
			gwbt_fw : window.encodeURI(window.encodeURI($("#input-word").val()=="请输入标题查询"?"":$("#input-word").val()))
		}
	});
}

function getmyArr(){
	var gwbt = $("#gwbt").val();
	var djr = $("#draftUser2IdName_").val();
	var bwzt = $("#bwzt").val();
	var sfgd = $("#sfgd").val();
	myArr = gwbt+"&"+djr+"&"+bwzt+"&"+sfgd;
	myArr = window.encodeURI(window.encodeURI(myArr));
	return myArr;
}
function getmyArr2(){
	var gwbt_fw = $("#gwbt_fw").val();
	var djr_fw = $("#draftUserIdName_").val();
	var lwdw_fw = $("#draftDeptIdName_").val();
	var jjcd_fw = $("#jjcd_fw").val();
	var sfgd_fw = $("#sfgd_fw").val();
	var bwzt_fw = $("#bwzt_fw").val();
	myArr2 = gwbt_fw+"&"+djr_fw+"&"+bwzt_fw+"&"+jjcd_fw+"&"+sfgd_fw;
	myArr2 = window.encodeURI(window.encodeURI(myArr2));
	return myArr2;
}

function getS(){
	var titleS = $("#input-word-sw").val()=="请输入标题查询"?"":$("#input-word-sw").val();
	if(titleS != ""){
		document.getElementById("search_form_sw").reset();
	}
	return window.encodeURI(window.encodeURI(titleS))
}

function initTable() {
	$('#tapList').bootstrapTable({
		url : 'docquery/getAllBasicinfo', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar_sw', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）0.
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				gwbt : getS(),
				query : getmyArr(),
				sortName : this.sortName,
				sortOrder : this.sortOrder
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
		uniqueId : "ID_", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.ID_, selectionIds) !== -1;
				});
				return res;	
		},
		detailView : false, // 是否显示父子表
		columns: [{
				checkbox : true,
				field: 'checkStatus',
				valign: 'middle',
				width : '3%'
				},{
		        	  field: 'Number',
		        	  title: '序号',
		        	  valign: 'middle',
		  			  align : 'center',
		  			  width : '5%',
                      formatter: function (value, row, index) {
                          return index+1;
                      }
					},{ 
		        	  field: 'BIZ_TITLE_', 
		        	  title: '标题',
		        	  valign: 'middle',
		  			  align : 'left',
		        	  width : '20%',
		        	  sortable:true,
		        	  /*events: onTdClickTab,*/
		              formatter: onTdClickTabFormatter,
		        	 /* formatter : function(value, row){
		        		 return "<a href='javascript:void(0);' onclick='view(\""+row.id+"\")'>"+value+"</a>";
		        	  }*/
		          }, {
		        	  field: 'ORG_NAME', 
		        	  title: '来文单位',
		        	  valign: 'middle',
		        	  sortable:true,
		  			  align : 'left',
		        	  visible:false
		          }, {
		        	  field: 'USER_NAME', 
		        	  valign: 'middle',
		        	  sortable:true,
		  			  align : 'left',
		        	  title: '登记人',
		        	  width:'10%'
		          }, 
		          {
		        	  field: 'DEPT_NAME', 
		        	  valign: 'middle',
		        	  sortable:true,
		  			  align : 'left',
		        	  title: '登记科室',
		        	  width:'10%'
		          },
		          {
		        	  field: 'CREATE_TIME_', 
		        	  sortable:true,
		        	  title: '登记时间',
		        	  valign: 'middle',
		        	  cellStyle : cellStyle,
		  			  align : 'center',
		  			  width : '15%',
		        	  formatter:function(value,row){
		        		  return jsonTimeStamp(value);
		        	  }
		          }
		          ,{
		        	  field: 'SERIAL_NUMBER_', 
		        	  title: '流水号',
		        	  visible:false
		          }
		          ,{
		        	  field: 'STATE_', 
		        	  title: '办理状态',
		        	  sortable:true,
		        	  cellStyle : cellStyle,
		        	  valign: 'middle',
		  			  align : 'center',
		  			  width : '10%',
		        	  formatter : function(value, row) {
							if (value == '1')
								return '<span class="label label-warning">在办</span>';
							if (value == '2')
								return '<span class="label label-success">办结</span>';
							if (value == '4')
								return '<span class="label label-warning">挂起</span>';
							return null;
		  			 }
		          }
		          ,{
		        	  field: 'ARCHIVE_STATE_', 
		        	  title: '归档状态',
		        	  sortable:true,
		        	  valign: 'middle',
		  			  align : 'center',
		  			  cellStyle : cellStyle,
		  			  width : '10%',
		        	  formatter : function(value, row) {
							if (value == '1'){
								return '<span class="label label-success">已归</span>';
							}else{
								return '<span class="label label-warning">未归</span>';
							}
		  			 }
		          }
		      ],onClickRow : function(row, tr) {
		    	  	var bizId=row.ID_;
					var solId = row.solId;
					var operateUrl = "bizRunController/getBizOperate?status=4&solId="+ solId + "&bizId=" + bizId;
					var options={
							"text":"查看公文",
							"id":"viewgw"+bizId,
							"href":operateUrl,
							"pid":window,
							"isDelete":true,
							"isReturn":true,
							"isRefresh":true
					};
					window.parent.createTab(options);
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
		if(value.length>14){
			return "<span class='tdClick' title='"+value+"'>"+value.substring(0,39)+"...</span>"
		}else{
			return "<span class='tdClick'>"+value+"</span>"
		}
	}else{
		return "<span class='tdClick'>-</span>"
	}
}
window.onTdClickTab = {
		 'click .tdClick': function (e, value, row, index) {
			var bizId=row.ID_;
			var options={
					"text":"查看公文",
					"id":"viewgw"+bizId,
					"href":"bpmRunController/view?bizId="+ bizId,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
		 }
	}

function jsonTimeStamp(milliseconds) {
    if (milliseconds != "" && milliseconds != null
            && milliseconds != "null") {
        var datetime = new Date();
        datetime.setTime(milliseconds);
        var year = datetime.getFullYear();
        var month = datetime.getMonth() + 1 < 10 ? "0"
                + (datetime.getMonth() + 1) : datetime.getMonth() + 1;
        var date = datetime.getDate() < 10 ? "0" + datetime.getDate()
                : datetime.getDate();
        var hour = datetime.getHours() < 10 ? "0" + datetime.getHours()
                : datetime.getHours();
        var minute = datetime.getMinutes() < 10 ? "0"
                + datetime.getMinutes() : datetime.getMinutes();
        var second = datetime.getSeconds() < 10 ? "0"
                + datetime.getSeconds() : datetime.getSeconds();
        return year + "-" + month + "-" + date + " " + hour + ":" + minute
                + ":" + second;
    } else {
        return "";
    }
 
} 

function getF(){
	var titleS = $("#input-word").val()=="请输入标题查询"?"":$("#input-word").val();
	if(titleS != ""){
		document.getElementById("search_form").reset();
	}
	return window.encodeURI(window.encodeURI(titleS));
}

function initTable2() {
	$('#tapList2').bootstrapTable({
		url : 'docquery/getAllBasicinfo_fw', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar_fw', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）0.
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				gwbt_fw : getF(),
				query : getmyArr2(),
				sortName : this.sortName,
				sortOrder : this.sortOrder
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
		uniqueId : "ID_", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.ID_, selectionIdsFw) !== -1;
				});
				return res;	
		},
		detailView : false, // 是否显示父子表
		columns: [{
				checkbox : true,
				field: 'checkStatus',
				valign: 'middle',
				width : '4%'
				},{
		        	  field: 'Number',
		        	  title: '序号', 
		        	  valign: 'middle',
		  			  align : 'center',
		  			  width : '7%',
                      formatter: function (value, row, index) {
                          return index+1;
                      }
					},{ 
		        	  field: 'BIZ_TITLE_', 
		        	  title: '标题',
		        	  valign: 'middle',
		  			  align : 'left',
		        	  width : '17%',
		        	  sortable:true,
		        	  /*events: onTdClickTab,*/
		              formatter: onTdClickTabFormatter,
		        	 /* formatter : function(value, row){
		        		 return "<a href='javascript:void(0);' onclick='view(\""+row.id+"\")'>"+value+"</a>";
		        	  }*/
		          },/* {
		        	  field: 'orgName', 
		        	  title: '拟稿单位',
		        	  valign: 'middle',
		  			  align : 'left',
		  			  width : '20%'
		          }, */
		          {
		        	  field: 'USER_NAME', 
		        	  title: '拟稿人',
		        	  sortable:true,
		        	  valign: 'middle',
		  			  align : 'left',
		  			  width : '13%'
		          },
		          /*{
		        	  field: 'DEPT_NAME', 
		        	  title: '拟稿部门',
		        	  sortable:true,
		        	  valign: 'middle',
		  			  align : 'left',
		  			  width : '12%'
		          },*/
		          {
		        	  field: 'CREATE_TIME_', 
		        	  title: '拟稿时间',
		        	  valign: 'middle',
		        	  sortable:true,
		  			  align : 'center',
		  			  cellStyle : cellStyle,
		  			  width : '22%',
		  			  classes:'time',
		        	  formatter:function(value,row){
		        		  return jsonTimeStamp(value);
		        	  }
		          },{
		        	  field: 'SERIAL_NUMBER_', 
		        	  title: '流水号',
		        	  visible:false
		          }
		          ,{
		        	  field: 'STATE_', 
		        	  title: '办理状态',
		        	  valign: 'middle',
		        	  cellStyle : cellStyle,
		        	  sortable:true,
		  			  align : 'center',
		  			  width : '13%',
		        	  formatter : function(value, row) {
							if (value == '1')
								return '<span class="label label-warning">在办</span>';
							if (value == '2')
								return '<span class="label label-success">办结</span>';
							if (value == '4')
								return '<span class="label label-danger">挂起</span>';
							return null;
		  			 }
		          }
		          ,{
		        	  field: 'URGENCY_', 
		        	  title: '紧急程度',
		        	  sortable:true,
		        	  valign: 'middle',
		        	  cellStyle : cellStyle,
		  			  align : 'center',
		  			  width : '12%',
		        	  formatter : function(value, row) {
							if (value == '1')
								return '<span class="label label-success">平件</span>';
							if (value == '2')
								return '<span class="label label-warning">急件</span>';
							if (value == '3')
								return '<span class="label label-danger">特急</span>';
							return null;
		  			 }
		          },{
		        	  field: 'ARCHIVE_STATE_', 
		        	  title: '归档状态',
		        	  sortable:true,
		        	  cellStyle : cellStyle,
		        	  valign: 'middle',
		  			  align : 'center',
		  			  width : '13%',
		        	  formatter : function(value, row) {
		        		  if (value == '1'){
								return '<span class="label label-success">已归</span>';
							}else{
								return '<span class="label label-warning">未归</span>';
							}
		  			 }
		          },
		      ],
		      onClickRow : function(row, tr) {
					var bizId=row.ID_;
					var solId = row.solId;
					var operateUrl = "bizRunController/getBizOperate?status=4&solId="+ solId + "&bizId=" + bizId;
					var options={
							"text":"查看公文",
							"id":"viewgw"+bizId,
//							"href":"bpmRunController/view?bizId="+ bizId,
							"href":operateUrl,
							"pid":window,
							"isDelete":true,
							"isReturn":true,
							"isRefresh":true
					};
					window.parent.createTab(options);
				}
	});
}
/**
 * 高级搜索模态框
 */
function upperSearch(){
	/*clearForm();*/
	/*document.getElementById("search_form").reset();*/
	$('#upperSearch').modal({
		backdrop : 'static',
		keyboard : false
	});
}
	//高级搜索
	function submitForm(){
		searchModel();
		$('#upperSearch').modal('hide');
	}
	//重置高级搜索表单
	function clearForm(){
		$("#input-word").val("请输入标题查询");
		document.getElementById("search_form").reset();
		$("#tapList2").bootstrapTable('refresh',{
			url : "docquery/getAllBasicinfo_fw",
			query:{
				"query" : getmyArr2()
			}
		});
		$("#upperSearch").modal('hide');
	}
	
	function searchModel(){
				$("#input-word").val("请输入标题查询");
				$("#tapList2").bootstrapTable('refresh',{
					url : "docquery/getAllBasicinfo_fw",
					query:{
						"query" : getmyArr2()
					}
				});
			}
	
	
	/**
	 * 高级搜索模态框
	 */
	function upperSearchSW(){
		/*clearFormsw();*/
		/*document.getElementById("search_form_sw").reset();*/
		$('#upperSearchsw').modal({
			backdrop : 'static',
			keyboard : false
		});
	}
		//高级搜索
		function submitFormsw(){
			searchModelsw();
			$('#upperSearchsw').modal('hide');
		}
		//重置高级搜索表单
		function clearFormsw(){
			$("#input-word-sw").val("请输入标题查询");
			document.getElementById("search_form_sw").reset();
			$("#tapList").bootstrapTable('refresh',{
				url : "docquery/getAllBasicinfo",
				query:{
					"query" : getmyArr()
				}
			});
			$("#upperSearchsw").modal('hide');
		}
		
		function searchModelsw(){
					$("#input-word-sw").val("请输入标题查询");
					$("#tapList").bootstrapTable('refresh',{
						url : "docquery/getAllBasicinfo",
						query:{
							"query" : getmyArr()
						}
					});
				}