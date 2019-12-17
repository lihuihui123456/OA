<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>招投标档案</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css"  href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/views/aco/arc/inv/template/js/arcinv-form.js"></script>
<script src="${ctx}/views/aco/dispatch/js/deptData.js"></script>
<script type="text/javascript">
 $(function(){
	 $("#arcName").focus();
	var date_now = getNowFormatDate();
	$("#regTime").val(date_now);
	$('#guidangDiv').find('input').attr('readonly',true).attr('disabled',true);	
});
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    var hour = date.getHours();
    var min = date.getMinutes();
    var sec = date.getSeconds();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    if (hour >= 0 && hour <= 9) {
        hour = "0" + hour;
    }
    if (min >= 0 && min <= 9) {
        min = "0" + min;
    }
    if (sec >= 0 && sec <= 9) {
        sec = "0" + sec;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + hour + seperator2 + min
            + seperator2 + sec;
    return currentdate;
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
						<div id="treeDiv_draftUserId_" class="treeDiv" style="z-index:2">
							<div id="treeDemo_draftUserId_" class="ztree"
								style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
								<ul id="groupTree_draftUserId_" class="ztree"
									style="margin-top: 10px;"></ul>
							</div>
						</div> 
						<input id="draftUserId_" class="form-control" name="draftUserId_"
							type="hidden" style="width: 100%; height: 29px; border: 0;" value="<shiro:principal property='id'/>" />
						<input id="draftUserIdName_"  name="regUser"
							readonly="readonly" class="validate[required] select" onclick="peopleTree(1,'draftUserId_')"; 
							 type="text" style="width: 100%; height: 29px; border: 0;padding:7px 12px;" value="<shiro:principal property='name'/>" />
					</td>
					<th>登记部门<span class="star">*</span></th>
					<td>
						<div id="treeDiv_draftDeptId_" class="treeDiv">
							<div id="treeDemo_draftDeptId_" class="ztree"
								style="width:240px;height:120px; margin-top:24px; overflow:auto;font-size: 13px;">
								<ul id="groupTree_draftDeptId_" class="ztree"
									style="margin-top: 10px;"></ul>
							</div>
						</div> <input id="draftDeptId_" class="form-control" name="draftDeptId_"
						type="hidden" style="width: 100%; height: 29px; border: 0;" value="<shiro:principal property='deptId'/>" />
						<input id="draftDeptIdName_" 
						readonly="readonly" class="validate[required] select" name="regDept" type="text"
						style="width: 100%; height: 29px; border: 0;padding:7px 12px;"
						onclick="peopleTree(2,'draftDeptId_');" value="<shiro:principal property='deptName'/>" />
					</td>
				</tr>
				<tr>
					<th>登记日期</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="regTime" name="regTime" style="width: 100%"
								class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
					<th>档案类型</th>
					<td>
						<div class="form-group">
							<select class="validate[required]  selectpicker select" id="arcType"
								name="arcType" value="" title="请选择">
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>文件标题<span class="star">*</span></th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="validate[required] form-control input" id="arcName" name="arcName">
						</div>
					</td>
				</tr>
				<tr>
					<th>投资项目名称<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input" id="proName" name="proName">
						</div>
					</td>
				</tr>
				<tr>
					<th>投资金额(万元)</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="mny" name="mny">
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
					<th>投资形式</th>
					<td>
						<div class="form-group">
							<select class="selectpicker select" id="invType"
								name="invType" value="" title="请选择">
								<option value="0">货币</option>
								<option value="1">无形资产</option>
							</select>
						</div>
					</td>
					<th>投资时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="invTime" name="invTime" value="" style="width: 100%"
								class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
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
					<th>投资收益处置</th>
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
						<div class="input-group date" style="width: 100%">
							<input type="text" id="startTime" name="startTime" value="" style="width: 100%"
								class="form-control select"
								 />
						</div>
					</td>
					<th>项目结束时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="endTime" name="endTime" value="" style="width: 100%"
								class="form-control select"
								 />
						</div>
					</td>
					<script>
							var starttime = {
							  elem: '#startTime',
							  format: 'YYYY-MM-DD hh:mm:ss',
							  min: laydate.now(), //设定最小日期为当前日期
							  max: '2099-06-16 23:59:59', //最大日期
							  istime: true,
							  istoday: false,
							  choose: function(datas){
								  endtime.min = datas; //开始日选好后，重置结束日的最小日期
								  endtime.start = datas //将结束日的初始值设定为开始日
							  }
							};
							var endtime = {
							  elem: '#endTime',
							  format: 'YYYY-MM-DD hh:mm:ss',
							  min: laydate.now(),
							  max: '2099-06-16 23:59:59',
							  istime: true,
							  istoday: false,
							  choose: function(datas){
								  starttime.max = datas; //结束日选好后，重置开始日的最大日期
							  }
							};
							laydate(starttime);
							laydate(endtime);
						</script>
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
						<div class="input-group date" style="width: 100%">
							<input type="text" id="invRegTime" name="invRegTime" value="" style="width: 100%"
								class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
					<th>注册资本(万元)</th>
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
							<select class="validate[required]  selectpicker select" id="expiryDate"
								name="expiryDate" value="" title="请选择">
								<option value="0">永久有效</option>
								<option value="10">10年</option>
								<option value="30">30年</option>								
							</select>
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
				<tr id="guidangDiv">
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