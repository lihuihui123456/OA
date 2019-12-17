<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
<head>
<title>重命名</title>
<base target="_self">
<style>
body {
	line-height: 22px;
	font-size: 12px;
	margin: 0px;
	background: #eee repeat-x top left
}

.table {
	font-size: 12px;
}

.new {
	width: 95px;
	height: 22px;
	border: none;
}

.del {
	width: 70px;
	height: 22px;
	border: none;
	margin-left: 10px;
}

.con {
	width: 70px;
	height: 22px;
	border: none;
	margin-left: 60px;
}

.con_new {
	width: 70px;
	height: 22px;
	border: none;
}

.config_bg {
	width: 60px;
	height: 20px;
	text-align: center;
	line-height: 15px;
	padding-top: 2px;
	border: none;
	font-size: 12px;
}

.config_bg1 {
	font-size: 12px;
	width: 60px;
	height: 20px;
	text-align: center;
	border: none;
	padding-top: 3px
}

.media_big_div {
	width: 120px;
	float: left;
	text-overflow: ellipsis;
	overflow: visible;
	height: 120px;
	padding: 3px;
	text-align: center;
}

.media_big_div {
	width: 80px;
	float: left;
	text-overflow: ellipsis;
	overflow: visible;
	height: 80px;
	padding: 3px;
	text-align: center;
	margin-right: 15px;
}

#s_ {
	padding: 3px
}

.advancedSelected {
	width: 100px;
	line-height: 28px;
	color: #000important;
	margin-top: 4px;
	font-size: 12px;
	font-weight: bold;
	text-align: center;
}
</style>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
<script type="text/javascript">
	function showStatus() {
		var newname = $("#newName").val();
		if (newname == "") {
			layerAlert("错误的文件名，请输入合法的文件名称！");
			return;
		} else {
			var reg = /^[^/\\:\*\?,",<>\|]+$/ig;
			if (!reg.test(newname)) {
				layerAlert(newname + ":文件名格式不正确");
				return;
			}
			window.returnValue = newname;
			window.close();
		}
	}
</script>
</head>
<body>
	<table width="100%" border="0" align="center" cellpadding="0"
		cellspacing="0" class="table" style="margin-left: 10px">
		<form>
			<tr>
				<td align="left" valign="bottom" nowrap>
					<table cellpadding="0" cellspacing="0" align="center" border="0"
						width="95%" style="margin: 0px 6px 0px 6px;">
						<tr id="mmtype">
							<td width="98%" valign="top" nowrap
								style="padding-left: 10px; height: 140px; padding-top: 20px; text-align: center">
								<div
									style="padding-left: 2px; font-size: 12px; line-height: 30px; margin-top: 3px">
									不要输入后缀名<font color="red">（不允许修改后缀名）</font>：
								</div>
								<input onfocus="this.select()" id="newName" value=""
								style="width: 90%; border: 1px solid #a4a4a4;" type="text"
								name="newName" />
								<div style="text-align: center; padding-top: 15px;">
									<input type="submit" name="" value="确&nbsp;认"
										onclick="showStatus()" />&nbsp;&nbsp; <input type="button"
										name="" value="取&nbsp;消" onClick="window.close()" />
								</div>
							</td>
							<td width="2%" rowspan="2" valign="bottom" style="width: 12px"
								nowrap></td>
						</tr>
						<tr>
							<td style="height: 5px"></td>
						</tr>
					</table>
				</td>
			</tr>
		</form>
	</table>
	<div style="height: 10px"></div>
</body>
<script type="text/javascript">
	$("#newName").val(window.dialogArguments);
</script>
</html>