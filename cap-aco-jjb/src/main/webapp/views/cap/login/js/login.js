/**
 * 页面监听函数
 */
$(function(){
	/**
	 * 当点击回车时执行登录操作
	 * keyCode == 13 为回车监听码
	 */
	document.onkeydown = function(e){ 
   	    var ev = document.all ? window.event : e;
   	    if(ev.keyCode==13) {
   	    	login();
   	    }
   	}
	
	/** 错误信息 */
	var error = $("#errorMsg").text();
	/** 是否为IE浏览器 */
	var isIE = false;
	if ((navigator.userAgent.indexOf('MSIE') >= 0) && (navigator.userAgent.indexOf('Opera') < 0)) {
		isIE = true;
	}
	
	/**
	 * 如果登陆失败，则清除密码
	 * */
	if (error =! null && error != "" && error != undefined) {
		$.cookie("password", "", {
			expires : 30,
			path : "/"
		});
	}
	
	/**
	 * 清空用户名输入框
	 * */
	$("#removeName").click(function(){
		$("#username").val("").focus();
	});
	
	/**
	 * 清空密码输入框
	 * */
	$("#removePwd").click(function(){
		$("#password").val("").focus();
	});
	
	/**
	 * 如果用户名cookie存在，则改变记住密码状态已图片路径
	 * */
	var imgpath = "views/cap/login/images/";
	if($.trim($.cookie('username'))!=''){
		$("#username").val($.cookie('username'));
		$("#password").focus();
	} else {
		if (username != null && username != "") {
			$("#username").val(username);
			$("#password").focus();
			$("#removeName").show();
		} else {
			$("#username").val("").focus();
			$("#removeName").show();
		}
	}
	
	/**
	 * 如果密码cookie存在，则填充密码输入框
	 * */
	if($.trim($.cookie('password'))!=''){
		if (error == null || error == "" || error == undefined) {
			$("#password0").hide();
			var type = $("#password").attr("type");
			/** IE8 type属性为只读，为解决兼容 */
			if (isIE) {
				$("#password").remove();
				$("#password0").after('<input type="password" id="password" name="password" />');
			} else {
				if (type == 'text') {
					$("#password").attr("type","password");
				}
			}
			$("#password").val($.cookie('password')).show().focus();
			$("#removePwd").show();
			/** 解决IE8 光标定位问题 */
			var obj = document.getElementById("password");
			var valLength = obj.value.length;
			setCaretPosition(obj,valLength);
		} else {
			var type = $("#password").attr("type");
			if (isIE) {
				$("#password").remove();
				$("#password0").after('<input type="password" id="password" name="password" />');
			} else {
				if (type == 'password') {
					$("#password").attr("type","text");
				}
			}
			$("#password0").hide();
			$("#password").val("").show().focus();
			$("#removePwd").show();
		}
	} else {
		if ((error =! null && error != "" && error != undefined) || $("#username").val() != '') {
			var type = $("#password").attr("type");
			if (isIE) {
				$("#password").remove();
				$("#password0").after('<input type="password" id="password" name="password" />');
				$("#password0").hide();
				$("#password").val("").focus();
				$("#removePwd").show();
			} else {
				if (type == 'password') {
					$("#password").attr("type","text");
				}
				$("#password0").hide();
				$("#password").val("").show().focus();
				$("#removePwd").show();
			}
		}
	}
	
	/**
	 * 1、用户名框获取焦点事件
	 * 	  当用户名框获取焦点时，将提示“请输入用户名\邮箱\手机”信息清空
	 * 2、用户名框失去焦点事件
	 *    当用户名框失去焦点时，如果用户名框为空值则将“请输入用户名\邮箱\手机”信息重新填入
	 */
    $("#username").focus(function(){
    	if($.trim($(this).val())=='请输入用户名\\邮箱\\手机'){
    		$(this).val('');
    	}
    	$("#removeName").show();
    }).blur(function(){
    	if($.trim($(this).val())==''){
    		$(this).val("请输入用户名\\邮箱\\手机");
    		$("#removeName").hide();
    	}
    });
    
    /**
	 * 1、密码框获取焦点事件
	 * 	  当密码框获取焦点时，将提示“请输入密码”信息清空
	 * 2、密码框失去焦点事件
	 *    当密码框失去焦点时，如果密码框为空值则将“请输入密码”信息重新填入
	 * 3、密码框值改变时，将type变为password(兼容chrome)
	 */
    $("#password0").focus(function(){
    	$(this).hide();
    	if (isIE) {
			$("#password").remove();
			$("#password0").after('<input type="password" id="password" name="password" />');
			$("#password").blur(function(){
				if($.trim($(this).val())==''){
					$(this).hide();
					$("#password0").val("请输入密码").show();
					$("#removePwd").hide();
				}
			});
		} else {
			if (type == 'text') {
				$("#password").attr("type","password");
			}
		}
    	$("#password").val("").show().focus();
    	$("#removePwd").show();
    })
    $("#password").blur(function(){
		if($.trim($(this).val())==''){
			$(this).hide();
			$("#password0").val("请输入密码").show();
			$("#removePwd").hide();
		}
	});
    
    /** 解决chrome自动填充表单问题 */
    if (!isIE) {
    	$("#password").on('input',function(e){
    		/**解决火狐浏览器光标乱跳问题*/
    		var obj = document.getElementById("password");
			var valLength = obj.value.length;
			setCaretPosition(obj,valLength);
    		var type = $(this).attr("type");
    		if (type == "text") {
    			$(this).attr("type","password");
    		}
    	});
	}
    
    /**
	 * 如果记住密码cookie值为1，则自动登录为选中状态，值设为1；
	 * 反之，记住密码为不选中状态，值设为0
	 * */
	if ($.trim($.cookie('rememberme')) == 1) {
		$("#remember_btn").attr("src",imgpath+"remember.png");
        $("#rememberme").val(1);
	} else {
		$("#remember_btn").attr("src",imgpath+"no_remember.png");
        $("#rememberme").val(0);
	}
    
	/**
	 * 如果自动登录cookie值为1，则自动登录为选中状态，值设为1，并且执行登陆操作；
	 * 反之，自动登录为不选中状态，值设为0
	 * */
	if ($.trim($.cookie('autoSubmit')) == 1) {
		$("#autosubmit_btn").attr("src",imgpath+"remember.png");
        $("#autoSubmit").val(1);
		login();
	} else {
		$("#autosubmit_btn").attr("src",imgpath+"no_remember.png");
        $("#autoSubmit").val(0);
	}
	
	/**
	 * 监听记住秘密点击事件
	 * */
    $("#remember_btn").click(function(){
        var img_btn = $("#remember_btn");
        var img_attr = img_btn.attr("src");
        if(img_attr == imgpath+"no_remember.png"){
            img_btn.attr("src",imgpath+"remember.png");
            $("#rememberme").val(1);
        }else{
            img_btn.attr("src",imgpath+"no_remember.png");
            $("#rememberme").val(0);
            /** 不记住我，不能自动登录 */
            $("#autosubmit_btn").attr("src",imgpath+"no_remember.png");
            $("#autoSubmit").val(0);
        }
    });
    
    /**
     * 监听自动登录点击事件
     * */
    $("#autosubmit_btn").click(function(){
        var img_btn = $("#autosubmit_btn");
        var img_attr = img_btn.attr("src");
        if(img_attr == imgpath+"no_remember.png"){
            img_btn.attr("src",imgpath+"remember.png");
            $("#autoSubmit").val(1);
            $("#remember_btn").attr("src",imgpath+"remember.png");
            $("#rememberme").val(1);
        }else{
            img_btn.attr("src",imgpath+"no_remember.png");
            $("#autoSubmit").val(0);
        }
    });
});
function remember(){
	if ($("#rememberme").val() == 1) {
		$.cookie("username", $("#username").val(), {
			expires : 30,
			path : "/"
		});
		$.cookie("password", $("#password").val(), {
			expires : 30,
			path : "/"
		});
	} else {
		$.cookie("username", $("#username").val(), {
			expires : 30,
			path : "/"
		});
		$.cookie("password", "", {
			expires : 30,
			path : "/"
		});
	}
	$.cookie("rememberme", $("#rememberme").val(), {
		expires : 30,
		path : "/"
	});
	$.cookie("autoSubmit", $("#autoSubmit").val(), {
		expires : 30,
		path : "/"
	});
}

/**
 * 登录校验
 *   1、判断用户名或密码是否为空
 *   2、判断用户名或密码是否包含特殊字符
 *   3、判断用户名或密码长度是否超长
 */
function valid(){
	var userName = $.trim($("#username").val());
	var password = $.trim($("#password").val());
	/*if(userName == '请输入用户名\\邮箱\\手机'){
		$("#username").val('');
	}
	if(password == '请输入密码'){
		$("#password").val('');
	}*/

	// 判断用户民或密码是否为空
	if (userName == '' || userName.length == 0 || userName == '请输入用户名\\邮箱\\手机') {
		$("#login_btn").append('<span id="errorspan"><i class="fa fa-minus-circle"> 用户名不能为空！</i></span>');
		$("#username").val("").focus();
		return false;
	}
	if (password == '' || password.length == 0 || password == '请输入密码') {
		$("#login_btn").append('<span id="errorspan"><i class="fa fa-minus-circle"> 密码不能为空！</i></span>');
		$("#password0").hide();
		$("#password").val("").show().focus();
		return false;
	}
	
	//判断非法字符
	var regu =/^[a-z0-9A-Z@._\u4e00-\u9fa5]+$/;
	var re = new RegExp(regu);
	if (!re.test(userName)) {
		$("#login_btn").append('<span id="errorspan"><i class="fa fa-minus-circle"> 非法登录，包含非法字符！</i></span>');
		return false;
	}
	if (!re.test(password)) {
		$("#login_btn").append('<span id="errorspan"><i class="fa fa-minus-circle"> 非法登录，包含非法字符！</i></span>');
		return false;
	}
	return true;
}

/**
 * 设置光标位置兼容IE/FF
 * @param tObj
 * @param sPos
 * 
 例：
  var obj =document.getElementById("tx1");  
        var sPos = obj.value.length-1;  
        setCaretPosition(obj, sPos);  
 */
function setCaretPosition(tObj, sPos){  
    if(tObj && sPos){
        if(tObj.setSelectionRange){  
            setTimeout(function(){  
                tObj.setSelectionRange(sPos, sPos);  
                tObj.focus();  
            }, 0);  
        }else if(tObj.createTextRange){  
            var rng = tObj.createTextRange();  
            rng.move('character', sPos);  
            rng.select();  
        }  
    }
}

/**
 * 表单提交
 * */
function login(){
	remember();
	if(valid()){
		// 修改点击登录按钮时文字显示
		$("#loginbtn").text("正在登录...");

		// 禁用登录按钮，防止重复提交
		$("#loginbtn").attr("href", "javascript:void(0)");

		// 提交登录form表单
		var form = document.forms[0];
		form.action = 'login';
		form.method = "post";
		form.submit();
		//$(".login_btn").find("a").unbind("click");//防止重复提交
	}
}