//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// IArcPubInfoDao-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.otherarc.dao;

import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoBean;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
/**
 * <p>
 * 概述：业务模块其它档案管理 dao接口
 * <p>
 * 功能：实现对其它档案管理业务数据处理接口
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-21
 * <p>
 * 类调用特殊情况：无
 */
public interface IArcPubInfoDao extends IBaseDao {
	/**
	 * 通过arcId查询公共信息实体
	 * 
	 * @param arcId
	 * @return
	 */
	public ArcPubInfoEntity selectArcPubInfoEntityByArcId(String arcId);

	/**
	 * 
	 * TODO: 通过档案Id修改归档状态.
	 * TODO: 填入方法说明
	 * @param paramString
	 */
	public void doUpdateFileStartByArcId(String paramString,ShiroUser user);

	/**
	 * 
	 * TODO: 修改归档状态（追加归档）
	 * TODO: 填入方法说明
	 * @param paramString
	 */
	public void doAddFileUpdateFileStartByArcId(String paramString);

	/**
	 * 
	 * TODO: 通过档案Id删除档案
	 * TODO: 填入方法说明
	 * @param paramString
	 */
	public void doDelArcInfoByArcId(String paramString);

	/**
	 * 
	 * TODO: 通过档案啊Id作废档案
	 * TODO: 填入方法说明
	 * @param paramString
	 */
	public void doInvArcInfoByArcId(String paramString);
	/**
	 * 分页查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 *            查询条件
	 * @return
	 */
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntityList(int pageNum,
			int pageSize,String arcName,String startTime,String endTime);
	/**
	 * 分页查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 *            查询条件
	 * @return
	 */
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntity(int pageNum,
			int pageSize,String arcName,String fileUser,String fileDept,String startTime,String endTime,String modCode);

	/**
	 * @add by zhang duoyi 2017.01.17
	 * 根据arcId还原已经作废的档案
	 * @param arcId
	 */
	public void doHuanyuanByArcId(String arcId);

	/**
	 * 分页查询结果
	 * @add zhangduoyi 2017.01.17
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @param fileUser
	 * @param fileDept
	 * @param startTime
	 * @param endTime
	 * @param arcType
	 * @param modCode
	 * @return
	 */
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntity(int pageNum,
			int pageSize, String arcName, String fileUser, String fileDept,
			String startTime, String endTime, String arcType, String modCode);

	/**
	 * 分页查询结果排序
	 * @add zhangduoyi 2017.01.17
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @param fileUser
	 * @param fileDept
	 * @param startTime
	 * @param endTime
	 * @param arcType
	 * @param modCode
	 * @return
	 */
	public PageResult<ArcPubInfoBean> pageArcPubInfoEntity(int pageNum,
			int pageSize, String arcName, String fileUser, String fileDept,
			String startTime, String endTime, String arcType, String modCode, String sortName,String sortOrder);
	
}
