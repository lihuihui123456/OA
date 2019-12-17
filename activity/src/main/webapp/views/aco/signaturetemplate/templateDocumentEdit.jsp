<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>金格科技-iWebOffice2015</title>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/bootstrap/css/style.min.css" rel="stylesheet">

<script type="text/javascript">
var filepath="${mFilePath}";
</script>
<script src="${ctx}/views/aco/signaturetemplate/js/WebOffice.js"></script>
<link rel='stylesheet' type='text/css' href='${ctx}/static/cap/plugins/iweboffice/css/iWebProduct.css' />

<!-- 以下为2015主要方法 -->
<script type="text/javascript">
 	var WebOffice = new WebOffice2015(); //创建WebOffice对象
</script>

<script type="text/javascript">
	$(function(){
		 var isNotLoad = true;/**公共方法**/	
			$(".tableAll").click(function(){
		        if(isNotLoad){
		            isNotLoad = false;	 
					  var noneY = $(this).next().css("display");
					  $(".tableAll").next().css("display","none");
					  $(".tableAll").find('td:eq(0)').css({'background-color':'#E6DBEC'});
					  $(".tableAll").find('span:eq(0)').html('+');
						  if( noneY== 'none'){
							  var s = $(this).find('td:eq(0)').html();                
							  $(this).find('td:eq(0)').html(s.replace("+", "-")) ;                              
							  $(this).find('td:eq(0)').css({'background-color':'#FFFFFF'});
				              $(this).next().slideToggle(function(){isNotLoad = true;});
						  }else{
							  isNotLoad = true;
						  }
		            }
			});
			var hide = false;	//下拉
			$("#disPlayNone").click(function(){
				 if(hide){
					 $('#showTD').width('204px');
					 $(this).siblings().css("display", "")
					 hide = false;
				 }else{	
					 $('#showTD').width('25px');
					 $(this).siblings().css("display", "none")
					 hide = true;
				 }
			});		
		WebOffice.WebShow(true,false);		//添加显示痕迹标记
		addOption(initDict('signtype'));
		var difType="${template.difType_}";
		if(difType!=null&&difType!=''){
		$('#difType_').val(difType);	
		}
	});
	function initDict(dicttype) {
		var temp;
		$.ajax({
			url : '${ctx}/dictController/findDictByTypeCode',
			type : "post",
			async : false,
			dataType : "json",
			data : {
				"showAll" : "showAll",
				"dictTypeCode" : dicttype
			},
			success : function(data) {
				temp = data;
			}
		});
		return temp;
	}
	function addOption(obj) {
		var value;
		var text;
		$(obj).each(function(index) {
			document.getElementById("difType_").options.add(
				new Option(this.dictVal, this.dictCode)
			);
		})
	}
 	function Load(){
 	  try{
 	  		WebOffice.WebUrl="${mServerUrl}";             //WebUrl:系统服务器路径，与服务器文件交互操作，如保存、打开文档，重要文件
 	  		WebOffice.RecordID="${mRecordID}";            //RecordID:本文档记录编号
		    WebOffice.FileName="${mFileName}";            //FileName:文档名称
		    WebOffice.FileType="${mFileType}";            //FileType:文档类型  .doc  .xls  
		    WebOffice.UserName="${mUserName}";            //UserName:操作用户名，痕迹保留需要
		    WebOffice.FilePath="${mFilePath}";
		    WebOffice.EditType="${mEditType}";				//0查看
		    WebOffice.AppendMenu("1","打开本地文件(&L)");    //多次给文件菜单添加
		    WebOffice.AppendMenu("2","保存本地文件(&S)");
			WebOffice.AppendMenu("3","-");
			WebOffice.AppendMenu("4","打印预览(&C)");
			WebOffice.AppendMenu("5","退出打印预览(&E)");
			WebOffice.AddCustomMenu();                       //一次性多次添加包含二次菜单
			WebOffice.Skin('purple');                        //设置皮肤
		    WebOffice.HookEnabled();
		    WebOffice.SetCaption(); 
		    WebOffice.SetUser("${mUserName}");
		    if(WebOffice.WebOpen()){                           //打开该文档    交互OfficeServer  调出文档OPTION="LOADFILE"
		    	WebOffice.setEditType("1");         //EditType:编辑类型  方式一   WebOpen之后
			    WebOffice.VBASetUserName(WebOffice.UserName);    //设置用户名
			    getEditVersion();//判断是否是永中office
			    WebOffice.AddToolbar();//打开文档时显示手写签批工具栏
			    WebOffice.ShowCustomToolbar(true);//自定义工具栏
			    /*  显示手签，因报语法错误，暂时屏蔽  */
			    /* WebOffice.ShowWritingUser(true,"${mUserName}"); */
				StatusMsg(WebOffice.Status);
			  
		    }
 	  }catch(e){
 	     layerAlert(e.description);       
 	  }
 	}
	 //作用：保存文档
	function SaveDocument(){
	  if (WebOffice.WebSave()){    //交互OfficeServer的OPTION="SAVEFILE"
		  if($("#iWebOfficeForm").validationEngine('validate')){
			  $.ajax({
					type : "POST",
					url : '${ctx}/signatureTemplate/doSaveTemplate',
					dataType : 'json',
					data : $("#iWebOfficeForm").serialize(),
					success : function(result) {
						window.parent.closePage(window,true,true,true);
					}
				});
		     return true; 
		  }
	  }else{
	     StatusMsg(WebOffice.Status);
	     return false;
	  }
	}
 	//设置页面中的状态值
 	function StatusMsg(mValue){
 	   try{
	   document.getElementById('state').innerHTML = mValue;
	   }catch(e){
	     return false;
	   }
	}
	//作用：获取文档Txt正文
	function WebGetWordContent(){
	  try{
	    layerAlert(WebOffice.WebObject.ActiveDocument.Content.Text);
	  }catch(e){
		  layerAlert(e.description);}
	}
	//作用：写Word内容
	function WebSetWordContent(mText){
	  //var mText=window.prompt("请输入内容:","测试内容");
	  if (mText==null){
	     return (false);
	  }else{
	     WebOffice.WebObject.ActiveDocument.Application.Selection.Range.Text= mText+"\n";
	  }
	}
	//作用：获取文档页数
	function WebDocumentPageCount(){
	    if (WebOffice.FileType==".doc"||WebOffice.FileType==".docx"){
		var intPageTotal = WebOffice.WebObject.ActiveDocument.Application.ActiveDocument.BuiltInDocumentProperties(14);
		intPageTotal = WebOffice.blnIE()?intPageTotal:intPageTotal.Value();
		layerAlert("文档页总数："+intPageTotal);
	    }
	    if (WebOffice.FileType==".wps"){
			var intPageTotal = WebOffice.WebObject.ActiveDocument.PagesCount();
			layerAlert("文档页总数："+intPageTotal);
	    }
	}
	//作用：显示或隐藏痕迹[隐藏痕迹时修改文档没有痕迹保留]  true表示隐藏痕迹  false表示显示痕迹
	function ShowRevision(mValue){
	  if (mValue){
	     WebOffice.WebShow(true,true);
	     StatusMsg("显示痕迹...");
	  }else{
	     WebOffice.WebShow(true,false);
	     StatusMsg("隐藏痕迹...");
	  }
	}
	
	//接受文档中全部痕迹
	function WebAcceptAllRevisions(){
	  WebOffice.WebObject.ActiveDocument.Application.ActiveDocument.AcceptAllRevisions();
	  var mCount = WebOffice.WebObject.ActiveDocument.Application.ActiveDocument.Revisions.Count;
	  if(mCount>0){
	    return false;
	  }else{
	    return true;
	  }
	}
	
	//作用：VBA套红
	function WebInsertVBA(){
		try{
	   	var myRange=WebOffice.WebObject.ActiveDocument.Range(0,0);
		myRange.Select();
		mtext="西藏公安厅情报中心";
		WebOffice.WebObject.ActiveDocument.Application.Selection.Range.InsertAfter (mtext);
		myRange=WebOffice.WebObject.ActiveDocument.Paragraphs(1).Range;
		myRange.ParagraphFormat.Alignment=0;
		myRange.font.ColorIndex=1;
		myRange.Font.Name="仿宋_GB2312";
		myRange.Font.Size=14;
		myRange.font.Spacing=4.8;
		mtext="编";
		WebOffice.WebObject.ActiveDocument.Application.Selection.Range.InsertAfter (mtext+"\n");
		myRange=WebOffice.WebObject.ActiveDocument.Paragraphs(1).Range;
		myRange.ParagraphFormat.Alignment=1;
		myRange.Font.Name="仿宋";
		myRange.Font.Size=14;
		myRange.font.ColorIndex=1;
		mtext="西藏反恐怖协调小组情报中心";
		WebOffice.WebObject.ActiveDocument.Application.Selection.Range.InsertAfter (mtext+"\n");
		myRange=WebOffice.WebObject.ActiveDocument.Paragraphs(1).Range;
		myRange.ParagraphFormat.Alignment=0;
		myRange.font.ColorIndex=1;
		myRange.font.Spacing=0.9;
		myRange.Font.Name="仿宋";
		myRange.Font.Size=14;
		mtext="情报会商";
		WebOffice.WebObject.ActiveDocument.Application.Selection.Range.InsertAfter (mtext+"\n\n");
		myRange=WebOffice.WebObject.ActiveDocument.Paragraphs(1).Range;
		myRange.Font.ColorIndex=6;
		myRange.Font.Name="宋体";
		myRange.font.Bold=true;
		myRange.Font.Size=65;
		myRange.ParagraphFormat.Alignment=1;
		myRange.ParagraphFormat.LineSpacingRule =5;
		WebOffice.WebObject.ActiveDocument.PageSetup.LeftMargin=70;
		WebOffice.WebObject.ActiveDocument.PageSetup.RightMargin=70;
		WebOffice.WebObject.ActiveDocument.PageSetup.TopMargin=70;
		WebOffice.WebObject.ActiveDocument.PageSetup.BottomMargin=70;
		var object=WebOffice.WebObject.ActiveDocument;
		var myl=object.Shapes.AddLine(30,290,560,290);
		myl.Line.ForeColor=255;
		myl.Line.Weight=2; 
		}catch(e){
		 layerAlert(e);
		}
	}

	//作用：设置书签值  vbmName:标签名称，vbmValue:标签值   标签名称注意大小写
	function SetBookmarks(){
		try{
			var mText=window.prompt("请输入书签名称和书签值，以','隔开。","例如：book1,book2");
			var mValue = mText.split(",");
			BookMarkName = mValue[0];
			BookMarkValue = mValue[1];
			WebOffice.WebSetBookmarks(mValue[0],mValue[1]);
			StatusMsg("设置成功");
			return true;
		}catch(e){
			StatusMsg("书签不存在");
			return false;
		}
	}
	//打开书签窗口
	function WebOpenBookMarks(){	
			WebOffice.WebOpenBookMarks();
		 }
	//添加书签
	function WebAddBookMarks(){//书签名称，书签值
		WebOffice.WebAddBookMarks("JK","KingGrid");
	}
	 //定位书签
	function WebFindBookMarks(){
		WebOffice.WebFindBookMarks("JK");
	 }
	 //删除书签
	function WebDelBookMarks(){//书签名称，
	    WebOffice.WebDelBookMarks("JK");//删除书签
	 }
         
	function DelFile(){
	   var mFileName = WebOffice.FilePath+WebOffice.FileName;
       WebOffice.Close(); 
       WebOffice.WebDelFile(mFileName);
	}
	//作用：用Excel求和
	function WebGetExcelContent(){
	  if(!WebOffice.WebObject.ActiveDocument.Application.Sheets(1).ProtectContents){
		  WebOffice.WebObject.ExitExcelEditMode();
		  WebOffice.WebObject.Activate(true);  
		  WebOffice.WebObject.ActiveDocument.Application.Sheets(1).Select();
		  WebOffice.WebObject.ActiveDocument.Application.Range("C5").Select();
		  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "126";
		  WebOffice.WebObject.ActiveDocument.Application.Range("C6").Select();
		  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "446";
		  WebOffice.WebObject.ActiveDocument.Application.Range("C7").Select();
		  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "556";
		  WebOffice.WebObject.ActiveDocument.Application.Range("C5:C8").Select();
		  WebOffice.WebObject.ActiveDocument.Application.Range("C8").Activate();
		  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "=SUM(R[-3]C:R[-1]C)";
		  WebOffice.WebObject.ActiveDocument.Application.Range("D8").Select();
		  WebOffice.WebObject.ActiveDocument.application.sendkeys("{ESC}");
		  StatusMsg(WebOffice.WebObject.ActiveDocument.Application.Range("C8").Text);
	  }
	
	}
	
		//作用：保护工作表单元
	function WebSheetsLock(){
		 if(!WebOffice.WebObject.ActiveDocument.Application.Sheets(1).ProtectContents){
	  WebOffice.WebObject.ActiveDocument.Application.Range("A1").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "产品";
	  WebOffice.WebObject.ActiveDocument.Application.Range("B1").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "价格";
	  WebOffice.WebObject.ActiveDocument.Application.Range("C1").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "详细说明";
	  WebOffice.WebObject.ActiveDocument.Application.Range("D1").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "库存";
	  WebOffice.WebObject.ActiveDocument.Application.Range("A2").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "书签";
	  WebOffice.WebObject.ActiveDocument.Application.Range("A3").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "毛笔";
	  WebOffice.WebObject.ActiveDocument.Application.Range("A4").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "钢笔";
	  WebOffice.WebObject.ActiveDocument.Application.Range("A5").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "尺子";
	
	  WebOffice.WebObject.ActiveDocument.Application.Range("B2").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "0.5";
	  WebOffice.WebObject.ActiveDocument.Application.Range("C2").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "樱花";
	  WebOffice.WebObject.ActiveDocument.Application.Range("D2").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "300";
	
	  WebOffice.WebObject.ActiveDocument.Application.Range("B3").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "2";
	  WebOffice.WebObject.ActiveDocument.Application.Range("C3").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "狼毫";
	  WebOffice.WebObject.ActiveDocument.Application.Range("D3").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "50";
	
	  WebOffice.WebObject.ActiveDocument.Application.Range("B4").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "3";
	  WebOffice.WebObject.ActiveDocument.Application.Range("C4").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "蓝色";
	  WebOffice.WebObject.ActiveDocument.Application.Range("D4").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "90";
	
	  WebOffice.WebObject.ActiveDocument.Application.Range("B5").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "1";
	  WebOffice.WebObject.ActiveDocument.Application.Range("C5").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "20cm";
	  WebOffice.WebObject.ActiveDocument.Application.Range("D5").Select();
	  WebOffice.WebObject.ActiveDocument.Application.ActiveCell.FormulaR1C1 = "40";
	
	  //保护工作表
	  WebOffice.WebObject.ActiveDocument.Application.Range("B2:D5").Select();
	  WebOffice.WebObject.ActiveDocument.Application.Selection.Locked = false;
	  WebOffice.WebObject.ActiveDocument.Application.Selection.FormulaHidden = false;
	  WebOffice.WebObject.ActiveDocument.Application.ActiveSheet.Protect(true,true,true);
	  StatusMsg("已经保护工作表，只有B2-D5单元格可以修改。");
		 }
	}
	
	//根据当空打开的文档类型保存文档
	function WebOpenLocal(){
	   WebOffice.WebOpenLocal();
	   //WebOffice.WebDelFile(WebOffice.FilePath+WebOffice.FileName);
	   //WebOffice.FileType = WebOffice.WebGetDocSuffix();
	   //WebOffice.FileName = WebOffice.FileName.substring(0,WebOffice.FileName.lastIndexOf("."))+WebOffice.FileType;
	   //document.getElementById('FileType').value = WebOffice.FileType;
	}
	
	//调用模板
	function WebUseTemplate(fileName){
		fileName=$("#mTemplate").val();
		    var currFilePath;
		    if(WebOffice.WebAcceptAllRevisions()){//清除正文痕迹的目的是为了避免痕迹状态下出现内容异常问题。
		       currFilePath = WebOffice.getFilePath(); //获取2015特殊路径
		       WebOffice.WebSaveLocalFile(currFilePath+WebOffice.iWebOfficeTempName);//将当前文档保存下来
		       if(WebOffice.DownloadToFile(fileName,currFilePath)){//下载服务器指定的文件
		          WebOffice.OpenLocalFile(currFilePath+fileName);//打开该文件
		          if(!WebOffice.VBAInsertFile("Content",currFilePath+WebOffice.iWebOfficeTempName)){//插入文档
		           StatusMsg("插入文档失败"); 
		           return;
		          }
		          StatusMsg("模板套红成功"); 
		          return; 
		       }
		       StatusMsg("下载文档失败"); 
		       return;
		    }
		    StatusMsg("清除正文痕迹失败，套红中止"); 
	}
	
	function HandWriting(){
	 	WebOffice.ShowToolBars(false);//签批时隐藏工具栏
	 	WebOffice.ShowMenuBar(false);//签批时隐藏菜单栏
	 	var penColor=document.getElementById("PenColor").value;
	 	var penWidth=document.getElementById("PenWidth").value;
	 	WebOffice.HandWriting(penColor,penWidth);
	}
	function getEditVersion(){
		var getVersion=WebOffice.getEditVersion(); //获取当前编辑器软件版本
		if (getVersion == "YozoWP.exe")  //如果是永中office,隐藏手写功能等
		{
		    document.getElementById("handWriting1").style.display='none';
		    document.getElementById("handWriting2").style.display='none';
		    document.getElementById("expendFunction").style.display='none';
		    document.getElementById("enableCopy1").style.display='none';
		    document.getElementById("enableCopy2").style.display='none';
		    document.getElementById("OpenBookMarks").style.display='none';
		}
	}
	
	function FullSize(mValue){
		WebOffice.FullSize(mValue);//全屏
		WebOffice.ShowCustomToolbar(true);//全屏时显示手写签批工具栏
	}
	
</script>

<script language="javascript" for="WebOffice2015" event="OnReady()">
   WebOffice.setObj(document.getElementById('WebOffice2015'));//给2015对象赋值
   Load();//避免页面加载完，控件还没有加载情况
</script>

<script language="javascript" for="WebOffice2015" event="OnRightClickedWhenAnnotate()">
   WebOffice.ShowToolBars(true);//停止签批时显示工具栏
   WebOffice.ShowMenuBar(true);//停止签批时显示菜单栏
</script>
<script language="JavaScript" for=WebOffice2015 event="OnFullSizeBefore(bVal)">
    if(bVal == true){
    	WebOffice.ShowCustomToolbar(true);	//全屏显示控件的手写签批工具栏
    }
</script>
<script language="JavaScript" for=WebOffice2015 event="OnFullSizeAfter(bVal)">
    if(bVal == false){
    	WebOffice.ShowCustomToolbar(true);	//隐藏控件的手写签批工具栏
    }
</script>

<script language="javascript" for=WebOffice2015 event="OnRecvStart(nTotleBytes)">
    nSendTotleBytes = nTotleBytes;
    nSendedSumBytes = 0;
</script>
<script language="javascript" for=WebOffice2015 event="OnRecving(nRecvedBytes)">
    nSendedSumBytes += nRecvedBytes;
</script>
<script language="javascript" for=WebOffice2015 event="OnRecvEnd(bSucess)">

</script>
<script language="javascript" for=WebOffice2015 event="OnSendStart(nTotleBytes)">
    nSendTotleBytes = nTotleBytes;
    nSendedSumBytes = 0;
</script>
<script language="javascript" for=WebOffice2015 event="OnSending(nSendedBytes)">
    nSendedSumBytes += nSendedBytes;
</script>
<script language="javascript" for=WebOffice2015 event="OnSendEnd(bSucess)">
    if (bSucess){
        if(WebOffice.sendMode == "LoadImage"){
          var httpclient = WebOffice.WebObject.Http;
          WebOffice.hiddenSaveLocal(httpclient,WebOffice,false,false,WebOffice.ImageName);
          WebOffice.InsertImageByBookMark();
          WebOffice.ImageName = null;
          WebOffice.BookMark = null;
          StatusMsg("插入图片成功");
          return
	     } 
	      StatusMsg("插入图片失败"); 
    }
</script>
<script language="JavaScript" for=WebOffice2015 event="OnCommand(ID, Caption, bCancel)">
   switch(ID){
	    case 1:WebOpenLocal();break;//打开本地文件
	    case 2:WebOffice.WebSaveLocal();break;//另存本地文件
		case 4:WebOffice.PrintPreview();break;//启用
		case 5:WebOffice.PrintPreviewExit();WebOffice.ShowField();break;//启用
		case 17:WebOffice.SaveEnabled(true);StatusMsg("启用保存");break;//启用保存
		case 18:WebOffice.SaveEnabled(false);StatusMsg("关闭保存");break;//关闭保存
		case 19:WebOffice.PrintEnabled(true);StatusMsg("启用打印");break;//启用打印
		case 20:WebOffice.PrintEnabled(false);StatusMsg("关闭打印");break;//关闭打印
		case 301:WebOffice.HandWriting("255","4");StatusMsg("手写签批");break;//手写签批
		case 302:WebOffice.StopHandWriting();StatusMsg("停止手写签批");break;//停止手写签批
		case 303:WebOffice.TextWriting();StatusMsg("文字签名");break;//文字签名
		case 304:WebOffice.ShapeWriting();StatusMsg("图形签批");break;//图形签批
		case 305:WebOffice.RemoveLastWriting();StatusMsg("取消上一次签批");break;//取消上一次签批
		case 306:WebOffice.ShowWritingUser(false,WebOffice.UserName);StatusMsg("显示签批用户");break;//显示签批用户
		case 307:SaveDocument();break;
		case 308:WebOffice.WebSaveLocal();break;//另存本地文件
		case 309:WebOffice.WebOpenPrint();break;//打印文件
		case 310:WebOffice.WebPageSetup();break;//页面设置
		case 311:ShowRevision(true);break;//显示痕迹
		case 312:ShowRevision(false);break;//隐藏痕迹
		case 313:rollback();break;//返回
		case 314:WebUseTemplate();break;
		default:;return;  
  }   
   function rollback(){
	   window.location.href="${ctx}/iweboffice/toDocumentList";
   }
</script>

<script language="javascript" for=WebOffice2015 event="OnQuit()">
//DelFile();
</script>


<!--以下是多浏览器的事件方法 -->
<script>
function OnReady(){
 WebOffice.setObj(document.getElementById('WebOffice2015'));//给2015对象赋值
 //Load();//避免页面加载完，控件还没有加载情况
 window.onload = function(){Load();} //IE和谷歌可以直接调用Load方法，火狐要在页面加载完后去调用
}

//停止签批时显示工具栏和菜单栏
function OnRightClickedWhenAnnotate(){
	WebOffice.ShowToolBars(true);
    WebOffice.ShowMenuBar(true);
}
//全屏显示控件的手写签批工具栏
function OnFullSizeBefore(bVal){
	 if(bVal == true){
    	WebOffice.ShowCustomToolbar(true);	
    }
}
//退出全屏隐藏控件的手写签批工具栏
function OnFullSizeAfter(bVal){
	if(bVal == false){
    	WebOffice.ShowCustomToolbar(true);	
    }
}
//上传下载回调用事件
function OnSendStart(nTotleBytes){
 nSendTotleBytes = nTotleBytes;nSendedSumBytes = 0;
}
function OnSending(nSendedBytes){
        nSendedSumBytes += nSendedBytes;
}
//异步上传
function OnSendEnd() {
    if(WebOffice.sendMode == "LoadImage"){
    	var httpclient = WebOffice.WebObject.Http;
    	WebOffice.hiddenSaveLocal(httpclient,WebOffice,false,false,WebOffice.ImageName);
     	WebOffice.InsertImageByBookMark();
        WebOffice.ImageName = null;
        WebOffice.BookMark = null;
        StatusMsg("插入图片成功");
        return;
	} 
	StatusMsg("插入图片失败"); 
}
function OnRecvStart(nTotleBytes){
    nSendTotleBytes = nTotleBytes;nSendedSumBytes = 0;
}
function OnRecving(nRecvedBytes){
   nSendedSumBytes += nRecvedBytes;
}
//异步下载
function OnRecvEnd() {
}
function OnCommand(ID, Caption, bCancel){
   switch(ID){
	    case 1:WebOpenLocal();break;//打开本地文件
	    case 2:WebOffice.WebSaveLocal();break;//另存本地文件
		case 4:WebOffice.PrintPreview();break;//启用
		case 5:WebOffice.PrintPreviewExit();WebOffice.ShowField();break;//启用
		case 17:WebOffice.SaveEnabled(true);StatusMsg("启用保存");break;//启用保存
		case 18:WebOffice.SaveEnabled(false);StatusMsg("关闭保存");break;//关闭保存
		case 19:WebOffice.PrintEnabled(true);StatusMsg("启用打印");break;//启用打印
		case 20:WebOffice.PrintEnabled(false);StatusMsg("关闭打印");break;//关闭打印
		case 301:WebOffice.HandWriting("255","4");StatusMsg("手写签批");break;//手写签批
		case 302:WebOffice.StopHandWriting();StatusMsg("停止手写签批");break;//停止手写签批
		case 303:WebOffice.TextWriting();StatusMsg("文字签名");break;//文字签名
		case 304:WebOffice.ShapeWriting();StatusMsg("图形签批");break;//图形签批
		case 305:WebOffice.RemoveLastWriting();StatusMsg("取消上一次签批");break;//取消上一次签批
		case 306:WebOffice.ShowWritingUser(false,WebOffice.UserName);StatusMsg("显示签批用户");break;//显示签批用户
		case 307:SaveDocument();break;
		case 308:WebOffice.WebSaveLocal();break;//另存本地文件
		case 309:WebOffice.WebOpenPrint();break;//打印文件
		case 310:WebOffice.WebPageSetup();break;//页面设置
		case 311:ShowRevision(true);break;//显示痕迹
		case 312:ShowRevision(false);break;//隐藏痕迹
		case 313:rollback();break;//返回
		case 314:WebInsertVBA();break;
		default:;return;  
  }   
}
     
</script>
<!--End以下是多浏览器的事件方法 -->
<%@ include file="/views/cap/common/theme.jsp"%>
</head>
<body  style="overflow-y: hidden; overflow-x: hidden;text-align: center;" onUnload="WebOffice.WebClose()">
<div style="border:1px solid #ddd; background:#fff; padding:10px; padding-right:10%;">
<form class="form-horizontal" id="iWebOfficeForm" method="post" action="">
	<div class="form-group">
		<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2"><span class="star" style="color: red;">*</span>签章名称</label>
		<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
			<input class="validate[required] form-control input-sm" type="text" id="name_" name="name_" value="${template.name_}" maxlength="100"/>
		</div>
		<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2"><span class="star" style="color: red;">*</span>签章密码</label>
		<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
			<input class="validate[required] form-control input-sm"  type="password" id="paw_" name="paw_" value="${template.paw_}" maxlength="64"/> 
		</div>
		<input type="hidden" id="recordId_" name="recordId_" value="${mRecordID}" />
		<input type="hidden" id="type_" name="type_" value="${template.type_}"/>
	</div>
	<div class="form-group">
		<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2"><span class="star" style="color: red;">*</span>签章类型</label>
			<div class="col-lg-4 col-md-4 col-sm-4 col-xs-4">
					<select id="difType_" name="difType_" class="validate[required] selectPiker select input-sm" value="" style="color: #333;width: 100%;padding: 0px 10px;">
					</select>
			</div>
		<label class="control-label col-lg-2 col-md-2 col-sm-2 col-xs-2">签章说明</label>
		<div class="col-lg-4  col-md-4 col-sm-4 col-xs-4">
			<input class="form-control input-sm"  type="text" id="remark_" name="remark_" value="${template.remark_}" maxlength="200"/> 
		</div>
	</div>
	   <div style="text-align:center;margin-left:5%;">
		<button type="button" class="btn btn-default btn-sm" onclick="SaveDocument()">
		<span class="fa fa-save" aria-hidden="true"></span>保存</button>
		<button type="button"  class="btn btn-default btn-sm" onclick="CloseDocument()">
		<span class="fa fa-reply" aria-hidden="true"></span>返回</button>
		<button type="button"  class="btn btn-default btn-sm" title="提示 : 制作签章模板时,需要在word中设置书签,书签名设置为:Content。在word中设置书签的具体方法参考http://jingyan.baidu.com/article/4f7d57128c10411a21192766.html">
		<span class=" " aria-hidden="true"></span>提示</button>
	</div>
	<input type="hidden" id="createTime_" name="createTime_" value="${template.createTime_}"/>
</form>
</div>
<table id="maintable" cellspacing='0' cellpadding='0'>
	<tr>
		<td id="showtr" colspan="2" valign="top">
			<table id="functionBox" border="0">
				<tr>
					<td id="activeBox">
					<table id="activeTable">
						<tr>
							<td colspan="8" id="activeTd">&nbsp;
							<script src="${ctx}/static/cap/plugins/iweboffice/iWebOffice2015.js"></script></td>
						</tr>
						<tr>
							<td colspan="6" height="10px" align="left" class="statue">状态：<span
								id="state"></span></td>
							<td colspan="2" align="right" style="">时间：</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
</body>
</html>
 <script language="javascript">
 //self.moveTo(0,100);
 //self.resizeTo(screen.availWidth,screen.availHeight);

 function init(){
   document.getElementById('WebOffice2015').height =document.documentElement.clientHeight- 160 +"px";
   var functionTableLength = getHeight('showTD')-document.getElementById("functionTable").rows.length*32;
   for(var i =0;i<document.getElementById("functionTable").rows.length-3;i++){
       try{
        var readivLength = document.getElementById("readT"+i).rows.length*30;
      
	    if(readivLength+30 < functionTableLength){
	      document.getElementById('readT'+i).style.height =  readivLength+ 8 + "px";
	      document.getElementById('read'+i).style.height =  readivLength+ 8 + "px";
	    }else{
	        document.getElementById('readT'+i).style.height =  functionTableLength-50 + "px";
	        document.getElementById('read'+i).style.height =  functionTableLength -50 + "px";
	    }
	   }catch(e){
         continue;
        }
    }
    $("tr").remove(".disabled");
  }
  //获取id的高度
  function  getHeight(id){
    return document.getElementById(id).offsetHeight; 
  }
  function CloseDocument(){
	  window.parent.closePage(window,true,true,true);
  }
  jQuery(document).ready(function () {
    jQuery("#iWebOfficeForm").validationEngine('attach', {
        relative: true,
        overflownDIV: "#name_",
        promptPosition: "centerRight" //验证弹出框的位置，topRight,topLeft,bottomRight,bottomLeft,centerRight,centerLeft,inline
    });
})
 </script>