<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>首页配置主题一</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/static/aco/images/favicon.ico" rel="SHORTCUT ICON" />
<link href="${ctx}/static/aco/images/favicon.ico" rel="BOOKMARK" />
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link href="${ctx}/views/cap/isc/theme/person/css/template.css" rel="stylesheet">
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="overflow-x:hidden;overflow-y:hidden;background-color:transparent">
		
		<div class="modal-body">
			<div class="row">
				<%-- <div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 ">
					<div class="template_eg">
						<a href="javascript:;"> <input name="theme_choose"
							type="radio" value="1"> <span>树形风格</span> <img
							src="${ctx}/static/aco/images/theme_eg/tree.png"> </a>
					</div>
				</div>
				<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 ">
					<div class="template_eg">
						<a href="javascript:;"> <input name="theme_choose"
							type="radio" value="2"> <span>浮动风格</span> <img
							src="${ctx}/static/aco/images/theme_eg/dialog.png"> </a>
					</div>
				</div> --%>
				
				<c:forEach var="list" items="${list }" varStatus="status">
					<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4 ">
						<div class="template_eg">
							<a href="javascript:;"> <input name="theme_choose"
								type="radio" style="display:none" id="${list.themeId }" code="${list.themeCode }" value="${list.themeId }" url="${list.themeUrl }" <c:if test="${list.themeId == userTheme }">checked</c:if>> 
								<span></span> <img id="${ status.index + 1}"
								src="${ctx}/${list.themePic }"> </a>
								<span>${list.themeName }</span> 
						</div>
						
					</div>
				</c:forEach>
			</div>
		</div>
		<!-- <div align="center" style="margin-bottom: 10px;margin-top:-40px;">
			<button class="btn btn-primary" onclick="saveTemplate()">选择</button>
			<button class="btn btn-primary" onclick="window.parent.close();">关闭</button>
		</div> -->
	<!-- /.modal-content -->

</body>

<!-- 引入JS文件 -->
<script type="text/javascript">

	$(function(){
		var skinCode = '<shiro:principal property="skinCode" />';
		var leng = $('.template_eg').length;
		var arr = [];
		for (var i = 1;i <= leng;i++) {
			arr[i] =  $("#"+i).attr("src");
		}
		
		var userTheme = '${userTheme}';
		if (userTheme != null && userTheme != '') {
			var sel = $('#'+userTheme).next().next('img');
			var name1 = null,type1 = null;
			name1 = sel.attr("src").split('.')[0];
			type1 = sel.attr("src").split('.')[1];
			sel.attr("src",name1+"_sel"+"_"+skinCode+"."+type1);
		}
		
		$('.template_eg').click(function(){
			var leng = $('.template_eg').length;
			for (var i = 1;i <= leng;i++) {
				$("#"+i).attr("src",arr[i]);
			}
			
			var obj = null;
			var name = null,type = null;
			$(this).find('input[name="theme_choose"]').attr("checked",true);
			obj = $(this).find('img');
			name = obj.attr("src").split('.')[0];
			type = obj.attr("src").split('.')[1];
			obj.attr("src",name+"_sel"+"_"+skinCode+"."+type);
		});
	});
	function saveTheme() {
		var num = $('input[name="theme_choose"]:checked').val();
		var url = $('input[name="theme_choose"]:checked').attr("url");
		var code = $('input[name="theme_choose"]:checked').attr("code");
		//alert(url);
		$.ajax({
			type : "POST",
			url : "themeController/doSaveUserTheme",
			async: false,
			data : {num : num,code : code},
			dataType : "json",
			success : function(data) {
				window.parent.closeThemeDialog();
				//window.parent.location.reload();
				window.parent.location.href="${ctx}"+url;
				//window.parent.location.href="${ctx}/views"+url+".jsp";
			}
		});
		//window.parent.closeThemeDialog();
		//window.parent.location.href="${ctx}/views"+num+".jsp";
	}
</script>
</html>