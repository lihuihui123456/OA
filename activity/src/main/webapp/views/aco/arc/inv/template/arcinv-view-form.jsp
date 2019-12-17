<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>投资项目档案-查看</title>
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
	$("input,select,textarea",$("form[name='arcInvForm']")).attr('readonly',true);
	$("#arcName").val('${bean.arcName}');
	$("#regUser").val('${bean.regUser}');
	$("#regDate").val(getDateTime('${bean.regTime}'));
	$("#regDept").val('${bean.regDept}');
	$("#arcType").val('${bean.arcType}');
	$("#proName").val('${bean.proName}');
	$("#mny").val('${bean.mny}');
	$("#invPro").val('${bean.invPro}');
	if('${bean.invType}'=="0"){
		$("#invType").val("货币");
	}else{
		$("#invType").val("无形资产");
	}
	$("#invDate").val(getDateTime('${bean.invTime}'));
	$("#bankSrc").val('${bean.bankSrc}');
	$("#invIncm").val('${bean.invIncm}');
	$("#invDeal").val('${bean.invDeal}');
	$("#proSource").val('${bean.proSource}');
	$("#proMny").val('${bean.proMny}');
	$("#startDate").val(getDateTime('${bean.startTime}'));
	$("#endDate").val(getDateTime('${bean.endTime}'));
	$("#legalPrsn").val('${bean.legalPrsn}');
	$("#invRegDate").val('${bean.invRegDate}');
	$("#regCap").val('${bean.regCap}');
	$("#dir").val('${bean.dir}');
	$("#spvs").val('${bean.spvs}');
	$("#regAdd").val('${bean.regAdd}');
	$("#mainCore").val('${bean.mainCore}');
	$("#keyWord").val('${bean.keyWord}');
	$("#remarks").val('${bean.remarks}');
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
	$("#fileTime").val(getDateTime('${bean.fileTime}'));
	$("#fileUser").val('${bean.fileUser}');
	
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
	background-image: url('${ctx}/views/aco/dispatch/img/treeImg.png');
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
		<form id="arcInvForm" name="arcInvForm">
			<p class="tablestyle_title" style="font-size:25pt">项目投资档案登记单</p>
			<input type="hidden" id="arcId" name="arcId">
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>登记人<span class="star">*</span></th>
					<td>
						<input id="regUser" name="regUser" class="form-control select" type="text" style="width: 100%; height: 29; border: 0;" />
					</td>
					<th>登记部门<span class="star">*</span></th>
					<td>
						<input id="regDept" name="regDept" class="form-control select" name="draft_depart_name" type="text" style="width: 100%; height: 29; border: 0;" />
					</td>
				</tr>
				<tr>
					<th>登记日期</th>
					<td>
						<input type="text" id="regDate" name="regDate" style="width: 100%" class="form-control select" />
					</td>
					<th>档案类型</th>
					<td>
						<input type="text" id="arcType" name=""arcType"" style="width: 100%" class="form-control select" />
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
					<th>投资项目名称<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" id="proName" name="proName">
						</div>
					</td>
				</tr>
				<tr>
					<th>投资金额（万元）</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="mny" name="mny" style="width: 100%" class="form-control select" />
						</div>
					</td>
					<th>投资占比</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="invPro" name="invPro">
						</div>
					</td>
				</tr>
				<tr>
					<th>投资形式<span class="star">*</span></th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="invType" name="invType">
						</div>
					</td>
					<th>投资时间</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input" id="invDate" name="invDate">
						</div>
					</td>
				</tr>
				<tr>
					<th>资金来源</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" id="bankSrc" name="bankSrc">
						</div>
					</td>
				</tr>
				<tr>
					<th>投资收益情况</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" id="invIncm" name="invIncm">
						</div>
					</td>
				</tr>
				<tr>
					<th>透支收益支出</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" id="invDeal" name="invDeal">
						</div>
					</td>
				</tr>
				<tr>
					<th>项目来源</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="proSource" name="proSource">
						</div>
					</td>
					<th>项目金额</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input" id="proMny" name="proMny">
						</div>
					</td>
				</tr>
				<tr>
					<th>项目开始时间</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="startDate" name="startDate">
						</div>
					</td>
					<th>项目结束时间</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input" id="endDate" name="endDate">
						</div>
					</td>
				</tr>
				<tr>
					<th colspan="4">注册信息</th>
				</tr>
				<tr>
					<th>法人</th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" id="legalPrsn" name="legalPrsn">
						</div>
					</td>
				</tr>
				<tr>
					<th>注册时间</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="invRegDate" name="invRegDate">
						</div>
					</td>
					<th>注册资本</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input" id="regCap" name="regCap">
						</div>
					</td>
				</tr>
				<tr>
					<th>董事</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="dir" name="dir">
						</div>
					</td>
					<th>监事</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input" id="spvs" name="spvs">
						</div>
					</td>
				</tr>
				<tr>
					<th>注册地</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="regAdd" name="regAdd">
						</div>
					</td>
					<th>主营业务</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input" id="mainCore" name="mainCore">
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
							<input type="text" class="validate[required] form-control input" id="depPos" name="depPos">
						</div>
					</td>
				</tr>
				<tr>
					<th>归档人</th>
					<td>
						<input type="text" class="validate[required] form-control input" id="fileUser" name="fileUser">
					</td>
					<th>归档日期</th>
					<td colspan="3">
						<div class="input-group date" style="width: 100%">
							<input type="text" class="form-control input" id="fileTime" name="fileTime">
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
</body>
</html>