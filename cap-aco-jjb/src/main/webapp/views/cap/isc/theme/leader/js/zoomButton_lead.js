/**
 * 初始化函数
 */
$(document).ready(function(){
	// 初始化左侧菜单宽度
	init();

	// 页面加载时判断如果浏览器宽度小于780时，自动收起左侧菜单（全屏模式）
	var bodyWidth = document.documentElement.clientWidth || document.body.clientWidth;
	if (bodyWidth < 780) {
		var isMax = $(".btn_control > i").attr("class");
		if (isMax.indexOf("icon-max") > 1) {
			narrow();
		}
	}

	// 重置内容区域高度  add by 徐真 2016-12-26
	resetContentHeight();
});

/**
 * 监听浏览器重置窗口事件，如果浏览器宽度小于780时，自动收起左侧菜单（全屏模式）
 */
$(window).resizeEnd(function() {
	var bodyWidth = document.documentElement.clientWidth || document.body.clientWidth;
	if (bodyWidth < 780) {
		var isMax = $(".btn_control > i").attr("class");
		if (isMax.indexOf("icon-max") > 1) {
			narrow();
		}
	}

	// 重置内容区域高度 add by 徐真 2016-12-26
	resetContentHeight();
});

/**
 * 重置内容区域高度 
 */
function resetContentHeight() {
	// 重置内容区域高度
	var mainbody_h = $("#mainbody",parent.document).height();
	var footer_h = $("#footer",parent.document).height();
	var h = mainbody_h - footer_h -45;
	// 动态设置个人桌面的body高度，并赋值给body
	var body_height = document.documentElement.clientHeight || document.body.clientHeight;
	var isMin = $(".btn_control > i").attr("class");
	if (isMin.indexOf("icon-min") > 1) {
		//$(".window-frame",parent.document).height(h + 60);
		$('.lead_left_min').css("height", (body_height - 40 ) + "px");
		$('.center_part').css("height", (body_height - 40 ) + "px");
		$("#myTabContent").height(h - 45);
		$("#myTabContent iframe").height(h - 45);
	} else {
		//$(".window-frame",parent.document).height(h);
		$('.left_part').css("height", (body_height - 40 ) + "px");
		$('.center_part').css("height", (body_height - 40 ) + "px");
		$("#myTabContent").height(h-45);
		$("#myTabContent iframe").height(h-45);
	}
}
/**
 * 初始化左侧菜单宽度
 */
function init(){
	var isMax = $(".btn_control > i").attr("class");
	if (isMax.indexOf("icon-max") > 1) {
		$(".left_part").css("display","block");
		$(".lead_left_min").css("display","none");
		$(".center_part").css("margin-left",350+20+"px");
		$(".contact_bg").css("left","338px");
	}else{
		$(".left_part").css("display","none");
		$(".lead_left_min").css("display","block");
		$(".center_part").css("margin-left",60+10+"px");
		$(".contact_bg").css("left","35px");
	}
}

/**
 * 放大缩小按钮点击事件
 */
function btnClick() {
	var isMax = $(".btn_control > i").attr("class");
	if (isMax.indexOf("icon-max") > 1) {
		narrow();
	} else{
		enlarge();
	}
}

/**
 * 主页最小化
 */
function narrow() {
	// 设置放大缩小按钮为最小化状态
	$(".btn_control > i").attr("class", "iconfont icon-min font22");
	// 设置左侧最小化，宽度为60px
	$(".left_part").css("display","none");
	$(".lead_left_min").css("display","block");
	$(".center_part").css({
		"margin-left":60+10+"px",
		"margin-top":"10px"
	});
	$(".contact_bg").css("left","35px");
	// 设置顶部隐藏
	$("#top-header",parent.document).css("display", "none");
	// 重新计算Iframe高度
	//iframeheight(60);

	// 重置内容区域高度 add by 徐真 2016-12-26
	resetContentHeight();
}

/**
 * 主页最大化
 */
function enlarge() {
	// 设置放大缩小按钮为最大化状态
	$(".btn_control > i").attr("class", "iconfont icon-max font22");
	$(".left_part").css("display","block");
	$(".lead_left_min").css("display","none");
	$(".center_part").css({
		"margin-left":350+20+"px",
		"margin-top":"10px"
	});
	$(".contact_bg").css("left","338px");
	// 设置顶部显示
	$("#top-header",parent.document).css("display", "block");
	// 重新计算Iframe高度
	//iframeheight();

	// 重置内容区域高度 add by 徐真 2016-12-26
	resetContentHeight();
}