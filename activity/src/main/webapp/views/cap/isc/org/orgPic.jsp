<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<html>
	<head>
	<title>组织机构结构图</title>
	<link rel="stylesheet" href="${ctx}/static/cap/plugins/jOrgChart/css/bootstrap.min.css" />
	<link rel="stylesheet" href="${ctx}/static/cap/plugins/jOrgChart/css/jquery.jOrgChart.css" />
	<link rel="stylesheet" href="${ctx}/static/cap/plugins/jOrgChart/css/custom.css" />
	<link href="${ctx}/static/cap/plugins/jOrgChart/css/prettify.css" type="text/css" rel="stylesheet" />
	<script type="text/javascript" src="${ctx}/static/cap/plugins/jOrgChart/prettify.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/jOrgChart/jquery.min.js"></script>
	<script type="text/javascript" src="${ctx}/static/cap/plugins/jOrgChart/jquery-ui.min.js"></script>
	<script src="${ctx}/static/cap/plugins/jOrgChart/jquery.jOrgChart.js"></script>
	<script>
		jQuery(document).ready(function() {
			$("#org").jOrgChart({
				chartElement : '#chart',
				dragAndDrop : false
			});
		});

		function openChild() {
			$("#1001").append("<ul><li>测试1</li><li>测试2</li></ul>");
			$("#chart").empty();
			$("#org").jOrgChart({
				chartElement : '#chart',
				dragAndDrop : true
			});
		}
	</script>
</head>
<body onload="prettyPrint();">
	${ result }

	<div id="chart" class="orgChart"></div>

	<script>
		jQuery(document).ready(function() {
			/* Custom jQuery for the example */
			$("#show-list").click(function(e) {
				e.preventDefault();

				$('#list-html').toggle('fast', function() {
					if ($(this).is(':visible')) {
						$('#show-list').text('Hide underlying list.');
						$(".topbar").fadeTo('fast', 0.9);
					} else {
						$('#show-list').text('Show underlying list.');
						$(".topbar").fadeTo('fast', 1);
					}
				});
			});

			$('#list-html').text($('#org').html());

			$("#org").bind("DOMSubtreeModified", function() {
				$('#list-html').text('');

				$('#list-html').text($('#org').html());

				prettyPrint();
			});
		});
	</script>
</body>
</html>