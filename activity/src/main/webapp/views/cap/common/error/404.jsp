<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html>
<head>
	<title>404错误</title>
	<%@ include file="/views/aco/common/head.jsp"%>
	<script type="text/javascript">
		/**
		 * 页面初始化时，404页面居中显示
		 */
		/*$(function(){
			var mainbody_h = $("#myTabContent" , parent.document).height();
			var bodyH = $("body").height();
			alert(mainbody_h);
			var bodyMarT = (mainbody_h - bodyH)/2;
			$("body").css("margin-top",bodyMarT);
		});*/

		/**
		 * 刷新
		 */
		function refresh() {
			
		}

		/**
		 * 返回首页
		 */
		function home() {
			
		}
		
		function openITL() {
			window.open("http://www.itonglian.com")
		}
	</script>
</head>
<body style="width: 1345px;height:564px;font-family:'Microsoft yahei';margin-top:-45px;background: url('${ctx}/views/cap/common/error/img/404new.png') no-repeat center;overflow:hidden;">
	<table class="table" style="position: absolute;top:300px;">			
		<tr>			
			<td style="border: 0px;text-align: center;font-weight: bold;">
				非常抱歉，您访问的页面不存在，也可能是网络不好
			</td>
		</tr>
		<tr>
			<td style="border: 0px;text-align: center;font-weight: bold;">
				您可以尝试以下操作
			</td>
		</tr>
		<tr>
			<td style="border: 0px;text-align: center;">
				或者访问<a href="javascript:void(0);" onclick="openITL();">http://www.itonglian.com</a>
			</td>
		</tr>
		<tr>
			<td align="center"  style="border: 0px;font-size: 14px;">
				<a href="javascript:void(0);">
					<i class="fa fa-refresh"></i> 刷新
				</a>
				<a href="javascript:void(0);" style="margin-left: 75px;">
					<i class="fa fa-home"></i> 返回首页
				</a>
			</td>
		</tr>
	</table>
</body>
</html>