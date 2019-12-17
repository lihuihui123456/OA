<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<script type="text/javascript" src="${ctx}/views/aco/upload/js/plupload.full.min.js"></script> 
<script type="text/javascript" src="${ctx}/views/aco/upload/js/customized-upload.js"></script>
<title>文件上传页面</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
    <body>
		<div id="fileDiv">
		
		</div>
		<div id="fileDiv1">
		
		</div>
		<div id="fileDiv2">
		
		</div>
		<div id="fileDiv3">
		
		</div>
		<div id="fileDiv4">
		
		</div>
<!-- <div class="modal fade" id="upload_rename" tabindex="-1" role="dialog"aria-labelledby="upload_rename" aria-hidden="true">
	<div class="modal-dialog">
		<div class="modal-content">
			 <div class="modal-header">
				<button type="button" class="close" data-dismiss="modal"
					aria-hidden="true">×</button>
				<h4 class="modal-title" id="modal_look_title">重命名</h4>
			</div> 
			<div class="modal-body">
				<div class="input-group">
					<span class="input-group-addon" >文件名称</span>
		 			<input type="text" id="input_rename" name="input_rename" class="form-control" placeholder="请输入文件的新名称" >
				</div>
			</div>
			<div class="modal-footer" style="text-align: center;">
				<button type="button" class="btn btn-primary" id="onRename">保存</button>
				<button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
			</div>
		</div>
	</div>
</div> -->
</body>
</html>
 <script type="text/javascript">

 upload({multipart_params:{refId:"test1",refType:"sw"}},"fileDiv",true,"view");
 upload({multipart_params:{refId:"test2",refType:"fw"}},"fileDiv1",true,"edit");
 upload({multipart_params:{refId:"test3",refType:"tp"}},"fileDiv2",true,null);
 upload({multipart_params:{refId:"test4",refType:"other"}},"fileDiv3",true,null);
 upload({multipart_params:{refId:"test5",refType:"other1"}},"fileDiv4",true,null);
 </script> 

