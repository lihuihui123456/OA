<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
  <head>
    <title>文件上传</title>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jquery-1.9.1.js"></script>
	<link rel="stylesheet" href="${ctx}/static/cap/plugins/plupload/queue/css/jquery.plupload.queue.css" type="text/css"></link>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/plupload/plupload.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/plupload/plupload.html4.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/plupload/plupload.html5.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/plupload/plupload.flash.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/plupload/zh_CN.js"></script>
    <script type="text/javascript" src="${ctx}/static/cap/plugins/plupload/queue/jquery.plupload.queue.js"></script>
  <body style="padding: 0;margin: 0;">
    <div id="uploader">&nbsp;</div>
<script type="text/javascript">
var files = [];
var errors = [];
var type = 'file';
var chunk = eval('${param.chunk}');
var url = '${param.url}';
if(url == '' || url == null){
	url = '${ctx}/media/upload';
}
var max_file_size = '${attEachLimit}'+'mb';
var filters = {title : "文档", extensions : "zip,doc,docx,xls,xlsx,ppt,pptx,txt,pdf,sql,mp3,mp4,rmvb,avi,flash,flv,wma,rm,mid,jpg,png,bmp"};
$("#uploader").pluploadQueue($.extend({
	runtimes : 'flash,html4,html5',
	url : url,
	max_file_size : max_file_size,
	file_data_name:'file',
	unique_names:true,
	filters : [filters],
	flash_swf_url : '${ctx}/static/cap/plugins/plupload/plupload.flash.swf',
	init:{
		FileUploaded:function(uploader,file,response){
			if(response.response){
				var rs = $.parseJSON(response.response);
				if(rs.status){
					files.push(file.name);
				}else{
					errors.push(file.name);
				}
			}
		},
		UploadComplete:function(uploader,fs){
			var e= errors.length ? ",失败"+errors.length+"个("+errors.join("、")+")。" : "。";
			alert("上传完成！共"+fs.length+"个。成功"+files.length+e);
			//target.window("close");
			window.returnValue = '1';
			window.close();
		}
	}
},(chunk ? {chunk_size:'1mb'} : {})));
</script>
  </body>
</html>