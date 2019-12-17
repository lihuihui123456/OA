function btnDisabled(type) {
	if (type != "view") {
	} else {
		   var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
		    if (isChrome) {
				var buttons1 = $(window.frames["form_iframe1"].contentDocument).find("button");
				btnDis(buttons1);
				var buttons2 = $(window.frames["form_iframe2"].contentDocument).find("button");
				btnDis(buttons2);
		    }
		    else {
			var buttons1 = $(window.frames["form_iframe1"].document).find(
					"button");
			btnDis(buttons1);
			var buttons2 = $(window.frames["form_iframe2"].document).find(
					"button");
			btnDis(buttons2);
		}
	}

}
function writeObj(obj){ 
	 var description = ""; 
	 for(var i in obj){ 
	 var property=obj[i]; 
	 description+=i+" = "+property+"\n"; 
	 } 
	 alert(description); 
} 
function btnDis(buttons) {
	for (var i = 0; i < buttons.length; i++) {
		if (buttons[i].getAttribute("id") != "open"
				&& buttons[i].getAttribute("id") != "resave") {
			buttons[i].setAttribute("disabled", "disabled");
		}
	}
}
