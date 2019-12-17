/**
 * 页面按钮、文本框等控件权限过滤工具类
 * 
 * Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
 * 版本信息：nxtbgmsV1.0
 * 作者：徐真
 * 创建时间：2016-05-05
 *   修改时间           修改人         变更说明     SVN版本号
 * 2016-05-05         徐真           新建       10661
 */

/**
 * 页面组件资源过滤，组件包括：按钮、文本框、下拉框
 * 
 * @param {String} menuUrl 菜单页面地址(示例：menu/index)
 * @return 无
 */
function componentFilter(menuUrl) {
	$.ajax({
		url : 'button/btnrolebymenuurl',
		dataType : 'json',
		data : {
			menuurl : menuUrl
		},
		success : function(result) {
			if (result != null && result.length > 0) {
				for (var i = 0; i < result.length; i++) {
					// 获取页面组件对象
					var btn = "#" + result[i].btncode;
					// 后台配置控件类型: 1：按钮   2：文本框
					var btnType = result[i].btntype;
					// 后台配置控件不可操作值：0：不可操作 1：可操作
					var isEnable = result[i].btnenable;
					// 后台配置控件是否显示值： 0：不显示 1：显示
					var isVisable = result[i].btnvisable;

					// 如果不可操作值为0，则设置组件不可用
					if (isEnable == '0') {
						$(btn).attr('disabled', true);
						/*// 如果控件类型为按钮则使用disabled
						if (btnType == '1') {
							$(btn).attr('disabled', true);
						}
						// 如果控件类型为文本框则使用readonly
						if (btnType == '2') {
							$(btn).attr('readonly', true);
						}*/
					}

					// 如果不可显示值为0，则不显示控件
					if (isVisable == '0') {
						$(btn).css("display", "none");
					}
				}
			}
		}, error : function(result) {
			
		}
	});
}