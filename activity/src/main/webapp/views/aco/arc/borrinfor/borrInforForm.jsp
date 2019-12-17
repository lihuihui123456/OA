<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>借阅管理</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">

<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">

<script src="${ctx}/views/aco/arc/borrinfor/js/borrInforForm.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script
	src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>

<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script src="${ctx}/views/aco/dispatch/js/deptData.js"></script>

<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>

<script type="text/javascript">
	var globalCTX = '${ctx}';
	 $(function(){
		 $("#arcName").focus();
	});
	var globalmyArra='';
	function attachFile(){
		$('#myModal').modal('show');
		$('#group').attr("src","${ctx}/borrInforConn/enclosureFileForm");
		//清除数据
		bizid_attach='';
	}
	
	//保存关联信息
	function saveAttach(){
		//group
		var myArrya = null;
		try{
			var myArray=document.getElementById("group").contentWindow.saveAttach();
		}catch(err){
			return null;
		}
		//arcId、arcName、id、fileName
		$('#myModal').modal('hide');
		globalmyArra = myArray;
		$('#arcName').val(myArray[1]);
		$('#arcId').val(myArray[1]);
		//empty the attachment
		$('#borrInforAttList').empty();
		//return myArray;
		$('<input name="serialNumber" id="'+myArray[2]+'" type="hidden" value="">').appendTo('#borrInforAttList');
		$('<input name="id" id="'+myArray[2]+'_i" type="checkbox" disabled="disabled" checked="checked" value="'+myArray[2]+'">').appendTo('#borrInforAttList');
		$('<a id="'+myArray[2]+'_a" href="/cap-aco/media/download?documentId='+myArray[2]+'">'+myArray[3]+'</a>').appendTo('#borrInforAttList');
		//var temp = [{'attId':myArray[2],'arcName':myArray[1],'attName':myArray[3]}];
		return myArray;
	}
	
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
			<form id="borrInforForm" enctype="multipart/form-data" class="form-horizontal " target="_top">
				<p class="tablestyle_title" style="font-size:25pt">借阅登记单</p>
				<!-- each input -->
				<table class="tablestyle" width="100%" border="0" cellspacing="0">
					<tr>
						<th>借阅单号</th>
						<td>
							<div id="borNBRDiv" class="" style="margin-left: 0; margin-right: 0">
									<input type="text" id="borNBR" name="borNBR" readonly="readonly"
										class="form-control  input" value="${borNBR }">
							</div>
						</td>
						<th>单号日期</th>
						<td>
							<div id="nbrTimeDiv" class="" style="margin-left: 0; margin-right: 0">
									<input type="text" id="nbrTime" name="nbrTime" value="" class="form-control " onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})">
							</div>
						</td>
					</tr>
					<tr>
						<th>借阅部门<span class="star">*</span></th>
						<td>
							<div id="borrDeptDiv" class="" style="margin-left: 0; margin-right: 0">
								<div id="treeDiv_jieyueBumenId_" class="treeDiv" style="display:none;">
									<div id="treeDemo_jieyueBumenId_" class="ztree"
										style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
										<ul id="groupTree_jieyueBumenId_" class="ztree"
											style=""></ul>
									</div>
								</div> 
								<input id="jieyueBumenId_" class="form-control" name="borrDept" type="hidden" style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='deptId'/>" />
								<input id="jieyueBumenIdName_" name="borrDeptName" class="validate[required] form-control select" type="text" 
									style="width: 100%; height: 29; border: 0;"
									onclick="peopleTree(2,'jieyueBumenId_');" value="${show.borrInfor.borrDept }" /> 
							</div>							
						</td>						
						<th>借阅人<span class="star">*</span></th>
						<td>
							<div id="borrUserDiv" class="" style="margin-left: 0; margin-right: 0">
<%-- 									<input type="text" id="borrUser" name="borrUser" value="${show.borrInfor.borrUser }" class="form-control input validate[required]"  > --%>
							
									<div id="treeDiv_checkUserId_" class="treeDiv">
										<div id="treeDemo_checkUserId_" class="ztree"
											style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
											<ul id="groupTree_checkUserId_" class="ztree"
												style=""></ul>
										</div>
									</div> <input id="checkUserId_" class="form-control" name="borrUser"
									type="hidden" style="width: 100%; height: 29; border: 0;" value="" />
									<input id="checkUserIdName_" name="regUserName"
									class="validate[required] form-control select"  
									onclick="peopleTree(1,'checkUserId_')"; 
									 type="text" style="width: 100%; height: 29; border: 0;"
									value="" />							
							</div>
						</td>
					</tr>
					<tr>
						<th>借阅时间</th>
						<td>
							<div id="borrTimeDiv" class="" style="margin-left: 0; margin-right: 0">
								<input type="text" id="borrTime" name="borrTime" value="${show.borrInfor.borrTime }" onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" class="form-control input" maxlength=10 >
							</div>
						</td>
						<th>借阅人电话</th>
						<td>
							<div id="borrMobileDiv" class="" style="margin-left: 0; margin-right: 0">
								<input type="text" id="borrMobile" name="borrMobile" value="${show.borrInfor.borrMobile }" class="form-control input" maxlength=11 >
							</div>	
						</td>
					</tr>
<!-- 					<tr>
						<th>文件标题<span class="star">*</span></th>
						<td colspan="3">
							<div id="arcIdDiv" class="" style="margin-left: 0; margin-right: 0">
									<input type="text" id="arcId" name="arcId" style="display:none;" value="${show.borrInfor.arcId }">
									<input type="text" id="arcName" name="arcName" class="form-control validate[required] " value="${show.arcName}">
									<button type="button" id="btn_search" class="btn btn-default" onclick="search();">查找</button>
							</div>						
						</td>
					</tr> -->
					<tr>
						<th>文件标题<span class="star">*</span></th>
						<td colspan="3">
							<div class="panel-body"> 
								<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
									<input type="text" id="arcName" name="arcName" class="form-control validate[required] " value="${show.arcName}">
									<input type="text" id="arcId" name="arcId" style="display:none;" value="${show.borrInfor.arcId }">
								</div>
				          		<span id="findattachFile" style="float:left;"></span>
								<div class="btn-group" role="group" aria-label="..." style="float:right;margin-top:10px;margin-bottom:10px;">
										<button type="button" class="btn btn-default" onclick="attachFile()">
											<i class="fa  fa-link"></i>&nbsp;引用
										</button>
								</div>
				            </div> 
						</td>
					</tr>
<!-- 					<tr>
						<td colspan="4">
							<div>标题查询结果</div>
							<div id="arcPubTable"></div>
						</td>
					</tr> -->
					<tr>
						<td colspan="4">
							<div>档案附件</div>
							<!-- attachment 列表 -->
							<div id="borrInforAttList" style="padding:10px;">
							</div>
						</td>
					</tr>
					<tr>
						<th>借阅类型</th>
						<td>
							<div id="borrTypeDiv" class="" style="margin-left: 0; margin-right: 0">
								<div class="">
									<select class="selectpicker select" style="width: 100%;" id="borrType"
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
								<div class="col-sm-8">
									<input id="isSetY" type="radio" class="isSet" name="isSet" value="Y" />是 
									<input id="isSetN" type="radio" class="isSet" name="isSet" value="N" />否
								</div>
							</div>						
						</td>
					</tr>
					<tr>
						<th>领导意见</th>
						<td colspan="3">
							<div id="keyWordDiv" class="" style="margin-left: 0; margin-right: 0">
								<input type="text" id="leaderOpinion" name="leaderOpinion" value="${show.borrInfor.leaderOpinion }" class="form-control ">
							</div>
						</td>
					</tr>
					<tr id="isSetTimeDiv">
						<th id="planTimeTh">计划归还时间<span class="star">*</span></th>
						<td>
							<div id="planTimeDiv" class="" style="margin-left: 0; margin-right: 0">
									<input type="text" id="planTime" name="planTime" value="${show.borrInfor.planTime }"
										class="form-control select validate[required]">
							</div>						
						</td>
						<th>实际归还时间</th>
						<td>
							<div id="actlTimeDiv" class="" style="margin-left: 0; margin-right: 0">
									<input type="text" id="actlTime" name="actlTime" value=""
										class="form-control select" />
									<script>
									var starttime = {
									  elem: '#planTime',
									  format: 'YYYY-MM-DD hh:mm:ss',
									  //min: laydate.now(), //设定最小日期为当前日期
									  max: '2099-06-16', //最大日期
									  istime: true,
									  istoday: false/* ,
									  choose: function(datas){
										  endtime.min = datas; //开始日选好后，重置结束日的最小日期
										  endtime.start = datas //将结束日的初始值设定为开始日
									  } */
									};
									var endtime = {
									  elem: '#actlTime',
									  format: 'YYYY-MM-DD hh:mm:ss',
									  //min: laydate.now(),
									  max: '2099-06-16',
									  istime: true,
									  istoday: true/* ,
									  choose: function(datas){
										  starttime.max = datas; //结束日选好后，重置开始日的最大日期
									  } */
									};
									laydate(starttime);
									laydate(endtime);
								</script>
							</div>						
						</td>
					</tr>
					<tr>
						<th>备注</th>
						<td colspan="3">
							<div id="remarksDiv" class="" style="margin-left: 0; margin-right: 0">
									<input type="text" id="remarks" name="remarks" value="${show.borrInfor.remarks }"
										class="form-control ">
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
									<input type="text" id="creTime" name="creTime" value="${show.borrInfor.creTime }"
										class="form-control ">
							</div>						
						</td>
					</tr>																			
				</table>
			</form>
		<!-- 关联平台内的文件  -->
		<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
			<div class="modal-dialog modal-lg">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h3 class="modal-title" id="myModalLabel">档案附件关联查询</h3>
					</div>
					<div class="modal-body" >
						<iframe id="group" runat="server" width="100%" height="350" frameborder="no" border="0" marginwidth="0"
							 marginheight="0" scrolling="yes" allowtransparency="yes"></iframe>
					</div>
					<div class="modal-footer" style="text-align:center">
						<button type="button" class="btn btn-primary btn-sm" onclick="saveAttach()" >确定</button>
	  					<button type="button" class="btn btn-primary btn-sm" data-dismiss="modal" >关闭</button>
					</div>
				</div>
			</div>
		</div>		
	</div>	
</body>
</html>