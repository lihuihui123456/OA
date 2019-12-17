<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">	
<head>
	    <title>办公系统</title>		
		<%@ include file="/views/aco/common/head.jsp"%>
		<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
		<script src="${ctx}/views/cap/isc/theme/leader/js/lead_home.js"></script>
		<link id="cssfile" href="${ctx}/views/cap/isc/theme/leader/css/lead.css" rel="stylesheet">
		<%@ include file="/views/cap/common/theme.jsp"%>
		<style type="text/css">
            .modal-lg {
	              width: 850px;
             }
</style>
	</head>
	<body style="background-color: white">
	<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12 ">
		<div class="panel panel-other mar_b_10">
			<div class="panel-body" style="padding:0;">
				<iframe id="todo_iframe" width="100%"  frameborder=0 scrolling=no >
				</iframe>
			</div>
		</div>
	</div>
	<%--<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
		<div class="panel panel-other mar_b_10">
		    <iframe id="notice_iframe" width="100%"  frameborder=0 scrolling=no>
			</iframe>					        
		</div>
	</div>  
	<div class="col-lg-6 col-md-6 col-sm-6 col-xs-12">
		<div class="panel panel-other mar_b_10" >
			<iframe id="trace_iframe" width="100%" height="100%"  frameborder=0 scrolling=no style="padding-right:1px">
			</iframe>				        
		</div>
	</div>
--%>
	<!-- 一键审阅弹出 -->
	<div class="modal fade" id="foronceModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog modal-lg" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
					<h4 class="modal-title" id="myModalLabel">一键审阅</h4>
				</div>
				<div class="modal-body" >
					<iframe id="reviewforonce" runat="server" width="100%" height="200px" frameborder="no" border="0" marginwidth="0"
						 src="" marginheight="0" scrolling="yes" allowtransparency="yes"></iframe> 
				</div>
				<div class="modal-footer" style="text-align:center">
					<button type="button" class="btn btn-primary" onclick="onSubmit()">提交</button>
  					<button type="button" class="btn btn-primary" data-dismiss="modal">取消</button>
				</div>
			</div>
		</div>
	</div>
<!-- 选人界面弹出模态框 -->
<div class="modal fade" id="chooseUserDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="false" data-backdrop="true" data-keyboard="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">人员选择</h4>
      </div>
      <div class="modal-body" style="text-align: center;">
      	<iframe id="chooseUser_iframe" src=""  width="100%" height="250px" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="yes" style=""></iframe>
      </div>
      <div class="modal-footer" style="text-align: center;margin-top:0;">
        <button type="button" class="btn btn-primary" onclick="makesure()">确认</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
</body>
</html>
<script>
	/**
	 * 初始化加载监听窗口改变事件
	 */
	$(window).resize(function() {
		onWinResize();
	});
	/**
	 * 初始化加载领导桌面左侧部分高度
	 */
	$(document).ready(function() {
		onWinResize();
		//待办部分高度
		$("#todo_iframe").attr("src","${ctx}/views/cap/isc/theme/leader/todolist-lead.jsp");
	});
	//计算页面高度
	function onWinResize(){
		var topIframeH=todoliCounts()*42+39;
		$("#todo_iframe").height(topIframeH);
	}
	//计算待办部分的行数
	function todoliCounts(){
		var leadH = $(".center_part",window.parent.document).height()- 46 ;
		var toCounts = Math.floor((leadH - 39 - 10 ) / 42);
		return toCounts ;
	}
	function openForOnce(url){
		$('#foronceModal').modal('show');
		$('#reviewforonce').attr("src",url);
	}
	var ids='';
	//弹出选择办理人窗口
	function choseUser(chooseUserUrl,id) {
		$("#chooseUser_iframe").attr("src", chooseUserUrl);
		ids=id;
		$('#chooseUserDiv').modal('show');
	}
	//选人确定按钮
	function makesure() {
		var arr = $("#chooseUser_iframe")[0].contentWindow.doSaveSelectUser();
		var userName = arr[1];
		var userId = arr[0];
		document.getElementById("reviewforonce").contentWindow.document
				.getElementById("sendUserName"+ids).value = userName;
		document.getElementById("reviewforonce").contentWindow.document
				.getElementById("sendUserId"+ids).value = userId; 
		$('#chooseUserDiv').modal('hide');
	}
	function onSubmit(){
		 var flag = $("#reviewforonce")[0].contentWindow.validateForm();
		      if(flag){
		    	  var obj=document.getElementById("reviewforonce").contentWindow.doSaveData();
		          flag=document.getElementById("reviewforonce").contentWindow.startProcess(obj);
		          if(flag == "1"){
		        	 $('#foronceModal').modal('hide'); 
		        	 document.getElementById("todo_iframe").contentWindow.refresh();
		         }else{
		     		    layerAlert("送交失败！");
		     	}    
		      }
	        
	}
</script>