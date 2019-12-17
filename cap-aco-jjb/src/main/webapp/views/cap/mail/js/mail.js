//*********************************************************************
//系统名称：cap-aco
//Branch. All rights reserved.
//版本信息：cap-aco1.0
//Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
//#作者：zhangdyd
//SVN版本号日期作者变更记录
//------------------01      2016/06/14   zhangdyd　新建
//*********************************************************************

/**
 * 邮件附件附件的js方法
 */
var writeBtn="write_email_a";

/**
 * ueditor object
 */
var ue = UE.getEditor('mail_content');
//var readMailId="";
var mail = (
		
/**
 * @returns {___anonymous53392_53848}
 */
function(){
	 var _self = this;
	 var readMailFlag = false;
	 var readMailId = "";
	 var readDraftId ="";
	 var tableColumn = [{
			checkbox : true
		},{
			field : 'msgId',
			title : 'msgId',
			visible:false
		}, {
			field : 'fromShown',
			title : '发送者',
			formatter:function(value,row){
				if(row.isRead){
					return '<span class="unRead_bold">'+value+'</span>';
				}else{
					return value;
				}
			}
		}, {
			field : 'subject',
			title : '邮件标题',
			formatter:function(value,row){
				if(row.isRead){
					return '<span class="unRead_bold">'+value+'</span>';
				}else{
					return value;
				}
			}
		},{
			field : 'dateShown',
			title : '时间',
			formatter:function(value,row){
				if(row.isRead){
					return '<span class="unRead_bold">'+value+'</span>';
				}else{
					return value;
				}
			}
		},{
			field : 'hasAttachment',
			title : '附件',
			formatter:function(value,row){
				if(value){
					return '<span><i class="fa fa-paperclip"></i></span>';
				}else{
					return '';
				}
			}
		},{
			field : 'isRead',
			title : '已读/未读',
			formatter:function(value,row){
				if(value){
					return '<span class="label label-danger">未读</span>';
				}else{
					return '<span class="label label-success">已读</span>';
				}
			}
		}];
	 //table columns with out read columns
	 var tableColumnNoread = [{
			checkbox : true
		},{
			field : 'msgId',
			title : 'msgId',
			visible:false
		}, {
			field : 'fromShown',
			title : '发送者'
		}, {
			field : 'subject',
			title : '邮件标题'
		},{
			field : 'dateShown',
			title : '时间',

		},{
			field : 'hasAttachment',
			title : '附件',
			formatter:function(value,row){
				if(value){
					return '<span class="label label-success">有</span>';
				}else{
					return '<span class="label label-danger">无</span>';
				}
			}
		}];
	 
	 
	 
    var scaleChange = function(){
        var mHeight = $(".mail_main").height();
        var dHeight = $(".details").height();
        $("#scale-change").click(function(){
            if($(".table").is(":hidden")){
                $(".toolbar , .table").show();
                $(".bootstrap-table").show();
                $(".details").height(dHeight);
            }else{
                $(".toolbar , .table").hide();
                $(".bootstrap-table").hide();
                $(".details").height(mHeight);
                window.scrollTo(0,0);
            }  
        });
    };
    //文件夹点击事件
    var liActive = function(){
    	//邮件缺省文件夹点击事件
    	//"live" 使得动态添加的节点也具有点击事件
        $(".folder_list a").live('click',function(){
        	//cancel the click function when the data loaded
        	$(".folder_list a").die("click");
            $(".mail_menu li").removeClass("active");
            $(this).parent().addClass("active");
        	var folderSelected = getCurrFolder();
        	//hide the write mail jsp, show mail list jsp-page 
        	$("#write_mail_jsp").hide();
        	$("#list_mail_jsp").show();
        	//hide the back button
        	$(".back_to_maillist").hide();
    		//clear the read mail status
    		readMailFlag=false;
    		readMailId="";
    		
        	if(folderSelected==null||folderSelected==""){
        		return null;
        	}
        	
        	if(folderSelected=="INBOX"){
        		//click the INBOX refresh the unread count
        		getUnreadEmailNum();
        	}else{
        		//TODO click other folder
        	}
        	//button open and close
        	switchMailBtn(folderSelected);
        	//show the mail list
        	$("#emaillist_div").show();
        	//hide the mail page
        	$("#mail_allInfor_div").hide();
        	//first destroy the table then create a new one
        	$('#emaillist').bootstrapTable('destroy').bootstrapTable(
        			{
        	    		url : 'email/doReadMailInfor', 
        	    		method : 'get', 
        	    		toolbar : '#toolbar', 
        	    		striped : true, 
        	    		cache : false,
        	    		pagination : true,
        	    		sortable : false, 
        	    		sortOrder : "asc", 
        	    		queryParams :function(params) {
        	    			var temp = {
        	    					rows : params.limit, 
        	    					page : params.offset,
        	    					currfolder: folderSelected
        	    			};
        	    			return temp;
        	    		}, 
        	    		sidePagination : "server", 
        	    		pageNumber : 1, 
        	    		pageSize : 10, 
        	    		search : false, 
        	    		strictSearch : false,
        	    		showColumns : false, 
        	    		showRefresh : false, 
        	    		minimumCountColumns : 2, 
        	    		clickToSelect : true, 
        	    		uniqueId : "msgId", 
        	    		showToggle : false,
        	    		cardView : false, 
        	    		detailView : false, 
        	    		columns : tableColumn,
        	    		onDblClickRow : function(row, tr) {
        	    			tableDBClick(row, tr);
        	    		},
        	    		onClickRow : function(row, tr) {

        	    		},
        	    		onLoadSuccess: function(data){
        	    			//add the click funtion again after load success
        	    			liActive();
        	    		}
        	    	}
        			);
        });
        
    };
    
//    var bootstrapTablePara =;
    
    
    function tableDBClick(row, tr){
		//jquery object can be used directly
		//get the "isRead" cell
    	$("#emaillist").bootstrapTable("checkBy", {field:"msgId", values:[row.msgId]});
		var selectedIsRead = $(tr).find("td span.label").get(0);
		//remove the bold style
		var tds = $(tr).find("td span");
		$(tds).each(function(index) {
			$(tds[index]).removeClass("unRead_bold");
		});
		//change "unRead" to "read"
		if($(selectedIsRead).text()=="未读"){
			$(selectedIsRead).text("已读");
			$(selectedIsRead).attr("class","label label-success");
			//reduce the number of unread
			operateTotalNum(1,1,"unread_mail_count");
		}
		//set the row selected
		$(tr).addClass("selected");
		$(tr).find("input[type='checkbox']").attr("checked",true);
		//input[type='hidden']
		var folder = getCurrFolder();
		readMail(row.msgId,folder);
    }
    function folderClick(){
    	
    }
    
    /*初始化添加文件夹按钮
     * */
    var addMenu = function(){
        $("#add-menu").click(function(){
            var myMenu = $(".my_menu");
            if(myMenu.is(":hidden")){
                $(this).find("i.icon").removeClass().addClass("fa fa-angle-down icon");
                myMenu.show();
            }else{
                $(this).find("i.icon").removeClass().addClass("fa fa-angle-right icon");
                myMenu.hide();
            }
        });
    };
    //我的文件夹的添加，修改，删除图标鼠标经过显示，鼠标离开隐藏
    var iconChange = function(){

		$(".mail_menu > li > a ,.my_menu > li > a ").live({
		   mouseenter:
		   function(){
			   $(this).find("i").show();
		   },
		   mouseleave:
		   function(){
		     $(this).find("i").hide();
		     $(this).find("i.icon").show();
		   }
		});
    }
    /*初始化按钮
     * */
    var addBtnClick = function(){
    	//add 'click' event to the "写信" button
    	$("#"+writeBtn).click(function() {
    		//reset the read draft id, in order to save draft
    		readDraftId="";
    		$.ajax({
    			url : 'email/doWriteEmailAction',
    			dataType:'json',
    			type : 'post',
    		    success: function(res) {
    		    	if(res==true){
    		    		$("#list_mail_jsp").hide();
    		    		//clear the write mail jsp form
    		    		clearMailWriteForm();
    		    		$("#write_mail_jsp").show();
    		    		//clear the mail content
    		    		//ue.setContent('', true);
    		    		ue.execCommand("clearDoc");
    		    		//show the "back" button 
    		    		$(".back_to_maillist").show();
    		    		//hide the input of "cc" and "bcc"
    		    		$("#CC").hide();
    		    		$("#BCC").hide();
//    		    		var ifr = document.getElementById('mail_att_list_frame');
//    		    		var win = ifr.window || ifr.contentWindow;
//    		    		win.refresh(); // 调用iframe中的a函数
    		    		//refresh the attachments list
    		    		refresh();//refresh the attachment list
    		    	}else{
    		    		layerAlert("服务器出现问题，请重新登录！");
    		    	}
    		    },
			    error: function() {
			        //请求出错处理
			    	layerAlert("服务器出现问题，请重新登录！");
			    }
    		});
    	});
    	//add 'click' event to the "收信" button
    	$("#recieve_email_a").click(function() {
    		//trigger the click on the INBOX folder
    		$("#mail_folder_inbox a").trigger("click");
    	});
    	//add 'click' event to the "发送" button
    	$(".send_mail_btn").click(function() {
    		sendMail();
    	});
    	//add 'click' event to the "保存草稿" button
    	$(".save_draft_btn").click(function() {
    		saveDraft();
    	});
    	//add 'click' event to the "编辑草稿" button
    	$(".edit_draft_btn").click(function() {
    		if(readMailFlag){
    			//set the read draft id
    			readDraftId = readMailId;
    			replyMail(readMailId, getCurrFolder(),4);
    		}else{
    			var selectRow = _self.getOneTableSelect("emaillist");
    			if(selectRow!=null){
        			var tr = _self.getTableSelectedTr("emaillist");
        			if(tr!=null){
        				//change unread charater bold
        				$(tr).find("td span").removeClass("unRead_bold");
        				var selectedIsRead = $(tr).find("td span.label").get(0);
    	    			//change "unRead" to "read"
    	    			if($(selectedIsRead).text()=="未读"){
    	    				$(selectedIsRead).text("已读");
    	    				$(selectedIsRead).attr("class","label label-success");
    	    			}
        			}
    				var id = selectRow[0].msgId;
    				var emailFrom = selectRow[0].fromShown;
    				clearMailWriteForm();
    				//hide the button
    				$(".back_to_maillist").show();
    				//set the read draft id
    				readDraftId=id;
    				//add current folder
    				replyMail(id, getCurrFolder(),4);
    			}else{
    				return null;
    			}
    		}
    	});
    	
    	//add 'click' event to the "查看" button
    	$(".read_mail_btn").click(function() {
    		//if(){}
    		//read the content of the mail
    		var selectRow = _self.getOneTableSelect("emaillist");
    		if(selectRow!=null){
    			//show the 'reply' and 'forward' button
        		$(".reply_mail_btn").show();
        		$(".forward_mail_btn").show();
    			var tr = _self.getTableSelectedTr("emaillist");
    			if(tr!=null){
    				//change unread charater bold
    				$(tr).find("td span").removeClass("unRead_bold");
    				var selectedIsRead = $(tr).find("td span.label").get(0);
	    			//change "unRead" to "read"
	    			if($(selectedIsRead).text()=="未读"){
	    				$(selectedIsRead).text("已读");
	    				$(selectedIsRead).attr("class","label label-success");
	    			}
    			}
    			var ids = selectRow[0].msgId;
    			var folder = getCurrFolder();
    			readMail(ids,folder);
    			//calculate the unread count
    			//TODO get current folder,find the count number after folder name
    			if(selectRow[0].isRead){
    				//the selected mail is a unread mail
    				//reduce the number by 1
    				operateTotalNum(1,1,"unread_mail_count");
    			}
    		}else{
    			return null;
    		}
    	});
    	
    	//add 'click' event to the "回复" button
    	$(".reply_mail_btn").click(function() {
    		var selectRow = _self.getOneTableSelect("emaillist");
    		if(selectRow==null){
    			return;
    		}
    		$(".back_to_maillist").show();
    		var emailFrom="";
    		if(readMailFlag){
    			replyMail(readMailId, getCurrFolder(),1);
    		}else{
    			if(selectRow!=null){
        			var tr = _self.getTableSelectedTr("emaillist");
        			if(tr!=null){
        				//change unread charater bold
        				$(tr).find("td span").removeClass("unRead_bold");
        				var selectedIsRead = $(tr).find("td span.label").get(0);
    	    			//change "unRead" to "read"
    	    			if($(selectedIsRead).text()=="未读"){
    	    				$(selectedIsRead).text("已读");
    	    				$(selectedIsRead).attr("class","label label-success");
    	    			}
        			}
    				var id = selectRow[0].msgId;
    				emailFrom = selectRow[0].fromShown;
    				clearMailWriteForm();
    				replyMail(id, getCurrFolder(),1);
        			if(selectRow[0].isRead){
        				//the selected mail is a unread mail
        				//reduce the number by 1
        				operateTotalNum(1,1,"unread_mail_count");
        			}
    			}else{
    				return null;
    			}
    		}

    	});
    	
    	//add 'click' event to the "删除" button
    	$(".del_mail_btn").click(function() {
    		//one select confirm
    		var selectRow = _self.getOneTableSelect("emaillist");
    		if(selectRow==null){
    			return;
    		}
    		//add confirm layer
			layer.confirm('确定删除吗？', {
				btn : [ '是', '否' ]
			}, function() {
	    		var currFolder = getCurrFolder();
	    		if(readMailFlag){
	    			delMail(readMailId,currFolder,0);
	    		}else{
	    			if (selectRow.length == 0) {
	    				layerAlert("请选择一封邮件！");
	    				return null;
	    			}
	    			var selectRows=_self.getTableSelectedTr("emaillist");
	    			var unread=0;
	    			$(selectRows).each(function(index){
	    				var selectedIsRead = $(selectRows[index]).find("td span.label").get(0);
	    				//change "unRead" to "read"
	    				if($(selectedIsRead).text()=="未读"){
	    					unread= unread +1;
	    				}
	    			});			
	    			var ids = '';
	    			$(selectRow).each(function(index) {
	    				ids = ids + selectRow[index].msgId + ",";
	    			});
	    			ids = ids.substring(0, ids.length - 1);
	    			delMail(ids,currFolder,unread);
	    		}
			});
    	});
    	
    	//add 'click' event to the "转发" button
    	$(".forward_mail_btn").click(function() {
    		var selectRow = _self.getOneTableSelect("emaillist");
    		if(selectRow==null){
    			return;
    		}
    		$(".back_to_maillist").show();
    		if(readMailFlag){
    			replyMail(readMailId, getCurrFolder(),2);
    		}else{
    			if(selectRow!=null){
    				var id = selectRow[0].msgId;
    				var emailFrom = selectRow[0].fromShown;
    				clearMailWriteForm();
    				//add current folder
    				replyMail(id, getCurrFolder(),2);
    			}else{
    				return null;
    			}
    		}

    	});
    	//add 'click' event to the "返回" button 
    	$(".back_to_maillist").click(function(){
    		//go back to the mail list
    		$("#mail_allInfor_div").hide();
    		//hide the write jsp
    		$("#write_mail_jsp").hide();
    		$("#list_mail_jsp").show();
    		$("#emaillist_div").show();
    		//hide the button
//    		$(".reply_mail_btn").hide();
//    		$(".forward_mail_btn").hide();
//    		//hide the button
//    		$(".back_to_maillist").hide();
//    		//show the "查看" button
//    		if(getCurrFolder()!="DRAFT"){
//    			$(".read_mail_btn").show();
//    		}
    		//clear the read mail status
    		readMailFlag=false;
    		readMailId="";
    		//cancel the table selected
    		var selectOneRow = $("#emaillist").bootstrapTable('getSelections');
    		var selectedTr = $("#emaillist"+" tr.selected");
    		//双击和复选框有时会出现bug，导致页面上显示选中一行，但$("#emaillist").bootstrapTable('getSelections');返回为空。
    		//此时重新加载table数据
    		if(selectOneRow.length==0&&selectedTr.length!=0){
    			//$('#emaillist').bootstrapTable('refresh');
    			refreshBootStrapTable()
    		}
    		switchMailBtn(getCurrFolder());
    	});
    };
    /*获取bootstrap table一个选中项，如果不是一个选中项，给出相应的提示
     * tableId ： table 的 id
     * */
    this.getOneTableSelect = function(tableId){
    	var selectOneRow = $("#"+tableId).bootstrapTable('getSelections');
		if (selectOneRow.length != 1) {
			layerAlert("请选择一封邮件！");
			return null;
		}
		var selectedTr = $("#"+tableId+" tr.selected");
		if(selectedTr.length!=1){
			layerAlert("请选择一封邮件！");
			return null;
		}
		return selectOneRow;
    }
    
    /*获取bootstrap table的选中列
     * tableId ： table 的 id
     * */
    this.getTableSelectedTr=function(tableId){
    	var selectedTr = $("#"+tableId+" tr.selected");
    	return selectedTr;
    }
    
    /*根据所选文件夹，开关按钮
     * */
    var switchMailBtn = function(folderSelected){
    	if(folderSelected=="INBOX"){
    		$(".reply_mail_btn").hide();
    		$(".forward_mail_btn").hide(); 
    		$(".back_to_maillist").hide();
    		$(".del_mail_btn").show();
    		$(".read_mail_btn").show();
    		$(".edit_draft_btn").hide();
    	}else if(folderSelected=="SEND"){
    		$(".reply_mail_btn").hide();
    		$(".forward_mail_btn").hide();
    		$(".back_to_maillist").hide();
    		$(".del_mail_btn").show();
    		$(".read_mail_btn").show();
    		$(".edit_draft_btn").hide();
    	}else if(folderSelected=="SPAM"){
    		$(".reply_mail_btn").hide();
    		$(".forward_mail_btn").hide();
    		$(".back_to_maillist").hide();
    		$(".del_mail_btn").show();
    		$(".read_mail_btn").show();
    		$(".edit_draft_btn").hide();
    	}else if(folderSelected=="DELETE"){
    		$(".reply_mail_btn").hide();
    		$(".forward_mail_btn").hide();
    		$(".back_to_maillist").hide();
    		$(".del_mail_btn").show();
    		$(".read_mail_btn").show();
    		$(".edit_draft_btn").hide();
    	}else if(folderSelected=="DRAFT"){
    		$(".reply_mail_btn").hide();
    		$(".forward_mail_btn").hide();
    		$(".back_to_maillist").hide();
    		$(".del_mail_btn").show();
    		$(".read_mail_btn").hide();
    		$(".edit_draft_btn").show();
    	}else{
    		//select customized folder
    		$(".reply_mail_btn").hide();
    		$(".forward_mail_btn").hide();
    		$(".back_to_maillist").hide();
    		$(".del_mail_btn").show();
    		$(".read_mail_btn").show();
    		$(".edit_draft_btn").hide();
    	}
    }
    
    /*回复邮件
     * id：选取邮件的主键
     * currFolder:当前邮件所在的文件夹
     * type: 回复类型，1： 为回复
     * 				2： 为转发
     * 				3: 抄送
     * 				4： 编辑草稿
     * */
    var replyMail = function(id,currFolder, type){
		$("#list_mail_jsp").hide();
		//clear the write mail jsp form
		clearMailWriteForm();
		$("#write_mail_jsp").show();
		$('#BCC').hide();
		$('#CC').hide();
		//$('#inputEmail0').attr("disabled",true); 
		//$('#tel').attr("disabled","false");
    	//加载邮件时空出3行
		var editorHtml ='<br/><br/><br/>'+originalMailTemplate;
		$.ajax({
			url : 'email/doReplyMail',
			dataType:'json',
		    data: {
		    	msgId:id,
		    	currfolder:currFolder
		    	},    //参数值
			type : 'post',
		    success: function(emailInforV) {
		    	if(emailInforV!=null){
			    	//show the mail infor read_mail_content_textarea
			    	if(typeof(type)=="undefined"||type==1){
				    	//set subject
				    	$("#inputCon1").val("回复："+emailInforV.subject);
			    		$("#inputEmail0").val(emailInforV.fromShow);
			    	}else if(type==2){
			    		$("#inputCon1").val("转发："+emailInforV.subject);
			    		//set to
			    		//$("#inputEmail0").val(emailInforV.fromShow);
			    	}else if(type==3){
			    		$("#inputCon1").val("抄送："+emailInforV.subject);
			    		$("#inputEmail0").val(emailInforV.fromShow);
			    	}else if(type==4){
			    		$("#inputCon1").val(emailInforV.subject);
			    		$("#inputEmail0").val(emailInforV.toShow);
			    		$("#inputEmail1").val(emailInforV.ccShow);
			    		$("#inputEmail2").val(emailInforV.bccShow);
			    	}else{
			    		layerAlert("邮件回复类型不支持！");
			    		return null;
			    	}
			    	//set the attachment list
			    	var attList = emailInforV.atts;
			    	var html = "";
			    	if(emailInforV.atts!=null){
			    		//TODO attachments operation
//			    		for(var i = 0, j = attList.length; i < j ;i++){
//			    			//create the attachment item to show
//			    			html = html + "<tr>" +
//			    			"<td style=\"border: 0px;\"><input type=\"hidden\" name=\"serialNumber\" id=\""+ attList[i].uuid + "\" value=\"" + attList[i].uuid + "\"/>" +
//			    			"<input id=\"" + attList[i].uuid + "_i\" name=\"documentId\" type=\"checkbox\" value=\"" + attList[i].uuid + "\" /> &nbsp;" +
//			    			"<a id=\"" + attList[i].uuid + "_a\" href=\""+  rootPath + "/emailAtt/doDownloadAttachment?attUUID="+ attList[i].uuid +"&fileName=" +  attList[i].attname +"\" >"+ attList[i].attname + "</a>" +
//			    			"</td>" +
//			    			"</tr>";
//			    		}
//			    		var temp = $("#mail_att_list_frame").contents().find("#write_att_list");
//			    		//$("#write_att_list").html(html);
//			    		$(temp).html(html);
			    		refresh();

			    	}
			    	editorHtml=editorHtml.replace("mail_original_mailfrom", emailInforV.fromShow.replace(/</g,"&lt;").replace(/>/g,"&gt;"))
			    						.replace("mail_original_mailtime",emailInforV.dateShow)
			    						.replace("mail_original_mailto",emailInforV.toShow.replace(/</g,"&lt;").replace(/>/g,"&gt;"))
			    						.replace("mail_original_mailcc",emailInforV.ccShow.replace(/</g,"&lt;").replace(/>/g,"&gt;"))
			    						.replace("mail_original_mailsubject",emailInforV.subject);
					$.ajax({
						url : 'email/doReadMailPart',
					    dataType: "text",   //返回格式为json
					    data: {
					    	msgId:id,
					    	currtfolder:currFolder,
					    	partId: 0
					    	},    //参数值
					    type: "POST",   //请求方式
					    success: function(content) {
					    	//set email content
					    	//var editor = FCKeditorAPI.GetInstance('mail_content');
					    	//TODO set a better format for reply
					    	//if edit draft
					    	if(type==4){
					    		editorHtml=content;
					    	}else{
					    		editorHtml=editorHtml.replace("mail_original_mailcontent", content);
					    	}
					    	//editor.SetHTML(editorHtml,false);
//					    	ue.addListener( 'afterSetContent', function( editor ) {
//					    	     editor.focus(false);
//					    	 } );
					    	ue.setContent(editorHtml);
					    	//ue.focus();//不好用
					    },
					    error: function() {
					        //请求出错处理
					    	layerAlert("邮件操作失败！");
					    }
					});
		    	}
		    },
		    error: function() {
		        //请求出错处理
		    	layerAlert("服务器出现问题，请重新登录！");
		    }
		});
    	
    }
    /*保存草稿
     * */
    var saveDraft = function(){
    	var to="";
    	var cc="";
    	var bcc="";
    	var subject="";
    	var content="";
    	to = $("#inputEmail0").val();
    	cc = $("#inputEmail1").val();
    	if(typeof(cc)=="undefined"){
    		cc = null;
    	}
    	bcc = $("#inputEmail2").val();
    	if(typeof(bcc)=="undefined"){
    		bcc=null;
    	}
    	subject = $("#inputCon1").val();
    	
    	//var Editor = FCKeditorAPI.GetInstance('mail_content');
    	
    	//获取值方法
    	//content = Editor.GetXHTML();
    	content = ue.getContent();
    	//if read draft is not null then delete the read draft id message in the draft
    	var sendData={};
    	
    	if(readDraftId!=""){
    		sendData={
    		    	to:to,
    		    	cc:cc,
    		    	bcc:bcc,
    		    	subject:subject,
    		    	content:content,
    		    	msgId:readDraftId
    		    	};
    	}else{
    		sendData={
    		    	to:to,
    		    	cc:cc,
    		    	bcc:bcc,
    		    	subject:subject,
    		    	content:content,
    		    	msgId:""
    		    	};

    	}
		$.ajax({
			url : 'email/saveDraft',
		    dataType: "json",   //返回格式为json
		    data: sendData,    //参数值
		    type: "POST",   //请求方式
		    success: function(res) {
		    	layerAlert("保存邮件成功！");
	    		$("#list_mail_jsp").show();
	        	$("#mail_allInfor_div").hide();
	    		//hide the mail list table
	    		$("#emaillist_div").show();
	    		$("#write_mail_jsp").hide();
	    		//hide the button
	    		$(".back_to_maillist").hide();
	    		//hide the button
	    		$(".reply_mail_btn").hide();
	    		$(".forward_mail_btn").hide();
		    },
		    complete: function() {
		    	// refresh the mail list table
	    		if(getCurrFolder()!="DRAFT"){
	    			$(".read_mail_btn").show();
	    		}
	    		refreshBootStrapTable();
		    },
		    error: function() {
		        //请求出错处理
		    	layerAlert("保存邮件失败！");
		    }
		});
    }
    
    /*发送邮件
     * */
    var sendMail = function(){
    	//alert(mailDomain);
    	$('.send_mail_btn').unbind("click")
    	var to="";
    	var cc="";
    	var bcc="";
    	var subject="";
    	var content="";
    	//get to value
    	to = $("#inputEmail0").val();
    	if(typeof(to)=="undefined"){
    		to = null;
    	}
    	//前台收件人邮箱地址简单格式验证
    	//收件人不能为空
    	var toList= new Array();
    	if(to!=""){
    		var tempto=to;
    		tempto=tempto.replace(/</g,"");
    		tempto=tempto.replace(/>/g,"");
    		var pattern = new RegExp("^\([\.a-zA-Z0-9_-])+" + mailDomain + "()+","");
    		tempto=tempto.replace(/\s/g,""); 
    		var tempTolist=new Array();
    		tempTolist=tempto.split(",");
    		
    		for(var i=0; i<tempTolist.length;i++){
    			if (!pattern.test(tempTolist[i])) {
    				layerAlert(tempTolist[i] +"：收件人地址格式不正确!");
        	    	$(".send_mail_btn").click(function() {
        	    		sendMail();
        	    	});
    				return; 
    			}
    		}
    		//e.g. zhangsan <zhangsan@court>
    		if(to.indexOf("<")!=-1&&to.indexOf(">")!=-1 ){
    			tempTolist=[];
    			var start=0;
    			var stop=0;
    			var formatList = to.split(",");
    			for(var i=0; i<formatList.length; i++){
    				start = formatList[i].indexOf("<");
    				stop = formatList[i].indexOf(">")
    				if(start!=-1&&stop!=-1){
    					//get the substring between "<" and ">"
    					var userList = formatList[i].substring(start+1,stop);
    					tempTolist.push(userList);
    				}else{
    					tempTolist.push(formatList[i]);
    				}
    			}
    		}
    		//check the comma in the list
    		if(!checkCommaCorrect(tempTolist,"：收件人地址缺少逗号分隔!")){
    			return;
    		}
    		//check the repeat address in the list
    		if(!checkReaptAddrInArray(tempTolist,"：收件人地址重复!")){
    			return;
    		}
    		toList = tempTolist;
    	}else{
    		layerAlert("收件人地址为空！");
	    	$(".send_mail_btn").click(function() {
	    		sendMail();
	    	});
    		return;
    	}
    	//get cc value	    	
    	cc = $("#inputEmail1").val();
    	if(typeof(cc)=="undefined"){
    		cc = null;
    	}
    	//前台转发人邮箱地址简单格式验证
    	var ccList= new Array();
    	if(cc!=""){
        	tempto=cc;
        	tempto=tempto.replace(/</g,"");
        	tempto=tempto.replace(/>/g,"");
        	var pattern = new RegExp("^\([\.a-zA-Z0-9_-])+" + mailDomain + "()+","");
        	tempto=tempto.replace(/\s/g,""); 
        	var tempTolist=tempto.split(",");

        	for(var i=0; i<tempTolist.length;i++){
        		if (!pattern.test(tempTolist[i])) {  
        			layerAlert(tempTolist[i] +"：密送人地址格式不正确!");  
        	    	$(".send_mail_btn").click(function() {
        	    		sendMail();
        	    	});
        			return; 
        		}
        	}
    		//e.g. zhangsan <zhangsan@court>
    		if(cc.indexOf("<")!=-1&&cc.indexOf(">")!=-1 ){
    			tempTolist=[];
    			var start=0;
    			var stop=0;
    			var formatList = cc.split(",");
    			for(var i=0; i<formatList.length; i++){
    				start = formatList[i].indexOf("<");
    				stop = formatList[i].indexOf(">")
    				if(start!=-1&&stop!=-1){
    					//get the substring between "<" and ">"
    					var userList = formatList[i].substring(start+1,stop);
    					tempTolist.push(userList);
    				}else{
    					tempTolist.push(formatList[i]);
    				}
    			}
    		}
    		//check the comma in the list
    		if(!checkCommaCorrect(tempTolist,"：密送人地址缺少逗号分隔!")){
    			return;
    		}
    		//check the repeat address in the list
    		if(!checkReaptAddrInArray(tempTolist,"：密送人地址重复!")){
    			return;
    		}
    		ccList= tempTolist;
    	}
    	//get bcc value
    	bcc = $("#inputEmail2").val();
    	if(typeof(bcc)=="undefined"){
    		bcc=null;
    	}
    	//前台抄送人邮箱地址简单格式验证
    	var bccList= new Array();
    	if(bcc!=""){
    		tempto=bcc;
    		tempto=tempto.replace(/</g,"");
    		tempto=tempto.replace(/>/g,"");
    		var pattern = new RegExp("^\([\.a-zA-Z0-9_-])+" + mailDomain + "()+","");
    		tempto=tempto.replace(/\s/g,""); 
    		var tempTolist=tempto.split(",");
    		
    		for(var i=0; i<tempTolist.length;i++){
    			if (!pattern.test(tempTolist[i])) {  
    				layerAlert(tempTolist[i] +"：抄送人地址格式不正确!");  
        	    	$(".send_mail_btn").click(function() {
        	    		sendMail();
        	    	});
    				return; 
    			}
    		}
    		//e.g. zhangsan <zhangsan@court>
    		if(bcc.indexOf("<")!=-1&&bcc.indexOf(">")!=-1 ){
    			tempTolist=[];
    			var start=0;
    			var stop=0;
    			var formatList = bcc.split(",");
    			for(var i=0; i<formatList.length; i++){
    				start = formatList[i].indexOf("<");
    				stop = formatList[i].indexOf(">")
    				if(start!=-1&&stop!=-1){
    					//get the substring between "<" and ">"
    					var userList = formatList[i].substring(start+1,stop);
    					tempTolist.push(userList);
    				}else{
    					tempTolist.push(formatList[i]);
    				}
    			}
    		}
    		//check the comma in the list
    		if(!checkCommaCorrect(tempTolist,"：抄送人地址缺少逗号分隔!")){
    			return;
    		}
    		//check the repeat address in the list
    		if(!checkReaptAddrInArray(tempTolist,"：抄送人地址重复!")){
    			return;
    		}

    		bccList = tempTolist;
    	}
    	//check the repeat name
    	//the cc con not exist in the bcc and cc list
    	if(!checkContainAddr(toList,bccList,ccList, "：收件人在抄送人或密送人中重复")){
    		return;
    	}
    	if(!checkContainAddr(bccList,ccList,new Array(), "：抄送人在密送人中重复")){
    		return;
    	}
		if(!validateAddress(toList,":收件人地址错误!")){
	    	$(".send_mail_btn").click(function() {
	    		sendMail();
	    	});
			return;
		}
		if(!validateAddress(ccList,"：密送人邮件地址错误!")){
	    	$(".send_mail_btn").click(function() {
	    		sendMail();
	    	});
			return;
		}
		if(!validateAddress(bccList,"抄送人邮件地址错误!")){
	    	$(".send_mail_btn").click(function() {
	    		sendMail();
	    	});
			return;
		}
    	
    	subject = $("#inputCon1").val();
    	if(subject==""||subject==null){
    		layerAlert("没有添加邮件标题");
	    	$(".send_mail_btn").click(function() {
	    		sendMail();
	    	});
    		return;
    	}
    	
//    	var Editor = FCKeditorAPI.GetInstance('mail_content');
//    	//获取值方法
//    	content = Editor.GetXHTML();
    	//get the content in the ueditor
    	content = ue.getContent();
    	
		$.ajax({
			url : 'email/doSendemail',
		    dataType: "json",   //返回格式为json
		    async : false,
		    data: {
		    	to:to,
		    	cc:cc,
		    	bcc:bcc,
		    	subject:subject,
		    	content:content
		    	},    //参数值
		    type: "POST",   //请求方式
		    success: function(res) {
		    	if(res){
		    		layerAlert("发送邮件成功！");
		    		//back to the mail list page
		    		$("#list_mail_jsp").show();
		    		$("#emaillist_div").show();
		    		$("#mail_allInfor_div").hide();
		    		//hide the write jsp
		    		$("#write_mail_jsp").hide();
		    		//hide the "back to" button
		    		$(".back_to_maillist").hide();
		    		//delete the draft
		    		if(readDraftId!=""){
		    			delDraft(readDraftId,false);
		    		}
		    	}else{
		    		layerAlert("发送邮件失败！");
		    	}
		    },
		    complete: function() {
		    	//add 'click' event to the "发送" button
		    	$(".send_mail_btn").click(function() {
		    		sendMail();
		    	});
	    		if(getCurrFolder()!="DRAFT"){
	    			$(".read_mail_btn").show();
	    		}
		    	// refresh the mail list table
	    		refreshBootStrapTable();
	    		//hide the button
	    		$(".reply_mail_btn").hide();
	    		$(".forward_mail_btn").hide();
	    		
		    },
		    error: function() {
		        //请求出错处理
		    	layerAlert("服务器出错！");
		    }
		});
    }
    /*检查邮件地址中是否重复名字
     * array： 地址数组
     * msg： 显示的信息
     * return： 正确返回true
     * */ 
    function checkReaptAddrInArray(array,msg){
    	if(array==null || array.length==0){
    		return true;
    	}else{
    		var nary=array.sort();
    		for(var i=0; i< nary.length-1; i++){
    			if(nary[i]==nary[i+1]){
    				layerAlert(nary[i] +msg);
        	    	$(".send_mail_btn").click(function() {
        	    		sendMail();
        	    	});
    				return false;
    			}
    		}
    		return true;
    	}
    }
    /*检查邮件地址中逗号分隔的位置
     * array： 地址数组
     * msg： 显示的信息
     * return： 正确返回true
     * */  
    function checkCommaCorrect(array,msg){
    	if(array==null || array.length==0){
    		return true;
    	}else{
    		for(var i=0; i<array.length; i++){
    			var nlist = array[i].split("@");
    			if(nlist.length>2){
    				layerAlert(array[i] +msg);
        	    	$(".send_mail_btn").click(function() {
        	    		sendMail();
        	    	});
    				return false;
    			}
    		}
    		return true;
    	}
    }
    /*检查list1中地址是否在list2和list3中重复
     * array： 地址数组
     * msg： 显示的信息
     * return： 正确返回true
     * */  
    function checkContainAddr(list1,list2,list3,msg){
    	for(var i=0; i< list1.length; i++){
    		for(var j=0; j<list2.length; j++){
    			if(list1[i]==list2[j]){
    				layerAlert(list1[i] +msg);
        	    	$(".send_mail_btn").click(function() {
        	    		sendMail();
        	    	});
    				return false;
    			}
    		}
    		for(var k=0; k<list3.length; k++){
    			if(list1[i]==list3[k]){
    				layerAlert(list1[i] +msg);
        	    	$(".send_mail_btn").click(function() {
        	    		sendMail();
        	    	});
    				return false;
    			}
    		}
    	}
    	return true;
    }
    
    /*读取邮件，
     * */    
    var readMail = function(ids,currFolder){
    	//fist hide the page
    	$("#mail_allInfor_div").hide();
		//show the button
		$(".back_to_maillist").show();
		//hide the mail list table
		$("#emaillist_div").hide();
		//hide the "查看" button
		$(".read_mail_btn").hide();
		//只有是收件箱才显示回复和转发按钮
		if(currFolder=="INBOX"){
			$(".reply_mail_btn").show();
			$(".forward_mail_btn").show();  
		}else{
			$(".reply_mail_btn").hide();
			$(".forward_mail_btn").hide();
		}
    	
    	//读取邮件头信息
		$.ajax({
			url : 'email/doReadOneMail',
		    dataType: "json",   //返回格式为json
		    data: {
		    	msgId:ids,
		    	currfolder:currFolder
		    	},    //参数值
		    type: "POST",   //请求方式
		    success: function(emailInforV) {
		    	if(emailInforV!=null){
		    		//set global read mail status
		    		readMailFlag=true;
		    		readMailId=ids;
		    		//set global mail id
		    		readMailId = ids;
		    		var $title = $("#mail-view");
		    		var fujian = emailInforV.atts;
		    		var fujian_num = "";
		    		if(fujian!=null&&fujian.length>0){
		    			fujian_num= fujian.length;
		    			fujian_num+="个";
		    		}
		    		
		    		var fujian_copy = emailInforV.atts;
			    	var mail_to = emailInforV.toShow;
			    	var mail_to_copy = emailInforV.toShow;
			    	var mail_to_show ="";
			    	var mail_to_show_copy="";
			    		
			    	var mail_zhuanfa = emailInforV.ccShow;
			    	var mail_zhuanfa_copy = emailInforV.ccShow;
			    	var mail_zhuanfa_show="";
			    	var mail_zhuanfa_show_copy="";
			    	
			    	var mail_misong=null
			    	mail_misong = emailInforV.bccShow;
			    	var mail_misong_copy = emailInforV.bccShow;
			    	var mail_misong_show="";
			    	var mail_misong_show_copy="";
			    	//construct the from block
			    	var mailfromName =emailInforV.fromShow.split("<");
			    	var fromshow=mailAddressTemplate;
			    	fromshow=fromshow.replace("mail_from_person", " "+$.trim(mailfromName[0])).replace("mail_from_address",$.trim("&lt;"+mailfromName[1]).replace(">","&gt;"));
			    	var tempTemplate = null;
			    	if(mail_misong==''||mail_misong==null){
			    		tempTemplate = mailTitleTemplate;
			    		//if the tos and ccs not contain the current user
				    	if(mail_to.indexOf(currentEmail)<0&&mail_zhuanfa.indexOf(currentEmail)<0){
				    		tempTemplate=tempTemplate.replace("show_reciever_contain_message","block");
				    	}else{
				    		tempTemplate=tempTemplate.replace("show_reciever_contain_message","none");
				    	}
			    		$title.html(
			    				tempTemplate
			    				.replace("mail_subject",$.trim(emailInforV.subject))
			    				.replace("mail_send_time",$.trim(emailInforV.dateShow))
			    				.replace("mail_from_block",fromshow)
			    				.replace("mail_to", "")
			    				.replace("mail_zhuanfa", "")
			    				.replace("mail_att_num",fujian_num)
			    		).css("border-bottom","1px solid #ddd");
			    	}else{
			    		tempTemplate = mailTitleAllTemplate;
			    		//if the tos and ccs not contain the current user
				    	if(mail_to.indexOf(currentEmail)<0&&mail_zhuanfa.indexOf(currentEmail)<0){
				    		tempTemplate=tempTemplate.replace("show_reciever_contain_message","block");
				    	}else{
				    		tempTemplate=tempTemplate.replace("show_reciever_contain_message","none");
				    	}
			    		$title.html(
			    				tempTemplate
			    				.replace("mail_subject",$.trim(emailInforV.subject))
			    				.replace("mail_send_time",$.trim(emailInforV.dateShow))
			    				.replace("mail_from_block",fromshow)
			    				.replace("mail_to", "")
			    				.replace("mail_zhuanfa", "")
			    				.replace("mail_misong", "")
			    				.replace("mail_att_num",fujian_num)
			    				
			    		).css("border-bottom","1px solid #ddd");
				    	$title.find(".mail-misong-more").click(function(){
				    		if($(this).html()=='[显示全部]'){
				    			$title.find(".mail-title-misong-content").html($.trim(mail_misong_show_copy));
				    			$(this).html('[收起]');
				    		}else{
				    			$title.find(".mail-title-misong-content").html(mail_misong_show);
				    			$(this).html('[显示全部]');
				    		}
				    	});
			    	}
			    	
			    	$("#mail-updown").click(function (){
			    		if($("#title-updown").is(":hidden")){
			    			$("#mail-updown").removeClass("fa-chevron-circle-down").addClass("fa-chevron-circle-up");
			    			$("#title-updown").show();
			    		}else{
			    			$("#mail-updown").removeClass("fa-chevron-circle-up").addClass("fa-chevron-circle-down");
			    			$("#title-updown").hide();
			    		}
			    	});
			    	$title.find(".mail-to-more").click(function(){
			    		if($(this).html()=='[显示全部]'){
			    			//$title.find(".mail-title-to-content").empty();
			    			//$title.find(".mail-title-to-content").html($.trim(mail_to_copy).replace(/</g,"&lt;").replace(/>/g,"&gt;"));
			    			$title.find(".mail-title-to-content").html($.trim(mail_to_show_copy));
			    			//$title.find(".mail-title-to-content").html("adksfjlasdjfl");
			    			$(this).html('[收起]');
			    		}else{
			    			$title.find(".mail-title-to-content").html(mail_to_show);
			    			$(this).html('[显示全部]');
			    		}
			    	});
			    	$title.find(".mail-zhuanfa-more").click(function(){
			    		if($(this).html()=='[显示全部]'){
			    			$title.find(".mail-title-chaosong-content").html($.trim(mail_zhuanfa_show_copy));
			    			$(this).html('[收起]');
			    		}else{
			    			$title.find(".mail-title-chaosong-content").html(mail_zhuanfa_show);
			    			$(this).html('[显示全部]');
			    		}
			    	});
			    	if(mail_zhuanfa==''||mail_zhuanfa==null){

			    	}
		    		scaleChange();
		    		$("#mail_allInfor_div").show();//show the whole mail
		    		//TODO optmize
		    		var maxlength = Math.floor($title.width()*3/4/7);
			    	var mail_to_flag = false,
			    	mail_zhuanfa_flag = false,
			    	mail_misong_flag = false,
			    	mail_fujian_flag = false;
			    	//construct the "to" block
			    	var mailTos = emailInforV.toShow.split(",");
			    	$(mailTos).each(function(index){
			    		var mailtoName = $.trim(mailTos[index]).split("<");
			    		var toshow=mailAddressTemplate;
			    		toshow=toshow.replace("mail_from_person", " "+$.trim(mailtoName[0])).replace("mail_from_address",$.trim("&lt;"+mailtoName[1]).replace(">","&gt;"));
			    		mail_to_show+=toshow;
			    		mail_to_show_copy+=toshow;
			    	});
			    	if(maxlength<mail_to.length){
			    		mail_to_flag = true;
			    		//cut the mail to show
			    		mail_to_show="";
			    		var mailTosCut = mail_to.substring(0,mail_to_copy.substring(0,maxlength).lastIndexOf(",")).split(",");
			    		$(mailTosCut).each(function(index){
			    			if(mailTosCut[index]!=""){
					    		var mailtoName = $.trim(mailTosCut[index]).split("<");
					    		var toshow=mailAddressTemplate;
					    		toshow=toshow.replace("mail_from_person", " "+$.trim(mailtoName[0])).replace("mail_from_address",$.trim("&lt;"+mailtoName[1]).replace(">","&gt;"));
					    		mail_to_show+=toshow;
			    			}
			    		});
			    	}
			    	//mail_to = mail_to.replace(/</g,"&lt;").replace(/>/g,"&gt;");
			    	if(mail_zhuanfa!=""){
			    		//construct the "cc" block
			    		var mailCcs = emailInforV.ccShow.split(",");
			    		for(var index=0;index<mailCcs.length;index++){
			    			var mailtoName = $.trim(mailCcs[index]).split("<");
			    			var toshow=mailAddressTemplate;
			    			toshow=toshow.replace("mail_from_person", " "+$.trim(mailtoName[0])).replace("mail_from_address",$.trim("&lt;"+mailtoName[1]).replace(">","&gt;"));
			    			mail_zhuanfa_show+=toshow;
			    			mail_zhuanfa_show_copy+=toshow;
			    		}
			    		if(maxlength<mail_zhuanfa.length){ 
			    			mail_zhuanfa_flag = true;
			    			mail_zhuanfa_show="";
			    			var mailZhuanfaCut = mail_zhuanfa.substring(0,mail_zhuanfa_copy.substring(0,maxlength).lastIndexOf(",")).split(",");
			    			for(var index=0;index<mailZhuanfaCut.length;index++){
			    				if(mailZhuanfaCut[index]!=""){
			    					var mailtoName = $.trim(mailZhuanfaCut[index]).split("<");
			    					var toshow=mailAddressTemplate;
			    					toshow=toshow.replace("mail_from_person", " "+$.trim(mailtoName[0])).replace("mail_from_address",$.trim("&lt;"+mailtoName[1]).replace(">","&gt;"));
			    					mail_zhuanfa_show+=toshow;
			    				}
			    			};
			    		}
			    	}
			    	if(mail_misong!=""){
			    		//construct the "cc" block
			    		var mailBccs = emailInforV.bccShow.split(",");
			    		for(var index=0;index<mailBccs.length;index++){
			    			var mailtoName = $.trim(mailBccs[index]).split("<");
			    			var toshow=mailAddressTemplate;
			    			toshow=toshow.replace("mail_from_person", " "+$.trim(mailtoName[0])).replace("mail_from_address",$.trim("&lt;"+mailtoName[1]).replace(">","&gt;"));
			    			mail_misong_show+=toshow;
			    			mail_misong_show_copy+=toshow;
			    		}
			    		if(maxlength<mail_misong.length){ 
			    			mail_misong_flag = true;
			    			mail_misong_show="";
			    			var mailZhuanfaCut = mail_misong.substring(0,mail_misong_copy.substring(0,maxlength).lastIndexOf(",")).split(",");
			    			for(var index=0;index<mailZhuanfaCut.length;index++){
			    				if(mailZhuanfaCut[index]!=""){
			    					var mailtoName = $.trim(mailZhuanfaCut[index]).split("<");
			    					var toshow=mailAddressTemplate;
			    					toshow=toshow.replace("mail_from_person", " "+$.trim(mailtoName[0])).replace("mail_from_address",$.trim("&lt;"+mailtoName[1]).replace(">","&gt;"));
			    					mail_misong_show+=toshow;
			    				}
			    			};
			    		}
			    	}
			    	//mail_zhuanfa = mail_zhuanfa.replace(/</g,"&lt;").replace(/>/g,"&gt;");
			    	if(mail_to_flag){
			    		$title.find(".mail-to-more").show();
			    	}else{
			    		$title.find(".mail-to-more").hide();
			    	}
			    	if(mail_zhuanfa_flag){
			    		$title.find(".mail-zhuanfa-more").show();
			    	}else{
			    		$title.find(".mail-zhuanfa-more").hide();
			    	}
			    	if(mail_misong_flag){
			    		$title.find(".mail-misong-more").show();
			    	}else{
			    		$title.find(".mail-misong-more").hide();
			    	}
			    	$title.find(".mail-title-to-content").html(mail_to_show);
			    	$title.find(".mail-title-chaosong-content").html(mail_zhuanfa_show);
			    	$title.find(".mail-title-misong-content").html(mail_misong_show);
			    	var fujianHtml = "无";
		    		if(fujian!=null){
		    			
		    			fujianHtml = "";
		    			var fujianAllHtml = '';
		    			var curlength = 0;
		    			var attTotal = mailAttBlockTotalNumTemplate;
		    			//initail the attachment total number
		    			var attDetailsHtml=attTotal.replace("mail_att_num_block", fujian.length);
		    			for ( var i = 0; i < fujian.length; i++) {
		    				//mail header attachment information
		    				curlength += ($.trim(fujian[i].attname).length + 2);
		    				var temp = mailFujianTemplate;
		    				temp = temp.replace("mail_fujian_item", $.trim(fujian[i].attname));
		    				var downloadUrl = rootPath+'/emailAtt/doDownloadAttachment?attUUID='+fujian[i].uuid+'&fileName='+$.trim(fujian[i].attname);
		    				temp = temp.replace("javascript:;", downloadUrl);
		    				if(curlength<=maxlength){
		    					fujianHtml += temp;
		    					fujianAllHtml += temp;
		    				}else{
		    					fujianAllHtml += temp;
		    				}
		    				//add information to the attachment part
		    				var attBlock = mailAttBlockTemplate;
		    				attBlock = attBlock.replace("mail_att_name_block", $.trim(fujian[i].attname))
		    									.replace("mail_att_size_block",fujian[i].sizeShown)
		    									.replace("mail_att_downloadURL", downloadUrl);
		    				attDetailsHtml+=attBlock;
		    			}
		    			$("#mail_attachment_details").html(attDetailsHtml);
		    			
		    		}
		    		//fujianHtml+='<a href="javascript:;" class="upload-all clip">[打包下载全部附件]</a>';
		    		if("无"!=fujianHtml){
		    			$("#mail_attachment_details").show();
		    			//initial the attachment show
		    			if(fujianHtml.length<fujianAllHtml.length){
		    				mail_fujian_flag = true;
		    				$title.find(".mail-title-fujian-content").html("("+fujianHtml+'...)');
		    			}else{
		    				$title.find(".mail-title-fujian-content").html("("+fujianAllHtml+")");
		    			}
		    			if(mail_fujian_flag){
				    		$title.find(".mail-fujian-more").show();
				    	}else{
				    		$title.find(".mail-fujian-more").hide();
				    	}
		    			//add click function to attachment size contract function
		    			$title.find('.mail-fujian-more').click(function(){
		    				if($(this).html()=='[显示全部]'){
		    					$title.find(".mail-title-fujian-content").html("("+fujianAllHtml+")");
		    					$(this).html('[收起]');
		    				}else{
		    					$title.find(".mail-title-fujian-content").html("("+fujianHtml+'...)');
		    					$(this).html('[显示全部]');
		    				}
		    			});
		    		}else{
		    			$title.find(".mail-title-fujian-content").html(fujianHtml);
		    			$title.find(".mail-fujian-more").hide();
		    			$("#mail_attachment_details").hide();
		    		}
			    }
		    },
		    error: function() {
		        //请求出错处理
		    	layerAlert("读取邮件失败！");
		    }
		});
		
		//读取邮件正文
		$.ajax({
			url : 'email/doReadMailPart',
		    dataType: "text",   //返回格式为json
		    data: {
		    	msgId:ids,
		    	currtfolder:currFolder,
		    	partId: 0
		    	},    //参数值
		    type: "POST",   //请求方式
		    success: function(content) {
		    	$("#read_mail_content").html(content);
		    },
		    error: function() {
		        //请求出错处理
		    	layerAlert("读取邮件失败！");
		    }
		});
    }
    /**删除邮件，如果当前文件夹不为“垃圾箱”，则只是暂时删除，否则真删除
     * ids :删除的邮件id
     * currfolder ：此时文件夹
     * unreadNum ：只有当currfolder是INBOX时生效，删减文件夹后面的未读数目。
     * deleteFlag : 只有当currfolder是DRAFT时，deleteFlag生效，并且为永远删除
     */
    var delMail = function(ids, currFolder,unreadNum){
    	var url = 'email/doDelMailTempo';
    	if(currFolder=="DELETE"){
    		url = 'email/doDelMailForever'
    	}
    	
		$.ajax({
			url : url,
		    dataType: "text",   //返回格式为json
		    data: {
		    	msgIds:ids,
		    	currFolder:currFolder
		    	},    //参数值
		    type: "POST",   //请求方式
		    success: function(res) {
		    	if(res!=null){
		    		layerAlert("删除邮件成功！");
		    		//if the id contains the global mail id then hide() the mail.jsp
		    		var idarray=ids.split(",");
		    		if(idarray!=null&readMailId!=""){
		    			$(idarray).each(function(index){
		    				if(idarray[index]==readMailId){
		    					$("#mail_allInfor_div").hide();
		    				}
		    			});
		    		}
		    		//reduce the unread num
		    		if(currFolder=="INBOX"){
	    				//reduce the number by "unreadNum"
	    				operateTotalNum(1,unreadNum,"unread_mail_count");
		    		}
		    		$("#emaillist_div").show();
		    		$("#emaillist_div").show();
		    		if(getCurrFolder()!="DRAFT"){
		    			$(".read_mail_btn").show();
		    		}
		    		$(".back_to_maillist").hide();
		    	}
		    },
		    complete: function() {
		    	switchMailBtn(currFolder);
		    	refreshBootStrapTable();
		    },
		    error: function() {
		        //请求出错处理
		    	layerAlert("删除邮件失败！");
		    }
		});
    	
    }
    
    /*验证收信人是否存在，
     * usercodes ： 数组
     * return ： 如果全部存在，返回 true
     * 			如果只要收件人地址中有一个不存在，则返回false，并提示那个收件人地址不存在
     * */
    function  validateAddress(userAddress,msg){
    	if(userAddress.length==0){
    		return true;
    	}
    	var param = {userName:userAddress}; 
    	var result = false;
    	$.ajax({
    		url : 'email/checkMailAddress',
    	    dataType: "json",   //返回格式为json
    	    async: false, 
    	    data: param,
    	    type: "POST",   //请求方式
    	    success: function(res) {
    	    	if(res!=null){
    	    		var errorAdress="";
        			for(var property in res){
        				if(property=="all"){
        					result = true;
        				}else{
        					errorAdress = errorAdress + property + " ";
        				}
        			}
        			if(!result){
        				//to show the error mail address
        				layerAlert(errorAdress+msg);
        			}

    	    	}else{
    	    		layerAlert("验证收件人出错");
    	    	}
    	    },
    	    complete: function(){

    	    },
    	    error: function() {
    	        //请求出错处理
    	    	layerAlert("服务器出错！！");
    	    	result = false;
    	    }
    	});
    	return result;
    };
    
    /**删除草稿
     */
    var delDraft = function(id,showMsg){
    	var url = 'email/doDelMailForever';
		$.ajax({
			url : url,
		    dataType: "text",   //返回格式为json
		    data: {
		    	msgIds:id,
		    	currFolder:"DRAFT"
		    	},    //参数值
		    type: "POST",   //请求方式
		    success: function(res) {
		    	if(res!=null){
		    		if(showMsg){
		    			layerAlert("删除草稿成功！");
		    		}
		    	}
		    },
		    complete: function() {
		    	// refresh the mail list table
		    	refreshBootStrapTable();
		    },
		    error: function() {
		        //请求出错处理
		    	layerAlert("删除草稿失败！");
		    }
		});
    	
    }
    //refresh the bootstrap table
    var refreshBootStrapTable = function(){
    	//first destroy the table then create a new one
    	var folderSelected = getCurrFolder();
    	$('#emaillist').bootstrapTable('destroy').bootstrapTable(
    			{
    	    		url : 'email/doReadMailInfor', 
    	    		method : 'get', 
    	    		toolbar : '#toolbar', 
    	    		striped : true, 
    	    		cache : false,
    	    		pagination : true,
    	    		sortable : false, 
    	    		sortOrder : "asc", 
    	    		queryParams :function(params) {
    	    			var temp = {
    	    					rows : params.limit, 
    	    					page : params.offset,
    	    					currfolder: folderSelected
    	    			};
    	    			return temp;
    	    		}, 
    	    		sidePagination : "server", 
    	    		pageNumber : 1, 
    	    		pageSize : 10, 
    	    		search : false, 
    	    		strictSearch : false,
    	    		showColumns : false, 
    	    		showRefresh : false, 
    	    		minimumCountColumns : 2, 
    	    		clickToSelect : true, 
    	    		uniqueId : "msgId", 
    	    		showToggle : false,
    	    		cardView : false, 
    	    		detailView : false, 
    	    		columns : tableColumn,
    	    		onDblClickRow : function(row, tr) {
    	    			tableDBClick(row, tr);
    	    		},
    	    		onClickRow : function(row, tr) {
    	    		},
    	    		onLoadSuccess: function(data){
    	    		}
    	    	}
    			);
    }
    
    var addCC = function(){
    	$("#CC , #BCC").hide();
    	$("#addCC").click(function(){
    		
    		if($("#inputEmail2").val()==''){
    			if($("#CC").is(':hidden')){
    				$("#CC").show();
    			}else{
    				$("#CC").hide();
    			}
    		}else{
    			$("#CC").show();
    		}
    	});
    	$("#addBCC").click(function(){
    		if($("#inputEmail1").val()==''){
    			if($("#BCC").is(':hidden')){
    				$("#BCC").show();
    			}else{
    				$("#BCC").hide();
    			}
    		}else{
    			$("#BCC").show();
    		}
    	});
    };
    
    
    /*读取邮件列表
     * */
    var getMaillist = function(currentFolder){
    	$('#emaillist').bootstrapTable({
    		url : 'email/doReadMailInfor', 
    		method : 'get', 
    		toolbar : '#toolbar', 
    		striped : true, 
    		cache : false,
    		pagination : true,
    		sortable : false, 
    		sortOrder : "asc", 
    		queryParams :function(params) {
    			var temp = {
    					rows : params.limit, 
    					page : params.offset,
    					currfolder: currentFolder
    			};
    			return temp;
    		}, 
    		sidePagination : "server", 
    		pageNumber : 1, 
    		pageSize : 10, 
    		search : false, 
    		strictSearch : false,
    		showColumns : false, 
    		showRefresh : false, 
    		minimumCountColumns : 2, 
    		clickToSelect : true, 
    		uniqueId : "msgId", 
    		showToggle : false,
    		cardView : false, 
    		detailView : false, 
    		columns : tableColumn,
    		onDblClickRow : function(row, tr) {
    			//jquery object can be used directly
    			//get the "isRead" cell
    			var selectedIsRead = $(tr).find("td span.label").get(0);
    			//remove the bold style
    			var tds = $(tr).find("td span");
    			$(tds).each(function(index) {
    				$(tds[index]).removeClass("unRead_bold");
    			});
    			//change "unRead" to "read"
    			if($(selectedIsRead).text()=="未读"){
    				$(selectedIsRead).text("已读");
    				$(selectedIsRead).attr("class","label label-success");
    				//reduce the number of unread
    				operateTotalNum(1,1,"unread_mail_count");
    			}
    			//set the row selected
    			$(tr).addClass("selected");
    			$(tr).find("input[type='checkbox']").attr("checked",true);
    			var folder = getCurrFolder();
    			readMail(row.msgId,folder);
    		},
    		onClickRow : function(row, tr) {
    		}
    	});
    	
    }
    
    return {
        init:function(){ 
        	//alert("initializing!!!");
            liActive();
            addMenu();
            addBtnClick();
            switchMailBtn("INBOX");
            getMaillist("INBOX");
            //get unread mail count
            getUnreadEmailNum();
            //$("#test_for_wysihtml5").wysihtml5();
        },
        change:function(){
            scaleChange();
            iconChange();
            addCC();
        }
    }
})();
mail.init();
mail.change();

/**清除邮件表单内的内容
 * */
function clearMailWriteForm(){
	//clear the form
	$(':input','#write_mail_form')
	 .val('')  
	 .removeAttr('checked')  
	 .removeAttr('selected');
	//clear the fck editor
//	var editor = FCKeditorAPI.GetInstance('mail_content');
//	editor.SetHTML('',false);
	//clear the ueditor
	//ue.setContent('');
	ue.execCommand("clearDoc");
	ue.reset();
}

/**获取当前选中的文件夹
 * return :当前选中文件夹的英文名，如果是自定义的文件夹，则返回中文名
 */
function getCurrFolder(){
	//only read the selected node text, not the child nodes text.
	var folderName = $(".folder_list").find("li.active a").contents().filter(function() {
	    return this.nodeType === 3;
	}).text();
	folderName = $.trim(folderName);
	if(folderName == "收件箱"){
		return "INBOX";
	}else if(folderName == "已发送"){
		return "SEND";
	}else if(folderName == "垃圾箱"){
		return "SPAM";
	}else if(folderName == "已删除"){
		return "DELETE";
	}else if(folderName == "草稿箱"){
		return "DRAFT";
	}else{
		//the select folder is customized folder
		return folderName;
	}
}
//每隔5分钟刷新一次未读数量，不刷新inbox列表
window.setInterval("getUnreadEmailNum()", refreshTime);
function getUnreadEmailNum(){
	$.ajax({
		url : 'email/countUnreadMails',
	    dataType: "text",   //返回格式为json
	    type: "POST",   //请求方式
	    success: function(res) {
	    	if(res!=null){
	    		//alert(res);
	    		try{
	    			var unreadNum = parseInt(res);
	    			if(unreadNum>0){
	    				$("#unread_mail_count").show();
	    				$("#unread_mail_count").text('('+unreadNum+')');
	    			}else if(unreadNum==0){
	    				$("#unread_mail_count").hide();
	    				$("#unread_mail_count").text('('+unreadNum+')');
	    			}
	    			
	    		}catch(e){
	    			return null;
	    		}
	    	}
	    },
	    error: function() {
	        //请求出错处理
	    	layerAlert("获取邮件未读数量出错！！");
	    }
	});
}

/**
 * @param add : 0 is add, 1 is reduce
 * @param num : the number to operate
 * @param objectID : the operated Object ID. example: the id of one "div"
 */
function operateTotalNum(add,num,objectID){
	var totalObj = $('#'+objectID);
	//formatt like "(0)"
	//delete the "(" and ")"
	var oldTotalNum = totalObj.text().replace('(','').replace(')','');
	var newTotalNum;
	if(add==1){
		newTotalNum = parseInt(oldTotalNum) - parseInt(num);
	}else if(add==0){
		newTotalNum = parseInt(oldTotalNum) + parseInt(num);
	}else{
		return;
	}
	var showNum = '(' + newTotalNum + ')'; 
	totalObj.text(showNum);
	if(newTotalNum>0){
		totalObj.show();
	}else if(newTotalNum==0){
		totalObj.hide();
	}else{
		return;
	}
}



var mailTitleTemplate = 
	'<h2>mail_subject' +
	'</h2>' +
	'<p><span class="mail-title mail-title-from">发件人：</span>' +
	'<span class="mail-title-from-content">mail_from_block</span>' +
	'</p>' +
	'<p><span>时&nbsp;&nbsp;&nbsp;间：</span><span>mail_send_time</span></p>'+
	'<span id="title-updown" >' +
	'	<span class="mail-title mail-title-to">收件人：</span>' +
	'	<span class="mail-title-to-content">mail_to</span>' +
	'   <a href="javascript:;" class="mail-to-more clip">[显示全部]</a>' +
	'	<br/>' +
	'	<span class="mail-title mail-title-chaosong">抄送人：</span>' +
	'	<span class="mail-title-chaosong-content">mail_zhuanfa</span>' +
	'   <a href="javascript:;" class="mail-zhuanfa-more clip">[显示全部]</a>' +
	'	<br/>' +
	'</span>' +
	'<p>'+
	'	<span class="mail-title mail-title-fujian">附&nbsp;&nbsp;&nbsp;件：</span>' +
	'	<span class="mail_black">mail_att_num</span>'+
	'	<span class="mail-title-fujian-content">' +
	'	</span>' +
	'	<a href="javascript:;" class="mail-fujian-more clip">[显示全部]</a>' + 
	'</p>'+
	'<p style="background:#fbe7e7; display:show_reciever_contain_message;">提示：您是密信接收者，所以不在收件人中</p>';
var mailTitleAllTemplate = 
	'<h2>mail_subject' +
	'</h2>' +
	'<p><span class="mail-title mail-title-from">发件人：</span>' +
	'<span class="mail-title-from-content">mail_from_block</span>' +
	'</p>' +
	'<p><span>时&nbsp;&nbsp;&nbsp;间：</span><span>mail_send_time</span></p>'+
	'<span id="title-updown" >' +
	'	<span class="mail-title mail-title-to">收件人：</span>' +
	'	<span class="mail-title-to-content">mail_to</span>' +
	'   <a href="javascript:;" class="mail-to-more clip">[显示全部]</a>' +
	'	<br/>' +
	'	<span class="mail-title mail-title-chaosong">抄送人：</span>' +
	'	<span class="mail-title-chaosong-content">mail_zhuanfa</span>' +
	'   <a href="javascript:;" class="mail-zhuanfa-more clip">[显示全部]</a>' +
	'	<br/>' +
	'	<span class="mail-title mail-title-misong">密送人：</span>' +
	'	<span class="mail-title-misong-content">mail_misong</span>' +
	'   <a href="javascript:;" class="mail-misong-more clip">[显示全部]</a>' +
	'	<br/>' +
	'</span>' +
	'<p>'+
	'	<span class="mail-title mail-title-fujian">附&nbsp;&nbsp;&nbsp;件：</span>' +
	'	<span class="mail_black">mail_att_num</span>'+
	'	<span class="mail-title-fujian-content">' +
	'	</span>' +
	'	<a href="javascript:;" class="mail-fujian-more clip">[显示全部]</a>' + 
	'</p>'+
	'<p style="display:show_reciever_contain_message;">您是密信接收者，所以不在收件人中</p>';
var mailFujianTemplate =
	'<a href="javascript:;" class="clip">' +
	'	<i class="fa fa-paperclip"></i>mail_fujian_item' +
	'</a>';
/**
 * 
 */
var mailAttBlockTemplate =
/*	'<div class="title"><i class="fa fa-paperclip"></i>附件（mail_att_num_block个）</div>'+
	'<div class="clearfix">'+*/
	'	<div class="attach_con">'+
	'		<img src="'+rootPath+'/views/cap/mail/img/word.png">'+
	'		<div class="attach_sim">mail_att_name_block<span>(mail_att_size_block)</span>'+
	'			<br>'+
	'			<a href="mail_att_downloadURL" class="brn btn-link btn-add">下载</a>'+
//	'			<a href="javascript:;" class="brn btn-link btn-add">预览</a>'+
//	'			<a href="javascript:;" class="brn btn-link btn-add">收藏</a>'	+
	'		</div>'+
	'	</div>'
	/*'<div>'*/;
var mailAttBlockTotalNumTemplate ='<div class="title"><i class="fa fa-paperclip"></i>附件（mail_att_num_block个）</div>';
var mailAddressTemplate='<b>mail_from_person</b>mail_from_address';
var originalMailTemplate =
	'<div style="font-size: 14px; margin:10px;color:#3f454c;">'+
	'	<p style="line-height:1.5;">--------------原始邮件-----------</p>'+
	'	<div style="background-color:#ececec;border-radius:4px;">'+
	'		<p style="line-height:1.0;"><b style="font-weight: bold;">发件人：</b><span style="color:#888;">mail_original_mailfrom</span></p>'+
	'		<p style="line-height:1.0;"><b style="font-weight: bold;">时间：</b><span style="color:#888;">mail_original_mailtime</span></p>'+
	'		<p style="line-height:1.0;"><b style="font-weight: bold;">收件人：</b><span style="color:#888;">mail_original_mailto </span></p>'+
	'		<p style="line-height:1.0;"><b style="font-weight: bold;">抄送人：</b><span style="color:#888;">mail_original_mailcc </span></p>'+
	'		<p style="line-height:1.0;"><b style="font-weight: bold;">主题：</b><span style="color:#888;">mail_original_mailsubject </span></p>'+
	'	</div>'+
	'	<div style="padding-top:10px;line-height:1.0;">mail_original_mailcontent'+
	'	</div>'+
	'</div>';
