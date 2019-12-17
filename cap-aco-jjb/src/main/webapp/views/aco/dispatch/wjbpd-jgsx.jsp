<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>文件报批单-金格手写</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<link rel="stylesheet" href="${ctx}/static/cap/plugins/iweb-revision/css/iweb-revision.css" type="text/css">

<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/views/aco/dispatch/js/deptData.js"></script>
<script src="${ctx}/views/aco/dispatch/js/phrasebook.js"></script>
<script src="${ctx}/views/aco/dispatch/js/iweb-revision.js"></script>
<style>
.btn-default {
	color: #333;
	background-color: #fff;
	border-color: #fff;
}

.btn-default.focus, .btn-default:focus {
	color: #333;
	background-color: #e6e6e6;
	border-color: #fff
}

.btn-default:hover {
	color: #333;
	background-color: #e6e6e6;
	border-color: #fff
}

.btn-default.active, .btn-default:active, .open>.dropdown-toggle.btn-default
	{
	color: #333;
	background-color: #e6e6e6;
	border-color: #fff
}

.btn-default.active.focus, .btn-default.active:focus, .btn-default.active:hover,
	.btn-default:active.focus, .btn-default:active:focus, .btn-default:active:hover,
	.open>.dropdown-toggle.btn-default.focus, .open>.dropdown-toggle.btn-default:focus,
	.open>.dropdown-toggle.btn-default:hover {
	color: #333;
	background-color: #d4d4d4;
	border-color: #fff
}

.form-control {
	border: 1px #fff solid;
	-webkit-box-shadow: none;
	box-shadow: none;
}

.form-group {
	margin-bottom: 0;
}

.treeDiv {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	margin-top: 20px;
	display: none;
	position: absolute;
	margin-top: -160px;
	background-image: url('${ctx}/views/aco/dispatch/img/treeImg.png');
	background-color: black;
}

.paper-outer {
	background-color: #bebebe;
	padding: 15px 5% 3% 5%;
}

.paper-inner {
	background-color: white;
	padding: 10px 5% 3% 5%;
	position:relative;
}

.tablestyle th {
	text-align: center;
	vertical-align: middle;
}
.table_inner td{
	border:none; 
}
div#phrasebook_div {
	position: absolute;
	display: none;
	top: 0;
	background-color: #555;
	text-align: left;
	padding: 2px;
} 
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
<script>
function btnControl(){
	var isMax = $(".btn_operation > i").attr("class");
	//alert(isMax);
	if (isMax.indexOf("icon-max") > 1) {
		$(".btn_operation > i").attr("class","iconfont icon-min");
		$("#aaa",window.parent.parent.parent.document).css("display","block");
	}else{
		$(".btn_operation > i").attr("class","iconfont icon-max");
		$("#aaa",window.parent.parent.parent.document).css("display","none");
	}
}
</script>
</head>
<body class="paper-outer" onload="LoadSignature();">
	<div class="paper-inner">
		<div class="btn_operation">
			<i class="iconfont icon-max" onclick="btnControl()"></i>
		</div>
		<form id="myFm">
			<p class="tablestyle_title" style="font-size: 25pt">文件报批单</p>
			<input type="hidden" id="bizId_" name="bizId_">
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>缓急程度</th>
					<td>
						<div class="form-group">
							<select class="selectpicker select" id="urgencyLevel_"
								name="urgencyLevel_" value="" title="请选择">
								<option value="1">平件</option>
								<option value="2">急件</option>
								<option value="3">特急</option>
							</select>
						</div>
					</td>
					<th>密 级</th>
					<td>
						<div class="form-group">
							<select class="selectpicker select" id="securityLevel_"
								name="securityLevel_" value="" title="请选择">
								<option value="1">公开</option>
								<option value="2">内部</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>主送</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" id="mainSend_"
								name="mainSend_" value="" placeholder="">
						</div>
					</td>
				</tr>
				<tr>
					<th>标题<span class="star">*</span>
					</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input"
								id="title_" name="title_" value="" placeholder="">
						</div>
					</td>
				</tr>
				<tr>
					<th height="180">院领导批示</th>
					<td colspan="3">
						<table style="width: 100%; height: 100%" id="commentYld_table" class="table_inner commentTable"> 
							<tr class="wz" style="height: 30px">
								<td>
									<a class="LinkButton" onClick="change('sx',this);">[手写签批]</a> 
								</td>
							</tr>
							<tr class="sx" style="height: 30px;display: none;">
								<td>
									<a class="LinkButton" onClick="change('wz',this);">[文字签批]</a> 
									<a class="LinkButton commentButton" onClick="ConsultInvisiblePages(1,'commentYld_');">[手写签名窗口]</a>
									<a class="LinkButton commentButton" onClick="ConsultClearAll('commentYld_');">[清空全部]</a> 
								</td>
							</tr>
							<tr class="wz">
								<td>
									<div class="form-group" style="overflow-y: auto; height: 180px;">
										<textarea class="form-control comment" id="commentYld_"name="commentYld_" style="background-color: white" rows="4"></textarea>
										<div style="padding-top: 10px">
											<c:choose>
												<c:when test="${not empty commentYld_}">
													<c:forEach items="${commentYld_}" var="comment" varStatus="vs">
														<c:if test="${comment.message_!=''}">
															<label style="color: #2a2a2a; margin-top: 8px; padding-left: 10px;">${comment.message_}</label>
															<br>
															<label style="color: #888; padding-left: 10px; margin-top: 5px; margin-bottom: 5px;">
																&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;
															</label>
															<label style="color: #888;">
																<fmt:formatDate value="${comment.time_ }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
															</label>
															<br>
														</c:if>
													</c:forEach>
												</c:when>
											</c:choose>
										</div>
									</div>
								</td>
							</tr>
							<tr class="sx" style="display: none">
								<td>
									<div class="form-group" style="overflow-y: auto; height: 180px;">
										<OBJECT style="width: 100%;" name="commentYld_" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439"
											codebase="${ctx}/static/cap/plugins/iweb-revision/iWebRevision.cab#version=6,0,0,0">
											<param name="WebUrl" value="${mServerUrl}">
											<param name="RecordID" value="${RecordID}">
											<param name="FieldName" value="commentYld_">
											<param name="UserName" value="${userName}>">
											<param name="Enabled" value="0">
											<param name="PenColor" value="FF0066">
											<param name="BorderStyle" value="0">
											<param name="EditType" value="0">
											<param name="ShowPage" value="0">
											<param name="InputText" value="">
											<param name="PenWidth" value="3">
											<param name="FontSize" value="14">
											<param name="SignatureType" value="0">
											<param name="InputList" value="同意\r\n不同意\r\n请上级批示\r\n已阅">
										</OBJECT>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th height="180">局领导批示</th>
					<td colspan="3">
						<table style="width: 100%; height: 100%" id="commentJld_table" class="table_inner commentTable"> 
							<tr class="wz" style="height: 30px">
								<td>
									<a class="LinkButton" onClick="change('sx',this);">[手写签批]</a> 
								</td>
							</tr>
							<tr class="sx" style="height: 30px;display: none;">
								<td>
									<a class="LinkButton" onClick="change('wz',this);">[文字签批]</a> 
									<a class="LinkButton commentButton" onClick="ConsultInvisiblePages(1,'commentJld_');">[手写签名窗口]</a>
									<a class="LinkButton commentButton" onClick="ConsultClearAll('commentJld_');">[清空全部]</a> 
								</td>
							</tr>
							<tr class="wz">
								<td>
									<div class="form-group" style="overflow-y: auto; height: 180px;">
										<textarea class="form-control comment" id="commentJld_"
											name="commentJld_" style="background-color: white" rows="4"></textarea>
										<div style="padding-top: 10px">
											<c:choose>
												<c:when test="${not empty commentJld_}">
													<c:forEach items="${commentJld_}" var="comment" varStatus="vs">
														<c:if test="${comment.message_!=''}">
															<label style="color: #2a2a2a; margin-top: 8px; padding-left: 10px;">${comment.message_}</label>
															<br>
															<label style="color: #888; padding-left: 10px; margin-top: 5px; margin-bottom: 5px;">
																&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;
															</label>
															<label style="color: #888;">
																<fmt:formatDate value="${comment.time_ }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
															</label>
															<br>
														</c:if>
													</c:forEach>
												</c:when>
											</c:choose>
										</div>
									</div>
								</td>
							</tr>
							<tr class="sx" style="display: none">
								<td>
									<div class="form-group" style="overflow-y: auto; height: 180px;">
										<OBJECT style="width: 100%;" name="commentJld_" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439"
											codebase="${ctx}/static/cap/plugins/iweb-revision/iWebRevision.cab#version=6,0,0,0">
											<param name="WebUrl" value="${mServerUrl}">
											<param name="RecordID" value="${RecordID}">
											<param name="FieldName" value="commentJld_">
											<param name="UserName" value="${userName}">
											<param name="Enabled" value="0">
											<param name="PenColor" value="FF0066">
											<param name="BorderStyle" value="0">
											<param name="EditType" value="0">
											<param name="ShowPage" value="0">
											<param name="InputText" value="">
											<param name="PenWidth" value="3">
											<param name="FontSize" value="14">
											<param name="SignatureType" value="0">
											<param name="InputList" value="同意\r\n不同意\r\n请上级批示\r\n已阅">
										</OBJECT>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th height="180">部门负责人</th>
					<td colspan="3">
						<table style="width: 100%; height: 100%" id="commentBm_table" class="table_inner commentTable"> 
							<tr class="wz" style="height: 30px">
								<td>
									<a class="LinkButton" onClick="change('sx',this);">[手写签批]</a> 
								</td>
							</tr>
							<tr class="sx" style="height: 30px;display: none;">
								<td>
									<a class="LinkButton" onClick="change('wz',this);">[文字签批]</a> 
									<a class="LinkButton commentButton" onClick="ConsultInvisiblePages(1,'commentBm_');">[手写签名窗口]</a>
									<a class="LinkButton commentButton" onClick="ConsultClearAll('commentBm_');">[清空全部]</a> 
								</td>
							</tr>
							<tr class="wz">
								<td>
									<div class="form-group" style="overflow-y: auto; height: 180px;">
										<textarea class="form-control comment" id="commentBm_" name="commentBm_" 
											style="background-color: white" rows="4"></textarea>
										<div>
											<c:choose>
												<c:when test="${not empty commentBm_}">
													<c:forEach items="${commentBm_}" var="comment"
														varStatus="vs">
														<c:if test="${comment.message_!=''}">
															<label style="color: #2a2a2a; margin-top: 8px; padding-left: 10px;">${comment.message_}</label>
															<br>
															<label style="color: #888; padding-left: 10px; margin-top: 5px; margin-bottom: 5px;">
																&nbsp;&nbsp;&nbsp;&nbsp;${comment.userName_}&nbsp;&nbsp;&nbsp;&nbsp;
															</label>
															<label style="color: #888;">
																<fmt:formatDate value="${comment.time_ }" type="both" pattern="yyyy-MM-dd HH:mm:ss" />
															</label>
															<br>
														</c:if>
													</c:forEach>
												</c:when>
											</c:choose>
										</div>
									</div>
								</td>
							</tr>
							<tr class="sx" style="display: none">
								<td>
									<div class="form-group" style="overflow-y: auto; height: 180px;">
										<OBJECT style="width: 100%;" name="commentBm_" classid="clsid:2294689C-9EDF-40BC-86AE-0438112CA439"
											codebase="${ctx}/static/cap/plugins/iweb-revision/iWebRevision.cab#version=6,0,0,0">
											<param name="WebUrl" value="">
											<param name="RecordID" value="">
											<param name="FieldName" value="commentBm_">
											<param name="UserName" value="${userName}">
											<param name="Enabled" value="0">
											<param name="PenColor" value="FF0066">
											<param name="BorderStyle" value="0">
											<param name="EditType" value="0">
											<param name="ShowPage" value="0">
											<param name="InputText" value="">
											<param name="PenWidth" value="3">
											<param name="FontSize" value="14">
											<param name="SignatureType" value="0">
											<param name="InputList" value="同意\r\n不同意\r\n请上级批示\r\n已阅">
										</OBJECT>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>拟稿部门<span class="star">*</span>
					</th>
					<td>
						<div id="treeDiv_draftDeptId_" class="treeDiv">
							<div id="treeDemo_draftDeptId_" class="ztree"
								style="width: 240px; height: 120px; margin-top: 20px; overflow: auto; font-size: 13px;">
								<ul id="groupTree_draftDeptId_" class="ztree" style="margin-top: 10px;"></ul>
							</div>
						</div> 
						<input id="draftDeptId_" class="form-control" name="draftDeptId_" type="hidden" 
							style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='deptId'/>" /> 
						<input id="draftDeptIdName_" name="draftDeptIdName_" class="validate[required] form-control select" name="draft_depart_name" 
							type="text" style="width: 100%; height: 29; border: 0;" onclick="peopleTree(2,'draftDeptId_');" value="<shiro:principal property='deptName'/>" />
					</td>
					<th>拟稿时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="draftTime_" name="draftTime_" value="" style="width: 100%" 
								class="form-control select" onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
				</tr>
				<tr>
					<th>核稿人</th>
					<td>
						<div id="treeDiv_checkUserId_" class="treeDiv">
							<div id="treeDemo_checkUserId_" class="ztree"
								style="width: 240px; height: 120px; margin-top: 20px; overflow: auto; font-size: 13px;">
								<ul id="groupTree_checkUserId_" class="ztree" style="margin-top: 10px;"></ul>
							</div>
						</div> 
						<input id="checkUserId_" class="form-control" name="checkUserId_"
							type="hidden" style="width: 100%; height: 29; border: 0;" value="" />
						<input id="checkUserIdName_" name="checkUserIdName_" class="form-control select" onclick="peopleTree(1,'checkUserId_');"
							type="text" style="width: 100%; height: 29; border: 0;" value="" />
					</td>
					<th>拟稿人<span class="star">*</span>
					</th>
					<td>
						<div id="treeDiv_draftUserId_" class="treeDiv" style="z-index: 2">
							<div id="treeDemo_draftUserId_" class="ztree"
								style="width: 240px; height: 120px; margin-top: 15px; overflow: auto; font-size: 13px;">
								<ul id="groupTree_draftUserId_" class="ztree" style="margin-top: 10px;"></ul>
							</div>
						</div> 
						<input id="draftUserId_" class="form-control" name="draftUserId_" type="hidden" 
							style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='id'/>" /> 
						<input id="draftUserIdName_" name="draftUserIdName_" class="validate[required] form-control select"
							onclick="peopleTree(1,'draftUserId_');" type="text" style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='name'/>" />
					</td>
				</tr>
			</table>
			<div class="txm">
				<c:if test="${serialNumber!=''&&serialNumber!=null}">
					<img alt="图片未加载"
						src="${ctx}/bpmRuFormInfoController/getOneBarcode?barcodeNum=${serialNumber}" />
				</c:if>
			</div>
		</form>
	</div>
	<div id="phrasebook_div" style="width: 300px; height: 150px">
		<iframe id="phrasebook_iframe" src="" width="100%" height="100%"
			frameborder="no" border="0" marginwidth="0" marginheight="0" scrolling="yes"></iframe>
	</div>
</body>
<script type="text/javascript">
	var map = ${keyValueMap};
	var style = "${style}";
	var tableName = "${tableName}";
	var commentColumn = "${commentColumn}";
	
	var Enabled = "${Enabled}";
	var showType = "${showType}";
	var taskId = "${taskId}";
	var procInstId = "${procInstId}";
	var bizId;
	
	$(function() {
		$('#myFm').validationEngine({
			
		});
		if(style == "draft"){
			bizId = window.parent.generateUUID();
			$('#bizId_').val(bizId);
		}else{
			bizId = "${bizId}";
		}
		/**遍历map实现表单回显*/
		for ( var key in map) {
			var checkboxs = $('input:checkbox[name=' + key + ']');
			var radios = $('input:radio[name=' + key + ']');
			if (checkboxs.length != 0) {//对复选框的处理
				var values = map[key].split(",");
				for ( var i = 0; i < checkboxs.length; i++) {
					//获取所有复选框对象的value属性，然后，用checkArray[i]和他们匹配，如果有，则说明他应被选中
					$.each(checkboxs, function(j, checkbox) {
						//获取复选框的value属性
						var checkValue = $(checkbox).val();
						if (values[i] == checkValue) {
							$(checkbox).attr("checked", checked);
						};
					});
				};
			} else if(radios.length != 0) {//对单选框的处理
				for ( var i = 0; i < radios.length; i++) {
					//获取所有复选框对象的value属性，然后，用checkArray[i]和他们匹配，如果有，则说明他应被选中
					$.each(radios, function(j, radio) {
						//获取复选框的value属性
						var radioValue = $(radio).val();
						if (map[key] == radioValue) {
							$(radio).attr("checked", true);
						};
					});
				};
			}else {//其他输入框的处理
				$('#' + key).val(map[key]);
			};
		};
		//表单显现方式
		formShowType();
	});
	
	//表单的展现方式
	function formShowType(){
		/**
		 * style表示当前表单以什么方式打开  deal:办理  view：查看  draft:拟稿  update:修改
		 * 通过自定义的class属性来控制表单读写权限
		 * input 表示输入控件  comment 表示意见框  select表示通过选择方式来实现录入的控件
		 */
		if(style == "deal") {
			$('.input').attr("readonly","readonly");
			$('.select').attr("disabled","disabled");
			$('.comment').css("display","none");
			$('#'+commentColumn).css({"display" :"block" ,});
			$('#'+commentColumn).focus();
		}else if(style == "draft") {
			$('.comment').css("display","none");
		}else if(style == "update") {
			$('.comment').css("display","none");
		}else if(style == "view") {
			$('.input').attr("readonly","readonly");
			$('.select').attr("disabled","disabled");
			$('.comment').css("display","none");
		}
	}
	
	function doSaveForm(bizId) {
		$('#bizId_').val(bizId);
		var flag = "N"
		$.ajax({
			url : 'bpmRuFormInfoController/doSaveBpmDuForm/'+tableName,
			type : 'post',
			dataType : 'text',
			async : false,
			data : $('#myFm').serialize(),
			success : function(data) {
				flag = data;
			}
		});
		return flag;
	}

	function doUpdateForm(bizId) {
		$('#bizId_').val(bizId);
		var flag = "N"
		if(style == "deal"){
			if(SaveSignature()){
				$.ajax({
					url : 'bpmRuFormInfoController/doUpdateBpmDuForm/'+bizId+'/'+tableName,
					type : 'post',
					dataType : 'text',
					async : false,
					data : $('#myFm').serialize(),
					success : function(data) {
						flag = data;
					}
				});
			}
		}else{
			$.ajax({
				url : 'bpmRuFormInfoController/doUpdateBpmDuForm/'+bizId+'/'+tableName,
				type : 'post',
				dataType : 'text',
				async : false,
				data : $('#myFm').serialize(),
				success : function(data) {
					flag = data;
				}
			});
		}
		return flag;
	}

	function getTitle() {
		return $("#title_").val();
	}

	function getComment(commentColumn){
		return $("#"+commentColumn).val();
	}

	
	function getUrgencyLevel() {
		return $("#urgencyLevel_").val();
	}

	function doDealForm(bizId) {
		var flag = "N";
		$('#bizId_').val(bizId);
		if(SaveSignature()){
			$.ajax({
				url : 'bpmRuFormInfoController/doDealBpmDuForm/'+bizId+'/'+tableName,
				type : 'post',
				dataType : 'text',
				async : false,
				data : $('#myFm').serialize(),
				success : function(data) {
					flag = data;
				}
			});
		}
		return flag;
	};
	laydate.skin('dahong');
	//验证表单必填项
	function validateForm(){  
		return $('#myFm').validationEngine('validate');
	}
	
	
</script>
</html>