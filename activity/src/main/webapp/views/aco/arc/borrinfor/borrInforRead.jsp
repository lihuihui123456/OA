<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>借阅管理档案</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/css/table.css"
	rel="stylesheet">

<link rel="stylesheet" type="text/css"
	href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">

<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
	
<script type="text/javascript">
	var showBorrisSet = '${show.borrInfor.isSet}'; 
	var globalCTX = '${ctx}';
</script>
	
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
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
			<div class="paper-inner">
				<!-- input tab -->
					<form id="borrInforForm" enctype="multipart/form-data" class="form-horizontal " target="_top">
						<p class="tablestyle_title" style="font-size:25pt">借阅登记单</p>
						<!-- each input -->
						<table class="tablestyle" width="100%" border="0" cellspacing="0">
							<tr>
								<th>借阅单号</th>
								<td>
									<div id="borNBRDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input type="text" id="borNBR" name="borNBR"
												class="form-control validate[required] input" value="${show.borrInfor.borNBR }">
										</div>
									</div>
								</td>
								<th>单号日期</th>
								<td>
									<div id="nbrTimeDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input type="text" id="nbrTime" name="nbrTime" value="${show.borrInfor.nbrTime}" class="form-control validate[required]" >
										</div>
									</div>
								</td>
							</tr>
							<tr>
								<th>借阅部门<span class="star">*</span></th>
								<td>
									<div id="borrDeptDiv" class="" style="margin-left: 0; margin-right: 0">
										<div >
											<input type="text" class="form-control input" value="${show.jieyueBumen }">
										</div>
									</div>							
								</td>								
								<th>借阅人<span class="star">*</span></th>
								<td>
									<div id="borrUserDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input type="text" id="borrUser" name="borrUser" value="${show.borrUserName }" class="form-control input" maxlength=10 >
										</div>
									</div>
								</td>
							

							</tr>
							<tr>
								<th>借阅时间</th>
								<td>
									<div id="borrTimeDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="" id="fileTypeDivCol">
											<input type="text" id="borrTime" name="borrTime" value="${show.borrInfor.borrTime }" class="form-control input" maxlength=10 >
										</div>
									</div>
								</td>
								<th>借阅人电话</th>
								<td>
									<div id="borrMobileDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input type="text" id="borrMobile" name="borrMobile" value="${show.borrInfor.borrMobile }" class="form-control input" maxlength=10 >
										</div>
									</div>	
								</td>
							</tr>
							<tr>
								<th>文件标题<span class="star">*</span></th>
								<td colspan="3">
									<div id="arcIdDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input type="text" id="arcId" name="arcId" style="display:none;" value="${show.borrInfor.arcId }">
											<input type="text" id="arcName" name="arcName" class="form-control " value="${show.arcName}">
											<input type="text" id="attId" name="attId" style="display:none;" value="${show.borrInfor.attId }">
										</div>
									</div>						
								</td>
							</tr>
							<tr>
								<td colspan="4">
									<!-- attachment 列表 -->
									<div id="borrInforAttList" style="padding:10px;">
										<input type="checkbox" checked="checked" disabled="disableds" value="">
										<a href="${ctx }/media/download?documentId=${show.borrInfor.attId }">${attName }</a>
									</div>
								</td>
								
							</tr>
							<tr>
								<th>借阅类型</th>
								<td>
									<div id="borrTypeDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<select class="selectpicker select" style="width: 100%;" id="borrDept"
												name="borrType" myvalue="${show.borrInfor.borrType }" title="请选择">
												<c:forEach items="${ borrType}" var="item">
													<option value="${item.getValue()}" >${item.getChname()}</option>
												</c:forEach>
											</select>
										</div>
									</div>						
								</td>
								<th>借阅数</th>
								<td>
									<div id="borrSHRDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<select class="selectpicker select" style="width: 100%;" id="borrSHR"
												name="borrSHR" myvalue="${show.borrInfor.borrSHR }" title="请选择">
												<c:forEach items="${ borrSHR}" var="item">
													<option value="${item.getValue()}" >${item.getChname()}</option>
												</c:forEach>
											</select>											
										</div>
									</div>					
								</td>
							</tr>
							<tr>
								<th>是否需要归还</th>
								<td colspan="3">
									<div id="isSetDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input id="isSetY" type="radio" class="isSet" name="isSet" value="Y" />是 
											<input id="idSetN" type="radio" class="isSet" name="isSet" value="N" />否
										</div>
									</div>						
								</td>
							</tr>
							<tr>
								<th>领导意见</th>
								<td colspan="3">
									<div id="keyWordDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input type="text" id="keyWord" name="keyWord" value=" ${show.borrInfor.leaderOpinion } " class="form-control ">
										</div>
									</div>						
								</td>
							</tr>
							<tr id="isSetTimeDiv">
								<th>计划归还时间<span class="star">*</span></th>
								<td>
									<div id="planTimeDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input type="text" id="planTime" name="planTime" value="${show.borrInfor.planTime }"
												class="form-control validate[required]">
										</div>
									</div>						
								</td>
								<th>实际归还时间</th>
								<td>
									<div id="actlTimeDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input type="text" id="actlTime" name="actlTime" value="${show.borrInfor.actlTime }"
												class="form-control validate[required]">
										</div>
									</div>						
								</td>
							</tr>
							<tr>
								<th>备注</th>
								<td colspan="3">
									<div id="remarksDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input type="text" id="remarks" name="remarks" value="${show.borrInfor.remarks }"
												class="form-control ">
										</div>
									</div>						
								</td>
							</tr>
							<tr>
								<th>办理人</th>
								<td>
									<div id="creUserDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input type="text" id="creUserName" name="creUserName" value="${creUserName }"
												class="form-control ">
											<input type="text" id="creUser" name="creUser" value="${creUserId }" style="display:none;">
										</div>
									</div>
								</td>
								<th>办理时间</th>
								<td>
									<div id="creTimeDiv" class="" style="margin-left: 0; margin-right: 0">
										<div class="">
											<input type="text" id="creTime" name="creTime" value="${show.borrInfor.creTime }"
												class="form-control">
										</div>
									</div>						
								</td>
							</tr>																			
						</table>
					</form>
			</div>			
</body>
<script src="${ctx}/views/aco/arc/borrinfor/js/borrInforRead.js"></script>
</html>