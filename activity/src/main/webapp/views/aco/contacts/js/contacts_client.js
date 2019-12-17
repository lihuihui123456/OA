if (!Array.prototype.filter)
{
  Array.prototype.filter = function(fun /*, thisArg */)
  {
    "use strict";

    if (this === void 0 || this === null)
      throw new TypeError();

    var t = Object(this);
    var len = t.length >>> 0;
    if (typeof fun !== "function")
      throw new TypeError();

    var res = [];
    var thisArg = arguments.length >= 2 ? arguments[1] : void 0;
    for (var i = 0; i < len; i++)
    {
      if (i in t)
      {
        var val = t[i];

        // NOTE: Technically this should Object.defineProperty at
        //       the next index, as push can be affected by
        //       properties on Object.prototype and Array.prototype.
        //       But that method's new, and collisions should be
        //       rare, so use the more-compatible alternative.
        if (fun.call(thisArg, val, i, t))
          res.push(val);
      }
    }

    return res;
  };
}
var datas_all;
var depts_all;
var contactors_all;
var word_all;
var search_all;
var filter;
function gc(){
	word_all=null;
	search_all=null;
}
function queryOnceAll(){
	$.ajax({
		type: "POST",
		async: false,
		url: "bizContactsController/queryAllUserData",
		data: {},
		success: function (data) {
			datas_all=data;
			initTable(datas_all);
		}
	});
	$.ajax({
		type: "POST",
		async: false,
		url: "bizContactsController/queryAllDeptData",
		data: {},
		success: function (data) {
			depts_all=data;
		}
	});
	dbContactors();
}
var arr_dept_datas;
function dbContactors(){
	$.ajax({
		type: "POST",
		async: false,
		url: "bizContactsController/queryAllContactorsData",
		data: {},
		success: function (data) {
			contactors_all=data;
		}
	});
}
/**
 * 递归查询部门
 */
function recursiveDept(parentDeptId){
	var new_datas= datas_all.filter(function(param){
		  return param.deptId === parentDeptId;
	});
	
	for(var i=0;i<new_datas.length;i++){
		if(new_datas[i]!=null){
			arr_dept_datas.push(new_datas[i]);
		}
	}
	depts_all.filter(function(dept){
		  if(dept.parentDeptId === parentDeptId){
			  recursiveDept(dept.deptId);
		  }
	});
}
function zTreeOnClick(event,treeId,treeNode){
	arr_dept_datas=new Array();
	validateIsLarger();
	ajaxContactors();
	$("#hidDeptId").val(treeNode.id);
	$("#hidWord").val("");
	$("#hidParam").val("");
	if(treeNode.type=="0"){
		$('#userList').bootstrapTable('load',datas_all);
	}else if(treeNode.type=="3"||treeNode.type=="1"){
		dbContactors();
		$('#userList').bootstrapTable('load',contactors_all);
	}else{
		recursiveDept(treeNode.id);
		$('#userList').bootstrapTable('load',arr_dept_datas);
	}
	
}

var startWord;
var wordTotal;
var clickWord;
function createWord(){
	wordTotal=26;
	$(".word-select-ul").html("");
	for(var i=startWord;i<startWord+wordTotal;i++){
		$(".word-select-ul").append("<li id=\""+String.fromCharCode(i)+"\" onclick=\"queryByWord(this.id)\">"+String.fromCharCode(i)+"</li>");
	}
	var margin_top=($(".word-select").height()-$(".word-select-ul").height())/2;
	if(margin_top>10){
		margin_top=margin_top-10;
	}
	$(".word-select-ul").css("margin-top",margin_top); 
}
function queryArrayByWord(word){
	word_all= datas_all.filter(function(param){
		  return param.firstWord === word;
	});
}
function queryByWord(id){
	if(clickWord!=id){
		$("#"+clickWord).removeClass().addClass("normal");
	}
	zTree.cancelSelectedNode();
	word_all=new Array();
	queryArrayByWord(id);
	$("#hidWord").val(id);
	$("#hidParam").val("");
	$("#hidDeptId").val("");
	if($("#"+id).attr("class")=="larger"){
		$("#"+id).removeClass().addClass("normal");
		clickWord="";
		$('#userList').bootstrapTable('load',datas_all);
		return;
	}else{
		clickWord=id;
		$('#userList').bootstrapTable('load',word_all);
		$("#"+id).removeClass().addClass("larger");
		
	}
}
function validateIsLarger(){
	$("#"+clickWord).removeClass().addClass("normal");
}
function queryBySearch(filter){
	filter=$.trim(filter);
	search_all= datas_all.filter(function(param){
		if(param.userMobile==null){
			param.userMobile="";
		}
		if(param.userEmail==null){
			param.userEmail="";
		}
		if(param.userTelephone==null){
			param.userTelephone="";
		}
		return param.userName.indexOf(filter)!=-1||param.deptName.indexOf(filter)!=-1||param.userMobile.indexOf(filter)!=-1||param.userEmail.indexOf(filter)!=-1||param.userTelephone.indexOf(filter)!=-1;
	});
}
function search(){
	gc();
	filter=$("#input-word").val();
	if(filter=="请输入姓名/部门名称/电话/手机/电子邮件查询"){
		filter="";
	}
	$("#hidParam").val($("#input-word").val());
	$("#hidDeptId").val("");
	$("#hidWord").val("");
	zTree.cancelSelectedNode();
	validateIsLarger();
	search_all=new Array();
	queryBySearch(filter);
	$('#userList').bootstrapTable('load',search_all);
}
function operateCollect(userId,userName){
	var classProperty=$("#li"+userId).attr("class");
	if(classProperty=="contacts-star fa fa-star fa-size-self"){
		var toDeleteNode=zTree.getNodeByParam("id",userId,null);
		zTree.removeNode(toDeleteNode);
		deleteUser(userId);
		$("#li"+userId).removeClass().addClass("contacts-star fa fa-star-o fa-size-self");
		$("#viewUserIsInContacotors li").removeClass().addClass("contacts-star fa fa-star-o fa-size-introduce");
		//$("#userList").bootstrapTable('refresh');
	}else{
		var parentNode=zTree.getNodeByParam("id","alwaysContactors",null);
		var node={id:userId,name:userName,pId:"alwaysContactors",type:"3",icon:"./views/aco/contacts/images/contactors.png"};
		var tempNode=zTree.getNodeByParam("id",userId,null);
		if(tempNode==null){
			zTree.addNodes(parentNode,-1,node);
		}
		addUser(userId);
		$("#li"+userId).removeClass().addClass("contacts-star fa fa-star fa-size-self");
		$("#viewUserIsInContacotors li").removeClass().addClass("contacts-star fa fa-star fa-size-introduce");
	}
	modalFlag=1;
	
}
function addUser(userIds){
		var flag;
		$.ajax({
		type: "POST",
		async: false,
		url: "bizContactsController/addAlwaysContactors",
		data: {userIds:userIds},
		success: function (data) {
			flag=data;
		}
	});
	}
	function deleteUser(userIds){
		var flag;
		$.ajax({
		type: "POST",
		async: false,
		url: "bizContactsController/deleteAlwaysContactors",
		data: {userIds:userIds},
		success: function (data) {
			flag=data;
		}
	});
	}
