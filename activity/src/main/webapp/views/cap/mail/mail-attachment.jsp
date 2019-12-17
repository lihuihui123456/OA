<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<%@ include file="/views/cap/common/easyui-head.jsp"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
 <link rel="stylesheet" href="${ctx}/views/cap/mail/css/mail.css">
<style type="text/css">
* {
	font-size: 14px;
}

a {
	color: blue;
	text-decoration: none;
}
</style>
<script type="text/javascript">

	/**
	 * 引入文件
	 */
	function add() {
		var resultStr = window.showModalDialog("${ctx}/media/pluploadMail?chunk=false&url=${ctx}/emailAtt/doUploadAttachment&attEachLimit=${attEachLimit}",
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
		var documentId = check_val();
		$.ajax({
			type : "POST",
			url : "${ctx}/emailAtt/doGetAttachment",
			data : {
			},
			success : function(msg) {
				//alert(msg.length);
				if (!!msg&&msg.length>0) {
					var html = "";
					for(var i=0; i<msg.length; i++){
						html = html + "<tr><td style=\"border: 0px;\"><input type=\"hidden\" name=\"serialNumber\" id=\""
						+ msg[i].uuid + "\" value=\"" + msg[i].uuid + "\"/><input id=\"" + msg[i].uuid
						+ "_i\" name=\"documentId\" type=\"checkbox\" value=\"" + msg[i].uuid + "\" />&nbsp;<a id=\""
						+ msg[i].uuid + "_a\" >"
						+ msg[i].attname + "</a></td></tr>";
					}
					
					
					$("#write_att_list").html(html);
					var doc = window.document.getElementsByName("documentId");
					for (var i = 0; i < doc.length; i++) {
						if (!!documentId && documentId == doc[i].value) {
							doc[i].checked = true;
						}
					}
				}else{
					$("#write_att_list").html("");
				}
			}
		});
	}

	/**
	 * 删除文件
	 */
	function del() {
		var obj = window.document.getElementsByName("documentId");
		var num = 0;
		var documentIds = new Array();
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].checked) {
				documentIds[num] = obj[i].value;
				num++;
			}
		}
		if (num < 1) {
			layerAlert("请选择一个文件！");
			return false;
		}
		$.ajax({
			type : "POST",
			url : "${ctx}/emailAtt/doDelAttachment",
			data : {
				attIds : documentIds.join()
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
	 * 是否选中一条数据
	 */
	function isCheck() {
		var obj = window.document.getElementsByName("documentId");
		var num = 0;
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].checked) {
				num++;
			}
		}
		if (num != 1) {
			layerAlert("请选择一个文件！");
			return false;
		}
		return true;
	}
	/**
	 * 获取选中数据
	 */
	function check_val() {
		var obj = window.document.getElementsByName("documentId");
		var checked_val = "";
		for (var i = 0; i < obj.length; i++) {
			if (obj[i].checked) {
				checked_val = obj[i].value;
			}
		}
		return checked_val;
	}
</script>

<div class="panel-body">
	<div class="btn-group" role="group" aria-label="...">
		<button type="button" class="btn btn-link btn-add" onclick="add()">
			<i class="fa fa-paperclip"></i> 添加附件<span>(最大<b>2G</b>)</span>
		</button>
		<button type="button" class="btn btn-link btn-add" onclick="del()">
			<i class="fa fa-trash-o"></i> 删除
		</button>  
	</div>
	<div id="file_list" style="overflow: auto; height: 50%">
	
		<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0 id="write_att_list">

		</TABLE>
	</div>

</div>
