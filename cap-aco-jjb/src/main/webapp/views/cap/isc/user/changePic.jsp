<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>修改头像</title>
    <meta http-equiv="X-UA-Compatible" content="IE=8" />
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/cap/easyui.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
	<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
    <link href="${ctx}/views/cap/isc/user/css/basic.css" rel="stylesheet" type="text/css" />
	<link href="${ctx}/views/cap/isc/user/css/jquery.Jcrop.css" rel="stylesheet" type="text/css" />
	<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/jQuery.js"> </script>
	<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/jquery.easyui.min.js"></script>
	
	<script type="text/javascript">
	
		/* $("#fcupload").change(function() {
			var objUrl = getObjectURL(this.files[0]);
			console.log("objUrl = " + objUrl);
			if (objUrl) {
				$("#cutimg").attr("src", objUrl);
			}
		}); */
		
		/* function readURL(input){
			var objUrl = getObjectURL(input.files[0]);
			console.log("objUrl = " + objUrl);
			if (objUrl) {
				$("#cutimg").attr("src", objUrl);
			}
		}
		
		function updateCoords(obj) {
			$("#x").val(obj.x);
			$("#y").val(obj.y);
			$("#w").val(obj.w);
			$("#h").val(obj.h);
		}
	
		//建立一個可存取到該file的url
		function getObjectURL(file) {
			var url = null;
			if (window.createObjectURL != undefined) { // basic
				url = window.createObjectURL(file);
			} else if (window.URL != undefined) { // mozilla(firefox)
				url = window.URL.createObjectURL(file);
			} else if (window.webkitURL != undefined) { // webkit or chrome
				url = window.webkitURL.createObjectURL(file);
			}
			return url;
		} */
	
		//定义一个全局api，这样操作起来比较灵活
		var api = null;
		var fileType = null;
		function readURL(input) {
			var fileName = $("#fcupload").val();
			if(fileName == ''){
				$.messager.alert('提示', '请选择文件！', 'info');
				return;
			}
			
			var f = fileName.split('.')[1];
			fileType = f;
			if(f != 'jpg' && f != 'png' && f != 'gif'){
				$.messager.alert('提示', '请选择jpg、png、gif格式！', 'info');
				return;
			}
			if (input.files && input.files[0]) {
				var reader = new FileReader();
				reader.readAsDataURL(input.files[0]);
				reader.onload = function(e) {
					$('#cutimg').removeAttr('src');
					$('#cutimg').attr('src', e.target.result);
					api = $.Jcrop('#cutimg', {
						setSelect : [ 40, 40, 100, 100 ],
						aspectRatio : 1,
						onSelect : updateCoords
					});
				};
				if (api != undefined) {
					api.destroy();
				}
			}
			function updateCoords(obj) {
				$("#x").val(obj.x);
				$("#y").val(obj.y);
				$("#w").val(obj.w);
				$("#h").val(obj.h);
			}
		} 
		
		//保存图片
		function doSavePic(){
			var userId = '${userId}';
			$('#myform').form('submit',{
	            url: '${ctx}/userController/doSavePic',
	            onSubmit: function(){
	                return true;
	            },
	            success: function(result){
	            	$("#userpic",parent.document).attr("src","uploader/uploadfile?pic="+userId+"."+fileType+"&r="+new Date());
	            	$("#picUrl",parent.document).val(userId+"."+fileType);
	            	
	            	window.parent.closePicDialog();
	            },
	            error : function(result) {
	            	alert("保存失败！");
				}
	        }); 
		}
	</script>
</head>
<body>
<form name="myform" id="myform" action="" class="form-horizontal"
      method="post" enctype="multipart/form-data">
    <div class="modal-body text-center">
        <div class="zxx_main_con">
        	<a href="javascript:void(0)" class="easyui-linkbutton">选择图片
					<input style="position:absolute;left:0;top:0;width:100%;height:100%;z-index:999;opacity:0;filter:alpha(opacity=0);" type="file" name="imgFile" id="fcupload" onChange="readURL(this)"/>											
				</a>
            <div style="width:150px;height:auto;margin-left:100px;margin-top:30px">
                <br/>
                <img alt="" src="" id="cutimg" style="width:150px;height:auto;margin-left:100px;margin-top:0px"/>
                <input type="hidden" id="x" name="x"/>
                <input type="hidden" id="y" name="y"/>
                <input type="hidden" id="w" name="w"/>
                <input type="hidden" id="h" name="h"/>
                <input type="hidden" id="userId" name="userId" value="${userId}"/>
            </div>
        </div>
    </div>
</form>


<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/jquery.Jcrop.js"> </script>
<script type="text/javascript" src="${ctx}/views/cap/isc/user/js/basic.js"> </script>
</body>
</html>