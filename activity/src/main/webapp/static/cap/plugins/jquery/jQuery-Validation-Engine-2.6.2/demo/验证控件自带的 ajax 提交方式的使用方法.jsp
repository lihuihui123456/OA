<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<title>办公系统</title>		

<!--  验证控件自带的 ajax 提交方式的使用方法
	jQuery-Validation-Engine 使用事例
	1：引入  jQuery-Validation-Engine 依赖文件 （css， js）
	2：创建form 
	3：给表单中文本域class属性中添加  validate[验证规则],  验证规则可使用多个中间用  , 隔开。具体验证规则请参考  此网站 ： http://code.ciaoca.com/jquery/validation-engine/
	例如： <input type="text" class="validate[required,custom[ruleName]] form-control" name="title" id="title">
	4：开启验证 ： 在javaScript 中添加以下方法，则开启验证模式，并修改参数为ajax方式提交
	$(function(){
		//开启验证引擎
		$('#formID').validationEngine({
			ajaxFormValidation:true, //开启ajax提交方式(默认为false)
			ajaxFormValidationURL:'validation/save', //设置 Ajax 提交的 URL，默认使用 form 的 action 属性
			ajaxFormValidationMethod: 'post', //设置 Ajax 提交时，发送数据的方式
			onAjaxFormComplete: success //提交成功后的回调函数
		});
	})
	5:提交表单触发验证：在form中添加  submit 点击触发
	<input type="submit"  value="提交">
	
 -->

<%@ include file="/views/cap/common/bootstrap-head.jsp"%>
<link rel="stylesheet" type="text/css" href="${ctx}/static/css/style.css">
<link rel="stylesheet" type="text/css" href="${ctx}/static/css/system/index.css">
<link href="${ctx}/static/js/bootstrap/css/style.min.css" rel="stylesheet">

<!-- 引入 jQuery-Validation-Engine css -->
<link rel="stylesheet" type="text/css" href="${ctx}/static/js/jQuery-Validation-Engine-2.6.2/css/validationEngine.jquery.css">
<!-- end -->

<script type="text/javascript" src="${ctx}/static/js/jquery-1.9.1.js"></script>

<!-- 引入jQuery-Validation-Engine js -->
<script type="text/javascript" src="${ctx}/static/js/jQuery-Validation-Engine-2.6.2/js/jquery.validationEngine.min.js"></script>
<script type="text/javascript" src="${ctx}/static/js/jQuery-Validation-Engine-2.6.2/js/jquery.validationEngine-zh_CN.js"></script>
<!-- end -->
<script type="text/javascript">
$(function(){
	//开启验证引擎
	$('#formID').validationEngine({
		ajaxFormValidation:true, //开启ajax提交方式(默认为false)
		ajaxFormValidationURL:'validation/save', //设置 Ajax 提交的 URL，默认使用 form 的 action 属性
		ajaxFormValidationMethod: 'post', //设置 Ajax 提交时，发送数据的方式
		onAjaxFormComplete: success //提交成功后的回调函数
	});
	//注册提交按钮点击事件
	$('#mt_btn_new').click(function(){
		$('#formID').submit();//提交表单
	});
});

//提交成功后的回调函数  
function success(status, form, json, options){
	alert("status :"  + status);  //status  为表单元素提交前的验证信息， 是boolean类型
	alert("json :"  + json); //json是访问后台后返回的信息
}
</script>
</head>
<body>
	<div class="container-fluid content">
		<div class="main">
			<div class="row">
				<div class="col-lg-12">
					<form id="formID" action="validation/save" method="get">
						<div class="row">
							<div class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0; margin-bottom: 0;">
								<label>标题：</label> 
								<input type="text" class="validate[required] form-control" name="title" id="title"> 
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0; margin-bottom: 0;">
								<label>用户：</label> 
								<input type="text" class="validate[required] form-control"  name="user" id="user"> 
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0; margin-bottom: 0;">
								<label>部门：</label> 
								<input type="text" class="validate[required] form-control"  name="org" id="org">
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0; margin-bottom: 0;">
								<label>性别：</label> 
								<select name="sex" id="sex" class="validate[required] form-control">
									<option value="">请选择</option>
									<option value="0">男</option>
									<option value="1">女</option>
								</select>
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0; margin-bottom: 0;">
								<label>数字：</label> 
								<input type="number" class="validate[required,custom[number]] form-control"  name="number" id="number">
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0; margin-bottom: 0;">
								<label>部门：</label> 
								<textarea rows="4" cols="" class="validate[required] form-control"  name="context" id="context"></textarea>
							</div>
						</div>
						<input type="submit" value="提交" />
  					</form>
				</div>
			</div>
		</div>
	</div>
	<div class="clearfix"></div>
</body>
</html>