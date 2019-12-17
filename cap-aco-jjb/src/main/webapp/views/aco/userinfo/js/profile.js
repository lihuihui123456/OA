
function submit(){
	$("#profile").submit();
}
function changeImg(){
	alert("修改头像");
}
function changeSave(){
	$.ajax({
		url:'uploader/changeData',
		data:$('#ff').serialize(),
		type:'post',
		success: function(data){
			$('#myModal').modal('hide');
			//刷新页签
			$('#profile').submit();
		}
	});
}

//二维码文件下载功能
$(function(){
	$('#appUpload').click(function(){
		var options = {
				"text" : "立即下载",
				"href" : "views/aco/userinfo/index.jsp",
				"pid":window
		};
		window.parent.createTab(options);
	});
})


function openPwd(){
	$("#password").val('');
	$("#newPassword").val('');
	$("#conPassword").val('');
	
	$('#mm').modal('show');
}

var validRes;
function validPWd(){
	var pass = $('#password').val();

	if(pass == null || pass == "" ){
		layerAlert("请输入原密码！");
		return;
	}
	
	$.ajax( {
		url : 'userController/validPWd',
		data:{pwd:pass},
		async: false,//同步
		cache: false,
		success : function(result) {
			validRes = result;
		},
		error : function(result) {
		}
	});

    if(validRes == 'no'){
    	layerAlert("输入的原密码不正确！");
		return;
	}
}

/*
 * 判断密码是否一致
 *
 */
var userPWd;
function getUserPWd(){
	var pass = $("#newPassword").val();
	$.ajax( {
		url : 'userController/getUserPWd',
		data:{pwd:pass},
		async: false,//同步
		cache: false,
		success : function(result) {
			userPWd = result;
		},
		error : function(result) {
		}
	});
	
	 if(userPWd == 'no'){
	    	layerAlert("新密码和原密码一致！");
			return;
		}
}

function validNewPWd(){
	var newPassword = $("#newPassword").val();

	var reg = /^[0-9_a-zA-Z]{3,10}$/;
	if(!reg.test(newPassword)){
		layerAlert('密码必须是3到10位的字母数字下划线等的组合!');
        return;
    }
}

function submitForm(){
	var password = $("#password").val();
	var newPassword = $("#newPassword").val();
	var conPassword = $("#conPassword").val();

	if(password == null || password == ''
			|| newPassword == null || newPassword == ''
			|| conPassword == null || conPassword == ''){
		layerAlert("请输入密码！");
		return;
	}
	
	if(validRes == 'no'){
		layerAlert("输入的原密码不正确！");
		return;
	}
	if(newPassword != conPassword){
		layerAlert("两次输入的新密码不一致！");
		return;
	}

	var reg = /^[0-9_a-zA-Z]{3,10}$/;
	if(!reg.test(newPassword)){
		layerAlert('新密码必须是3到10位的字母数字下划线等的组合!');
        return;
    }
	getUserPWd();
	if(userPWd == 'no'){
		layerAlert("新密码和原密码一致！");
		return;
	}
	$.ajax({
		url:'userController/updatePwd',
		data:$('#ff_mm').serialize(),
		type:'post',
		success: function(data){
			if(data){
				layerAlert("密码修改成功！");
        	}else{
        		layerAlert("密码修改失败！");
        	}
			$('#mm').modal('hide');
		}
	})
}