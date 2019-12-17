// 点击删除当前页时,禁用鼠标滚动事件,默认不禁用
var disableMousewheel = true;

$(function(){
	// ---------界面初始化时，计算功能按钮布局---------
	calcLayout();

	// ---------关闭自动轮播效果-------------------
	$(".carousel").carousel({
	  interval: false
	});
	
	var num = parseInt(ret);
	$("#myCarousel").carousel(num);
	carouselBtnWidth();

	// ---------当轮播完成幻灯片过渡效果时触发该事件------
	$('.carousel').on('slid.bs.carousel', function () {
		calcLayout();
	});
	
	// ---------添加移动端滑动事件------------------
	if (!IsPC()) {
		$(".shortcut").swipe({
			swipe:function (event, direction, distance, duration, fingerCount) {
				if (direction == "left") {
					$(".carousel").carousel('next');
				} else if (direction == "right") {
					$(".carousel").carousel('prev');
				}
			}
		});
	}

	// ---------初始化按钮图标拖拽------------------
	sortableItem();

	// ---------监听shortcut DIV区域鼠标滚动事件-----
	$('#shortcut').mousewheel(function(event, delta) {  
		var dir = delta > 0 ? 'Up' : 'Down';
		if (disableMousewheel) {
			if (dir == 'Up') {
				$(".carousel").carousel('prev');
			} else {
				$(".carousel").carousel('next');
			}
		}
		return false;
	});

	// ---------设置该垃圾箱为一个可放置的区域，用来接收功能按钮------
	$("#trash").droppable({
		//设置允许接收的内容为指定的内容
		accept: ".item > a",
		//当接收的对象在被拖拽时，设置该垃圾箱的css样式
		activeClass: "ui-state-highlight",
		//当被拖拽目标完全进入指定的容器内内部时触发的函数（经过测试该完全进入是指被拖拽目标的1/2进入指定区域即可）
		drop: function( event, ui ) {
			// 调用删除事件，删除被拖拽对象原始位置的功能按钮
			ui.draggable.remove();
			var obj = ui.helper;
			var id = $(obj).attr("id");
			var pageNum = $(obj).attr("pageNum");
			// 调用删除事件，数据库中删除功能按钮
			doDelBtns(id,pageNum);
		}
	});

	// ---------判断是显示PC端导航菜单, 还是显示移动端导航菜单------
	if (IsPC()) {
		$("#mainPoint").css("display", "block");
		$("#mobileNavDiv").css("display", "none");
	} else {
		$("#mainPoint").css("display", "block");
		$("#mobileNavDiv").css("display", "none");
	}
});

/**
 * 初始化按钮图标拖拽
 */
function sortableItem() {
	$(".item").sortable({
		revert: true,						// 是否使用一个流畅的动画还原到它的新位置
		//containment: "parent",			// 定义拖拽时，sortable 项目被约束的边界
		placeholder: "ui-state-highlight",	// 放置占位符, 要应用的 class 名称，否则为白色空白
		items: "a:not(.ui-state-disabled)", // 添加此class的元素不能被拖动
		start: function(event, ui) {        // 当排序开始时触发该事件
			$("#trash").css("display", "block");
		},
		stop: function(event, ui) {			// 当排序停止时触发该事件
			$("#trash").css("display", "none");
			var obj = $(this).children();
			var ids = [];
			var sorts = [];
			$(obj).each(function(i){ 
				if ($(obj[i]).attr("title") != '新增') {
					ids.push($(obj[i]).attr("id"));
					sorts.push($(obj[i]).attr("sort"));
				}
			});
			var pageNum = $(this).attr("pageNum");
			$.ajax({
				url : 'themeController/doSortable',
				dataType : 'json',
				async : true,
				type : "POST",
				data : {ids : ids.toString(),sorts : sorts.toString(),pageNum : pageNum},
				success : function(result) {
					ids = [];
					sorts = [];
				},
				error : function(result) {
					$.messager.alert('提示', "操作失败！",'error');
				}
			});
		}
	});
}

/**
 * 窗口发生变化时，重新计算功能按钮布局
 */
$(window).resizeEnd(function(){
	calcLayout();
});

/**
 * 删除功能按钮(数据库删除)
 * @param ids 功能按钮ID
 */
function doDelBtns(ids,pageNum) {
	$.ajax({
		url : 'themeController/doDelBtns',
		dataType : 'json',
		async : true,
		type : "POST",
		data : {ids : ids,pageNum : pageNum},
		success : function(result) {
			
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

/**
 * 删除功能按钮(数据库删除)
 * @param ids 功能按钮ID
 */
function doSaveBtns(id,pageNum) {
	$.ajax({
		url : 'themeController/doSaveBtns',
		dataType : 'json',
		async : true,
		type : "POST",
		data : {id : id,pageNum : pageNum},
		success : function(result) {
			
		},
		error : function(result) {
			$.messager.alert('提示', "操作失败！",'error');
		}
	});
}

function carouselBtnWidth(){
	var W = $(".carousel-indicators").width();
	$(".carousel-indicators").css({
		"left":"50%",
		"margin-left":-W/2 +"px"
	});
}

/**
 * 计算功能按钮布局
 */
function calcLayout(){
	var allW = $(".shortcut").width();
	var aW = $('div[role="listbox"] a').outerWidth(true);
	var aH = $('div[role="listbox"] a').outerHeight(true);
	var num = $('div[role="listbox"] .active').children('a').length;
	var rows = Math.floor(allW/aW);
	var cols = Math.ceil(num/rows);
	var itemW = rows * aW ;
	var itemH = cols * aH ;
	$('div[role="listbox"]').css({
		"position":"absolute",
		//"top":"50%",
		//"margin-top":-itemH / 2+"px",
		"left":"50%",
		"margin-left":-itemW / 2+"px"
	});

	// 分辨率小时，按钮按照小尺寸显示
	var bodyW = $("#shortcut").width();
	var bodyH = $("#shortcut").height();
	if(bodyW < 680 ){
		$("#btnCon").addClass("shortcut_small");
	}else{
		if( bodyH < 600){
			$("#btnCon").addClass("shortcut_small");
		}else{
			$("#btnCon").removeClass("shortcut_small");
		}
	}
}

/**
 * 添加菜单
 * 
 * pageNum 当前页码
 * total   
 * arr     
 */
function addModule(pageNum, total, arr){
	closeSetDialog();
	if (arr == '') {
		return;
	}
	total = $("#sortable"+pageNum).children().length;
	for (var i = 0;i < arr.length;i++) {
		// 如果字体图标为空,则使用默认字体图标
		if (arr[i].modIcon == "") {
			arr[i].modIcon = "iconfont icon-bookmark";
		}
		var checked = arr[i].checked;
		if (checked == "checked") {
			$("#sortable"+pageNum+" "+"#"+arr[i].modId).remove();
			total--;
			doDelBtns(arr[i].modId,pageNum);
		} else {
			var str = "<a title=\""+arr[i].modName+"\" id=\""+arr[i].modId+"\" pagenum=\""+pageNum+"\" class=\"ui-sortable-handle\"" +
					" onclick=\"addTab(\'"+arr[i].modId+"\',\'"+arr[i].modName+"\',\'"+arr[i].modIcon+"\',\'"+arr[i].modUrl+"\')\"><i class=\""+arr[i].modIcon+" color1\"></i><span>"+arr[i].modName+"</span></a>";
			if (total < 15) {
				$("#"+pageNum).before(str);
				total++;
				doSaveBtns(arr[i].modId,pageNum);
			} else {
				layerAlert("当前页已满!");
				return 
			}
		}
	}
}

/**
 * 保存添加的菜单
 */
function saveSelectMod() {
	window.frames["setFrame"].saveSelectMod();
}

/**
 * 关闭自定义菜单设置框
 */
function closeSetDialog() {
	$('#setModal').modal('hide');
}

/**
 * 点击功能按钮添加Tab页
 * 
 * modId   模块ID
 * modName 模块名称
 * modIcon 模块字体图标
 * modUrl  模块URl
 */
function addTab(modId, modName, modIcon, modUrl) {
	if ($("#trash").css("display") != 'none') {
		return;
	}
	var options={
			"text":modName,
			"id": modId,
			"href":ctx + modUrl,
		    "pid":window,
		    "modIcon" : modIcon
	};
	window.parent.createTab(options);
}

/**
 * 自定义常用菜单
 * pageNum 当前页数
 * total	当前页模块总数
 */
function showSet(pageNum, total) {
	$('#setModal').modal('show');
	$('#setFrame').attr('src', ctx+'/themeController/shortcutSet?pageNum='+pageNum+'&total='+total);
}

/**
 * 是否PC端
 * true  : PC端
 * false : 非PC端
 */
function IsPC() {
    var userAgentInfo = navigator.userAgent;
    var Agents = ["Android", "iPhone", "SymbianOS", "Windows Phone", "iPad", "iPod"];
    var flag = true;
    for (var v = 0; v < Agents.length; v++) {
        if (userAgentInfo.indexOf(Agents[v]) > 0) {
            flag = false;
            break;
        }
    }

    return flag;
}

function addPageBefore(){
	// 禁用鼠标滚动事件
	disableMousewheel = false;
	$("#pageName").val("");
	$("#pageIcon").val("");
	$("#pageNum").val("");
	$('#addPageModal').modal('show');
}

/**
 * 添加空白页，仅保留有添加按钮
 */
function addPage() {
	
	var pageName = $("#pageName").val();
	var pageIcon = $("#pageIcon").val();

	if(pageName == ''){
		layerAlert("请输入页名称！");
		return;
	}
	
	if(pageIcon == ''){
		//layerAlert("请输入页图标！");
		//return;
		$("#pageIcon").val("iconfont icon-bookmark");
		pageIcon = "iconfont icon-bookmark";
	}
	// 获取point数量, 动态添加时追加数值, 此时需要减去加号li
	var pointObj = document.getElementById("mainPoint");
	var pointList = pointObj.getElementsByTagName("li");
	var pointNum = (pointList.length - 1);
	if(pointNum >= 10){
		layerAlert("不能添加更多的页数！");
		return;
	}
	var pageNum = $("#mainPage").children().last().attr("pageNum");
	pageNum = parseInt(pageNum) + 1;
	$("#pageNum").val(pageNum);
	$.ajax({
		url:'themeController/doAddPage',
		data:$('#add_form').serialize(),
		type:'post',
		success: function(data){
			// 隐藏添加页窗口
			$('#addPageModal').modal('hide');
			
			// 添加轮播按钮
			var point = "<li data-target=\"#myCarousel\" data-slide-to=\""+pointNum+"\"><span>"+pageName+"</span><i title=\""+pageName+"\" class=\""+pageIcon+" color1\"></i></li>";
			$("#mainPoint li[class='btn-add-del']").before(point);

			// 添加空白页
			var page = "<div id=\"sortable"+pageNum+"\" pageNum=\""+pageNum+"\" class=\"item ui-sortable\"><a title=\"新增\" id=\""+pageNum+"\" class=\"add-btn  ui-state-disabled\" onclick=\"showSet(\'"+pageNum+"\',\'"+pointNum+"\')\"><i class=\"iconfont icon-liansuoqudaoxinzeng\"></i></a></div>"
			$("#mainPage").append(page);

			// 显示新增的空白页
			$("#myCarousel").carousel(pointNum);
			carouselBtnWidth();

			// 启用鼠标滚动事件
			disableMousewheel = true;

			// 重新初始化按钮图标拖拽
			sortableItem();
		}
	})
}

/**
 * 关闭添加页窗口
 */
function closeAddDialog(){
	// 关闭添加页窗口
	$('#addPageModal').modal('hide');

	// 启用鼠标滚动事件
	disableMousewheel = true;
}

/**
 * 删除页
 */
function delPage() {
	// 禁用鼠标滚动事件
	disableMousewheel = false;

	layer.confirm('删除当前页会导致定制的功能一并删除，<br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;'
			+ '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;是否确定删除？', {
	  btn: ['是','否']
	}, function(){
		// 刷新当前框口
		var obj = $("#mainPage").children();
		var curPageNum = "";
		$(obj).each(function (i){
			if ($(obj[i]).hasClass("active")) {
				curPageNum = $(obj[i]).attr("pageNum");
				return false;
			}
		});
		var obj1 = $("#mainPoint").children();
		var pointNum = "";
		$(obj1).each(function (i){
			if ($(obj1[i]).hasClass("active")) {
				pointNum = $(obj1[i]).attr("data-slide-to");
				return false;
			}
		});
		if (curPageNum == '') {
			layerAlert("当前没有可删除页！");
			return;
		}
		$.ajax({
			url : 'themeController/doDelPage',
			dataType : 'json',
			async : true,
			type : "POST",
			data : {curPageNum : curPageNum},
			success : function(result) {
				layer.confirm('删除成功!', {
				  btn: ['确定'] //按钮
				}, function(){
					window.location.href = ctx+"/themeController/shortcutDesk?pointNum="+pointNum;
				});
			},
			error : function(result) {
				$.messager.alert('提示', "操作失败！",'error');
			}
		});
	}, function(){
		// 启用鼠标滚动事件
		disableMousewheel = true;
	});
}

/**
 * 弹出选择图标界面
 */
function openFunIconDialog(){
	$("#setIconFrame").attr("src",ctx+"/static/cap/font/index.html");
	$('#funIconDialog').modal('show');
}

/**
 * 关闭图标选择框
 */
function closeFunIconDialog(){
	$('#funIconDialog').modal('hide');
}

/**
 * 设置模块图标
 */
function setFunIcon(val){
	// 如果当前选择的系统支撑平台则图标样式为：[iconfont icon-ht icon-***]
	val = "iconfont " + val
	$('#pageIcon').val(val);
}