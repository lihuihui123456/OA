
function FormatModel(str, model) {
    for (var k in model) {
        var re = new RegExp("{" + k + "}", "g");
        str = str.replace(re, model[k]);
        if(k=='text'){
        	if(model[k]!=null){
        		if(model[k].length > 7){
        			var re = new RegExp("{name}", "g");
        	        str = str.replace(re, model[k].substring(0,7));
        		}else{
        			var re = new RegExp("{name}", "g");
        	        str = str.replace(re, model[k]);
        		}
        	}
        }
    }
    return str;
}

function   isIE(){ 
    if   (window.navigator.userAgent.toString().toLowerCase().indexOf("msie") >=1)
      return   true;
    else
      return   false;
}

function getheight() {
	if(!isIE()){
		return $("#mainbody").height()-$("#navbar").height()-$("#footer").height()-45+10;
	}else{
		return $("#mainbody").height()-$("#navbar").height()-$("#footer").height()-45+10;
	}   
}

function iframeheight(dheight) {
	if(dheight){
		$('.window-frame').css("height",(getheight()+dheight) + "px");
	}else{
		$('.window-frame').css("height",getheight() + "px");
	}
}
var Tabli ='<li window="{id}" pid="{pid}"><a href="#{id}" data-toggle="tab" title="{text}"><span class="{modIcon}"></span>&nbsp;{name}&nbsp;'+
 	'<i class="iconfont icon-close"  onmouseover="this.className=\'iconfont icon-close_s\'" onmouseout="this.className=\'iconfont icon-close\'" onclick="closeTab(this)"></i></a></li>';

var homeli ='<li window="home" pid="{pid}"><a href="#{id}" data-toggle="tab" title="{text}"><span class="{modIcon}"></span>&nbsp;{name} &nbsp;'+
	'</a></li>';

var Tabdiv =
	'<div id="{id}" pid="{pid}" style="box-sizing: border-box;top:{top}px;left:{left}px;width: 100%" class="tab-pane fade">' +
	    '<div id="window-frame_{id}">' +
	       '<iframe id="frame{id}" pid="{pid}" class="window-frame"  src="{href}"  style="position: relative;border: 0;height: {height}px; width: 100%;top: 0; bottom: 0;left: 0;right: 0;margin-bottom:-5px;" frameborder="0" ></iframe>' +
	    '</div>' +
    '</div>';



function createTabFromNav(obj) {
	var opt=$(obj).data("info");
	var isDelete = true;
	var isReturn = false;
	var isRefresh = true;
	if(opt.text=='即时通讯'){
		isDelete = false;
		isReturn = false;
		isRefresh = false;
	}
	var temp={
			"id":opt.id,
			"text":opt.text,
			"href":opt.href,
			"pid" :"home",
            "isDelete":isDelete,
			"isReturn":isReturn,
			"isRefresh":isRefresh,
			"modIcon" : opt.icon
	};
	var options = $.extend({}, obj , temp);
	$(obj).data("info",options);
	createTab(options);
};

function createHomeTab(opt) {
	var circleTask={
			"text":"融合桌面",
			"id": "home",
		    "pid":"home",
		    "modIcon" : "fa fa-home"
	};
	var temp = $.extend({}, circleTask,opt);
    var ct = $(FormatModel(homeli,temp));
    ct.addClass('active');
    $('#myTab').append(ct);
}


/**
 * 创建弹出页面
 
	var opt={
			"text"     :"",               //标签名称
			"id"       :"",               //标签ID
			"href"     :"",               //页面链接
			"pid"      :window,  		  //默认填写
		    "width"    : 300,             //页面宽度
            "height"   : 300,             //页面高度
            "top"      : 0,               //页面起始上坐标
            "left"     : 0,               //页面起始左坐标
            "zIndex"   : 0,               //页面层级
            "isDelete" :false,            //false为逻辑删除，当前页面缓存，true为物理删除，无缓存；默认为false
			"isReturn" :false,            //是否返回父页面，默认false不返回父页面
			"isRefresh":false,            //父页面是否刷新，默认false不刷新父页面
			"createFirst" :"false"        //指定的isDelete，isReturn，isRefresh参数使用优先级，fasle：closePage函数指定的参数优先使用  true：createTab函数指定的参数优先使用
	};

 */
function createTab(opt,flag) {
	if (opt.id == '8a8641285c43408f015c4356ec9f000b' 
		|| opt.id == '2c9ba3855c8ae2f1015c8b609e10000c'
		|| opt.id == '8a8648bf5d075412015d0b771dd00084'
		|| opt.id == '8a8648bf5d075412015d0b781c5e0085'
		|| opt.id == '8a8648bf5d075412015d0b78fec40086'
		|| opt.id == '8a8648bf5d075412015d0b79b2370087') {
		window.open(opt.href);
		return;
	}
	var top=0;
	var left=0;
    var height = getheight();
    var width = $("#main").width();
    var pid = 'home';
    var _pid=opt.pid;
    if(_pid != null && _pid != 'undefined' && _pid != undefined && _pid != ''){
    	if(!!_pid.frameElement){
    		//alert("create iframe")
    		pid = _pid.frameElement.id;
	    	if(pid != null && pid != 'undefined' && pid != undefined && _pid != ''){
	    		pid = pid.substring(5,pid.length);
	    	}
    	}else{
    		//alert("create not iframe");
    	}
    }
    opt.pid=pid;
    if(opt.modIcon != null && opt.modIcon != 'undefined' && opt.modIcon != undefined && opt.modIcon != ''){
    	opt.modIcon = "icon node-icon "+opt.modIcon;
    } else {
    	opt.modIcon = "icon node-icon iconfont icon-bookmark";
    }
	var defaults={
			"text":"新建选项卡",
			"id":-1,
			"href":"#",
			"pid":"home",
		    "width": width,
            "height": height,
            "top": top,
            "left": left,
            "zIndex": 0 ,
            "isDelete":true,
			"isReturn":false,
			"isRefresh":true,
			"modIcon" : "icon node-icon fa fa-file",
			"createFirst":false
	};
	var options = $.extend({}, defaults, opt);
    //判断窗口是否已打开
    var iswindowopen = 0;
    var isDivOpen = 0;
    $('#myTab li').each(function() {
        if ($(this).attr('window') == options.id) {
            iswindowopen = 1;
            $('#myTab a[href="#'+options.id+'"]').tab('show');
        }
    });
    if (iswindowopen == 0) {
        //新增任务栏
    	 var lio;
    	if('home'==options.id){
    		 lio = $(FormatModel(homeli, options));
    	}else{
    		 lio = $(FormatModel(Tabli, options));
    	}
       
    	lio.data("info",options);
        $('#myTab').append(lio);
        //新增窗口
        
        $('#myTabContent div').each(function() {
            if ($(this).attr('id') == options.id) {
            	isDivOpen = 1;
            }
        });
        if (isDivOpen == 0) {
        	var divo =  $(FormatModel(Tabdiv, options));
            $('#myTabContent').append(divo);
            divo.find("iframe")[0].contentWindow.info=options;
            divo.find("iframe")[0].info=options;
            var height = $("#myTabContent").height();
            divo.find("iframe")[0].height = height;
        }
        $('#myTab a[href="#'+options.id+'"]').tab('show');
        g(".my_tabs li.active");
        //快捷桌面页面初始有左侧，其余打开页面最大化,点击快捷桌面左侧内容显示，点击其他标签左侧内容隐藏
        if (_themeCode == 'shortcut' || _themeCode == 'leader') {
        	if(document.body.clientWidth <= 1024){
        		if('home'==options.id || "noticeLeader"== flag){
                	enlarge();
        	   	}else{
        	   		narrow();
        	   	}
                $("#myTab a").click(function(){
                	if($(this).attr("href")=="#home"){
                		enlarge();
                	}else{
                		narrow();
                	}
                });
        	}	
        }
    }
};

function closeTab(objimg){
	window.event? window.event.returnValue = false : e.preventDefault();
	var obj = $(objimg).parent().parent();
	var opt=$(obj).data("info");
	window.info=opt;
	closePage(opt,opt.isDelete,opt.isReturn,opt.isRefresh);
}

/**
 * currobj :默认写 window
 * isDelete:false为逻辑删除，当前页面缓存，true为物理删除，无缓存；默认为false
 * isReturn:是否返回父页面，默认false不返回父页面
 * isRefresh:父页面是否刷新，默认false不刷新父页面
 * isIFrame: 子页面IFrame Id 
 */
function closePage(currobj,isDelete,isReturn,isRefresh,isIFrame){
	var id = null;
	var pid= "home";
	var opt = null;
	
	if(!!currobj&&!!currobj.frameElement&&!!currobj.frameElement.id){
		opt=currobj.info
		if(opt == undefined || opt == 'undefined'){
			opt=currobj.parent.document.getElementById(currobj.frameElement.id).info; 
		}
	}else{
		opt = currobj;
	}
	id=opt.id
	if($('#myTab a[href="#'+opt.pid+'"]').length>0){
		pid=opt.pid;
	}
	
	if(opt.createFirst){
		isReturn = opt.isReturn;
		isRefresh = opt.isRefresh;
		isDelete = opt.isDelete;
	}else{
		if(isReturn == null || isReturn == 'undefined' || isReturn == undefined){
			isReturn = opt.isReturn;
		}
		if(isRefresh == null || isRefresh == 'undefined' || isRefresh == undefined){
			isRefresh = opt.isRefresh;
		}
		if(isDelete == null || isDelete == 'undefined' || isDelete == undefined){
			isDelete = opt.isDelete;
		}
	}
	

	
	
	
    if(isIFrame) {
    	var mainFrame = $("#frame"+pid).contents().find(isIFrame);
    	if(mainFrame!=null&mainFrame.length>0){
    		//add 2017 01 11
    		//先判断是否有iframe，
    		$("#frame"+pid).contents().find(isIFrame)[0].contentWindow.tableRefresh();
    	}else{
    		//如果没有直接按frameid查找，调取tableRefresh
    		$("#frame"+pid)[0].contentWindow.tableRefresh();
    	}
    }
	
	
	if(isReturn){
    	$('#myTab li[window="' + id + '"]').remove();
    	
    	if(isDelete){
    		$('#' + id).remove();
    	}
    	//alert($('#myTab a[href="#'+pid+'"]'));
    	$('#myTab a[href="#'+pid+'"]').tab('show');
    	
    	if(isRefresh){
    		var purl = $("#frame"+pid).attr('src');
    		var refreshUrl=purl;
    		if(purl.indexOf("?")>-1){
    			refreshUrl =purl+ "&_time="+new Date().getTime();
    		}else{
    			refreshUrl =purl+ "?_time="+new Date().getTime();
    		}
    		$("#frame"+pid).attr("src",refreshUrl);
    	}
    	return;
	}
	
	var obj = $('#myTab li[window="' + id + '"]');
    var no = obj.next('li');
    var po = obj.prev('li');
    $('#myTab li[window="' + id + '"]').remove();
    
	if(isDelete){
		$('#' + id).remove();
	}
    
    if ($('#myTab li').length == 1) {
    	$('#myTab a:first').tab('show') ;
    } else {
        $('#myTab li').removeClass('active');

        if (no != null && no.attr('window') != undefined 
        		&& no.attr('window') != 'undefined' && no.attr('window') != '') {
        	
        	id = no.attr('window');

            $('#myTab a[href="#'+id+'"]').tab('show');
        } else {
        	id = po.attr('window');

        	$('#myTab a[href="#'+id+'"]').tab('show');
        }
    }
}

/**
 * currobj :默认写 window
 * isDelete:false为逻辑删除，当前页面缓存，true为物理删除，无缓存；默认为false
 * isReturn:是否返回父页面，默认false不返回父页面
 * isRefresh:父页面是否刷新，默认false不刷新父页面
 * isIFrame:0 无iframe，1 有iframe
 */
function closePage1(currobj,isDelete,isReturn,isRefresh,isIFrame){
	var _id = currobj.frameElement.id;
	var id = null;
	if(_id != null && _id != 'undefined' && _id != ''
		&& _id != undefined){
		id = _id.substring(5,_id.length);
	}
	
	var pid = $.trim($("#"+_id).attr("pid"));
    if(pid=="fusiondesktop"){
    	$("#desk").show();
    }
    if(isIFrame=='1') {
    	var mainFrame = $("#frame"+pid).contents().find("#main_iframe");
    	if(mainFrame!=null&mainFrame.length>0){
    		//add 2017 01 11
    		//先判断是否有iframe，
    		$("#frame"+pid).contents().find("#main_iframe")[0].contentWindow.tableRefresh();
    	}else{
    		//如果没有直接按frameid查找，调取tableRefresh
    		$("#frame"+pid)[0].contentWindow.tableRefresh();
    	}
    }
    
	var param = eval( "(" + $("#"+_id).attr("param")+ ")" ) ;
	
	if(isDelete == null || isDelete == 'undefined' || isDelete == undefined){
		isDelete = param.isDelete;
	}
	if(isReturn == null || isReturn == 'undefined' || isReturn == undefined){
		isReturn = param.isReturn;
	}
	if(isRefresh == null || isRefresh == 'undefined' || isRefresh == undefined){
		isRefresh = param.isRefresh;
	}
	
	if(isReturn){
    	$('#myTab li[window="' + id + '"]').remove();
    	if(isDelete){
    		$('#' + id).remove();
    	}
    	id = pid;
    	$('#myTab a[href="#'+id+'"]').tab('show');
    	if(isRefresh){
    		$("#frame"+id).attr("src",$("#frame"+id).attr('src'));
    	}
    	return;
	}
	
	var obj = $('#myTab li[window="' + id + '"]');
    var no = obj.next('li');
    var po = obj.prev('li');
    $('#myTab li[window="' + id + '"]').remove();
    
	if(isDelete){
		$('#' + id).remove();
	}
    
    if ($('#myTab li').length == 1) {
    	$('#myTab a:first').tab('show') ;
    } else {
        $('#myTab li').removeClass('active');

        if (no != null && no.attr('window') != undefined 
        		&& no.attr('window') != 'undefined' && no.attr('window') != '') {
        	
        	id = no.attr('window');

            $('#myTab a[href="#'+id+'"]').tab('show');
        } else {
        	id = po.attr('window');

        	$('#myTab a[href="#'+id+'"]').tab('show');
        }
    }
}

function f(l) {
    var k = 0;
    $(l).each(function() {
        k += $(this).outerWidth(true)
    });
    return k
}
function g(n) {
    var o = f($(n).prevAll()), q = f($(n).nextAll());
    //var l = f($(".content-tabs").children().not(".page-tabs"));
    var l = $(".blank-white").outerWidth(true) + $(".tab-right").outerWidth(true) +$(".roll-right").outerWidth(true);
    var k = $(".content-tabs").outerWidth(true) - l;
    var p = 0;
    if ($(".page-tabs-content").outerWidth() < k) {
        p = 0
    } else {
        if (q <= (k - $(n).outerWidth(true) - $(n).next().outerWidth(true))) {
            if ((k - $(n).next().outerWidth(true)) > q) {
                p = o;
                var m = n;
                while ((p - $(m).outerWidth()) > ($(".page-tabs-content").outerWidth() - k)) {
                    p -= $(m).prev().outerWidth();
                    m = $(m).prev()
                }
            }
        } else {
            if (o > (k - $(n).outerWidth(true) - $(n).prev().outerWidth(true))) {
                p = o - $(n).prev().outerWidth(true)
            }
        }
    }
    $(".page-tabs-content").animate({marginLeft: 0 - p + "px"}, "fast")
}
function a() {
    var o = Math.abs(parseInt($(".page-tabs-content").css("margin-left")));
    //var l = f($(".content-tabs").children().not(".page-tabs"));
    var l = $(".blank-white").outerWidth(true) + $(".tab-right").outerWidth(true) +$(".roll-right").outerWidth(true);
    var k = $(".content-tabs").outerWidth(true) - l;
    var p = 0;
    if ($(".page-tabs-content").width() < k) {
        return false
    } else {
        var m = $(".my_tabs li:first");
        var n = 0;
        while ((n + $(m).outerWidth(true)) <= o) {
            n += $(m).outerWidth(true);
            m = $(m).next()
        }
        n = 0;
        if (f($(m).prevAll()) > k) {
            while ((n + $(m).outerWidth(true)) < (k) && m.length > 0) {
                n += $(m).outerWidth(true);
                m = $(m).prev()
            }
            p = f($(m).prevAll())
        }
    }
    $(".page-tabs-content").animate({marginLeft: 0 - p + "px"}, "fast")
}
function b() {
    var o = Math.abs(parseInt($(".page-tabs-content").css("margin-left")));
    //var l = f($(".content-tabs").children().not(".page-tabs"))-60;
    var l = $(".blank-white").outerWidth(true) + $(".tab-right").outerWidth(true) +$(".roll-right").outerWidth(true);
    var k = $(".content-tabs").outerWidth(true) - l;
    var p = 0;
    if ($(".page-tabs-content").width() < k) {
        return false
    } else {
        var m = $(".my_tabs li:first");
        var n = 0;
        while ((n + $(m).outerWidth(true)) <= o) {
            n += $(m).outerWidth(true);
            m = $(m).next()
        }
        n = 0;
        while ((n + $(m).outerWidth(true)) < (k) && m.length > 0) {
            n += $(m).outerWidth(true);
            m = $(m).next()
        }
        p = f($(m).prevAll());
        if (p > 0) {
            $(".page-tabs-content").animate({marginLeft: 0 - p + "px"}, "fast");
        }
        
    }
}
function i() {
    $(".page-tabs-content").children("li").not(":first").not(".active").each(function() {
    	$('#window-frame_' + $(this).attr("window") + '').parent().remove();
        $(this).remove()
    });
    $(".page-tabs-content").css("margin-left", "0");
}

function j() {
    g($(".my_tabs li.active"));
}

function k(){
	$(".page-tabs-content").children("li").not(":first").each(function() {
        $('#window-frame_' + $(this).attr("window") + '').parent().remove();
        $(this).remove();
    });
    $(".page-tabs-content").children("li:first").each(function() {
        $('#window-frame_home').parent().addClass("active");
        $(this).addClass("active");
    });
    $(".page-tabs-content").css("margin-left", "0");
}

function tabClose(){
	if($(this).next().css("display")=="none"){
		$(this).next().css("display","block");
	}else{
		$(this).next().css("display","none");
	}
	$("#tab-close-list li").click(function(){
		$(this).parent().hide();
	});
	stopPropagation();
}

function tabCloseActive() {
	$(".page-tabs-content").children("li").not(":first").each(function(index) {
    	if($(this).hasClass("active")){
    		 $('#window-frame_' + $(this).attr("window") + '').parent().remove();
    	     $(this).remove();
    	     $('#window-frame_' + $(".page-tabs-content").children("li").eq(index).attr("window") + '').parent().addClass("active");
    	     $(".page-tabs-content").children("li").eq(index).addClass("active");
    	}
    });
    $(".page-tabs-content").css("margin-left", "0");
}

//g(".page-tabs-content");
$(".tab-left").on("click", a);
$(".tab-right").on("click", b);
$(".tabCloseOther").on("click", i);
$(".tabShowActive").on("click", j);
$(".tabCloseAll").on("click", k);
$(".tabCloseActive").on("click", tabCloseActive);
$(".tab-close").on("click",tabClose);
function stopPropagation(event){
    event = event || window.event ;
    if(event.stopPropagation){
        event.stopPropagation();
     }else{
          event.cancelBubble = true;
     }
}