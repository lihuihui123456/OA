<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>归档管理</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css"
	rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<link rel="stylesheet" type="text/css"
	href="${ctx}/views/aco/docmgt/css/zTreeRightClick.css" />
<script src="${ctx}/views/aco/docmgt/js/TreeRightClick.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/views/aco/docmgt/js/gdgl.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css"
	rel="stylesheet">
<link href="${ctx}/views/cap/bpm/solrun/css/navla.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<script type="text/javascript">
	var chooseNode = "";
	var unitFold="0000";
	var deptFold="3000";
	var mainFold="7000";
	var shareFold="6000";
	var doc_type = 1;
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
			onClick : zTreeOnClick,
			onRightClick : OnRightClick
		}

	};

	function zTreeOnClick(event, treeId, treeNode) {
		chooseNode = treeNode.id;
		$("#tapList2").bootstrapTable('refresh');
	}

	//增加节点
	function addTreeNode() {
		hideRMenu();
		$("#folder_name_").val("");
		$("#nodeModal").modal("show");
	}
	function modifyTreeNode() {
		hideRMenu();
		var id=zTree.getSelectedNodes()[0].ID_;
		if(id==mainFold){
			layerAlert("不能修改主目录！");
			return false;
		}
		var name_=zTree.getSelectedNodes()[0].name;
		$("#folder_name_m").val(name_);
		$("#nodeModalModify").modal("show");
	}
	function writeObj(obj){ 
		 var description = ""; 
		 for(var i in obj){ 
		 var property=obj[i]; 
		 description+=i+" = "+property+"\n"; 
		 } 
		 alert(description); 
		} 
	function modifyFolderInfo(){
		var id=checktreeId;
		var AjaxURL= "${ctx}/docmgt/modifyDocType";
		var name=$("#folder_name_m").val();
		if(name==null||name==""){
			layerAlert("名称不能为空！");
			return false;
		}
		$.ajax({
			type: "POST",
			url: "${ctx}/docmgt/doCheckRepat",
			data: {folderId:id,folderName:name},
			success: function (reId) {
				if(reId=='Y'){
					layerAlert("名称重复！");
					return false;
				}else{
					$.ajax({
						type: "POST",
						url: AjaxURL,
						data: {folderId:id,folderName:name},
						success: function () {
							 if (zTree.getSelectedNodes()[0]) {
							    	zTree.getSelectedNodes()[0].name=name;
							    	zTree.updateNode(zTree.getSelectedNodes()[0]);
							    }
							$("#nodeModalModify").modal("hide");
							 layer.msg("修改成功!",{icon:1});
						}
					});
				   
				}
			}
		});
		
	}
	//保存节点信息
	function saveFolderInfo(){
		$('#tapList2').bootstrapTable('refresh');
		var name=$("#folder_name_").val();
/* 		var id=zTree.getSelectedNodes()[0].ID_;
 */		
 		var id=checktreeId;
 		var AjaxURL= "${ctx}/docmgt/addDocType";
		var flag=false;
		var folderId='';
		if(name==null||name==""){
			layerAlert("名称不能为空！");
			return false;
		}
		$.ajax({
			type: "POST",
			url: "${ctx}/docmgt/doCheckName",
			data: {folderId:id,folderName:name},
			success: function (reId) {
				if(reId=='Y'){
					layerAlert("名称重复！");
					return false;
				}else{
					$.ajax({
						type: "POST",
						url: AjaxURL,
						data: {parentFolderId:id,folderName:name},
						success: function (reId) {
							id=reId;
							if(name!=""&&name!=null){
								var newNode = {name:name,id:id};
								if (zTree.getSelectedNodes()[0]) {
									newNode.checked = zTree.getSelectedNodes()[0].checked;
									zTree.addNodes(zTree.getSelectedNodes()[0], newNode);
								} else {
									zTree.addNodes(null, newNode);
								}
							}
							$("#nodeModal").modal("hide");
							layer.msg("新增成功!",{icon:1});
						},
						error: function(){
						    alert(arguments[1]);
						}
					});
				}
			}
		});		
	}
	function deleteTreeNodeBefore(){
		hideRMenu();
		var id=checktreeId;
		if(id==mainFold||id==shareFold||id==unitFold||id==deptFold){
			layerAlert("不能删除主目录！");
			return false;
		}
		$.ajax({
			type: "POST",
			url: "${ctx}/docmgt/doCheckDel",
			data: {folderId:id},
			success: function (reId) {
				if(reId=='Y'){
					layerAlert("包含子节点,不能删除！");
					return false;
				}else{
				$.ajax({
			type: "POST",
			url: "${ctx}/docmgt/doCheckDelete",
			data: {folderId:id},
			success: function (reId) {
				if(reId=='Y'){
					layerAlert("包含归档文件,不能删除！");
					return false;
				}else{
					layer.confirm('确定删除？',{
						 btn: ['确定','取消']
					},function(index){
						deleteTreeNode(id);
						layer.close(index);
					});
				}
			}
		});
				}
			}
		});
	}

	var zTree, rMenu,rMenuForRole;
	//删除节点
	function deleteTreeNode(id){
		var AjaxURL= "${ctx}/docmgt/deleteDocType";
		$.ajax({
			type: "POST",
			url: AjaxURL,
			data: {folderId:id},
			success: function () {
				
			}
		});
		
	    //选中节点  
	    var nodes = zTree.getSelectedNodes();  
		var l;
	    for (var i=0,l=nodes.length; i < l; i++)   
	    {  
	        //删除选中的节点  
	        zTree.removeNode(nodes[i]);  
	    }  
		$("#nodeModal").modal("hide");
		layer.msg("删除节点成功!",{icon:1});
	}

	/* var zTree, rMenu; */
	$(document).ready(function() {
		//ztree初始化
			$.fn.zTree.init($("#folderTree"), setting,${treeList});
		 zTree = $.fn.zTree.getZTreeObj("folderTree");
		 var nodes = zTree.getNodes();
                     for (var i = 0; i < nodes.length; i++) { //设置节点展开
                          zTree.expandNode(nodes[i], true, false, false);
                     }
		 rMenu = $("#rMenu");
		 rMenuForRole=$("#rMenuForRole");
		//bootstrapTable初始化
		//已归档
		$('#tapList2').bootstrapTable(
			{
				url : '${ctx}/docmgt/findHasBelong',
				method : 'get', // 请求方式（*）
				toolbar : '#toolBar', // 工具按钮用哪个容器
				striped : true, // 是否显示行间隔色
				cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
				pagination : true, // 是否显示分页（*）
				sortable : true, // 是否启用排序
				sortOrder : "DESC", // 排序方式
				queryParams : function(params) {
					var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
						pageSize : params.limit, // 页面大小
						pageNum : params.offset, // 页码
						query : getmyArr2(),
						id: chooseNode,
						sortName : this.sortName,
						sortOrder : this.sortOrder
					};
					return temp;
				}, // 传递参数（*）
				sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
				pageNumber : 1, // 初始化加载第一页，默认第一页
				search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
				//strictSearch : true,
				showColumns : false, // 是否显示所有的列
				showRefresh : false, // 是否显示刷新按钮
				minimumCountColumns : 2, // 最少允许的列数
				clickToSelect : true, // 是否启用点击选中行
				uniqueId : "ID_", // 每一行的唯一标识，一般为主键列
				showToggle : false, // 是否显示详细视图和列表视图的切换按钮
				cardView : false, // 是否显示详细视图
				detailView : false, // 是否显示父子表
				columns : [ {
					checkbox : true,
					width : '5%'
				},{
					field : 'ID_',
					title : 'ID_',
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
				}, /* {
					field : 'SERIAL_NUMBER_',
					title : '流水号',
					valign: 'middle',
					align : 'center',
					sortable : true,
					visible : false
				}, */ {
					field : 'BIZ_TITLE_',
					title : '文件标题',
					align:'left',
					valign: 'middle',
					width : '40%',
					sortable : true,
					/* events: onTdClickTab, */
		            formatter: onTdClickTabFormatter
				}, /* {
					field : 'URGENCY_',
					title : '紧急程度',
					align : 'left',
					valign: 'middle',
					width : '12%',
					sortable : true,
					formatter:function(value,row){
						if (value == "1"){
							return '<span class="label label-success">平件</span>';
						}else if (value == "2"){
							return '<span class="label label-warning">急件</span>';
						}else if(value == "3"){
							return '<span class="label label-danger">特急</span>';
						}
					}
				}, */ {
					field : 'USER_NAME',
					title : '拟稿人',
					valign: 'middle',
					width : '8%',
					sortable : true,
					align : 'left'
				}, {
					field : 'CREATE_TIME_',
					title : '拟稿日期',
					align : 'center',
					width : '11%',
					sortable : true,
					valign: 'middle',
					cellStyle : cellStyle,
		 			formatter:function(value,row){
		 				if (value == null){
							return '-';
						}else{
							return value.substring(0,10);

						}			
				}
				}, /* {
					field : 'STATE_',
					title : '办理状态',
					align : 'left',
					valign: 'middle',
					width : '12%',
					sortable : true,
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
				}, */ {
					field : 'PLACE_TIME',
					title : '归档时间',
					valign: 'middle',
					cellStyle : cellStyle,
					sortable : true,
					width : '11%',
					align : 'center',
		 			formatter:function(value,row){
		 				if (value == null){
							return '-';
						}else{
							return value.substring(0,10);

						}			
				}
				} ],
				onClickRow : function (row, obj) {
					var bizid=row.bizid;
					var solId=row.SOL_ID_;
		     		var procInstId = row.PROC_INST_ID_;
		     		var tname = "查看";
		     		var status = "4";
		     		/* if(procInstId!=null&&procInstId!="") {
		     			tname = "查看";
		     			status = "4";
		     		} */
		     		var operateUrl = "bizRunController/getBizOperate?solId="+ solId  + "&bizId=" + bizid + "&status=" + status;
		     		var options = {
		     			"text" : tname,
		     			"id" : "view"+bizid,
		     			"href" : operateUrl,
		     			"pid" : window,
		     			"isDelete":true,
		     			"isReturn":true,
		     			"isRefresh":true
		     		};
		     		window.parent.parent.createTab(options);
		        }
			});
		});
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
			if(value.length>30){
					return "<span class='tdClick' title='"+value+"'>"+value.substring(0,29)+"...</span>"
			}else{
				return "<span class='tdClick'>"+value+"</span>"
			}
		}else{
		    return "<span class='tdClick'>-</span>"
		}
	}
	window.onTdClickTab = {
		 'click .tdClick': function (e, value, row, index) {
			var taskid = row.id_;
			var bizid=row.bizid;
			var proc_inst_id_=row.proc_inst_id_;
			var solId=row.solId;
			var options={
					"text":"查看原文",
					"id":"bizinfoview"+bizid,
					"href":"bpmRunController/view?bizId="+ bizid+"&&procInstId="+ proc_inst_id_ +"&&taskId="+taskid +"&&solId="+solId,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
		 }
	}
	function search() {
		/* 	if(username!=""){
		 username = $("#input-word").val();
		 } */
		$("#tapList2").bootstrapTable('refresh');
	}

	//查询公文的正文和附件信息
	function findMediaInfo() {
		var obj = $('#tapList2').bootstrapTable('getSelections');
		if (obj.length > 1 || obj.length == '') {
			layerAlert("请选择一条数据");
			return false;
		} else {
			var bizId = obj[0].id_;
			$('#myModal').modal('show');
			$('#media').attr("src",
					"${ctx}/docmgt/toLoadMediaList?bizId=" + bizId);
		}
	}

	function changeType() {
		doc_type = $("#changeType").val();
		$('#tapList2').bootstrapTable('refresh');
	}
	function makeSure(){
		 var bizid = getselectoption();
		if (bizid == "") {
			layerAlert("请选择数据");
		} else { 
		$('#DocTypeModal').modal('show');
		$('#group').attr("src","${ctx}/docmgt/enclosureFile");
	}
		}
	//归档
	function makesureFolder() {
	 	var bizid = getselectoption();
		if (bizid == "") {
			layerAlert("请选择数据");
		} else { 
			var id=document.getElementById("group").contentWindow.saveAttach();
			if(id==''){
				layerAlert("请选择归档类型");
			}else{
				var AjaxURL = "docmgt/doAddFolderInfo";
				$.ajax({
					type : "POST",
					url : AjaxURL,
					async : false,
					data : {
						bizid : bizid,
						id :id
					},
					success : function(data) {
						$("#tapList").bootstrapTable('refresh');
						$('#DocTypeModal').modal('hide');
						layerAlert("归档成功！");
					},
					error : function(data) {
						return false;
					}
				}); 	
			}
		}
	}
	var guidangIds = "";
	function getselectoption() {
		var obj = $('#tapList').bootstrapTable('getSelections');
		if (obj.length == '') {
			return "";
		} else {
			for (var i = 0; i < obj.length; i++) {
				if (i == 0) {
					guidangIds = obj[i].bizid;
				} else {
					guidangIds = guidangIds + "," + obj[i].bizid;
				}

			}
		}
		return guidangIds;
	}
	function getselectoption1() {
		var obj = $('#tapList2').bootstrapTable('getSelections');
		if (obj.length == '') {
			return "";
		} else {
			for (var i = 0; i < obj.length; i++) {
				if (i == 0) {
					guidangIds = obj[i].bizid;
				} else {
					guidangIds = guidangIds + "," + obj[i].bizid;
				}

			}
		}
		return guidangIds;
	}
	function selectDoc(flag) {
		var obj = $('#' + flag).bootstrapTable('getSelections');
		if (obj.length > 1 || obj.length == '') {
			layerAlert("请选择一条数据");
			return false;
		} else {
			var taskid = obj[0].ID_;
			var bizid = obj[0].bizid;
			//var proc_inst_id_=obj[0].proc_inst_id_;
			//var solId=obj[0].solId;
			var options = {
				"text" : "查看原文",
				"id" : "bizinfoview" + bizid,
				"href" : "bpmRunController/view?bizId=" + bizid
						+ "&&taskId=" + taskid,
				//"href":"bpmRuBizInfoController/view?bizId="+ bizid+"&&procInstId="+ proc_inst_id_ +"&&taskId="+taskid +"&&solId="+solId,
				"pid" : window,
				"isDelete" : true,
				"isReturn" : true,
				"isRefresh" : true
			};
			window.parent.createTab(options);
		}
	}
	function cancel(divName){
		$("#"+divName).modal("hide");
	}
	function restore(flag){
		var obj = $('#' + flag).bootstrapTable('getSelections');
		if (obj.length == '') {
			layerAlert("请选择数据还原");
			return false;
		}
		else{
			var bizid = getselectoption1();
			var AjaxURL = "docmgt/doDeleteFolderInfo";
			$.ajax({
				type : "POST",
				url : AjaxURL,
				async : false,
				data : {
					bizid : bizid,
					id :chooseNode
				},
				success : function(data) {
					$("#tapList2").bootstrapTable('refresh');
					layerAlert("还原成功！");
					
				},
				error : function(data) {
					return false;
				}
			}); 
		}
	}
</script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<style type="text/css">
.fixed-table-toolbar .bars{
	margin-top: 0px;
}
</style>
</head>
<!-- <body style="overflow-x:hidden;overflow-y:hidden;">
 --><body>
	<div id="rMenu">
		<ul>
			<li id="m_add" onclick="addTreeNode();">增加归档类型</li>
		</ul>
	</div>
		<div id="rMenuForRole">
		<ul>
		    <li id="m_add" onclick="addTreeNode();">增加归档类型</li>
			<li id="m_modify" onclick="modifyTreeNode();">修改归档类型</li>
			<li id="m_delete" onclick="deleteTreeNodeBefore();">删除归档类型</li>
		</ul>
	</div>
	<!-- Nav tabs -->
	<ul class="nav nav-tabs" role="tablist" id="myTab" style="margin-left: 10px;margin-right:10px;">
		<li role="presentation" class="active"><a href="#yibanjie"
			role="tab" data-toggle="tab" id="xx_fw">未归档</a></li>
		<li role="presentation"><a href="#yiguidang" role="tab"
			data-toggle="tab" id="xx_sw">已归档</a></li>
	</ul>

	<!-- Tab panes -->
	<div class="tab-content">
		<div role="tabpanel" class="tab-pane active" id="yibanjie">
			<div class="panel-body"
				style="padding-top:0px;padding-bottom:0px;border:0;" id="swxx_body">
				<div id=""
					style="border:1px solid #ddd; background:#fff; padding:10px; padding-right:10%;">
					<form class="form-horizontal" id="search_form"">
						<div class="form-group">
						<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">办结时间</label>
							<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
								<input type="text" id="djsj" name="djsj" value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
								<span
									style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
								<input type="text" id="djsj1" name="djsj1" value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
							</div>
							<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">公文标题</label>
							<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
								<input class="form-control input-sm" type="text" id="gwbt"
									name="gwbt">
							</div>						
						</div>
						<div style="margin-left: 45%;" class="btn-group">
							<!-- <button type="button" id="btn_search" class="btn btn-default"
								onclick="selectDoc('tapList');"><span class="fa fa-eye" aria-hidden="true"></span>查看</button> -->
							<button type="button" id="btn_search" class="btn btn-default"
								onclick="searchBJ();">查询</button>
							<button type="button" id="guidang" class="btn btn-default"
								onclick="makeSure()">归档</button>
							<button type="button" id="btn_reset" class="btn btn-default">重置</button>
							<!-- <button type="button" id="btn_excel" class="btn btn-default">导出Excel</button>
							<button type="button" id="btn_reset" class="btn btn-default">重置</button> -->
						</div>
						<div class="clearfix"></div>
					</form>
				</div>
				<form id="export" action="">
					<table id="tapList"></table>
				</form>
			</div>
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<div class="swiper-slide mask_layer"></div>
				</div>
			</div>
		</div>
		<div role="tabpanel" class="tab-pane" id="yiguidang">
			<div class="panel-body"
				style="padding-top:0px;padding-bottom:0px;border:0;" id="fwxx_body">
				<div class="container-fluid content" style="padding-right:0">
		<!-- start: Main Menu -->
		<div class="sidebar " Style="margin-left: 10px;" >
			<div class="sidebar-collapse" style="height:100%">
				<div id="sidebar-menu" class="sidebar-menu" style="height:100%;overflow:auto;" >
					<ul id="folderTree" class="ztree"></ul>
				</div>
			</div>
		</div>
		<!-- end: Main Menu -->
		<!-- start: Content -->
		<div class="main" id="main" style="padding-left: 190px;">
				<div id=""
					style="border:1px solid #ddd; background:#fff; padding:10px; padding-right:3%;">
					<form class="form-horizontal" id="search_form"">
						<div class="form-group">
							<label
								class="control-label col-lg-2 col-lg-2 col-md-2 col-sm-2 col-xs-2">归档时间</label>
							<div class="col-lg-5 col-md-5 col-sm-5 col-xs-5">
								<input type="text" id="djsj_fw" name="djsj_fw" value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
								<span
									style="display:inline-block;float:left; margin-top: 5px;width: 10%; text-align: center;">至</span>
								<input type="text" id="djsj1_fw" name="djsj1_fw" value=""
									class="form-control select input-sm"
									style="width:45%; float:left"
									onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />
							</div>
							<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">公文标题</label>
							<div class="col-lg-3  col-md-3 col-sm-3 col-xs-3">
								<input class="form-control input-sm" type="text" id="gwbt_fw"
									name="gwbt_fw">
							</div>					
						</div>
						<div style="margin-left: 45%;" class="btn-group">
							<!-- <button type="button" id="btn_search" class="btn btn-default"
								onclick="selectDoc('tapList2');"><span class="fa fa-eye" aria-hidden="true"></span>查看</button> -->
							<button type="button" id="btn_search_fw" class="btn btn-default"
								onclick="searchGD();">查询</button>
									<button type="button" id="btn_restore" class="btn btn-default"
								onclick="restore('tapList2');">还原</button>	
					<button type="button" id="btn_reset_gd" class="btn btn-default">重置</button> 
						</div>
						<div class="clearfix"></div>
					</form>
				</div>
				<form id="export_fw" action="">
					<table id="tapList2"></table>
				</form>
			</div>
		<!-- 	<div class="swiper-container-fw" id="swiper-fw">
				<div class="swiper-wrapper">
					<div class="swiper-slide mask_layer"></div>
				</div>
			</div> -->
		</div>
	</div>
</div>
</div>
<!-- 节点新增 -->
	<div class="modal fade" id="nodeModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="nodeModalLabel">新增归档类型</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<input type="text" id="folder_name_" name="folder_name_" value=""
							class="form-control" />
					</div>
					<div class="modal-footer" style="text-align: center;">
						<button type="button" class="btn btn-primary"
							onclick="saveFolderInfo()">保存</button>
						<button type="button" class="btn btn-primary"
							onclick="cancel('nodeModal')">取消</button>
					</div>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<div class="modal fade" id="nodeModalModify" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="nodeModalLabel">修改归档类型</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<input type="text" id="folder_name_m" name="folder_name_m"
							value="" class="form-control" />
					</div>
					<div class="modal-footer" style="text-align: center;">
						<button type="button" class="btn btn-primary"
							onclick="modifyFolderInfo()">保存</button>
						<button type="button" class="btn btn-primary"
							onclick="cancel('nodeModalModify')">取消</button>
					</div>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
<!-- 模态框（Modal） -->
	<div class="modal fade" id="DocTypeModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
				</div>
				<div class="modal-body" >
					<iframe id="group" runat="server" width="100%" height="300" frameborder="no" border="0" marginwidth="0"
						 marginheight="0" scrolling="yes" allowtransparency="yes"></iframe>
				</div>
				<div class="modal-footer" style="text-align:center">
					<button type="button" class="btn btn-primary" onclick="makesureFolder()">确定</button>
 					<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
</body>
<style type="text/css">
.sidebar {
	position: fixed;
	z-index: 11;
	top: 39px;
	width: 200px;
	background-color: #fff;
	border: 1px solid #ddd;
	padding-bottom: 40px;
}

.sidebar .sidebar-menu {
	width: 200px;
}

.main {
	padding: 0;
	padding-left: 200px;
}

.dept_post_tree {
	font-size: 14px;
	overflow-y: auto;
}

.dept_post_tree a {
	font-size: 14px;
	padding-left: 5px;
}

.dept_post_tree li:hover {
	background-color: #fcf1f1 !important;
	color: #576069 !important;
}

.dept_post_tree li.node-selected {
	background-color: #fcf1f1 !important;
	color: #576069 !important;
}

.node-dept_post_tree {
	border-width: 0 !important;
	background-color: #fff !important;
	color: #576069 !important;
}

.list-group-item {
	padding: 10px;
}

.tablepic td {
	border: 1px #becedb solid;
	padding: 5px;
}

.tablepic th {
	background: #eff0f5;
	border: 1px #becedb solid;
}

.bmw {
	background: #f8f9fd;
}
</style>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>