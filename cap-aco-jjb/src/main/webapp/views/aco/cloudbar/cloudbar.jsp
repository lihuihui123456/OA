<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<title>企业微信</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link href="${ctx}/static/cap/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<link href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/ztree/css/metroStyle/metroStyle.css" />
<link href="${ctx}/views/aco/cloudbar/css/cloudbar.css" rel="stylesheet">
<script src="${ctx}/static/cap/plugins/swiper/idangerous.swiper.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.core-3.5.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.exedit-3.5.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/ztree/js/jquery.ztree.excheck-3.5.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/laydate-v1.1/laydate.js"></script>
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body style="overflow:hidden;">
	<div class="cloudbar-messaging">
		<div class="search">
			<input type="text" class="form-control input-sm" placeholder="搜索联系人、群组、部门">
			<i class="fa fa-search"></i>
		</div>
		<div class="grouping">
			<div class="linkman">
				<img src="${ctx}/views/aco/cloudbar/images/user1.png">
				<div class="linkman-info">
					<div class="name">吉姆</div>
					<div class="time">7/10</div>
					<div class="state"><span>[在线]</span>世界很大，我想去看看。。。</div>
				</div>
			</div>
			<div class="linkman active">
				<img src="${ctx}/views/aco/cloudbar/images/user2.png">
				<div class="linkman-info">
					<div class="name">美女</div>
					<div class="time">7/1</div>
					<div class="state"><span>[在线]</span>世界很大，我想去看看。。。</div>
				</div>
			</div>
			<div class="linkman">
				<img src="${ctx}/views/aco/cloudbar/images/user3.png">
				<div class="linkman-info">
					<div class="name">Jesse</div>
					<div class="time">6/20</div>
					<div class="state"><span>[在线]</span>天气很好，心情很好。。。</div>
				</div>
			</div>
			<div class="linkman">
				<img src="${ctx}/views/aco/cloudbar/images/user4.png">
				<div class="linkman-info">
					<div class="name">leron</div>
					<div class="time">6/18</div>
					<div class="state"><span>[在线]</span>我是一个小男孩。。。</div>
				</div>
			</div>
			<div class="linkman">
				<img src="${ctx}/views/aco/cloudbar/images/user5.png">
				<div class="linkman-info">
					<div class="name">皮特</div>
					<div class="time">6/15</div>
					<div class="state"><span>[在线]</span>世界很大，我想去看看。。。</div>
				</div>
			</div>
		</div>
	</div>
	<div class="cloudbar-title">
		<div class="name-groups">姓名1、姓名2、姓名3、姓名4、姓名5、姓名6、姓名7、姓名8、姓名9、姓名10<span>10</span></div>
		<div class="user-plus">
			<i class="fa fa-user-plus"></i>
		</div>
	</div>
	<div class="cloudbar-dialog-box">
    	<div class="dialog">
    		<p class="time">6月18日 11：42</p>
    		<p class="people"><span>易红成邀请徐冰飞、高兆琼、李超、徐真、徐冰飞、高兆琼、李超、徐真和你加入了群聊</span></p>
    		<div class="user">
    			<img src="${ctx}/views/aco/cloudbar/images/user2.png">
    			<div class="user-name">美女</div>
    			<div class="information">
    				<div class="arrow"><span></span></div>
    				今天天气很好啊！
    			</div>
    			<div class="state">
    				<span class="read">已读</span>
    			</div>
    			<div class="receipt">
    				<i class="fa fa-check-circle"></i>
    				<span>回执消息</span>
    			</div>
    		</div>
    		<div class="mine">
    			<img src="${ctx}/views/aco/cloudbar/images/user6.png">
    			<div class="information">
    				<div class="arrow"><span></span></div>
    				是啊！
    			</div>
    			<div class="state">
    				<span class="unread">1人未读</span>
    			</div>
    			<div class="receipt">
    				<i class="fa fa-check-circle"></i>
    				<span>回执消息</span>
    			</div>
    		</div>
    		<div class="user">
    			<img src="${ctx}/views/aco/cloudbar/images/user2.png">
    			<div class="user-name">美女</div>
    			<div class="information">
    				<div class="arrow"><span></span></div>
    				今天天气很好啊！
    			</div>
    			<div class="state">
    				<span class="read">已读</span>
    			</div>
    			<div class="receipt">
    				<i class="fa fa-check-circle"></i>
    				<span>回执消息</span>
    			</div>
    		</div>
    		<div class="mine">
    			<img src="${ctx}/views/aco/cloudbar/images/user6.png">
    			<div class="information">
    				<div class="arrow"><span></span></div>
    				是啊！天气好心情好！
    			</div>
    			<div class="state">
    				<span class="unread">1人未读</span>
    			</div>
    			<div class="receipt">
    				<i class="fa fa-check-circle"></i>
    				<span>回执消息</span>
    			</div>
    		</div>
    		<div class="user">
    			<img src="${ctx}/views/aco/cloudbar/images/user2.png">
    			<div class="user-name">美女</div>
    			<div class="information">
    				<div class="arrow"><span></span></div>
    				今天天气很好啊！
    			</div>
    			<div class="state">
    				<span class="read">已读</span>
    			</div>
    			<div class="receipt">
    				<i class="fa fa-check-circle"></i>
    				<span>回执消息</span>
    			</div>
    		</div>
    		<div class="mine">
    			<img src="${ctx}/views/aco/cloudbar/images/user6.png">
    			<div class="information">
    				<div class="arrow"><span></span></div>
    				是啊！
    			</div>
    			<div class="state">
    				<span class="read">已读</span>
    			</div>
    			<div class="receipt">
    				<i class="fa fa-check-circle"></i>
    				<span>回执消息</span>
    			</div>
    		</div>
    		<div class="user">
    			<img src="${ctx}/views/aco/cloudbar/images/user2.png">
    			<div class="user-name">美女</div>
    			<div class="information">
    				<div class="arrow"><span></span></div>
    				今天天气很好啊！
    			</div>
    			<div class="state">
    				<span class="read">已读</span>
    			</div>
    			<div class="receipt">
    				<i class="fa fa-check-circle"></i>
    				<span>回执消息</span>
    			</div>
    		</div>
    		<div class="mine">
    			<img src="${ctx}/views/aco/cloudbar/images/user6.png">
    			<div class="information">
    				<div class="arrow"><span></span></div>
    				是啊！
    			</div>
    			<div class="state">
    				<span class="read">已读</span>
    			</div>
    			<div class="receipt">
    				<i class="fa fa-check-circle"></i>
    				<span>回执消息</span>
    			</div>
    		</div>
    	</div>
    	<div class="dialog-edit">
    		<div class="setting">
    			<a><img src="${ctx}/views/aco/cloudbar/images/icon/icon_bq.png"></a>
    			<a><img src="${ctx}/views/aco/cloudbar/images/icon/icon_prt.png"></a>
    			<a><img src="${ctx}/views/aco/cloudbar/images/icon/icon_dd.png"></a>
    			<a><img src="${ctx}/views/aco/cloudbar/images/icon/icon_pic.png"></a>
    			<a><img src="${ctx}/views/aco/cloudbar/images/icon/icon_sp.png"></a>
    			<a><img src="${ctx}/views/aco/cloudbar/images/icon/icon_yy.png"></a>
    		</div>
    		<textarea></textarea>
    		<div class="send-out">
    			<botton type="button">发送(s)</botton>
    		</div>
    	</div>
    	
	</div>
	<div class="cloudbar-tree">
		<ul>
			<li class="female"><i class="fa fa-user"></i>姓名1</li>
			<li class="male"><i class="fa fa-user"></i>姓名2</li>
			<li class="female"><i class="fa fa-user"></i>姓名3</li>
			<li class="female"><i class="fa fa-user"></i>姓名4</li>
			<li class="male"><i class="fa fa-user"></i>姓名5</li>
			<li class="male"><i class="fa fa-user"></i>姓名6</li>
		</ul>
	</div>
<script src="${ctx}/views/cap/isc/theme/common/js/jquery.nicescroll.js"></script>
<script>
$(function(){	
	winH();
	$(".dialog,.dialog-edit textarea,.grouping,.cloudbar-tree").niceScroll({
		cursorcolor : "#000",
		cursoropacitymax : 0.3,
		touchbehavior : false,
		cursorwidth : "8px",
		cursorborder : "0",
		cursorborderradius : "8px"
	});
	$(".dialog > .mine > .state > span").each(function(index){
		$(".dialog > .mine > .state > span").eq(index).css("right",stateRight(this));
	});
	
	var words = $(".cloudbar-title > .name-groups").html();
	$(".cloudbar-title > .name-groups").html(words.substr(0,36) +"…" + "<span>10</span>");
	
	$(".grouping > .linkman").click(function(){
		$(".grouping > .linkman").removeClass("active");
		$(this).addClass("active");
	});
});
$(window).resize(function(){
	winH();
});

function winH(){
	var dialogH = $(".cloudbar-dialog-box").height()-$(".dialog-edit").height()-26-40;
	$(".dialog").height(dialogH);
	var groupingH = $(".cloudbar-messaging").height()-$(".search").height()-15;
	$(".grouping").height(groupingH);
}
function stateRight(obj){
	var stateRight = $(obj).parent().prev().outerWidth()+ $(".dialog > .mine > img").outerWidth() + 20;
	return stateRight;
}
</script>
</body>
</html>