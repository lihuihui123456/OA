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
	display:block!important;
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
<title>业务修改公共页面</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/jquery-ui/css/jquery-ui-1.10.4.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/add-ons.min.css" rel="stylesheet">
<link href="${ctx}/views/cap/bpm/solrun/css/navla.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/jquery-ui/js/jquery-ui-1.10.4.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/jquery.dataTables.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/SmoothScroll.js"></script>
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
							    <!-- <button id="btn_send" type="button" class="btn btn-default btn-sm">
									<span class="fa fa-sign-in" aria-hidden="true"></span>提交
								</button> -->
								<button id="btn_save" type="button" class="btn btn-default btn-sm">
									<span class="fa fa-save" aria-hidden="true"></span>保存
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
								width="100%" height="1300" frameborder="no" border="0" scrolling="no""></iframe>
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
	
	<!-- 送交界面弹出模态框 -->
	<div class="modal fade" id="sendDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
	  <div class="modal-dialog" role="document">
	    <div class="modal-content">
	      <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="gridSystemModalLabel">送交选项</h4>
	      </div>
	      <div class="modal-body">
	      	<iframe id="send_iframe" src=""  width="100%" height="200px" frameborder="no" border="0" marginwidth="0"
				marginheight="0" scrolling="yes" style=""></iframe>
	      </div>
	      <div class="modal-footer" style="text-align: center;">
	        <button type="button" class="btn btn-primary" onclick="btnSubmit()">提交</button>
	        <button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->


<!-- 选人界面弹出模态框 -->
<div class="modal fade" id="chooseUserDiv" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" data-backdrop="false" data-keyboard="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">人员选择</h4>
      </div>
      <div class="modal-body" style="text-align: center;">
      	<iframe id="chooseUser_iframe" src=""  width="100%" height="400" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="yes" style=""></iframe>
      </div>
      <div class="modal-footer" style="text-align: center;margin-top:0;">
        <button type="button" class="btn btn-primary" onclick="makesure()">确认</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<!-- 图片识别 start -->
<div class="modal fade" id="scanFrameDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="false" data-backdrop="true" data-keyboard="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">图片识别</h4>
      </div>
      <div class="modal-body" style="text-align: center;">
      	<iframe id="scanFrame" src=""  width="100%" height="400" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="yes" style=""></iframe>
      </div>
      <div class="modal-footer" style="text-align: center;margin-top:0;">
      	 <button type="button" class="btn btn-primary" onclick="writeToZw()">确定</button>
         <button type="button" class="btn btn-primary" onclick="cancelScan()">关闭</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!-- 图片识别 end -->
<div id="dingbu1" style="display: none;">
	<a href="javascript:void(0);"><span id="dingbu2" title="返回顶部" class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span></a>
</div>	
</body>
<script type="text/javascript">
	var solId = '${solId}'; //业务解决方案Id
	var bizId = '${bizId}'; //业务流程Id
	var procdefId = '${procdefId}'; //流程定义Id
	var isFreeSelect = '${isFreeSelect}';//是否允许自由跳转   0：不允许    1：允许
	var isExeUser = '${isExeUser}';//是否允许选人 0:不允许      1  ：允许
	var divId="bizform";

	$(function() {
		//提交按钮事件
		$('#btn_send').click(function() {
			changeIndex();
			var flag = document.getElementById("form_iframe").contentWindow.validateForm();
			if(flag){
				var flag = btnSave("send");			
			}	
		});
		//暂存按钮事件
		$('#btn_save').click(function() {
			changeIndex();
			var flag = document.getElementById("form_iframe").contentWindow.validateForm();
			if(flag){
			var flag = btnSave("save");
			if(flag == "1") {
				layerAlert("表单信息保存出错，暂存失败！");
			}else if (flag == "2") {
				layerAlert("业务信息保存出错，暂存失败！");
			}
			}
		});
		
		//返回按钮事件
		$('#btn_close').click(function() {
			window.parent.closePage(window,true,true,true);
		});
		
		//切换页签
		$('#myTabs a').click(function (e) {
			  e.preventDefault()
			  divId = $(this).attr('href').replace("#","");
		});
		
	});
	//子页面赋值(拟稿用到)
	function setContent(){
	}
	//切换到表单所在的页签
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

	//弹出选择办理人窗口
	function choseUser() {
		$("#chooseUser_iframe").attr("src",'treeController/zMultiPurposeContacts');
		$('#chooseUserDiv').modal('show');
	}

	//选人确定按钮
	function makesure() {
		var arr = document.getElementById("chooseUser_iframe").contentWindow
				.doSaveSelectUser();
		var userName = arr[1];
		var userId = arr[0];
		document.getElementById("send_iframe").contentWindow.document
				.getElementById("userName").value = userName;
		document.getElementById("send_iframe").contentWindow.document
				.getElementById("userId").value = userId;
		$('#chooseUserDiv').modal('hide');
	}
	
	//暂存
	function btnSave(action) {
		var flag = "0";
		//是否生成业务数据处理
		var data ;
		/* var data = doUpdateBpmRuBizInfo(); */
		/* if (data == "Y") { */
			data = document.getElementById('form_iframe').contentWindow.doUpdateForm(bizId,action);//保存业务表单
			if(data == "Y"){
				var isMainBody = "${isMainBody}";
				if(isMainBody == "1" && $('#mainBody_iframe').attr("src")!="") {
					document.getElementById('mainBody_iframe').contentWindow.SaveDocument();//保存正文
				}
					window.parent.parent.closePage(window,true,true,true);
			}else{
				flag = "1";
			}
			/*} else {
			flag = "2";
		} */
		return flag;
 	} 

	//提交方法
	function btnSubmit() {
		//document.getElementById("send_iframe").contentWindow.document.getElementById("bizId").value = bizId;
		flag = document.getElementById('send_iframe').contentWindow.startProcess();
		if(flag == "1") {
			window.parent.parent.closePage(window,true,true,true);
		}else{
			layerAlert("送交失败！");
		}
	}
	
	/* //修改业务信息
	function doUpdateBpmRuBizInfo() {
		var flag;
		//var title = $('#form_iframe').contents().find('#title').val();
		var title = document.getElementById('form_iframe').contentWindow.getTitle();
		//var urgency = $('#form_iframe').contents().find('#URGENCY_LEVEL').find("option:selected").val();//选中的文本
		var urgency = document.getElementById('form_iframe').contentWindow.getUrgencyLevel();//选中的文本
		$.ajax({
			url : 'bpmRuBizInfoController/doUpdateBpmRuBizInfoEntity',
			type : 'post',
			dataType : 'text',
			async : false,
			data : {
				'bizId' : bizId,
				'title' : title,
				'urgency' :urgency
			},
			success : function(data) {
				flag = data;
			}
		});
		return flag;
	} */
	
	//给送交页面赋值
	function setValue() {
		//var title = $('#form_iframe').contents().find('#title').val();
		var title = document.getElementById('form_iframe').contentWindow.getTitle();
		document.getElementById('send_iframe').contentWindow.setTitle(title);
	}
	
	//通过判断是否存在在DB中存在bizId,没有插入并更新标记dbbizId
	function changeIseb() {
		return;
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