/**
 * Created by Administrator on 2016/12/7.
 */
$(function() {
	var Mheight = $(".describe")[0].scrollHeight + 45;
	
	// 判断
	if ($(".describe").height() <= 55) {
		// 收起详情和展开详情的小图标地址
		$(".down").attr("src", "img/down.jpg");
		// class=main 的高度
		$(".main").css("height", "180px");
		
	} else {
		$(".down").attr("src", "img/up.jpg");
		$(".main").css("height", Mheight + 'px');
			}
	if ($(".down").attr("src") == "img/down.jpg") {
		$(".describe").css("overflow", "hidden");
	} else {
		$(".describe").css("overflow", "");
	}
	

	// 添加点击事件
	$(".btn").click(
			function() {
				// 获取点击按钮的小图标
				if ($($(this).children("span")[1].children).attr("src") == "img/down.jpg") {
					// 插件描述的元素
					$($(this).siblings(".describe")).css("overflow", "");
					// 获取点击按钮的小图标并设置路径
					$($(this).children("span")[1].children).attr("src", "img/up.jpg");
					// 获取class=main的元素
					$(this).parent().parent().parent().css("height", Mheight + 90 + 'px');
					// 获取点击按钮并设置文本
					$($(this).children("span")[0]).html("收起详情");
				} else {
					$($(this).siblings(".describe")[0]).css("overflow", "hidden");
					$($(this).children("span")[1].children).attr("src", "img/down.jpg");
					$(this).parent().parent().parent().css("height", "180px");
					$($(this).children("span")[0]).html("展开详情");
				}
				
			}
	)
})


