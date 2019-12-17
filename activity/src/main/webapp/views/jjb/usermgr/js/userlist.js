var url;
var action;
var checkId = -1;
var myArr = "";
$(document).ready(function(){
	initTable();
	$("#fff").hide();
	$("#mt_btn_new").click(function() {
		checkId = -1;
		userType='0';
		var userId='';
		var edittype='open';
		$('#userRadio').show();
		$('#userType-0').attr('checked', true);
		$('#mainBody_iframe').attr('src', "userManager/toUserPage?userType="+userType+"&edittype="+edittype+"&userId="+userId);
		$('#myModalLabel').text('员工资料');
		url = 'userManager/doAddUserInfo';
		showOrHideModal('open');
	});

	// 修改按钮
	$("#mt_btn_edit").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行修改！");
			return flse;
		}
		var userId = selectRow[0].userId;
		var userDutyTyp = selectRow[0].userDutyTyp;
		checkId = userId;
		var edittype='edit';
		$('#userRadio').hide();
		$('#mainBody_iframe').attr('src',  "userManager/toUserPage?userType="+userDutyTyp+"&edittype="+edittype+"&userId="+userId);
		$('#myModalLabel').text('员工资料');
		url = 'userManager/doUpdateUserInfo';
		showOrHideModal('open');
	});
	
	// 查看
	$("#mt_btn_view").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length != 1) {
			layerAlert("请选择单行进行查看！");
			return flse;
		}
		var userId = selectRow[0].userId;
		var userDutyTyp = selectRow[0].userDutyTyp;
		checkId = userId;
		var edittype='hide';
		$('#userRadio').hide();
		$('#mainBody_iframe').attr('src',  "userManager/toUserPage?userType="+userDutyTyp+"&edittype="+edittype+"&userId="+userId);
		$('#myModalLabel').text('员工资料');
		showOrHideModal('hide');
	});
	
	// 删除按钮
	$("#mt_btn_delete").click(function() {
		var selectRow = $("#dtlist").bootstrapTable('getSelections');
		if (selectRow.length == 0) {
			layerAlert("请选择操作项！");
			return false;
		}
		var ids = [];
		var flag=0;
		var users='';
		var user='';
		$(selectRow).each(function(index) {
			ids[index] = selectRow[index].userId;
			if(selectRow[index].userSource!=1){
				flag=1;
				users=users+selectRow[index].userName+'，';
			}
		});
		if(flag!=0){
			user=users.substring(0,users.length-1);
			layerAlert(user+"是系统用户，不能删除！");
			return false;
		}
		layer.confirm('确定删除吗？', {
			btn : [ '是', '否' ]
		}, function() {
			$.ajax({
				url : 'userManager/doDelUserInfo',
				dataType : 'json',
				data : {
					ids : ids
				},
				success : function(data) {
					if(data != 0){
						layerAlert("删除失败");
					} else{
						layerAlert("删除成功");
					}
					$("#dtlist").bootstrapTable('refresh');
				},
				error : function(result) {
					layerAlert(result);
				}
			});
		});
	});
	
	// 导出
	$("#mt_btn_export").click(function() {
		myArr = userName+"&"+userAge+"&"+userSex+"&"+deptName+"&"+postName+"&"+entryTime+"&"+userDutyTyp;
		myArr = window.encodeURI(window.encodeURI(myArr));
		var action="userManager/exportUserInfoToExcel/"+myArr;
		$("#exportUserInfoToExcel").attr("action",action);
		$("#exportUserInfoToExcel").submit();
	});
});

var userName='';
var userAge=''; 
var userSex=''; 
var deptName=''; 
var postName=''; 
var entryTime='';
var userDutyTyp='';
function initTable(){
	$('#dtlist').bootstrapTable({
		url : 'userManager/findAllUser', // 请求后台的URL（*）
		method : 'get', // 请求方式（*）
		striped : true, // 是否显示行间隔色
		cache : false,// 是否使用缓存，默认为true，所以一般情况下需要设置一下这个属性（*）
		pagination : true, // 是否显示分页（*）
		sortable : false, // 是否启用排序
		sortOrder : "asc", // 排序方式
		queryParams : function(params) {
			var temp = {// 这里的键的名字和控制器的变量名必须一直，这边改动，控制器也需要改成一样的
					rows : params.limit, // 页面大小
					page : params.offset, // 页码
					userName:$("#input-word").val()=="请输入人员名称"?"":$("#input-word").val(),
			        userAge:$("#userAge").val(),
			        userSex:$("#userSex").val(),
			        deptName: $("#deptName").val(),
			        postName:$("#postName").val(),
			        entryTime:$("#entryTime").val(),
			        userDutyTyp:$("#userDutyTyp").val()
				};
				return temp;
			}, // 传递参数（*）
		sidePagination : "server", // 分页方式：client客户端分页，server服务端分页（*）
		pageNumber : 1, // 初始化加载第一页，默认第一页
		pageSize : 10, // 每页的记录行数（*）
		pageList : [ 10, 25, 50, 100 ], // 可供选择的每页的行数（*）
		search : false, // 是否显示表格搜索，此搜索是客户端搜索，不会进服务端，所以，个人感觉意义不大
		strictSearch : false,
		showColumns : false, // 是否显示所有的列
		showRefresh : false, // 是否显示刷新按钮
		minimumCountColumns : 2, // 最少允许的列数
		clickToSelect : true, // 是否启用点击选中行
		uniqueId : "userId", // 每一行的唯一标识，一般为主键列
		showToggle : false, // 是否显示详细视图和列表视图的切换按钮
		cardView : false, // 是否显示详细视图
		detailView : false, // 是否显示父子表
		singleSelect : false,
		columns : [ {
			field : 'ck',
			checkbox : true
		}, {
			field : 'index',
			title : '序号',
			align : 'center',
			formatter : function(value, row, index) {
				return index + 1;
			}
		}, {
			field : 'userName',
			title : '姓名',
			align : 'left'
		}, {
			field : 'userSex',
			title : '性别',
			align : 'left',
			formatter : function(value, row) {
				if(value == '0') 
					return '女';
				if(value == '1') 
					return '男';
				if(value == '2')
					return '未知';
				return '';
			}
		}, {
			field : 'userBitrth',
			title : '出生日期',
			align : 'center'
		}, {
			field : 'userAge',
			title : '年龄',
			align : 'center'
		},{
			field : 'userEducation',
			title : '学历',
			align : 'center'
		},{
			field : 'userPoliceType',
			title : '政治面貌',
			align : 'center'
		},{
			field : 'joinTime',
			title : '入党时间',
			align : 'center'
		},{
			field : 'workTime',
			title : '工作时间',
			align : 'center'
		},{
			field : 'userSource',
			title : '用户来源',
			visible:false
		},{
			field : 'userDutyTyp',
			title : '用户类型',
			visible:false
		}],
		onDblClickRow : function(row, tr) {
			var id = row.userId;
			var userId = row.userId;
			var userDutyTyp = row.userDutyTyp;
			var type='hide';
			$('#userRadio').hide();
			$('#mainBody_iframe').attr('src',  "userManager/toUserPage?userType="+userDutyTyp+"&edittype="+type+"&userId="+userId);
			$('#myModalLabel').text('员工资料');
			showOrHideModal('hide');
		}
	});
}

function searchUserInfo() {
	userName = $("#input-word").val();
	if(userName == '请输入人员名称'){
		userName="";
	}else{
		var reg = /^[A-Za-z0-9\u4e00-\u9fa5-\w]+$/;     
		if(userName.match(reg)==null){
			layerAlert("输入内容含有非法字符！");
			return;
		}
	}
	$("#dtlist").bootstrapTable('refresh',{
		url : 'userManager/findAllUser',
		query:{
			userName : userName
		}
	});
}
//打开高级搜索弹出页面
function searchWindow(){
	clearForm();
	if($("#fff").is(":hidden")){
		$("#input-word").hide();
		$("#search").hide();
		$("#query").text("返回");
		$("#fff").show();
	}else{
		$("#input-word").show();
		$("#search").show();
		$("#query").text("高级查询");
		$("#fff").hide();
	}	
}

//高级搜索
function submitForm(){
	userAge = $("#userAge").val();
	userSex = $("#userSex").val();
	deptName = $("#deptName").val();
	postName = $("#postName").val();	
	entryTime = $("#entryTime").val();
	userDutyTyp = $("#userDutyTyp").val();
	$("#dtlist").bootstrapTable('refresh',{
		url : 'userManager/findAllUser',
		query:{
			userAge:userAge,
	        userSex:userSex,
	        deptName: deptName,
	        postName:postName,
	        entryTime:entryTime,
	        userDutyTyp:userDutyTyp
		}
	});
}
//重置表单
function clearForm(){
	document.getElementById("fff").reset();
	clear();
	$("#dtlist").bootstrapTable('refresh');
}

function showOrHideModal(action){
	if(action =='open'){
		$('#btnDiv1').show();
		$('#btnDiv2').hide();
	}else{
		$('#btnDiv1').hide();
		$('#btnDiv2').show();
	}
	$('#myModal').modal({
		backdrop : 'static',
		keyboard : false
	});
}

/**新增或者修改人员信息保存方法*/
function doSave(){
    document.getElementById('mainBody_iframe').contentWindow.doSave(url);
}
function closeDialog(){
	$('#myModal').modal('hide');
	$("#dtlist").bootstrapTable('refresh');
	checkId = -1;
}
function clear(){
	userAge=''; 
    userSex=''; 
	deptName=''; 
	postName=''; 
	entryTime='';
	userDutyTyp='';
}