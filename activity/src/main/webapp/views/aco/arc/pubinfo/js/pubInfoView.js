window.onload=function(){
	 var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
	    if (isChrome) {
	    	disableFileLoadButtonChrom();
	    }
	    else {
		disableFileLoadButton();
	}
};
//返回按钮事件
$(function() {
	if ($("#selectView").val() == 'selectView') {
		$("#btn_close").remove();
	}


	$("#btn_close").click(function() {
		window.parent.closePage(window, true, true, false, "#main_iframe");
		/*		window.parent.closePage(window,true,true,true);
		 */});
});

function disableFileLoadButton() {
	//disable the button of file upload
	var buttons = $(window.frames["attachment_iframe"].document).find("button");
	for (var i = 0; i < buttons.length; i++) {
		if (buttons[i].getAttribute("id") != "open"
				&& buttons[i].getAttribute("id") != "resave") {
			buttons[i].setAttribute("disabled", "disabled");
		}
	}
}
function disableFileLoadButtonChrom() {
	//disable the button of file upload
	var buttons = $(window.frames["attachment_iframe"].contentDocument).find("button");
	for (var i = 0; i < buttons.length; i++) {
		if (buttons[i].getAttribute("id") != "open"
				&& buttons[i].getAttribute("id") != "resave") {
			buttons[i].setAttribute("disabled", "disabled");
		}
	}
}
