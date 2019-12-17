<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
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
	 * 打开文件
	 */
	function openFile() {
		if (isCheck()) {
			var documentId = check_val();
			location.href = "${ctx}/media/download?documentId=" + documentId;
		}
	}
	/**
	 * 引入文件
	 */
	function add() {
		var resultStr = window
				.showModalDialog(
						"${ctx}/media/plupload?chunk=false&url=${ctx}/media/upload?tableId=${tableId}",
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
			url : "${ctx}/media/refresh",
			data : {
				tableId : "${tableId}",
				ctx : "${ctx}"
			},
			success : function(msg) {
				if (!!msg) {
					$("#file_list").html(msg);
					var doc = window.document.getElementsByName("documentId");
					for (var i = 0; i < doc.length; i++) {
						if (!!documentId && documentId == doc[i].value) {
							doc[i].checked = true;
						}
					}
				}
			}
		});
	}

	/**
	 * 另存文件
	 */
	function saveAs() {
		if (isCheck()) {
			var documentId = check_val();
			location.href = "${ctx}/media/download?documentId=" + documentId;
		}
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
			url : "${ctx}/media/delete",
			data : {
				documentIds : documentIds.join()
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
	 * 重命名文件
	 */
	function reName() {
		if (isCheck()) {
			var documentId = check_val();
			var oldName = $("#" + documentId + "_a").html();
			var i = oldName.indexOf(".");
			var name = oldName;
			var suffix = "";
			if (i > 0) {
				suffix = oldName.substring(i, oldName.length);
				name = oldName.substring(0, i);
			}
			name = window
					.showModalDialog(
							"${ctx}/views/cap/sys/plupload/reNameMediaWindow.jsp",
							name,
							"center:yes;status:no;status:no;dialogWidth:320px;dialogHeight:160px;scroll=no");
			if (!!name) {
				name += suffix;
				if (name == oldName) {
					return;
				}
				if (isReName(documentId, name)) {
					layerAlert("附件列表中已经存在此名称，请重新修改！");
				} else {
					$.ajax({
						type : "POST",
						url : "${ctx}/media/reName",
						data : {
							documentId : documentId,
							name : name
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
			}
		}
	}
	/**
	 * 是否已经有重名文件
	 */
	function isReName(documentId, name) {
		var documentIds = document.getElementsByName("documentId");
		for (var i = 0; i < documentIds.length; i++) {
			var val = documentIds[i].value;
			if (val != documentId && $("#" + val + "_a").html() == name) {
				return true;
			}
		}
		return false;
	}
	/**
	 * 上移下移
	 */
	function moveUpDown(upOrDown) {
		var documentId = check_val();
		var serialNumber = $("#" + documentId).val();
		if (isCheck()) {
			if ((upOrDown == 'up' && isTop(serialNumber))
					|| (upOrDown == 'down' && isDown(serialNumber))) {
				return;
			}
			$.ajax({
				type : "POST",
				url : "${ctx}/media/moveUpOrDown",
				data : {
					status : upOrDown,
					tableId : "${tableId}",
					serialNumber : serialNumber
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
	}
	/**
	 * 是否是第一行
	 */
	function isTop(serialNumber) {
		var number = document.getElementsByName("serialNumber");
		if (number.length > 0) {
			var minNumber = number[0].value;
			if (serialNumber == minNumber) {
				layerAlert("文件已经在第一行，不能继续上移！");
				return true;
			}
		}
		return false;
	}
	/**
	 * 是否是最后一行
	 */
	function isDown(serialNumber) {
		var number = document.getElementsByName("serialNumber");
		if (number.length > 0) {
			var maxNumber = number[number.length - 1].value;
			if (maxNumber == serialNumber) {
				layerAlert("文件已经在最后一行，不能继续下移！");
				return true;
			}
		}
		return false;
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
</script>
<div class="panel-body">
	<div class="btn-group" role="group" aria-label="...">
		<button type="button" class="btn btn-default"  onclick="openFile()">
			<i class="fa fa-external-link"></i>&nbsp;打开
		</button>
		<button type="button" class="btn btn-default" disabled ="true" onclick="add()">
			<i class="fa fa-file-text"></i>&nbsp;上传
		</button>
		<button type="button" class="btn btn-default"  onclick="saveAs()">
			<i class="fa fa-floppy-o"></i>&nbsp;另存
		</button>		
		<button type="button" class="btn btn-default" disabled ="true" onclick="del()">
			<i class="fa fa-trash-o"></i>&nbsp;删除
		</button>
		<button type="button" class="btn btn-default" disabled ="true" onclick="reName()">
			<i class="fa fa-pencil"></i>&nbsp;重命名
		</button>
		<button type="button" class="btn btn-default"
			disabled ="true" onclick="moveUpDown('up')">
			<i class="fa fa-sort-up"></i>&nbsp;上移
		</button>
		<button type="button" class="btn btn-default"
			disabled ="true" onclick="moveUpDown('down')">
			<i class="fa fa-sort-desc"></i>&nbsp;下移
		</button>
	</div>
	<div id="file_list">
		<input type="hidden" id="tableId" value="${tableId}" />
		<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0>
			<c:forEach items="${list}" var="list" varStatus="vs">
				<tr>
					<td style="border: 0px;"><input type="hidden"
						name="serialNumber" id="${list.id}"
						value="${list.serialNumber}" /><input id="${list.id}_i"
						name="documentId" type="checkbox" value="${list.id}" />&nbsp;<a
						id="${list.id}_a"
						href="${ctx}/media/download?documentId=${list.id}">${list.fileName}</a></td>
				</tr>
			</c:forEach>
		</TABLE>
	</div>

</div>
