<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>阅件接收</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/views/aco/circularize/css/navla.css" rel="stylesheet">
<link href="${ctx}/views/aco/circularize/css/form_common.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css"
	rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<!-- 引用 ueditor -->
<script type="text/javascript" charset="utf-8" src="${ctx}/static/cap/plugins/UEditor1.4.4.3/ueditor.config.js"></script>
<script type="text/javascript" charset="utf-8" src="${ctx}/static/cap/plugins/UEditor1.4.4.3/ueditor.all.js"> </script>
<script type="text/javascript" charset="utf-8" src="${ctx}/static/cap/plugins/UEditor1.4.4.3/lang/zh-cn/zh-cn.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<style type="text/css">
.form-control {
	border: 1px #fff solid;
	box-shadow:none;
	-webkit-box-shadow:none;
}
.form-group {
 margin-bottom: 0px;
}
.paper-outer{
	background-color: #bebebe; 
	padding:3% 5% 3% 5%;
}
.paper-inner{
	background-color: white;
	padding:3% 5% 3% 5%;
}
.bootstrap-select .btn-default{
	background:#fff;
	color:#000;
	border:1px solid #fff;
}
.fixed-table-body{
	overflow-x:auto;
	overflow-y:auto;
	height:200px;
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
	z-index:1000;
} 
.nav-tabs{
	width:100%;
	margin-left:-15px;
	margin-top:44px;
    position:fixed;
	width:100%;
	top:0px;
	left:30px;
	z-index:1000; 
} 
.tab-content{
	margin-top: 82px;
}
.modal-content{
		z-index:1001;
}
</style>
</head>
<body>
	<div class="container-fluid content">
		<div class="row">
			<div class="col-lg-12">
				<div class="panel panel-default panel-bgcolor">
					<div class="panel-body">
						<!-- 按钮栏开始 -->
						<div class="panel-body btngroup">
							<div class="btn-group" role="group" aria-label="...">
								<button type="button" class="btn btn-default btn-sm" id="send_btn" >
								<i class="fa fa-sign-in"></i>&nbsp;发送
							</button>
<!-- 							<button type="button" class="btn btn-default btn-sm" id="save_btn">
								<i class="fa   fa-save"></i>&nbsp;提交
							</button> -->
							<button type="button" class="btn btn-default btn-sm" onclick="window.parent.closePage(window,true,true,true);">
								<i class="fa   fa-reply"></i>&nbsp;返回
							</button>
							</div>
						</div>
						<!-- 按钮栏结束 -->
						<!-- 页签头 -->
						<ul id="myTabs" class="nav nav-tabs" role="tablist">
							<li role="presentation" class="active">
								<a href="#bizform" role="tab" data-toggle="tab">阅件信息</a>
							</li>
							<li role="presentation" targetsrc="${mainBodySRC}">
								<a href="#mainBody" role="tab" data-toggle="tab"
									onclick='showPage("mainBody","${mainBodySRC}")' >阅件内容</a>
							</li>
						</ul>
						<!-- 页签头结束 -->
						<!-- tab页签内容 -->
						<div class="tab-content" id="panel_box">
							<div role="tabpanel" class="tab-pane active paper-outer" id="bizform">
								<div class="paper-inner">
									<p class="wjcystyle_title">文件传阅</p>
									<form id="ff" method="post"
										action="${ctx}/circularize/circularizeinsert" name="ff">
										<table class="wjcystyle" width="100%" border="0" cellspacing="0">
											<input type="hidden" value="${type}" id="type" />
											<input type="hidden" value="${basicinformation.id}" id="id" name="id" />
											<input type="hidden" value="${basicinformation.circulated_people_id}"
												id="circulatedpeopleid" name="circulated_people_id">
											<input type="hidden" value="${basicinformation.mustsee_id}"
												id="mustseeid" name="mustsee_id">
											<input type="hidden" value="${basicinformation.scene_id}" id="sceneid"
												name="scene_id">
											<input type="hidden" value="${basicinformation.table_id}" id="tableid"
												name="table_id">
											<input type="hidden" value="${basicinformation.status}" id="status"
												name="status">
											<input type="hidden" value="${basicinformation.bid}" id="bid"
												name="bid">
											<input type="hidden" value="" id="flag" name="flag">
											<input type="hidden" id="choose_userid" />
											<input type="hidden" id="choose_username" />
											<tr>
												<th>标 &nbsp;&nbsp;&nbsp;&nbsp; 题<span class="star">*</span>
												</th>
												<td colspan="3">
													<div class="form-group">
														<input type="text" id="name" name="title"
															class="validate[required] form-control" placeholder="请输入名称"
															value="${basicinformation.title}" disabled>
													</div>
												</td>
											</tr>
											<tr>
												<th width="10%" nowrap>传&nbsp;阅&nbsp;人</th>
												<td width="40%">
													<div class="form-group">
														<input type="text" class="form-control" id="circulatedpeople"
															name="circulated_people"
															value="${basicinformation.circulated_people}" disabled>
													</div>
												</td>
												<th width="10%" nowrap>紧急程度</th>
												<td width="40%"><select disabled class="selectpicker"
													id="priority" name="priority" data-live-search="true" title="请选择"
													style="width:200px">
														<option
															<c:if test="${basicinformation.priority=='普通'}"> selected="selected" </c:if>
															value='普通'>普通</option>
														<option
															<c:if test="${basicinformation.priority=='急件'}"> selected="selected" </c:if>
															value='急件'>急件</option>
														<option
															<c:if test="${basicinformation.priority=='特急'}"> selected="selected" </c:if>
															value='特急'>特急</option>
												</select></td>
											</tr>
											<th nowrap>必看人员<span class="star">*</span></th>
											<td colspan="3">
												<div class="form-group">
													<input type="text" class=" form-control" id="mustsee"
														onclick="selectPeople('mustsee')" name="mustsee"
														placeholder="请选择人员" value="${basicinformation.mustsee}">
												</div>
											</td>
											</tr>
											<tr>
												<th nowrap>选看人员</th>
												<td colspan="3">
													<div class="form-group">
														<input type="text" class="form-control" id="scene"
															onclick="selectPeople('scene')" name="scene" placeholder="请选择人员"
															value="${basicinformation.scene}">
													</div>
												</td>
											</tr>
											<tr>
												<th height="140" nowrap>传阅附件</th>
												<td colspan="3" valign="top">
													<div class="panel-body">
														<iframe frameborder="0" name="mainFrame" id="mainFrame"
															src="${ctx}/media/accessory.do?tableId=${basicinformation.table_id}"
															width="100%" height="99%" frameborder="no" border="0"
															marginwidth="0" marginheight="0" 
															allowtransparency="yes" scrolling="auto" allowtransparency="yes"></iframe>
													</div>
												</td>
											</tr>
											<tr>
												<th height="100" nowrap>描述</th>
												<td colspan="4" height="240" style="padding:10px;" id="textfield_tdjs"><input
													type="hidden" name="text_field" id="textfield"
													value="${basicinformation.text_field}"> 
												</td>
												<td colspan="4" height="240" style="padding:10px;"> 
													<script id="editor"
														type="text/plain" style="width:100%;height:300px;">${basicinformation.text_field}</script>
												</td>
											</tr>
											<tr>
												<th height="100px">处理意见</th>
												<td colspan="4" height="100px" style="padding:10px;"><textarea
														id="opinion" name="opinion" class="form-control" onpropertychange="if(value.length>100) value=value.substr(0,100)">${basicinformation.opinion}</textarea>
												</td>
											</tr>
										</table>
									</form>
								</div>
								<div class="paper-inner" style="height: 350px;">
						 			<span style="color:red">阅读情况（总人数${numbers[0]}人，已处理${numbers[1]}人，未处理${numbers[2]}人）</span>
					  				<table id="tapList"></table>
				  				</div>
							</div>
							<div role="tabpanel" class="tab-pane" id="mainBody">
								<div style="padding-left:10px">
									<input type="radio" name="zw" id="word" />Word文档&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
									<input type="radio" name="zw" id="pdf" />PDF文档
								</div>
								<iframe id="mainBody_iframe" src=""  width="100%" height="1300" frameborder="no" border="0" marginwidth="0"
									marginheight="0" scrolling="yes"></iframe>
							</div>
						</div>
						
						<div id="dingbu1" style="display: none;">
								<a href="javascript:void(0);">
									<span id="dingbu2" title="返回顶部" class="glyphicon glyphicon-chevron-up" aria-hidden="true"></span>
								</a>
						</div>
						<!-- tab页签内容结束 -->
					</div>
				</div>
			</div><!--/col-->
		</div><!--/row-->
	</div>

	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">
					选择人员
					</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="group" runat="server" src="" width="100%" height="450" frameborder="no" border="0" marginwidth="0"
						 marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
					</div>
				</div>
				
				<div class=modal-footer style="TEXT-ALIGN: center; MARGIN-TOP: 0px">
					<button class="btn btn-primary" onclick="makesurePerson()" type="button">确定</button>
					<button class="btn btn-primary" onclick="btnQk();" type="button">清空</button>
					<button class="btn btn-primary" type="button"  onclick="btnCancel()">取消</button> 
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
</body>
<script type="text/javascript">
//实例化编辑器
//建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
var type = $('#type').val();
if (type == 'open') {
	var ue = UE.getEditor('editor', {
		readonly: true
	});
}else{
	var ue = UE.getEditor('editor', {
		readonly: false
	});
}

//加载tab中的iframe
function showPage(tabId, url){
	if ($('#' + tabId + '_iframe').attr("src") == "") {
		if(tabId == "mainBody"){
			bodyType = dofindBizRuAction();
			if(bodyType == "0"){
				$("#word").attr("checked",true);
				url = "iweboffice/toDocumentEdit?fileType=.doc&bizId="+ "${id}";
			}else{
				$("#pdf").attr("checked",true);
			}
			$('#' + tabId + '_iframe').attr('src', url);
		}
	}
}

//获取业务最后一次操作信息
function dofindBizRuAction() {
	var temp = "1";
	$.ajax({
		url : "bizController/findBizRuActionByBizId",
		type : 'post',
		dataType : 'json',
		async : false,
		data : {
			"bizId" : "${id}"
		},
		success : function(data) {
			if(data){
				temp = data.bodyType_;
			}
		}
	});
	return temp;
}

function changeIseb(){
	return;
}

var divId = "bizform";
//切换到表单所在的页签
function changeIndex() {
	if (divId == "mainBody") {
		$('#myTabs li:eq(0)').addClass("active");
		$('#myTabs li:eq(1)').removeClass("active");
		$('#mainBody').removeClass("active");
		$('#bizform').addClass("active");
		divId = "bizform";
	}
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
	
	$("#textfield_tdjs").hide();
	$("input:radio[name=zw]").change(function(){
		var url;
		var inputid = $(this).attr("id");
		if(inputid == "word"){
			bodyType = "0";
			url = "iweboffice/toDocumentEdit?fileType=.doc&bizId="+ "${id}" + "&editType=0";
		}else{
			bodyType = "1";
			url = "${mainBodySRC}";
		}
		var flag = document.getElementById('mainBody_iframe').contentWindow.SaveDocument();
		if(flag == true || flag == 'true'){
			$('#mainBody_iframe').attr('src', url);
		}
	});
})
</script>
<script src="${ctx}/views/aco/circularize/js/filejs.js"></script>
</html>
