function handleSaveLayout() {
    var e = $(".demo").html();
    if (e != window.demoHtml) {
        //saveLayout();
        window.demoHtml = e
    }
}
function handleJsIds() {
    handleModalIds();
    handleAccordionIds();
    handleCarouselIds();
    handleTabsIds()
}
function handleAccordionIds() {
    var e = $(".demo #myAccordion");
    var t = randomNumber();
    var n = "panel-" + t;
    var r;
    e.attr("id", n);
    e.find(".panel").each(function(e, t) {
        r = "panel-element-" + randomNumber();
        $(t).find(".panel-title").each(function(e, t) {
            $(t).attr("data-parent", "#" + n);
            $(t).attr("href", "#" + r)
        }
        );
        $(t).find(".panel-collapse").each(function(e, t) {
            $(t).attr("id", r)
        }
        )
    }
    )
}
function handleCarouselIds() {
    var e = $(".demo #myCarousel");
    var t = randomNumber();
    var n = "carousel-" + t;
    e.attr("id", n);
    e.find(".carousel-indicators li").each(function(e, t) {
        $(t).attr("data-target", "#" + n)
    }
    );
    e.find(".left").attr("href", "#" + n);
    e.find(".right").attr("href", "#" + n)
}
function handleModalIds() {
    var e = $(".demo #myModalLink");
    var t = randomNumber();
    var n = "modal-container-" + t;
    var r = "modal-" + t;
    e.attr("id", r);
    e.attr("href", "#" + n);
    e.next().attr("id", n)
}
function handleTabsIds() {
    var e = $(".demo #myTabs");
    var t = randomNumber();
    var n = "tabs-" + t;
    e.attr("id", n);
    e.find(".tab-pane").each(function(e, t) {
        var n = $(t).attr("id");
        var r = "panel-" + randomNumber();
        $(t).attr("id", r);
        $(t).parent().parent().find("a[href=#" + n + "]").attr("href", "#" + r)
    }
    )
}
function randomNumber() {
    return randomFromInterval(1, 1e6)
}
function randomFromInterval(e, t) {
    return Math.floor(Math.random() * (t - e + 1) + e)
}
function gridSystemGenerator() {
    $(".lyrow .preview input").bind("keyup", function() {
        var e = 0;
        var t = "";
        var n = false;
        var r = $(this).val().split(" ", 12);
        $.each(r, function(r, i) {
            if (!n) {
                if (parseInt(i) <= 0)
                    n = true;
                e = e + parseInt(i);
                t += '<div class="col-md-' + i + ' column"></div>'
            }
        }
        );
        if (e == 12 && !n) {
            $(this).parent().next().children().html(t);
            $(this).parent().prev().show()
        } else {
            $(this).parent().prev().hide()
        }
    }
    )
}
function configurationElm(e, t) {
    $(".demo").delegate(".configuration > a", "click", function(e) {
        e.preventDefault();
        var t = $(this).parent().next().next().children();
        $(this).toggleClass("active");
        t.toggleClass($(this).attr("rel"))
    }
    );
    $(".demo").delegate(".configuration .dropdown-menu a", "click", function(e) {
        e.preventDefault();
        var t = $(this).parent().parent();
        var n = t.parent().parent().next().next().children();
        t.find("li").removeClass("active");
        $(this).parent().addClass("active");
        var r = "";
        t.find("a").each(function() {
            r += $(this).attr("rel") + " "
        }
        );
        t.parent().removeClass("open");
        n.removeClass(r);
        n.addClass($(this).attr("rel"))
    }
    )
}
function removeElm() {
    $(".demo").delegate(".remove", "click", function(e) {
        e.preventDefault();
        $(this).parent().remove();
        if (!$(".demo .lyrow").length > 0) {
            clearDemo()
        }
    }
    )
}

/**
 * 清空布局
 */
function clearDemo() {
	layer.msg("清空当前布局，系统将使用默认布局");
	$(".demo").empty();	
	/*layer.confirm('清空当前布局，系统将使用默认布局，确定吗？', {
		btn: ['确定','取消'] //按钮
	}, function() {
		$(".demo").empty();	
	}, function(){
		return;
	});*/
}

function removeMenuClasses() {
    $("#menu-layoutit li button").removeClass("active")
}
function changeStructure(e, t) {
    $("#download-layout ." + e).removeClass(e).addClass(t)
}
function cleanHtml(e) {
    $(e).parent().append($(e).children().html())
}
function downloadLayoutSrc() {
    var e = "";
    $("#download-layout").children().html($(".demo").html());
    var t = $("#download-layout").children();
    t.find(".preview, .configuration, .drag, .remove").remove();
    t.find(".lyrow").addClass("removeClean");
    t.find(".box-element").addClass("removeClean");
    t.find(".lyrow .lyrow .lyrow .lyrow .lyrow .removeClean").each(function() {
        cleanHtml(this)
    }
    );
    t.find(".lyrow .lyrow .lyrow .lyrow .removeClean").each(function() {
        cleanHtml(this)
    }
    );
    t.find(".lyrow .lyrow .lyrow .removeClean").each(function() {
        cleanHtml(this)
    }
    );
    t.find(".lyrow .lyrow .removeClean").each(function() {
        cleanHtml(this)
    }
    );
    t.find(".lyrow .removeClean").each(function() {
        cleanHtml(this)
    }
    );
    t.find(".removeClean").each(function() {
        cleanHtml(this)
    }
    );
    t.find(".removeClean").remove();
    $("#download-layout .column").removeClass("ui-sortable");
    t.find(".column").removeClass("column");
    $("#download-layout .row-fluid").removeClass("clearfix").children().removeClass("column");
    if ($("#download-layout .container").length > 0) {
        changeStructure("row-fluid", "row")
    }
    formatSrc = $("#download-layout").html();
    $("#downloadModal textarea").empty();
    $("#downloadModal textarea").val(formatSrc);
    return formatSrc;
}
var currentDocument = null ;
var timerSave = 2e3;
var demoHtml = $(".demo").html();
$(window).resize(function() {
    $("body").css("min-height", $(window).height() - 90);
    $(".demo").css("min-height", $(window).height() - 160)
}
);
$(document).ready(function() {
    $("body").css("min-height", $(window).height() - 90);
    $(".demo").css("min-height", $(window).height() - 160);
    $(".demo, .demo .column").sortable({
        connectWith: ".column",
        opacity: .35,
        handle: ".drag"
    });
    $(".sidebar-nav .lyrow").draggable({
        connectToSortable: ".demo",
        helper: "clone",
        handle: ".drag",
        drag: function(e, t) {
            t.helper.width(400)
        },
        stop: function(e, t) {
            $(".demo .column").sortable({
                opacity: .35,
                connectWith: ".column"
            })
        }
    });
    $(".sidebar-nav .box").draggable({
        connectToSortable: ".column",
        helper: "clone",
        handle: ".drag",
        drag: function(e, t) {
            t.helper.width(400)
        },
        stop: function() {
            handleJsIds()
        }
    });
    $("[data-target=#downloadModal]").click(function(e) {
        e.preventDefault();
        downloadLayoutSrc()
    }
    );
    $("#download").click(function() {
        downloadLayout();
        return false
    }
    );
    $("#downloadhtml").click(function() {
        downloadHtmlLayout();
        return false
    }
    );
    $("#edit").click(function() {
        $("body").removeClass("devpreview sourcepreview");
        $("body").addClass("edit");
        removeMenuClasses();
        $(this).addClass("active");
        return false
    }
    );
    $("#clear").click(function(e) {
        e.preventDefault();
        clearDemo()
    }
    );
    $("#devpreview").click(function() {
        $("body").removeClass("edit sourcepreview");
        $("body").addClass("devpreview");
        removeMenuClasses();
        $(this).addClass("active");
        return false
    }
    );
    $("#sourcepreview").click(function() {
        $("body").removeClass("edit");
        $("body").addClass("devpreview sourcepreview");
        removeMenuClasses();
        $(this).addClass("active");
        return false
    }
    );
    $(".nav-header").click(function() {
        $(".sidebar-nav .boxes, .sidebar-nav .rows").show();
        //$(this).next().slideDown()
    }
    );
    removeElm();
    configurationElm();
    gridSystemGenerator();
    setInterval(function() {
        handleSaveLayout()
    }
    , timerSave)
}
)

/**
 * 用户保存布局确认
 */
function saveConfirm(){
	var content = $(".demo").html();
	var vcontent = downloadLayoutSrc();

	// 如果用户没有布局，则提示用户使用默认布局
	if (vcontent.indexOf("row clearfix") < 0 || vcontent.indexOf("iframe") < 0) {
		saveLayout();
		
		/*layer.confirm('您没有设置任何布局，将使用默认布局，确定吗？', {
			btn: ['确定','取消'] //按钮
		}, function() {
			saveLayout();
		}, function(){
			return;
		});*/
	} else {
		saveLayout();
	}
}

/**
 * 保存用户个人桌面布局
 */
function saveLayout() {
	var content = $(".demo").html();
	var vcontent = downloadLayoutSrc();

	$.ajax({
		url : ctx+'/themeController/doSaveLayout',
		type : 'post',
		dataType : 'text',
		data : {
			content : content,
			vcontent : vcontent
		},
		success : function(data) {
			if (data != null && data != '') {
				/*layer.alert('保存成功!', function(){
					//window.opener.location.reload();
					
		        });*/
				
				layer.msg("布局已保存!");
				
				//window.parent.parent.btnClick();
				//window.parent.closePage(window,true,true,true);
				
				
			} else {
				layer.msg("保存失败!");
			}
		}
	});
}

/**
 * 返回首页
 */
function doReturn(){
	//window.parent.parent.btnClick();
	window.parent.closePage(window,true,true,true);
}