//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// IArcPubInfoService-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.otherarc.service;


import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoBean;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * <p>
 * 概述：业务模块—其它档案管理功能接口
 * <p>
 * 功能：其它档案管理功能接口
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-21
 * <p>
 * 类调用特殊情况：无
 */
public interface IArcPubInfoService {
	
	/**
	 * 根据档案名字获取档案
	 * @add by zhang duo yi
	 * @param arcName
	 * @return 返回分页查询结果
	 */
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntityList(int pageNum,
			int pageSize, String arcName);
	
	/**
	 * 根据档案名字获取档案
	 * @add by zhang duo yi
	 * @param arcName
	 * @return 默认返回完全匹配到的第一个记录
	 */
	public ArcPubInfoEntity findByArcName(String arcName);
	/**
	 * 添加档案基本信息实体
	 * 
	 * @param arcPubInfoEntity
	 */
	public void addArcPubInfo(ArcPubInfoEntity arcPubInfoEntity);

	/**
	 * 通过id删除档案基本信息实体
	 * 
	 * @param id
	 */
	public void deleteArcPubInfo(String id);

	/**
	 * 通过id查询
	 * 
	 * @param id
	 * @return
	 */
	public ArcPubInfoEntity selectPubInfoEntityById(String id);

	/**
	 * 修改基本信息
	 * 
	 * @param arcPubInfoEntity
	 */
	public void updatePubInfoSumm(ArcPubInfoEntity arcPubInfoEntity);

	/**
	 * 
	 * TODO: 修改档案归档
	 * TODO: 填入方法说明
	 * @param arcId
	 * @return
	 */
	public String doUpdateFileStartByArcId(String arcId,ShiroUser user);

	/**
	 * 
	 * TODO: 追加归档修改归档状态可对附件追加上传
	 * TODO: 填入方法说明
	 * @param arcId
	 * @return
	 */
	public String doAddFileUpdateFileStartByArcId(String arcId);

	/**
	 * 
	 * TODO: 通过 档案ID删除档案基本信息
	 * TODO: 填入方法说明
	 * @param arcId
	 * @return
	 */
	public String doDelArcInfoByArcId(String arcId);

	/**
	 * 
	 * TODO: 通过档案ID设置档案作废
	 * TODO: 填入方法说明
	 * @param arcId
	 * @return
	 */
	public String doInvArcInfoByArcId(String arcId);
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
	 * 查询分页
	 * @add zhangduoyi
	 * @date 2017.01.17
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @param fileUser
	 * @param fileDept
	 * @param arcType
	 * @param startTime
	 * @param endTime
	 * @param modCode
	 * @return
	 */
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntity(int pageNum,
			int pageSize, String arcName, String fileUser, String fileDept,
			String arcType, String startTime, String endTime, String modCode);
	/**
	 * 查询分页排序
	 * @add zhangduoyi
	 * @date 2017.01.17
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @param fileUser
	 * @param fileDept
	 * @param arcType
	 * @param startTime
	 * @param endTime
	 * @param modCode
	 * @return
	 */
	public PageResult<ArcPubInfoBean> pageArcPubInfoEntity(int pageNum,
			int pageSize, String arcName, String fileUser, String fileDept,
			String arcType, String startTime, String endTime, String modCode, String sortName,String sortOrder);
}
