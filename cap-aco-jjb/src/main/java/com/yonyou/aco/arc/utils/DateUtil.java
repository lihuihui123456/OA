//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// DateUtil-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.utils;

import java.util.Calendar;
import java.util.Date;
/**
 * <p>
 * 概述：日期公共类
 * <p>
 * 功能：获取日期转换工具
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-21
 * <p>
 * 类调用特殊情况：无
 */
public class DateUtil {
	/**
	 * 获取日期后几年的日期
	 * @param num
	 * @param operDate
	 * @return
	 */
	public static Date getExpiryDate(int num, Date operDate){
		if(num==0){
			num=1000;
		}
		Calendar calendar = Calendar.getInstance();
		calendar.setTimeInMillis(operDate.getTime());
		int currenYear = calendar.get(Calendar.YEAR);
		calendar.set(Calendar.YEAR, currenYear + num);
		operDate = new Date(calendar.getTimeInMillis());
		return operDate;
	}
}
