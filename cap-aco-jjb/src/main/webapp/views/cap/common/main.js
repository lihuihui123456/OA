
/**
 * 初始化页面相关函数
 */
$(function() {
	// 绑定Tab页的右键菜单
    $("#tabs_main").tabs({
        onContextMenu : function (e, title) {
            e.preventDefault();
            $('#tabs_menu').menu('show', {
                left : e.pageX,
                top : e.pageY
            }).data("tabTitle", title);
        }
    });

    // 实例化Tab页右键菜单的onClick事件
    $("#tabs_menu").menu({
        onClick : function (item) {
        	closeTab(this, item.name);
        }
    });
    
   //左侧一级菜单增加点击选中事件
    $("#accordion_nav .nav-item a").click(function(){
    	$(this).parent().addClass("nav-item-selected").siblings().removeClass("nav-item-selected");
    });
});

/**
 * 点击左侧菜单时，内容区域动态添加Tab标签
 * @param title Tab标签标题
 * @param href 链接
 */
function addTab(title, href) {
	// 处理演示版和试用版的Tab添加重复问题
	if (title.indexOf("演示版") > 0) {
		title = title.replace(" (演示版)", "");
	} else if (title.indexOf("试用版") > 0) {
		title = title.replace(" (试用版)", "");
	}
	var tt = $('#tabs_main');
	if (tt.tabs('exists', title)) {
		tt.tabs('select', title);
	} else {
		if (href) {
			var content = createFrame(href);
		} else {
			var content = '未实现';
		}
		tt.tabs('add', {
			title : title,
			closable : true,
			content : content
		});
	}
}

/**
 * 右边center区域打开菜单，关闭tab
 * @param title Tab标签标题
 * @param href 链接
 */
function closeTab(menu, type) {
    var curTabTitle = $(menu).data("tabTitle");
    var tabs = $("#tabs_main");

    if (type === "Close") {
        tabs.tabs("close", curTabTitle);
        return;
    }

    var allTabs = tabs.tabs("tabs");
    var closeTabsTitle = [];

    $.each(allTabs, function () {
        var opt = $(this).panel("options");
        if (opt.closable && opt.title != curTabTitle && type === "Other") {
            closeTabsTitle.push(opt.title);
        } else if (opt.closable && type === "All") {
            closeTabsTitle.push(opt.title);
        }
    });

    for (var i = 0; i < closeTabsTitle.length; i++) {
        tabs.tabs("close", closeTabsTitle[i]);
    }
}

/**
 * 关闭tab，并刷新父tab
 */
function closeAndReloadTab(closeText,reloadText) {
	var tabs = $("#tabs_main");
	tabs.tabs("close", closeText);
	//var tab = tabs.tabs("getTab", reloadText);

	var currTab = tabs.tabs('getTab', reloadText);
	var iframe = $(currTab.panel('options').content);
	var src = iframe.attr('src');
	tabs.tabs('update', { tab: currTab, options: { content: createFrame(src)} });
}

function createFrame(url) {  
    var frame = '<iframe id="mainFrame" name="mainFrame" scrolling="yes" frameborder="0"  src="' + url 
    + '" style=\"width:100%;height:100%;\"></iframe>';  
    return frame;  
}

function openPwdForm(){
	$("#password").val("");
	$("#newPassword").val("");
	$("#conPassword").val("");
	$('#pwdDialog').dialog('open');
}

var validRes;
function validPWd(){
	var pass = $('#password').val();

	if(pass == null || pass == "" ){
		$.messager.alert('提示', '请输入原密码！');
		return;
	}
	
	$.ajax( {
		url : path+'/userController/validPWd',
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
    	$.messager.alert('提示', '输入的原密码不正确！');
		return;
	}
}

function validNewPWd(){
	var newPassword = $("#newPassword").val();

	var reg = /^[0-9_a-zA-Z]{3,10}$/;
	if(!reg.test(newPassword)){
		$.messager.alert('提示', '密码必须是3到10位的字母数字下划线等的组合!');
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
		$.messager.alert('提示', '请输入密码！');
		return;
	}
	
	if(validRes == 'no'){
		$.messager.alert('提示', '输入的原密码不正确！');
		return;
	}
	if(newPassword != conPassword){
		$.messager.alert('提示', '两次输入的新密码不一致！');
		return;
	}

	var reg = /^[0-9_a-zA-Z]{3,10}$/;
	if(!reg.test(newPassword)){
		$.messager.alert('提示', '新密码必须是3到10位的字母数字下划线等的组合！');
        return;
    }
	$.ajax({
		url:path+'/userController/updatePwd',
		data:$('#pwdForm').serialize(),
		type:'post',
		success: function(data){
			if(data){
				$.messager.alert('提示', '密码修改成功！');
        	}else{
        		$.messager.alert('提示', '密码修改失败！');
        	}
			$('#pwdDialog').dialog('close');
		}
	})
}