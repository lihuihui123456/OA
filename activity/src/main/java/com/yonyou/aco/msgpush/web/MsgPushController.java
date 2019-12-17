//*********************************************************************
//系统名称：cap-aco
//Branch. All rights reserved.
//版本信息：cap-aco0.0.1
//Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
//#作者：张多一$手机：18701386200#
//SVN版本号                                             日   期                 作     者              变更记录
//MsgPushController-001     2016/12/22   张多一                     新建

//*********************************************************************
package com.yonyou.aco.msgpush.web;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

/**
 * <p> 概 述：管理消息推送controller
 * <p> 功 能：实现推送消息列表的跳转
 * <p> 作 者：张多一
 * <p> 创建时间：2016-12-22
 * <p> 类调用特殊情况：仅是跳转到消息列表页面，数据加载由消息页面的js完成。
 */
@Controller
@RequestMapping("/msgpush")
public class MsgPushController {
	/**
	 * 实现推送消息列表的跳转
	 * @return
	 */
	@RequestMapping("toMsgList")
	public @ResponseBody ModelAndView toMsgPushList() {
		ModelAndView mv = new ModelAndView();
		mv.setViewName("cap/msgpush/msgpushList");
		return mv;
	}
}
