<%@ page contentType="text/html;charset=UTF-8"%>
	<!-- 消息推送JS -->
	<shiro:hasPermission name="on:msgpushController:msgpush">
	<script type="text/javascript" src="${ctx}/static/cap/plugins/msgpush/notice.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/msgpush/pushAPI.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/msgpush/strophe.js"></script>
	</shiro:hasPermission>
	<!-- 消息推送 参数配置 -->
	<shiro:hasPermission name="on:msgpushController:msgpush">
		<script type="text/javascript">
			//全局变量存储即时通讯接口
			var connector={};
			var layIMobj={};
			//global variable of the instant message connections
			var globalMsgPushConnection = null;//used for the notice-list child frame
			//这些数值是从后台传到前台
			var globalLoginName = '<shiro:principal property="loginName" />';
			var globalMsgPushUserDomain = "${MSG_PUSH_USER_DOMAIN}";
			var globalMsgPushServerAddr = "${MSG_PUSH_SERVER_IP}"+":"+"${MSG_PUSH_SERVER_PORT}";
			var globalPath = "${ctx}";
			//从后台获取登录的终端
			var globalMsgPushUserResource = "browser";
			
			//通知公告iframe是否已经加载完
			var noticeiFrameReady = false;
			var todoiFrameReady = false;
		</script>
	</shiro:hasPermission>