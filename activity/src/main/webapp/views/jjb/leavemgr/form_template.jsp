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
	height:1250px;
	overflow:hidden;
}

.tab-content>.tab-pane{
	display:block!important;
	z-index:0;
    width: 100%;
    position: absolute;
    top: 0;
    left: 0;
   	height:1250px;
}
.tab-content>.active {
    display: block;
    z-index:1;
    width:100%;
    position: absolute;
    top: 0;
    left: 0;
    height:1250px;
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
.btngroup{
	margin-left:-15px;
	position:fixed;
	width:100%;
	top:0px;
	left:30px;
	z-index:10000;
} 
.nav-tabs{
	width:100%;
	margin-left:-15px;
	margin-top:44px;
    position:fixed;
	width:100%;
	top:0px;
	left:30px;
	z-index:10000; 
} 
.tab-content>.active{
	top:83px;
}
</style>
<title>业务拟稿公共页面</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/jquery-ui/css/jquery-ui-1.10.4.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/add-ons.min.css" rel="stylesheet">
<link href="${ctx}/views/cap/bpm/solrun/css/navla.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/jquery-ui/js/jquery-ui-1.10.4.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/datatables/js/jquery.dataTables.min.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/js/SmoothScroll.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
	//生成uuid
	function generateUUID() { 
		var d = new Date().getTime(); 
		var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, 
		function(c) {   
			var r = (d + Math.random()*16)%16 | 0;   d = Math.floor(d/16);   
			return (c=='x' ? r : (r&0x3|0x8)).toString(16); 
		}); 
		return uuid; 
	}
</script>
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
							    <button id="btn_send" type="button" class="btn btn-default btn-sm">
									<span class="fa fa-sign-in" aria-hidden="true"></span>提交
								</button>
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
								width="100%" height="1250" frameborder="no" border="0" scrolling="no"></iframe>
							</div>
							<c:choose>
								<c:when test="${isMainBody== '1' }">
									<div role="tabpanel" class="tab-pane" id="mainBody">
										<iframe id="mainBody_iframe" src=""  width="100%" height="1250" frameborder="no" border="0" marginwidth="0"
										marginheight="0" scrolling="yes"></iframe>
									</div>
								</c:when>
							</c:choose>
							<c:choose>
								<c:when test="${isAttachment== '1' }">
									<div role="tabpanel" class="tab-pane" id="attachment">
										<iframe id="attachment_iframe" runat="server" src="" width="100%"
										height="1250" frameborder="no" border="0" scrolling="no"></iframe>
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
	var solId = '${solId}';//业务解决方案Id
	var procdefId = '${procdefId}';//流程定义Id
	var tableName = '${tableName}';//业务表单对应的业务表名
	var isFreeSelect = '${isFreeSelect}';//是否允许自由跳转   0：不允许    1：允许
	var isExeUser = '${isExeUser}';//是否允许选人 0:不允许      1  ：允许
	var iseb = "N";//N:数据库中没有bizId Y：数据库存在bizId
	var bizId = '${bizId}';//业务Id
	var postName = '${postName}';
	var workTime = '${workTime}';
	var already = '${already_day}';
	var leaveday = '${leave_already}';
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
			}	
		});
		
		//返回按钮事件
		$('#btn_close').click(function() {
			window.parent.parent.closePage(window,true,true,true);
		});
		
		//切换页签
		$('#myTabs a').click(function (e) {
			  e.preventDefault();
			  divId = $(this).attr('href').replace("#","");
		});
		
	});
	//子页面赋值
	function setContent(){
		document.getElementById("form_iframe").contentWindow.setPostName(postName);
		document.getElementById("form_iframe").contentWindow.setWorkTime(workTime);
		document.getElementById("form_iframe").contentWindow.setAlready(already);
		document.getElementById("form_iframe").contentWindow.setLeaveday(leaveday);
		document.getElementById("form_iframe").contentWindow.setTotaldays(already,leaveday);
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
		url = url + '&bizId=' + bizId;
		if ($('#' + tabId + '_iframe').attr("src") == "") {
			$('#' + tabId + '_iframe').attr('src', url);
		}
	}
	
	//暂存
	function btnSave(action) {
	/* 	var data = "N";
		var flag = "0";
		//是否生成业务数据处理
		if(iseb == "N"){
			data = doSaveBpmRuBizInfo();
		}else {
			data = doUpdateBpmRuBizInfo();
		} */
		/* if (data == "Y") { */
			/* var restTime = $("#rest_time").val();
			var restTimeEnd = $("#rest_time_end").val();
			alert(restTime);
			if(restTime > restTimeEnd){
				layerAlert("开始时间不能大于结束时间");
				return;
			} */
			var data;
			var flag;
			data = document.getElementById('form_iframe').contentWindow.doSaveForm(bizId,action);//保存业务表单
			if(data == "Y"){
				var isMainBody = "${isMainBody}";
				if(isMainBody == "1" && $('#mainBody_iframe').attr("src")!="") {
					document.getElementById('mainBody_iframe').contentWindow.SaveDocument();//保存正文
				}
					window.parent.parent.closePage(window,true,true,true);
			}else{
				flag = "1";
			}
	/* 	}else {
			flag = "2";
		} */
		return flag;
	}
	
	//新增业务信息
	/* function doSaveBpmRuBizInfo() {
		var flag;
		//var title = $('#form_iframe').contents().find('#title').val();
		var title = document.getElementById('form_iframe').contentWindow.getTitle();
		//var urgency = $('#form_iframe').contents().find('#URGENCY_LEVEL').find("option:selected").val();//选中的文本
		var urgency = document.getElementById('form_iframe').contentWindow.getUrgencyLevel();//选中的文本
		$.ajax({
			url : 'bpmRuBizInfoController/doSaveBpmRuBizInfoEntity',
			type : 'post',
			dataType : 'text',
			async : false,
			data : {
				'bizId' : bizId,
				'solId' : solId,
				'tableName' : tableName,
				'procdefId' : procdefId,
				'title' : title,
				'urgency' :urgency
			},
			success : function(data) {
				iseb = data;
				flag = data;
			}
		});
		return flag;
	} */
	
	//修改业务信息
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
	}
	
	//给送交页面赋值
	function setValue() {
		//var title = $('#form_iframe').contents().find('#title').val();
		var title = document.getElementById('form_iframe').contentWindow.getTitle();
		document.getElementById('send_iframe').contentWindow.setTitle(title);
	}
	
	//通过判断是否存在在DB中存在bizId,没有插入并更新标记dbbizId(未保存表单的时候操作正文或者附件时被调用)
	function changeIseb() {
		//是否生成业务数据处理
		if(iseb == "N"){
			doSaveBpmRuBizInfo();
			document.getElementById('form_iframe').contentWindow.doSaveForm(bizId);//保存业务表单
		}
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