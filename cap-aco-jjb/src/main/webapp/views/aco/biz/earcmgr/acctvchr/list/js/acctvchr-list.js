//翻页选中数组
var zTree;
var selectionIds = [];
$(function() {
	
	/**
	 * 获取档案目录分类构建树
	 */
	var setting = {
		async: {
			enable: true,
			url: "earcController/findZtreeListByUserId"
		},
		data: {
			simpleData: {
				enable: true,
				idKey: "id",
				pIdKey: "pId",
				rootPId: 0
			}
		},
		check: {
			enable: true,
			chkStyle: "radio",
			radioType: "all"
		},
		callback : {
			 onClick: function (e, treeId, treeNode, clickFlag) {   
                 zTree.checkNode(treeNode, !treeNode.checked, true);   
                 ctlgId=treeNode.id;
             	 $("#parentId").val(treeNode.id);
             }, 
			 onExpand: onExpand,
			 beforeExpand: beforeExpand //节点展开前的事件
		}
	};
	
	initTable();
	
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
	$('#earcTable').on('check.bs.table check-all.bs.table uncheck.bs.table uncheck-all.bs.table', function (e, rows) {  
		var ids = $.map(!$.isArray(rows) ? [rows] : rows, function (row) {  
			return row.ID_;  
		});  
	     func = $.inArray(e.type, ['check', 'check-all']) > -1 ? 'union' : 'difference';  
	     selectionIds = _[func](selectionIds, ids);   
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
	 * 高级搜索方法
	 */
	$("#advSearch").click(function(){
		if($("#advStartDate").val() != "" && $("#advEndDate").val() != "") {
			if($("#advEndDate").val() <= $("#advStartDate").val()) {
				layer.msg("结束时间必须大于开始时间！");
				return;
			}
		}
		if($("#advSendStartTime").val() != "" && $("#advSendEndTime").val() != "") {
			if($("#advSendEndTime").val() <= $("#advSendStartTime").val()) {
				layer.msg("结束时间必须大于开始时间！");
				return;
			}
		}
		$("#earcTable").bootstrapTable('refresh',{
			url : "earcController/findEarcAcctVchrInfo",
			query:{
				queryParams : $("#ff").serialize(),
			}
		});
		
		$("#advSearchModal").modal('hide');
	});
	
	/**
	 * 高级搜索重置
	 */
	$("#advSearchCalendar").click(function(){
		document.getElementById("ff").reset();
		$("#draftUserId_").val('');
		$("#earcTable").bootstrapTable('refresh',{
			url : "earcController/findEarcAcctVchrInfo",
			query:{
				queryParams : $("#ff").serialize(),
			}
		});
		$("#advSearchModal").modal('hide');
	});
	
	/**
	 * 归档按钮事件
	 */
	$('#file_btn').click(function(){
		var selects = $("#earcTable").bootstrapTable('getSelections');  
		if(selects.length==0){
			layerAlert("请选择一条数据！");
			return;
		}else if(selects[0].EARC_STATE==2){
			layerAlert("档案已作废,请重新选择！");
		}else if(selects[0].EARC_STATE==4){
			layerAlert("档案已到期,请重新选择！");
		}else if(selects[0].EARC_STATE==3){
			layerAlert("档案已销毁,请重新选择！");
		}else if(selects[0].EARC_STATE==1){
			layerAlert("档案已归档,请重新选择！");
		}else if(selects.length==1){
			var modal = $("#acctvchrModal");
			modal.modal('show');		
			$.fn.zTree.init($("#filingtree"), setting);
			zTree = $.fn.zTree.getZTreeObj("filingtree");
			var nodes = zTree.getNodesByParam("pId", "0", null);
			//展开指定节点
			zTree.expandNode(nodes[0], true, false , true);
			
			$("#earcId").val(selects[0].ID_);
		}
	});

	/**
	 * 追加归档按钮事件
	 */
	$('#addFile_btn').click(function(){
		var selects = $("#earcTable").bootstrapTable('getSelections');  
		if(selects.length==0){
			layerAlert("请选择一条数据！");
			return;
		}else if(selects[0].EARC_STATE!=1){
			layerAlert("请选择已归档档案进行追加归档!");
		}else{
			$.ajax({
				type : "POST",
				url : "earcController/updateEarcStateByEarcId",
				dataType:'text',
				data:{
					"earcId":selects[0].ID_,
					"earcState":"0"
				},
				success : function(data) {
					if(data=="true"){
						layerAlert("追加归档成功!");
					}else{
						layerAlert("追加归档失败!");
					}
					refreshTable('earcTable','earcController/findEarcAcctVchrInfo');
				},
				error : function(data) {
					refreshTable('earcTable','earcController/findEarcAcctVchrInfo');
				}
			});
			
		}
	});
	
	
});

function qxButton(){
	$("#advSearchModal").hide();	
}
var acctVchrName = "";
/**
 * 表格数据初始化
 */
var solId;
function initTable() {
	$('#earcTable').bootstrapTable({
		url : 'earcController/findEarcAcctVchrInfo', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		toolbar : '', // 工具按钮用哪个容器
		striped : true, // 是否显示行间隔色
		cache : false, // 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : true, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
				pageNum:params.offset, // 页码
				pageSize:params.limit, // 页面大小
				solId:solId,//业务模块
				acctVchrName:$.trim(acctVchrName),
				sortName:this.sortName,
				sortOrder:this.sortOrder,
				queryParams : $("#ff").serialize(),
			};
			acctVchrName="";
			return temp;
		},// 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		strictSearch : true,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "ID_", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		singleSelect : true,
		maintainSelected:true,
		responseHandler:function(res){
			$.each(res.rows, function (i, row) {
				 row.checkStatus  = $.inArray(row.ID_, selectionIds) !== -1;
				});
				return res;	
		},
		columns : [ {
			checkbox : true,
			valign: 'middle',
			halign: 'center',
			field: 'checkStatus'
		}, {
			field : 'index',
			title : '序号',
			valign : 'middle',
			width: '5%',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'BIZ_TITLE_',
			title : '题名',
			align : 'left',
			valign : 'middle',
			sortable : true,
			/*events: onTdClickTab,*/
            formatter: onTdClickTabFormatter
		}, {
			field : 'CREATE_USER_ID_',
			title : '责任人',
			align : 'left',
			valign : 'middle',
			width: '20%',
			sortable : true,
		}, {
			field : 'SECURITY_LEVEL',
			title : '密级',
			cellStyle : cellStyle,
			align : 'center',
			valign : 'middle',
			sortable : true,
			formatter : function(val, row) {
				 if(row.SECURITY_LEVEL=='0'){
					 return '<span class="label label-success">&nbsp;低&nbsp;&nbsp;</span>';
				 }else if(row.SECURITY_LEVEL=='1'){
					 return '<span class="label label-warning">&nbsp;中&nbsp;&nbsp;</span>';
				 }else if(row.SECURITY_LEVEL=='2') {
					 return '<span class="label label-danger">&nbsp;高&nbsp;&nbsp;</span>';
				 }else {
					 return '--';
				 }
			}
		}, {
			field : 'TERM',
			title : '保管期限',
			align : 'center',
			valign : 'middle',
			cellStyle : cellStyle,
			sortable : true,
			formatter : function(val, row) {
				 if(row.SECURITY_LEVEL=='0'){
					 return '<span class="label label-success">&nbsp;永久&nbsp;&nbsp;</span>';
				 }else if(row.SECURITY_LEVEL=='15'){
					 return '<span class="label label-warning">&nbsp;15年&nbsp;&nbsp;</span>';
				 }else if(row.SECURITY_LEVEL=='25') {
					 return '<span class="label label-danger">&nbsp;25年&nbsp;&nbsp;</span>';
				 }else {
					 return '--';
				 }
			}
		}, {
			field : 'OPER_TIME',
			title : '归档日期',
			cellStyle : cellStyle,
			align : 'center',
			valign : 'middle',
			sortable : true
		}, {
			field : 'EARC_STATE',
			title : '档案状态',
			align : 'center',
			cellStyle : cellStyle,
			valign : 'middle',
			sortable : true,
			  formatter : function(val, row) {
				 if(row.EARC_STATE=='0'){
					 return '<span class="label label-success">&nbsp;未归档&nbsp;&nbsp;</span>';
				 }else if(row.EARC_STATE=='1'){
					 return '<span class="label label-warning">&nbsp;已归档&nbsp;&nbsp;</span>';
				 }else if(row.EARC_STATE=='2') {
					 return '<span class="label label-danger">&nbsp;已作废&nbsp;&nbsp;</span>';
				 }else if(row.EARC_STATE=='3') {
					 return '<span class="label label-danger">&nbsp;已销毁&nbsp;&nbsp;</span>';
				 }else if(row.EARC_STATE=='4') {
					 return '<span class="label label-danger">&nbsp;已到期&nbsp;&nbsp;</span>';
				 }else {
					 return '--';
				 }
				}
		}],
		onClickRow:function(row,tr){
			var tname = "编辑";
			var status = "2";
			if(row.EARC_STATE!='0'){
				tname = '查看';
				status="4";
			}
			var bizId = row.ID_;
			var operateUrl = "bizRunController/getBizOperate?solId="+ row.SOL_ID_  + "&bizId=" + bizId + "&status="+status;
			var options = {
				"text" : tname,
				"id" : "view"+bizId,
				"href" : operateUrl,
				"pid" : window.parent,
				"isDelete":true,
				"isReturn":true,
				"isRefresh":true
			};
	 		window.parent.parent.createTab(options);
		}
	});
}


/**
 *  查询方法
 */
function search() {
	$("#advTitle").val('');
	var title = $.trim($("#input-word").val());
	if (title == '请输入标题查询') {
		title = "";
	}else{
		title = window.encodeURI(window.encodeURI(title));
	}
	$("#earcTable").bootstrapTable('refresh',{
		url : "earcController/findEarcAcctVchrInfo",
		query:{
			acctVchrName : title
		}
	});
}




/**
 * table序号格式化
 * @param value
 * @param row
 * @param index
 * @returns
 */
function indexFormatter(value, row, index) {
	return index + 1;
 }

/**
 * 高级搜索
 */
function showOrHide(){
	var display =$('#advSearchModal').css('display');
	if(display == "none") {
		$("#advSearchModal").show();
	}else {
		$("#advSearchModal").hide();
	}
}

/**
 * 目录树单击方法
 */
function zTreeOnClick(event, treeId, treeNode) {
	ctlgId=treeNode.id;
	$("#parentId").val(treeNode.id);

}
var curExpandNode = null;
function beforeExpand(treeId, treeNode) {
	var pNode = curExpandNode ? curExpandNode.getParentNode():null;
	var treeNodeP = treeNode.parentTId ? treeNode.getParentNode():null;
	for(var i=0, l=!treeNodeP ? 0:treeNodeP.children.length; i<l; i++ ) {
		if (treeNode !== treeNodeP.children[i]) {
			zTree.expandNode(treeNodeP.children[i], false);
		}
	}
	while (pNode) {
		if (pNode === treeNode) {
			break;
		}
		pNode = pNode.getParentNode();
	}
	if (!pNode) {
		singlePath(treeNode);
	}

}
function singlePath(newNode) {
	if (newNode === curExpandNode) return;
       var  rootNodes, tmpRoot, tmpTId, i, j, n;

    if (!curExpandNode) {
        tmpRoot = newNode;
        while (tmpRoot) {
            tmpTId = tmpRoot.tId;
            tmpRoot = tmpRoot.getParentNode();
        }
        rootNodes = zTree.getNodes();
        for (i=0, j=rootNodes.length; i<j; i++) {
            n = rootNodes[i];
            if (n.tId != tmpTId) {
                zTree.expandNode(n, false);
            }
        }
    } else if (curExpandNode && curExpandNode.open) {
		if (newNode.parentTId === curExpandNode.parentTId) {
			zTree.expandNode(curExpandNode, false);
		} else {
			var newParents = [];
			while (newNode) {
				newNode = newNode.getParentNode();
				if (newNode === curExpandNode) {
					newParents = null;
					break;
				} else if (newNode) {
					newParents.push(newNode);
				}
			}
			if (newParents!=null) {
				var oldNode = curExpandNode;
				var oldParents = [];
				while (oldNode) {
					oldNode = oldNode.getParentNode();
					if (oldNode) {
						oldParents.push(oldNode);
					}
				}
				if (newParents.length>0) {
					zTree.expandNode(oldParents[Math.abs(oldParents.length-newParents.length)-1], false);
				} else {
					zTree.expandNode(oldParents[oldParents.length-1], false);
				}
			}
		}
	}
	curExpandNode = newNode;
}

function onExpand(event, treeId, treeNode) {
	curExpandNode = treeNode;
}
/**
 * 档案归档
 */
function saveTreeNodeId(){
	var nodes = zTree.getCheckedNodes(true);
	if(nodes!=""){
		var ctlgId = nodes[0].id;
		zTree.checkAllNodes(false);
		var earcId = $("#earcId").val();
		$.ajax({
			type : "POST",
			url : "earcController/earcFileByCtlgId",
			async:false,
			dataType:'text',
			data:{
				"earcId":earcId,
				"ctlgId":ctlgId
			},
			success : function(data) {
				if(data=="true"){
					layerAlert("归档成功!");
				}else{
					layerAlert("归档失败!");
				}
				var modal = $("#acctvchrModal");
				modal.modal('hide');	
				refreshTable('earcTable','earcController/findEarcAcctVchrInfo');
			},
			error : function(data) {
				refreshTable('earcTable','earcController/findEarcAcctVchrInfo');
			}
		});
		
	}else{
		layerAlert("请选择档案分类目录进行归档!");
	}
	
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
	if(value!=null){
		if(value.length>25){
			return "<span class='tdClick' title='"+value+"'>"+value.substring(0,20)+"...</span>";
		}else{
			return "<span class='tdClick'>"+value+"</span>";
		}
	}else{
		return "<span class='tdClick'>-</span>"
	}
}


window.onTdClickTab = {'click .tdClick': function (e, value, row, index) {
		var tname = "编辑";
		var status = "2";
		if(row.EARC_STATE!='0'){
			tname = '查看';
			status="4";
		}
		var bizId = row.ID_;
		var operateUrl = "bizRunController/getBizOperate?solId="+ row.SOL_ID_  + "&bizId=" + bizId + "&status="+status;
		var options = {
			"text" : tname,
			"id" : "view"+bizId,
			"href" : operateUrl,
			"pid" : window.parent,
			"isDelete":true,
			"isReturn":true,
			"isRefresh":true
		};
 		window.parent.parent.createTab(options);
	 }
}

