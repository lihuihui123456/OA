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
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/views/aco/indexLibrary/js/index-library-from.js"></script>
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
	<div class="btn-group" role="group" style="padding: 5px 0px">
			<button id="btn_send" type="button" class="btn btn-default btn-sm"  onclick="doSaveIndexLibraryInfo();">
				<span class="fa fa-save" aria-hidden="true"></span>提交
			</button>
			<button id="btn_save" type="button" class="btn btn-default btn-sm" onclick="doSaveIndexLibraryInfo();">
				<span class="fa fa-retweet" aria-hidden="true"></span>暂存
			</button>
			<button id="btn_close" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-reply" aria-hidden="true"></span>返回
			</button>
	</div>
	<div class="paper-inner">
		<form id="myFm">
			<p class="tablestyle_title" style="font-size:25pt">项目指标库登记单</p>
			<input type="hidden" id="id" name="id">
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th style="width: 20%;">创建人</th>
					<td style="width: 30%;">
						<input class="validate[required] form-control select" readonly="readonly" id="userName" name="createUserName" type="text" style="width: 100%; height: 29; border: 0;" value="<shiro:principal property='name'/>" />
					</td>
					<th>创建时间</th>
					<td style="width: 30%;">
						<input id="createTime"  name="createTime" readonly="readonly" type="text" class="form-control"  />
					</td>
				</tr>
				<tr>
					<th>部门</th>
					<td colspan="3">
						<input id="draftDeptId_" class="form-control" name="draftDeptId_" type="hidden"
							style="width: 100%; height: 29; border: 0;"  /> 
						<input id="draftDeptIdName_" name="deptName" class="validate[required] form-control select" type="text"
							style="width: 100%; height: 29; border: 0;" onclick="deptTree(2,'draftDeptId_');"
							value="<shiro:principal property='deptName'/>" />
					</td>
				</tr>
				<tr>
					<th>项目名称<span class="star">*</span>
					</th>
					<td colspan="3">
						<select  id="proName" name="proName" class="form-control" size="1" >
							<option value="0">"双优"评选项目</option>
		    				<option value="1">"丹柯杯"项目</option>
		    				<option value="2">基本经费</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>功能分类</th>
					<td colspan="3">
						<select  id="funcType" name="funcType" class="form-control" size="1" >
							<option value="0">工资福利支出</option>
		    				<option value="1">商品和服务支出</option>
		    				<option value="2">对个人和家庭的补助</option>
		    				<option value="3">对企事业单位补助</option>
		    				<option value="4">转移性支出</option>
	    					<option value="5">债务利息支出</option>
		    				<option value="6">债务还本支出</option>
		    				<option value="7">其他资本性支出</option>
		    				<option value="8">其他支出</option>
						</select>
					</td>
				</tr>
				<tr>
					<th>预算总金额</th>
					<td colspan="3">
						<input id="budgetAmount" name="budgetAmount" type="text" class="form-control " />
					</td>
				</tr>
				<tr>
					<th>备注</th>
					<td colspan="3">
						<input type="text" id="remarks" name="remarks" class="form-control " />
					</td>
				</tr>
			</table>
		</form>
	</div>
</div>
<%@ include file="/views/aco/common/selectionDept_tree.jsp"%>
</body>
<!-- 业务表单公共js 必须引入  -->
<script src="${ctx}/views/aco/dispatch/js/biz_form_common.js"></script>
</html>