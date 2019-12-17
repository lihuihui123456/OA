/**
 * 初始化函数
 */
$(document).ready(function(){
	// 初始化左侧菜单宽度
	init();

	// 监听菜单点击事件
	$(".sidebar").click(function(){
		enlarge();
	});

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

	// 初始化放大缩小按钮提示信息
	tipInfo();
});

/**
 * 初始化放大缩小按钮提示信息
 */
function tipInfo(){
	//鼠标经过放大缩小图标时出现文字提示
	var isMax = $(".btn_control > i").attr("class");
	if (isMax.indexOf("icon-max") > 1) {
		$(".btn_control > i").mouseover(function(){
			$(this).attr("title","工作区放大");
		});
	} else {
		$(".btn_control > i").mouseover(function(){
			$(this).attr("title","工作区缩小");
		});
	}
}

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
 * 重置内容区域高度 add by 徐真 2016-12-26
 */
function resetContentHeight() {
	// 重置内容区域高度
	var mainbody_h = $("#mainbody").height();
	var navbar_h = $("#navbar").height();
	var footer_h = $("#footer").height();
	var h = mainbody_h - navbar_h - footer_h -45;
	// 动态设置个人桌面的body高度，并赋值给body
	var body_height = document.documentElement.clientHeight || document.body.clientHeight;
	var isMin = $(".btn_control > i").attr("class");
	if (isMin.indexOf("icon-min") > 1) {
		$(".window-frame").height(h);
		$('#allArea').css("height", (body_height) + "px");
	} else {
		$(".window-frame").height(h);
		$('#allArea').css("height", body_height + "px");
	}

	//Iframe内部记录条数和高度
	var iframeH = liCounts() * 42 + 39;
	$("#todo_iframe").height(iframeH);
	$("#calendarPanel").height(iframeH);
	$("#calendar_iframe").height(iframeH);
	$("#notice_iframe").height(iframeH);
	$("#trace_iframe").height(iframeH) ;
}

/**
 * 获取Iframe窗口显示记录行数
 */
function liCounts(){
	var mainH= $("#myTabContent").height()-25;
	var titleH = 39 ; // Iframe标题高度
	var rowCounts = Math.floor((mainH / 2 - titleH) / 42);
	if(rowCounts < 5){
		rowCounts = 5 ;
	}

	return rowCounts;
}

/**
 * 初始化左侧菜单宽度
 */
function init(){
	var win_width = screen.width;
	$(".sidebar .sidebar-menu").css("width", getSidebarWidth()+"px");
	$(".main").css("padding-left", getSidebarWidth() + 20 +"px");
	$(".sidebar").css("width", getSidebarWidth()+"px");	
}

/**
 * 根据电脑分辨率获取左侧菜单的宽度
 * @returns {Number}
 */
function getSidebarWidth() {
	var cur_sidebar_width = 180;
	var win_width = screen.width;
	if (win_width > 1024) {
		cur_sidebar_width = 240;
	}

	return cur_sidebar_width;
}

/**
 * 放大缩小按钮点击事件
 */
function btnClick() {
	var isMax = $(".btn_control > i").attr("class");
	if (isMax.indexOf("icon-max") > 1) {
		narrow();
		tipInfo();
	} else{
		enlarge();
		tipInfo();
	}
}

/**
 * 主页最小化
 */
function narrow() {
	// 设置放大缩小按钮为最小化状态
	$(".btn_control > i").attr("class", "iconfont icon-min font22");
	// 设置左侧菜单最小化，宽度为45px
	$(".sidebar").animate({ "width":"42px", 'top':0 });
	// 设置内容区域左移
	$(".main").animate({ 'padding-left':'61px', 'padding-top':'0px' });
	// 设置顶部隐藏
	$("#top-header").css("display", "none");
	// 重新计算Iframe高度
	iframeheight();

	// 收起所有菜单
	$('#treeview12').treeview('collapseAll', { silent: true });

	// 重置内容区域高度 add by 徐真 2016-12-26
	resetContentHeight();
}

/**
 * 主页最大化
 */
function enlarge() {
	// 设置放大缩小按钮为最大化状态
	$(".btn_control > i").attr("class", "iconfont icon-max font22");
	// 设置左侧菜单最大化，宽度为240px
	$(".sidebar").animate({ "width":getSidebarWidth() + "px", "top": "0px" });
	// 设置内容区域右移
	$(".main").animate({ 'padding-left':getSidebarWidth() + 20 +"px", 'padding-top':'0px' });
	// 设置顶部显示
	$("#top-header").css("display", "block");
	// 重新计算Iframe高度
	iframeheight();

	// 重置内容区域高度 add by 徐真 2016-12-26
	resetContentHeight();
}