<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>情报流转</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<script type="text/javascript">

function toclose(){
	window.parent.closePage(window,true,true,true);
}

</script>


	<script>
	/**
	 * 初始化加载监听窗口改变事件
	 */
	$(window).resizeEnd(function(){
		winH();
	});
	/**
	 * 初始化加载页面高度
	 */
	$(function(){
		winH();
	});
	//计算页面高度
	function winH(){
		var id ="${applyid}";
		var iframeId = "";
		var action = "${action}";
		if(action=="shenpiview"){
			iframeId = 'framewply_view'+id;
		}else{
			iframeId = 'framewply_out_view_'+id;
		}
		$("#"+iframeId,parent.document).attr("scrolling","no");
		var H = $("#"+iframeId,parent.document).height();
		var btnH = $(".btn-group").height();
		//这里“40”是ie浏览器下的高度，在google浏览器中，此高度需要重新计算
		$("#wjbpd").height(H - btnH - 40);
	}
	</script>

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
</style>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body>
	<div class="container-fluid content">
	<!-- start: Content -->
	<div class="row">
		<div class="col-lg-12">
			<div class="panel panel-default" style="border: 0;background-color:#f2f4f8;">
				<div class="panel-body" style="padding:0">
					<div class="panel-body" style="border: 0px; padding: 5px 5px;">
						<div class="btn-group" role="group" aria-label="...">
							<button class="btn btn-default btn-sm" id="toclose" onclick="toclose()">
								<i class="fa fa-reply"></i>&nbsp;返回
							</button>
						</div>
					</div>

					<!-- Tab panes -->
					<div class="tab-content">
						<div role="tabpanel" class="tab-pane active" id="home">
							<iframe id="wjbpd" runat="server" src="${url }" width="100%" 
								frameborder="no" border="0" marginwidth="0" marginheight="0" scrolling="yes" ></iframe>
						</div>
					</div>
				</div>
			</div>
		</div>
	<!--/col-->
	</div>
	<!--/row-->
	</div>
	<div class="clearfix"></div>

</body>
</html>