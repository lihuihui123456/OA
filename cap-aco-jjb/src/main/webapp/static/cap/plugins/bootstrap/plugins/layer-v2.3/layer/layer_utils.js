var NOTICE_ICON = 0; 	// 惊叹号图标
var YES_ICON = 1; 		// 对号图标
var NO_ICON = 2; 		// 错误图标
var CONFIRM_ICON = 3; 	// 问号图标
var LOCK_ICON = 4;		// 锁图标
var CRY_ICON = 5;		// 哭图标
var SMAIL_ICON = 6;		// 微笑图标

/**
 * layer弹出提示框
 * @param {String} 提示消息
 */
function layerAlert(msg) {
	// 弹出提示框
	layer.alert(msg, {
		title : "提示",
		skin: 'layui-layer-lan', // 样式类名
		icon : NOTICE_ICON,
		closeBtn : 0
	});
}

/**
 * layer弹出提示框，带提示图标
 * @param {String} 提示消息
 */
function layerAlert(msg, icon) {
	// 弹出提示框
	layer.alert(msg, {
		title : "提示",
		skin: 'layui-layer-lan', // 样式类名
		icon : icon,
		closeBtn : 0,
		shadeClose : 0.3,
		shadeClose : false
	});
}

function layerOpen(msg) {
	//自定页
	layer.open({
	  type: "提示",
	  skin: 'layui-layer-lan', //样式类名
	  closeBtn: 0, //不显示关闭按钮
	  anim: 2,
	  shadeClose: false, //开启遮罩关闭
	  content: msg
	});
}

/**
 * layer提示层，提示后自动消失
 * @param {String} msg 提示消息
 */
function layerMsg(msg) {
	//提示层
	layer.msg(msg);
}