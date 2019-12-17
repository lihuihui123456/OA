<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>文件报批单</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css">
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css"  href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<!-- 意见域样式 -->
<link rel="stylesheet" type="text/css" href="${ctx}/views/aco/dispatch/css/form_common.css" />
<style>
.btn-default {
	color: #333;
	background-color: #fff;
	border-color: #fff;
}

.btn-default.focus,.btn-default:focus {
	color: #333;
	background-color: #e6e6e6;
	border-color: #fff
}

.btn-default:hover {
	color: #333;
	background-color: #e6e6e6;
	border-color: #fff
}

.btn-default.active,.btn-default:active,.open>.dropdown-toggle.btn-default
	{
	color: #333;
	background-color: #e6e6e6;
	border-color: #fff
}

.btn-default.active.focus,.btn-default.active:focus,.btn-default.active:hover,.btn-default:active.focus,.btn-default:active:focus,.btn-default:active:hover,.open>.dropdown-toggle.btn-default.focus,.open>.dropdown-toggle.btn-default:focus,.open>.dropdown-toggle.btn-default:hover
	{
	color: #333;
	background-color: #d4d4d4;
	border-color: #fff
}

.form-control {
	border: 1px #fff solid;
	-webkit-box-shadow: none;
    box-shadow: none;
}
.form-group{
	margin-bottom:0;
}
.treeDiv {
	height: 152px;
	overflow-x: hidden;
	overflow: auto;
	text-align: center;
	margin-top: 20px;
	display: none;
}
.paper-outer{
	background-color: #F2F4F8; 
	padding:3% 5% 3% 5%;
}
.paper-inner{
	background-color: white;
	padding:10px 5% 3% 5%;
	-webkit-box-shadow:0 0 10px 2px #666;  
    -moz-box-shadow:0 0 10px 2px #666;  
    box-shadow:0 0 10px 2px #666; 
}
.tablestyle th{
	text-align:center;
	vertical-align:middle;
}
.bootstrap-select > .dropdown-toggle {
  width: 100%;
  padding-right: 25px;
  border-width:0;
}
.btn{
	border-radius:0px;
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
<style type="text/css"></style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
<div class="paper-outer">
	<div class="paper-inner">
		<form id="myFm">
			<p class="tablestyle_title" style="font-size:25pt">文件报批单</p>
			<input type="hidden" id="bizId_" name="bizId_">
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th style="width: 20%;">紧急程度</th>
					<td style="width: 30%;">
						<div class="form-group">
							<select class="selectpicker select" id="urgencyLevel_"
								name="urgencyLevel_" value="" title="请选择">
								<option value="1">平件</option>
								<option value="2">急件</option>
								<option value="3">特急</option>
							</select>
						</div></td>
					<th>密 级</th>
					<td style="width: 30%;">
						<div class="form-group">
							<select class="selectpicker select" id="securityLevel_"
								name="securityLevel_" value="" title="请选择">
								<option value="1">公开</option>
								<option value="2">内部</option>
							</select>
						</div></td>
				</tr>
				<tr>
					<th>主送</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" id="mainSend_"
								name="mainSend_" value="" placeholder="">
						</div></td>
				</tr>
				<tr>
					<th>标题<span class="star">*</span>
					</th>
					<td colspan="3">
						<div class="form-group" style="word-break:break-all;overflow:auto;">
							<input type="text" class="validate[required] form-control input" id="title_"
								name="title_" maxlength="256" value="" placeholder="">
						</div></td>
				</tr>
				<tr>
					<th height="180">院领导批示</th>
					<td colspan="3">
						<table style="width: 100%; height: 100%" id="commentYld_table" class="table_inner commentTable"> 
							<tr class="commentEditBtnGroup" style="height: 30px;">
								<td class="border-bottom">
									<a href="javascript:void(0);" class="LinkButton close-page" onClick="changeEditType('wz',this,'commentYld_');">[文字签批]</a> 
									<a href="javascript:void(0);" class="LinkButton close-page" id="commentYld_btn" onClick="changeEditType('sx',this,'commentYld_');">[手写签批]</a> 
								</td>
							</tr>
							<tr class="commentViewBtnGroup" style="height: 30px;display: none;">
								<td class="border-bottom">
									<a href="javascript:void(0);" class="LinkButton close-page" onClick="changeViewType('wz', this, 'commentYld_');">[文字批示]</a> 
									<a href="javascript:void(0);" class="LinkButton close-page" id="commentYld_btn" onClick="changeViewType('sx', this, 'commentYld_');">[手写批示]</a> 
								</td>
							</tr>
							 
							<tr class="wz" style="display: none">
								<td class="border-none">
									<div class="form-group" style="word-break:break-all;overflow:auto;overflow-y: auto; height: 180px;">
										<textarea class="form-control comment" id="commentYld_"name="commentYld_" style="background-color: white" rows="8" onpropertychange="if(value.length>2048) value=value.substr(0,2048)"></textarea>
										<div id="commentYld_comment" style="padding-top: 10px">${commentYld_}</div>
									</div>
								</td>
							</tr>
							<tr class="sx" style="display: none">
								<td class="border-none">
									<div class="form-group" style="overflow:hidden; height: 180px;">
										<div id="commentYld_signature" style="width: 100%;height: 160px;"></div>
										<div id="commentYld_signature_msg" style="width: 100%;height: 20px;padding-left: 10px;"></div>
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
							<tr class="commentEditBtnGroup" style="height: 30px">
								<td class="border-bottom">
									<a href="javascript:void(0);" class="LinkButton close-page" onClick="changeEditType('wz',this,'commentJld_');">[文字签批]</a> 
									<a href="javascript:void(0);" class="LinkButton close-page" id="commentJld_btn" onClick="changeEditType('sx',this,'commentJld_');">[手写签批]</a> 
								</td>
							</tr>
							<tr class="commentViewBtnGroup" style="height: 30px;display: none;">
								<td class="border-bottom">
									<a href="javascript:void(0);" class="LinkButton close-page" onClick="changeViewType('wz',this,'commentJld_');">[文字批示]</a> 
									<a href="javascript:void(0);" class="LinkButton close-page" id="commentJld_btn" onClick="changeViewType('sx',this,'commentJld_');">[手写批示]</a> 
								</td>
							</tr>
							<tr class="wz" style="display: none">
								<td class="border-none">
									<div class="form-group" style="word-break:break-all;overflow:auto;overflow-y: auto; height: 180px;">
										<textarea class="form-control comment" id="commentJld_"
											name="commentJld_" onpropertychange="if(value.length>2048) value=value.substr(0,2048)" style="background-color: white" rows="8"></textarea>
										<div id="commentJld_comment" style="padding-top: 10px">${commentJld_}</div>
									</div>
								</td>
							</tr>
							<tr class="sx" style="display: none">
								<td class="border-none">
									<div class="form-group" style="overflow:hidden; height: 180px;">
										<div id="commentJld_signature" style="width: 100%;height: 160px;"></div>
										<div id="commentJld_signature_msg" style="width: 100%;height: 20px;padding-left: 10px;"></div>
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
							<tr class="commentEditBtnGroup" style="height: 30px">
								<td class="border-bottom">
									<a href="javascript:void(0);" class="LinkButton close-page" onClick="changeEditType('wz',this,'commentBm_');">[文字签批]</a> 
									<a href="javascript:void(0);" class="LinkButton close-page" id="commentBm_btn" onClick="changeEditType('sx',this,'commentBm_');">[手写签批]</a> 
								</td>
							</tr>
					
							<tr class="commentViewBtnGroup" style="height: 30px;">
								<td class="border-bottom">
									<a href="javascript:void(0);" class="LinkButton close-page" onClick="changeViewType('wz',this);">[文字批示]</a> 
									<a href="javascript:void(0);" class="LinkButton close-page" id="commentBm_btn" onClick="changeViewType('sx',this,'commentBm_');">[手写批示]</a> 
								</td>
							</tr>
							<tr class="wz" style="display: none">
								<td class="border-none">
									<div class="form-group" style="word-break:break-all;overflow:auto;overflow-y: auto; height: 180px;">
										<textarea class="form-control comment" id="commentBm_" name="commentBm_" 
											 onpropertychange="if(value.length>2048) value=value.substr(0,2048)" style="background-color: white" rows="8"></textarea>
										<div id="commentBm_comment" style="padding-top: 10px">${commentBm_}</div>
									</div>
								</td>
							</tr>
							<tr class="sx" style="display: none">
								<td class="border-none">
									<div class="form-group" style="overflow:hidden; height: 180px;">
										<div id="commentBm_signature" style="width: 100%;height: 160px;"></div>
										<div id="commentBm_signature_msg" style="width: 100%;height: 20px;padding-left: 10px;"></div>
									</div>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<th>拟稿部门<span class="star">*</span></th>
					<td>
						<input id="draftDeptId_" class="form-control"
						name="draftDeptId_" type="hidden"
						style="width: 100%; height: 29; border: 0;"
						value="<shiro:principal property='deptId'/>" /> 
						<input id="draftDeptIdName_" name="draftDeptIdName_"
						class="validate[required] form-control select" type="text"
						style="width: 100%; height: 29; border: 0;"
						onclick="deptTree(2,'draftDeptId_');"
						value="<shiro:principal property='deptName'/>" />
					</td>
					<th>拟稿时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="draftTime_" name="draftTime_" value="" style="width: 100%"
								class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />

						</div></td>
				</tr>
				<tr>
					<th>核稿人</th>
					<td>
						<input id="checkUserId_" class="form-control" name="checkUserId_"
						type="hidden" style="width: 100%; height: 29; border: 0;" value="" />
						<input id="checkUserIdName_" name="checkUserIdName_"
						class="form-control select" onclick="peopleTree(1,'checkUserId_')"; 
						 type="text" style="width: 100%; height: 29; border: 0;"
						value="" /></td>
					<th>拟稿人<span class="star">*</span>
					</th>
					<td>
						<input id="draftUserId_" class="form-control" name="draftUserId_"
							type="hidden" style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='id'/>" />
						<input id="draftUserIdName_" name="draftUserIdName_"
							class="validate[required] form-control select" onclick="peopleTree(1,'draftUserId_')"; 
							 type="text" style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='name'/>" />
					</td>
				</tr>
			</table>
			<div class="txm">
			<c:if test="${serialNumber!=''&&serialNumber!=null}">
				<img alt="图片未加载" src="${ctx}/bpmRuFormInfoController/getOneBarcode?barcodeNum=${serialNumber}" />
			</c:if>
			</div>
		</form>
	</div>
</div>
<div id="phrasebook_div" style="width: 300px;height: 150px">
	<iframe id="phrasebook_iframe" src="" width="100%" height="100%"
		frameborder="no" border="0" marginwidth="0" marginheight="0" scrolling="yes"></iframe>
</div>
<%@ include file="/views/aco/common/selectionPeople_tree.jsp"%>
<%@ include file="/views/aco/common/selectionDept_tree.jsp"%>
</body>
<script type="text/javascript">
	/*初始化页面参数*/
	var map = [${keyValueMap}];
	var style = "${style}";
	var tableName = "${tableName}";
	var commentColumn = "${commentColumn}";
	var taskId = "${taskId}";
	var procInstId = "${procInstId}";
	var bizId;
	$(function() {
		if(style == "draft"){
			bizId = window.parent.generateUUID();
			$('#bizId_').val(bizId);
		}else{
			bizId = "${bizId}";
		}
	})
</script>	
<script src="${ctx}/views/aco/dispatch/js/biz_form_common.js"></script>
<!-- 手写签批js -->
<script src="${ctx}/views/aco/dispatch/js/signature.js"></script>
<script src="${ctx}/views/aco/dispatch/js/phrasebook.js"></script>
<script type="text/javascript">
	/*打开手写签批窗口*/
	function openWindow(filedName) { 
		if(commentColumn != null && commentColumn != "" && filedName != null && filedName !="" && commentColumn.indexOf(filedName) > -1){
		    var url="${ctx}/signatureController/openSignature?"
		    		+"bizId="+bizId+"&filedName="+filedName+"&taskId="
		    		+taskId+"&procInstId="+procInstId;//转向网页的地址; 
		    var name="手写签批窗口"; //网页名称，可为空; 
		    var iWidth=500; //弹出窗口的宽度; 
		    var iHeight=300;//弹出窗口的高度; 
		    //获得窗口的垂直位置 
		    var iTop = (window.screen.availHeight - 30 - iHeight) / 2; 
		    //获得窗口的水平位置 
		    var iLeft = (window.screen.availWidth - 10 - iWidth) / 2; 
		    window.open(url, name, "height=" + iHeight + "px,width=" + iWidth + "px,top=" + iTop + ",left=" + iLeft + ",status=no,toolbar=no,menubar=no,location=no,resizable=no,scrollbars=0,titlebar=no"); 
		}
	}
	
	/*为表单手写签批插入签批生成的图片*/
	function setParentWindowPic(filedName, datapair){
		var i = new Image();
		i.onload=function(){
		  this.style.height="100%";
		  this.style.width="100%"; 
		}
		i.src = "data:" + datapair[0] + "," + datapair[1];
		$("#"+filedName+"signature").empty();
		$("#"+filedName+"signature")[0].appendChild(i); 
	}
</script>
</html>