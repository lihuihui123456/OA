	
	//弹出识别图片模态框
	function scan(){
		$("#scanFrame").attr("src",'bpmRuBizInfoController/ocrIndex');
		if(changeToZw()){
			$('#mainBody_iframe').hide();
			$('#scanFrameDiv').modal('show');
		}
	}
	
	//将识别出的字保存到正文
	function writeToZw(){
		var value=document.getElementById("scanFrame").contentWindow.getValue();
		$('#scanFrameDiv').modal('hide');
		$('#mainBody_iframe').show();
		document.getElementById("mainBody_iframe").contentWindow.WebSetWordContent(value);
	}
	
	//跳转到正文
	function changeToZw(){
		if(divId == "bizform"||divId == "attachment") {
			layerAlert("请切换到正文使用！");
			return false;
		}else{
			return true;
		}
	}
	
	//扫描图片关闭
	function cancelScan(){
		$('#scanFrameDiv').modal('hide');
		$('#mainBody_iframe').show();
	}