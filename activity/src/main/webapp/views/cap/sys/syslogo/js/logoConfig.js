/**
 * 登录页logo图片更换
 * @author 王建坤
 * 
 * 选择文件后，将文件上传到服务器，再将服务器生成的文件下载到客户端
 * 注：为了防止浏览器无法读取本地文件，故需要上传文件到客户端后再读取
 */
function loginFileOnchange() {
	var picSrc = $('#loginFile').filebox('getValue');
	if (picSrc.indexOf(".jpg") < 0 && picSrc.indexOf(".jpeg") <0 && picSrc.indexOf(".png") < 0 && picSrc.indexOf(".bmp") < 0) {
		$.messager.alert('提示', '仅支持jpg、jpeg、png、bmp格式图片，请重新选择！', 'info');
		//$("#picResFile").filebox('setValue', '');
		return;
	}
	// 当选择图片后上传图片到服务器，再下载
	// 注：未放置不能读取本地文件故需先上传后再下载写入到IMG控件中
	$('#loginForm').form('submit', {
		url : 'sysLogoController/upfileImg?logo=login',
		success:function(data){
			$("#loginImg").attr("src", "sysLogoController/doDownLoadPicFile?picPath=" + data + "&r=" + new Date());
		},
		error:function(data){
			alert("执行出现异常");
		}
	});
}

/**
 * 主页logo图片更换
 * @author 王建坤
 * 
 * 选择文件后，将文件上传到服务器，再将服务器生成的文件下载到客户端
 * 注：为了防止浏览器无法读取本地文件，故需要上传文件到客户端后再读取
 */
function mainFileOnchange() {
	var picSrc = $('#mainFile').filebox('getValue');
	if (picSrc.indexOf(".jpg") < 0 && picSrc.indexOf(".jpeg") <0 && picSrc.indexOf(".png") < 0 && picSrc.indexOf(".bmp") < 0) {
		$.messager.alert('提示', '仅支持jpg、jpeg、png、bmp格式图片，请重新选择！', 'info');
		//$("#picResFile").filebox('setValue', '');
		return;
	}
	// 当选择图片后上传图片到服务器，再下载
	// 注：未放置不能读取本地文件故需先上传后再下载写入到IMG控件中
	$('#mainForm').form('submit', {
		url : 'sysLogoController/upfileImg?logo=main',
	    success:function(data){
	    	$("#mainImg").attr("src", "sysLogoController/doDownLoadPicFile?picPath=" + data + "&r=" + new Date());
	    },
	    error:function(data){
	    	alert("执行出现异常");
	    }
	});
}

function reload(){
	
}

var flag = "";
function addDlLogo(type){
	flag = type;
	$("#logoName").textbox('setValue',"");
	$("#filePath").filebox('setValue',"");
	$('#logoDialog').dialog('open');
}

/**
 * 保存
 * 
 * @param 无
 * @param 无
 */
function doUpfileImg() {
	if(!$('#logoForm').form('validate')){
		return;
	}

	var url = "sysLogoController/doUpfileImg?type="+flag+"&sysType="+sysType;

	var picSrc = $('#filePath').filebox('getValue');
	if (picSrc.indexOf(".jpg") < 0 && picSrc.indexOf(".jpeg") <0 && picSrc.indexOf(".png") < 0 && picSrc.indexOf(".bmp") < 0) {
		$.messager.alert('提示', '仅支持jpg、jpeg、png、bmp格式图片，请重新选择！', 'info');
		return;
	}
	
	$('#logoForm').form('submit', {
		url : url,
	    success:function(data){
	    	$.messager.show({ title:'提示', msg:'保存成功！', showType:'slide' });
			$('#logoDialog').dialog('close');
			window.location.reload();
	    },
	    error:function(data){
	    	alert("执行出现异常");
	    }
	});
}

function setUsed(logoName,isUsed,type){
	if (isUsed == "Y") {
		return;
	}
	$.ajax({
		url : 'sysLogoController/setUsed',
		type : "post",
		data : {
			logoName : logoName,
			type : type,
			sysType : sysType
		},
		success : function(data) {
			window.location.reload();
		},
		error : function(data) {
			alert("服务器出错，创建失败");
		}
	});
}

function removeLogo(logoName,isUsed,type){
	if (isUsed == "Y") {
		logoName = logoName + "_sel";
	}
	$.messager.confirm('提示', '确定删除吗?', function(r) {
		if (r) {
			$.ajax({
				url : 'sysLogoController/removeLogo',
				type : "post",
				data : {
					logoName : logoName,
					type : type,
					sysType : sysType
				},
				success : function(data) {
					window.location.reload();
				},
				error : function(data) {
					alert("服务器出错");
				}
			});
		}
	});
}