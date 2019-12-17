<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<%@ include file="/views/aco/common/head.jsp"%>
<title>阅件接收</title>
	<link href="${ctx}/static/cap/plugins/bootstrap/css/table.css" rel="stylesheet">
	<script src="${ctx}/views/aco/notice/js/noticejs.js"></script>
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/css/bootstrap-table.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table.js"></script>
	<script src="${ctx}/static/cap/plugins/bootstrap/plugins/bootstraptable/js/bootstrap-table-zh-CN.js"></script>
	<!-- 引用 ueditor -->
    <script type="text/javascript" charset="utf-8" src="${ctx}/static/cap/plugins/UEditor1.4.4.3/ueditor.config.js"></script>
    <script type="text/javascript" charset="utf-8" src="${ctx}/static/cap/plugins/UEditor1.4.4.3/ueditor.all.js"> </script>
	<script type="text/javascript" charset="utf-8" src="${ctx}/static/cap/plugins/UEditor1.4.4.3/lang/zh-cn/zh-cn.js"></script>
	<script type="text/javascript" src="${ctx}/views/aco/upload/js/plupload.full.min.js"></script> 
	<script type="text/javascript" src="${ctx}/views/aco/upload/js/customized-upload.js"></script>
<style type="text/css">
#tb_departments td{
	text-align: center;
}
.sendbtn{
	height:25px;
	width:50px;
	background-color: #CA2320;
	color:#fff;
	font-family:Microsoft YaHei;
	border: #d4d4d4 1px solid;
	margin-top:10px;
}
.sendInput{
	margin-top:5px;
	width: 400px;
}
.form-control {
	border: 1px #fff solid;
}
.form-group {
 margin-bottom: 0px;
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
	background-image: url(${ctx}/static/aco/images/treeImg.png);
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
.btn-position{
	position: fixed;
  	width: 100%;
  	top: 0;
  	left: 10px;
  	z-index: 9999;
}
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>

<body>
<div class="container-fluid content" style="margin-left:5px;">
	<!-- start: Content -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default" style="border: 0;">
				<div class="panel-body" style="padding:0">
					<div class="panel-body btn-position" style="border: 0px;  padding: 10px 1px;background-color:#f2f4f8;">
						<div class="btn-group" role="group" aria-label="...">
							<button type="button" class="btn btn-default btn-sm" onclick="window.parent.closePage(window,true,true,true);">
								<i class="fa   fa-reply"></i>&nbsp;返回
							</button>
						</div>
					</div>
					<div class="paper-outer" style="margin-top:50px">
					 <div class="paper-inner">
					<p class="wjcystyle_title">通知公告</p>
					  <table class="wjcystyle"  width="100%" border="0" cellspacing="0">
					  <input type="hidden"  value="${type}" id="type"/>
					  <form id="ff" method="post" action="${ctx}/circularize/circularizeinsert"  name="ff">
					  		<input type="hidden" value="${noticeInfo.id}" id="id"  name="id"/>
					  		<input type="hidden"  value="${noticeInfo.senderid}"  id="senderid" name="senderid" >
					  		<input type="hidden"  value="${noticeInfo.sceneid}"  id="sceneid" name="sceneid">
					  		<input type="hidden"  value="${noticeInfo.tableid}"  id="tableid" name="tableid">
					  		<input type="hidden"  value="${noticeInfo.status}"  id="status" name="status">
					  		<input type="hidden"  value="${noticeInfo.bid}"  id="bid" name="bid">
					  		<input type="hidden"  value="${noticeInfo.sender}"  id="sender" name="sender">
					  		<input type="hidden"  value=""  id="flag" name="flag">
					  		<input type="hidden" id="choose_userid"/>
					  		<input type="hidden" id="choose_username"/>
								<tr>
									<th style="text-align: center;">标题
									</th>
									<td colspan="3">
										<div class="form-group">
											<input type="text" id="name" name="title" class="validate[required] form-control"
												placeholder="请输入名称" value="${noticeInfo.title}" disabled>
										</div></td>
								</tr>
					      <tr>
					        <th style="text-align: center;">发送人</th>
					        <td colspan="3"> 
					            <div class="form-group">
					             <input  type="text" class="form-control" id="sender" disabled name = "sender" value="${noticeInfo.sender}">
					            </div>
					        </td>
					      </tr>      
					       <tr>
					        <th height="140" style="text-align: center;">附件</th>
					        <td colspan="3" valign="top">
					           <div id="notice_attachment_div" class="panel-body">
					          		<%-- <iframe frameborder="0" name="mainFrame" id="mainFrame"
										src="${ctx}/media/accessory.do?tableId=${noticeInfo.tableid}"
										style="overflow: auto;"
										width="100%" height="99%" frameborder="no" border="0" marginwidth="0"
										marginheight="0"  allowtransparency="yes"  allowtransparency="yes"></iframe> --%>
					           </div> 
					        </td>
					      </tr>
					      <tr>
					      <th height="100" style="text-align: center;">描述</th>
					        <td colspan="4"  height="240" style="padding:10px;">
					              <!--  <textarea id="describeinfor" name="textfield"  class="form-control" id="message-text"  placeholder="请输入描述" ></textarea> -->
					              <input type="hidden" name="textfield" id="textfield">
					               <%-- <fck:editor  instanceName="content" basePath="/static/cap/plugins/FCKeditor" width="100%;" height="300px;" value="${noticeInfo.textfield}">
						  			</fck:editor> --%>
						  			<script id="editor" type="text/plain" style="width:100%;height:300px;">${noticeInfo.textfield}</script>
					        </td>
					      </tr>
					    </form>
					  </table>
					  
					  <br/><br/>
					  </div>
					  </div>
					  
					  <br/>
					  <div class="paper-inner" style="height: 350px;overflow: auto;" >
					  <span style="color:red">阅读情况（总人数${numbers[0]}人，已阅读${numbers[1]}人，未阅读${numbers[2]}人）</span>
					  <table id="tapList"></table>
					  </div>
				</div>
			</div>
		</div>
	<!--/col-->
	</div>
	<!--/row-->
	</div>
	
	<div class="modal fade" id="myModal" tabindex="-1" role="dialog"
		aria-labelledby="myModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal"
						aria-hidden="true">×</button>
					<h4 class="modal-title" id="myModalLabel">
					选择人员
					</h4>
				</div>
				<div class="modal-body" style="text-align: center;">
					<div>
						<iframe id="group" runat="server" src="" width="100%" height="350" frameborder="no" border="0" marginwidth="0"
						 marginheight="0" scrolling="auto" allowtransparency="yes"></iframe>
					</div>
				</div>
				<div class="modal-footer" style="text-align: center;">
					<button type="button" class="sendbtn" onclick="makesurePerson()" >确定</button>
					<button type="button" class="sendbtn" onclick="btnQk();" >清空</button>
					<button type="button" class="sendbtn" onclick="btnCancel()" >取消</button>
				</div>
			</div>
			<!-- /.modal-content -->
		</div>
		<!-- /.modal-dialog -->
	</div>
	
	<!-- end: Content -->
	<div class="clearfix"></div>
	
	<script type="text/javascript">
	//实例化编辑器
	//建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
	var type = $('#type').val();
	if (type == 'open') {
		var ue = UE.getEditor('editor', {
			readonly: true
		});
	}else{
		var ue = UE.getEditor('editor', {
			readonly: false
		});
	}
	
	upload({multipart_params:{refId:"${noticeInfo.tableid}",refType:"notice"}},"notice_attachment_div",true,"view");
	</script>
</body>
</html>
