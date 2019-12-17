package com.yonyou.aco.arc.type.dao;

import java.util.List;

import com.yonyou.aco.arc.type.entity.ArcTypeBean;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.cap.common.base.IBaseDao;

/**
 * 
 * TODO: 档案管理类型Dao层
 * TODO: 填写Class详细说明 
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2016年12月22日
 * @author  hegd
 * @since   1.0.0
 */
public interface IActTypeDao extends IBaseDao {

	/**
	 * 
	 * TODO: 获取所有档案管理类型
	 * TODO: 填入方法说明
	 * @return
	 */
	public List<ArcTypeEntity> findArcTypeInfo();

	/**
	 * 
	 * TODO: 通过ID获取档案类型.
	 * TODO: 填入方法说明
	 * @param id
	 * @return
	 */
	public List<ArcTypeBean> findArcTypeInfoById(String id);

	/**
	 * 
	 * TODO: 删除档案类型.
	 * TODO: 填入方法说明
	 * @param id
	 */
	public void doDelArcTypeById(String id);
	
	public String validate(String id);
	
	/**
	 * 查询最大orderby
	 * @return
	 */
	public String selectMaxOrderBy();
}
