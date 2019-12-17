//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：张多一$手机：18701386200#
// SVN版本号                    日   期                 作     者              变更记录
// IBorrInforDao-001     2016/12/28   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.borr.dao;

import com.yonyou.aco.arc.borr.entity.IWebDocumentBean;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;
/**
 * <p>概述：借阅管理dao层接口
 * <p>功能：在dao层提供借阅管理接口
 * <p>作者：张多一
 * <p>创建时间：2016-12-28
 * <p>类调用特殊情况：无
 */
public interface IBorrInforDao extends IBaseDao{

	/**
	 * 方法: 根据标题列出附件列表.
	 * @param pagenum
	 * @param pagesize
	 * @param wheresql
	 * @return
	 */
	public PageResult<IWebDocumentBean> listEnclosureAndTitle(int pagenum,int pagesize,String wheresql);
}
