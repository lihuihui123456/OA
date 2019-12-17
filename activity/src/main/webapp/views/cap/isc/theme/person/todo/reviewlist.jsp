<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">

<script type="text/javascript">
var chooseUserUrl = "";
$(function(){
	         var ids='${ids}';   
	         var userName="";
	         var userId="";
	         var array=new Array("序号","任务标题","办理环节","办理人员","意见");
	         $.ajax({
	 			type: "post",  
	 	        url: "${ctx}/leaddtpflow/listReview",
	 	        dataType: 'json',
	 	        data: {
	 	        	ids:ids
	 	        },
	 	        success: function(data) {
	 	        	/*  var table=$("<table class='table table-bordered table-condensed' id='tb_review'>"); 
	 		         table.appendTo($("#createtable")); */
	 		         for(var i=0;i<data.length+1;i++) { 
	 		            var tr=$("<tr></tr>"); 
	 		            tr.appendTo($("#tb_review")); 
	 	                if(i==0){
	 		               var td=$("<td align='center'; width='7%';>"+array[0]+"</td>"); 
	 		 	               td.appendTo(tr);
	 		 	           var td=$("<td align='center'; width='25%';>"+array[1]+"</td>"); 
	 		 	               td.appendTo(tr);
	 		 	           var td=$("<td align='center'; width='20%';>"+array[2]+"</td>"); 
	 		 	               td.appendTo(tr);
	 		 	           var td=$("<td align='center'; width='18%';>"+array[3]+"</td>"); 
	 		 	               td.appendTo(tr);
		 		 	       var td=$("<td align='center'; width='30%';>"+array[4]+"</td>"); 
	 		 	               td.appendTo(tr);
	 		            }else{
	 		            	if(data[i-1].userName!=null){
	 		            		userName=data[i-1].userName;
	 		            	}else{
	 		            		userName="";
	 		            	}
	 		            	if(data[i-1].userId!=null){
	 		            		userId=data[i-1].userId;
	 		            	}else{
	 		            		userId="";
	 		            	}
	 		               var td=$("<td align='center';>"+i+"<input id='id"+i+"' name='id' type='hidden' value="+data[i-1].id+"><input id='taskId"+i+"' name='taskId' type='hidden' value="+data[i-1].taskId+"><input id='solId"+i+"' name='solId' type='hidden' value="+data[i-1].solId+"><input id='commentColumn"+i+"' name='commentColumn' type='hidden' value="+data[i-1].commentColumn+"></td>"); 
	 		 	               td.appendTo(tr);
	 		 	           var td=$("<td align='center';><input id='title"+i+"' name='title' readonly='readonly' style='text-align:center;width:100%;border:none;' value="+data[i-1].title+" onfocus='this.blur();'><input id='procdefId"+i+"' name='procdefId' type='hidden' value="+data[i-1].procdefId+"><input id='isFreeSelect"+i+"' name='isFreeSelect' type='hidden' value="+data[i-1].isFreeSelect+"></td>"); 
	 		 	               td.appendTo(tr);	
	 		 	           var td=$("<td align='center';><select id='actId"+i+"' name='actId' style='width:100%;border:none;' value='' onchange='changeAct(\""+i+"\")' title='请选择'></select></td>"); 
	 		 	               td.appendTo(tr);
	 		 	           initAct(data[i-1].tasklist,i);
	 		 	           if(data[i-1].actType== "endEvent"){
	 		 	        	 var td=$("<td><input id='sendUserName"+i+"' name='sendUserName' style='text-align:center;width:90%;border:none;' onfocus='this.blur();' value="+userName+"><img id='img"+i+"' src='${ctx}/static/cap/images/user.png' style='float:right; text-align:left;width:10%;margin-top:5px;display: none;' onclick='chooseUser(\""+i+"\")';/><input id='sendUserId"+i+"' name='sendUserId' type='hidden' value="+userId+"></td>"); 
		 	                   td.appendTo(tr);	  
	 		 	           }else{
	 		 	        	 var td=$("<td><input id='sendUserName"+i+"' name='sendUserName' style='text-align:center;width:90%;border:none;' onfocus='this.blur();' value="+userName+"><img id='img"+i+"' src='${ctx}/static/cap/images/user.png' style='float:right; text-align:left;width:10%;margin-top:5px;display: none;' onclick='chooseUser(\""+i+"\")';/><input id='sendUserId"+i+"' name='sendUserId' type='hidden' value="+userId+"></td>"); 
	 		 	               td.appendTo(tr);
	 		 	               $("#sendUserName"+i).addClass('validate[required]');
	 		 	               $("#img"+i).show();
	 		 	           }
	 		 	           var td=$("<td><input id='comment"+i+"' name='comment' style='width:100%;border:none;' value=''></td>"); 
	 		 	               td.appendTo(tr);
	 		            }
	 		         } 
	 		        // $("#createtable").append("</table>"); 
	 	        }
	 		});
	        $('#btn_agree').click(function() {
	        	var comment='同意';
	        	var rows = document.getElementById("tb_review").rows.length;
	        	for (var i = 1; i < rows; i++) {
	        		$("#comment"+i).val(comment);
	        	}
	        });
	        $('#btn_disagree').click(function() {
	        	var comment='不同意';
	        	var rows = document.getElementById("tb_review").rows.length;
	        	for (var i = 1; i < rows; i++) {
	        		$("#comment"+i).val(comment);
	        	} 
	        }); 

});
//保存关联信息
function doSaveData(){
	    var JsonData =  {id:"",title:"",taskId:"",solId:"",procdefId:"",actId:"",sendUserName:"",sendUserId:"",comment:"",commentColumn:"",isFreeSelect:""};
		var data=[];
	    var rows = document.getElementById("tb_review").rows.length; //获得行数(包括thead)
		for (var i = 1; i < rows; i++) {
			var JsonData = new Object();
			JsonData.id = $("#id"+i).val();
			JsonData.title = $("#title"+i).val();
			JsonData.taskId = $("#taskId"+i).val();
			JsonData.solId = $("#solId"+i).val();
			JsonData.procdefId = $("#procdefId"+i).val();
			JsonData.actId = $("#actId"+i).val();
			JsonData.sendUserName = $("#sendUserName"+i).val();
			JsonData.sendUserId = $("#sendUserId"+i).val();
			JsonData.comment = $("#comment"+i).val();
			JsonData.commentColumn = $("#commentColumn"+i).val();
			JsonData.isFreeSelect = $("#isFreeSelect"+i).val();
			data.push(JsonData);
		}
		return JSON.stringify(data);
}
function chooseUser(e){
	$.ajax({
		url : "${ctx}/bizSolMgr/findTaskNodeCfg",
		type : "post",
		dataType : "json",
		async : false,
		data : {
			"solId" : $("#solId"+e).val(),
			"procdefId" : $("#procdefId"+e).val(),
			"actId" : $("#actId"+e).val(),
			"bizId": $("#id"+e).val()
		},
		success : function(data) {
			if(data){
				isExeUser = data.exeUser_;
				isHqNode = data.isHqNode_;
			}else{
				isExeUser = "0";
				isHqNode = "0";
			}
			changeUser(isExeUser, isHqNode, $("#actId"+e).val(),e);
		}
	}); 
}
	/** 控制选择人员是否显示*/
	function changeUser(isExeUser, isHqNode, actId,id){
		if(isExeUser == "1"){
			if(isHqNode == "1"){
				chooseUserUrl = "bizSolMgr/zTreeBackVar?state=1&&solId="+$("#solId"+id).val()+"&&procdefId="+$("#procdefId"+id).val()+"&&actId="+actId;
			}else{
				chooseUserUrl = "bizSolMgr/zTreeBackVar?state=0&&solId="+$("#solId"+id).val()+"&&procdefId="+$("#procdefId"+id).val()+"&&actId="+actId;
			}
		}else{
			chooseUserUrl = "";
		}
		window.parent.choseUser(chooseUserUrl,id);
	}
    function changeAct(e){
    	$("#sendUserId"+e).val('');
		$("#sendUserName"+e).val('');
		$.ajax({
			url : '${ctx}/leaddtpflow/findActTypeByActId?date='+new Date(),
			type : 'post',
			dataType : 'text',
			async : false,
			data :{actId:$("#actId"+e).val()},
			success : function(data) {
				if(data=="endEvent"){
					$("#sendUserName"+e).removeClass('validate[required]');
	 	            $("#img"+e).hide();
				}else{
					$("#sendUserName"+e).addClass('validate[required]');
	 	            $("#img"+e).show();
	 	            getNodeCfg(e);
				}
			}
		});
	}
	/**启动流程*/
	function startProcess(obj) {
		var flag = "0";
		$.ajax({
			url : '${ctx}/leaddtpflow/startProcess?date='+new Date(),
			type : 'post',
			dataType : 'json',
			async : false,
			data :{obj:obj},
			success : function(data) {
				flag = data;
			}
		});
		return flag;
	}
	function validateForm(){
		return $('#myFm').validationEngine('validate');
	}
	function initAct(tasklist,e){
		 $(tasklist).each(function(index) {
			  document.getElementById("actId"+e).options.add(
				new Option(this.actName, this.actId)
				);
			});	
	}
	/**获取目标任务节点配置*/
	function getNodeCfg(e){
		var isExeUser = "0";  //目标节点是否允许选执行人
		var isHqNode = "0";   //目标节点是否会签节点
			$.ajax({
				url : "${ctx}/bizSolMgr/findTaskNodeCfg",
				type : "post",
				dataType : "json",
				async : false,
				data : {
					"solId" : $("#solId"+e).val(),
					"procdefId" : $("#procdefId"+e).val(),
					"actId" : $("#actId"+e).val(),
					"bizId": $("#id"+e).val(),
				},
				success : function(data) {
					if(data){
						isExeUser = data.exeUser_;
						isHqNode = data.isHqNode_;
						if(data.userId!=""&&data.userId!=null){
							$("#sendUserId"+e).val(data.userId);
							$("#sendUserName"+e).val(data.userName);
						}
					}
				}
			});
		}
</script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
<style>
body{
	background-color:#fff;
}
.form-control {
	border: 1px #fff solid;
	-webkit-box-shadow: none;
    box-shadow: none;
}
.form-group{
	margin-bottom:0;
}
<%@ include file="/views/cap/common/theme.jsp"%>
</style>
</head>
<body>
<form id="myFm">
   <div id="createtable" class="panel-body" style="padding-top:0px;padding-bottom:5px;border:0;">	
        <div id="toolbar" class="btn-group" style="padding-bottom:5px;">
			<button id="btn_agree" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-check" aria-hidden="true"></span>同意
			</button>
			<button id="btn_disagree" type="button" class="btn btn-default btn-sm">
				<span class="fa fa-remove" aria-hidden="true"></span>不同意
			</button>
		</div>
		<table class="table table-bordered table-condensed" id="tb_review"></table>
   </div>	
</form>
</body>
</html>