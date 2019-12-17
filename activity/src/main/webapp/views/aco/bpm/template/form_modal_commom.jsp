<%@ page contentType="text/html;charset=UTF-8"%>

<!-- 送交界面弹出模态框 -->
<div class="modal fade" id="sendDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="sendDivLabel">送交选项</h4>
      </div>
      <div class="modal-body">
      	<iframe id="send_iframe" src=""  width="100%" height="200" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="yes" style=""></iframe>
      </div>
      <div class="modal-footer" style="text-align: center;">
        <button type="button" class="btn btn-primary btn-sm" id="submit" onclick="btnSubmit()">提交</button>
        <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

<!-- 选人界面弹出模态框 -->
<div class="modal fade" id="chooseUserDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="false" data-backdrop="true" data-keyboard="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header" style="height:50px;">
      	<button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
        <h4 class="modal-title" id="myModalLabel">人员选择</h4>
      </div>
      <div class="modal-body" style="text-align:;center;padding:5px;height: 300px">
      	<iframe id="chooseUser_iframe" src=""  width="100%" height="100%" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="yes" style=""></iframe>
      </div>
      <div class="modal-footer" style="height:50px;text-align: center;padding-top: 8px;margin-top: 0px">
        <button type="button" class="btn btn-primary btn-sm" onclick="makesure()">确认</button>
        <button type="button" class="btn btn-primary btn-sm" data-dismiss="modal">关闭</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->



<!-- 图片识别 start -->
<div class="modal fade" id="scanFrameDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="false" data-backdrop="true" data-keyboard="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">图片识别</h4>
      </div>
      <div class="modal-body" style="padding: 10px;text-align: center;">
      	<iframe id="scanFrame" src=""  width="100%" height="400" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="yes" style=""></iframe>
      </div>
      <div class="modal-footer" style="text-align: center;margin-top:-10px;">
      	 <button type="button" class="btn btn-primary btn-sm" onclick="writeToZw()">确定</button>
         <button type="button" class="btn btn-primary btn-sm" onclick="cancelScan()">关闭</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
<!-- 图片识别 end -->

<!-- 办理时传阅选人界面弹出模态框 -->
<div class="modal fade" id="circulationDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="gridSystemModalLabel">人员选择</h4>
      </div> 
      <div class="modal-body" style="text-align: center;">
      	<iframe id="circulation_iframe" src=""  width="100%" height="450" frameborder="no" border="0" marginwidth="0"
			marginheight="0" scrolling="yes" style=""></iframe>
      </div>
      <div class="modal-footer" style="text-align: center;margin-top:0;">
        <button type="button" class="btn btn-primary" onclick="circulation('${bizId}')">确认</button>
        <button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->

	<!-- 收文转发文 -->
	<div class="modal fade" id="swTurnToFwDiv" role="dialog" aria-labelledby="gridSystemModalLabel" aria-hidden="true" data-backdrop="true" data-keyboard="false">
	  <div class="modal-dialog modal-sm" style="width: 400px;" role="document">
	    <div class="modal-content">
	       <div class="modal-header">
	        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
	        <h4 class="modal-title" id="gridSystemModalLabel">选择发文类型</h4>
	      </div>
	      <div class="modal-body">
	     	 <iframe id="swTurnToFw_iframe" src="" frameborder="no" border="0" style="width: 100%;height: 80px"></iframe>
	      </div>
	      <div class="modal-footer" style="text-align: center;">
	        <button type="button" class="btn btn-primary" onclick="turn()">确认</button>
	        <button type="button" class="btn btn-primary" data-dismiss="modal">关闭</button>
	      </div>
	    </div><!-- /.modal-content -->
	  </div><!-- /.modal-dialog -->
	</div><!-- /.modal -->