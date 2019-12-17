package com.yonyou.aco.material.dao;

import java.util.List;

import com.yonyou.aco.material.entity.BizMaterialEntity;
import com.yonyou.aco.material.entity.BizMaterialStockEntity;
import com.yonyou.cap.common.base.IBaseDao;

/**
 * 
 * <p>概述：物品信息管理接口dao
 * <p>功能：对物品信息的
 * <p>作者：贺国栋
 * <p>创建时间：
 * <p>类调用特殊情况：无
 */
public interface IBizMaterialDao extends IBaseDao {

	
	/**
	 * TODO: 获取当前物品最大排序数
	 * @return
	 */
	public String findCount();

	/**
	 * TODO: 根据id集合获取物品集合
	 * @param ids
	 * @return
	 */
	public List<BizMaterialEntity> findMaterialByIds(String[] ids);
	
	/**
	 * TODO: 
	 * TODO: 填入方法说明
	 * @param goods
	 * @param stock
	 */
	public void doSaveMaterialAndStock(BizMaterialEntity bmEntity, BizMaterialStockEntity bmsEntity);

	/**
	 * 删除物品信息和物品对应的库存信息
	 * @Title: delMaterialAndStock  
	 * @Description: TODO(这里用一句话描述这个方法的作用)  
	 * @param ids
	 */
	public void doDelMaterialAndStock(String ids);
}
