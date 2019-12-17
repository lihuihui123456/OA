<%@ page contentType="text/html;charset=UTF-8"%> 
    <div id="list_mail_jsp">
        <div class="toolbar">
        <!-- 
            <button class="btn btn-default"><i class="fa fa-reply-all"></i>全部回复</button>  -->
            <button class="btn btn-default back_to_maillist" style="display: none;"><i class="fa fa-reply-all"></i>返回</button>
            <button class="btn btn-default reply_mail_btn" ><i class="fa fa-mail-reply"></i>回复</button>
            <button class="btn btn-default forward_mail_btn" ><i class="fa fa-mail-forward"></i>转发</button>
            <button class="btn btn-default del_mail_btn" ><i class="fa fa-remove"></i>删除</button>
            <button class="btn btn-default read_mail_btn" ><i class="fa fa-eye"></i>查看</button>
            <button class="btn btn-default edit_draft_btn" ><i class="fa fa-pencil"></i>编辑草稿</button>
        </div>
	<div id="emaillist_div">
		<table  id="emaillist" data-toggle="table" date-striped="true" data-click-to-select="true" ></table>
	</div>
    <!-- id check in the js -->
    <div id="mail_allInfor_div" style="display: none;">
		<div class="details"  >
			<!-- id check in the js -->
		        <div id="mail-view" class="title">
		        </div>
			<div class="mail_con" id="read_mail_content" style="" readonly="readonly"></div> 
		</div>
		<div class="attachment" id="mail_attachment_details" style="display: none;">
		     <div class="title"><i class="fa fa-paperclip"></i> </div>
		     <div class="attach_con"></div>
		</div>
       
		<div class="toolbar">
		 <!-- 
		    <button class="btn btn-default"><i class="fa fa-reply-all"></i>全部回复</button>  -->
		   <button class="btn btn-default back_to_maillist" style="display: none;"><i class="fa fa-reply-all"></i>返回</button>
		   <button class="btn btn-default reply_mail_btn" ><i class="fa fa-mail-reply"></i>回复</button>
		   <button class="btn btn-default forward_mail_btn" ><i class="fa fa-mail-forward"></i>转发</button>
		   <button class="btn btn-default del_mail_btn" ><i class="fa fa-remove"></i>删除</button>
		   <button class="btn btn-default read_mail_btn" ><i class="fa fa-eye"></i>查看</button>
		   <button class="btn btn-default edit_draft_btn" ><i class="fa fa-pencil"></i>编辑草稿</button>
		</div>
    </div>
</div>
