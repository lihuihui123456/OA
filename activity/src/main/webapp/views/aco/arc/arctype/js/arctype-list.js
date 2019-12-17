$(function() {
	/**
	 * 列表回车触发搜索
	 */
	$('#input-word').bind('keypress', function (event) {
	    if (event.keyCode == "13") {
	    	searchCommon(); 
	       return false ;   
	    } 
	});
	laydate.skin('dahong');
	initTree();
	initTable();
	$('#add_btn').click(function() {
		var typeId = $('#typeId').val();
		if(typeId=='123456'||typeId==''){
			layerAlert("请选择一个档案类型！");
			return;
		}
		if(typeId!='8a814fea59243834015924547a73000b'&&typeId!='8a814fea592438340159244e96f50002'){
			layerAlert("请选择文书档案和会议纪要类型");
			return;
		}
		if("8a814fea59243834015924547a73000b"==typeId){
			$("#href").val("/arcMtgSumm/index");
		}else{
			$("#href").val("/docInforController/toDocInforList");
		}
		var modal = $('#arcTypeModal');
		modal.modal('show');
		var date = new Date().Format("yyyy-MM-dd hh:mm:ss");
		$("#creTime").val(date);
		$.ajax({
			type : "POST",
			url : "actTypeController/findArcTypeInfoById",
			data : {
				"Id" : typeId
			},
			success : function(data) {
				var select = document.getElementById("prntId");
				select.options.length=0; //把select对象的所有option清除掉
				for (var i = 0; i < data.length; i++) {
					var op = document.createElement("option"); // 新建OPTION (op)
					op.setAttribute("value", data[i].id); // 设置OPTION的 VALUE
					op.appendChild(document.createTextNode(data[i].typeName)); // 设置OPTION的
					select.appendChild(op); // 为SELECT 新建一 OPTION(op)
				}
			},
			error : function(data) {
				layerAlert("error:" + data.responseText);
			}
		});
		document.getElementById("typeName").focus();
	});
	$('#edi_btn').click(function() {
		clearCUserForm();
		var selecteds = $('#typeList').bootstrapTable('getSelections');
		if(selecteds.length!="1"){
			layerAlert("请选择一条数据修改！");
			return;
		}else{
			var Id = selecteds[0].id;
			var modal = $('#arcTypeModal');
			modal.modal('show');
			$.ajax({
				type : "POST",
				url : "actTypeController/findArcTypeInfoById",
				data : {
					"Id" : Id
				},
				success : function(data) {
					$("#id").val(data[0].id);	
					$("#typeName").val(data[0].typeName);
					$("#href").val(data[0].href);
					$("#creTime").val(data[0].creTime);
					$("#remark").val(data[0].remark);
					$.ajax({
						type : "POST",
						url : "actTypeController/findArcTypeInfoById",
						data : {
							"Id" : data[0].prntId
						},
						success : function(data) {
	          				var select = document.getElementById("prntId");
							select.options.length=0; //把select对象的所有option清除掉
							for (var i = 0; i < data.length; i++) {
								var op = document.createElement("option"); // 新建OPTION (op)
								op.setAttribute("value", data[i].prntId); // 设置OPTION的 VALUE
								op.appendChild(document.createTextNode(data[i].typeName)); // 设置OPTION的
								select.appendChild(op); // 为SELECT 新建一 OPTION(op)
								// select.options.remove(i); //把select对象的第i个option清除掉
							}
						},
						error : function(data) {
							layerAlert("error:" + data.responseText);
						}
					});
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
				}
			});
		}
       
	});
	$('#del_btn').click(function() {
		var selecteds = $('#typeList').bootstrapTable('getSelections');
		if(selecteds.length!="1"){
			layerAlert("请选择一条数据！");
			return;
		}else{
			var Id = selecteds[0].id;
			$.ajax({
				url : 'actTypeController/doDelArcTypeById',
				type : 'post',
				dataType : 'json',
				data : {
					"Id" : Id,
				},
				success : function(result) {
					if (result != null && result ==true) {
						
						/*$("#typeList").bootstrapTable('refresh');*/
						refreshTable('typeList','actTypeController/findAllArcTypeData');
						layerAlert("删除成功！");
					} else {
						layerAlert("已存在数据不能删除！");
					}
				}
			});
		}
	});
});

function saveArcType() {
/*	if (!$('#arcTypeForm').validationEngine('validate')) {
		return false;
	}*/
	if ($('#arcTypeForm').validationEngine('validate')) {
		$.ajax({
			type : "POST",
			url : "actTypeController/doAddArcTypeInfo",
			data : $('#arcTypeForm').serialize(),
			success : function(data) {				
				/*$("#addContactsUserModal").modal('hide');*/
				$("#arcTypeModal").modal('hide');		
				/*history.go(0);*/
				refreshTable('typeList','actTypeController/findAllArcTypeData');
				clearCUserForm();
				layerAlert("保存成功!");
			},
			error : function(data) {
				layerAlert("error:" + data.responseText);
			}
		});
	}
	else{
		return false;
	}
	var select = document.getElementById("prntId");
	select.options.length=0; //把select对象的所有option清除掉
/*	$("#typeName").val("");
	$("#href").val("");*/
}

var typeName = '';
function initTable() {
	$('#typeList').bootstrapTable({
		url : 'actTypeController/findAllArcTypeData', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '#toolbar', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			validataAdv();
			pageSize=params.limit;
			pageNum=params.offset;
		    var	typeName1="";
			if($("#input-word").val()!="请输入类型名称"&&$("#input-word").val()!=""){
				typeName1=typeName1+$("#input-word").val();
				$("#search_form")[0].reset();
			}
			typeName1=typeName1+$("#typeName1").val();
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				typeName :$.trim(typeName1),
				creUser : $("#creUser1").val(),
				startTime : $("#startTime1").val(),
				endTime : $("#endTime1").val(),
				remark : $("#remark1").val(),
				typeId:$('#typeId').val()
			};
			return temp;
		},// 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
/*		pageSize : 10, // 每页的记录行数（*）
		pageList: [10, 15, 20],*/
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
/*		strictSearch : true,*/
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "Id", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		singleSelect : true,
		columns : [ {
			checkbox : true
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			valign : 'middle',
			width: '7%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'typeName',
			title : '类型名称',
			align : 'left',
			valign : 'middle',
/* 		    events: onTdClickTab,
*/ 		    formatter: onTdClickTabFormatter
		}, {
			field : 'userName',
			title : '创建人',
			align : 'left',
			valign : 'middle'
		}, {
			field : 'creTime',
			title : '创建时间',
			align : 'center',
			valign : 'middle'
		}, {
			field : 'remark',
			title : '备注',
			align : 'left',
			valign : 'middle'
		} , {
			field : '',
			title : '操作',
			align : 'left',
			valign : 'middle',
			formatter : function(value, row, index) {
				return '<span"> <img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/up.png" onclick=upOrderBy('+index+')><img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/down.png" onclick=downOrderBy('+index+')> </span>';
			}
		}],
		onClickRow: function (row, tr) {
			//双击查看用户信息
			$.ajax({
				type : "POST",
				url : "actTypeController/findArcTypeInfoById",
				data : {
					"Id" : row.id
				},
				success : function(data) {
					var imgUrl ="uploader/uploadfile?pic=";
					var viewModel = $("#viewModal");
					viewModel.modal('show');
					// 填充值给span标签
					var viewName = document.getElementById("viewName");
					viewName.innerHTML = data[0].typeName;
					var viewTime = document.getElementById("viewTime");
					viewTime.innerHTML = data[0].creTime;
					var viewUser = document.getElementById("viewUser");
					var creUser;
					if(data[0].userName==null){
						creUser="";
					}else{
						creUser=data[0].userName;
					}
					viewUser.innerHTML = creUser;
					var viewRemark = document.getElementById("viewRemark");
					var remark ="";
					if(data[0].remark==null){
					}else{
						remark=data[0].remark;
					}
					viewRemark.innerHTML = remark;
					
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
				}
			});
		}/*,
		onDblClickRow : function(row, tr) {
			//双击查看用户信息
			$.ajax({
				type : "POST",
				url : "actTypeController/findArcTypeInfoById",
				data : {
					"Id" : row.id
				},
				success : function(data) {
					var imgUrl ="uploader/uploadfile?pic=";
					var viewModel = $("#viewModal");
					viewModel.modal('show');
					// 填充值给span标签
					var viewName = document.getElementById("viewName");
					viewName.innerHTML = data[0].typeName;
					var viewTime = document.getElementById("viewTime");
					viewTime.innerHTML = data[0].creTime;
					var viewUser = document.getElementById("viewUser");
					viewUser.innerHTML = data[0].userName;
					var viewRemark = document.getElementById("viewRemark");
					var remark ="";
					if(data[0].remark==null){
					}else{
						remark=data[0].remark;
					}
					viewRemark.innerHTML = remark;
					
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
				}
			});

		}*/
	});
}

/**
 * 重置表单
 */
function clearCUserForm(){
	var typeId1=$('#typeId').val();
	document.getElementById("arcTypeForm").reset();
	$('#typeId').val(typeId1);
}
function searchData() {
	  $('#advSearchModal').modal('hide');
	  $("#input-word").val("");
	$("#typeList").bootstrapTable('refresh');
}
function validataAdv(){
	var startTime=$("#startTime1").val();
	var endTime=$("#endTime1").val();
	if(startTime!=""&& endTime!=""){
		if(startTime > endTime){
			window.parent.publicAlert("创建开始日期不能大于结束日期");
			return;
		}
	}
}
function validateData() {
	typeName = $("#input-word").val();
	if (typeName == '请输入类型名称'||typeName == '') {
		typeName = "";
	}/* else {
		var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;
		if (typeName.match(reg) == null) {
			layerAlert("输入内容含有非法字符！");
			return;
		}
	}*/
}


var setting = {
	data: {
		simpleData: {
			enable: true,
			idKey: "id",
			pIdKey: "pId",
			rootPId: 0
		}
	},
	callback:{
		onClick:zTreeOnClick
	}
};
function initTree(){
	//ztree初始化
	$.fn.zTree.init($("#folderTree"), setting,treeList);
	zTree = $.fn.zTree.getZTreeObj("folderTree");
	zTree.expandAll(true);
}
function zTreeOnClick(event,treeId,treeNode){
	chooseNode=treeNode.type;
	$('#typeId').val(treeNode.id);
	$("#typeList").bootstrapTable('refresh');
/*	$("#typeList").load("${ctx}/arcMtgSumm/index");
*/}


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

function upOrderBy(param){
	stopPropagation();
	var typeId = $('#typeId').val();
	var selecteds = $('#typeList').bootstrapTable('getData')[param];
	
	if(param==0){
		if(pageNum!=0){
			$.ajax({
				type : "POST",
				url : "actTypeController/orderByType",
				data : {
					"pageNum":pageNum,
					"pageSize":pageSize,
					"firstOrLast":"first",
					"typeId":typeId,
					"id" : selecteds.id,
					
				},
				success : function(data) {
					if(data=='true'){
						
						/*$("#typeList").bootstrapTable('refresh');*/
						refreshTable('typeList','actTypeController/findAllArcTypeData');
						layerAlert("移动成功！");
					}
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
				}
			});
		}
		else{
			layerAlert("无法上移！");
			return;
		}
	}
	else{
		var selectedsUp = $('#typeList').bootstrapTable('getData')[param-1];
		$.ajax({
			type : "POST",
			url : "actTypeController/orderByTypeBase",
			data : {
				"idUp":selecteds.id,
				"idDown":selectedsUp.id
				
			},
			success : function(data) {
				if(data=='true'){
					
					/*$("#typeList").bootstrapTable('refresh');*/
					refreshTable('typeList','actTypeController/findAllArcTypeData');
					layerAlert("移动成功！");
				}
			},
			error : function(data) {
				layerAlert("error:" + data.responseText);
			}
		});
	}
}
function downOrderBy(param){
	stopPropagation();
	var totalPageNum=$('#typeList').bootstrapTable('getOptions').totalPages;
	var typeId = $('#typeId').val();
	var selecteds = $('#typeList').bootstrapTable('getData')[param];
	var lengthTable= $('#typeList').bootstrapTable('getData').length;
	if(param==lengthTable-1){
		var pageNumThis=pageNum;
	    if (pageNumThis != 0) {
	    	pageNumThis = pageNumThis / pageSize;
		    }
	    pageNumThis++;
		if(totalPageNum!=pageNumThis){
			$.ajax({
				type : "POST",
				url : "actTypeController/orderByType",
				data : {
					"pageNum":pageNum,
					"pageSize":pageSize,
					"firstOrLast":"last",
					"typeId":typeId,
					"id" : selecteds.id,
					
				},
				success : function(data) {
					if(data=='true'){
						
						/*$("#typeList").bootstrapTable('refresh');*/
						refreshTable('typeList','actTypeController/findAllArcTypeData');
						layerAlert("移动成功！");
					}
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
				}
			});
		}
		else{
			layerAlert("无法下移！");
			return;
		}
	}
	else{
		var selectedsUp = $('#typeList').bootstrapTable('getData')[param+1];
		$.ajax({
			type : "POST",
			url : "actTypeController/orderByTypeBase",
			data : {
				"idUp":selectedsUp.id,
				"idDown":selecteds.id
				
			},
			success : function(data) {
				if(data=='true'){
					
					/*$("#typeList").bootstrapTable('refresh');*/
					refreshTable('typeList','actTypeController/findAllArcTypeData');
					layerAlert("移动成功！");
				}
			},
			error : function(data) {
				layerAlert("error:" + data.responseText);
			}
		});
	}
}
/*document.onkeydown = function(event_e){    
    if(window.event)    
     event_e = window.event;    
     var int_keycode = event_e.charCode||event_e.keyCode;    
     if(int_keycode ==13){
    	 searchData(); 
    }  
}*/
/**
 * 高级搜索模态框
 */
function advSearchModal(){
	$('#advSearchModal').modal('show');
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
	if(value==null){
		return "<span class='tdClick'>-</span>"
	}
	else if(value.length>30){
		return "<span class='tdClick' title='"+value+"'>"+value.substring(0,29)+"...</span>"
	}else{
		return "<span class='tdClick'>"+value+"</span>"
	}
}
/*
 * table 点击标题弹出查看/办理页面
 */
window.onTdClickTab = {
	 'click .tdClick': function (e, value, row, index) {
			//双击查看用户信息
			$.ajax({
				type : "POST",
				url : "actTypeController/findArcTypeInfoById",
				data : {
					"Id" : row.id
				},
				success : function(data) {
					var imgUrl ="uploader/uploadfile?pic=";
					var viewModel = $("#viewModal");
					viewModel.modal('show');
					// 填充值给span标签
					var viewName = document.getElementById("viewName");
					viewName.innerHTML = data[0].typeName;
					var viewTime = document.getElementById("viewTime");
					viewTime.innerHTML = data[0].creTime;
					var viewUser = document.getElementById("viewUser");
					var creUser;
					if(data[0].userName==null){
						creUser="";
					}else{
						creUser=data[0].userName;
					}
					viewUser.innerHTML = creUser;
					var viewRemark = document.getElementById("viewRemark");
					var remark ="";
					if(data[0].remark==null){
					}else{
						remark=data[0].remark;
					}
					viewRemark.innerHTML = remark;
					
				},
				error : function(data) {
					layerAlert("error:" + data.responseText);
				}
			});
	 }
}
function searchCommon() {
	validateData();
	//普通查询清空高级查询条件
	$("#search_form")[0].reset();
	var typeName = $("#input-word").val();
	if (typeName == '请输入类型名称') {
		typeName = "";
	}else{
		typeName = typeName
	}
	$("#typeList").bootstrapTable('refresh',{
		url : "actTypeController/findAllArcTypeData",
		query:{
			typeName :$.trim(typeName),
			typeId:$('#typeId').val()
		}
	});
}
/**
 * 重置条件表单
 */
function clearForm(){
	 $('#advSearchModal').modal('hide');
	document.getElementById("search_form").reset();
	searchData();
}