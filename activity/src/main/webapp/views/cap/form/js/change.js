function bindResize(el) {
            // 初始化参数
	var els = el.style,
            // 鼠标的 X 和 Y 轴坐标
            x = y = 0;
            // 邪恶的食指
            $(el).mousedown(function(e) {
                // 按下元素后，计算当前鼠标与对象计算后的坐标
                x = e.clientX - el.offsetWidth,
            y = e.clientY - el.offsetHeight;
                // 在支持 setCapture 做些东东
                el.setCapture ? (
                // 捕捉焦点
                el.setCapture(),
                // 设置事件
                el.onmousemove = function(ev) {
                    mouseMove(ev || event)
                },
                el.onmouseup = mouseUp
            ) : (
                // 绑定事件
                $(document).bind("mousemove", mouseMove).bind("mouseup", mouseUp)
            )
                // 防止默认事件发生
                e.preventDefault()
            });
            // 移动事件
            function mouseMove(e) {
                // 宇宙超级无敌运算中...
             /*   els.width = (e.clientX - x) + 'px',*/
            els.height = (e.clientY - y) + 'px'
            }
            // 停止事件
            function mouseUp() {
                // 在支持 releaseCapture 做些东东
                el.releaseCapture ? (
                // 释放焦点
                el.releaseCapture(),
                // 移除事件
                el.onmousemove = el.onmouseup = null
            ) : (
                // 卸载事件
                $(document).unbind("mousemove", mouseMove).unbind("mouseup", mouseUp)
            )
            }
        } 
$(function(){
	/*$('#back_color,#text_color').colpick({

		layout:'hex',

		submit:0,

		colorScheme:'dark',

		onChange:function(hsb,hex,rgb,el,bySetColor) {

			$(el).css('border-color','#'+hex);

			// Fill the text box just if the color was set using the picker, and not
			// the colpickSetColor 
			

			if(!bySetColor) $(el).val(hex);

		}

	}).keyup(function(){

		$(this).colpickSetColor(this.value);

	});*/
});
var eventid="";
function buttonEvents(e){
	eventid=e.id;
	$("#con_name").val(e.name);
	$("#con_id").val(e.id);
	$("#con_type").val(e.type);
	$("#con_height").val(e.style.height);
	$("#con_width").val(e.style.width);
	$("#is_visable");
	if(e.type=="text"){
		$("#def_value").val(e.defaultValue);
	}
}
function heightmouseout(e){
	$("#"+eventid).css("height",e.value);
}
function widthmouseout(e){
	$("#"+eventid).css("width",e.value);
}
function disablechange(e){
	var ischeck=$("#is_display").is(':checked')
	if(ischeck){
		$("#"+eventid).css("display","none");
	}
	$("#"+eventid).css("display","");
}
function disablchange(e){
	var ischeck=$("#is_disabled").is(':checked')
	if(ischeck){
		$("#"+eventid).attr("disabled","true");
	}else{
		$("#"+eventid).attr("disabled","false");
	}
}
function defmouseout(e){
	$("#"+eventid).attr("value",e.value);
}
function bcolormouseout(e){
	$("#"+eventid).css("background-color","#"+e.value);
}
function tcolormouseout(e){
	$("#"+eventid).css("color","#"+e.value);
}