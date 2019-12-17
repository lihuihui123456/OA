
var _cache={};

_cache.num=1;

_cache.windowTemp = {
    	"num":"circle"+_cache.num++,
        "width": 200,
        "height": 200,
        "top": 0,
        "left": 0,
        "zIndex":0,
        "pageid":""
};

//工作圈-前身
var liObj =
    '<li style="width:{width}px;height:{height}px;top:{top}px;left:{left}px;z-index:{zIndex};border:1.9px #fff solid"  pageid="{pageId}">' +
    '<img style="width:{width}px;height:{height}px;top:{top}px;left:{left}px;z-index:{zIndex};border:1.9px #fff solid" src="themeController/doDownLoadPicFile?picPath={modImg}" alt=""/>' +
    '<div class="tooltip">Image description</div>' +
    '</li>';

//工作圈
var windowWorkCircle =
    '<div style="width:{width}px;height:{height}px;top:{top}px;left:{left}px;z-index:{zIndex};border:1.9px #fff solid" class="carousel-item circle-container circle-current" circle="{num}" id="circle_{num}_warp"  >' +
    	'<div style="width: 100%;height:100%;" id="circle_{num}_inner" class="carousel-item-div">' +
    		'<div class="circle-bar">' +
    			'<i class="{modIcon}"></i> ' +
    			'{modName}' +
    		'</div>' +
    		'<div class="circle-image" id="circle-image_{num}">' +
    			'<img class="reflect" id="img{num}" style="width:100%;height:100%;margin:0;padding:0;" src="themeController/doDownLoadPicFile?picPath={modImg}" />' +
    		'</div>' +
    	'</div>' +
    '</div>';

//工作圈
var windowWorkCircle1 =
    '<div style="width:{width}px;height:{height}px;top:{top}px;left:{left}px;z-index:{zIndex};border:1.9px #fff solid" class="carousel-item circle-container circle-current" circle="{num}" id="circle_{num}_warp"  >' +
    	'<div style="width: 100%;height:100%;" id="circle_{num}_inner" class="carousel-item-div flag-inner-temp">' +
    		'<div class="circle-bar"> ' +
    			'<i class="fa fa-plus"></i> ' +
    			'请添加应用' +
    		'</div>' +
    		'<div class="circle-image" id="circle-image_{num}">' +
    			'<img class="reflect" id="img{num}" style="width:100%;height:100%;margin:0;padding:0;" src="views/cap/isc/theme/fusion/images/plus.png" />' +
    		'</div>' +
    	'</div>' +
    '</div>';

//工作圈
var windowWorkCircleInner =
	'<div style="width: 100%;height:100%;" id="circle_{num}_inner" class="carousel-item-div">' +
		'<div class="circle-bar"> ' +
			'<i class="{modIcon}"></i> ' +
			'{modName}' +
		'</div>' +
		'<div class="circle-image" id="circle-image_{num}">' +
			'<img class="reflect" id="img{num}" style="width:100%;height:100%;margin:0;padding:0;" src="themeController/doDownLoadPicFile?picPath={modImg}" />' +
		'</div>' +
	'</div>';

var Circleinner =
	'<div style="width: 100%;height:100%;" id="circle_{num}_inner" class="carousel-item-div flag-inner-temp"  >' +
		'<div class="circle-bar"> ' +
		    '<i class="fa fa-plus"></i> ' +
			'请添加应用' +	
		'</div>' +
		'<div class="circle-image" id="circle-image_{num}">' +
			'<img class="reflect" id="img{num}" style="width:100%;height:100%;margin:0;padding:0;" src="views/cap/isc/theme/fusion/images/plus.png" />' +
		'</div>' +
	'</div>';

//任务栏模板
var navigationLi1 =
    '<li class="icon_li" num="{modId}">' +
        '<img class="icon-img" src="themeController/doDownLoadPicFile?picPath={modImgSmall}" title="{modName}">' +
    '</li>';

var navigationLi =
	'<li class="icon_li" num="li{modId}">' +
		'<a title="{modName}" >' +
			'<i class="{modIcon}"></i>' +
			'<span class="ospan">{modName}</span>' +
	    '</a>'+
	'</li>';

var num=1;
//创建工作圈上的页面
var createCircle = function(obj, circle) {
    var setting = obj.ds;
    var win_warp=null;
    var temp = null;
    if(setting.modId==undefined||setting.modId==null){
    	win_warp = $(FormatModel(windowWorkCircle1, setting));
        win_warp.children(".carousel-item-div").data("ds",setting);
        temp = $(win_warp).appendTo(circle);
    }else{
    	win_warp = $(FormatModel(windowWorkCircle, setting));
        win_warp.children(".carousel-item-div").data("ds",setting);
        temp = $(win_warp).appendTo(circle);
        handleCircle(temp);
    }
    return temp;
};

//工作圈最大化，还原，双击
var handleCircle = function(obj) {
    //改变窗口样式
    $('.circle-container').removeClass('circle-current');

    handleClick(obj.children(".carousel-item-div"));
};

var handleClick = function(obj) {
    var df=1;
    obj.bind("click", function(e) {
        var setting = obj.data("ds");
        window.pid="home";
		var options={
				"id": setting.modId,
				"text":setting.modName,
				"href":window.ctx+setting.modUrl,
			    "pid":window,
			    "modIcon" : setting.modIcon
		};
		window.createTab(options);
    });
};




	
	

	
	
	
    jQuery(document).ready(function($){
    
		$.ajax({
			url : 'themeController/getFusionDesktop',
			dataType : 'json',
			async:false,
			data : {
				themeId : "",
				userId : ""
			},
			success : function(result) {
				var circleTask={
						"text":"融合桌面",
						"id": "home",
					    "pid":"home",
					    "icon" : "fa fa-home"
				};
				createHomeTab(circleTask);
				for (var sc=0;sc<result.length;sc++) {
					  var setting = $.extend({}, result[sc], _cache.windowTemp);
					  
					  if(setting.pageId.indexOf("circle") > -1 ){
						  //alert(setting.id);
						  var lio=$(FormatModel(liObj, setting));
						  lio.data("ds", setting);
				          $("#carousel").append(lio);
					  }else{
						  var lio = $(FormatModel(navigationLi, setting));
						  var str = lio.find(".ospan").text();
						  lio.find(".ospan").text(calStr(str));
				          lio.data("ds", setting);
				          $("#icon_wrap_ul").append(lio);
				          handleClick(lio);
					  }   
			    }
				
			},
			error : function(result) {
				$.messager.show({ title:'提示', msg:'执行失败', showType:'slide' });
			}
		});
		
		
	    
		initCarousel();

	});
  
    
    
    function initCarousel(width,height) {
    	var deskHeight = (document.documentElement.clientHeight || document.body.clientHeight);
    	var mainbody_h = $("#main").height();
    	var navbar_h = $("#navbar").height();
    	var footer_h = $("#footer").height();
    	var deskHeight = deskHeight - navbar_h - footer_h-120;
	    var deskWidth = (document.documentElement.clientWidth || document.body.clientWidth);
	    if(deskHeight==0){
	    	deskHeight =$(window).height()-120;                                                    ;
	    }
	    if(deskWidth==0){
	    	deskWidth =$(window).width()-260;
	    }
	    
	    if(!!height){
	    	deskHeight=height+deskHeight;
	    }
	    if(!!width){
	    	deskWidth=width+deskWidth;
	    }
        var fingerSwipe = false;
		if(navigator.userAgent.match(/Android/i)||(navigator.userAgent.indexOf('iPhone') != -1) || (navigator.userAgent.indexOf('iPod') != -1) || (navigator.userAgent.indexOf('iPad') != -1)) {
			fingerSwipe = true;
	    }
	    
	    
        $('#carousel').carousel({
        	width: deskWidth,
            height: deskHeight,
            itemWidth: deskWidth*0.4,
            itemHeight: deskHeight*0.45,
            horizontalRadius: deskWidth / 3, //水平半径
            verticalRadius: (deskHeight / 0.65) / 6, //垂直半径
            resize: false,
            mouseScroll: false, //鼠标滚动事件设置
            mouseDrag: false, //鼠标拖拽事件设置
            scaleRatio: 0.5, //图片前后比例设置
            scrollbar: true,//--下条
            mouseWheel: true, //鼠标滚轮是否生效
            mouseWheelReverse: false, //滚轮方向与工作圈旋转方向
            speed: 50000,
            tooltip:false,
            fingerSwipe : fingerSwipe
        });
        carousel_sortable();

    }
    
    function refreshCarousel(width,height) {
    	var deskHeight = (document.documentElement.clientHeight || document.body.clientHeight);
    	var mainbody_h = $("#main").height();
    	var navbar_h = $("#navbar").height();
    	var footer_h = $("#footer").height();
    	var deskHeight = deskHeight - navbar_h - footer_h;
    	var deskWidth = (document.documentElement.clientWidth || document.body.clientWidth);
	    if(deskHeight==0){
	    	deskHeight =$(window).height()-200;
	    }
	    if(deskWidth==0){
	    	deskWidth =$(window).width()-260;
	    }
	    if(!!height){
	    	deskHeight=height+deskHeight;
	    }
	    if(!!width){
	    	deskWidth=width+deskWidth;
	    }
	    
	    var fingerSwipe = false;
		if(navigator.userAgent.match(/Android/i)||(navigator.userAgent.indexOf('iPhone') != -1) || (navigator.userAgent.indexOf('iPod') != -1) || (navigator.userAgent.indexOf('iPad') != -1)) {
			fingerSwipe = true;
	    }
        $('#carousel').carouselRefresh({
        	width: deskWidth,
            height: deskHeight,
            itemWidth: deskWidth*0.4,
            itemHeight: deskHeight*0.45,
            horizontalRadius: deskWidth / 3, //水平半径
            verticalRadius: (deskHeight / 0.65) / 6, //垂直半径
            resize: false,
            mouseScroll: false, //鼠标滚动事件设置
            mouseDrag: false, //鼠标拖拽事件设置
            scaleRatio: 0.5, //图片前后比例设置
            scrollbar: true,//--下条
            mouseWheel: true, //鼠标滚轮是否生效
            mouseWheelReverse: false, //滚轮方向与工作圈旋转方向
            speed: 50000,
            tooltip:false,
            fingerSwipe : fingerSwipe
        });
        carousel_sortable();

    }

    /**
     * 截取字符串，当字符大于等于5个字符时，截取前4个字符并追加...
     * @param {String} 字符串
     * @returns {String} 截取后的字符串
     */
    function calStr(str) {
    	if (str.length >= 5) {
    		return str.substring(0, 4) + "..";
		}
		return str;
	} 