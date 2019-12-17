<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<style type="text/css">
#tb_departments td{
	text-align: center;
}
.sendbtn{
	height:25px;
	width:50px;
	background-color: #CA2320;
	color:#fff;
	font-family:Microsoft YaHei;
	border: #d4d4d4 1px solid;
	margin-top:10px;
}
.sendInput{
	margin-top:5px;
	width: 400px;
}
#panel_box{
	position:relative;
	width:100%;
	height:1300px;
	overflow:hidden;
}

.tab-content>.tab-pane{
	display:block;
	z-index:0;
    width: 100%;
    position: absolute;
    top: 0;
    left: 0;
   	height:1300px;
}
.tab-content>.active {
    display: block;
    z-index:1;
    width:100%;
    position: absolute;
    top: 0;
    left: 0;
    height:1300px;
}
#dingbu1 {
	position: fixed;
	float: right;
	z-index: 1;
	right: 20px;
	bottom:50%;
}

#dingbu2 {
	font-size: 28px;
	color: #F6F9FA;
	background-color: #00A1D6;
}
</style>
<title>业务信息查看公共页面</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/jquery-ui/css/jquery-ui-1.10.4.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/add-ons.min.css" rel="stylesheet">
<link href="${ctx}/views/cap/bpm/solrun/css/navla.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/jquery-ui/js/jquery-ui-1.10.4.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/jquery.dataTables.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/SmoothScroll.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="container-fluid content">
	<!-- start: Content -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default panel-bgcolor">
					<div class="panel-body">
						<div class="panel-body btngroup">
							<div class="btn-group" role="group" aria-label="...">
							<button id="btn_export" type="button" style="display:none" class="btn btn-default btn-sm">
									<span class="fa fa-reply" aria-hidden="true"></span>导出
								</button>
								<button id="btn_print" type="button" style="display:none" class="btn btn-default btn-sm">
									<span class="fa fa-reply" aria-hidden="true"></span>打印
								</button>
								<button id="btn_close" type="button" class="btn btn-default btn-sm">
									<span class="fa fa-reply" aria-hidden="true"></span>返回
								</button>
							</div>
						</div>

						<!-- 页签头 -->
						<ul id="myTabs" class="nav nav-tabs" role="tablist">
							<li role="presentation" class="active"><a href="#bizform"
								role="tab" data-toggle="tab">${formName }</a></li>
							<c:choose>
								<c:when test="${isMainBody== '1' }">
									<li role="presentation" targetsrc="${mainBodySRC}"><a
										href="#mainBody" role="tab"
										onclick='showPage("mainBody","${mainBodySRC}")'
										data-toggle="tab">正文</a></li>
								</c:when>
							</c:choose>
							<c:choose>
								<c:when test="${isAttachment== '1' }">
									<li role="presentation" targetsrc="${attachmentSRC}"><a
										href="#attachment"
										onclick='showPage("attachment","${attachmentSRC}")' role="tab"
										data-toggle="tab">附件</a></li>
								</c:when>
							</c:choose>
						</ul>
						<!-- 页签头结束 -->

						<!-- tab页签内容 -->
						<div class="tab-content" id="panel_box">
							<div role="tabpanel" class="tab-pane active" id="bizform">
								<iframe src="${formsrc}" id="form_iframe" runat="server"  
								width="100%" height="1300" frameborder="no" border="0" scrolling="no"></iframe>
							</div>
							<c:choose>
								<c:when test="${isMainBody== '1' }">
									<div role="tabpanel" class="tab-pane" id="mainBody">
										<iframe id="mainBody_iframe" src=""  width="100%" height="1300" frameborder="no" border="0" marginwidth="0"
										marginheight="0" scrolling="yes"></iframe>
									</div>
								</c:when>
							</c:choose>
							<c:choose>
								<c:when test="${isAttachment== '1' }">
									<div role="tabpanel" class="tab-pane" id="attachment">
										<iframe id="attachment_iframe" runat="server" src="" width="100%"
										height="1300" frameborder="no" border="0" scrolling="no"></iframe>
									</div>
								</c:when>
							</c:choose>
						</div>
						<!-- tab页签内容结束 -->
					</div>
					<!-- tab页签结束 -->
				</div>
			</div>
		</div>
	<!--/col-->
	</div>
	<!--/row-->
	</div>
	
	<!-- 传阅选人界面弹出模态框 -->
	<div class="modal fade" id="circulationDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
	  <div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="gridSystemModalLabel">人员选择</h4>
	      </div> 
	      <div class="modal-body" style="text-align: center;">
	      	<iframe id="circulation_iframe" src=""  width="100%" height="400" frameborder="no" border="0" marginwidth="0"
				marginheight="0" scrolling="yes" style=""></iframe>
	      </div>
	      <div class="modal-footer" style="text-align: center;margin-top:0;">
	        <button type="button" class="btn btn-primary" onclick="circulation()">确认</button>
	        <button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	
	<!-- 查看流程图 -->
	<div class="modal fade" id="viewFlowPicture" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
	  <div class="modal-dialog modal-lg" role="document">
	    <div class="modal-content">
	       <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="gridSystemModalLabel">流程图</h4>
	      </div>
	      <div class="modal-body" style="text-align: center">
	      <div style="overflow: auto;">
	      	<img id="flowPicture" alt='正在加载...' src="" onload="openImgDiv();"/>
	      </div>
	      </div>
	      <div class="modal-footer" style="text-align: center;">
	        <button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->
	<div id="dingbu1" style="display: none;">
	<a href="javascript:void(0);"><span id="dingbu2" title="返回顶部" class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span></a>
</div>
</body>
<script type="text/javascript">
	var solId = '${solId}'; //业务解决方案Id
	var bizId = '${bizId}'; //业务流程Id
	var procdefId = '${procdefId}'; //流程定义Id
	var procInstId = '${procInstId}'; //流程实例Id
	var taskId = '${taskId}'; //当前任务Id
	var isMainBody = '${isMainBody}';//是否有正文
	var divId;
	$(function() {
		if(procInstId!=""&&procInstId!=null){
			$('#btn_viewFlow').show();
			$('#btn_export').show();
			$('#btn_print').show();
			$('#btn_circulation').show();
		}else{
			$('#btn_export').show();
			$('#btn_print').show();
		}
		//查看流程按图钮事件
		$('#btn_viewFlow').click(function() {
			changeIndex();
			var src = 'bpmRuBizInfoController/viewFlowPicture?bizId=' +bizId;
			if($("#flowPicture").attr("src") == "") {
				$("#flowPicture").attr("src",src);
			}else {
				$('#viewFlowPicture').modal('show');
			}
		});
		
		//传阅按钮事件
		$('#btn_circulation').click(function() {
			changeIndex();
			$("#circulation_iframe").attr("src",'orgController/selectDeptPostUser_bs');
			$('#circulationDiv').modal('show');
		});
		
		//导出按钮事件
		$('#btn_export').click(function() {
			var bizid = $("#bizid").val();
			location.href="${ctx}/contractMgr/exportWord?bizId="+bizId;
		});
		
		//打印按钮事件
		$('#btn_print').click(function() {
			$.ajax({
		    url:"${ctx}/contractMgr/printWord?bizId="+bizId,
			type:"post",
			dataType:"json",
			success:function(data) {
				if(data.filename !=null){
					var url = "${ctx}/wordController/openWord?fileType=.doc&&mFileName="+data.filename;
					var options = {
						"text" : "合同管理-打印",
						"id" : "printWord",
						"href" :url,
						"pid" : window,
						"isDelete" : true,
						"isReturn" : true,
						"isRefresh" : true
					};
					window.parent.createTab(options);
				}
			}
		}); 
			
		});
		//子页面赋值(拟稿用到)
		function setContent(){
		}
		//返回按钮事件
		$('#btn_close').click(function() {
			window.parent.closePage(window,true,true,true);
		});
		
		$('#myTabs a').click(function (e) {
			  e.preventDefault()
			  divId = $(this).attr('href').replace("#","");
		});
		
	});
	
	function changeIndex() {
		if(divId == "mainBody") {
			$('#myTabs li:eq(0)').addClass("active");
			$('#myTabs li:eq(1)').removeClass("active");
			$('#mainBody').removeClass("active");
			$('#bizform').addClass("active");
			divId = "";
		}
		if(divId == "attachment") {
			$('#myTabs li:eq(0)').addClass("active");
			$('#myTabs li:eq(2)').removeClass("active");
			$('#attachment').removeClass("active");
			$('#bizform').addClass("active");
			divId = "";
		}
	}

	//加载tab中的iframe
	function showPage(tabId, url){
		if($('#'+ tabId +'_iframe').attr("src")=="") {
	 		$('#'+ tabId +'_iframe').attr('src',url);
		}
	}
	
	function openImgDiv() {
		$('#viewFlowPicture').modal('show');
	}	
	
	//传阅选人确定按钮
	function circulation() {
		var users = document.getElementById("circulation_iframe").contentWindow.doSaveSelectUser();
		var viewUserIds = users[0];
		$.ajax({
			type: 'post',  
	        url: 'bpmRuBizInfoController/doSaveBizGwCircularsEntitys',
	        dataType: 'json',
	        data: {
	        	'bizId' : bizId,
	        	'viewUserIds' : viewUserIds
	        },
	        success: function(data) {
	        	if(data){
		        	layerAlert("传阅成功！");
		        	$('#circulationDiv').modal('hide');
		        	$("#mainBody_iframe").css('display','block');
	        	}else {
		        	layerAlert("传阅失败！");
	        	}
	        }
		});
	}
	function toTop() {
		scroll(0,0);
	}
	
	$(function(){
		//绑定滚动条事件    
		$(window).bind("scroll", function() {
			var sTop = $(window).scrollTop();
			var sTop = parseInt(sTop);

			if (sTop >= 100) {
				$("#dingbu1").show();
			} else {
				$("#dingbu1").hide();
			}

		});
		$("#dingbu1").click(function() {
			scroll(0, 0);
		});
	})
</script>
</html>