package com.yonyou.aco.material.dao;

import java.util.List;

import com.yonyou.aco.material.entity.BizMaterialApplyQuery;
import com.yonyou.aco.material.entity.BizMaterialBean;
import com.yonyou.aco.material.entity.BizMaterialListBean;
import com.yonyou.aco.material.entity.BizMaterialStockBean;
import com.yonyou.aco.material.entity.BizMaterialStockDetailEntity;
import com.yonyou.aco.material.entity.BizMaterialStockDetailListEntity;
import com.yonyou.aco.material.entity.BizMaterialStockDetailQuery;
import com.yonyou.aco.material.entity.BizMaterialStockQuery;
import com.yonyou.aco.material.entity.BizMaterialStorageEntity;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;

/**
 * 
 * <p>概述：物资管理-物品出入库管理接口dao
 * <p>功能：实现对物品出库、入库、库存查询等
 * <p>作者：贺国栋
 * <p>创建时间：2016年8月5日
 * <p>类调用特殊情况：无
 */
public interface IBizMaterialStockDao extends IBaseDao {

	/**
	 * TODO: 获取物品库存信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum,
			int pageSize, BizMaterialStockQuery bizMaterialStockQuery);

	/**
	 * TODO: 获取物品库存信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum,
			int pageSize, String mode);

	/**
	 * TODO: 根据mname模糊查询获取物品库存信息 TODO: 填入方法说明
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param mname
	 * @return
	 */
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum,
			int pageSize, String mode, String mname);

	/**
	 * TODO: 通过物品id集合分页查询对应的库存信息 TODO: 填入方法说明
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param ids
	 * @return
	 */
	public PageResult<BizMaterialStockBean> findChoosedStock(String[] ids);

	/**
	 * TODO: 通过id获取物品物品及其库存信息
	 * 
	 * @param materialid
	 * @return
	 */
	public BizMaterialStockBean findStockByMaterialId(String materialid);

	/**
	 * TODO: 获取出入库明细列表数据
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param sql
	 * @return
	 */
	public PageResult<BizMaterialBean> findStockDetials(int pageNum,
			int pageSize, String sql);

	/**
	 * TODO: 查询库存预警的物品数目
	 * 
	 * @return
	 */
	public long findWarningNumber();

	/**
	 * TODO: TODO: 根据用户id获取物资申请记录
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param userId
	 *            用户id为"" 表示管理员 不为"" 表示普通用户
	 * @param title
	 * @return
	 */
	public PageResult<BizMaterialBean> findMaterialApplyRecords(int pageNum,
			int pageSize, String userId, String title);
	/**
	 * TODO: TODO: 根据用户id获取物资申请记录
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param userId
	 *            用户id为"" 表示管理员 不为"" 表示普通用户
	 * @param BizMaterialApplyQuery
	 * @return
	 */
	public PageResult<BizMaterialListBean> findMaterialApplyRecords(int pageNum,
			int pageSize, String userId, BizMaterialApplyQuery bizMaterialApplyQuery);

	/**
	 * TODO:根据ID获取出库物品信息
	 * 
	 * @param id
	 * @return
	 */
	public PageResult<BizMaterialStockBean> findChoosedMateriaById(String id);

	/**
	 * TODO: 删除物资领用记录
	 * 
	 * @param id
	 *            参数id
	 */
	public void doDelMaterialApply(String ids);

	/**
	 * TODO: 物资管理员批准物资领用申请通过方法 TODO: 填入方法说明
	 * 
	 * @param id
	 *            物资领用申请id
	 * @param status
	 *            物资领用申请装态
	 * @param operator
	 *            经办人id（管理员id）
	 * @param operatorOrg
	 *            经办人部门id（管理员部门id）
	 * @param time
	 *            出库时间
	 * @param list
	 *            出库物品信息
	 */
	public void doUpdateStatus(String id, String status, String operator,
			String operatorOrg, String time,
			List<BizMaterialStockDetailEntity> list);

	/**
	 * TODO: TODO:
	 * 
	 * @param id
	 *            物资领用申请id
	 * @param status
	 *            物资领用申请装态
	 * @param operator
	 *            经办人id（管理员id）
	 * @param operatorOrg
	 *            经办人部门id（管理员部门id）
	 * @param time
	 *            出库时间
	 */
	public void doUpdateStatus(String id, String status, String operator,
			String operatorOrg, String time);

	/**
	 * 
	 * TODO: 根据物资领用申请id 获取所选的出库物品 TODO: 填入方法说明
	 * 
	 * @param id
	 * @return
	 */
	public List<BizMaterialStockDetailEntity> findStockChangeDetailByStorageId(
			String id);

	/**
	 * TODO: 物品入库方法 TODO: 填入方法说明
	 * 
	 * @param bmsEntity
	 *            物品入库单
	 * @param list
	 *            要入库的物品列表
	 */
	public void doInStock(BizMaterialStorageEntity bmsEntity,
			List<BizMaterialStockDetailEntity> list);

	/**
	 * TODO: 物品出库方法 TODO: 填入方法说明
	 * 
	 * @param bmsEntity
	 *            物品出库单
	 * @param list
	 *            要出库的物品列表
	 */
	public void doOutStock(BizMaterialStorageEntity bmsEntity,
			List<BizMaterialStockDetailEntity> list);

	public void doUpdateMaterialApply(BizMaterialStorageEntity bmsEntity,
			List<BizMaterialStockDetailEntity> list);
	/**
	 * TODO: 获取出入库明细列表数据高级查询
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param BizMaterialStockDetailQuery
	 * @return
	 */
	public PageResult<BizMaterialStockDetailListEntity> findStockDetials(int pageNum,
			int pageSize, BizMaterialStockDetailQuery bizMaterialStockDetailQuery);
}
