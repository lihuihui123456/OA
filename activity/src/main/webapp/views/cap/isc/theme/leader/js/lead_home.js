/**
 * 加载自定义常用菜单
 */
function InitCustomizedMenu(){
	 $.ajax({
        url :'leaddtp/custmenu',
        dataType: 'json',
        async: true, //同步
        //data:{num:num},
		success: function (reVal) {
			var json = reVal;//返回List<Module>类型
			var output="";
            $.each (json, function (index, value){
            	var modName=value.modName;//节点名称
            	var modUrl=value.modUrl;
            	var isVrtlNode=value.isVrtlNode;//是否虚拟节点
            	var modId=value.modId;
            	if(index==0){
            		$("#modIds").val(modId);
            	}else{
            		$("#modIds").val($("#modIds").val()+","+modId);
            	}
            	var pModId=value.parentModId;
            	var color=new Array("red","blue","green");
    		 	var style=new Array("fa fa-folder-open","fa fa-user-plus","fa fa-area-chart","fa  fa-check-square-o","fa  fa-plus-square-o","fa fa-file-image-o");
    		 	var thiscolor=color[index%color.length];
            	if(isVrtlNode=="Y"){//先循环取出父节点
            		output+="<div class=\"custom-menu\"><h4>"+modName+"</h4>";//一级节点名称
            		 $.each (json, function (subIndex, subValue){//通过父节点查询子节点，第二次循环
            		 	var subIsVrtlNode=subValue.isVrtlNode;
            		 	var parentModId=subValue.parentModId;
            		 	if(subIsVrtlNode=="N"&&parentModId==modId){//非虚拟的子节点
            		 		output+=""+
            		 		"<a class="+thiscolor+" onclick=\"changeCheck(this.id)\" id='"+subValue.modId+"'>" +
		    				"<i class='"+style[subIndex%style.length]+"'></i>" +
							"<em class='unchecked' ></em>" +
							"<span>"+subValue.modName+"</span>" +
						"</a>";
            		 	}
            		 });
            		
            	}else{
            		if(pModId==null||pModId==""){
            			output+="<div class=\"custom-menu\"><h4>"+modName+"</h4>"+
	            		 		"<a class="+color[1]+" onclick=\"changeCheck(this.id)\" id='"+value.modId+"'>" +
			    					"<i class='"+style[1]+"'></i>" +
									"<em class='unchecked' ></em>" +
									"<span>"+value.modName+"</span>" +
								"</a>";
            		}
            	}
            	output+="</div>";
            });	
           
            $("#customized").html(output);
            InitChecked();
		},
		error: function (text) {
			//alert("执行出现异常！");
		}
	});
	
	
}
function getRootPath(){  
    //获取当前网址，如： http://localhost:8083/uimcardprj/share/meun.jsp  
    var curWwwPath=window.document.location.href;  
    //获取主机地址之后的目录，如： uimcardprj/share/meun.jsp  
    var pathName=window.document.location.pathname;  
    var pos=curWwwPath.indexOf(pathName);  
    //获取主机地址，如： http://localhost:8083  
    var localhostPaht=curWwwPath.substring(0,pos);  
    //获取带"/"的项目名，如：/uimcardprj  
    var projectName=pathName.substring(0,pathName.substr(1).indexOf('/')+1);  
    return(localhostPaht+projectName);  
} 
function openWindow(id,name){
	var url=$("#"+id+">input").val();
	var root=getRootPath();
	//window.open(root+url);
	var params={
		"id":id,
		"href":root+url,
		"text":name
	}
	createTab(params);
}
InitCustomizedMenu();
function changeCheck(value){
	if($("#"+value+">em").attr("class") == "unchecked"){
		$("#"+value+">em").removeClass().addClass("checked");
	}else{
		$("#"+value+">em").removeClass().addClass("unchecked");
	}
	var hiddenVal=$("#isChecked").val();
	if(hiddenVal==null||hiddenVal==""){
		$("#isChecked").val(value)
	}else{
		$("#isChecked").val(hiddenVal+","+value)
	}
}
function InitChecked(){
		$.ajax({
			url : 'leaddtp/getchecked',
			type : 'post',
			dataType: 'json',
			async : false,
			//data:{},
			success : function(reVal) {
				var shortcut_output="";
				var json = reVal;
				 $.each (json, function (index, value){
				 	var modId=value.modId;
				 	var modUrl=value.modUrl;
				 	var color=new Array("red","blue","green");
    		 		var style=new Array("fa fa-folder-open","fa fa-user-plus");
				 	$("#"+modId+">em").removeClass().addClass("checked");
				 	shortcut_output+="<a onclick=\"openWindow(this.id,'"+value.modName+"')\" class=\""+color[index%3]+"\" id=\"hid"+modId+"\">" +
            							"<i class=\""+style[index%2]+"\"></i>" +
            							"<span>"+value.modName+"</span>" +
            							"<input type=\"hidden\"  value=\""+modUrl+"\"/>"+
            						"</a>";
				 });
				  shortcut_output+="<a class=\"add-btn\" data-toggle=\"modal\" data-target=\"#changeModal\">+</a>";
				  $("#shortcut").html(shortcut_output);
			},
			error: function (text) {
				//alert("执行出现异常！");
			}
		});
}
function saveChecked(){
	$("#isChecked").val("");
	var count=calCheckedNum();
	if(count>4){
		layerAlert("自定义菜单不能超过4个");
		return false;
	}
	$.ajax({
			url : 'leaddtp/addallmenu',
			type : 'post',
			dataType : 'text',
			async : false,
			data :{
				"modIds":$("#isChecked").val()
			},
			success : function(data) {
				$("#changeModal").modal("hide");
				InitChecked();
			}
		});
}
function calCheckedNum(){
	var modId=$("#modIds").val().split(",");
	var count=0;
	for(var i=0;i<modId.length;i++){
		if($("#"+modId[i]+">em").attr("class") == "checked"){
			if($("#isChecked").val()==null||$("#isChecked").val()==""){
				$("#isChecked").val(modId[i]);
			}else{
				$("#isChecked").val($("#isChecked").val()+","+modId[i]);
			}
			count++;
		}
	}
	return count;
}

