function start(){
    var scripts = document.getElementsByTagName("script");
    var jsFolder = "";
    for (var i= 0; i< scripts.length; i++)
    {
        if( scripts[i].src && scripts[i].src.match(/lovelygallery\.js/i))
            jsFolder = scripts[i].src.substr(0, scripts[i].src.lastIndexOf("/") + 1);
    }
    //动态获取父iframe的宽高
    var iframeHeight;
    var iframewidth;
    if(parent.document.getElementById("newsPicsFrame")!=null){
    	iframeHeight = parent.document.getElementById("newsPicsFrame").height;
    	iframewidth = parent.document.getElementById("newsPicsFrame").width;
    }else{
    	iframeHeight = 400;
    	iframewidth = 400;
    }
    //根据父iframe的宽高计算图片的大小
    var photoHeight = 0;
    var phptoWidth = 0;
    if((iframeHeight-100)>0){
    	//因为底框有padding 5px所以高度减10
    	photoHeight = iframeHeight-10;
    	//因为底框有padding 5px所以宽度减10
    	phptoWidth = iframewidth-10;
    }
    jQuery("#html5zoo-1").html5zoo({
        jsfolder:jsFolder,
        //图片的大小
        width:phptoWidth,
        height:photoHeight,
        skinsfoldername:"",
        loadimageondemand:false,
        isresponsive:false,
        autoplayvideo:false,
        pauseonmouseover:true,
        addmargin:true,
        randomplay:false,
        //图片滑入间隔
        slideinterval:10000,
        //触摸滑动
        enabletouchswipe:true,
        //载入时是否显示第一张幻灯片
        transitiononfirstslide:false,
        //循环播放次数，0为循环播放
        loop:0,
        //是否自动播放
        autoplay:true,
        navplayvideoimage:"images3/bg/play-32-32-0.png",
        navpreviewheight:60,
        //下面时间进度条高度
        timerheight:2,
        //在标题前添加数字显示
        shownumbering:true,
        skin:"Frontpage",
        addgooglefonts:true,
        //是否停止轮播按钮展示（图片路径要设置）
        navshowplaypause:false,
        //是否开始轮播按钮展示（图片路径要设置）
        navshowplayvideo:true,
        navshowplaypausestandalonemarginx:8,
        navshowplaypausestandalonemarginy:8,
        navbuttonradius:0,
        navthumbnavigationarrowimageheight:32,
        //导航栏margin高
        navmarginy:10,
        showshadow:false,
        navfeaturedarrowimagewidth:16,
        navpreviewwidth:120,
        googlefonts:"Inder",
        textpositionmarginright:24,
        bordercolor:"#ffffff",
        navthumbnavigationarrowimagewidth:32,
        navthumbtitlehovercss:"text-decoration:underline;",
        navcolor:"#999999",
        arrowwidth:48,
        texteffecteasing:"easeOutCubic",
        texteffect:"fade",
        //导航按钮间隔
        navspacing:12,
        playvideoimage:"images3/bg/playvideo-64-64-0.png",
        ribbonimage:"images3/bg/ribbon_topleft-0.png",
        navwidth:24,
        showribbon:false,
        arrowimage:"images3/bg/arrows-48-48-3.png",
        timeropacity:0.6,
        navthumbnavigationarrowimage:"/images3/bg/carouselarrows-32-32-0.png",
        navshowplaypausestandalone:false,
        navpreviewbordercolor:"#ffffff",
        ribbonposition:"topleft",
        navthumbdescriptioncss:"display:block;position:relative;padding:2px 4px;text-align:left;font:normal 12px Arial,Helvetica,sans-serif;color:#333;",
        arrowstyle:"mouseover",
        navthumbtitleheight:20,
        textpositionmargintop:24,
        navswitchonmouseover:false,
//        navarrowimage:"../../images3/bg/navarrows-28-28-0.png",
        //方向按钮高度 变成top 按百分比计算
        arrowtop:38,
        textstyle:"static",
        playvideoimageheight:64,
        navfonthighlightcolor:"#666666",
        showbackgroundimage:false,
        navpreviewborder:4,
        navopacity:0.8,
        shadowcolor:"#aaaaaa",
        navbuttonshowbgimage:true,
//      navbuttonbgimage:"../../images3/bg/navbuttonbgimage-28-28-0.png",
        //标题背景css
        textbgcss:"display:block; position:absolute; top:0px; left:0px; width:100%; height:100%; background-color:#333333; opacity:0.6; filter:alpha(opacity=60);",
        navdirection:"horizontal",
        navborder:4,
        bottomshadowimagewidth:110,
        showtimer:true,
        navradius:0,
        navshowpreview:false,
        navpreviewarrowheight:8,
        navmarginx:16,
//        navfeaturedarrowimage:"images3/bg/featuredarrow-16-8-0.png",
        navfeaturedarrowimageheight:8,
        navstyle:"bullets",
        textpositionmarginleft:24,
        descriptioncss:"display:block; position:relative; margin-top:4px; font:14px Inder,Arial,Tahoma,Helvetica,sans-serif; color:#fff;",
//      navplaypauseimage:"../../images3/bg/navplaypause-28-28-0.png",
        backgroundimagetop:-10,
        timercolor:"#ffffff",
        numberingformat:"%NUM/%TOTAL ",
        navfontsize:12,
        navhighlightcolor:"#333333",
        //导航按钮图片
        navimage:"images3/bg/bullet-24-24-4.png",
        //导航按钮高度,高度为0时，nav按钮被覆盖住了
        //navheight:24,
        navheight:0,
        navshowplaypausestandaloneautohide:false,
        navbuttoncolor:"",
        //展示图片下面点状图的方向箭头
        navshowarrow:false,
        navshowfeaturedarrow:false,
        titlecss:"display:block; position:relative; font:16px Inder,Arial,Tahoma,Helvetica,sans-serif; color:#fff;",
        ribbonimagey:0,
        ribbonimagex:0,
        navshowplaypausestandaloneposition:"bottomright",
        shadowsize:5,
        arrowhideonmouseleave:1100,
        navshowplaypausestandalonewidth:28,
        navshowplaypausestandaloneheight:28,
        backgroundimagewidth:20,
        //标题字体是否隐藏
						        textautohide : false,
        navthumbtitlewidth:20,
        navpreviewposition:"top",
        playvideoimagewidth:64,
        arrowheight:48,
        arrowmargin:0,
        texteffectduration:1100,
        bottomshadowimage:"images3/bg/bottomshadow-110-100-5.png",
        border:0,
        timerposition:"bottom",
        navfontcolor:"#333333",
        navthumbnavigationstyle:"arrow",
        borderradius:0,
        navbuttonhighlightcolor:"",
        //标题字体的位置
        textpositionstatic:"bottom",
        navthumbstyle:"imageonly",
        textcss:"display:block; padding:12px; text-align:left;",
        navbordercolor:"#ffffff",
        navpreviewarrowimage:"/images3/bg/previewarrow-16-8-0.png",
        showbottomshadow:true,
        //标题字体的margin-${textpositionstatic} 数值
        textpositionmarginstatic:0,
        backgroundimage:"",
        navposition:"bottom",
        navpreviewarrowwidth:16,
        bottomshadowimagetop:150,
        textpositiondynamic:"bottomleft",
        navshowbuttons:true,
        navthumbtitlecss:"display:block;position:relative;padding:2px 4px;text-align:left;font:bold 14px Arial,Helvetica,sans-serif;color:#333;",
        textpositionmarginbottom:24,
        ribbonmarginy:0,
        ribbonmarginx:0,
        slide: {
            duration:1100,
            easing:"easeOutCubic",
            checked:true
        },
        crossfade: {
            duration:1100,
            easing:"easeOutCubic",
            checked:true
        },
        threedhorizontal: {
            checked:true,
            bgcolor:"#222222",
            perspective:1100,
            slicecount:1,
            duration:1500,
            easing:"easeOutCubic",
            fallback:"slice",
            scatter:5,
            perspectiveorigin:"bottom"
        },
        slice: {
            duration:1500,
            easing:"easeOutCubic",
            checked:true,
            effects:"up,down,updown",
            slicecount:10
        },
        fade: {
            duration:1100,
            easing:"easeOutCubic",
            checked:true
        },
        blocks: {
            columncount:5,
            checked:true,
            rowcount:5,
            effects:"topleft,bottomright,top,bottom,random",
            duration:1500,
            easing:"easeOutCubic"
        },
        blinds: {
            duration:2000,
            easing:"easeOutCubic",
            checked:true,
            slicecount:3
        },
        shuffle: {
            duration:1500,
            easing:"easeOutCubic",
            columncount:5,
            checked:true,
            rowcount:5
        },
        threed: {
            checked:true,
            bgcolor:"#222222",
            perspective:1100,
            slicecount:5,
            duration:1500,
            easing:"easeOutCubic",
            fallback:"slice",
            scatter:5,
            perspectiveorigin:"right"
        },
        transition:"slide"
    });
}