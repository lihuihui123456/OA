<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>招投标档案修改</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css"  href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script src="${ctx}/views/aco/dispatch/js/deptData.js"></script>
<script src="${ctx}/views//aco/arc/arcbid/template/js/arcbid-form.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>
<script>

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
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
	<div class="paper-inner">
		<form id="arcBidForm" name="arcBidForm">
			<p class="tablestyle_title" style="font-size:25pt">招投标档案登记单</p>
			<input type="hidden" id="arcId" name="arcId" value='${bean.arcId}'>
			<input type="hidden" id="id" name="id" value='${bean.id}'>
		 	<input type="hidden" id="type" name="type" value='${type}'>
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
						<input id="draftUserIdName_" name="regUser" readOnly="true"
							class="validate[required] select"  
							onclick="peopleTree(1,'draftUserId_')"; 
							 type="text" style="width: 100%; height: 29px; border: 0;padding:7px 12px;" value='${bean.regUser}' />
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
						<input id="draftDeptIdName_" name="regDept"
						class="validate[required]  select" readOnly="true" name="draft_depart_name" type="text"
						style="width: 100%; height: 29px; border: 0;padding:7px 12px;"
						onclick="peopleTree(2,'draftDeptId_');" value='${bean.regDept}' />
					</td>
				</tr>
				<tr>
					<th>登记日期</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="regTime" name="regTime" style="width: 100%"
								class="form-control select" value=''
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
					<th>档案类型</th>
					<td>
						<div class="form-group">
							<select class="selectpicker validate[required]  " id="arcType"
								name="arcType" value="${bean.arcTypeId}" myvalue="${bean.arcTypeId}" title="">
								<option value="${bean.arcTypeId}">${bean.arcType}</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>文件标题<span class="star">*</span></th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="validate[required] form-control input" id="arcName" name="arcName" value='${bean.arcName}'>
						</div>
					</td>
				</tr>
				<tr>
					<th>项目名称<span class="star">*</span></th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="validate[required] form-control input" value='${bean.bidName}' id="bidName" name="bidName">
						</div>
					</td>
				</tr>
				<tr>
					<th>项目编号</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input" id="proNbr" value='${bean.proNbr}' name="proNbr">
						</div>
					</td>
					<th>招标时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="bidTime" name="bidTime" style="width: 100%"
								class="form-control select" value=''
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
				</tr>
				<tr>
					<th>中标单位<span class="star">*</span></th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" value='${bean.bidCo}' id="bidCo" name="bidCo">
						</div>
					</td>
				</tr>
				<tr>
					<th>中标单位联系人</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input" value='${bean.unitCntctUser}' id="unitCntctUser" name="unitCntctUser">
						</div>
					</td>
					<th>中标单位联系方式</th>
					<td>
							<div class="form-group">
							<input type="text" class="form-control input"  value='${bean.unitCntct}' id="unitCntct" name="unitCntct">
						</div>
					</td>
				</tr>
				<tr>
					<th>关键字</th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" id="keyWord" value='${bean.keyWord}' name="keyWord">
						</div>
					</td>
				</tr>
				<tr>
					<th>备注</th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" value='${bean.remarks}' id="remark" name="remarks">
						</div>
					</td>
				</tr>
				<tr>
					<th>有效期<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<select class="validate[required]  selectpicker select" id="expiryDate" name="expiryDate"
								   <option value=""></option>
								   <option <c:if test="${bean.expiryDate==10}"> selected="selected"</c:if>  value="10">10年</option>
								   <option <c:if test="${bean.expiryDate==30}"> selected="selected"</c:if>  value="30">30年</option>
                                   <option <c:if test="${bean.expiryDate==0}"> selected="selected"</c:if>  value="0">永久有效</option>                                                
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>存放位置<span class="star">*</span></th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="validate[required] form-control input"  value='${bean.depPos}' id="depPos" name="depPos">
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
<script type="text/javascript">
var type = '${type}';
var regTime = '${bean.regTime}';
var bidTime = '${bean.bidTime}';
$("#regTime").val(regTime.substring(0,regTime.length-2)); 
$("#bidTime").val(bidTime.substring(0,bidTime.length-2));
</script>
</html>