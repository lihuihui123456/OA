/** 
 * form表单校验规则
 */
$.extend($.fn.validatebox.defaults.rules, {  
    phone : {// 验证电话号码          
    	validator : function(value) {  
            return /^(0([3-9]\d\d|10|2[1-9])-?[2-8]\d{6,7})$/.test(value);  
        },  
        message : '电话号码格式不正确,请使用下面格式:***-********' 
    },  
    mobile : {// 验证手机号码          
    	validator : function(value) {  
            return /^((13[0-9])|(15[0-9])|(18[0-9]))\d{8}$/.test(value);  
        },  
        message : '手机号码格式不正确' 
    },  
    idcard : {// 验证身份证          
    	validator : function(value) {  
            return /^\d{15}(\d{2}[A-Za-z0-9])?$/.test(value);  
        },  
        message : '身份证号码格式不正确' 
    },  
    qq : {// 验证QQ,从10000开始          
    	validator : function(value) {  
            return /^[1-9]\d{4,9}$/.test(value);  
        },  
        message : 'QQ号码格式不正确' 
    },  
    chinese : {// 验证中文          
    	validator : function(value) {  
            return /^[\u0391-\uFFE5]$/.test(value);  
        },  
        message : '请输入中文' 
    },  
    english : {// 验证英语          
    	validator : function(value) {  
            return /^[A-Za-z]$/.test(value);  
        },  
        message : '请输入英文' 
    },  
    unnormal : {// 验证是否包含非法字符          
    	validator : function(value) {  
            return /^[A-Za-z0-9()（）\u4e00-\u9fa5-\w]+$/.test(value);  
        },  
        message : '包含非法字符' 
    },  
    username : {// 验证用户名          
    	validator : function(value) {  
            return /^[a-zA-Z0-9_]{2,18}$/.test(value);  
        },  
        message : '登录名称格式为：字母数字下划线组成，长度3-18位' 
    },  
    name : {        
    	validator : function(value) {  
    		return /^[\u4e00-\u9fa5_a-zA-Z]+$/.test(value);   
    	},  
    	message : '请输入中文或英文字符' 
    }, 
    ip : {// 验证IP地址          
    	validator : function(value) {  
            return /^((25[0-5]|2[0-4]\d|[1]?\d?\d)\.){3}((25[0-5]|2[0-4]\d|[1]?\d?\d)$)/.test(value);  
        },  
        message : 'IP地址格式不正确' 
    },  
    email:{  
        validator : function(value){  
	        return /^\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/.test(value);  
	    },  
	    message : '请输入有效的电子邮件账号'    
    }, 
    same:{  
        validator : function(value, id){  
            if($("#"+id).val() != "" && value != ""){  
                return $("#"+id).val() == value;  
            }else{  
                return true;  
            }  
        },  
        message : '两次输入的密码不一致'    
    },
    compareDate: { 
        validator: function (value, param) { 
        	return dateCompare($(param[0]).datetimebox('getValue'), value);          
        }, 
        message: '开始日期不能大于结束日期'
	},
	isBlank : {//验证空格
		validator: function (value, param) { 
        	return $.trim(value) != '';          
        }, 
        message: '不能为空'
	},
	modUrl : {
		validator: function (value, param) { 
        	return /^\/.*$/.test(value);          
        }, 
        message: '要以‘/’开头'
	},
	Number: {
        validator: function (value) {
            var reg =/^[0-9]*$/;
            return reg.test(value);
        },
        message: '请输入数字'
    }
});