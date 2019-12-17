//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：张多一$手机：18701386200#
// SVN版本号                    日   期                 作     者              变更记录
// IBorrInforService-001     2016/12/21   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.borr.service;

import java.util.List;
import java.util.Map;

import com.yonyou.aco.arc.borr.entity.BorrInfoTableBean;
import com.yonyou.aco.arc.borr.entity.BorrInfor;
import com.yonyou.aco.arc.borr.entity.BorrInforWebShow;
import com.yonyou.aco.arc.borr.entity.IWebDocumentBean;
import com.yonyou.cap.common.util.PageResult;

/**
 * <p>概述：借阅管理service层接口
 * <p>功能：在service层提供档借阅管理接口
 * <p>作者：张多一
 * <p>创建时间：2016-12-28
 * <p>类调用特殊情况：无
 */
public interface IBorrInforService {
	
	/**
	 * 方法: 根据标题列出附件列表.
	 * @param pagenum
	 * @param pagesize
	 * @param wheresql
	 * @return
	 */
	public PageResult<IWebDocumentBean> listEnclosureAndTitle(int pagenum,int pagesize,String wheresql);
	/**
	 * 分页查询结果
	 * @param pageNum 当前页码(获取第一页内容，设置参数为1)
	 * @param pageSize 每页显示条数
	 * @param wheresql 查询条件
	 * @return 返回pageresult类型数据，不包含已经删除的文件
	 */
	public PageResult<BorrInforWebShow> findBorrInforByWhereSql(int pageNum,int pageSize,String whereSql);
	
	/**
	 * 分页查询结果
	 * @param pageNum 当前页码(获取第一页内容，设置参数为1)
	 * @param pageSize 每页显示条数
	 * @return 返回pageresult类型数据，不包含已经删除的文件
	 */
	public PageResult<BorrInforWebShow> findBorrInfor(int pageNum,int pageSize);
	
	/**
	 * 根据id查询记录
	 * @param id
	 * @return
	 */
	public BorrInforWebShow findBorrInforWebShowById(String id);
	
	/**
	 * @param id
	 * @return
	 */
	public BorrInfor findBorrInforById(String id);
	
	/**
	 * 根据id删除记录
	 * @param id
	 */
	public void delBorrInforById(String id);
	
	/**
	 * 根据id更新记录
	 * @param borrInfor
	 * @throws Exception : the arc id in arcPubEntity in not unique or exist!
	 */
	public void upDateBorrInfor(BorrInfor borrInfor) throws Exception;
	
	/**
	 * 保存记录
	 * @param borrInfor
	 * @throws Exception : the arc id in arcPubEntity in not unique or exist!
	 */
	public void saveBorrInfor(BorrInfor borrInfor) throws Exception;

	/**
	 * 设置档案已经归还
	 * @param temp
	 */
	public void setReturnBorrInfor(BorrInfor temp);

	/**
	 * @param pageNum
	 * @param pageSize
	 * @param dengjiBumen_
	 * @param arcType
	 * @param jieyueBumenId_
	 * @param arcName
	 * @param borrUser
	 * @param planTimeBeginn
	 * @param planTimeEnd
	 * @param actlTimeBeginn
	 * @param actlTimeEnd
	 * @param isSet 
	 * @return
	 * @throws Exception 
	 */
	public PageResult<BorrInforWebShow> findAllDocInforByCondition(int pageNum,
			int pageSize, String dengjiBumen_, String arcType,
			String jieyueBumenId_, String arcName, String borrUser,
			String planTimeBeginn, String planTimeEnd, String actlTimeBeginn,
			String actlTimeEnd, String isSet) throws Exception;

	/**
	 * @param pageNum
	 * @param pageSize
	 * @param dengjiBumen_
	 * @param arcType
	 * @param jieyueBumenId_
	 * @param arcName
	 * @param borrUser
	 * @param planTimeBeginn
	 * @param planTimeEnd
	 * @param actlTimeBeginn
	 * @param actlTimeEnd
	 * @param isSet 
	 * @return
	 * @throws Exception 
	 */
	public List<BorrInforWebShow> findAllDocInforByCondition(
			String dengjiBumen_, String arcType, String jieyueBumenId_,
			String arcName, String borrUser, String planTimeBeginn,
			String planTimeEnd, String actlTimeBeginn, String actlTimeEnd,
			String isSet) throws Exception;
	
	/**
	 * @param userId
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	public PageResult<BorrInforWebShow> findBorrInfor(String userId,
			int pageNum, int pageSize);

	/**
	 * @param userId
	 * @param dengjiBumen_
	 * @param arcType
	 * @param jieyueBumenId_
	 * @param arcName
	 * @param borrUser
	 * @param planTimeBeginn
	 * @param planTimeEnd
	 * @param actlTimeBeginn
	 * @param actlTimeEnd
	 * @param isSet
	 * @return
	 * @throws Exception 
	 */
	public List<BorrInforWebShow> findAllDocInforByCondition(String userId,
			String dengjiBumen_, String arcType, String jieyueBumenId_,
			String arcName, String borrUser, String planTimeBeginn,
			String planTimeEnd, String actlTimeBeginn, String actlTimeEnd,
			String isSet,String[] arr,String hideInputWord) throws Exception;

	/**
	 * @param userId
	 * @param pageNum
	 * @param pageSize
	 * @param dengjiBumen_
	 * @param arcType
	 * @param jieyueBumenId_
	 * @param arcName
	 * @param borrUser
	 * @param planTimeBeginn
	 * @param planTimeEnd
	 * @param actlTimeBeginn
	 * @param actlTimeEnd
	 * @param isSet
	 * @return
	 * @throws Exception 
	 */
	public PageResult<BorrInforWebShow> findAllDocInforByCondition(
			String userId, int pageNum, int pageSize, String dengjiBumen_,
			String arcType, String jieyueBumenId_, String arcName,
			String borrUser, String planTimeBeginn, String planTimeEnd,
			String actlTimeBeginn, String actlTimeEnd, String isSet) throws Exception;
	
	public Map<String, Object> doPrintByBorrId(String id);
	
	//public Map<String, Object> doPrintByBorrInforId(String id);
	
	public PageResult<BorrInfoTableBean> doFindAllBorrInforTableBean(String userId,
			int pageNum, int pageSize,String queryPams,String sortName,String sortOrder,String arcName);
	public List<BorrInfoTableBean> findAllDocInfor(String userId, String[] arr);

}
