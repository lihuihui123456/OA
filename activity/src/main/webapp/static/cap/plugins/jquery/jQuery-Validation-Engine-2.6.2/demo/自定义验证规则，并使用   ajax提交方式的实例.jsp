<%@ page contentType="text/html;charset=UTF-8"%>
<%@ include file="/views/cap/common/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
<!-- 自定义验证规则，并使用   ajax提交方式的实例
	jQuery-Validation-Engine 使用事例
	1：引入  jQuery-Validation-Engine 依赖文件 （css， js）
	2：创建form 并添加 action  method 属性
	3：给表单中文本域class属性中添加  validate[验证规则],  验证规则可使用多个中间用  , 隔开。具体验证规则请参考  此网站 ： http://code.ciaoca.com/jquery/validation-engine/
	例如： <input type="text" class="validate[required,custom[自己定义的规则名称],ajax[自己定义的ajax验证规则] form-control" name="title" id="title">
	4：开启验证 ：参照 javaScript 中方法
	
	5:提交表单触发验证
	
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
	
	 //追加自定义验证规则
	 $.extend($.validationEngineLanguage.allRules,{
		 //普通验证方法事例
		 'ruleName': {
			  'regex': /^[\u0391-\uFFE5]+$/, /* 正则表达式，如果正则能匹配内容表示通过 */
			  'alertText': '* 请输入汉字不超过10个字符'
		},
		//ajax请求后台验证方法事例(后台返回格式  [String,boolean])
		'ajaxName': {
			  'url': 'validation/ajax', /* 验证程序地址  后台方法可以直接使用 @RequestParam 注解来接收到fieldId和fieldValue两个参数分别表示要验证的的组件的id和输入值*/
			  'alertTextOk': '验证成功是显示的信息',
			  'alertText': '验证失败时显示的信息',
			  'alertTextLoad': '正在验证时的提示信息'
		}
    });  
	//开启表单验证引擎(修改部分参数默认属性)
	$('#formID').validationEngine({
		promptPosition:'centerRight', //提示框的位置 
		autoHidePrompt:true, //是否自动隐藏提示信息 默认为false
		autoHideDelay:100000, //自动隐藏提示信息的延迟时间 (ms)
		//custom_error_messages:{} 自定义验证提示信息（参考此网站 ： http://code.ciaoca.com/jquery/validation-engine/）
		maxErrorsPerField:false,//单个元素显示错误提示的最大数量，值设为数值。默认 false 表示不限制。
		showOneMessage:false, //是否只显示一个提示信息
		onValidationComplete:submitForm,//表单提交验证完成时的回调函数 function(form, valid){}，参数：form：表单元素 valid：验证结果（ture or false）使用此方法后，表单即使验证通过也不会进行提交，交给定义的回调函数进行操作。
	});
	//未提交按钮注册时间
	$('#mt_btn_new').click(function(){
		$('#formID').submit();//表单提交
	});
});

//验证后的回调函数(在回调函数中使用ajax提交后台)
function submitForm(form, valid){
	if(valid){
		$.ajax({
			url:'validation/save',
			type:'post',
			dataType:'json',
			data:form.serialize(),
			success:function(data){
				alert(data);
			}
		})
	}else{
		alert("请正确填写表单");
		return;
	}
}

</script>
</head>
<body>
	<div class="container-fluid content">
		<div class="main">
			<div class="row">
				<div class="col-lg-12">
					<form id="formID">
						<div class="row">
							<div class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0; margin-bottom: 0;">
								<label>标题：</label> 
								<input type="text" class="validate[required,custom[ruleName]] form-control" name="title" id="title"> 
							</div>
						</div>
						<div class="row">
							<div class="form-group has-feedback col-sm-6"
								style="margin-left: 0; margin-right: 0; margin-bottom: 0;">
								<label>用户：</label> 
								<input type="text" class="validate[required,ajax[ajaxName]] form-control"  name="user" id="user"> 
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
						<button id="mt_btn_new" type="button" class="btn btn-default">
							<span class="" aria-hidden="true"></span>新增
						</button>	 
 					</form>
				</div>
			</div>
		</div>
	</div>
	<div class="clearfix"></div>
</body>
</html>