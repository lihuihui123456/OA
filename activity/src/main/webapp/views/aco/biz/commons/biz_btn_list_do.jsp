<%@ page contentType="text/html;charset=UTF-8"%>
<!-- table工具栏 -->
<div class="btn-div btn-group">
	<button id="btn_dobiz" type="button" class="btn btn-default btn-sm">
		<span id="doBizBtnName" class="fa fa-plus" aria-hidden="true">拟稿</span>
	</button>
	<button id="btn_delete" type="button" class="btn btn-default btn-sm">
		<span class="fa fa-remove" aria-hidden="true"></span>删除
	</button>
</div>
<script type="text/javascript">
$(function() {
	//拟稿
	$("#btn_dobiz").click(function() {
		var operateUrl = "${ctx}/bizRunController/getBizOperate?status=1&solId="+"${solId}";
		if(operateUrl!=null) {
			var btnName = $("#doBizBtnName").text();
			date = new Date().getTime();
			var options = {
				"text" : btnName,
				"id" : date,
				"href" : operateUrl,
				"pid" : window,
				"isDelete":true,
				"isReturn":true,
				"isRefresh": true
			};
			window.parent.createTab(options);
		}
	});
});
</script>