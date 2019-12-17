var main = (function(){
	//查询：点击查询图标，出现查询框，查询图标隐藏；查询框出现时，点击任意地方，查询框消失，查询图标出现
	var searchToggle = function(){
		var input = $("#search-input > input");
		//点击搜索图标，出现搜索框
		$(".search > i").click(function(){
			$("#search-input").show();
			input.focus();
	        $(this).css("opacity","0.1");
	        $(".dropdown-menu").hide();
	        stopPropagation();
		});
		//搜索框内点击输入文字，搜索框不消失
		$("#search-input").click(function(){
			stopPropagation();
		}); 

		//搜索框输入内容，键盘回车键操作
		$("#search-input > input").keydown(function(event){
			var parm = input.val();
			if(parm=="请输入搜索内容"||parm==""){
				return;
			}
		    event=document.all?window.event:event;
		    if((event.keyCode || event.which)==13){
		    	var url = "luceneController/searchIndex?page=1&indextype=0&sk="+parm;
		    	var options={
						"text":"大数据全文检索",
						"id":"home_search1",
						"href":url,
						"pid":window,
						"isDelete":true,
						"isReturn":true,
						"isRefresh":true,
				};
				createTab(options);

				// 清空搜索框值并隐藏 add by 徐真 2016-12-16
				$("#search-input > input").val('');
				$("#search-input").hide();
				$(".search > i").css("opacity","1");
		    }
		});	
	};
	//鼠标点击任意地方，弹出浮层部分都消失
	document.onclick = function(){
		$("#search-input").hide();
	    $(".search > i").css("opacity","1");
	    //$(".dropdown-menu").hide();
	}
	
	$("#myTabContent").click(function(){
		$(".dropdown-menu").hide();
	});
	
	//帐号信息相关操作
	var tog = function(){
		$("#accountInfo").click(function(){
			$(this).children(".dropdown-menu").toggle();
			$("#search-input").hide();
			$(".search > i").css("opacity","1");
			$(this).siblings().children(".dropdown-menu").hide();
			stopPropagation();
		});
		$("#accountInfo > ul").click(function(){
			stopPropagation();
		});
		$("#accountInfo li").click(function(){
			$(this).parent().slideUp();
		});
		
		//document.onclick = function(){
			//$(".dropdown-menu").hide();
		//}
	};
	//即时消息相关操作
	var message = function(){
		$("#instantmessage").click(function(){
			$(this).children(".dropdown-menu").toggle();
			$("#search-input").hide();
			$(".search > i").css("opacity","1");
			$(this).siblings().children(".dropdown-menu").hide();
			stopPropagation();
		});
		
		$("#instantmessage > ul").click(function(){
			stopPropagation();
		});
		$("#msgs_display_board").css("top","65px");
		//document.onclick = function(){
			//$(".dropdown-menu").hide();
		//}
	};
	
    //阻止事件冒泡
    var stopPropagation = function(event){
        event = event || window.event ;
        if(event.stopPropagation){
            event.stopPropagation();
         }else{
              event.cancelBubble = true;
         }
    }
    var tabMenu = function(){
    	$("#myTab li a").click(function(){
    		var a = $(this).parent().hasClass("active").index();
    		alert(a);
    	});
    	
    }
    var calendarHeight = function(){
        $("#calendarPanel").height($("#todoPanel").height());        
    }
    var pageCount = function(){
        $(".page_count > a").hover(function(){
            $(this).addClass("active");
            if($(this).hasClass('disabled')){
                $(this).removeClass("active");
            }
        },function(){
            $(this).removeClass("active");
        });
    }
    var loading = function(){
        $(".loading").animate({
            "width":"100%"
        },1000).hide("fast");
    }
    return {
        init:function(){
            loading();
            
        },
        toggle:function(){
            searchToggle();
            //tabMenu();
            tog();
            message();
           
        },
        heightP:function(){
            calendarHeight();
        },
        pageCount:function(){
            pageCount();
        }
    }
})();
main.init();
main.toggle();
//main.heightP();
main.pageCount();

/**
 * 全文检索按钮点击查询
 */
function btnSearch() {
	var input = $("#search-input > input");
	var parm = input.val();
	if(parm=="请输入搜索内容"||parm==""){
		return;
	}
	var url = "luceneController/searchIndex?page=1&indextype=0&sk="+parm;
	var options={
			"text":"大数据全文检索",
			"id":"home_search1",
			"href":url,
			"pid":window,
			"isDelete":true,
			"isReturn":true,
			"isRefresh":true,
	};
	createTab(options);

	// 清空搜索框值并隐藏 add by 徐真 2016-12-16
	$("#search-input > input").val('');
	$("#search-input").hide();
	$(".search > i").css("opacity","1");
}