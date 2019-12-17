/**
 * 全局变量
 * @author wangjiankun
 * @since 2017-05-11
 * */
var tabLi = "<li><a href=\"#home\" contenteditable=\"true\" data-toggle=\"tab\">标题</a></li>";//标签页中li元素
var tabPanel = "<div class='tab-pane' id='home'>"//标签页中panel元素
				+  	"<div class='box box-element ui-draggable'>"
				+  		"<a href='#close' class='remove label label-important'>"
				+  			"<i class='icon-remove icon-white'></i>删除"
				+  		"</a>"
				+		"<span class='drag label'><i class='icon-move'></i>拖动</span>"
				+		"<span class='configuration'>"
				+			"<button type='button' class='btn btn-mini' data-target='#editorModal' role='button' data-toggle='modal'>编辑</button>"
				+		"</span>"
				+		"<div class='preview'>内容</div>"
				+		"<div class='view'>"
				+			"<table border='1' cellpadding='1' cellspacing='1' style='width:100%;background-color:#ffffff;'>"
				+				"<tr><td class='column'></td></tr>"
				+			"</table>"
				+		"</div>"
				+	"</div>"
				+  "</div>  ";

$(document).ready(function() {
	getControlData();
	reloadContent();
	$('#editorModal').modal({
		show : false,
		backdrop : 'static',
		keyboard : false
	});

	CKEDITOR.disableAutoInline = true;
	/* restoreData(); */
	//定义ckeditor编辑器
	var contenthandle = CKEDITOR.replace('contenteditor',
					{
						language : 'zh-cn',
						contentsCss : [ '../views/cap/form/css/bootstrap-combined.min.css' ],
						allowedContent : true,
						toolbar :
							[
								{ name: 'document', items : [ 'Source','-','Save','NewPage','DocProps','Preview','Print','-','Templates' ] },
								{ name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
								{ name: 'editing', items : [ 'Find','Replace','-','SelectAll','-','SpellChecker', 'Scayt' ] },
								{ name: 'forms', items : [ 'Form', 'Checkbox', 'Radio', 'TextField', 'Textarea', 'Select', 'Button', 'ImageButton', 
							        'HiddenField' ] },
								'/',
								{ name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
								{ name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv',
								'-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
								{ name: 'links', items : [ 'Link','Unlink','Anchor' ] },
								{ name: 'insert', items : [ 'Image','Flash','Table','HorizontalRule','Smiley','SpecialChar','PageBreak','Iframe' ] },
								'/',
								{ name: 'styles', items : [ 'Styles','Format','Font','FontSize' ] },
								{ name: 'colors', items : [ 'TextColor','BGColor' ] },
								{ name: 'tools', items : [ 'Maximize', 'ShowBlocks','-','About' ] }
							]
						//extraPlugins : 'close' //toolbar属性要加‘close’
					});
	$("body").css("min-height", $(window).height() - 90);
	$(".demo").css("min-height", $(window).height() - 160);
	$(".sidebar-nav .lyrow").draggable({
		connectToSortable : ".demo",
		helper : "clone",
		handle : ".drag",
		start : function(e, t) {
			if (!startdrag)
				stopsave++;
			startdrag = 1;
		},
		drag : function(e, t) {
			t.helper.width(400)
		},
		stop : function(e, t) {
			$(".demo .column").sortable({
				opacity : .35,
				connectWith : ".column",
				start : function(e, t) {
					if (!startdrag)
						stopsave++;
					startdrag = 1;
				},
				stop : function(e, t) {
					if (stopsave > 0)
						stopsave--;
					startdrag = 0;
				}
			});
			if (stopsave > 0)
				stopsave--;
			startdrag = 0;
		}
	});
	$(".sidebar-nav .box").draggable({
		connectToSortable : ".column",
		helper : "clone",
		handle : ".drag",
		start : function(e, t) {//t.helper为拖拽的jquery对象
			if (!startdrag)
				stopsave++;
			startdrag = 1;
		},
		drag : function(e, t) {
			t.helper.width(400)
		},
		stop : function(e,t) {
			if ($(t.helper).find("#myTabs").html() != null && $(t.helper).find("#myTabs").html() != undefined) {
				var tabPageCount = $("#tabPageCount").val();
				for (var i = 0; i < tabPageCount; i++) {
					var li = $(tabLi).appendTo($(".demo #myTabs_ul"));
					$(li).children().eq(0).attr("href","#home"+i);
					var panel = $(tabPanel).appendTo($(".demo #mytabs_panel"));
					$(panel).attr("id","home"+i);
				}
				handleTabsIds();
				$(".demo #myTabs_ul").children().eq(0).addClass("active");
				$(".demo #mytabs_panel").children().eq(0).addClass("active");
				$(".demo #myTabs_ul").removeAttr("id");
				$(".demo #mytabs_panel").removeAttr("id");
				initContainer();
			}
			handleJsIds();
			if (stopsave > 0)
				stopsave--;
			startdrag = 0;
		}
	});
	initContainer();
	/**
	 * 重写ckeditor工具栏里面的保存
	 */
	contenthandle.on("instanceReady", function (e) {  
		contenthandle.addCommand("save", { 
			modes: { wysiwyg: 1, source: 1 }, 
			exec: function (contenthandle) { 
				currenteditor.html(contenthandle.getData());
				initContainer();
				$('#editorModal').modal('hide');
			}  
		 });  
	}); 
	/**
	 * 重写ckeditor工具栏里面的取消
	 */
	contenthandle.on("instanceReady", function (e) {  
		contenthandle.addCommand("close", { 
			modes: { wysiwyg: 1, source: 1 }, 
			exec: function (contenthandle) { 
				$('#editorModal').modal('hide');
			}  
		 });  
	}); 
	
	$('body.edit .demo').on("click","[data-target=#editorModal]",//编辑按钮绑定事件
			function(e) {

				e.preventDefault();
				currenteditor = $(this).parent().parent().find(
						'.view');
				var eText = currenteditor.html();
				contenthandle.setData(eText);
			});
	$("#savecontent").click(function(e) {
		e.preventDefault();
		currenteditor.html(contenthandle.getData());
		initContainer();
	});
	$("[data-target=#downloadModal]").click(function(e) {
		e.preventDefault();
		downloadLayoutSrc();
	});
	/*
	 * $("[data-target=#shareModal]").click(function(e) {
	 * e.preventDefault(); handleSaveLayout(); });
	 */
	$("#download").click(function() {
		downloadLayout();
		return false
	});
	$("#downloadhtml").click(function() {
		downloadHtmlLayout();
		return false
	});
	$("#edit").click(function() {
		$("body").removeClass("devpreview sourcepreview");
		$("body").addClass("edit");
		/*
		 * $(".column").bind("mousedown",function(){
		 * bindResize(this); });
		 */
		removeMenuClasses();
		$(this).addClass("active");
		return false
	});
	$("#clear").click(function(e) {
		e.preventDefault();
		clearDemo()
	});
	$("#devpreview").click(function() {
		$("body").removeClass("edit sourcepreview");
		$("body").addClass("devpreview");
		removeMenuClasses();
		$(this).addClass("active");
		return false
	});
	$("#sourcepreview").click(function() {
		$("body").removeClass("edit");
		$("body").addClass("devpreview sourcepreview");
		/* $(".column").unbind("mousedown"); */
		removeMenuClasses();
		$(this).addClass("active");

		return false
	});
	$("#fluidPage").click(function(e) {
		e.preventDefault();
		changeStructure("container", "container-fluid");
		$("#fixedPage").removeClass("active");
		$(this).addClass("active");
		downloadLayoutSrc()
	});
	$("#fixedPage").click(function(e) {
		e.preventDefault();
		changeStructure("container-fluid", "container");
		$("#fluidPage").removeClass("active");
		$(this).addClass("active");
		downloadLayoutSrc()
	});
	$(".nav-header").click(function() {
		$(".sidebar-nav .boxes, .sidebar-nav .rows").hide();

		if (!showflag) {
			$(this).next().slideDown();
			showflag = true;
		} else {
			if (dome != $(this)[0].innerHTML) {
				$(this).next().slideDown();
				showflag = true;
			} else {
				showflag = false;
			}
		}
		dome = $(this)[0].innerHTML;
	});
	$('#undo').click(function() {
		stopsave++;
		if (undoLayout())
			initContainer();
		stopsave--;
	});
	$('#redo').click(function() {
		stopsave++;
		if (redoLayout())
			initContainer();
		stopsave--;
	});
	/*
	 * $(".column").bind("mousedown",function(){
	 * bindResize(this); });
	 */
	removeElm();
	gridSystemGenerator();
	setInterval(function() {
		handleSaveLayout()
	}, timerSave)
	/**
	 * 保存界面源码
	 */
	$("#btnsave").click(function() {
		var formid = getQueryString('formid');
		if (formid == null || formid == "") {
			formid = "0";
		}
		
		var content = $("#con_left").html();
		$.ajax({
			url : 'formModelDesginController/save',
			type : 'post',
			dataType : 'text',
			data : {
				formid : formid,
				content : content
			},
			success : function(data) {
				if (data != null && data != '') {
					alert("保存成功");
				} else {
					alert("保存失败");
				}
			}
		});
	});
	$("#saveRelease").click(function() {
		var formid = getQueryString('formid');
		if (formid == null || formid == "") {
			formid = "0";
		}
		var content = $("#con_left").html();
		var rcontent = getRelaseContent();
		$.ajax({
			url : 'formModelDesginController/saveRelease',
			type : 'post',
			dataType : 'text',
			data : {
				formid : formid,
				content : content,
				rcontent : rcontent
			},
			success : function(data) {
				if (data != null && data != "") {
					alert("保存成功");
				} else {
					alert("保存失败");
				}
			}
		});
	});
	$("#viewFile").click(function() {
		var formid = getQueryString('formid');
		if (formid == null || formid == "") {
			formid = "0";
		}
		var content = $("#con_left").html();
		var rcontent = getRelaseContent();
		url = 'formController/formurl?formid=' + formid;
		window.open(url);
	});
	// div高度改变监听
	$(".column").resize(function() {

		var elem = $(this);

		// Update the info div width and height -
		// replace this with your own code
		// to do something useful!
		/*
		 * elem.closest('.container').find('.info').text(
		 * this.tagName + ' width: ' + elem.width() + ', height: ' +
		 * elem.height());
		 */
	});
	function getRelaseContent() {
		var e = "";
		$("#download-layout").children().html($("#con_left").html());
		var t = $("#download-layout").children();
		t.find(".preview, .configuration, .drag, .remove").remove();
		t.find(".lyrow").addClass("removeClean");
		t.find(".box-element").addClass("removeClean");
//		t.find(".lyrow .lyrow .lyrow .lyrow .lyrow .removeClean").each(function() {
//			cleanHtml(this)
//		});
//		t.find(".lyrow .lyrow .lyrow .lyrow .removeClean").each(function() {
//			cleanHtml(this)
//		});
//		t.find(".lyrow .lyrow .lyrow .removeClean").each(function() {
//			cleanHtml(this)
//		});
//		t.find(".lyrow .lyrow .removeClean").each(function() {
//			cleanHtml(this)
//		});
//		t.find(".lyrow .removeClean").each(function() {
//			cleanHtml(this)
//		});
		t.find(".removeClean .removeClean .removeClean .removeClean").each(function() {
			cleanHtml(this)
		});
		t.find(".removeClean .removeClean .removeClean").each(function() {
			cleanHtml(this)
		});
		t.find(".removeClean .removeClean").each(function() {
			cleanHtml(this)
		});
		t.find(".removeClean").each(function() {
			cleanHtml(this)
		});
		t.find(".removeClean").remove();
		$("#download-layout .column").removeClass("ui-sortable");
		/*
		 * $("#download-layout
		 * .row-fluid").removeClass("clearfix").children().removeClass("column");
		 */
		if ($("#download-layout .container").length > 0) {
			changeStructure("row-fluid", "row")
		}
		/* t.find(".column").remove(); */
		t.find(".column").removeClass("column");
		formatSrc = $("#download-layout").html();
		return formatSrc;
	}
	
	$("#tabPageCount").spinner({ 
	    max:10, 
	    min:01, 
	    step:1 
	});
});
function supportstorage() {
	if (typeof window.localStorage == 'object')
		return true;
	else
		return false;
}

function handleSaveLayout() {
	var e = $(".demo").html();
	if (!stopsave && e != window.demoHtml) {
		stopsave++;
		window.demoHtml = e;
		saveLayout();
		stopsave--;
	}
}

var layouthistory;
function saveLayout() {
	var data = layouthistory;
	if (!data) {
		data = {};
		data.count = 0;
		data.list = [];
	}
	if (data.list.length > data.count) {
		for (i = data.count; i < data.list.length; i++)
			data.list[i] = null;
	}
	data.list[data.count] = window.demoHtml;
	data.count++;
	if (supportstorage()) {
		localStorage.setItem("layoutdata", JSON.stringify(data));
	}
	layouthistory = data;
	// console.log(data);
	/*
	 * $.ajax({ type: "POST", url: "/build/saveLayout", data: { layout:
	 * $('.demo').html() }, success: function(data) {
	 * //updateButtonsVisibility(); } });
	 */
}

function downloadLayout() {

	$.ajax({
		type : "POST",
		url : "/build/downloadLayout",
		data : {
			layout : $('#download-layout').html()
		},
		success : function(data) {
			window.location.href = '/build/download';
		}
	});
}

function downloadHtmlLayout() {
	$.ajax({
		type : "POST",
		url : "/build/downloadLayout",
		data : {
			layout : $('#download-layout').html()
		},
		success : function(data) {
			window.location.href = '/build/downloadHtml';
		}
	});
}

function undoLayout() {
	var data = layouthistory;
	// console.log(data);
	if (data) {
		if (data.count < 2)
			return false;
		window.demoHtml = data.list[data.count - 2];
		data.count--;
		$('.demo').html(window.demoHtml);
		if (supportstorage()) {
			localStorage.setItem("layoutdata", JSON.stringify(data));
		}
		return true;
	}
	return false;
	/*
	 * $.ajax({ type: "POST", url: "/build/getPreviousLayout", data: { },
	 * success: function(data) { undoOperation(data); } });
	 */
}

function redoLayout() {
	var data = layouthistory;
	if (data) {
		if (data.list[data.count]) {
			window.demoHtml = data.list[data.count];
			data.count++;
			$('.demo').html(window.demoHtml);
			if (supportstorage()) {
				localStorage.setItem("layoutdata", JSON.stringify(data));
			}
			return true;
		}
	}
	return false;
	/*
	 * $.ajax({ type: "POST", url: "/build/getPreviousLayout", data: { },
	 * success: function(data) { redoOperation(data); } });
	 */
}

function handleJsIds() {
	handleModalIds();
	handleAccordionIds();
	handleCarouselIds();
//	handleTabsIds()
}
function handleAccordionIds() {
	var e = $(".demo #myAccordion");
	var t = randomNumber();
	var n = "accordion-" + t;
	var r;
	e.attr("id", n);
	e.find(".accordion-group").each(function(e, t) {
		r = "accordion-element-" + randomNumber();
		$(t).find(".accordion-toggle").each(function(e, t) {
			$(t).attr("data-parent", "#" + n);
			$(t).attr("href", "#" + r)
		});
		$(t).find(".accordion-body").each(function(e, t) {
			$(t).attr("id", r)
		})
	})
}
function handleCarouselIds() {
	var e = $(".demo #myCarousel");
	var t = randomNumber();
	var n = "carousel-" + t;
	e.attr("id", n);
	e.find(".carousel-indicators li").each(function(e, t) {
		$(t).attr("data-target", "#" + n)
	});
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
	});
	/**第一个标签页高亮*/
	$(".demo #myTabs_ul").children().eq(0).click();
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
		var n = $(this).val().split(" ", 12);
		$.each(n, function(n, r) {
			e = e + parseInt(r);
			t += '<div class="span' + r + ' column"></div>'
		});
		if (e == 12) {
			$(this).parent().next().children().html(t);
			$(this).parent().prev().show()
		} else {
			$(this).parent().prev().hide()
		}
	})
}
function configurationElm(e, t) {
	$(".demo").delegate(".configuration > a", "click", function(e) {
		e.preventDefault();
		var t = $(this).parent().next().next().children();
		$(this).toggleClass("active");
		t.toggleClass($(this).attr("rel"))
	});
	$(".demo").delegate(".configuration .dropdown-menu a", "click",
			function(e) {
				e.preventDefault();
				var t = $(this).parent().parent();
				var n = t.parent().parent().next().next().children();
				t.find("li").removeClass("active");
				$(this).parent().addClass("active");
				var r = "";
				t.find("a").each(function() {
					r += $(this).attr("rel") + " "
				});
				t.parent().removeClass("open");
				n.removeClass(r);
				n.addClass($(this).attr("rel"))
			})
}
var showflag = false;
var dome = null;
function removeElm() {
	$(".demo").delegate(".remove", "click", function(e) {
		e.preventDefault();
		$(this).parent().remove();
		if (!$(".demo .lyrow").length > 0) {
			clearDemo()
		}
	})
}
function clearDemo() {
	$(".demo").empty();
	layouthistory = null;
	if (supportstorage())
		localStorage.removeItem("layoutdata");
}
function removeMenuClasses() {
	$("#menu-layoutit li button").removeClass("active");

}
function changeStructure(e, t) {
	$("#download-layout ." + e).removeClass(e).addClass(t)
}
function cleanHtml(e) {
	$(e).parent().append($(e).children().html())
}
function downloadLayoutSrc() {
	var e = "";
	/* $(".column").unbind("mousedown"); */
	$("#download-layout").children().html($("#con_left").html());
	var t = $("#download-layout").children();
	t.find(".preview, .configuration, .drag, .remove").remove();
	t.find(".lyrow").addClass("removeClean");
	t.find(".box-element").addClass("removeClean");
//	t.find(".lyrow .lyrow .lyrow .lyrow .lyrow .removeClean").each(function() {
//		cleanHtml(this)
//	});
//	t.find(".lyrow .lyrow .lyrow .lyrow .removeClean").each(function() {
//		cleanHtml(this)
//	});
//	t.find(".lyrow .lyrow .lyrow .removeClean").each(function() {
//		cleanHtml(this)
//	});
//	t.find(".lyrow .lyrow .removeClean").each(function() {
//		cleanHtml(this)
//	});
//	t.find(".lyrow .removeClean").each(function() {
//		cleanHtml(this)
//	});
	t.find(".removeClean .removeClean .removeClean .removeClean").each(function() {
		cleanHtml(this)
	});
	t.find(".removeClean .removeClean .removeClean").each(function() {
		cleanHtml(this)
	});
	t.find(".removeClean .removeClean").each(function() {
		cleanHtml(this)
	});
	t.find(".removeClean").each(function() {
		cleanHtml(this)
	});
	t.find(".removeClean").remove();
	$("#download-layout .column").removeClass("ui-sortable");
	/*
	 * $("#download-layout
	 * .row-fluid").removeClass("clearfix").children().removeClass("column");
	 */
	if ($("#download-layout .container").length > 0) {
		changeStructure("row-fluid", "row")
	}
	formatSrc = $("#download-layout").html();
	/*
	 * $.htmlClean($("#download-layout").html(), { format: true,
	 * allowedAttributes: [ ["id"], ["class"], ["data-toggle"], ["data-target"],
	 * ["data-parent"], ["role"], ["data-dismiss"], ["aria-labelledby"],
	 * ["aria-hidden"], ["data-slide-to"], ["data-slide"] ] });
	 */
	// 添加算法
	$("#download-layout").html(formatSrc);
	$("#downloadModal textarea").empty();
	$("#downloadModal textarea").val(formatSrc)
}

var currentDocument = null;
var timerSave = 1000;
var stopsave = 0;
var startdrag = 0;
var demoHtml = $(".demo").html();
var currenteditor = null;
$(window).resize(function() {
	$("body").css("min-height", $(window).height() - 90);
	$(".demo").css("min-height", $(window).height() - 160)
});
// 获取历史内容
function restoreData() {
	if (supportstorage()) {
		layouthistory = JSON.parse(localStorage.getItem("layoutdata"));
		if (!layouthistory)
			return false;
		window.demoHtml = layouthistory.list[layouthistory.count - 1];
		if (window.demoHtml)
			$(".demo").html(window.demoHtml);
	}
}

function initContainer() {
	$(".demo, .demo .column").sortable({
		connectWith : ".column",
		opacity : .35,
		handle : ".drag",
		start : function(e, t) {
			if (!startdrag)
				stopsave++;
			startdrag = 1;
		},
		stop : function(e, t) {
			if (stopsave > 0)
				stopsave--;
			startdrag = 0;
		}
	});
	configurationElm();
}

function resizeHeight(em) {
}
/**
 * 获取表单设计内容
 */
function reloadContent() {
	var formid = getQueryString('formid');
	if (formid == null || formid == "") {
		formid = "0";
	}
	$.ajax({
		url : 'formModelDesginController/getcontentbyformid',
		type : 'post',
		dataType : 'text',
		data : {
			formid : formid
		},
		async : false, // 必须为同步加载，异步加载无法绑定方法
		success : function(data) {
			if (data != '') {
				$("#con_left").html(data);
				if ($("#_tableid").length == 0) {
					var table = "<input id='_tableid' style='display:none' value='" + tableid + "'>";
					$("#con_left").append(table);
				} else {
					if ($("#_tableid").val() != tableid) {
						$("#_tableid").remove();
						var table = "<input id='_tableid' style='display:none' value='" + tableid + "'>";
						$("#con_left").append(table);
					}
				}
				if ($("#_formid").length == 0) {

					var forminput = "<input id='_formid' style='display:none' value='" + formid + "'>";
					$("#con_left").append(forminput);
				} else {
					if ($("#_formid").val() != formid) {
						$("#_formid").remove();
						var forminput = "<input id='_formid' style='display:none' value='" + formid + "'>";
						$("#con_left").append(forminput);
					}
				}
				if ($("#myModal").length == 0) {
					var userdialog = "<div class='modal fade' style='display:none;' id='myModal' tabindex='-1' role='dialog'"
							+ " aria-labelledby='myModalLabel' aria-hidden='true'><div class='modal-dialog modal-lg'>"
							+ " <div class='modal-content'><div class='modal-header'><button type='button' class='close' data-dismiss='modal'"
							+ " aria-hidden='true'>×</button><h4 class='modal-title' id='myModalLabel'>选择人员</h4>"
							+ " </div><div class='modal-body' style='text-align: center;'><div>"
							+ " <iframe id='group' runat='server' src='' width='100%' height='350' frameborder='no' border='0' marginwidth='0'"
							+ " marginheight='0' scrolling='auto' allowtransparency='yes'></iframe></div><div>"
							+ " <input type='button' class='sendbtn' value='确定' onclick='makesurePerson()' />&nbsp;&nbsp; "
							+ " <input type='button' class='sendbtn' value='清空' onclick='btnQk();' />&nbsp;&nbsp; "
							+ " <input type='button' class='sendbtn' value='取消' onclick='btnCancel()' /></div></div>"
							+ " </div></div></div>";
					$("#con_left").append(userdialog);
				}
				if ($("#treeDiv_").length == 0) {
					var usertreeview = "<div id='treeDiv_' class='treeDiv' style='position:absolute; '><div id='treeDemo_' class='ztree'	style='min-height:150px; margin-top: 15px; overflow: auto; font-size: 13px;'><ul id='groupTree_' class='ztree' style='margin-top: 10px;'></ul></div></div>";
					$("#con_left").append(usertreeview);
				}
			}
		}
	});
}
var tableid = '';
var _formid = '';
/**
 * 组件封装
 */
function getControlData() {
	var formid = getQueryString('formid');
	if (formid == null || formid == "") {
		formid = "0";
	}
	_formid = formid;

	$.ajax({
		url : 'formModelDesginController/getDataSource',
		type : 'post',
		dataType : 'text',
		data : {
			formid : formid
		},
		async : false, // 必须为同步加载，异步加载无法绑定方法
		success : function(data) {
			tableid = data;
		}
	});
	$.ajax({
		url : 'formColumnController/listFormCols',
		type : 'post',
		dataType : 'json',
		data : {
			tableid : tableid
		},
		async : false, // 必须为同步加载，异步加载无法绑定方法
		success : function(data) {
			if (data != null && data.length) {
				var comhtml = "<div class='box box-element ui-draggable'><a href='#close' class='remove label label-important'>"
						+ "<i class='icon-remove icon-white'></i>删除</a> <span class='drag label'><i	class='icon-move'></i>拖动</span>"
						+ " <span class='configuration'><button type='button' class='btn btn-mini' data-target='#editorModal'"
						+ " role='button' data-toggle='modal'>编辑</button> </span><div class='preview'>全部意见</div>"
						+ " <div class='view'><div id='all_comments' >"
						+ " <lable></lable></div></div></div>";
				/**
				 * 未使用标题栏
				 */
//				var html = " <div class='box box-element ui-draggable'><a href='#close'"
//						+ " class='remove label label-important'><i class='icon-remove icon-white'></i>删除</a>"
//						+ " <span class='drag label'><i class='icon-move'></i>拖动</span> <span class='configuration'>"
//						+ " <button type='button' class='btn btn-mini' data-target='#editorModal'	"
//						+ " role='button' data-toggle='modal'>编辑</button> </span><div class='preview'>标题栏</div>"
//						+ " <div class='view'><label contenteditable='true'>标题.</label></div></div>";
				var html = "";
				for (var i = 0; i < data.length; i++) {
					html += "<div class='box box-element ui-draggable'><a href='#close' "
							+ " class='remove label label-important'><i class='icon-remove icon-white'></i>删除</a> "
							+ " <span class='drag label'><i class='icon-move'></i>拖动</span>"
							+ " <span class='configuration'><button type='button' class='btn btn-mini' "
							+ " data-target='#editorModal' role='button' data-toggle='modal'>编辑</button>"
							+ " </span> <div class='preview'>"
							+ data[i].col_name
							+ "</div> <div class='view'>";
					var comclass = "";
					if (data[i].wf_key == 'Y') {
						comclass = " _com_form_data_control"
					}
					if (data[i].ctr_type == 'label') {//文本框
						html += " <label class='_form_data_control "
								+ comclass
								+ "' style='width:100%;' contenteditable='true' id='"
								+ data[i].col_code + "' name='"
								+ data[i].col_name + "' >"
								+ data[i].col_name + "</label>";
					} else if (data[i].ctr_type == 'input') {
						html += "<input  type='text' id='"
								+ data[i].col_code
								+ "' name='"
								+ data[i].col_name
								+ "'"
								+ " class='validate[required] form-control _form_data_control "
								+ comclass;
						if (data[i].ismemory == 'Y') {
							html += " form_memory";
						}
						html += "' placeholder='' style='height:24px;width:100%;text-indent: 13px;' >";
					} else if (data[i].ctr_type == 'textarea') {
						html += "<textarea id='"
								+ data[i].col_code
								+ "' name='"
								+ data[i].col_name
								+ "' "
								+ "class='form-control _form_data_control "
								+ comclass
								+ "' style='width:100%;min-height:80px;'></textarea>";
					} else if (data[i].ctr_type == 'ueditor') {//富文本编辑器(暂时不用)
						html += "<input id='"
								+ data[i].col_code
								+ "' name='"
								+ data[i].col_name
								+ "'  type='hidden'"
								+ "class='form-control _form_data_control "
								+ comclass
								+ " _form_ueditor' value=''>"
								+ " <script id='editor' type='text/plain' style='width:99.9%;height:300px;'"
								+ " onpropertychange='if(value.length>2048) value=value.substr(0,2048)'></script>";
					} else if (data[i].ctr_type == 'date') {//日期
						html += "<input style='height:24px;width:100%;text-indent: 13px;' type='text' id='"
								+ data[i].col_code
								+ "' name='"
								+ data[i].col_name
								+ "'"
								+ " class='form-control _form_data_control "
								+ comclass
								+ "' enable='false' "
								+ " onclick=\"laydate({istime: true, format:'YYYY-MM-DD hh:mm:ss'})\" />";
					} else if (data[i].ctr_type == 'userlist') {//用户列表（已经弃用，使用新人员选择树代替）
						html += "<div class='form-group'><input style='width:100%;text-indent: 13px;'  type='text' class='_form_data_control form-control "
								+ comclass
								+ "' id='"
								+ data[i].col_code
								+ "_NAME' onclick=\"selectPeople('"
								+ data[i].col_code
								+ "','"
								+ data[i].ref_obj
								+ "')\" name = '"
								+ data[i].col_code
								+ "_NAME' placeholder='请选择人员' value=''><input style='width:100%;display:none;' class='_form_data_control ' type='text' id='"
								+ data[i].col_code
								+ "' value=''></div>";
					} else if (data[i].ctr_type == 'treeview') {//下拉树，暂时弃用
						html += "<input id='"
								+ data[i].col_code
								+ "' class='form-control _form_data_control' name='"
								+ data[i].col_code
								+ "' type='hidden' style='width: 100%;  border: 0;' value='' />"
								+ "<input id='"
								+ data[i].col_code
								+ "_NAME' name='"
								+ data[i].col_code
								+ "_NAME' class='validate[required] form-control _form_data_control select'"
								+ " type='text' style='width: 100%;  border: 0;text-indent: 13px;' onclick=\"peopleTree('"
								+ data[i].ref_obj + "','"
								+ data[i].col_code
								+ "');\" value='' />";
					} else if (data[i].ctr_type == 'selectionDept') {// 部门树选择
						var ctrname = data[i].col_code.substr(0,
								data[i].col_code.length - 1)
								+ "Name_";
						html += "<input id='"
								+ data[i].col_code
								+ "' class='form-control _form_data_control' name='"
								+ data[i].col_code
								+ "' type='hidden' style='width: 100%;  border: 0;' value='' />"
								+ "<input id='"
								+ ctrname
								+ "' name='"
								+ ctrname
								+ "' class='validate[required] form-control _form_data_control select'"
								+ " type='text' style='height:24px;width: 100%;  border: 0;text-indent: 13px;' onclick=\"deptTree(2,'"
								+ data[i].col_code
								+ "');\" value='' />";
					} else if (data[i].ctr_type == 'selectionPeople') {// 人员树选择
						var ctrname = data[i].col_code.substr(0,
								data[i].col_code.length - 1)
								+ "Name_";
						html += "<input id='"
								+ data[i].col_code
								+ "' class='form-control _form_data_control' name='"
								+ data[i].col_code
								+ "' type='hidden' style='width: 100%;  border: 0;' value='' />"
								+ "<input id='"
								+ ctrname
								+ "' name='"
								+ ctrname
								+ "' class='validate[required] form-control _form_data_control select'"
								+ " type='text' style='height:24px;width: 100%;  border: 0;text-indent: 13px;' onclick=\"peopleTree(1,'"
								+ data[i].col_code
								+ "');\" value='' />";
					} else if (data[i].ctr_type == 'selectionMoreDept') {// 部门树多选择
						var ctrname = data[i].col_code.substr(0,
								data[i].col_code.length - 1)
								+ "Name_";
						html += "<input id='"
								+ data[i].col_code
								+ "' class='form-control _form_data_control' name='"
								+ data[i].col_code
								+ "' type='hidden' style='width: 100%;  border: 0;' value='' />"
								+ "<input id='"
								+ ctrname
								+ "' name='"
								+ ctrname
								+ "' class='validate[required] form-control _form_data_control select'"
								+ " type='text' style='height:24px;width: 100%;  border: 0;text-indent: 13px;' onclick=\"deptMoreTree(2,'"
								+ data[i].col_code
								+ "');\" value='' />";
					} else if (data[i].ctr_type == 'selectionMorePeople') {// 人员树多选选择
						var ctrname = data[i].col_code.substr(0,
								data[i].col_code.length - 1)
								+ "Name_";
						html += "<input id='"
								+ data[i].col_code
								+ "' class='form-control _form_data_control' name='"
								+ data[i].col_code
								+ "' type='hidden' style='width: 100%;  border: 0;' value='' />"
								+ "<input id='"
								+ ctrname
								+ "' name='"
								+ ctrname
								+ "' class='validate[required] form-control _form_data_control select'"
								+ " type='text' style='height:24px;width: 100%;  border: 0;text-indent: 13px;' onclick=\"peopleMoreTree(1,'"
								+ data[i].col_code
								+ "');\" value='' />";
					} else if (data[i].ctr_type == 'zbk') {// 指标库选择
						var ctrname = data[i].col_code.substr(0,
								data[i].col_code.length - 1)
								+ "Name_";
						html += "<input id='"
								+ data[i].col_code
								+ "' class='form-control _form_data_control' name='"
								+ data[i].col_code
								+ "' type='hidden' style='width: 100%;  border: 0;' value='' />"
								+ "<input id='"
								+ ctrname
								+ "' name='"
								+ ctrname
								+ "' class='validate[required] form-control _form_data_control select'"
								+ " type='text' style='height:24px;width: 100%;  border: 0;text-indent: 13px;' onclick=\"IndexLibraryTree(1,'"
								+ data[i].col_code
								+ "');\" value='' />";
					} else if (data[i].ctr_type == 'sys_dic') {//数据字典
						html += "<select id='"
								+ data[i].col_code
								+ "' name='"
								+ data[i].col_name
								+ "' type='text'"
								+ " class='reload_data_select' style='height:24px;width:100%;padding-left:10px;' method='BindSelectItembyDict' parameter='"
								+ data[i].col_code + ","
								+ data[i].dic_type
								+ "' placeholder='' ></select>";
					} else if (data[i].ctr_type == 'select') {
						if (data[i].ref_type == 'sys_dic') {//ref_type参照类型弃用
							html += "<select id='"
									+ data[i].col_code
									+ "' name='"
									+ data[i].col_name
									+ "' type='text'"
									+ " class='form-control _form_data_control reload_data_select selectpicker select' style='width:100%;text-indent: 13px;' method='BindSelectItembyDict' parameter='"
									+ data[i].col_code + ","
									+ data[i].dic_type//数据字典
									+ "' placeholder='' ></select>";
						} else if (data[i].ref_obj != null
								&& data[i].ref_obj != "") {//ref_obj参照对象弃用
							html += "<select id='"
									+ data[i].col_code
									+ "' name='"
									+ data[i].col_name
									+ "' type='text'"
									+ " class='form-control _form_data_control reload_data_select' style='width:100%;text-indent: 13px;' method='addItemsbyUrl' parameter='"
									+ data[i].col_code + ","
									+ data[i].ref_obj
									+ "' placeholder=''></select>";
						} else {
							html += "<select id='"
									+ data[i].col_code
									+ "' name='"
									+ data[i].col_name
									+ "' type='text'"
									+ " class='form-control _form_data_control' style='width:100%;text-indent: 13px;' placeholder=''  ></select>";
						}
					} else if (data[i].ctr_type == 'select2') {//自定义下拉列表
						if (data[i].ref_type == 'sys_dic') {
							html += "<select id='"
									+ data[i].col_code
									+ "' name='"
									+ data[i].col_name
									+ "' type='text'"
									+ " class='form-control _form_data_control js-example-data-array select2 reload_data_select' style='width:100%;text-indent: 13px;' method='BindDictItem' placeholder='' parameter='"
									+ data[i].col_code + ","
									+ data[i].dic_type + "' ></select>";
						} else if (data[i].ref_obj != null
								&& data[i].ref_obj != "") {
							html += "<select id='"
									+ data[i].col_code
									+ "' name='"
									+ data[i].col_name
									+ "' type='text'"
									+ " class='form-control _form_data_control js-example-data-array select2 reload_data_select' style='width:100%;text-indent: 13px;' method='BindDataSource' parameter='"
									+ data[i].col_code + ","
									+ data[i].ref_obj
									+ "' placeholder='' ></select>";
						} else {
							html += "<select id='"
									+ data[i].col_code
									+ "' name='"
									+ data[i].col_name
									+ "' type='text'"
									+ " class='form-control _form_data_control' style='width:100%;text-indent: 13px;' placeholder=''  ></select>";
						}
					} else if (data[i].ctr_type == 'annex') {//旧版附件
						html += "<iframe class='form_annex "
								+ comclass
								+ "' id='"
								+ data[i].col_code
								+ "' frameborder='no' border='0' src='media/bpmaccessory?docType="
								+ data[i].col_code
								+ "&showType=form' style='width: 100%;height: 200px'></iframe>"
					}else if (data[i].ctr_type == 'annexnew') {//新附件
						html += "<div class='form_annex_new "
							+ comclass
							+ "' id='"
							+ data[i].col_code
							+ "' style='width: 100%;min-height: 200px'></div>"
				} else if (data[i].ctr_type == 'number') {//数字，未使用
						html += "<input type='number' id='"
								+ data[i].col_code
								+ "' name='"
								+ data[i].col_name
								+ "' "
								+ " class='validate[required,custom[integer],min[10]] form-control _form_data_control' style='width:100%;text-indent: 13px;' placeholder='' maxlength=4>";
					} else if (data[i].ctr_type == 'img') {//图片，未使用
						html += "<img alt='图片未加载' id='"
								+ data[i].col_code
								+ "' name='"
								+ data[i].col_name
								+ "' "
								+ " class='validate[required,custom[integer],min[10]] form-control form_barcode' style='width:100%;' />";
					} else if (data[i].ctr_type == 'radio') {//单选，未使用
						html += "<input class='_form_data_control' id='"
								+ data[i].col_code
								+ "' name='"
								+ data[i].col_name
								+ "' type='radio' value='N'> 是"
								+ "<input class='_form_data_control' name='"
								+ data[i].col_code
								+ "' type='radio' value='Y'> 否";
					} else if (data[i].ctr_type == 'checkbox') {//复选框，未使用
						html += "<input class='_form_data_control' type='checkbox' value='' id='"
								+ data[i].col_code
								+ "' name='"
								+ data[i].col_name
								+ "' data-toggle='checkbox'>";
					} else if (data[i].ctr_type == 'signature') {//手写签批
						html += "<div class='form_signature commentDiv' style='width: 100%;min-height:150px;overflow:auto; ' id='"+ data[i].col_code+"Div'></div>";
							}
					if (data[i].wf_key == 'Y') {
						comhtml += "<div class='box box-element ui-draggable'><a href='#close' "
								+ " class='remove label label-important'><i class='icon-remove icon-white'></i>删除</a> "
								+ " <span class='drag label'><i class='icon-move'></i>拖动</span>"
								+ " <span class='configuration'><button type='button' class='btn btn-mini' "
								+ " data-target='#editorModal' role='button' data-toggle='modal'>编辑</button>"
								+ " </span> <div class='preview'>"
								+ data[i].col_name
								+ "</div> <div class='view'>";
						comhtml += "<div id='_com_"
								+ data[i].col_code
								+ "' class='form_com_content'></div>";

					}
					comhtml += "</div></div>";
					html += " </div></div>";
				}
				comhtml += "<div class='box box-element ui-draggable'><a href='#close' "
						+ " class='remove label label-important'><i class='icon-remove icon-white'></i>删除</a> "
						+ " <span class='drag label'><i class='icon-move'></i>拖动</span>"
						+ " <span class='configuration'><button type='button' class='btn btn-mini' "
						+ " data-target='#editorModal' role='button' data-toggle='modal'>编辑</button>"
						+ " </span> <div class='preview'>流程条形码</div> <div class='view'>"
						+ "<img alt='条形码未加载'  class=' form-control form_barcode' />";
				+"</div></div>";
				$("#elmBase").append(html);

				$("#wfBase").html(comhtml);
			}
		}
	});
	// 附件控件绑定参数

}
/**
 * 获取数据源地址
 * 
 * @param code
 */
function getUrlByDicData(code) {
	var url = "";
	$.ajax({
		url : "dictController/findDictByTypeCode",
		type : "post",
		async : false,
		dataType : "json",
		data : {
			dictTypeCode : 'czdx'
		},
		success : function(data) {
			if (data != null && data.length > 0) {
				for (var i = 0; i < data.length; i++) {
					if (code == data[i].dictCode) {
						url = data[i].remark;
					}
				}
			}
		}
	});
	return url;
}
function getQueryString(name) {
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)", "i");
	var r = window.location.search.substr(1).match(reg);
	if (r != null)
		return unescape(r[2]);
	return null;
}
function bindColumn() {

}
