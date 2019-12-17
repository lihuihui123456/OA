//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：张多一$手机：18701386200#
// SVN版本号                    日   期                 作     者              变更记录
// IDocInforService-001     2016/12/21   张多一                  新建
//*********************************************************************
package com.yonyou.aco.arc.doc.service;

import java.util.List;

import com.yonyou.aco.arc.doc.entity.DocInfor;
import com.yonyou.aco.arc.doc.entity.DocInforShow;
import com.yonyou.aco.arc.doc.entity.DocTableBean;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.cap.common.util.PageResult;

/**
 * <p>概述：档案文书登记表service层接口
 * <p>功能：在service层提供档案文书登记表接口
 * <p>作者：张多一
 * <p>创建时间：2016-07-11
 * <p>类调用特殊情况：无
 */
public interface IDocInforService {
	
	/**获取分页docinforlist
	 * @param pageNum 当前页码(获取第一页内容，设置参数为1)
	 * @param pageSize 每页显示条数
	 * @param wheresql 查询条件
	 * @return 返回pageresult类型数据，不包含已经删除的文件
	 */
	public PageResult<DocInforShow> findAllDocInfor(int pageNum,int pageSize);
	
	/**
	 * @param pageNum ：当前页码
	 * @param pageSize :每页显示条数
	 * @param fileTypeId :类型id
	 * @return
	 */
	public PageResult<DocInforShow> findAllDocInfor(int pageNum,int pageSize, String fileTypeId);

	/**
	 * 根据类型返回分页的docinfor
	 * @param pageNum 当前页码(获取第一页内容，设置参数为1)
	 * @param pageSize 每页显示条数
	 * @param wheresql 查询条件
	 * @return 返回pageresult类型数据，不包含已经删除的文件
	 */
	public PageResult<DocInfor> findDocInforByType(int pageNum,int pageSize,String type);
	
	/**
	 * 根据类型返回分页的docinfor
	 * @param pageNum 当前页码(获取第一页内容，设置参数为1)
	 * @param pageSize 每页显示条数
	 * @param wheresql 查询条件
	 * @return 返回pageresult类型数据，不包含已经删除的文件
	 */
	public PageResult<DocInforShow> findDocInforByWhereSql(int pageNum,int pageSize,String whereSql);
	
	/**docinfor.jilujilu
	 * 添加一条实体记录, 设置ts dr 和arcid
	 * @param docInfor
	 * @param pubInfor
	 */
	public void doSaveDocInfor(DocInfor docInfor, ArcPubInfoEntity pubInfor );


	/**
	 * 根据id删除DocInfor记录
	 * @param string
	 */
	public void doDeleteDocInforById(String string);


	/**
	 * 修改更新docInfor
	 * @param docInfor
	 */
	public void doUpdate(DocInfor docInfor,ArcPubInfoEntity pubInfor);

	/**
	 * 根据docInforid获取实体
	 * @param docInforId
	 * @return
	 */
	public DocInforShow findDocInforById(String docInforId);

	/**
	 * 根据查询条件，获取查询结果
	 * @param pageNum ：当前页码
	 * @param pageSize :每页显示条数
	 * @param searchArcType ：档案类型
	 * @param searcharcName ：档案名称
	 * @param searchdocNBR ：文号，在docinfor表中
	 * @param searchfileStart ：归档状态
	 * @param searchregYear ：文档建立年份（根据登记regtime搜索）
	 * @param regTimeBeginn ：起始区间（根据登记regtime搜索）
	 * @param regTimeEnd ：结束区间（根据登记regtime搜索）
	 * @param type 
	 * @return ：分页的查询结果
	 */
	public PageResult<DocInforShow> findAllDocInforByCondition(int pageNum,
			int pageSize, String searchArcType, String searcharcName,
			String searchdocNBR, String searchfileStart, String searchregYear,
			String regTimeBeginn, String regTimeEnd, String type);

	/**
	 * 根据查询条件，获取查询结果
	 * @param pageNum ：当前页码
	 * @param pageSize :每页显示条数
	 * @param searchArcType ：档案类型
	 * @param searcharcName ：档案名称
	 * @param searchdocNBR ：文号，在docinfor表中
	 * @param searchfileStart ：归档状态
	 * @param searchregYear ：文档建立年份（根据登记regtime搜索）
	 * @param regTimeBeginn ：起始区间（根据登记regtime搜索）
	 * @param regTimeEnd ：结束区间（根据登记regtime搜索）
	 * @return ：列表
	 */
	public List<DocInforShow> findAllDocInforByCondition(String searchArcType,
			String searcharcName, String searchdocNBR, String searchfileStart,
			String searchregYear, String regTimeBeginn, String regTimeEnd);

	/**
	 * 根据arcId获取实体
	 * @param arcId
	 * @return
	 */
	public DocInforShow findDocInforByArcId(String arcId);

	/**
	 * @param userId
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	public PageResult<DocInforShow> findAllDocInfor(String userId, int pageNum,
			int pageSize);

	/**
	 * @param userId
	 * @param pageNum
	 * @param pageSize
	 * @param type
	 * @return
	 */
	public PageResult<DocInforShow> findAllDocInfor(String userId, int pageNum,
			int pageSize, String type);
	public PageResult<DocTableBean> findAllDocTabInfor(String userId, int pageNum,
			int pageSize, String type,String sortName,String sortOrder);

	/**
	 * @param userId
	 * @param pageNum
	 * @param pageSize
	 * @param searchArcType
	 * @param searcharcName
	 * @param searchdocNBR
	 * @param searchfileStart
	 * @param searchregYear
	 * @param regTimeBeginn
	 * @param regTimeEnd
	 * @param type
	 * @return
	 */
	public PageResult<DocInforShow> findAllDocInforByCondition(String userId,
			int pageNum, int pageSize, String searchArcType,
			String searcharcName, String searchdocNBR, String searchfileStart,
			String searchregYear, String regTimeBeginn, String regTimeEnd,
			String type);
	public PageResult<DocTableBean> findAllDocTabInfor(String userId,
			int pageNum, int pageSize, String searchArcType,
			String searcharcName, String searchdocNBR, String searchfileStart,
			String searchregYear, String regTimeBeginn, String regTimeEnd,
			String type,String sortName, String sortOrder);

	/**
	 * @param userId
	 * @param searchArcType
	 * @param searcharcName
	 * @param searchdocNBR
	 * @param searchfileStart
	 * @param searchregYear
	 * @param regTimeBeginn
	 * @param regTimeEnd
	 * @return
	 */
	public List<DocInforShow> findAllDocInforByCondition(String userName,
			String searchArcType, String searcharcName, String searchdocNBR,
			String searchfileStart, String searchregYear, String regTimeBeginn,
			String regTimeEnd);
	public List<DocInforShow> findAllDocInforByCondition(String userName,
			String searchArcType,String selectionIds);
	public List<DocInforShow> findAllDocInforByTitle(String userName,
			String searchArcType,String title);

	/**
	 * @param userId
	 * @param searchArcType
	 * @param globalFileType
	 * @param searcharcName
	 * @param searchdocNBR
	 * @param searchfileStart
	 * @param searchregYear
	 * @param regTimeBeginn
	 * @param regTimeEnd
	 * @return
	 */
	public List<DocInforShow> findAllDocInforByCondition(String userName,
			String searchArcType, String globalFileType, String searcharcName,
			String searchdocNBR, String searchfileStart, String searchregYear,
			String regTimeBeginn, String regTimeEnd);
	public List<DocInforShow> findAllDocInforByCondition(String userName,
			String searchArcType, String globalFileType, String selectionIds);
	public List<DocInforShow> findAllDocInforByTitle(String userName,
			String searchArcType, String globalFileType, String title);
}
