<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>办公云盘</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css">
<link href="${ctx}/views/aco/clouddisk/css/clouddisk.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.exedit-3.5.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<script src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>

<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="position: relative;">
	<div>
		<div id="cloud-menu">
			<div id="toolbar" class="btn-group" style="margin-top:10px;margin-bottom: 5px;">
				<button id="beforeAdd" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-plus-square" aria-hidden="true"></span> 新建文件夹
				</button>
				<button id="beforeRename" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-pencil-square" aria-hidden="true"></span> 重命名文件
				</button>
				<button id="onShowLog" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-list" aria-hidden="true"></span> 文件详情
				</button> 
				<button id="buttonShare" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-share-square-o" aria-hidden="true"></span>分享文件
				</button>
				<button id="buttonUpload" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-upload" aria-hidden="true"></span> 上传文件
				</button>
				<button id="btnDelete" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-trash" aria-hidden="true"></span> 删除文件
				</button>
				<button id="btnShareAuth" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-cogs" aria-hidden="true"></span> 文件权限
				</button>
				<button id="btnSeeImages" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-cogs" aria-hidden="true"></span> 图片预览
				</button>
				<!-- Single button -->
				<!-- <div class="btn-group">
				  <button type="button" id="download-drop" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
				    下载方式 <span class="caret"></span>
				  </button>
				  <ul class="dropdown-menu">
				    <li><a id="batchDownload">批量下载</a></li>
				      <li role="separator" class="divider"></li>
				    <li><a id="packDownload">打包下载</a></li>
				  </ul>
				</div> -->
				<button id="packDownload" type="button" class="btn btn-default btn-sm">
					<span class="fa fa-tasks" aria-hidden="true"></span> 打包下载
				</button>
			</div>
			<div id="search_div"
				style="width: 230px; float: right; padding-top: 10px;padding-right: 20px;">
				<div class="input-group">
					<input type="text" id="input-word" class="form-control input-sm"
						value="请输入文件名查询" onFocus="if (value =='请输入文件名查询'){value=''}"
						onBlur="if (value ==''){value='请输入文件名查询'}"> <span
						class="input-group-btn">
						<button type="button" class="btn btn-primary btn-sm"
							style="margin-right: 0px" onclick="search()">
							<i class="fa fa-search"></i> 查询
						</button>
					</button>
					</span>
				</div>
			</div>
			</div>
		<div class="path">
			<div class="path-btn">
				<!-- <i class="fa fa-arrow-left backTo"></i>
				<i class="fa fa-arrow-right goTo"></i>
				<i class="fa fa-arrow-up upTo"></i> -->
				所在位置：
			</div>
			<div class="path-location">
			</div>
		</div>
		<div class="outDiv">
			<div class="sidebar">
					<ul id="folderTree" class="ztree"></ul>
			</div>
			
			<div class="main" id="main">
				<div class="panel-body" style="padding-top:0px;padding-bottom:0px;border:0;">
				<table id="tableList"></table>
				<table id="shareTableList"></table>
			</div>
		<div class="swiper-container">
	    	<div class="swiper-wrapper">
				<div  class="swiper-slide mask_layer" ></div>
			</div>
		</div>
		</div>
				<shiro:hasPermission name="CAddFolder:clouddiskc:initialData">
							<span id="CAddFolder">&nbsp;</span>
				</shiro:hasPermission> 
				<shiro:hasPermission name="CRename:clouddiskc:initialData">
							<span id="CRename">&nbsp;</span>
				</shiro:hasPermission> 
				<shiro:hasPermission name="CUploadFile:clouddiskc:initialData">
							<span id="CUploadFile">&nbsp;</span>
				</shiro:hasPermission> 
				<shiro:hasPermission name="CDeleteFile:clouddiskc:initialData">
							<span id="CDeleteFile">&nbsp;</span>
				</shiro:hasPermission> 
				<shiro:hasPermission name="CShowLog:clouddiskc:initialData">
							<span id="CShowLog">&nbsp;</span>
				</shiro:hasPermission> 
			</div>
		</div>
		<input type="hidden" id="cloud-this-user-id" value="<shiro:principal property='id'/>"/>
		<input type="hidden" id="cloud-this-user-name" value="<shiro:principal property='name'/>"/>
		<div  id="modal_upload" class="signatureCon">
				<span id="" class="fa fa-"></span>
					<button type="button" class="close" id="minusModalUploadBtn"
					aria-hidden="true">-</button>
					<button type="button" class="close" id="closeModalUploadBtn"
					aria-hidden="true">&times;</button>
				<h4 class="modal-title" id="modal_detail_title" >文件上传</h4>
				<div class="detail-row">
					<span class="detail-title">文件夹名称</span><span class="detail-text"><span id="upLoadFileName"></span></span>
				</div>
				<div>
				<div class="uploading-console"><span class="uploading-console-filename"></span><span class="uploading-console-status"></span></div>
				<div class="progress">
				  <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="min-width: 2em;">
				    0%
				  </div>
				</div>
				</div>
				<div id="container">
				<div class="btn btn-primary" id="pickFiles"><i class="fa fa-cloud-upload"></i>上传</div>
			 <!-- 	<button type="button" class="btn btn-primary" id="onUpload"><i class="fa fa-arrow-circle-up "></i>上传</button> -->
				<button type="button" class="btn btn-primary" id="closeUploadBtn" >关闭</button>
				</div>
		</div>
		<div id="modal_upload_min" class="signatureCon">
			<div class="uploading-console"><span class="uploading-console-filename-min"></span><span class="uploading-console-status"></span><span id="reback-upload"style="float:right;"><i class="fa fa-arrows-alt"></i></span></div>
			<div class="progress">
				  <div class="progress-bar" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="min-width: 2em;">
				    0%
				  </div>
			</div>
		</div>
	</body>
</html>
<form id="downloadForm" method="post" action="${ctx}/clouddiskc/fileDownload">
		<input id="folderId" name="folderId" type="hidden">
		<input id="fileId" name="fileId" type="hidden">
</form>
<form id="downloadPackForm" method="post" action="${ctx}/clouddiskc/filePackDownload">
		<input id="folderId" name="folderId" type="hidden">
		<input id="fileIds" name="fileIds" type="hidden">
</form>
<input type="hidden" id="hidImage"/>
<script type="text/javascript">
var mySwiper = new Swiper('.swiper-container',{
    loop:true,
	onSlidePrev: function(swiper){
	$("#tb_departments").bootstrapTable('prevPage');
	  },
	onSlideNext: function(swiper){
	$("#tb_departments").bootstrapTable('nextPage');
	}
});

var treeArray=${tree};
var CLOUD_USER_ID=$("#cloud-this-user-id").val();
var CLOUD_USER_NAME=$("#cloud-this-user-name").val();
</script>

<%@ include file="/views/aco/common/foot.jsp"%>
<%-- <script type="text/javascript" src="${ctx}/views/aco/clouddisk/js/plupload3_js/plupload.min.js"></script> --%>
<script type="text/javascript" src="${ctx}/views/aco/clouddisk/js/cloudinit.js"></script>
<script type="text/javascript" src="${ctx}/views/aco/upload/js/plupload.full.min.js"></script>
<script type="text/javascript" src="${ctx}/views/aco/clouddisk/js/clouddisk.js"></script>
<script type="text/javascript" src="${ctx}/views/aco/clouddisk/js/cloudtable.js"></script>
<script type="text/javascript" src="${ctx}/views/aco/clouddisk/js/cloudbutton.js"></script>
<script type="text/javascript" src="${ctx}/views/aco/clouddisk/js/cloudupload.js"></script>

<%@ include file="/views/aco/clouddisk/cloudmodal.jsp"%>
<%@ include file="/views/aco/common/selectionPeople_tree.jsp"%>
<%@ include file="/views/aco/common/selectionDept_tree.jsp"%>

