<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>会计档案-会计凭证</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css"
	href="${ctx}/views/aco/docmgt/css/zTreeRightClick.css" />
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.exedit-3.5.js"></script>
<script type="text/javascript"
	src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/views/aco/biz/earcmgr/acctvchr/list/js/acctvchr-list.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<style>
.control-label {
	text-align: left !important;
}
#toolbar{
	margin-top: 10px;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
	var solId = '${solId}';
</script>
</head>
<body>
    <div id="search_div" style="width: 300px; float: right; padding-bottom: 10px;padding-top: 10px;">
		<div class="input-group">
			<input type="text" id="input-word" class="form-control input-sm"
				value="请输入标题查询" onFocus="if (value =='请输入标题查询'){value=''}"
				onBlur="if (value ==''){value='请输入标题查询'}"> 
			<span class="input-group-btn">
				<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
					<i class="fa fa-search"></i> 查询
				</button>
				<button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px; margin-right: 0px;" onclick="showOrHide();">
					<i class="fa fa-search-plus"></i> 高级
				</button>
			</span>
		</div>
	</div>
	<div style="padding-top: 0px;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group">
			<%@ include file="/views/aco/biz/earcmgr/biz_btn_list_do.jsp"%>
			<button id="file_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-files-o" aria-hidden="true"></span> 归档
			</button>
			<button id="addFile_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-folder-open" aria-hidden="true"></span> 追加归档
			</button>
		</div>
	<!-- 模态框（Modal） -->
		<div id="advSearchModal" class="search-high-grade" style="display: none; margin-top: 5px;">
			<form id="ff" enctype="multipart/form-data" class="form-horizontal "
				target="_top" method="post" action="">
				<div class="form-group" id="dialog-message">
					<label class="col-sm-1 control-label" style="text-align: left;">标题</label>
					<div class="col-sm-3">
						<input id="BIZ_TITLE_" name="BIZ_TITLE_" type="text" class="form-control" >
					</div>
					<label class="col-sm-1 control-label" style="text-align: left;">责任人</label>
					<div class="col-sm-3">
						<input id="draftUserId_" class="form-control select" name="CREATE_USER_ID_"
									type="hidden" style="width: 100%; height: 29; border: 0;" />
						<input id="draftUserIdName_" class="form-control select" name="draftUserIdName_"
									type="text" onclick="peopleTree(1,'draftUserId_')"; />
					</div>
					<label class="col-sm-1 control-label" style="text-align: left;">保管期限</label>
					<div class="col-sm-3">
						<select  id="TERM" name="TERM" class="form-control" size="1" >
							<option value="">请选择</option>
							<option value="15">15年</option>
		    				<option value="25">25年</option>
		    				<option value="0">永久</option>
						</select>
					</div>
				</div>
				<div class="form-group" id="dialog-message">
					<label class="col-sm-1 control-label" style="text-align: left;">密级</label>
					<div class="col-sm-3">
						<select  id="SECURITY_LEVEL" name="SECURITY_LEVEL" class="form-control" size="1" >
							<option value="">请选择</option>
							<option value="1">低</option>
		    				<option value="2">中</option>
		    				<option value="3">高</option>
						</select>
					</div>
					<label class="col-sm-1 control-label" style="text-align: left;">档案状态</label>
					<div class="col-sm-3">
						<select  id="EARC_STATE" name="EARC_STATE" class="form-control" size="1" >
							<option value="">请选择</option>
							<option value="1">已归档</option>
		    				<option value="2">已作废</option>
		    				<option value="3">已销毁</option>
		    				<option value="4">已到期</option>
						</select>
						
					</div>
				</div>
				<div class="form-group" id="dialog-message">
					<label class="col-sm-1 control-label" style="text-align: left;">归档日期</label>
					<div class="col-sm-3">
						<!-- <div class="input-group date"> -->
							<input type="text" id="advStartDate"  name="CREATE_TIME_START_" class="form-control select"  onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
						<!-- </div> -->
					</div>
					<label class="col-sm-1 control-label" style="text-align: left;padding-left: 32px">到</label>
					<div class="col-sm-3">
						<!-- <div class="input-group date"> -->
							<input type="text" id="advEndDate" name="CREATE_TIME_END_" class="form-control select" onclick="laydate({format: 'YYYY-MM-DD',isclear: true,istime: true,})"/>
						<!-- </div> -->
					</div>
				</div>						
			</form>
			<div id="btnDiv" align="center" style="width:100%; margin-bottom: 10px">
				<button type="button" class="btn btn-primary btn-sm" id="advSearch">查询</button>
				<button type="button" class="btn btn-primary btn-sm"
					id="advSearchCalendar">重置</button>
				<button type="button" id="modal_close"
					class="btn btn-primary btn-sm" onclick="qxButton();">取消</button>
			</div>
		</div>
	<table id="earcTable">
	</table>
	</div>
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide mask_layer"></div>
		</div>
	</div>
	<!-- 归档模态框（Modal） -->
	<div class="modal fade" id="acctvchrModal"  role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" backdrop="false">
		<div class="modal-dialog" style="width: 600px">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel" >档案归档分类管理&gt;归档</h4>
				</div>
				<input id="parentId" type="hidden" />
				<input id="userName" type="hidden" value="<shiro:principal property='name'/>" />
				<input id="userId" type="hidden" value="<shiro:principal property='id'/>" />
				<input id="earcId" type="hidden" />
				<div class="modal-body">
				<ul id="filingtree" class="ztree"></ul>
				</div>
				<div class="modal-footer" id="btnDiv" align="center">
					<button type="button" class="btn btn-primary btn-sm" id="saveBtn" onclick="saveTreeNodeId();">确定</button>
					<button type="button" id="modal_close" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
				</div>
			</div>
		</div>
	</div>
<%@ include file="/views/aco/common/selectionPeople_tree.jsp"%>
</body>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>