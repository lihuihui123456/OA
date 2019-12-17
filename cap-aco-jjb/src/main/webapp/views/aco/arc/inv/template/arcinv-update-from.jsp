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
<script type="text/javascript">
var type = window.parent.$('#type').val();
$(function() {
	$("#arcName").focus();
	if(type=="addFile"){
		$("input,select,textarea",$("form[name='arcInvForm']")).attr("disabled","disabled");
	}
	
});
</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="paper-outer">
	<div class="paper-inner">
		<form id="arcInvForm" name="arcInvForm">
			<p class="tablestyle_title" style="font-size:25pt">项目投资档案登记单</p>
			<input type="hidden" id="arcId" name="arcId" value='${bean.arcId}'>
			<input type="hidden" id="id" name="id" value='${bean.id}'>
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
						<input id="draftUserIdName_" name="regUser"
							class="validate[required] select" readonly="readonly" 
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
						<input id="draftDeptIdName_" name="regDept" type="text"
						class="validate[required]  select" readonly="readonly"
						style="width: 100%; height: 29px; border: 0;padding:7px 12px;"
						onclick="peopleTree(2,'draftDeptId_');" value='${bean.regDept}' />
					</td>
				</tr>
				<tr>
					<th>登记日期</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="regTime" name="regTime" style="width: 100%"
								class="form-control select" value='<fmt:formatDate value='${bean.regTime}'  pattern='yyyy-MM-dd HH:mm:ss'/>'
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
					<th>档案类型</th>
					<td>
						<div class="form-group">
							<select class="validate[required]  selectpicker select" id="arcType"
								name="arcType" value="" title="请选择">
								<option value='${bean.arcTypeId}'>'${bean.arcType}'</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>文件标题<span class="star">*</span></th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="validate[required] form-control input" value='${bean.arcName}' id="arcName" name="arcName">
						</div>
					</td>
				</tr>
				<tr>
					<th>投资项目名称<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input" value='${bean.proName}' id="proName" name="proName">
						</div>
					</td>
				</tr>
				<tr>
					<th>投资金额(万元)</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" value='${bean.mny}' id="mny" name="mny">
						</div>
					</td>
					<th>投资占比</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" value='${bean.invPro}' id="invPro" name="invPro">
						</div>
					</td>
				</tr>
				<tr>
					<th>投资形式</th>
					<td>
						<div class="form-group">
							<select class="validate[required]  selectpicker select" id="invType" name="invType"
								   <option value=""></option>
								   <option <c:if test="${bean.invType==0}"> selected="selected"</c:if>  value="0">货币</option>
								   <option <c:if test="${bean.invType==1}"> selected="selected"</c:if>  value="1">无形资产</option>
							</select>
						</div>
					</td>
					<th>投资时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="invTime" name="invTime" style="width: 100%"
								class="form-control select" value='<fmt:formatDate value='${bean.invTime}'  pattern='yyyy-MM-dd HH:mm:ss'/>'
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
				</tr>
				<tr>
					<th>资金来源</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" value='${bean.bankSrc}' id="bankSrc" name="bankSrc">
						</div>
					</td>
				</tr>
				<tr>
					<th>投资收益情况</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" value='${bean.invIncm}' id="invIncm" name="invIncm">
						</div>
					</td>
				</tr>
				<tr>
					<th>投资收益处置</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="form-control input" value='${bean.invDeal}' id="invDeal" name="invDeal">
						</div>
					</td>
				</tr>
				<tr>
					<th>项目来源</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" value='${bean.proSource}' id="proSource" name="proSource">
						</div>
					</td>
					<th>项目金额</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" value='${bean.proMny}' id="proMny" name="proMny">
						</div>
					</td>
				</tr>
				<tr>
					<th>项目开始时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="startTime" name="startTime" style="width: 100%"
								class="form-control select" value='<fmt:formatDate value='${bean.startTime}'  pattern='yyyy-MM-dd HH:mm:ss'/>'
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
					<th>项目结束时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="endTime" name="endTime" style="width: 100%"
								class="form-control select" value='<fmt:formatDate value='${bean.endTime}'  pattern='yyyy-MM-dd HH:mm:ss'/>'
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
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
							<input type="text" class="form-control input" value='${bean.legalPrsn}' id="legalPrsn" name="legalPrsn">
						</div>
					</td>
				</tr>
				<tr>
					<th>注册时间</th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="invRegTime" name="invRegTime" style="width: 100%"
								class="form-control select" value='<fmt:formatDate value='${bean.invRegTime}'  pattern='yyyy-MM-dd HH:mm:ss'/>'
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
					<th>注册资本(万元)</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" value='${bean.regCap}' id="regCap" name="regCap">
						</div>
					</td>
				</tr>
				<tr>
					<th>董事</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" value='${bean.dir}'  id="dir" name="dir">
						</div>
					</td>
					<th>监事</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" value='${bean.spvs}' id="spvs" name="spvs">
						</div>
					</td>
				</tr>
				<tr>
					<th>注册地</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" value='${bean.regAdd}'  id="regAdd"  name="regAdd">
						</div>
					</td>
					<th>主营业务</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input"  value='${bean.mainCore}' id="mainCore" name="mainCore">
						</div>
					</td>
				</tr>
				<tr>
					<th>关键字</th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" value='${bean.keyWord}' id="keyWord" name="keyWord">
						</div>
					</td>
				</tr>
				<tr>
					<th>备注</th>
					<td colspan="3">
							<div class="form-group">
							<input type="text" class="form-control input" value='${bean.remarks}' id="remarks" name="remarks">
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
							<input type="text" class="validate[required] form-control input" value='${bean.depPos}' id="depPos" name="depPos">
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