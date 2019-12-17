<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>档案销毁档案</title>
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
		<form id="destryFormView" name="destryFormView">
			<p class="tablestyle_title" style="font-size:25pt">档案销毁登记稿纸</p>
            <input type="hidden" id="id" name="id" value="${arcDestryEntity.id}">           
            <input type="hidden" id="arcId" name="arcId" value="${arcDestryEntity.arcId}">
            <input type="hidden" id="dr" name="dr" value="${arcDestryEntity.dr}" >
            <input type="hidden" id="arcType" name="arcType" value="${arcType}">
             
            
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>销毁单号<span class="star"></span></th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="nbr" name="nbr"
								value="${arcDestryEntity.nbr}" readonly="readonly">
						</div>
					</td>
					<th>单号日期<span class="star"></span></th>
					<td>
						<div class="input-group date" style="width: 100%">
							<input type="text" id="nbrTime" name="nbrTime"
								value="<fmt:formatDate value="${arcDestryEntity.nbrTime}"  pattern='yyyy-MM-dd HH:mm:ss'/>"
								style="width: 100%" class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />
						</div>
					</td>
				</tr>




				<tr>
					<th>文件标题<span class="star">*</span></th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input" onclick="viewArc();" title="请点击查看档案基本信息"; style="cursor:hand;text-decoration:underline"; id="arcName" name="arcName"  value="${arcDestryEntity.arcName}" unselectable="on">
						</div>
					</td>
				</tr>
				<tr>
					<th>有效期</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input" id="expiryDate" name="expiryDate" value="${arcDestryEntity.arcExpiryDate}">
						</div>
					</td>
				</tr>
				<tr>
					<th>操作员</th>
					<td>
						<div class="input-group " style="width: 100%">
							<input type="text" class="form-control input" id="oper"
								name="oper" value="${arcDestryEntity.oper}">
						</div>
					</td>
					<th>操作日期</th>
					<td>
						<div class="form-group date">
							<input type="text" id="operTime" name="operTime"
								value="<fmt:formatDate  value="${arcDestryEntity.operTime}" pattern='yyyy-MM-dd HH:mm:ss'/>"
								style="width: 100%" class="form-control select"
								onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})" />

						</div>
					</td>

				</tr>
				<tr>
					<th>备注</th>
					<td colspan="3">
						<div class="form-group">
							<textarea class=" form-control input" name="remarks" id="remarks"
								value="">${arcDestryEntity.remarks}</textarea>
						</div>
					</td>
				</tr>
			</table>
		</form>
	</div>
	

</body>
<script src="${ctx}/views/aco/arc/arcdestry/js/destryView_form.js"></script>
</html>