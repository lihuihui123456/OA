<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>指标库</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script
	src="${ctx}/views/aco/indexLibrary/js/indexLibrary.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css"  href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
	
</script>
</head>
<body>
	<div id="search_div" style="width: 300px; float: right; padding-bottom: 10px;padding-top: 10px;">
		<div class="input-group">
			<input type="text" id="input-word" class="form-control input-sm"
				value="请输入部门查询" onFocus="if (value =='请输入部门查询'){value=''}"
				onBlur="if (value ==''){value='请输入部门查询'}"> <span
				class="input-group-btn">
				<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
					<i class="fa fa-search"></i> 查询
				</button>
				<!-- <button type="button" class="btn btn-primary btn-sm" style="margin-left: 2px; margin-right: 0px;" onclick="showOrHide();">
					<i class="fa fa-search-plus"></i> 高级
				</button> -->
			</span>
		</div>
	</div>
	<div style="padding-top: 0px;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group">
			<button id="add_btn" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-plus" aria-hidden="true"></span> 新增
			</button>
			<button id="update_btn" type="button" class="btn btn-default btn-sm" onclick="doUpdateIndexLiarbryById();">
				<span class="fa  fa-edit" aria-hidden="true"></span> 修改
			</button>
			<button id="del_btn" type="button" class="btn btn-default btn-sm" onclick="doDelIndexLiarbryById();">
				<span class="fa fa-remove" aria-hidden="true"></span> 删除
			</button>
		</div>
		<table id="indexLibTable">
		</table>
	</div>
	<div class="swiper-container">
		<div class="swiper-wrapper">
			<div class="swiper-slide mask_layer"></div>
		</div>
	</div>
</body>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>