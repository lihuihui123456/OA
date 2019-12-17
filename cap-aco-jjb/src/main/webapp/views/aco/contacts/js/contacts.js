	/*var startWord;
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
	}*/
	/*function validateIsLarger(){
		$(".word-select-ul li").each(function(){
			if($(this).attr("class")=="larger"){
				$(this).removeClass().addClass("normal");
				word="";
				$("#userList").bootstrapTable('refresh');
				return;
			}
		});	
		word="";
		$("#"+clickWord).removeClass().addClass("normal");
	}*/
	/*function queryByWord(id){
		var liVal=$("#"+id).text();
		if(clickWord!=null&&clickWord!=""){
			$("#"+clickWord).removeClass().addClass("normal");
		}
		if(clickWord!=id){
			$("#"+clickWord).removeClass().addClass("normal");
		}
		if($("#"+id).attr("class")=="larger"){
			$("#"+id).removeClass().addClass("normal");
			word="";
			clickWord="";
			$("#userList").bootstrapTable('refresh');
			return;
		}else{
			clickWord=id;
			$("#"+id).removeClass().addClass("larger");
		}
		if(liVal!=null&&liVal!=""){
			word=liVal;
			ajaxContactors();
			deptId="";
			type="";
			zTree.cancelSelectedNode();
			$("#input-word").val("请输入姓名/部门名称/电话/手机/电子邮件查询");
			userName="";
			$("#hidWord").val(liVal);
			$("#hidParam").val("");
			$("#hidDeptId").val("");
			$("#userList").bootstrapTable('refresh',{url:'bizContactsController/queryUserByDept',pageNumber: 10, pageSize: 10});
			
		}
	}*/
