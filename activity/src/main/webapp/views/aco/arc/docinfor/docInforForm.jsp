<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>档案文书档案</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/css/table.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">

<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script src="${ctx}/views/aco/dispatch/js/deptData.js"></script>
<script src="${ctx}/views/aco/arc/docinfor/js/docInforForm.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>
<script>

	var globalUserName = '${username}';
	var globalUserid = '${userid}';
$(function(){
	$("#docCo").focus();
});
</script>

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
	padding: 3% 5% 3% 5%;
}

.paper-inner {
	background-color: white;
	padding: 3% 5% 3% 5%;
}

.tablestyle th {
	text-align: center;
	vertical-align: middle;
}
.bootstrap-select > .dropdown-toggle {
  width: 100%;
  padding-right: 25px;
  border-width:0;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
	<div class="paper-inner">
		<!-- input tab -->
			<form id="docInforForm" enctype="multipart/form-data" class="form-horizontal " target="_top">
				<input type="hidden" id="docInforId" name="arcId" value="${show.docInfor.arcId }">
				<p class="tablestyle_title" style="font-size:25pt">文书档案登记单</p>
				<!-- each input -->
				<table class="tablestyle" width="100%" border="0" cellspacing="0">
					<tr>
						<th>登记人</th>
						<td>
							<div id="regUserDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
<%-- 									<input type="text" id="regUser" name="regUser"
										class="form-control validate[required] input" value="${username }">
									<input type="text" id="regUserId" name="regUserId" value="${userid }" style="display:none;border: 0px currentColor; border-image: none; width: 100%; height: 29px;"> --%>												

									<div id="treeDiv_checkUserId_" class="treeDiv">
										<div id="treeDemo_checkUserId_" class="ztree"
											style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
											<ul id="groupTree_checkUserId_" class="ztree"
												style=""></ul>
										</div>
									</div> <input id="checkUserId_" class="form-control" name="regUserId"
									type="hidden" style="width: 100%; height: 29; border: 0;" value="" />
									<input id="checkUserIdName_" name="regUser"
									class="validate[required] select form-control" 
									onclick="peopleTree(1,'checkUserId_')"; 
									 type="text" style="width: 100%; height: 29; border: 0;"
									value="" />

								</div>
							</div>
						</td>
						<th>登记部门</th>
						<td>
							<div id="regDeptDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
<%-- 									<input type="text" id="regDept" name="regDept" value="${deptname }" class="form-control validate[required]">
									<input type="text" id="regDeptId" name="regDeptId" value="${deptid }" style="display:none;"> --%>
 										<div id="treeDiv_jieyueBumenId_" class="treeDiv" style="display:none;">
											<div id="treeDemo_jieyueBumenId_" class="ztree"
												style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
												<ul id="groupTree_jieyueBumenId_" class="ztree"
													style=""></ul>
											</div>
										</div> 
										<input id="jieyueBumenId_" class="form-control" name="regDeptId" type="hidden" style="width: 100%; height: 29; border: 0;" value="${deptid }" />
										<input id="jieyueBumenIdName_" name="regDeptName" class="validate[required] form-control select" type="text" 
											style="width: 100%; height: 29; border: 0;"
											onclick="peopleTree(2,'jieyueBumenId_');" value="${deptname }" />


								</div>
							</div>
						</td>
					</tr>
					<tr>
						<th>登记日期<span class="star">*</span></th>
						<td>
							<div id="regTimeDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="regTime" name="regTime" style="width: 100%"
										class="form-control select"   value="${show.arcPubInfor.regTime }"
										onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
								</div>
							</div>
						</td>
						<th>档案类型<span class="star">*</span></th>
						<td>
							<div id="arcTypeDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<select class="selectpicker validate[required]" style="width: 100%;" id="arcType"
										name="arcType" value="" myvalue="${show.arcPubInfor.arcType }" title="请选择" >
										<c:forEach items="${arcType }" var="item">
											<option value="${item.getId()}" >${item.getTypeName()}</option>
										</c:forEach>
									</select>
								</div>
							</div>	
						</td>
					</tr>
					<tr>
						<th>文件类型<span class="star">*</span></th>
						<td>
							<div id="fileTypeDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="" id="fileTypeDivCol">
									<select class="selectpicker  validate[required]" style="width: 100%;" id="fileType"
										name="fileType" myvalue="${show.arcPubInfor.fileType }" title="请选择">
										<c:forEach items="${ fileType}" var="item">
											<option value="${item.getId()}" >${item.getTypeName()}</option>
										</c:forEach>
									</select>
								</div>
							</div>
						</td>
						<th>公文种类</th>
						<td>
							<div id="docTypeDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<select class="selectpicker select" style="width: 100%;" id="docType"
										name="docType" myvalue="${show.docInfor.docType }" title="请选择">
										<c:forEach items="${ doctype}" var="item">
											<option value="${item.getValue()}" >${item.getChname()}</option>
										</c:forEach>
									</select>
								</div>
							</div>							
						</td>
					</tr>
					<tr>
						<th>来文单位</th>
						<td>
							<div id="docCoDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="docCo" name="docCo" class="form-control " value="${show.docInfor.docCo }">
								</div>
							</div>						
						</td>
						<th>文号</th>
						<td>
							<div id="docNBRDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="docNBR" name="docNBR" class="form-control " value="${show.docInfor.docNBR }">
								</div>
							</div>						
						</td>
					</tr>
					<tr>
						<th>文件标题<span class="star">*</span></th>
						<td colspan="3">
							<div id="arcNameDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="arcName" name="arcName" value="${show.arcPubInfor.arcName }" class="form-control validate[required] input">
								</div>
							</div>						
						</td>
					</tr>
					<tr>
						<th>页数</th>
						<td>
							<div id="pageNumDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="pageNum" name="pageNum" value="${show.docInfor.pageNum }" class="form-control " >
								</div>
							</div>						
						</td>
						<th>发文时间</th>
						<td>
							<div id="regDeptDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="dptTime" name="dptTime" value="${show.docInfor.dptTime }" class="form-control " onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})">
								</div>
							</div>					
						</td>
					</tr>
					<tr>
						<th>收文时间</th>
						<td>
							<div id="recTimeDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="recTime" name="recTime" value="${show.docInfor.recTime }" class="form-control " onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})">
								</div>
							</div>						
						</td>
						<th>截止时间</th>
						<td>
							<div id="endTimeDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="endTime" name="endTime" value="${show.docInfor.endTime }" class="form-control " onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})">
										<!-- <span  class="laydate-icon" style="width:30px;height:30px;position:absolute;right:5px;float:right;padding-right:1%"  onclick="laydate({elem: '#endTime'});"></span>  -->
								</div>
							</div>							
						</td>
					</tr>
					<tr>
						<th>关键字</th>
						<td colspan="3">
							<div id="keyWordDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="keyWord" name="keyWord" value="${show.arcPubInfor.keyWord }" class="form-control ">
								</div>
							</div>						
						</td>
					</tr>
					<tr>
						<th>存放位置<span class="star">*</span></th>
						<td colspan="3">
							<div id="depPosDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="depPos" name="depPos" value="${show.arcPubInfor.depPos }"
										class="form-control validate[required]">
								</div>
							</div>						
						</td>
					</tr>
					<tr>
						<th>有效期<span class="star">*</span></th>
						<td colspan="3">
							<div id="expiryDateDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<select class="selectpicker select validate[required]" style="width: 100%;" id="expiryDate"
										name="expiryDate" myvalue="${show.arcPubInfor.expiryDate }" title="请选择">
										<c:forEach items="${expiretime }" var="item">
											<option value="${item.getValue()}" >${item.getChname()}</option>
										</c:forEach>
									</select>
								</div>
							</div>						
						</td>
					</tr>	
					<tr>
						<th>备注</th>
						<td colspan="3">
							<div id="remarksDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="remarks" name="remarks" value="${show.arcPubInfor.remarks }"
										class="form-control ">
								</div>
							</div>						
						</td>
					</tr>
					<tr id="guidangDiv" style="">
						<th>归档人</th>
						<td>
							<div id="fileUserDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="fileUser" name="fileUser" value="${show.fileUserName }"
										class="form-control ">
									<input type="text" id="fileUserID" name="fileUserID" value="${show.arcPubInfor.fileUser }" style="display:none;">
								</div>
							</div>
						</td>
						<th>归档日期</th>
						<td>
							<div id="fileTimeDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<input type="text" id="fileTime" name="fileTime" value="${show.arcPubInfor.fileTime }"
										class="form-control ">
								</div>
							</div>						
						</td>
					</tr>																			
				</table>
			</form>
	</div>
</body>

</html>