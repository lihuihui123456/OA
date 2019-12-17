//作用：调入签章数据信息
function LoadSignature() {
	$.ajax({
		url : 'iWebRevisionController/toIWebRevisionEdit',
		type : 'post',
		data : {
			bizId : bizId,
			showType : style,
			taskId : taskId,
			procInstId : procInstId
		},
		dataType : 'json',
		async : false,
		success : function(data){
			$("OBJECT").each(function(index){
				this.InvisibleMenus("-2,-3,-4,-5,"); //“-2”代表的是“签名盖章”菜单，“-3”代表的是“文字批注“菜单，“-4”代表“签章信息”菜单，“-5”代表“撤销签章”菜单。
				this.RecordID = data.RecordID;
				this.WebUrl = data.mServerUrl;
				if(style == "draft" || style == "update"){
					this.Enabled = "0";
				}else if(style == "view"){
					this.Enabled = "0";
					this.LoadSignature(); //调用“会签”签章数据信息
				}
				else if(style == "deal"){
					//办理状态
					if($(this).attr('name') == commentColumn){
						this.Enabled = data.Enabled;
						this.UserName = data.userName;
						this.SetFieldByName('Flag', '2'); //全屏签批后自动计算放置位置
					}else{
						this.Enabled = "0";
					}
					this.LoadSignature(); //调用“会签”签章数据信息
				}
			});
		}
	});
}

//作用：控制Consult控件弹出窗口打开哪些TAB
function ConsultInvisiblePages(mIndex, objName){
	var object = $("OBJECT[name ='"+objName+"']")[0];
	if(object){
		if (!(object.Enabled)) {
			alert('该签章已被锁定，无权编辑！');
		} else {
			var mShowPage = object.ShowPage;
			if(mIndex==0){
				object.ShowPage = "0";
				object.InvisiblePages('1,2,');
			}else if(mIndex==1){
				object.ShowPage = "1";
				object.InvisiblePages('0,2,');
			}else if(mIndex==2){
				object.ShowPage = "2";
				object.InvisiblePages('0,1,');
			}
			object.ShowPage = mShowPage;
		}
	}
}





//作用：将Consult控件中的签批信息清除
function ConsultClearAll(objName) {
	var object = $("OBJECT[name ='"+objName+"']")[0];
	if(object){
		if (!(object.Enabled)) {
			alert('该签章已被锁定，无权编辑！');
		} else {
			object.ClearAll();
		}
	}
}

//切换审批方式
function change(action, aObj) {
	var tableObj = $(aObj).parent().parent().parent();
	var sx = tableObj.find('tr.sx');
	var wz = tableObj.find('tr.wz');
	if (action == 'wz') {
		sx.css({
			'display' : "none"
		});
		wz.css({
			'display' : "table-row"
		});
	}
	if (action == 'sx') {
		sx.css({
			'display' : "table-row"
		});
		wz.css({
			'display' : "none"
		});
	}
}

//作用：保存签章数据信息  
//保存流程：先保存签章数据信息，成功后再提交到DocumentSave，保存表单基本信息
function SaveSignature() {
	var object = $("OBJECT[name ='"+commentColumn+"']")[0];
	if(object){
		if (object.Modify) { //判断签章数据信息是否有改动
			if (!object.SaveSignature()) { //保存签章数据信息
				alert("保存会签签批内容失败！");
				return false;
			}
		}
		return true;
	}else{
		return true;
	}
	
}

$(function(){
	/**
	 * style表示当前表单以什么方式打开  deal:办理  view：查看  draft:拟稿  update:修改
	 * 通过自定义的class属性来控制表单读写权限
	 * input 表示输入控件  comment 表示意见框  select表示通过选择方式来实现录入的控件
	 */
	if(style == "deal") {
		$('.commentTable').addClass("show");
	}
	if(style == "draft" || style == "update" ) {
		$('.commentTable').addClass("hide");
	}
	if(style == "view") {
		$('.commentTable').addClass("show");
	}
	var tableId = commentColumn+"table";
	$("#"+tableId).find('a.commentButton').show();
})
