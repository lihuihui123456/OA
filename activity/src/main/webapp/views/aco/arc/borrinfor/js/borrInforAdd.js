$(function() {
	
	$("#btn_save").click(function() {
		var data=$("#form_iframe")[0].contentWindow.doSaveForm();
		if(data){
			window.parent.closePage(window,true,true,true);
		}
	});
	
	//返回按钮事件
	$("#btn_close").click(function() {
		window.parent.closePage(window,true,true,true);
	});
	//重置按钮事件
	$("#btn_reset").click(function() {
		clearInputForm();
	});
});

/**
 * 调用子页面的清空方法
 */
function clearInputForm(){
	$("#form_iframe")[0].contentWindow.doClearForm();
}