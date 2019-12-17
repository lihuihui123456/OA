<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>招投标档案查看</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css"  href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/views/aco/dispatch/js/deptData.js"></script>
<script type="text/javascript">
$(function() {
	$("input,select,textarea",$("form[name='arcBidForm']")).attr('readonly',true);
	$("#arcName").val('${bean.arcName}');
	$("#regUser").val('${bean.regUser}');
	$("#regDept").val('${bean.regDept}');
	$("#regTime").val(getDateTime('${bean.regTime}'));
	$("#arcType").val('${bean.arcType}');
	$("#bidName").val('${bean.bidName}');
	$("#proNbr").val('${bean.proNbr}');
	$("#bidTime").val(getDateTime('${bean.bidTime}'));
	$("#bidCo").val('${bean.bidCo}');
	$("#unitCntctUser").val('${bean.unitCntctUser}');
	$("#unitCntct").val('${bean.unitCntct}');
	$("#keyWord").val('${bean.keyWord}');
	var exDate = '${bean.expiryDate}';
	if(exDate=="0"){
		exDate="永久有效";
	}
	if(exDate=="10"){
		exDate="10年";
	}
	if(exDate=="30"){
		exDate="30年";
	}
	$("#expiryDate").val(exDate);
	$("#depPos").val('${bean.depPos}');
	$("#remarks").val('${bean.remarks}');
	$("#fileUser").val('${bean.fileUser}');
	$("#fileTime").val(getDateTime('${bean.fileTime}'));
	
});

function getDateTime(date){
	if(date!=null){
		return date.substring(0,date.length-2);
	}else{
		return "";
	}
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
	position: absolute;
	margin-top: -160px;
	background-image: url('${ctx}/static/arc/images/treeImg.png');
	background-color: black;
}
.paper-outer{
	background-color: #bebebe; 
	padding:3% 5% 3% 5%;
}
.paper-inner{
	background-color: white;
	padding:3% 5% 3% 5%;
}
.tablestyle th{
	text-align:center;
	vertical-align:middle;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
	<div class="paper-inner">
		<form id="arcBidForm" name="arcBidForm">
			<p class="tablestyle_title" style="font-size:25pt">招投标档案登记单</p>
			<input type="hidden" id="arcId" name="arcId">
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>登记人<span class="star">*</span></th>
					<td>
						<input type="text" class="form-control input" id="regUser" name="regUser">
					</td>
					<th>登记部门<span class="star">*</span></th>
					<td>
						<input type="text" class="form-control input" id="regDept" name="regDept">
					</td>
				</tr>
				<tr>
					<th>登记日期</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="regTime" name="regTime" style="width: 100%"
								class="form-control select" />
						</div>
					</td>
					<th>档案类型</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="arcType" name="arcType">
						</div>
					</td>
				</tr>
				<tr>
					<th>文件标题<span class="star">*</span></th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" id="arcName" name="arcName">
						</div>
					</td>
				</tr>
				<tr>
					<th>项目名称<span class="star">*</span></th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" id="bidName" name="bidName">
						</div>
					</td>
				</tr>
				<tr>
					<th>项目编号</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input" id="proNbr" name="proNbr">
						</div>
					</td>
					<th>招标时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="bidTime" name="bidTime" value="" style="width: 100%"
								class="form-control select"/>
						</div>
					</td>
				</tr>
				<tr>
					<th>中标单位<span class="star">*</span></th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" id="bidCo" name="bidCo">
						</div>
					</td>
				</tr>
				<tr>
					<th>中标单位联系人</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input" id="unitCntctUser" name="unitCntctUser">
						</div>
					</td>
					<th>中标单位联系方式</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input" id="unitCntct" name="unitCntct">
						</div>
					</td>
				</tr>
				<tr>
					<th>关键字</th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" id="keyWord" name="keyWord">
						</div>
					</td>
				</tr>
				<tr>
					<th>备注</th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" id="remarks" name="remarks">
						</div>
					</td>
				</tr>
				<tr>
					<th>有效期<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" id="expiryDate" name="expiryDate">
						</div>
					</td>
				</tr>
				<tr>
					<th>存放位置<span class="star">*</span></th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" id="depPos" name="depPos">
						</div>
					</td>
				</tr>
				<tr>
					<th>归档人</th>
					<td>
						<input type="text" class="form-control input" id="fileUser" name=""fileUser"">
					</td>
					<th>归档日期</th>
					<td colspan="3">
							<div class="input-group date" style="width: 100%">
							<input type="text" id="fileTime" name="fileTime" value="" style="width: 100%"
								class="form-control select" />
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>