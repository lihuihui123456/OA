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
<!-- 引入自定义手写插件用于生成意见域 -->
<script src="${ctx}/views/aco/dispatch/js/mySignature.js"></script>
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
					<th>院领导批示</th>
					<td colspan="3">
						<div class="commentDiv" id="commentYld_Div"></div>
					</td>
				</tr>
				<tr>
					<th>局领导批示</th>
					<td colspan="3">
						<div class="commentDiv" id="commentJld_Div"></div>
					</td>
				</tr>
				<tr>
					<th>部门负责人</th>
					<td colspan="3">
						<div class="commentDiv" id="commentBm_Div"></div>
					</td>
				</tr>
				<tr>
					<th>拟稿部门<span class="star">*</span></th>
					<td>
						<input id="draftDeptId_" class="form-control" name="draftDeptId_" type="hidden"
							style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='deptId'/>" /> 
						<input id="draftDeptIdName_" name="draftDeptIdName_" class="validate[required] form-control select" type="text"
							style="width: 100%; height: 29; border: 0;" onclick="deptMoreTree(2,'draftDeptId_');"
							value="<shiro:principal property='deptName'/>" />
					</td>
					<th>拟稿时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input class="form-control select" type="text" id="draftTime_" name="draftTime_" value="" style="width: 100%"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div></td>
				</tr>
				<tr>
					<th>核稿人</th>
					<td>
						<input id="checkUserId_" class="form-control" name="checkUserId_"
							type="hidden" style="width: 100%; height: 29; border: 0;" value="" />
						<input id="checkUserIdName_" name="checkUserIdName_"
							class="form-control select" onclick="peopleMoreTree(1,'checkUserId_')"; 
						 	type="text" style="width: 100%; height: 29; border: 0;"/></td>
					<th>拟稿人<span class="star">*</span>
					</th>
					<td>
						<input id="draftUserId_" class="form-control" name="draftUserId_"
							type="hidden" style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='id'/>" />
						<input class="validate[required] form-control select" id="draftUserIdName_" name="draftUserIdName_"
							onclick="peopleTree(1,'draftUserId_')"; type="text" 
							style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='name'/>" />
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
<%@ include file="/views/aco/common/selectionMorePeople_tree.jsp"%>
<%@ include file="/views/aco/common/selectionDept_tree.jsp"%>
<%@ include file="/views/aco/common/selectionMoreDept_tree.jsp"%>
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
		//生成意见域
		$(".commentDiv").mySignature();
		
		if(style == "draft"){
			bizId = window.parent.generateUUID();
			$('#bizId_').val(bizId);
		}else{
			bizId = "${bizId}";
		}
	});
</script>	
<!-- 业务表单公共js 必须引入  -->
<script src="${ctx}/views/aco/dispatch/js/biz_form_common.js"></script>
<!-- 业务表单意见处理公共js 必须引入 -->
<script src="${ctx}/views/aco/dispatch/js/signature.js"></script>
<script src="${ctx}/views/aco/dispatch/js/phrasebook.js"></script>
</html>