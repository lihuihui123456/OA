<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/aco/common/taglibs.jsp"%>
<!DOCTYPE html>
<head>
<title>PDF在线管理</title>
<%@ include file="/views/aco/common/head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/views/cap/iweb/iwebpdf/css/iWebProduct.css" />
</head>
<body onload="init()" onresize="init()" style="overflow-y:hidden;overflow-x:hidden">
	<table id="maintable" cellspacing='0' cellpadding='0' style="margin-top: 5px">
		<!-- head -->
		<!-- <tr>
			<td colspan="2" valign="top" height="61px">
				<table cellspacing='0' cellpadding='0' cellspacing='0'
					cellpadding='0' id="header">
					<tr>
						<td><span>PDF</span> 在线管理</td>
					</tr>
				</table>
			</td>
		</tr> -->
		<tr>
			<td class="title">
			<!-- <span><a  id="action" href="javascript:void(0)"
					id="saveFile">保存文档</a></span> -->
			<span><a  id="action" href="javascript:void(0)"
					onclick="SaveDocument();">保存文档</a></span>
			</td>
		</tr>
		<!-- end head -->

		<!-- showList -->
		<tr>
			<td id="showtr" colspan="2">
				<table id="functionBox" border="0">
					<tr>
						<!-- 左侧功能菜单开始 -->
						<!-- <td id="showTD" width="204px" height="30px" valign="top">

							<table id="functionTable" cellspacing='4' cellpadding='0'>
								<tr id="disPlayNone">
									<td height="30px" class="tableFather">功能列表 &lt;</td>
								</tr>
								<tr class="test">
									<td valign="middle" class="tableFather">
										<table class="tableAll" cellspacing='0' cellpadding='0'>
											<tr>
												<td class="titleStyle">文档阅读功能 <span>+</span></td>
											</tr>
										</table>
										<div id="read0" class="hideDiv">
											<table id="readT0" width="100%" cellspacing='0'
												cellpadding='0'>
												文档阅读功能子菜单
												<tr>
													<td class="dot-size"><a href="#" id="openLocalFile">打开本地文档</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="openURLFile">打开URL文档</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="saveLocalFile">保存本地文档</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="closeActiveFile">关闭当前文档</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="closeAllFile">关闭所有文档</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="GetCurrentPageNo">获取页码信息</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="GoToPage">跳转到指定页</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="GoToPageFirst"><
															首页 ></a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="GoToPagePrv"><
															前页 ></a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="GoToPageNext"><
															后页 ></a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="GoToPageLast"><
															未页 ></a></td>
												</tr>
												<tr><td class="dot-size"><a href="#" id="RoateView">旋转文档</a></td></tr>
											</table>
											END 文档阅读功能子菜单
										</div>
									</td>
								</tr>
								<tr class="test">
									<td valign="middle" class="tableFather">
										<table class="tableAll" cellspacing='0' cellpadding='0'>
											<tr>
												<td class="titleStyle">界面控制功能 <span>+</span></td>
											</tr>
										</table>
										<div id="read0" class="hideDiv">
											<table id="readT0" width="100%" cellspacing='0'
												cellpadding='0'>
												界面控制子菜单
												<tr>
													<td class="dot-size"><a href="#"
														onclick="NormalMode()">普通模式</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" onclick="AnnotMode()">批注模式</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" onclick="SigMode()">盖章模式</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="HideShowBar">隐藏/显示工具栏</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#"
														id="HideShowNavigation">隐藏/显示导航栏</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id=HideShowNavBar>隐藏/显示标签页</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="HideShowPrint">隐藏/显示打印按钮</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#"
														id="HideShowTabCommandBar">隐藏/显示左侧命令栏</a></td>
												</tr>
											</table>
											END 文档阅读功能子菜单
										</div>
									</td>
								</tr>
								<tr class="test">
									<td valign="middle" class="tableFather">
										<table class="tableAll" cellspacing='0' cellpadding='0'>
											<tr>
												<td class="titleStyle">文档控制功能 <span>+</span></td>
											</tr>
										</table>
										<div id="read1" class="hideDiv">
											<table id="readT1" width="100%" cellspacing='0'
												cellpadding='0'>
												文档制功能子菜单
												<tr>
													<td class="dot-size"><a href="#" id="addAnnotText">添加文字批注</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="addPictureAnnot">添加图片批注</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="Watermark">添加文字水印</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="WatermarkPic">添加图片水印</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="delAnnot"
														onclick="DelAllAnnots()">删除所有批注</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="lockAnnot"
														onclick="LockAnnots()">锁定所有批注</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="lockdAnnot"
														onclick="UnlockAnnots()">解锁所有批注</a></td>
												</tr>
											</table>
											END 文档控制功能子菜单
										</div>
									</td>
								</tr>

								<tr class="test">
									<td valign="middle" class="tableFather">
										<table class="tableAll" cellspacing='0' cellpadding='0'>
											<tr>
												<td class="titleStyle">交互表单功能 <span>+</span></td>
											</tr>
										</table>
										<div id="read2" class="hideDiv">
											<table id="readT2" width="100%" cellspacing='0'
												cellpadding='0'>
												打印控制示例能子菜单
												<tr>
													<td class="dot-size"><a href="#" onclick="GetFileds()">获取域个数</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#"
														onclick="addTextField()">添加文本域</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#"
														onclick="IsHighlightField()">高亮显示表单域</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#"
														onclick="IsAllowInteraction()">是否允许文本域输入</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#"
														onclick="delAllFields()">删除所有域</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#"
														onclick="gotoFields()">转到第一个域</a></td>
												</tr>




											</table>
											END 打印控制示例能子菜单
										</div>
									</td>
								</tr>

								<tr class="test">
									<td valign="middle" class="tableFather">
										<table class="tableAll" cellspacing='0' cellpadding='0'>
											<tr>
												<td class="titleStyle">打印控制功能 <span>+</span></td>
											</tr>
										</table>
										<div id="read2" class="hideDiv">
											<table id="readT2" width="100%" cellspacing='0'
												cellpadding='0'>
												打印控制示例
												<tr>
													<td class="dot-size"><a href="#" id="PrintNormal">普通打印</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="PrintContent">只打印文档内容</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="PrintAnnot">只打印批注内容</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="PrintStamp">只打印图章</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="PrintField">只打印域内容</a></td>
												</tr>
											</table>
											END 附加功能示例能子菜单
										</div>
									</td>
								</tr>
								<tr class="test">
									<td valign="middle" class="tableFather">
										<table class="tableAll" cellspacing='0' cellpadding='0'>
											<tr>
												<td class="titleStyle">文件操作功能 <span>+</span></td>
											</tr>
										</table>
										<div id="read2" class="hideDiv">
											<table id="readT2" width="100%" cellspacing='0'
												cellpadding='0'>
												文件操作功能
												<tr>
													<td class="dot-size"><a href="#" id="addPage">新增/删除空白页</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="SplitFile">分割文档</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="ImportFile">插入文档</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="MergFile">合并文档</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="FileToPic">文档保存成图片</a></td>
												</tr>
											</table>
											END 附加功能示例能子菜单
										</div>
									</td>
								</tr>

								<tr class="test">
									<td valign="middle" class="tableFather">
										<table class="tableAll" cellspacing='0' cellpadding='0'>
											<tr>
												<td class="titleStyle">附加功能示例 <span>+</span></td>
											</tr>
										</table>
										<div id="read2" class="hideDiv">
											<table id="readT2" width="100%" cellspacing='0'
												cellpadding='0'>
												附加功能示例子菜单
												<tr>
													<td class="dot-size"><a href="#" id="getAnnotCount">获取批注个数</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="AddDelAttchments">添加/删除附件</a></td>
												</tr>
												<tr><td class="dot-size"><a href="#" id="delFields">删除所有签名</a></td></tr>
												<tr>
													<td class="dot-size"><a href="#" id=getVersion>查看版本号</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="SwitchLanguage">界面语言切换</a></td>
												</tr>
												<tr>
													<td class="dot-size"><a href="#" id="getContext">获取文档内容</a></td>
												</tr>
											</table>
											END 附加功能示例能子菜单
										</div>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								</tr>
								<tr>
									<td style="border: 0">&nbsp;
										<form id="iWebPDF" method="post" action="DocumentSave.jsp"
											onSubmit="return SaveDocument();">
											<input type="hidden" id="RecordID" name="RecordID" value="1" />
											<input type="hidden" id="Subject" name="Subject"
												value="卢昭炜是打发" /> <input type="hidden" id="Author"
												name="Author" value="sdaf" /> <input type="hidden"
												id="FileDate" name="FileDate" value="dsf " /> <input
												type="hidden" id="FileType" name="FileType" value="PDF" /> <input
												type="hidden" id="HTMLPath" name="HTMLPath" value="" />
										</form>
									</td>
								</tr>
							</table>
						</td> -->
						<!-- 左侧功能菜单结束 -->

						<td id="activeBox">
							<div style="padding-right: 5px">
								<table id="activeTable">
									<tr>
										<td colspan="2" id="activeTd"><script
												src="${ctx}/views/cap/iweb/iwebpdf/js/iWebPDF2015.js"></script>
										</td>
										</td>
									</tr>
	
									<tr>
										<td height="10px" align="left" class="statue">状态：<span
											id="state"></span></td>
										<td align="right" style="time;padding-right: 10px">时间：${mFileDate }</td>
									</tr>
								</table>
							</div>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<!-- end showList -->

		<!-- footer -->
		<tr>
			<td colspan="2" height="30px" class="footer"><table>
					<tr>
						<td align="center"></td>
					</tr>
				</table></td>
		</tr>
		<!-- end footer -->
	</table>
</body>
<script type="text/javascript">
	/**页面参数*/
  	var mServerUrl = "${mServerUrl}";
	var mRecordID = "${mRecordID}";
	var mfileName = "${mfileName}";
	var fileUrl = "${fileUrl}";
	var mIsExsitRId = "${isExsitRId}";
	var style = "${style}";
	var e_pdf = "${e_pdf}";
	
	var basePath = "<%=basePath %>";
</script>
<script type="text/javascript" src="${ctx}/views/cap/iweb/iwebpdf/js/iWebProduct.js"></script>
<script type="text/javascript">
$(function() {
	if (style == "edit") {
		$("#action").show();
	} else {
		$("#action").hide();
	}
})

function init() {
	//	iWebPDF2015.COMAddins("KingGrid.ComControl").Object.Copyright = Copyright="";  //设置授权码
	document.getElementById('activeBox').style.height = document.documentElement.clientHeight - 25 + "px";
	document.getElementById('activeTable').style.height = getHeight('activeBox') - 15 + "px";
	document.getElementById('iWebPDF2015').style.height = getHeight('activeTd') + "px";
	//document.getElementById('showTD').style.height = getHeight('activeBox')+"px"

/* 	var functionTableLength = getHeight('showTD')
			- document.getElementById("functionTable").rows.length * 32
	// alert(functionTableLength);
	for (var i = 0; i < 3; i++) {
		var readivLength = document.getElementById("readT" + i).rows.length * 30;
		if (readivLength < functionTableLength) {
			document.getElementById('readT' + i).style.height = readivLength
					+ 8 + "px";
			document.getElementById('read' + i).style.height = readivLength
					+ 8 + "px";
		} else {
			document.getElementById('read' + i).style.height = functionTableLength
					+ 5 + "px";
		}
	} */

}

//获取id的高度
function getHeight(id) {
	return document.getElementById(id).offsetHeight;
}

//状态信息
function addState(value) {
	$("#state").html(value);
}

//清空批注
function DelAllAnnots() {
	try {
		if (0 == iWebPDF2015.Documents.Count) {
			alert("没有已打开文档");
			return;
		}

		var nPage = iWebPDF2015.Documents.ActiveDocument.Pages.Count;
		for (var i = 0; i < nPage; i++) {
			var nAnnot = iWebPDF2015.Documents.ActiveDocument.Pages(i).Annots.Count;
			for (var j = nAnnot - 1; j >= 0; j--) {
				//				iWebPDF2015.Documents.ActiveDocument.pages(i).Annots(j).Delete();	
				var annot = iWebPDF2015.Documents.ActiveDocument.pages(i).Annots(j);

				if (annot.Subtype != "Widget") //批注对象为构件类型时不能删除，会崩溃  
				{
					annot.Delete();
				}
				//如果是要指定删除的可以==“Text”  Text为文字批注  Line为线 Square为矩形 Circle为圆形批注 Stamp为图章批注
			}
			iWebPDF2015.Documents.ActiveDocument.Pages(i).Refresh();
		}
		iWebPDF2015.Documents.ActiveDocument.Views.ActiveView.Refresh();
	} catch (e) {
		alert(e.description);
	}
}

//锁定批注
function LockAnnots() {
	try {
		if (0 == iWebPDF2015.Documents.Count) {
			alert("没有已打开文档");
			return;
		}
		var nAnnot = iWebPDF2015.Documents.ActiveDocument.Pages.Item(0).Annots.Count;
		for (var i = 0; i < nAnnot; i++) {
			iWebPDF2015.Documents.ActiveDocument.Pages.Item(0).Annots.item(i).Locked = true;

		}

	} catch (e) {
		alert(e.description);
	}
}

//解除锁定批注
function UnlockAnnots() {
	try {
		if (0 == iWebPDF2015.Documents.Count) {
			alert("没有已打开文档");
			return;
		}
		var nAnnot = iWebPDF2015.Documents.ActiveDocument.Pages.Item(0).Annots.Count;
		for (var i = 0; i < nAnnot; i++) {
			iWebPDF2015.Documents.ActiveDocument.Pages.Item(0).Annots.item(i).Locked = false;
		}

	} catch (e) {
		alert(e.description);
	}
}

//普通模式
function NormalMode() {
	try {

		var n = iWebPDF2015.CommandBars.Count;

		for (var i = 0; i < n; i++) {
			var CommandBar = iWebPDF2015.CommandBars.item(i);
			CommandBar.Visible = true;
		}

		addState("普通模式。");
	} catch (e) {
		addState("普通模式进入失败。");
		alert(e.description);
	}
}

//批注模式
function AnnotMode() {
	try {
		var n = iWebPDF2015.CommandBars.Count;
		for (var i = 0; i < n; i++) {
			var CommandBar = iWebPDF2015.CommandBars.item(i);

			var name = CommandBar.Name;
			if (name == "MenuBar" || name == "Rotate" || name == "Zoom" || name == "Find" || name == "DigitalSignature") {
				CommandBar.Visible = false;
			} else {
				CommandBar.Visible = true;
			}
		}
		addState("批注模式设置成功。");
	} catch (e) {
		addState("批注模式设置失败。");
		alert(e.description);
	}
}

//盖章模式
function SigMode() {
	try {
		var n = iWebPDF2015.CommandBars.Count;
		for (var i = 0; i < n; i++) {
			var CommandBar = iWebPDF2015.CommandBars.item(i);

			var name = CommandBar.Name;
			if (name == "MenuBar" || name == "File" || name == "Rotate" || name == "Zoom" || name == "Standard" || name == "Find" || name == "Annots" || name == "Comments") {
				CommandBar.Visible = false;
			} else {
				CommandBar.Visible = true;
			}
		}
		addState("盖章模式设置成功。");
	} catch (e) {
		addState("盖章模式设置失败。");
		alert(e.description);
	}
}

//添加文本域
function addTextField() {
	try {
		if (0 == iWebPDF2015.Documents.Count) {
			alert("没有已打开文档");
			return;
		}
		var nCount = iWebPDF2015.Documents.ActiveDocument.Fields.Count;
		var field = iWebPDF2015.Documents.ActiveDocument.Fields.Add(3);

		var widget = field.AddToPage(0);
		widget.FromUserRect(100, 750, 250, 780);
		widget.UpdateAppearance();

		field.Name = "TextField";
		field.Value = "KingGrid";
		field.Visible = true;

		iWebPDF2015.Documents.ActiveDocument.Views.ActiveView.Refresh();

		addState("添加文本域成功。");
	} catch (e) {
		addState("添加文本域失败。");
		alert(e.description);
	}
}

//跳转到第一个域
function gotoFields() {
	try {
		if (0 == iWebPDF2015.Documents.Count) {
			alert("没有已打开文档");
			return;
		}
		var fields = iWebPDF2015.Documents.ActiveDocument.Fields;
		if (fields.Count != 0) {
			fields(0).Goto();
		} else {
			alert("文档中不存在域");
		}
		addState("跳转至第一个域成功。");
	} catch (e) {
		addState("跳转至第一个域失败。");
		alert(e.description);
	}
}

//获取域个数
function GetFileds() {
	try {
		if (0 == iWebPDF2015.Documents.Count) {
			alert("没有已打开文档");
			retrun;
		}
		var fields = iWebPDF2015.Documents.ActiveDocument.Fields;
		var count = fields.Count;
		alert("域的个数" + count);

		addState("获取域个数成功。");
	} catch (e) {
		addState("获取域个数失败。");
		alert(e.description);
	}

}

//删除所有域
function delAllFields() {
	try {
		if (0 == iWebPDF2015.Documents.Count) {
			alert("没有已打开文档");
			return;
		}
		var fields = iWebPDF2015.Documents.ActiveDocument.Fields;
		var count = fields.Count;

		for (var i = 0; i < count; i++) {
			var sigfield = fields(0);
			sigfield.Delete();
		}
		iWebPDF2015.Documents.ActiveDocument.Views.ActiveView.Refresh();
		addState("删除成功");
	} catch (e) {
		addState("删除失败");
		alert(e.description);
	}
}

//是否允许文本域输入 (域交互)
function IsAllowInteraction() {
	try {
		if (0 == iWebPDF2015.Documents.Count) {
			alert("没有已打开文档");
			return;
		}

		var Res = false;
		var document = iWebPDF2015.Documents.ActiveDocument;
		var fields = document.Fields;
		var cnt = fields.Count;
		if (cnt) {
			nClick++;
			if (nClick % 2) {
				Res = false;
				alert("禁止文本域输入！");
			} else {
				Res = true;
				alert("允许文本域输入！");
			}
			for (var i = 0; i < cnt; i++) {
				fields.Item(i).AllowInteraction = Res;
			}
			addState("域交互控制成功！");
		}
	} catch (e) {
		addState("域交互控制失败");
		alert(e.description);
	}
}

//文档转图片
function FileToPic() {
	try {
		var picPath = "c:\\p1.png";
		var res = iWebPDF2015.Documents.ActiveDocument.Pages.Item(0).ExportPNG(picPath);
		if (!res) {
			alert("首页图片保存为：" + picPath);
		}
		addState("图片转文档成功！");
	} catch (e) {
		addState("图片转文档失败！");
		alert(e.description);
	}
}
</script>
</html>