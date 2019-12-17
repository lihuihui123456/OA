package com.yonyou.aco.material.service;

import java.util.List;

import com.yonyou.aco.material.entity.BizMaterialBeanNew;
import com.yonyou.aco.material.entity.BizMaterialBeanNewQuery;
import com.yonyou.aco.material.entity.BizMaterialEntity;
import com.yonyou.aco.material.entity.BizMaterialStockEntity;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;

public interface IBizMaterialService extends IBaseDao {

	
	/**
	 * 分页获取物品信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	public PageResult<BizMaterialBeanNew> findAllMaterialData(int pageNum, int pageSize);

	public PageResult<BizMaterialBeanNew> findAllMaterialData(int pageNum, int pageSize,
			String mname,String sortName,String sortOrder);
	public PageResult<BizMaterialBeanNew> findAllMaterialData(int pageNum, int pageSize,BizMaterialBeanNewQuery bizMaterialBeanNewQuery);
	/**
	 * 新增物品
	 * 
	 * @param goods
	 */
	public void addMaterial(BizMaterialEntity bmEntity);

	/**
	 * 获取当前物品最大排序数
	 * 
	 * @return
	 */
	public String findCount();

	/**
	 * 修改物品信息
	 * 
	 * @param goods
	 */
	public void updateMaterial(BizMaterialEntity bmEntity);

	/**
	 * 通过id获取一条物品信息
	 * 
	 * @param id
	 * @return
	 */
	public BizMaterialBeanNew findMaterialById(String id);

	/**
	 * 获取状态为启用的物品
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param wheresql
	 * @return
	 */
	public PageResult<BizMaterialEntity> getAllUsingMaterial(int pageNum, int pageSize,
			String wheresql);

	/**
	 * 根据id集合获取物品集合
	 * 
	 * @param str
	 * @return
	 */
	public List<BizMaterialEntity> getMaterialByIds(String[] ids);
	
	/**
	 * TODO: 新增物品信息保存方法同时创建对应库存信息
	 * TODO: 填入方法说明
	 * @param goods
	 * @param stock
	 */
	public void saveMaterialAndStock(BizMaterialEntity bmEntity, BizMaterialStockEntity bmsEntity);
	
	/**
	 * TODO: 删除物品及其库存
	 * TODO: 填入方法说明
	 * @param ids
	 */
	public void delMaterialAndStock(String ids);
	
	public String findCountById(String id);
}
