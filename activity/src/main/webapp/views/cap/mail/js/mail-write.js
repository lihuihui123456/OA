/**
 * 附件操作
 */
	/**
	 * 引入文件
	 */
	function add() {
		var resultStr = window.showModalDialog(rootPath+"/media/pluploadMail?chunk=false&url="+rootPath+"/emailAtt/doUploadAttachment&attEachLimit="+attEachLimitGlobal,
						window,
						"dialogWidth:500px; dialogHeight: 310px; help: no; scroll: no; status: no");
		if (resultStr == '1') {
			refresh();
		}
	}
	/**
	 * 刷新列表-获取数据
	 */
	function refresh() {
		$("#mail_att_list").empty();
		$.ajax({
			type : "POST",
			url : rootPath+"/emailAtt/doGetAttachment",
			data : {
			},
			success : function(msg) {
				//alert(msg.length);
				if (!!msg&&msg.length>0) {
					
					for(var i=0; i<msg.length; i++){
						var downloadUrl = rootPath+'/emailAtt/doDownloadTempAttachment?attUUID='+msg[i].uuid+'&fileName='+$.trim(msg[i].attname);
						var attName=$('<a href="'+downloadUrl+'" > <i class="fa fa-paperclip"> </i>'+msg[i].attname+'<span>('+msg[i].sizeShown+')</span>'+'</a>');
						var del=$('<a onclick="delsingle(\''+msg[i].uuid+'\');" class="btn btn-link btn-add">删除</a>');
						var listItem=$('<div class="attach_list"></div>').append(attName).append(del);
						$(listItem).appendTo("#mail_att_list");
						$('<div class="clearfix"></div>').appendTo("#mail_att_list");
					}
				}else{
					$("#mail_att_list").empty();
				}
			}
		});
	}
	/**
	 * 删除单个附件
	 */
	function delsingle(documentId) {
		$.ajax({
			type : "POST",
			url : rootPath+"/emailAtt/doDelAttachment",
			data : {
				attIds : documentId
			},
			success : function(msg) {
				if ($.trim(msg) == "true") {
					refresh();
				} else if ($.trim(msg) == "false") {
					layerAlert("操作失败！");
				}
			}
		});
	}
	/**
	 * 删除所有附件
	 */
	function delAll(){
		$.ajax({
			type : "POST",
			url : rootPath+"/emailAtt/doDelAllAttachment",
			success : function(msg) {
				if ($.trim(msg) == "true") {
					refresh();
				} else if ($.trim(msg) == "false") {
					layerAlert("操作失败！");
				}
			}
		});
	}
	
	
	function checkToExist() {
		var to="";
		to = $("#inputEmail0").val();
		if(typeof(to)=="undefined"){
			to = null;
		}
		//前台收件人邮箱地址简单格式验证
		if(to!=""){
			var tempto=to;
			tempto=tempto.replace(/</g,"");
			tempto=tempto.replace(/>/g,"");
			var pattern = new RegExp("^\([\.a-zA-Z0-9_-])+" + mailDomain + "()+","");
			
			tempto=tempto.replace(/\s/g,""); 
			var tempTolist=tempto.split(",");
			
			for(var i=0; i<tempTolist.length;i++){
	   			if(tempTolist.length>0&&tempTolist[i]==""){
	       			layerAlert("收信人地址不能以逗号结尾或者有多个逗号"); 
	       			return;
	   			}else{
	   				if (!pattern.test(tempTolist[i])) {
		    			layerAlert(tempTolist[i] +"：收信人地址格式不正确!");  
		    			return; 
	   				}
	   			}
			}
			//TODO
			//validateAddress();
		}else{
			layerAlert("收件人地址为空！");
		}
		
	}

	function checkCcExist(){
		//get cc value	    	
		cc = $("#inputEmail1").val();
		if(typeof(cc)=="undefined"){
			cc = null;
		}
		//前台转发人邮箱地址简单格式验证
		if(cc!=""){
			var tempto='';
	    	tempto=cc;
	    	tempto=tempto.replace(/</g,"");
	    	tempto=tempto.replace(/>/g,"");
	    	var pattern = new RegExp("^\([\.a-zA-Z0-9_-])+" + mailDomain + "()+","");
	    	tempto=tempto.replace(/\s/g,""); 
	    	var tempTolist=tempto.split(",");

	    	for(var i=0; i<tempTolist.length;i++){
	   			if(tempTolist.length>0&&tempTolist[i]==""){
	       			layerAlert("密送人地址不能以逗号结尾或者有多个逗号"); 
	       			return;
	   			}else{
	   				if (!pattern.test(tempTolist[i])) {
		    			layerAlert(tempTolist[i] +"：密送人地址格式不正确!");  
		    			return; 
	   				}
	   			}
	    	}
			//TODO
			//validateAddress();
		}
	}

	function checkBccExist(){
		//get bcc value
		var bcc='';
		bcc = $("#inputEmail2").val();
		if(typeof(bcc)=="undefined"){
			bcc=null;
		}
		//前台抄送人邮箱地址简单格式验证
		if(bcc!=""){
			tempto=bcc;
			tempto=tempto.replace(/</g,"");
			tempto=tempto.replace(/>/g,"");
			var pattern = new RegExp("^\([\.a-zA-Z0-9_-])+" + mailDomain + "()+","");
			tempto=tempto.replace(/\s/g,""); 
			var tempTolist=tempto.split(",");
			
			for(var i=0; i<tempTolist.length;i++){
	   			if(tempTolist.length>0&&tempTolist[i]==""){
	       			layerAlert("抄送人地址不能以逗号结尾或者有多个逗号"); 
	       			return;
	   			}else{
	   				if (!pattern.test(tempTolist[i])) {
		    			layerAlert(tempTolist[i] +"：抄送人地址格式不正确!");  
		    			return; 
	   				}
	   			}
			}
			//TODO
			//validateAddress();
		}
	}