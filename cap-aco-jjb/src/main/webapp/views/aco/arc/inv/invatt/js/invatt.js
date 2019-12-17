function btnDisabled(type){
	if(type!="view"){
	}else{
		 var isChrome = window.navigator.userAgent.indexOf("Chrome") !== -1;
		    if (isChrome) {
				 var buttons1=$(window.frames["form_iframe1"].contentDocument).find("button");
				 var buttons2=$(window.frames["form_iframe2"].contentDocument).find("button");
				 var buttons3=$(window.frames["form_iframe3"].contentDocument).find("button");
				 var buttons4=$(window.frames["form_iframe4"].contentDocument).find("button");
				 var buttons5=$(window.frames["form_iframe5"].contentDocument).find("button");
				 var buttons6=$(window.frames["form_iframe6"].contentDocument).find("button");
				 var buttons7=$(window.frames["form_iframe7"].contentDocument).find("button");
				 var buttons8=$(window.frames["form_iframe8"].contentDocument).find("button");
				 var buttons9=$(window.frames["form_iframe9"].contentDocument).find("button");
				 var buttons10=$(window.frames["form_iframe10"].contentDocument).find("button");
				 btnDis(buttons1);
				 btnDis(buttons2);
				 btnDis(buttons3);
				 btnDis(buttons4);
				 btnDis(buttons5);
				 btnDis(buttons6);
				 btnDis(buttons7);
				 btnDis(buttons8);
				 btnDis(buttons9);
				 btnDis(buttons10);
		    }
		    else {
			 var buttons1=$(window.frames["form_iframe1"].document).find("button");
			 var buttons2=$(window.frames["form_iframe2"].document).find("button");
			 var buttons3=$(window.frames["form_iframe3"].document).find("button");
			 var buttons4=$(window.frames["form_iframe4"].document).find("button");
			 var buttons5=$(window.frames["form_iframe5"].document).find("button");
			 var buttons6=$(window.frames["form_iframe6"].document).find("button");
			 var buttons7=$(window.frames["form_iframe7"].document).find("button");
			 var buttons8=$(window.frames["form_iframe8"].document).find("button");
			 var buttons9=$(window.frames["form_iframe9"].document).find("button");
			 var buttons10=$(window.frames["form_iframe10"].document).find("button");
			 btnDis(buttons1);
			 btnDis(buttons2);
			 btnDis(buttons3);
			 btnDis(buttons4);
			 btnDis(buttons5);
			 btnDis(buttons6);
			 btnDis(buttons7);
			 btnDis(buttons8);
			 btnDis(buttons9);
			 btnDis(buttons10);
		}
	}
	
}
function btnDis(buttons){
	  for(var i=0;i<buttons.length;i++){
	    	if(buttons[i].getAttribute("id")!="open" && buttons[i].getAttribute("id")!="resave"){
		    	buttons[i].setAttribute("disabled","disabled");
	    	}
	    }
}