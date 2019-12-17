window.onload = function() {
	var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
	if (isChrome) {
		disableFileLoadButtonChrom();
		disableFileLoadButton1Chrom();
		disableFileLoadButton2Chrom();
	} else {
		disableFileLoadButton();
		disableFileLoadButton1();
		disableFileLoadButton2();
	}
}
//返回按钮事件
$(function() {
	if ($("#selectView").val() == 'selectView') {
		$("#btn_close").remove();
	}

	$("#btn_close").click(function() {
		window.parent.parent.closePage1(window, true, true, false, 1);
	});
});

function btnDisabled(type) {
	if (type != "view") {
	} else {
		var buttons1 = $(window.frames["attachment_iframe"].document).find(
				"button");
		btnDis(buttons1);
	}

}
function btnDis(buttons) {
	for (var i = 0; i < buttons.length; i++) {
		if (buttons[i].getAttribute("id") != "open"
				&& buttons[i].getAttribute("id") != "resave") {
			buttons[i].setAttribute("disabled", "disabled");
		}
	}
}
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
function disableFileLoadButton1() {
	//disable the button of file upload
	var buttons = $(window.frames["attachment_iframe1"].document)
			.find("button");
	for (var i = 0; i < buttons.length; i++) {
		if (buttons[i].getAttribute("id") != "open"
				&& buttons[i].getAttribute("id") != "resave") {
			buttons[i].setAttribute("disabled", "disabled");
		}
	}
}
function disableFileLoadButton2() {
	//disable the button of file upload
	var buttons = $(window.frames["attachment_iframe2"].document)
			.find("button");
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
function disableFileLoadButton1Chrom() {
	//disable the button of file upload
	var buttons = $(window.frames["attachment_iframe1"].contentDocument)
			.find("button");
	for (var i = 0; i < buttons.length; i++) {
		if (buttons[i].getAttribute("id") != "open"
				&& buttons[i].getAttribute("id") != "resave") {
			buttons[i].setAttribute("disabled", "disabled");
		}
	}
}
function disableFileLoadButton2Chrom() {
	//disable the button of file upload
	var buttons = $(window.frames["attachment_iframe2"].contentDocument)
			.find("button");
	for (var i = 0; i < buttons.length; i++) {
		if (buttons[i].getAttribute("id") != "open"
				&& buttons[i].getAttribute("id") != "resave") {
			buttons[i].setAttribute("disabled", "disabled");
		}
	}
}