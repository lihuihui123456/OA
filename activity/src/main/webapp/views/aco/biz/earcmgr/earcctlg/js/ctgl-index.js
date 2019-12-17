var selectionIds = [];//记忆选中
var ctlgName;
var ctlgId ="";
$(document).ready(function() {
	/**
	 * 获取档案目录分类构建树
	 */
	var setting = {
		data : {
			simpleData : {
				enable : true,
				idKey : "id",
				pIdKey : "pId",
				rootPId : 0
			}
		},
		callback : {
			onClick : zTreeOnClick
		}
	};
	
	$.fn.zTree.init($("#ctlgTree"), setting, treeList);
	zTree = $.fn.zTree.getZTreeObj("ctlgTree");
	//展开所有节点
	zTree.expandAll(true);
	//展开指定节点
/*	var nodes = zTree.getNodesByParam("pId", "0", null);
	zTree.expandNode(nodes[0], true, false , true);*/
	/**
	 * 添加按钮事件
	 */
	$('#btn_new').click(function() {
		$("#updateOradd").html("新增");
		$("#EARC_CTLG_NAME").attr("readonly",false);
		$("#PARENT_ID").attr("disabled",false);
		$("#saveBtn").css("display","");
		$("#resetBtn").css("display","");
		
		var date = new Date();
		var modal = $("#ctlgModal");
		modal.modal('show');
		$("#CREATE_TIME").val(date.Format("yyyy-MM-dd hh:mm:ss"));
		$("#EARC_CTLG_NAME").val("");
		var parentId= $("#parentId").val();
		//保留父节点id和节点名称初始值
		$("#PARENTID").val(parentId);
		$("#EARCCTLGNAME").val("");
		initParentOptin(parentId,"");
		
	});
	
	/**
	 * 修改按钮事件
	 */
	$('#btn_edit').click(function() {
		var selectRow = $("#ctlgList").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return;
		}else if(selectRow.length > 1) {
			layerAlert("请选择一条记录操作！");
			return;
		}else{
			$.ajax({
				type : "post",
				url : "earcCtlgController/findCtlgInfoByCtlgId",
				data : {ctlgId:selectRow[0].ID_},
				dataType: "json",  
				success : function(data) {
					if(data!=null || date!=""){
						$("#updateOradd").html("修改");
						$("#EARC_CTLG_NAME").attr("readonly",false);
						$("#PARENT_ID").attr("disabled",false);
						$("#saveBtn").css("display","");
						$("#resetBtn").css("display","");
						
						$("#ID_").val(data.ID_);
						$("#CREATE_USER_NAME").val(data.CREATE_USER_NAME);
						$("#CREATE_TIME").val(data.CREATE_TIME);
						$("#EARC_CTLG_NAME").val(data.EARC_CTLG_NAME);
						initParentOptin(data.PARENT_ID,data.ID_);
						//保留父节点id和节点名称初始值
						$("#PARENTID").val(data.PARENT_ID);
						$("#EARCCTLGNAME").val(data.EARC_CTLG_NAME);
						var modal = $("#ctlgModal");
						modal.modal('show');
					}else{
						layerAlert("修改失败,请联系管理员!");
					}
				},
				error : function(data) {
				}
			});
		}
	});
	
	/**
	 * 删除按钮事件
	 */
	$('#btn_delete').click(function() {
		var selectRow = $("#ctlgList").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return;
		}
		var ids = '';
		$(selectRow).each(function(index) {
			ids = ids + selectRow[index].ID_ + ",";
		});
		ids = ids.substring(0, ids.length - 1);
		layer.confirm('确定删除吗？', {
			btn : [ '是', '否' ]
			// 按钮
			}, function(index) {
				$.ajax({
					type : "post",
					url : "earcCtlgController/isCtlgParent",
					data : {Ids:ids},
					dataType: "json",  
					success : function(data) {
						if(data=='0'){
							delCtlgDataById(ids);
						}else{
							layerAlert('所选操作项,是父目录,请先删除子目录!');
						}
					},
					error : function(data) {
					}
				});
				layer.close(index);
			}, function() {
				return;
		});
	});
	/**
	 * 重置按钮
	 */
	$('#resetBtn').click(function() {
		var parentId=$("#PARENTID").val();
		var EARCCTLGNAME=$("#EARCCTLGNAME").val();		
		$("#EARC_CTLG_NAME").val(EARCCTLGNAME);
		initParentOptin(parentId);
	});
	/**
	 * 列表回车触发搜索
	 */
	$('#input-word').bind('keypress', function (event) {
	    if (event.keyCode == "13") {
	    	search();
	       return false ;   
	    } 
	});
	
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
             if(ID_!=-1){  
                 array.splice(index, 1);  
             }  
         });  
        return array;  
	};    
	var _ = {"union":union,"difference":difference};
	/**
	 * bootstrap-table 记忆选中 
	 */
	$('#ctlgList').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
		var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
	        return row.ID_;  
	    });  
	    func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	    selectionIds = _[func](selectionIds, ids);   
	});
	 initCtlgTableData();
});

function initCtlgTableData(){
	$('#ctlgList').bootstrapTable({
		url : 'earcCtlgController/findArcCtlgDataByCtlgId', // 请求后台的URL（*）
        method : 'get',
		striped : true,
		cache : false,
		pagination : true,
		sortable : true,
		sortOrder : "desc",
		queryParams : function(params) {
			var temp = {
				pageSize : params.limit, // 页面大小
				pageNum : params.offset, // 页码
				ctlgId : ctlgId,
				ctlgName : ctlgName,
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
		uniqueId : "ID_",
		showToggle : false,
		cardView : false,
		detailView : false,
		maintainSelected:true,
		responseHandler:function(res){
        	$.each(res.rows, function (i, row) {
        		 row.checkStatus  = $.inArray(row.ID_, selectionIds) !== -1;
        		});
        		return res;	
        },
		columns : [ {
			checkbox : true,
			align : 'center',
			valign: 'middle',
			field: 'checkStatus'
		}, {
			field : 'index',
			title : '序号',
			valign : 'middle',
			width : '5%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'EARC_CTLG_NAME',
			title : '类型名称',
			align : 'left',
			valign : 'middle',
			sortable : true
		}, {
			field : 'CREATE_USER_NAME',
			title : '创建人',
			align : 'left',
			valign : 'middle',
			sortable : true
		}, {
			field : 'CREATE_TIME',
			title : '创建时间',
			align : 'center',
			cellStyle : cellStyle,
			valign : 'middle',
			sortable : true
		}, {
			field : 'operate',
			title : '操作',
			halign : 'center',
			width : '7%',
			align : 'center',
/*			events : operateEvents,
*/			formatter : operateFormatter
		} ],
		onClickRow : function(row, tr) {
			$.ajax({
				type : "post",
				url : "earcCtlgController/findCtlgInfoByCtlgId",
				data : {ctlgId:row.ID_},
				dataType: "json",  
				success : function(data) {
					if(data!=null || date!=""){
						$("#updateOradd").html("查看");
						$("#ID_").val(data.ID_);
						$("#CREATE_USER_NAME").val(data.CREATE_USER_NAME);
						$("#CREATE_TIME").val(data.CREATE_TIME);
						$("#EARC_CTLG_NAME").val(data.EARC_CTLG_NAME);
						initParentOptin(data.PARENT_ID,data.ID_);
						$("#EARC_CTLG_NAME").prop("readonly","readonly");
						$("#PARENT_ID").prop("disabled","disabled");
						$("#saveBtn").css("display","none");
						$("#resetBtn").css("display","none");
						var modal = $("#ctlgModal");
						modal.modal('show');
					}else{
						layerAlert("查看失败,请联系管理员!");
					}
				},
				error : function(data) {
				}
			});
		}
	});
}
/**
 * 初始化父类目录,如果id修改时不能选择当前节点作为父节点
 */
function initParentOptin(parentId,id) {
	$.ajax({
		type : "POST",
		url : "earcCtlgController/findCtlgDataListByUserId",
		data:{id:id},
		success : function(data) {
			var select = document.getElementById("PARENT_ID");
			select.options.length = 0; // 把select对象的所有option清除掉
			for (var i = 0; i < data.length; i++) {
				if(id!=""||id!=null){
					if(id==data[i].id){
						continue;
					}
				}
				var op = document.createElement("option"); // 新建OPTION (op)
				op.setAttribute("value", data[i].id); // 设置OPTION的 VALUE
				op.appendChild(document.createTextNode(data[i].name)); // 设置OPTION的
				select.appendChild(op); // 为SELECT 新建一 OPTION(op)
			}
			if(parentId!=""){
				$("#PARENT_ID option[value='"+parentId+"']").attr("selected","selected");  
			}else{
				$("#PARENT_ID option[text='档案目录']").attr("selected","selected");  
			}
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});
}

/**
 * 搜索方法
 */
function search() {
	var ctlgName = $("#input-word").val();
	if(ctlgName == '请输入目录名称查询'){
		ctlgName="";
	}else{
		$("#ctlgList").bootstrapTable('refresh', {
			url : "earcCtlgController/findArcCtlgDataByCtlgId",
			query : {
				ctlgName : $.trim(ctlgName),
				ctlgId : ctlgId,
			}
		});
	}
	$("#input-word").val('请输入目录名称查询');
}
function saveCtlgInfo() {
	var ctlgName = $("#EARC_CTLG_NAME").val();
	if (ctlgName == "" || ctlgName == "请输入子类名称") {
		layerAlert("请输入子类名称!");
	} else {
		$.ajax({
			type : "POST",
			url : "earcCtlgController/doAddCtlgInfo",
			dataType : 'json',
			data : $('#ff').serialize(),
			success : function(data) {
				refreshTable('ctlgList','earcCtlgController/findArcCtlgDataByCtlgId');
				makeTree();
				$("#ff")[0].reset();
				var modal = $("#ctlgModal");
				modal.modal('hide');
			},
			error : function(data) {

			}
		});
	}
}
/**
 * 目录树单击方法
 */
function zTreeOnClick(event, treeId, treeNode) {
	ctlgId=treeNode.id;
	$("#parentId").val(treeNode.id);
	$("#ctlgList").bootstrapTable('refresh', {
		url : "earcCtlgController/findArcCtlgDataByCtlgId",
		query : {
			ctlgId : treeNode.id,
		}
	});
}

function writeObj(obj) {
	var description = "";
	for ( var i in obj) {
		var property = obj[i];
		description += i + " = " + property + "\n";
	}
	alert(description);
}


function delCtlgDataById(Ids){
	$.ajax({
		type : "POST",
		url : "earcCtlgController/doDelCtlgDataByCtlgId",
		data : {
			"Ids" : Ids
		},
		success : function(data) {
			if(data=='0'){
				layerAlert("删除成功!");
				refreshTable('ctlgList','earcCtlgController/findArcCtlgDataByCtlgId');
				makeTree()
			}
		},
		error : function(data) {
			refreshTable('ctlgList','earcCtlgController/findArcCtlgDataByCtlgId');
		}
	});
}
/**
 * 操作格式化
 * 
 * @param value
 * @param row
 * @param index
 * @returns
 */
function operateFormatter(value, row, index) {
	return '<span"> <img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/up.png" onclick=sortOrderBy("'+row.ID_+'","up")><img style="cursor:pointer" src="static/cap/plugins/easyui/themes/icons/down.png" onclick=sortOrderBy("'+row.ID_+'","down") > </span>';
}
function sortOrderBy(id,orderBy){
	$.ajax({
		type : "POST",
		url : "earcCtlgController/orderByTypeBase",
		data : {
			"upOrdown":orderBy,
			"id" :id,
			
		},
		success : function(data) {
			if(data=='true'){
				refreshTable('ctlgList','earcCtlgController/findArcCtlgDataByCtlgId');
				makeTree()
				layerAlert("移动成功！");
			}
			else if(data=='0'){
				layerAlert("无法上移！");	
			}else if(data=='1'){
				layerAlert("无法下移！");
			}
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});	
}
/*
 * 操作方法
 */
window.operateEvents = {
	'click .fordetails' : function(e, value, row, index) {
		stopPropagation();
		var doc_type = row.BIZ_TYPE_;
		var bizid = row.bizid;
		var procInstId = row.proc_inst_id_;
		var options = {
			"text" : "办理详情",
			"id" : "bizinfodetail" + bizid + "_dbsx",
			"href" : "bpmRuBizInfoController/toDealDetialPage?procInstId="
					+ procInstId,
			"pid" : window,
			"isDelete" : true,
			"isReturn" : true,
			"isRefresh" : true
		};
		window.parent.createTab(options);
	}
};

/**
 * 日期格式化
 */
Date.prototype.Format = function(fmt) { // author: meizz
	var o = {
		"M+" : this.getMonth() + 1, // 月份
		"d+" : this.getDate(), // 日
		"h+" : this.getHours(), // 小时
		"m+" : this.getMinutes(), // 分
		"s+" : this.getSeconds(), // 秒
		"q+" : Math.floor((this.getMonth() + 3) / 3), // 季度
		"S" : this.getMilliseconds()
	// 毫秒
	};
	if (/(y+)/.test(fmt))
		fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "")
				.substr(4 - RegExp.$1.length));
	for ( var k in o)
		if (new RegExp("(" + k + ")").test(fmt))
			fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k])
					: (("00" + o[k]).substr(("" + o[k]).length)));
	return fmt;
}
function makeTree(){
	$.ajax({
		type : "POST",
		url : "earcCtlgController/getTreeList",
		dataType: "json",
		success : function(data) {
			/**
			 * 获取档案目录分类构建树
			 */
			var setting = {
				data : {
					simpleData : {
						enable : true,
						idKey : "id",
						pIdKey : "pId",
						rootPId : 0
					}
				},
				callback : {
					onClick : zTreeOnClick
				}
			};			
			$.fn.zTree.init($("#ctlgTree"), setting, data);
			zTree = $.fn.zTree.getZTreeObj("ctlgTree");
			//展开所有节点
			zTree.expandAll(true);
		},
		error : function(data) {
			layerAlert("error:" + data.responseText);
		}
	});	
}