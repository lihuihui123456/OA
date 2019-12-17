package com.yonyou.aco.earc.ctlg.service;

import java.util.List;

import com.yonyou.aco.earc.ctlg.entity.EarcCtlgEntity;
import com.yonyou.aco.earc.ctlg.entity.EarcCtlgTreeBean;
import com.yonyou.cap.common.util.PageResult;

/**
 * 
 * TODO: 档案目录管理service接口类
 * TODO: 填写Class详细说明 
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2017年4月18日
 * @author  贺国栋
 * @since   1.0.0
 */
public interface IEarcCtlgService {


	/**
	 * 
	 * TODO: 通过用户ID获取档案目录分类信息
	 * @param userId
	 * @return
	 */
	public List<EarcCtlgTreeBean> findCtlgInfoByUserId(String userId);

	/**
	 * 
	 * TODO:  添加档案目录信息
	 * @param acEntity
	 */
	public void doAddCtlgInfo(EarcCtlgEntity acEntity);

	/**
	 * 
	 * TODO: 多条件获取档案目信息
	 * @param pageNum
	 * @param pageSize
	 * @param ctlgId
	 * @param ctlgName
	 * @param sortName
	 * @param sortOrder
	 * @return
	 */
	public PageResult<EarcCtlgEntity> findArcCtlgDataByCtlgId(int pageNum,
			int pageSize, String ctlgId, String ctlgName, String sortName,
			String sortOrder);

	/**
	 * 
	 * TODO: 通过目录ID判断当前目录是否是父目录
	 * TODO: 填入方法说明
	 * @param id
	 * @return
	 */
	public String isCtlgParent(String Id);

	/**
	 * 
	 * TODO: 通过ID删除档案目录信息
	 * @param string
	 * @return
	 */
	public String doDelCtlgDataById(String Id);

	/**
	 * 
	 * TODO: 通过ID获取档案目录信息
	 * @param ctlgId
	 * @return
	 */
	public EarcCtlgEntity findCtlgInfoByCtlgId(String ctlgId);
	public EarcCtlgEntity findCtlgInfoByPk(String ctlgId);

	/**
	 * 
	 * TODO: 通过ID修改档案目录信息
	 * @param acEntity
	 */
	public void doUpdateCtlgInfo(EarcCtlgEntity acEntity);


	/**
	 * 
	 * TODO: 获取最大的orderby字段值
	 * @param acEntity
	 */
	public String getMaxOrderBy(EarcCtlgEntity acEntity);
}
