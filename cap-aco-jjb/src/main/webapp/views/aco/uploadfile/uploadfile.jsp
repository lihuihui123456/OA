<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
	<title>导出打印模板上传</title>
	<%@ include file="/views/cap/common/easyui-head.jsp"%>
	<script type="text/javascript">
		function submitInfo() {
			var picSrc = $('#file').filebox('getValue');
			if (picSrc.indexOf(".ftl") < 0 ) {
				$.messager.alert('提示', '仅支持ftl格式文件，请重新选择！', 'info');
				return;
			}
			
			// 当选择图片后上传图片到服务器
			$('#themeForm').form('submit', {
				url : '${ctx}/templateMgmt/upfile',
			    success:function(data){
			    	window.parent.hideModel();
			    	window.parent.refreshTable();
			    	//layerAlert("上传成功");
			    },
			    error:function(data){
			    	alert("执行出现异常");
			    }
			});
		}
	</script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body class="easyui-layout" style="width: 100%; height: 70%;">
<form id="themeForm" method="post" class="window-form" enctype="multipart/form-data">
	<label>说&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;明：</label><input type="text" id="remark_" name="remark_" style="width:87%;margin-bottom:50px;" value=""/>
	<input id="file" name="file" class="easyui-filebox" style="width:92%" data-options="prompt:'请选择一张图片...'" /><br/>
	<!-- <input type="button" value="提交" onclick="submitInfo()"/> -->
</form>
</body>
</html>