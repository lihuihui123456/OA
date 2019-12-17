<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<base href="<%=basePath%>" />
<meta http-equiv="X-UA-Compatible" content="IE=8" />
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/cap/easyui.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/themes/icon.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/cap/plugins/easyui/demo/demo.css">
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/locale/easyui-lang-zh_CN.js"></script>
<script type="text/javascript" src="${ctx}/static/cap/plugins/easyui/plugins/easyui-treesearch.js"></script>
<script type="text/javascript" src="${ctx}/views/cap/common/validate.js"></script>
<script src="${ctx}/static/cap/plugins/bootstrap/plugins/layer-v2.3/layer/layer.js"></script>

<script>
	$(function() {
		window.ctx = '${ctx}';
		$(".easyui-linkbutton").click(function() {
			//alert(${pageContext.request.session});
		});

		$(document).keyup(function(event) {
			switch (event.keyCode) {
			case 27:
				$(".easyui-dialog").dialog('close');
			case 8:
				return;
			}
		});

		$(".easyui-dialog").dialog({
			onClose : function() {
				$(".validatebox-tip").hide();
				$(".tooltip.tooltip-right").hide();
			}
		});
	});

	document.onkeypress = banBackSpace;
	document.onkeydown = banBackSpace;

	function banBackSpace(e) {
		var ev = e || window.event;
		var obj = ev.target || ev.srcElement;
		var t = obj.type || obj.getAttribute('type');

		var vReadOnly = obj.getAttribute('readonly');
		var vEnabled = obj.getAttribute('enabled');

		vReadOnly = (vReadOnly == null) ? false : vReadOnly;
		vEnabled = (vEnabled == null) ? true : vEnabled;

		var flag1 = (ev.keyCode == 8 && (t == "password" || t == "text" || t == "textarea") && (vReadOnly == true || vEnabled != true)) ? true : false;

		var flag2 = (ev.keyCode == 8 && t != "password" && t != "text" && t != "textarea") ? true : false;

		if (flag2) {
			return false;
		}
		if (flag1) {
			return false;
		}
	}

	function initDict(dictArr, showAll) {
		for ( var code in dictArr) {
			$('#' + code).combobox(
					{
						url : "dictController/findDictByTypeCode?showAll=" + showAll + "&dictTypeCode=" + dictArr[code],
						valueField : 'dictCode',
						textField : 'dictVal'
					});
			refuseBackspace(code);
		}
	}

	function freshTreeNode(treeid, node, url) {
		var treeObj = $('#' + treeid);
		treeObj.tree("options").url = url;
		treeObj.tree("reload", node.target);
	}

	var dataGridExtendView = $.extend({}, $.fn.datagrid.defaults.view, {
		onAfterRender : function(target) {
			$.fn.datagrid.defaults.view.onAfterRender.call(this, target);
			var opts = $(target).datagrid('options');
			var vc = $(target).datagrid('getPanel').children('div.datagrid-view');
			vc.children('div.datagrid-empty').remove();

			$("#emptyDiv").remove();
			if ($(target).datagrid('getRows').length == 0) {
				var d = $('<div id="emptyDiv"��class="datagrid-empty"></div>').html(opts.emptyMsg || 'no��records').appendTo(vc);
				d.css({
					position : 'absolute',
					left : 0,
					top : 50,
					width : '100%',
					textAlign : 'center'
				});
			} else {
				$("#emptyDiv").remove();
			}
		}
	});

	function refuseBackspace(id) {
		var _input = $("#" + id).siblings().eq(0).children().eq(1);
		$(_input).keydown(function(e) {
			if (e.keyCode == 8) {
				return false;
			}
		});
	}

	function closes() {
		$("#Loading").fadeOut("normal", function() {
			$(this).remove();
		});
	}
	var pc;
	$.parser.onComplete = function() {
		if (pc)
			clearTimeout(pc);
		pc = setTimeout(closes, 1000);
	}
</script>

<div id='Loading' style="position:absolute;z-index:1000;top:0px;left:0px;width:100%;height:100%;background:#DDDDDB;text-align:center;padding-top: 20%;overflow: hidden;">
	<h1>
		<image src='${ctx}/static/cap/plugins/easyui/themes/cap/images/loading.gif' />
		<font color="#15428B">加载中...</font>
	</h1>
</div>