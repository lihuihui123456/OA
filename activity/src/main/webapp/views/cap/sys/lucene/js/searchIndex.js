function searchData() {
	var name=navigator.appName;
	var type = $('#indextype').val();
	var sk = $("#input-word").val();
	if(sk=="请输入要搜索的内容"){
		sk="";
	}

	var url = "";
	if(isIE()){
		url = "../luceneController/searchIndex?page=1&indextype=" + type + "&sk=" + sk;
	}else{
		url = "luceneController/searchIndex?page=1&indextype=" + type + "&sk=" + sk;
	}

	location.href = url;
}

/**
 * 判断是否IE浏览器
 * 
 * @returns {Boolean} true 为IE浏览器 false 为其他浏览器
 */
function isIE() {
    if (!!window.ActiveXObject || "ActiveXObject" in window) {
    	return true;
    } else {
    	return false;
    }
}

function initDicData() {
	/** 查询字段信息 * */
	$.ajax({
		url : "dictController/findDictByTypeCode",
		type : "get",
		async : false,
		dataType : "json",
		data : {
			"dictTypeCode" : 'indextype'
		},
		success : function(data) {
			var control = $('#indextype');
			control.append("<option value='0'>&nbsp;全部</option>");
			$.each(data, function(i, item) {
				control.append("<option value='" + item.dictCode + "'>&nbsp;" + item.dictVal
						+ "</option>");
			});
			$("#indextype").val(_indextype);
		}
	});
}
function changeType() {
	var name=navigator.appName;
	var type = $('#indextype').val();
	var sk = $("#searchkey").val();
	if(name=="Microsoft Internet Explorer"){
		var url = "../luceneController/searchIndex?page=1&indextype=" + type + "&sk="
		+ sk;
		}else{
	    var url = "luceneController/searchIndex?page=1&indextype=" + type + "&sk="
			+ sk;
		}
	location.href = url;
	/*var url = "luceneController/searchIndex?page=1&indextype=" + type + "&sk="
			+ sk;
	location.href = url;*/
}
function openWinnew(id,url){
	var type=$("#indextype option:selected").text();
	var typeid=$('#indextype').val();
	var options={
			"text":"全文检索",
			"id":"home_search2"+typeid+"_"+id,
			"href":url,
			"pid":window,
			"isDelete":true,
			"isReturn":false,
			"isRefresh":false
	};
	window.parent.createTab(options);
}
$(function() {
	initDicData();
	var obj=$(".f13");
	var len=obj.size();
	if(len!=null&&len!=0){
		for(var i=0;i<len;i++){
			
			var leni=obj[i].children.length;
			var obji=obj[i].children;
			if(leni!=null&&leni!=0){
				for(var j=0;j<leni;j++){
					obji[j].innerHTML=obji[j].innerHTML.replace(/&nbsp;/g,"");
					obji[j].innerHTML=obji[j].innerHTML.replace(/strong/g,"span");
					obji[j].innerHTML=obji[j].innerHTML.replace(/em/g,"span");
					obji[j].innerHTML=obji[j].innerHTML.replace(/sup/g,"span");
					obji[j].innerHTML=obji[j].innerHTML.replace(/sub/g,"span");
					obji[j].innerHTML=obji[j].innerHTML.replace(/h1/g,"span");
					obji[j].innerHTML=obji[j].innerHTML.replace(/br/g,"span");
					obji[j].style="";
					var lenj=obji[j].children.length;
					var objj=obji[j].children;
					if(lenj!=null&&lenj!=0){
						for(var z=0;z<lenj;z++){
							
							var lenz=objj[z].children.length;
							var objz=objj[z].children;
							if(lenz!=null&&lenz!=0){
								objj[z].style="";
								/*for(var k=0;k<lenz;k++){
									objz[k].style="";
									var lenk=objz[k].children.length;
									var objk=objz[k].children;
									if(lenk!=null&&lenk!=0){
										for(var m=0;m<lenk;m++){
											objk[m].style="";
											var lenm=objk[m].children.length;
											var objm=objk[m].children;
										}
									}
								}*/
							}
						}
					}
				}
			}
		}
	}
});