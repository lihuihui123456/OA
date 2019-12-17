/**
 * 手写签批插件：用于生成意见域
 * author : luzhw
 * date : 2017年4月24日
 */
;(function($, window, document, undefined) {
	$.fn.mySignature = function() {
		$(this).each(function() {
			var divId = this.id;
			if(divId == undefined || divId == "") {
				return;
			}
			if(divId.indexOf("Div") != -1){
				var id = divId.substring(0, divId.indexOf("Div"));
				var htmlStr = "<div class='commentEditDiv' id='"+id+"editDiv'>"
				+"<div class='form-group commentWz'>"
				+"<textarea class='form-control _form_data_control comment' id='"+id+"' name='"+id+"'"
				+"onpropertychange='if(value.length>2048) value=value.substr(0,2048)'></textarea></div>"
				+"<div class='form-group commentSx'>"
				+"<div><a href='javaScript:void(0);' onclick='openWindow(\""+id+"\");'>手写签批</a></div>"
				+"<div id='"+id+"signature'></div></div></div>"
				+"<div class='commentShowDiv' id='"+id+"showDiv'></div>";
				$(this).append(htmlStr);
			}
		})
	}
})(jQuery, window, document);

/*;(function($, window, document, undefined) {
	var Haorooms= function(el, opt) {
	    this.$element = el,
	    this.defaults = {
	        'color': 'red',
	        'fontSize': '12px',
	        'textDecoration':'none'
	    },
	    this.options = $.extend({}, this.defaults, opt)
	}
	//定义haorooms的方法
	Haorooms.prototype = {
	    changecss: function() {
	        return this.$element.css({
	            'color': this.options.color,
	            'fontSize': this.options.fontSize,
	            'textDecoration': this.options.textDecoration
	        });
	    }
	}
	$.fn.myPlugin = function(options) {
	    //创建haorooms的实体
	    var haorooms= new Haorooms(this, options);
	    //调用其方法
	    return haorooms.changecss();
	}
})(jQuery, window, document);*/