<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>审批意见</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script type="text/javascript">
var bizid='${bizid}';

</script>
<script src="${ctx}/views/cap/bpm/monitor/js/advicelist.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<script type="text/javascript">
$(function(){
	$("#change_advice_btn").click(function(){
		var commentid=getselect();
		if(commentid==""||commentid==null){
			layerAlert("请选择一条数据");
		}else{
			$("#changeadvice").attr("src","${ctx}/bpmMonitor/toUpdateTaskComment?commentid="+commentid);
			$('#changeadvicemodel').modal('show');
		}
	});
});

function getselect(){
	var commentid="";
	var obj =$('#tb_departments_advice').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
	}else{
		commentid=obj[0].id;
	}
	return commentid;
}

function savecomment(){
	document.getElementById("changeadvice").contentWindow.savecomment();
}

//隐藏模态框并刷新列表
function refreshList(){
	$('#changeadvicemodel').modal('hide');
	$('#tb_departments_advice').bootstrapTable('refresh'); 
}

</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="panel-body" style="padding-top:0px;padding-bottom:0px;border:0;">
		<div id="toolbar" class="btn-group">
			<button id="change_advice_btn" class="btn btn-default btn-sm">
				 <span class="fa fa-file-text" aria-hidden="true"></span>修改意见
			</button>
		</div>
		<table  id="tb_departments_advice" data-toggle="table" date-striped="true" data-click-to-select="true" ></table>
	</div>
	<!-- 修改审批意见  模态框 -->
	<div class="modal fade" id="changeadvicemodel" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
					<h4 class="modal-title">
						审批意见-修改
					</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
						<iframe id="changeadvice" runat="server" src="" width="100%" height="120" frameborder="no" border="0" marginwidth="0"
						 marginheight="0" scrolling="no" allowtransparency="yes"></iframe>
				</div>
				<div class="modal-footer" style="text-align:center">
		            <button type="button" class="btn btn-primary" onclick="savecomment()">保存</button>
		            <button type="button" class="btn btn-default" data-dismiss="modal">关闭 </button>
		         </div>
			</div>
		</div>
	</div>
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
</body>
<script type="text/javascript">
var mySwiper = new Swiper('.swiper-container',{
    loop:true,
	onSlidePrev: function(swiper){
	$("#tb_departments_advice").bootstrapTable('prevPage');
	  },
	onSlideNext: function(swiper){
	$("#tb_departments_advice").bootstrapTable('nextPage');
	}
});
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>