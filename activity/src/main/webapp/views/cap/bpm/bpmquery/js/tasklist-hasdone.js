var selectionIds = [];
function search() {
	document.getElementById("ff").reset();
	var title = $("#input-word").val();
	if (title == '请输入标题查询') {
		title = "";
	}else{
		title = window.encodeURI(window.encodeURI(title));
	}
	$("#tb_departments").bootstrapTable('refresh',{
		url : "bpmQuery/findHasDoneList",
		query:{
			title : title
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

$(document).ready(function() {
	$('#tb_departments').bootstrapTable({
		url : 'bpmQuery/findHasDoneList',
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
				title : getT(),
				sortName : this.sortName,
				sortOrder : this.sortOrder,
				"queryPams":$("#ff").serialize()
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
			checkbox : true,
			align : 'center',
			valign: 'middle',
			field: 'checkStatus',
			width: '4%',
		}, {
			field : 'id_',
			title : 'id_',
			visible : false
		}, {
			field : 'index',
			title : '序号',
			align:'center',
			valign: 'middle',
			width: '7%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, 
		/*{
			field : 'serial_number',
			title : '流水号',
			valign: 'middle',
			align : 'left',
			width : '16%'
		},*/ 
		{
			field : 'BIZ_TITLE_',
			title : '标题',
			valign: 'middle',
			halign: 'left',
			align:'left',
			sortable:true,
			width : '21%',
			/*events: onTdClickTab,*/
            formatter: onTdClickTabFormatter
		}, {
			field : 'USER_NAME',
			title : '拟稿人',
			cellStyle : cellStyle,
			valign: 'middle',
			halign: 'center',
			align:'center',
			width : '9%',
			sortable:true
		},  {
			field : 'URGENCY_',
			title : '紧急程度',
			valign: 'middle',
			cellStyle : cellStyle,
			halign: 'center',
			align:'center',
			width : '10%',
			sortable:true,
			formatter:function(value,row){
				if (value == "1"){
					return '<span class="label label-success">平件</span>';
				}else if (value == "2"){
					return '<span class="label label-warning">急件</span>';
				}else if(value == "3"){
					return '<span class="label label-danger">特急</span>';
				}
			}
		}, {
			field : 'code',
			title : '文件类型',
			valign: 'middle',
			width: '10%',
			halign: 'center',
			align: 'center',
			sortable: true,
			formatter:function(value,row){
				if(value!=null){
					var sw = value.indexOf("10011002");
					var fw = value.indexOf("10011001");
					var ht = value.indexOf("10011004");
					var qj = value.indexOf("10011006");
					var xmjs = value.indexOf("10011003");
					if (sw==0) {
						return "收文";
					}else if(fw==0){
						return "发文";
					}else if(ht==0){
						return "合同";
					}else if(qj==0){
						return "请假";
					}else if(xmjs==0){
						return "项目建设";
					}
				     else{
						return "--";
					}	
				}else{
					return "其它";
				}
	
			},
			cellStyle : cellStyle
		}, {
			field : 'STATE_',
			title : '办理状态',
			valign: 'middle',
			cellStyle : cellStyle,
			halign: 'center',
			align:'center',
			width : '10%',
			sortable:true,
			formatter:function(value,row){
				if (value == "0"){
					return '<span class="label label-danger">待发</span>';
				}else if (value == "2"){
					return '<span class="label label-success">办结</span>';
				}else if (value == "1"){
					return '<span class="label label-warning">在办</span>';
				}else if(value == "4"){
					return '<span class="label label-default">挂起</span>';
				}
			}
		}, {
			field : 'CREATE_TIME_',
			title : '拟稿日期',
			cellStyle : cellStyle,
			valign: 'middle',
			halign: 'center',
			align:'center',
			width : '11%',
			sortable:true
		}, {
			field : 'END_TIME_',
			title : '办理时间',
			cellStyle : cellStyle,
			valign: 'middle',
			align: 'center',
			align:'center',
			width:  '11%',
			sortable:true,
 			formatter:function(value,row){
 				if (value == null){
					return '-';
				}else{
					return value.substring(0,10);

				}
		}
		}, {
			field : 'bizid',
			title : '业务id',
			visible : false,
		}, {
			field : 'proc_inst_id_',
			title : '流程实例id',
			visible : false
		}, {
			field : 'solId',
			title : '业务解决方案id',
			visible : false
		} , {
			 field: 'operate',
             title: '操作',
             halign: 'center',
             width: '8%',
             align:'center',
             width: '',
             events: operateEvents,
             formatter: operateFormatter
		}],
		onClickRow : function(row, tr) {
			var bizid=row.bizid;
			var solId=row.solId;
			/*var timestamp=new Date().getTime();*/
			var operateUrl = "bizRunController/getBizOperate?status=4&solId="+ solId + "&bizId=" + bizid;
			var options={
					"text":"查看-已办事项",
					"id":"bizinfoview"+bizid,
					"href":operateUrl,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
		}
	});
	var oButtonInit = new ButtonInit();
	oButtonInit.Init();
	laydate.skin('dahong');
	
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
		$('#tb_departments').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
				var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
	         return row.id_;  
	     });  
	     func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	     selectionIds = _[func](selectionIds, ids);   
		});  
	});

	function operateFormatter(value, row, index) {
	    return [
	        '<a class="fordetails" style="color:#167495;" href="javascript:void(0)" title="办理详情">',
	        '<i class="fa fa-list"></i>',
	        '</a>'
	    ].join('');
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
			if(value.length>30){
				return "<span class='tdClick' title='"+value+"'>"+value.substring(0,29)+"...</span>"
			}else{
				return "<span class='tdClick' title='"+value+"'>"+value+"</span>"
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
			 var taskid = row.id_;
				var bizid=row.bizid;
				var proc_inst_id_=row.proc_inst_id_;
				var solId=row.solId;
				var timestamp=new Date().getTime();
				var options={
						"text":"查看-已办事项",
						"id":"bizinfoview"+bizid+timestamp,
						//"href":"bpmRuBizInfoController/view?bizId="+ bizid+"&&procInstId="+ proc_inst_id_ +"&&taskId="+taskid +"&&solId="+solId,
						"href":"bpmRunController/view?bizId="+ bizid+"&taskId="+taskid,
						"pid":window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true
				};
				window.parent.createTab(options);
		 }
	}
	
	window.operateEvents = {
		    'click .fordetails': function (e, value, row, index) {
		    	stopPropagation();
				var bizid=row.bizid;
					var options={
							"text":"办理详情",
							"id":"bizinfodetail"+bizid+"_yfsx",
							"href":"bpmRuBizInfoController/toDealDetialPage?bizId="+bizid,
							"pid":window,
							"isDelete":true,
							"isReturn":true,
							"isRefresh":false
					};
					window.parent.createTab(options);
		    }
		};

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
		//高级搜索
		function submitForm(){
			$("#input-word").val("请输入标题查询");
			searchModel();
			$('#upperSearch').modal('hide');
		}
		//重置高级搜索表单
		function clearForm(){
			document.getElementById("ff").reset();
			$("#input-word").val("请输入标题查询");
			$("#tb_departments").bootstrapTable('refresh',{
				url : "bpmQuery/findHasDoneList",
				query:{
					"queryPams" : $("#ff").serialize(),
				}
			});
			/*$("#upperSearch").modal('hide');*/
		}
		
		function searchModel(){
			var startTimeN,endTimeN;
			startTimeN = $("#CREATE_TIME_START_").val();
			endTimeN = $("#CREATE_TIME_END_").val();
			if(startTimeN != "" && endTimeN != "") {
				if(endTimeN <= startTimeN) {
					layer.msg("拟稿结束日期必须大于拟稿开始日期！");
					return;
				}
			}
			
			var startTimeJ,endTimeJ;
			startTimeJ = $("#END_TIME_START_").val();
			endTimeJ = $("#END_TIME_END_").val();
			if(startTimeJ != "" && endTimeJ != "") {
				if(endTimeJ <= startTimeJ) {
					layer.msg("办理结束时间必须大于办理开始时间！");
					return;
				}
			}
			
			$("#tb_departments").bootstrapTable('refresh',{
				url : "bpmQuery/findHasDoneList",
				query:{
					"queryPams":$("#ff").serialize()
				}
			});
		}
		
		Date.prototype.Format = function (fmt) { //author: meizz 
		    var o = {
		        "M+": this.getMonth() + 1, //月份 
		        "d+": this.getDate(), //日 
		        "h+": this.getHours(), //小时 
		        "m+": this.getMinutes(), //分 
		        "s+": this.getSeconds(), //秒 
		        "q+": Math.floor((this.getMonth() + 3) / 3), //季度 
		        "S": this.getMilliseconds() //毫秒 
		    };
		    if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
		    for (var k in o)
		    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
		    return fmt;
		}