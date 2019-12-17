<%@ page contentType="text/html;charset=UTF-8"%>       

<script src="${ctx}/views/cap/mail/js/mail-write.js"></script>
<script type="text/javascript">
	var attEachLimitGlobal="${attEachLimit}";
</script>

<div id="write_mail_jsp" class="mail-write" style="display: none;">
    <div class="toolbar">
        <button class="btn btn-default send_mail_btn" ><i class="fa fa-paper-plane"></i> 发送</button>
        <button class="btn btn-default save_draft_btn" ><i class="fa fa-floppy-o"></i> 保存草稿</button>
        <button class="btn btn-default back_to_maillist" ><i class="fa fa-times"></i> 关闭</button>
    </div>
    <form class="form-horizontal mail-form" id="write_mail_form" style="padding-top: 20px;">
      <div class="form-group">
        <label for="inputEmail0" class="col-sm-1 control-label" style="text-align: right;">收件人：</label>
        <div class="col-sm-11">
          <input type="email" class="form-control" id="inputEmail0" onblur="checkToExist();" placeholder="请填写收件人">
        </div>
      </div>
      <div class="col-md-offset-1 col-sm-offset-1 col-xs-offset-1">
      	<a href="javascript:;" class="btn btn-link btn-add" id="addCC">添加抄送人</a>
      	<a href="javascript:;" class="btn btn-link btn-add" id="addBCC">添加密送人</a>
      </div>
      <div class="form-group" id="CC">
        <label for="inputEmail0" class="col-sm-1 control-label" style="text-align: left;">抄送人：</label>
        <div class="col-sm-11">
          <input type="email" class="form-control" id="inputEmail2" onblur="checkBccExist();" placeholder="请填写要抄送的人员">
        </div>
      </div>
      <div class="form-group" id="BCC">
        <label for="inputEmail1" class="col-sm-1 control-label" style="text-align: left;">密送人：</label>
        <div class="col-sm-11">
          <input type="email" class="form-control" id="inputEmail1" onblur="checkCcExist();" placeholder="请填写要密送的人员">
        </div>
      </div>
      <div class="form-group">
        <label for="inputCon1" class="col-sm-1 control-label" style="text-align: left;">主题：</label>
        <div class="col-sm-11">
          <input type="text" class="form-control" id="inputCon1" placeholder="请输入主题">
        </div>
      </div>

      	<div>
			<div class="panel-body add-attachment-con"> 
				<div class="btn-group" role="group" aria-label="...">
					<button type="button" class="btn btn-link btn-add" onclick="add()">
						<i class="fa fa-paperclip"></i> 添加附件<span>(最大<b>2G</b>)</span>
					</button>
  					<button type="button" class="btn btn-link btn-add" onclick="delAll()">
						<i class="fa fa-trash-o"></i> 清空
					</button>  
				</div>
				<div id="mail_att_list" style="overflow: auto; height: 50%">
					<TABLE cellSpacing=0 cellPadding=0 width="100%" border=0 id="write_att_list">
					</TABLE>
				</div>
			</div> 
      	</div>
      	
		<div class="write-con">
			<script id="mail_content" type="text/plain" style="" ></script>
		</div>
    </form>
	<div class="mail-footer">
        <button class="btn btn-default send_mail_btn" ><i class="fa fa-paper-plane"></i> 发送</button>
        <button class="btn btn-default save_draft_btn" ><i class="fa fa-floppy-o"></i> 保存草稿</button>
        <button class="btn btn-default back_to_maillist" ><i class="fa fa-times"></i> 关闭</button>
        <div class="sender">
            <span>发件人：</span>
            ${currUser}
            <a href="javascript:;">&lt;${currUser}${maildomain}&gt;</a>
        </div>
	</div>
