<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>签章模板列表</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<script type="text/javascript">
$(function() {
   addOption(initDict('signtype'));
   changeType();
});
	//模板应用
function tempUse(){
	if($('#tempName option:selected').val()==''||$('#tempName option:selected').val()==null){
	    alert('请选择签章模板!');
	}else{
	    opener.tempSign($('#tempName option:selected').val());
		window.close();
	}		
}
function tempClose(){
	window.close();
}
function changeType(){
      if($('#tempType option:selected').val()==''||$('#tempType option:selected').val()==null){
		    alert('请选择签章类型!');
		}else{
			$.ajax({
				url: '${ctx}/signatureTemplate/getTempList?date='+new Date(),
				async: false,
				dataType:'json',
				data:{temptype:$('#tempType option:selected').val()},
				success: function(data){
					if(data!=null){
					document.getElementById("tempName").innerHTML = "";
					   $(data.list).each(function(index) {
						  document.getElementById("tempName").options.add(
							new Option(this.name_, this.recordId_)
							);
						});	
					}		
			  }
		});	
		}	
}
function chooseType(){
	if($('#tempType option:selected').val()==''||$('#tempType option:selected').val()==null){
		    alert('请选择签章类型!');
		}	
}
function initDict(dicttype) {
	var temp;
	$.ajax({
		url : '${ctx}/dictController/findDictByTypeCode',
		type : "post",
		async : false,
		dataType : "json",
		data : {
			"showAll" : "showAll",
			"dictTypeCode" : dicttype
		},
		success : function(data) {
			temp = data;
		}
	});
	return temp;
}
function addOption(obj) {
	$(obj).each(function(index) {
		document.getElementById("tempType").options.add(
			new Option(this.dictVal, this.dictCode)
		);
	})
}
function tempSign(){
	if($('#tempName option:selected').val()==''||$('#tempName option:selected').val()==null){
	    alert('请选择签章模板!');
	    return;
	}else if($("#password").val()==null||$("#password").val()==''){
		 alert('请输入签章密码!');
		 return;
	}else{
	$.ajax({
		url : '${ctx}/signatureTemplate/findPawByRecordId?date='+new Date(),
		type : "post",
		async : false,
		dataType : "json",
		data : {
			"recordId" : $('#tempName option:selected').val()
		},
		success : function(data) {
			if(data!=$("#password").val()){
				$("#password").val('');
				alert('签章密码不正确!');
				return;
			}else{
				tempUse();
			}
		}
	});	
}
}
</script>
<style>
.btn-primary {
  color: #61a2cd;
  background: #e3f1fc;
  border: 1px solid #9bc2d5;
}
.btn-primary:hover,
.btn-primary.disabled,
.btn-primary[disabled] {
  background-color: #b5d1e1;
  border-color: #7ca3b9;
}
.btn-primary:focus,
.btn-primary:focus{
  color: #fff;
  background-color: #b5d1e1;
  border-color: #7ca3b9;
}
.btn-primary:active,
.btn-primary.active {
  background-color: #b5d1e1;
	border-color: #7ca3b9;
}
</style>
</head>
<body>
	<div style="padding:20px;">
	 <div class="form-group">
		<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="text-align:right;margin-top:5px;"><span class="star" style="color: red;">*</span>签章类型</label>
		<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
	<select id="tempType" name="tempType" class="form-control input-sm" style="width:100%" onchange="changeType();">
		</select>
		</div>
		<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="text-align:right;margin-top:5px;"><span class="star" style="color: red;">*</span>签章模板</label>
		<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
		<select id="tempName" name="tempName" class="form-control input-sm" style="width:100%" onchange="chooseType();">
		<c:choose>
		   		<c:when test="${not empty tempList}">
		   			<c:forEach items="${tempList}" var="temp" varStatus="vs">
						<option value="${temp.recordId_}">${temp.name_}</option>
					</c:forEach>
				</c:when>
			</c:choose>
		</select>
		</div>
		</div>
		</br>
		<div class="form-group">
		<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2" style="text-align:right;margin-top:5px;"><span class="star" style="color: red;">*</span>签章密码</label>
		<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
		<input type="password" id="password" name="password"
									class="form-control input-sm" placeholder="">
		</div>
		</div>
		<div style="text-align:center;margin-top:50px;">
		<button type="button" class="btn btn-primary btn-sm" onclick="tempSign()">确定</button>
		<button type="button" class="btn btn-primary btn-sm" onclick="tempClose()">取消</button>
	</div></div>
</body>
</html>