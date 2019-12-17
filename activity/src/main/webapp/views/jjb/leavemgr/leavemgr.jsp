<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<head>
<title>请假登记</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8"/>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/table.css">
<script src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/demo.css" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/zTreeStyle/zTreeStyle.css" />
<link rel="stylesheet" type="text/css"  href="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/css/bootstrap-select.css">
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/dropdown/js/bootstrap-select.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<script src="${ctx}/views/jjb/leavemgr/js/biz_form_common.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
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
	padding:15px 5% 3% 5%;
}
.paper-inner{
	background-color: white;
	padding:10px 5% 3% 5%;
}
.tablestyle th{
	text-align:center;
	vertical-align:middle;
}
.btngroup{
	margin-left:-15px;
	position:fixed;
	width:100%;
	top:0px;
	left:30px;
	z-index:1000;
} 
.nav-tabs{
	width:100%;
	margin-left:-15px;
	margin-top:44px;
    position:fixed;
	width:100%;
	top:0px;
	left:30px;
	z-index:1000; 
} 	
</style>
</head>
<body class="paper-outer">
	<div class="paper-inner">
		<form id="myFm">
			<p class="tablestyle_title" style="font-size:25pt">基金办请假审批表</p>
			<input type="hidden" id="bizId_" name="bizId_">
			<input type="hidden" id="id" name="id">
			<input type="hidden" id="userId" name="userId">
			<input type="hidden" id="deptCode" name="deptCode">
			<input type="hidden" id="orgId" name="orgId">
			<input type="hidden" id="tenantId" name="tenantId">
			<input type="hidden" id="state" name="state">
			<table class="tablestyle" width="100%" border="0" cellspacing="0">
				<tr>
					<th>姓名</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="user_name"
								name="user_name" readonly="readonly" value="<shiro:principal property='name'/>">
						</div></td>
						<th>请假类型</th>
					<td>
						<div class="form-group">
					<select id="leave_type" name="leave_type" class="selectpicker select" title="请选择">
						<option value="病假">病假</option>
						<option value="休假">休假</option>
						<option value="事假">事假</option>
					</select>
						</div></td>				
				</tr>
				<tr>
				<th>所在部门</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="dept_name"
								name="dept_name" readonly="readonly" value="<shiro:principal property='deptName'/>">
						</div></td>
					<th>职务</th>
					<td>
						<div class="form-group">
							<input type="text" class=" form-control input" id="post_name"
							readonly="readonly"	name="post_name" value="">
						</div></td>	
						</tr>
				<tr>
				<th>参加工作时间</th>
					<td>
						<div class="form-group">
							<input type="text" id="work_time" name="work_time" 
						class="form-control select" value="" maxlength=10
							readonly="readonly" placeholder="">
						</div></td>
					<th>可休年假天数</th>
					<td >
						<div class="form-group">
					  <input type="text" class=" validate[custom[onlyNumberSp]] form-control input" id="leave_day"
							maxlength="32" name="leave_day" value="" placeholder="请输入"
							onblur="setSurplusDays()">
						</div></td>
					
				</tr>
				<tr>
					
					<th>本年度已休假天数</th>
					<td>
						<div class="form-group">
							<input type="text" class=" form-control input" id="already_day" 
							readonly="readonly"	name="already_day" value="" placeholder="请输入">
						</div></td>
				<th>本年度已请假天数</th>
					<td>
						<div class="form-group">
							<input type="text" class=" form-control input" id="leave_already"
								readonly="readonly" maxlength="32" name="leave_already" value="" placeholder="请输入">
						</div></td></tr>
				<tr>
				<tr>
					
					<th>年度剩余休假天数</th>
					<td>
						<div class="form-group">
							<input type="text" class=" form-control input" id="surplus_days" 
							readonly="readonly"	name="surplus_days" value="" placeholder="请输入">
						</div></td>
				<th>本年度请假总天数</th>
					<td>
						<div class="form-group">
							<input type="text" class=" form-control input" id="total_days"
								readonly="readonly" maxlength="32" name="total_days" value="" placeholder="请输入">
						</div></td></tr>
				<tr>
				<th>本次请假事由</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class=" form-control input" id="leave_reason"
								maxlength="256" name="leave_reason" value="" placeholder="请输入" onclick="calulateDay()">
						</div></td>
				</tr>
				<tr>
				<th>本次申请休假时间</th>
					<td>
						<div class="form-group">
					        <input type="text" id="rest_time" name="rest_time" 
						class="form-control select" value="">
						</div></td>
					<th>至</th>
					<td>
						<div class="form-group">
							<input type="text" id="rest_time_end" name="rest_time_end" 
						class="form-control select" value="">
						</div>
						</td>	
						</tr>
						<script>
							var starttime = {
							  elem: '#rest_time',
							  format: 'YYYY-MM-DD',
							  min: laydate.now(), //设定最小日期为当前日期
							  max: '2099-06-16', //最大日期
							  istime: true,
							  istoday: false,
							  choose: function(datas){
								  endtime.min = datas; //开始日选好后，重置结束日的最小日期
								  endtime.start = datas //将结束日的初始值设定为开始日
								  calRestHoliday();
							  }
							};
							var endtime = {
							  elem: '#rest_time_end',
							  format: 'YYYY-MM-DD',
							  min: laydate.now(),
							  max: '2099-06-16',
							  istime: true,
							  istoday: false,
							  choose: function(datas){
								  starttime.max = datas; //结束日选好后，重置开始日的最大日期
								  calRestHoliday();
							  }
							};
							laydate(starttime);
							laydate(endtime);
						</script>
				<tr>
				<th>本次休假天数</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class=" validate[custom[onlyNumberSp]] form-control input" id="xiujia_days"
								 maxlength="64" name="xiujia_days" value="" placeholder="请输入">
						</div>
					</td>
				</tr>
				<tr>
				<th>本次请假时间</th>
					<td>
						<div class="form-group">
							<input type="text" id="leave_time" name="leave_time" 
						class="form-control select" value="">
						</div></td>
					<th>至</th>
					<td>
						<div class="form-group">
							<input type="text" id="leave_time_end" name="leave_time_end" 
						class="form-control select" value="">
						</div></td>		
						</tr>
					<script>
							var starttime1 = {
							  elem: '#leave_time',
							  format: 'YYYY-MM-DD',
							  min: laydate.now(), //设定最小日期为当前日期
							  max: '2099-06-16', //最大日期
							  istime: true,
							  istoday: false,
							  choose: function(datas){
								  endtime1.min = datas; //开始日选好后，重置结束日的最小日期
								  endtime1.start = datas //将结束日的初始值设定为开始日
								  calSickHoliday();
							  }
							};
							var endtime1 = {
							  elem: '#leave_time_end',
							  format: 'YYYY-MM-DD',
							  min: laydate.now(),
							  max: '2099-06-16',
							  istime: true,
							  istoday: false,
							  choose: function(datas){
								  starttime1.max = datas; //结束日选好后，重置开始日的最大日期
								  calSickHoliday();
							  }
							};
							laydate(starttime1);
							laydate(endtime1);
						</script>
					<tr>
					<th>本次请假天数</th>
					<td colspan="3">
						<div class="form-group">
							<input type="text" class=" validate[custom[onlyNumberSp]] form-control input" id="qingjia_days"
								 maxlength="64" name="qingjia_days" value="" placeholder="请输入">
						</div>
					</td>
				</tr>
				<tr>
				<th>是否出京</th>
					<td>
					<div class="form-group">
					<select id="leave_capital" name="leave_capital" class="selectpicker select" >
						<option value="否">否</option>
						<option value="是">是</option>
					</select>
					</div></td>
				<th>出京目的地</th>
					<td>
					<div class="form-group">
							<input type="text" class="form-control input" id="capital"
							maxlength="32"	name="capital" value="" placeholder="请输入">
					</div></td>
				</tr>
				<tr><th>是否出境</th>
					<td>
						<div class="form-group">
					<select id="leave_country" name="leave_country" class="selectpicker select" >
						<option value="否">否</option>
						<option value="是">是</option>
					</select>
						</div></td>
						<th>出境目的地</th>
					<td>
						<div class="form-group">
							<input type="text" class="form-control input" id="country"
								maxlength="32" name="country" value="" placeholder="请输入">
						</div></td></tr>
					<tr>
				<th>所在部门意见</th>
					<td colspan="3">
						<div class="form-group">
								<textarea class="form-control input" id="comment_bm"
								name="comment_bm" value="" rows="5" onpropertychange="if(value.length>200) value=value.substr(0,200)"></textarea>
						</div></td></tr>
						<tr>
				<th>领导意见</th>
					<td colspan="3">
						<div class="form-group">
								<textarea class="form-control input" id="comment_ld"
								name="comment_ld" value="" rows="5" onpropertychange="if(value.length>200) value=value.substr(0,200)"></textarea>
						</div></td></tr>	
				<tr>
					<th>备注</th>
					<td colspan="3">
						<div class="form-group">
							<textarea class="form-control input" id="remark"
								name="remark" value="" rows="5" onpropertychange="if(value.length>200) value=value.substr(0,200)"></textarea>
						</div></td>
				</tr>
				<tr>
					<th>附件</th>
					<td colspan="3">
						<div class="form-group">
							<iframe id="fj" name="fj" frameborder="no" border="0" src="" style="width: 100%;height: 180px"></iframe>
						</div></td>
				</tr>
			</table>
		</form>
	</div>
	<div id="phrasebook_div" style="width: 300px;height: 150px">
		<iframe id="phrasebook_iframe" src="" width="100%" height="100%"
			frameborder="no" border="0" marginwidth="0" marginheight="0"
			scrolling="yes"></iframe>
	</div>
</body>
<script type="text/javascript">
	var map = ${keyValueMap};
	var style = "${style}";
	var tableName = "${tableName}";
	var commentColumn = "${commentColumn}";
	/**附件功能开始**/
	function changeIseb(){
		return;
	}
	$(function() {
		var bizId = "${bizId}";
		var view = "${view}";
		
		if('1'==view){
			$("#fj").attr("src", "leaveManager/accessory.do?tableId="+bizId);
		}else{
			$("#fj").attr("src", "media/accessory.do?tableId="+bizId);
		}
		//赋值
		window.parent.setContent();
	});
	function top1() {
		window.parent.toTop();
	}
	function scroll1(){
		$("#back-to-top").fadeIn(1000);
	}

	function scroll2(){
		  $("#back-to-top").fadeOut(1000);
	}
	function setSurplusDays(){
		if($("#leave_day").val()!=''){
			var day=$("#leave_day").val()-$("#already_day").val();
			$("#surplus_days").val(day);
		}else{
			$("#surplus_days").val('');
		}
	}
	//根据起始时间自动计算休假或请假天数，并且扣除周六周日
	function calulateDay(){
		var start='2017-02-01';
		var end='2017-02-08';
		var days=dataScope(start,end);
		
	}
	function calRestHoliday(){
		var start=$("#rest_time").val();
		var end=$("#rest_time_end").val();
		if(start!=null&&start!=""&&end!=null&&end!=""){
			var days=dataScope(start,end);
			$("#xiujia_days").val(days);
		}
	}
	function calSickHoliday(){
		var start=$("#leave_time").val();
		var end=$("#leave_time_end").val();
		if(start!=null&&start!=""&&end!=null&&end!=""){
			var days=dataScope(start,end);
			$("#qingjia_days").val(days);
		}
	}
	/*************************
	 * 计算两个日期时间段内天数
	 *  
	 * @param value1  起始日期 YYYY-MM-DD 
	 * @param value2  终止日期 YYYY-MM-DD 
	 * return num
	 */  
	function dataScope(value1, value2) {  
		//字符串转化为Date
	    var getDate = function(str) {  
	        var tempDate = new Date();  
	        var list = str.split("-");  
	        tempDate.setFullYear(list[0]);  
	        tempDate.setMonth(list[1] - 1);  
	        tempDate.setDate(list[2]);  
	        return tempDate;  
	    }  
	    var date1 = getDate(value1);  //起始日期
	    var date2 = getDate(value2);  //终止日期
	    if (date1 > date2) {  
	        alert('起始日期不能大于终止日期');
	        return false;
	    }  
	    date1.setDate(date1.getDate());  
	    var i = 0;  
	    while (!(date1.getFullYear() == date2.getFullYear()  
	            && date1.getMonth() == date2.getMonth() && date1.getDate() == (date2  
	            .getDate()))) {  
            if(date1.getDay()!=6&&date1.getDay()!=0){//排除周六与周日
            	 i++;  
            }
	        date1.setDate(date1.getDate() + 1); //循环+1 
	    } 
	    if(date2.getDay()!=6&&date2.getDay()!=0){
	    	i++;
	    }
	    return i;  
	}
</script>
<style type="text/css">
	div#phrasebook_div {
		position: absolute;
		display: none;
		top: 0;
		background-color: #555;
		text-align: left;
		padding: 2px;
	}
</style>
</html>