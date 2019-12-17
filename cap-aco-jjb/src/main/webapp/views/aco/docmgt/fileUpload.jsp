<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
  <head>
    <title>文件上传</title>
    <script type="text/javascript" src="${ctx}/static/cap/plugins/jquery/jquery-1.9.1.js"></script>
      <script src="${ctx}/views/aco/docmgt/js/plupload.full.min.js"></script>
      <script src="${ctx}/views/aco/docmgt/js/customized-upload.js"></script>
  <body style="padding: 0;margin: 0;">
    <div id="uploader">&nbsp;</div>
    <div id="parentDiv">&nbsp;</div>
<script type="text/javascript">
var url = '';
if(url == '' || url == null){
	url = window.parent.getParentUrl();
}
upload({multipart_params:{refId:bizId,refType:"notice"}},"uploader",true,"view","parentDiv",url);
/* var files = [];
var errors = [];
var type = 'file';
var chunk = eval('${param.chunk}');
var url = '';
if(url == '' || url == null){
	url = window.parent.getParentUrl();
}
var max_file_size = '100mb';
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
			/* var e= errors.length ? ",失败"+errors.length+"个("+errors.join("、")+")。" : "。";
			//alert("上传完成！共"+fs.length+"个。成功"+files.length+e);
			window.returnValue =fs[0].name;
			window.close(); */
			window.parent.closeUploadModal();
		}
	}
},(chunk ? {chunk_size:'1mb'} : {}))); */
</script>
  </body>
</html>