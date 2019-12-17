package com.yonyou.aco.earc.ctlg.dao;

import java.util.List;
import com.yonyou.aco.earc.ctlg.entity.EarcCtlgEntity;
import com.yonyou.aco.earc.ctlg.entity.EarcCtlgTreeBean;
import com.yonyou.cap.common.base.IBaseDao;

/**
 * 
 * TODO: 档案目录管理dao接口类
 * TODO: 填写Class详细说明 
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2017年4月18日
 * @author  贺国栋
 * @since   1.0.0
 */
public interface IEarcCtlgDao extends IBaseDao {

	/**
	 * 
	 * TODO: 通过用户ID获取档案目录分类信息
	 * @param userId
	 * @return
	 */
	public List<EarcCtlgTreeBean> findCtlgInfoByUserId(String userId);

	/**
	 * 
	 * TODO: 通过目录ID判断当前目录是否是父目录
	 * @param id
	 * @return
	 */
	public String isCtlgParent(String Id);

	/**
	 * 
	 * TODO: 通过ID删除档案目录信息
	 * @param id
	 * @return
	 */
	public String doDelCtlgDataById(String id);

	/**
	 * 
	 * TODO: 通过ID获取档案目录信息
	 * @param ctlgId
	 * @return
	 */
	public EarcCtlgEntity findCtlgInfoByCtlgId(String ctlgId);

	/**
	 * 
	 * TODO: 获取最大的orderby字段值
	 * @param acEntity
	 */
	public String getMaxOrderBy(EarcCtlgEntity acEntity);
}
