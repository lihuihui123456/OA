<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>基金办合同处理单</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/views/aco/dispatch/css/dispath_common.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script src="${ctx}/views/jjb/contractMgr/js/biz_form_common.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<script type="text/javascript">
	var map = ${keyValueMap};
	var style = "${style}";
	var tableName = "${tableName}";
	var commentColumn = "${commentColumn}";
	var taskId="${taskId}";
	//laydate.skin('dahong');
	function saveForm(){
		
	}
	$(function() {
		if(style == "view") {
			var buttons=$(window.frames["fj"].document).find("button");
		    for(var i=0;i<buttons.length;i++){
		    	if(buttons[i].getAttribute("id")!="open" && buttons[i].getAttribute("id")!="resave"){
			    	buttons[i].setAttribute("disabled","disabled");
		    	}
		    }
		}
		var date = new Date();
		$('#year').val(date.getFullYear());
	});
function select(){
		
	}
</script>
<style type="text/css">
	.select{
		width:100%;
		border:none;
	}
	.paper-outer{
		padding:120px 5% 3% 5%;
	}
</style>
</head>
<body class="paper-outer">
	<div class="paper-inner">
		<form id="myFm">
			<br>
			<p class="tablestyle_title" style="font-size:25pt">基金办合同处理单</p>
			<br>
			<input type="hidden" id="bizId_" name="bizId_">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="dr" name="dr">
			<input type="hidden" id="data_user_id" name="data_user_id">
			<input type="hidden" id="data_dept_id" name="data_dept_id">
			<input type="hidden" id="data_org_id" name="data_org_id">
			<input type="hidden" id="createTime_" name="createTime_">
			<table class="tablesmall " width="100%" border="0" cellspacing="0"
				style="margin-top:2px;">
				</table>
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>合同名称<span class="star">*</span></th>
						<td colspan="5">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input" id="title_"
								name="title_" value="" maxlength="50">
						</div>
					</td>
				<tr>
					<th>项目名称<span class="star">*</span></th>
						<td colspan="5">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input" id="projectName_"
								name="projectName_" value="" maxlength="50">
						</div>
					</td>
				</tr>
				<tr>
					<th>合同文号</th>
						<td colspan="2">
						<div class="form-group">
							<input type="text" class="form-control input" id="contractNum_"
								name="contractNum_" value="" maxlength="50">
						</div>
					</td>
					<th>合同/协议类型<span class="star">*</span></th>
						<td colspan="2">
						<div class="form-group">
							<select id="contractType_" name="contractType_" class="selectpicker select" 
										>
								<option value="人事">人事</option>
								<option value="政采">政采</option>
								<option value="宣传">宣传</option>
								<option value="基础建设（房租、车租、物业）">基础建设（房租、车租、物业）</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>合同签订时间</th>
						<td colspan="5">
						<div class="form-group">
							<input type="text" class="form-control input select" id="contractTime_"
								name="contractTime_" value="" onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})">
						</div>
					</td>
				</tr>
				<tr>
					<th>甲方/发包方/委托方<span class="star">*</span></th>
						<td colspan="5">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input" id="client_"
								name="client_" value="" maxlength="50">
						</div>
					</td>
				</tr>
				<tr>
					<th>乙方/承包方/承担方<span class="star">*</span></th>
						<td colspan="5">
						<div class="form-group">
							<input type="text" class="validate[required] form-control input" id="bearer_"
								name="bearer_" value="" maxlength="50">
						</div>
					</td>
				</tr>
				<tr>
					<th>丙方</th>
						<td colspan="5">
						<div class="form-group">
							<input type="text" class=" form-control input" id="third_"
								name="third_" value="" maxlength="50">
						</div>
					</td>
				</tr>
				<tr>
					<th>录入时间</th>
						<td colspan="2">
						<div class="form-group">
							<input type="text" class=" form-control input select" id="entryTime_"
								name="entryTime_" value="" onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})">
						</div>
					</td>
					<th>存续时间</th>
						<td colspan="2">
						<div class="form-group">
							<input type="text" class=" form-control input select" id="survivalTime_"
								name="survivalTime_" value="" onclick="laydate({istime: true, format: 'YYYY-MM-DD hh:mm:ss'})">
						</div>
					</td>
				</tr>
				<tr>
					<th>金额</th>
						<td colspan="5">
						<div class="form-group">
							<input type="text" class=" form-control input" id="money_"
								name="money_" value="" maxlength="50">
						</div>
					</td>
				</tr>
				<tr>
					<th>支付方式（账号等）<span class="star">*</span></th>
						<td colspan="5">
						<div class="form-group">
							<select id="payType_" name="payType_" class="selectpicker select" 
										>
								<option value="支票">支票</option>
								<option value="汇款">汇款</option>
								<option value="分段">分段</option>
								<option value="一次性">一次性</option>
							</select>
						</div>
					</td>
				</tr>
				<tr>
					<th>办内经办人</th>
						<td colspan="5">
						<div class="form-group">
							<input type="text" class="form-control input" id="agent_"
								name="agent_" value="" maxlength="50">
						</div>
					</td>
				</tr>
				<tr>
					<th height="80">公司联系人（联系方式）</th>
					<td colspan="5">
						<div class="form-group">
							<textarea class="form-control input" id="contact_"
								name="contact_" rows="4" value="" onpropertychange="if(value.length>50) value=value.substr(0,50)"></textarea>
						</div>
					</td>
				</tr>
				<tr>
					<th height="80">备注</th>
					<td colspan="5">
						<div class="form-group">
							<textarea class="form-control input" id="remark_"
								name="remark_" rows="4" value="" onpropertychange="if(value.length>200) value=value.substr(0,200)"></textarea>
						</div>
					</td>
				</tr>
				<tr>
					<th>附件</th>
					<td colspan="5">
					<iframe id="fj" frameborder="no" border="0" src="" style="width: 100%;height: 200px"></iframe>
						<%-- <jsp:include page="/media/bpmaccessory?tableId=${bizid}"></jsp:include> --%>
					</td>
				</tr>			
			</table>
			<table class="tablesmall " width="100%" border="0" cellspacing="0"
				style="margin-top:2px;"><tr><td colspan="2" width="85%"></td><td><span class="star number">基金办综合处制</span></span></td></tr></table>
			<div class="txm">
			<c:if test="${serialNumber!=''&&serialNumber!=null}">
				<%-- <img alt="图片未加载" src="${ctx}/bpmRuFormInfoController/getOneBarcode?barcodeNum=${serialNumber}" /> --%>
			</c:if>
			</div>
		</form>
	</div>
</body>
<script type="text/javascript">
/**附件功能开始**/
function changeIseb(){
	return;
}
var bizId = "${bizId}";
if(bizId == "" || bizId == ''){
	bizId = window.parent.generateUUID();
}
$("#fj").attr("src", "media/bpmaccessory?tableId="+bizId);
/**附件功能结束**/
</script>
</html>