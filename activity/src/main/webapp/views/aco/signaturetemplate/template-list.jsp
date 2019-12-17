<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>模版列表</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" >
<script src="${ctx}/views/aco/signaturetemplate/js/template-list.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- 滑动start -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/swiper/idangerous.swiper.css">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<!-- 滑动end -->
<%@ include file="/views/cap/common/theme.jsp"%>
<style type="text/css">
.btn-div{
	padding: 5px 0px;
}
#search-div{
	width: 300px; 
	height:40px;
	float: right;
}
</style>
</head>
<body>
	<div class="panel-body" style="padding-top:0px;padding-bottom:0px;border:0;">
	<!-- 搜索框 -->
	<div class="btn-div" id="search-div">
		<div class="input-group">
			<input type="text" id="input-word" class="form-control input-sm" value="请输入签章名称查询" 
				onFocus="if (value =='请输入签章名称查询'){value=''}" onBlur="if (value ==''){value='请输入签章名称查询'}"> 
			<span class="input-group-btn">
				<button type="button" class="btn btn-primary btn-sm" style="margin-right: 0px" onclick="search()">
					<i class="fa fa-search"></i> 查询
				</button>
			</span>
		</div>
	</div>
		<div id="toolbar" class="btn-div btn-group">
			<button id="zyxw_btn_over" type="button" class="btn btn-default btn-sm" onclick="addTemp()">
				<span class="fa  fa-plus" aria-hidden="true"></span>新增
			</button>
			<!-- <button id="zyxw_btn_over" type="button" class="btn btn-default btn-sm" onclick="updateTemp()">
				<span class="fa  fa-pencil" aria-hidden="true"></span>修改
			</button>
			 <button id="zyxw_btn_view" type="button" class="btn btn-default btn-sm" onclick="viewTemp()">
				<span class="fa fa-eye" aria-hidden="true"></span>查看
			</button> -->
			<!-- <button id="zyxw_btn_delete" type="button" class="btn btn-default btn-sm" onclick="delTemp()">
				<span class="fa fa-remove" aria-hidden="true"></span>删除
			</button> -->
			<!-- <button id="print_temp_btn" type="button" class="btn btn-default btn-sm" onclick="printTempModel()">
				<span class="fa  fa-upload" aria-hidden="true"></span>上传打印导出模版
			</button> -->
		</div>
		<table  id="tb_departments" data-toggle="table" date-striped="true"
			data-click-to-select="true"></table>
	</div>
	<div class="swiper-container">
    	<div class="swiper-wrapper">
			<div  class="swiper-slide mask_layer" ></div>
		</div>
	</div>
	
	<!-- 上传打印导出模版 -->
	<div class="modal fade" id="printTempModel" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
	  <div class="modal-dialog modal-md" role="document">
	    <div class="modal-content">
	       <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="gridSystemModalLabel">打印导出模版</h4>
	      </div>
	      <div class="modal-body" style="text-align: center; overflow:auto ">
	      	<iframe id="printTemp" src=""  width="100%" height="300px" frameborder="no" border="0" marginwidth="0"
				marginheight="0" scrolling="yes" style=""></iframe>
	      </div>
	      <div class="modal-footer" style="text-align: center;">
	      	<button type="button" class="btn btn-primary btn-sm" onclick="submitInfo()">提交</button>
	        <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	<!-- 验证密码modal -->
	<div class="modal fade" id="mm">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<h4 class="modal-title">输入密码</h4>
				</div>
				<div class="modal-body" style="margin-left: 130px">
					<form id="ff_mm" action="profile/updatePwd" method="post"
						class="form-horizontal " target="_top">
						<input type="hidden" id="paw" name="paw"
									value="">
						<div class="row">
							<label class="col-sm-2 control-label" for="password"
								style="text-align: right;"><span class="star" style="color: red;">*</span>签章密码</label>
							<div class="col-sm-7">
								<input type="password" id="password" name="password"
									class="form-control" placeholder="">
							</div>
						</div>
						<br />
					</form>
				</div>
				<div align="center" style="margin-bottom: 20px;">
					<button class="btn btn-primary" onclick="submitForm()">确定</button>
					<button type="button" class="btn btn-primary"" data-dismiss="modal">取消 </button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	<!-- 验证密码/.modal -->
</body>
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

function getselectoption(){
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
		return "";
	}else{
		return obj[0].recordId_;
	}
}

function getTempType(){
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if (obj.length>1||obj.length=='') {
		return "";
	}else{
		return obj[0].type_;
	}
}

function addTemp(){
	options={
			"text":"新增模板",
			"id":"template_add_",
			"href":"signatureTemplate/templateDocumentEdit?encryption=1",
			"pid":window,
			"isDelete":true,
			"isReturn":true,
			"isRefresh":true
	};
	window.parent.createTab(options);
}

function updateTemp(){
	var reocrdId=getselectoption();
	var type=getTempType();
		if(reocrdId!=""){
			 if(type==".doc"){
				 options={
							"text":"修改模板",
							"id":"template_update_"+reocrdId,
							"href":"signatureTemplate/templateDocumentEdit?encryption=1&&recordId="+reocrdId,
							"pid":window,
							"isDelete":true,
							"isReturn":true,
							"isRefresh":true
					};
					window.parent.createTab(options); 
			 }else{
					layerAlert("该信息为打印导出模版！");
				}		
		}else{
			layerAlert("选择一条数据！");
		}
	}


function printTempModel(){
	$("#printTemp").attr("src", "${ctx}/signatureTemplate/toUploadFile");
	$("#printTempModel").modal('show');
}

function submitInfo(){
	document.getElementById("printTemp").contentWindow.submitInfo();
}

function hideModel(){
	$("#printTempModel").modal('hide');
}
function refreshTable(){
	$("#tb_departments").bootstrapTable('refresh');
}
function delTemp(){
	var obj =$('#tb_departments').bootstrapTable('getSelections');
	if (obj.length == 0) {
		layerAlert("请选择操作项");
		return false;
	}
	layer.confirm('确定删除吗？', {
		btn : [ '是', '否' ]
	}, function() {
		var ids = '';
		$(obj).each(function(index) {
			if(obj[index].state_ == '2'){
				return false;
			}
			ids = ids + obj[index].id_ + ",";
		});
		ids = ids.substring(0, ids.length - 1);
		$.ajax({
			type: "POST",
			url: "signatureTemplate/doDelTemp",
			data: {ids:ids},
			success: function (data) {
				$('#tb_departments').bootstrapTable('refresh');
				layerAlert("删除模板成功！");
			},
			error: function(data) {
				alert("error:"+data.responseText);
			}
		});
	});	
}
function viewTemp(){
	var reocrdId=getselectoption();
	var type=getTempType();
	if(reocrdId!=""){
		if(type==".doc"){
			options={
					"text":"查看模板",
					"id":"template_view_"+reocrdId,
					"href":"signatureTemplate/templateDocumentView?recordId="+reocrdId,
					"pid":window,
					"isDelete":true,
					"isReturn":true,
					"isRefresh":true
			};
			window.parent.createTab(options);
		}else{
			layerAlert("该信息为打印导出模版！");
		}
	}else{
		layerAlert("选择一条数据！");
	}
}
</script>
</html>
<%@ include file="/views/aco/common/foot.jsp"%>