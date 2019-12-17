<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<html>
<head>
<title>档案管理-目录分类管理</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
<link
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${ctx}/views/aco/docmgt/css/zTreeRightClick.css" />
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.exedit-3.5.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.js"></script>
<script src="${ctx}/views/aco/arc/arcdoc/js/zTreeRightClick.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>
<script src="${ctx}/views/aco/biz/earcmgr/earcctlg/js/ctgl-index.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
	var treeList = ${treeList};
	/**
	 * 导出按钮事件
	 */
	 function expExcel(){
		 window.location.href = "${ctx}/earcCtlgController/exportExcel?flag=1";
	 }
		//打印按钮事件
		function printExcel() {
			$.ajax({
			    url:"earcCtlgController/exportExcel?flag=2",
				type:"post",
				dataType:"json",
				success:function(data) {
					if(data.filename!=null){
						var url = "earcCtlgController/openExcel?encryption=0&fileType=.xls&&mFileName="+data.filename;
						var options = {
							"text" : "档案目录-打印",
							"id" : "printExcel",
							"href" :url,
							"pid" : window,
							"isDelete" : true,
							"isReturn" : true,
							"isRefresh" : false
						};
						window.parent.createTab(options);
					}
				}
			}); 
		}
</script>
<style type="text/css">
.sidebar {
	position: fixed;
	z-index: 11;
	top: 10px;
	width: 200px;
	background-color: #fff;
	border: 1px solid #ddd;
	padding-bottom: 10px;
}

.sidebar .sidebar-menu {
	width: 200px;
}

.main {
	padding: 0;
	padding-left: 200px;
}

#search-div {
	width: 300px;
	float: right;
}
</style>
</head>
<body style="background:#f2f4f8;">
	<div class="container-fluid content">
		<div class="sidebar ">
			<div class="sidebar-collapse" style="height:100%">
				<div id="sidebar-menu" class="sidebar-menu"
					style="height:100%;overflow:auto;">
					<ul id="ctlgTree" class="ztree"></ul>
				</div>
			</div>
		</div>
	</div>
	<div id="listResult" class="main">
		<div class="panel-body">
			<!-- 搜索框 -->
			<div class="input-group"  id="search-div">
				<input type="text" id="input-word"
					class="validate[required] form-control input-sm" value="请输入目录名称查询"
					onFocus="if (value =='请输入目录名称查询'){value=''}"
					onBlur="if (value ==''){value='请输入目录名称查询'}"> <span
					class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm"
						style="margin-right: 0px" onclick="search()">
						<i class="fa fa-search"></i> 查询
					</button>
					<!-- <button id="supperSearchBtn" type="button"
						class="btn btn-primary btn-sm"
						style="margin-left: 2px; margin-right: 0px;">
						<i class="fa fa-search-plus"></i> 高级
					</button> -->
				</span>
			</div>
			<!-- table工具栏 -->
			<div class="btn-group" id="toolbar">
				<button id="btn_new" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-plus" aria-hidden="true"></span>新增
				</button>
				<button id="btn_edit" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-pencil" aria-hidden="true"></span>修改
				</button>
				<button id="btn_delete" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-remove" aria-hidden="true"></span>删除
				</button>
			<button type="button" id="btn_print" class="btn btn-default btn-sm" onclick="printExcel()"; >
				<span class="fa fa-print" aria-hidden="true"></span> 打印
			</button>
				<button id="export_excel_btn" type="button"
				class="btn btn-default btn-sm" onclick="expExcel()"; >
				<span class="fa fa-cloud-download" aria-hidden="true"></span> 导出
			</button>
			</div>
		</div>
		<table id="ctlgList" data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
	</div>
	</div>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="ctlgModal"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 600px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >档案目录分类管理&gt;<font id="updateOradd">新增</font></h4>
				</div>
				<input id="parentId" type="hidden" />
				<input id="userName" type="hidden" value="<shiro:principal property='name'/>" />
				<input id="userId" type="hidden" value="<shiro:principal property='id'/>" />
				<div class="modal-body">
					<form id="ff" enctype="multipart/form-data" class="form-horizontal "
						target="_top" method="post" action="${ctx}/bizCalendarController/doSaveOrUpdateCalendar">
						<input id="ID_" name="ID_" type="hidden" />
						<input id="PARENTID" name="PARENTID" type="hidden" />	
						<input id="EARCCTLGNAME" name="EARCCTLGNAME" type="hidden" />				
						<div class="form-group" id="dialog-message">
							<label class="col-sm-2 col-xs-2 control-label">操作人：</label>
							<div class="col-sm-4 col-xs-4">
								<input id="CREATE_USER_NAME" name="CREATE_USER_NAME" type="text" readonly="readonly" class="form-control" value="<shiro:principal property='name'/>" >
							</div>
							<label class="col-sm-2 col-xs-2 control-label">操作时间：</label>
							<div class="col-sm-4 col-xs-4">
								<input id="CREATE_TIME" name="CREATE_TIME" type="text" class="form-control" readonly="readonly">
							</div>
						</div>
						
						<div class="form-group">
							<label class="col-sm-2 col-xs-2 control-label">父类名称：</label>
							<div class="col-sm-4 col-xs-4">
								<select  id="PARENT_ID" name="PARENT_ID" class="form-control" size="1" >
								</select>
							</div>
							<label class="col-sm-2 col-xs-2 control-label">子类名称：</label>
							<div class="col-sm-4 col-xs-4">
								<input id="EARC_CTLG_NAME" name="EARC_CTLG_NAME" type="text" class="form-control" placeholder="请出入子类名称">
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer" id="btnDiv" align="center">
					<button type="button" class="btn btn-primary btn-sm" id="saveBtn" onclick="saveCtlgInfo();">保存</button>
					<button type="button" class="btn btn-primary btn-sm" id="resetBtn">重置</button>
					<button type="button" id="modal_close" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>