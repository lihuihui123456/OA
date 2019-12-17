/**
 * 页面加载时初始化相关函数
 */
var newsIdGlobal=null;
var imgSrcPathGlobal=null;
var picContentUE=UE.getEditor('sysNewsPicInforContent');
var localPicContentUE=UE.getEditor('localPicContentUE');;
var outsidePicContentUE=UE.getEditor('outsidePicContentUE');;

$(function() {
	initSysNewsMgList();
	//set the datagrid only one row can be selected
/*	$('#sysNewsMgDataGrid').datagrid({
		onClickRow: function(index,row){
			//cancel all
			$('#sysNewsMgDataGrid').datagrid("clearChecked");
			//check the select row
			$('#sysNewsMgDataGrid').datagrid("selectRow", index);
		}
	});*/
	
	getPicOutside();
});

var operatorFlag = 'save';

/**
 * 初始化部门类型列表
 * 
 * @param 无
 * @return 无
 */
function initSysNewsMgList() {
	var url = "sysNewsMgController/findByCondition";
	$('#sysNewsMgDataGrid').datagrid({
		url:url,
		method:'POST',
		idField:'newsId',
		striped:true,
		fitColumns:true,
		singleSelect:false,
		sortOrder:'desc',
		fit: true,
		rownumbers:true,
		pagination:true,
		nowrap:false,

		pageSize:10,
		showFooter:true,
		columns:[[ 
 		    { field:'ck', checkbox:true }, 
 		    { field:'newsId',   title:'newsId',	hidden:true }, 
 		    { field:'newsTittle', title:'标题',  width:180, align:'left' }, 
 		    { field:'newsNum', title:'图片数量',  width:80, align:'left' }, 
 		    { field:'orgName', title:'所属单位',  width:180, align:'left' }, 
 		    { field:'deptName', title:'所属部门',  width:180, align:'left' }, 
 		    { field:'createUserName', title:'创建人',  width:150, align:'left' }, 
 		    { field:'ts',  title:'创建日期', width:80, align:'left', formatter:formatCreateTime },
 		    { field:'isDeploy',title:'是否发布', width:70, align:'left', formatter:formatIsDeploy }
 		]],
		onClickRow: function(index,row){
		//cancel all
		$('#sysNewsMgDataGrid').datagrid("clearChecked");
		//check the select row
		$('#sysNewsMgDataGrid').datagrid("selectRow", index);
	}
	});
	//直接从第一页加载
/*	$('#sysNewsMgDataGrid').datagrid('load');*/
}

function showpics(){
	//add check selected row
	var selecteds = $('#sysNewsMgDataGrid').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		$.messager.alert('提示','请一条记录！','info');
		return;
	}
	//add check selected row if deployed
	if (selecteds[0].idDeploy === 'Y') {
		$.messager.alert('提示','所选记录还没有发布！','info');
		return;
	}
	//add check selected row's photo number
	if (selecteds[0].newsNum < 1) {
		$.messager.alert('提示','所选记录中没有轮播图片！','info');
		return;
	}
	
	window.open (ctxGlobal+'/sysNewsPicController/doGetCarouselSysNewsPic?deptId='+selecteds[0].deptId,'新闻图片轮播预览','height=1000,width=2000,top=0,left=0,toolbar=yes,menubar=no,scrollbars=yes, resizable=no,location=no, status=no');
}
/**
 * 条件查询
 */
function findByCondition() {
	//获取search的关键词
	var searchValue = $.trim($("#search").textbox("getValue"));
	if(searchValue==null){
		return;
	}
	//筛选查询条件
	if(searchValue!=null&&searchValue.indexOf('%')>=0){
		$.messager.alert('提示', '输入非法查询字符\'%\'！', 'info');
		return;
	}
	//刷新数据表
	$('#sysNewsMgDataGrid').datagrid({
		url : "sysNewsMgController/findByCondition",
		queryParams : {
			sysNewsMgTitle: searchValue,
		},
		onLoadSuccess: function(data) {
			$.messager.show({ title:'提示', msg:'搜索到 <span style="color:red">'+data.rows.length+'</span> 条数据', showType:'slide' });
		}
	});
	$('#sysNewsMgDataGrid').datagrid('clearSelections'); // 清空选中的行
}

/**
 * 添加新闻管理前的，初始化对话框
 */
function doAddSysNewsMgTypeBefore(){
	operatorFlag = 'save';
	initSysNewsMgDlg("新增新闻图片管理");
}

/**
 * 初始化部门类型编辑对话框 初始化面板 初始化数据
 */
function initSysNewsMgDlg(title) {
	$('#sysNewsMgDialog').dialog({
		title : title
	});
	$('#sysNewsMgForm').form('clear');
	$('#sysNewsMgDialog').dialog("open");
	$("#isDeploy").switchbutton("uncheck");
	//初始化org树
	initOrgTree();
	//初始化dept树
	initDeptTree();
}

/**
 * 加载部门树（添加部门）
 */
function initDeptTree(){
	var orgId = $("#orgId").val();
	if(orgId==null){
		return;
	}
	$("#deptId").combotree({
		url:'deptController/findUnSealDeptTree',
		queryParams:{
			orgId : orgId
		},
		onlyLeafCheck : false,
		cascadeCheck : false
	});
}

/**
 * 加载部门树（添加部门）
 * 设置加载单位的数值，不是树模式
 */
function initOrgTree(){
	$('#orgId').val(orgIdGlobal);
	$('#orgName').textbox('setValue',orgNameGlobal);
	$('#orgNameInput').val(orgNameGlobal);
}

/**
 * 在更新前，加载老的数据
 */
function doUpdateSysNewsMgBefore(){
	operatorFlag = 'update';
	newsIdGlobal = getTableOneSelected();
	if(newsIdGlobal==null){
		return;
	}
	var newsId = getTableOneSelected();
	if(newsId==null){
		return;
	}
	$.ajax({
		url : 'sysNewsMgController/findSysNewsMgById',
		async : false,
		dataType : 'json',
		data : {
			newsId : newsId
		},
		success : function(sysNewsMg) {
			if (sysNewsMg != null) {
				initSysNewsMgDlg("修改部门类型");
				$('#newsId').val(sysNewsMg.newsId);
				$('#newsTittle').textbox("setValue", sysNewsMg.newsTittle);
				$("#orgId").val(sysNewsMg.orgId);
				$('#orgNameInput').val(sysNewsMg.orgName)
				$("#orgName").textbox("setValue", sysNewsMg.orgName);

				$("#deptId").combotree("setValue", sysNewsMg.deptId);
				$("#deptName").val(sysNewsMg.deptName);
				var isDeploy = sysNewsMg.isDeploy;
				if (isDeploy == "N") {
					$("#isDeploy").switchbutton("uncheck"); 
				} else {
					$("#isDeploy").switchbutton("check"); 
				}
			}
		},
		error : function(result) {
			$.messager.alert('错误','修改失败！','error');
		}
	});
}

/**
 * 删除数据记录
 */
function doDeleteSysNewsMg(){
	//选择记录
	var selecteds = $('#sysNewsMgDataGrid').datagrid('getSelections');
	if (selecteds == null || selecteds.length == 0) {
		$.messager.alert('提示','请选择需要删除的记录！','info');
		return;
	}
	$.messager.confirm('删除新闻图片管理', '确定删除吗?', function(r) {
		if (r) {
			var ids = '';
			$(selecteds).each(function(index) {
				ids = ids + selecteds[index].newsId + ",";
			});
			ids = ids.substring(0, ids.length - 1);
			$.ajax({
				url : 'sysNewsMgController/doDeleteSysNewsMg',
				async : false,
				dataType : 'json',
				data : {
					ids : ids
				},
				success : function(result) {
					$.messager.show({ title:'提示', msg:'删除成功！', showType:'slide' });
					initSysNewsMgList();
					$('#sysNewsMgDataGrid').datagrid('clearSelections'); // 清空选中的行
				},
				error : function(result) {
					$.messager.show({ title:'提示', msg:'删除失败！', showType:'slide' });
				}
			});
		}
	});
}

/**
 * 新建管理和更新保存
 */
function doSaveOrUpdateSysNewsMg(){
	var url = "";
	if (operatorFlag == 'save') {
		url = "sysNewsMgController/doSaveSysNewsMg";
	} else {
		url = "sysNewsMgController/doUpdateSysNewsMg";
	}
	var is_Deploy = $("#isDeploy").switchbutton("options").checked;
	if (is_Deploy) {
		is_Deploy = "Y";
	} else {
		is_Deploy = "N";
	}
	var deptName = $("#deptId").combotree("getText");
	$('#deptName').val(deptName);
	var obj = $('#sysNewsMgForm').serialize()+'&'+'isDeploy='+is_Deploy;
	$.ajax({
		url : url,
		async : false,
		type : "post",
		data : obj,
		beforeSend : function() {
			$('input.easyui-validatebox').validatebox('enableValidation');
			return $('#postTypeForm').form('validate');
		},
		success : function(data) {
			if (operatorFlag == 'save') {
				if(data.result == "true"){
					$.messager.show({ title:'提示', msg:'添加成功', showType:'slide' });
					$('#sysNewsMgDialog').dialog('close');
					$('#sysNewsMgDataGrid').datagrid('clearSelections'); // 清空选中的行
				}else{
					$.messager.show({ title:'提示', msg:'添加失败,标题名字重名!', showType:'slide' });
				}
			} else {
				if(data.result == "true"){
					$.messager.show({ title:'提示', msg:'修改成功', showType:'slide' });
					$('#sysNewsMgDialog').dialog('close');
					$('#sysNewsMgDataGrid').datagrid('clearSelections'); // 清空选中的行
				}else{
					$.messager.show({ title:'提示', msg:'修改失败,标题名字重名!', showType:'slide' });
				}
			}
			initSysNewsMgList();
		}
	});
}

/**
 * 获取一条记录发布
 */
function doDeploySysNews(){
	
	var url = "sysNewsMgController/doDeploySysNewsMg";
	var newsId = getTableOneSelected();
	if(newsId==null){
		return;
	}
	$.ajax({
		url : url,
		async : false,
		type : "post",
		data : {
			newsId:newsId
		},
		success : function(data) {
			if (data!=null) {
				$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
			} 
			initSysNewsMgList();
		}
	});
}

/**
 * 获取选中表的一条记录，不是一条返回空并给出提示，
 * @returns： 数据的newsId
 */
function getTableOneSelected(){
	var data = $('#sysNewsMgDataGrid').datagrid('getChecked');
	if (data == "" || data.length > 1) {
		$.messager.alert('提示','请选择一行记录！','info');
		return null;
	}
	newsIdGlobal = data[0].newsId;
	return data[0].newsId;
}

/**
 * 管理新闻图片，点击管理图片按钮触发
 */
function doManagePics(){
	var newsId=null
	newsId = getTableOneSelected();
	if(newsId==null){
		return;
	}
	$('#newsPicUpMgDialog').dialog({
		title : "新闻图片管理"
	});
	$('#picsQueue .uploadPics').remove();
	$('#newsPicUpMgDialog').dialog('open');

	//initial the picqueue
	initialPicQueue(newsId);
	//clear the pic infor block form
	$('#newsPicUpMgDialog #sysNewsPicInforBlockForm').hide().form('clear');
	picContentUE=UE.getEditor('sysNewsPicInforContent');
}

/**
 * 根据newsId初始化新闻图片轮播的iframe
 * @param newsId
 */
function initialPicPreview(newsId){
	$('#picCarouselPreview').attr('src',ctxGlobal+'/sysNewsPicController/doCarouselSysNewsPic?newsId='+newsId);
}

/**
 * 根据newsId初始化新闻图片队列
 * @param newsId
 */
function initialPicQueue(newsId){
	//remove the infor block
	$('#sysNewsPicInforList').find('.inforBlock').remove();
	//initial set the pic infor input can not be modified
	$('.inforBlock').find('input[name="picTitle"]').attr('disabled','disabled');
	$('.inforBlock').find('input[name="picDes"]').attr('disabled','disabled');
	$('.inforBlock').find('input[name="picContent"]').attr('disabled','disabled');
	$('.inforBlock').find('input[name="picUrl"]').attr('disabled','disabled');	
	
	//remov the modify block
	$('.sysNewsPicInforModifyBlock').remove();
	$.ajax({
		url : 'sysNewsPicController/doFindSysNewsPicList',
		type : "post",
		async : false,
		data : {
			newsId:newsId
		},
		success : function(data) {
			if(data!=null){
				var picItem;
				for(var i=0;i<data.length;i++){
					picItem = data[i];
					var fileName = picItem.picPath.substring(picItem.picPath.lastIndexOf('/')+1);
					var picPath = picItem.picPath;
					//生成图片的div模块
					createPicBlock(fileName,picPath,picItem);
				}
				if(data.length>0){
					//triger a click on the first pic
					var picId= data[data.length-1].picId;
					$('#'+picId+' .picInQueue').click();
				}
			}
		}
	});
	
}


/**
 * 获取图片链接，当外部地址输入框中输入“回车”，则获取图片
 */
function getPicOutside(){
	$('#picOutsideSelectInput').bind('keypress',function(event){
		//当外部地址输入框中输入“回车”，则获取图片
		if(event.keyCode == "13")    
		{
			$('#upOutsideNewsPic').find('img').attr('src',$('#picOutsideSelectInput').val());
			//加载图片完成
			$('#upOutsideNewsPic').find('img').load(
					function(){
						//TODO 加载图片完成
						//验证图片链接是否正确
					});
		}
	});
}

/**
 * 上传本地或上传外部新闻图片打开对话框
 * @param flag
 */
function doUploadPic(flag){
	if(flag=='1'){
		var temp = $('#upLoadNewsPic');
		temp.dialog({
			title : "本地新闻图片上传"
		});
		temp.dialog('open');
		temp.find('form').form('clear');
		temp.find('picResImg').removeAttr("src");
		//localPicContentUE = UE.getEditor('localPicContentUE');
		localPicContentUE.setContent("");
		
	}else if(flag=='2'){
		var temp = $('#upOutsideNewsPic');
		temp.dialog({
			title : "外部新闻图片上传"
		});
		temp.dialog('open');
		temp.find('form').form('clear');
		temp.find('picResImg').removeAttr("src");
		//outsidePicContentUE = UE.getEditor('outsidePicContentUE');
		outsidePicContentUE.setContent("");
	}
}

/**
 * 保存本地图片
 * @param fileName：图片的名字
 */
function doSaveSysNewsPic(fileName){
	var pidItem=new Object();
	pidItem.picTitle=$('#upLoadNewsPic').find('#picTitle').val();
	pidItem.picDes=$('#upLoadNewsPic').find('#picDes').val();
	//pidItem.picContent=$('#upLoadNewsPic').find('#picContent').val();
	//get the modify pic ue content 
	pidItem.picContent=localPicContentUE.getContent();
	pidItem.picUrl=$('#upLoadNewsPic').find('#picUrl').val();
	pidItem.isOutside='N';
	//remove the modify block
	$('.sysNewsPicInforModifyBlock').remove();
	$.ajax({
		url : 'sysNewsPicController/doSaveSysNewsPic',
		type : "post",
		async : false,
		data : {
			fileName:fileName,
			newsId:newsIdGlobal,
			picTitle:pidItem.picTitle,
			picDes:pidItem.picDes,
			picContent:pidItem.picContent,
			picUrl:pidItem.picUrl,
			isOutside:'N'
		},
		beforeSend : function() {
			var title = $('#upLoadNewsPic #picTitle').val();
			if(title!=null&&title!=""){
				//disable the form to prevent repeat submit
				$('#saveSysNewsPicBtn').linkbutton('disable');    //禁用按钮
				return true;
			}else{
				$.messager.show({ title:'提示', msg:"新闻图片标题为空！", showType:'slide' });
				return false;
			}
		},		
		success : function(data) {
			if(data!=null){
				if(data.state=="2"){
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
					$('#upLoadNewsPic').dialog('close');
					//add the pic block
					pidItem.picId = data.picId;
					createPicBlock(fileName ,imgSrcPathGlobal,pidItem);
				}else if(data.state=="1"){
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
				}
			}
		},
		complete: function(){
			$('#saveSysNewsPicBtn').linkbutton('enable');    //启用按钮
			
		}
	});
}
/**
 * 保存外部图片
 * @param fileName
 */
function doSaveOutSysNewsPic(fileName){
	var pidItem=new Object();
	pidItem.picTitle=$('#upOutsideNewsPic').find('#picTitle').val();
	pidItem.picDes=$('#upOutsideNewsPic').find('#picDes').val();
	pidItem.picContent=outsidePicContentUE.getContent();
	pidItem.picUrl=$('#upOutsideNewsPic').find('#picUrl').val();
	pidItem.isOutside='Y';
	pidItem.picPath = $('#picOutsideSelectInput').val();
	//remove the modify block
	$('.sysNewsPicInforModifyBlock').remove();
	$.ajax({
		url : 'sysNewsPicController/doSaveSysNewsPic',
		type : "post",
		async : false,
		data : {
			fileName:fileName,
			newsId:newsIdGlobal,
			picTitle:pidItem.picTitle,
			picDes:pidItem.picDes,
			picContent:pidItem.picContent,
			picUrl:pidItem.picUrl,
			isOutside:'Y',
			picPath:pidItem.picPath
		},
		beforeSend : function() {
			$('input.easyui-validatebox').validatebox('enableValidation');
			if($('#upLoadOutSideNewsPicForm').form('validate')){
				//disable the form to prevent repeat submit
				$('#saveOutSysNewsPicBtn').linkbutton('disable');    //禁用按钮
				return true;
			}else{
				return false;
			}
		},	
		success : function(data) {
			if(data!=null){
				if(data.state=="2"){
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
					$('#upOutsideNewsPic').dialog('close');
					//add the pic block
					pidItem.picId = data.picId;
					createPicBlock(fileName ,imgSrcPathGlobal,pidItem);
				}else if(data.state=="1"){
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
				}
			}
		},
		complete: function(){
			$('#saveOutSysNewsPicBtn').linkbutton('enable');
		}
	});
}

var sysNewsPicInforModifyFlag=false;

/**
 * 根据newsId刷新新闻图片轮播的iframe
 * @param newsId
 */
function previewSysNewsPicCarousel(){
	
	var newsId = getTableOneSelected();
	
	window.open (ctxGlobal+'/sysNewsPicController/doCarouselSysNewsPic?newsId='+newsId,'新闻图片轮播预览','height=1000,width=2000,top=0,left=0,toolbar=yes,menubar=no,scrollbars=yes, resizable=no,location=no, status=no');
}

/**
 * 创建新闻图片的div的模块，包括图片模块、图片功能事件、图片信息模块，图片信息修改事件
 * @param fileName：图片名字
 * @param imgPath：图片路径
 * @param picItem：模块
 */
function createPicBlock(fileName ,imgPath,picItem){
	var picBlock=$('#picBlock').clone(true);
	var picId= picItem.picId;
	if(picItem.isOutside=='N'){
		picBlock.find('.picInQueue').attr("src", "sysNewsPicController/doDownLoadPicFile?picPath=" + imgPath + "&r="+new Date()).attr('style','width:80px;height:80px;');
	}else{
		picBlock.find('.picInQueue').attr("src", picItem.picPath);
	}
	picBlock.find('.selectBefore').attr("src", ctxGlobal+modeladdres+'/img/selectBefore.png');
	picBlock.find('.selectAfter').attr("src", ctxGlobal+modeladdres+'/img/selectAfter.png');
	picBlock.find('.delPic').attr("src", ctxGlobal+modeladdres+'/img/delPic.png');
	picBlock.attr('id',picId);
	picBlock.attr('class','uploadPics');
	//add show pic function
	picBlock.find('.unshowSysNewsPicBtn').click(
			function(){
				
				newsIdGlobal = getTableOneSelected();
				var newsId = getTableOneSelected();
				if(newsId==null){
					return;
				}
				var para=null;
				if(picItem.isOutside=='N'){
					para=fileName;
				}else{
					para= picItem.picPath;
				}
				$.ajax({
					url : 'sysNewsPicController/doUnshowSysNewsPic',
					type : "post",
					async : false,
					data : {
						fileName:para,
						isOutside:picItem.isOutside
					},
					success : function(data) {
						if(data!=null){
							if(data.state=="1"){
								$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
								//initialPicPreview(newsId);
								//show the "use" button
								picBlock.find('.unshowSysNewsPicBtn').hide();
								picBlock.find('.showSysNewsPicBtn').show();
							}else if(data.state=="2"){
								$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
							}
						}
					}
				});
			});	
	picBlock.find('.showSysNewsPicBtn').click(
			function(){
				newsIdGlobal = getTableOneSelected();
				var newsId = getTableOneSelected();
				if(newsId==null){
					return;
				}
				var para=null;
				if(picItem.isOutside=='N'){
					para=fileName;
				}else{
					para= picItem.picPath;
				}
				$.ajax({
					url : 'sysNewsPicController/doShowSysNewsPic',
					type : "post",
					async : false,
					data : {
						fileName:para,
						isOutside:picItem.isOutside
					},
					success : function(data) {
						if(data!=null){
							if(data.state=="1"){
								$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
								//initialPicPreview(newsId);
								picBlock.find('.unshowSysNewsPicBtn').show();
								picBlock.find('.showSysNewsPicBtn').hide();
							}else if(data.state=="2"){
								$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
							}
						}
					}
				});
			});
	if(picItem.isShow=='Y'){
		picBlock.find('.unshowSysNewsPicBtn').show();
		picBlock.find('.showSysNewsPicBtn').hide()
	}else{
		picBlock.find('.unshowSysNewsPicBtn').hide();
		picBlock.find('.showSysNewsPicBtn').show();
	}
	
	
	//add delete pic function
	picBlock.find('.delSysNewsPicBtn').click(function(){
		newsIdGlobal = getTableOneSelected();
		var newsId = getTableOneSelected();
		if(newsId==null){
			return;
		}

		$.ajax({
			url : 'sysNewsPicController/doDeleteSysNewsPicByPicId',
			type : "post",
			async : false,
			data : {
				picId :picId
			},
			success : function(data) {
				if(data!=null){
					if(data.state=="1"){
						$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
						//initialPicPreview(newsId);
						if(picBlock.find('.picInQueue').hasClass('selectedPic')){
							$('#sysNewsPicInforBlock').hide();
						}
						picBlock.remove();
					}else if(data.state=="2"){
						$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
					}
				}
			}
		});
	});
	//add the click function
	//click the pic show the information
	picBlock.find('.picInQueue').click(function(){
		//add a select effect to the pic item in the queue
		//remove the old select pic
		$('#picsQueue .picInQueue').removeClass('selectedPic');
		//add effect class
		picBlock.find('.picInQueue').addClass('selectedPic');
		//var picContentUE= UE.getEditor('sysNewsPicInforContent');
		
		$.ajax({
			url : 'sysNewsPicController/doGetPicInforById',
			type : "post",
			async : true,
			data : {
				picId :picId
			},
			success : function(data) {
				if(data!=null){
					if(data.state=="1"){
						var inforblock = $('#sysNewsPicInforBlock');
						$('#newsPicUpMgDialog #sysNewsPicInforBlockForm').show();
						inforblock.find('input[name="picId"]').val(data.pic.picId);
						inforblock.find('#picTitle').textbox("setValue",data.pic.picTitle);
						inforblock.find('#picDes').textbox("setValue",data.pic.picDes);
						picContentUE.setContent(data.pic.picContentShow);
						//inforblock.find('#picContent').textbox("setValue",data.pic.picContent);
						inforblock.find('#picUrl').textbox("setValue",data.pic.picUrl);
						if(data.pic.isOutside=="Y"){
							$('#sysPicLinkColumn').show();
						}else{
							$('#sysPicLinkColumn').hide();
						}
					}else if(data.state=="2"){
						$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
					}
				}
			}
		});
		$('#sysNewsPicInforBlock').show();
		
	});
	picBlock.show();
	picBlock.prependTo('#picsQueue');
}



/**
 * 保存图片信息
 */
function doSavePicInfor(){
	//update the infor
	var obj = $('#sysNewsPicInforBlock').find('form').serialize();
	obj.picContent = picContentUE.getContent();
	$.ajax({
		url : 'sysNewsPicController/doUpdatePicInforByPicId',
		type : "post",
		async : false,
		data : obj,
		beforeSend : function() {
			$('input.easyui-validatebox').validatebox('enableValidation');
			if($('#sysNewsPicInforBlockForm').form('validate')){
				//disable the form to prevent repeat submit
				$('#picInforBlockSaveBtn').linkbutton('disable');    //禁用按钮
				return true;
			}else{
				return false;
			}
		},
		success : function(data) {
			if(data!=null){
				if(data.state=="1"){
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
				}else if(data.state=="2"){
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
				}
			}
		},
		complete:function(){
			$('#picInforBlockSaveBtn').linkbutton('enable'); 
		}
	});
}

/**
 * 根据图片名设置图片为“不展示”
 * @param fileName
 */
function doUnshowSysNewsPic(fileName){
	newsIdGlobal = getTableOneSelected();
	var newsId = getTableOneSelected();
	if(newsId==null){
		return;
	}
	$.ajax({
		url : 'sysNewsPicController/doUnshowSysNewsPic',
		type : "post",
		async : false,
		data : {
			fileName:fileName
		},
		success : function(data) {
			if(data!=null){
				if(data.state=="1"){
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
					//initialPicPreview(newsId);
				}else if(data.state=="2"){
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
				}
			}
		}
	});
}
/**
 * 根据图片名设置图片为“展示”
 * @param fileName
 */
function doShowSysNewsPic(fileName){
	newsIdGlobal = getTableOneSelected();
	var newsId = getTableOneSelected();
	if(newsId==null){
		return;
	}
	$.ajax({
		url : 'sysNewsPicController/doShowSysNewsPic',
		type : "post",
		async : false,
		data : {
			fileName:fileName
		},
		success : function(data) {
			if(data!=null){
				if(data.state=="1"){
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
					//initialPicPreview(newsId);
				}else if(data.state=="2"){
					$.messager.show({ title:'提示', msg:data.msg, showType:'slide' });
				}
			}
		}
	});
}

/**
 * 选择文件后，将文件上传到服务器，再将服务器生成的文件下载到客户端
 * 注：为了防止浏览器无法读取本地文件，故需要上传文件到客户端后再读取
 */
function fileOnchange() {

	var picSrc = $('#file').filebox('getValue');
	if(picSrc==null||picSrc==''){
		return;
	}
	//TODO 大写判断
	if (picSrc.indexOf(".jpg") < 0 && picSrc.indexOf(".jpeg") <0 && picSrc.indexOf(".png") < 0 && picSrc.indexOf(".bmp") < 0) {
		$.messager.alert('提示', '仅支持jpg、jpeg、png、bmp格式图片，请重新选择！', 'info');
		//$("#file").filebox('setValue', '');
		return;
	}
	
	// 当选择图片后上传图片到服务器，再下载
	// 注：未放置不能读取本地文件故需先上传后再下载写入到IMG控件中
	$('#upLoadNewsPicForm').form('submit', {
		url : 'sysNewsPicController/upfileImg',
	    success:function(data){
	    	var retval = eval("("+data+")");
	    	var curPicPath = retval.filePath;
	    	//$("#themePic").val(curPicPath);
	    	var fileName = retval.fileName;
	    	imgSrcPathGlobal=curPicPath;
	    	// 从服务器下载当前上传的图片路径，并赋值到IMG控件中
			//$("#picResImg").attr("src", "");
	    	$("#picResImg").attr("src", "sysNewsPicController/doDownLoadPicFile?picPath=" + curPicPath + "&r="+new Date());
	    	$('#saveSysNewsPicBtn').attr('onclick','doSaveSysNewsPic("'+fileName+'")')
	    },
	    error:function(data){
	    	alert("执行出现异常");
	    }
	});
}




/*************************** 格式化字段值 ***************************/
/**
 * 格式化是否封存字段
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatIsDeploy(val, row) {
	if(val == 'Y'){
		return "是";
	}else{
		return "否";
	}
}

/**
 * 清空查询框值
 * 
 * @param 无
 * @returns 无
 */
function clearSearchBox(){
	 $("#search").searchbox("setValue", "");
	 $('#sysNewsMgDataGrid').datagrid()
}

/**
 * 格式化创建时间
 * 
 * @param val 当前值
 * @param row 当前行
 * @return {String} 返回格式化后的值
 */
function formatCreateTime(val, row) {
	//格式化时间，截取年月日
	return val.substring(0,10);
}