<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<html>
<head>
<title>档案调度</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${ctx}/views/aco/docmgt/css/zTreeRightClick.css" />
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
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/views/aco/biz/earcmgr/earcseddread/js/seddread-index.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
var solId = '${solId}';
</script>
<style type="text/css">


#search-div {
	width: 300px;
	float: right;
}
</style>
</head>
<body style="background:#f2f4f8;">
	<div id="listResult" >
		<div class="panel-body">
			<!-- 搜索框 -->
			<div class="input-group"  id="search-div">
				<input type="text" id="input-word"
					class="validate[required] form-control input-sm" value="请输入提名查询"
					onFocus="if (value =='请输入提名查询'){value=''}"
					onBlur="if (value ==''){value='请输入提名查询'}"> <span
					class="input-group-btn">
					<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="searchCommon()"><i class="fa fa-search"></i> 查询</button>
					<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px;" onclick="advSearchModal()"><i class="fa fa-search-plus"></i> 高级</button>
				</span>
			</div>
			<!-- table工具栏 -->
			<div class="btn-group" id="toolbar" style="padding: 5px 0px;">
				<%@ include file="/views/aco/biz/earcmgr/biz_btn_list_do.jsp"%>
				<!-- <button id="btn_new" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-plus" aria-hidden="true"></span>选择档案
				</button> -->
			</div>
		<div id="advSearch" class="search-high-grade"
			style="display: none; margin-top: 5px;">
			<form id="search_form" enctype="multipart/form-data"
				class="form-horizontal " target="_top" method="post" action="">
			
				<div class="form-group" id="dialog-message">
						<label class="col-sm-1 control-label" style="text-align: left;">提名:</label>
						<div class="col-md-3">
							<input  id="biz_title_" name="biz_title_" type="text" class="form-control">
						</div>
						<label class="col-sm-1 control-label" style="text-align: left;">密级:</label>
						<div class="col-sm-3">
						<select id="security_level" name="security_level" class="form-control" size="1">
								<option value="">请选择</option>
							<option value="1">低</option>
		    				<option value="2">中</option>
		    				<option value="3">高</option>
						</select>
						</div>
						<label class="col-sm-1 control-label" style="text-align: left;padding-left: 22px">接收人:</label>
						<div class="col-sm-3">
						<input id="receiveUserId_" class="form-control select" name="receiveUserId_"
									type="hidden" style="width: 100%; height: 29; border: 0;" />
						<input id="receiveUserIdName_" class="form-control select" name="receiveUserIdName_"
									type="text" onclick="peopleTree(1,'receiveUserId_')"; />
						</div>
					</div>
			
						<div class="form-group" id="dialog-message">
								<label class="col-sm-1 control-label" style="text-align: left;">发送人:</label>
						<div class="col-md-3">
	                     <input id="sendUserId_" class="form-control select" name="sendUserId_"
									type="hidden" style="width: 100%; height: 29; border: 0;" />
						<input id="sendUserIdName_" class="form-control select" name="sendUserIdName_"
									type="text" onclick="peopleTree(1,'sendUserId_')"; />						
									</div>
						<label class="col-sm-1 control-label" style="text-align: left;">调阅时间:</label>
						<div class="col-sm-3">
						<input type="text" id="startTime" name="startTime"
							value="" 
							class="form-control"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />						</div>
						<label class="col-sm-1 control-label" style="text-align: left;padding-left: 32px">至</label>
						<div class="col-sm-3">
						<input type="text" id="endTime" name="endTime" value=""
							class="form-control"
							onclick="laydate({istime: true, format: 'YYYY-MM-DD'})" />						</div>
					</div>	


			</form>
			<div class="" id="btnDiv" align="center"
				style="width:100%; margin-bottom: 10px">
				<button type="button" class="btn btn-primary btn-sm" id="advSearch"
					onclick="submitForm()">查询</button>
				<button type="button" class="btn btn-primary btn-sm" id="advReset"
					onclick="clearForm()">重置</button>
				<button type="button" id="modal_close"
					class="btn btn-primary btn-sm">取消</button>
			</div>
		</div>
				<table id=earcTable data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
		</div>

	</div>
	</div>
	<!-- 模态框（Modal） -->
	<div class="modal fade" id="seddreadModal"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 600px">
			<div class="modal-content" >
				<div class="modal-body">
            <div id="seddreadListDiv"></div>
            </div>
            		<div class="modal-footer" id="btnDiv" align="center">
					<button type="button" class="btn btn-primary btn-sm" id="saveBtn" onclick="javascript:void(0);">确定</button>
					<button type="button" id="modal_close" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
	<%@ include file="/views/aco/common/selectionPeople_tree.jsp"%>
</body>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>