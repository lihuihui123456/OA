package com.yonyou.aco.material.service;

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

public interface IBizMaterialStockService extends IBaseDao {

	
	
	/**
	 * TODO: 通过物品id获取物品信息和库存信息
	 * 
	 * @param materialId
	 * @return
	 */
	public BizMaterialStockBean findStockByMaterialId(String materialId);

	/**
	 * TODO: 获取出入库明细列表数据
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param sql
	 * @return
	 */
	public PageResult<BizMaterialBean> findStockDetials(int pageNum,
			int pageSize, String whereSql);
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

	/**
	 * TODO: 查询库存预警的物品数目
	 * 
	 * @return
	 */
	public long getWarningNumber();

	
	/**
	 * TODO: 根据物品id集合分页查询库存信息
	 * TODO: 填入方法说明
	 * @param pageNum
	 * @param pageSize
	 * @param ids
	 * @return
	 */
	public PageResult<BizMaterialStockBean> findChoosedStock(String[] ids);
	/**
	 * TODO: 模糊查询、分页获取可用物品的库存信息
	 * TODO: 填入方法说明
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum, int pageSize,BizMaterialStockQuery bizMaterialStockQuery);
	/**
	 * TODO: 模糊查询、分页获取可用物品的库存信息
	 * TODO: 填入方法说明
	 * @param pageNum
	 * @param pageSize
	 * @param mode 请求方式：   getAll 表示获取所有物资库存， 不为getAll表示获取预警物资库存
	 * @param goodsname 搜素参数  物品名称
	 * @return
	 */
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum, int pageSize,String mode,
			String mname);
	/**
	 * TODO: 模糊查询、分页获取可用物品的库存信息
	 * TODO: 填入方法说明
	 * @param pageNum
	 * @param pageSize
	 * @param mode 请求方式：   getAll 表示获取所有物资库存， 不为getAll表示获取预警物资库存
	 * @return
	 */
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum, int pageSize,String mode);

	/**
	 * TODO: 根据用户id获取不同的申请记录
	 * TODO: 
	 * @param pageNum
	 * @param pageSize
	 * @param userId userId 为 ""是表示当前请求由物资管理员发出  不为空字符串表示普通用户发出
	 * @param title 
	 * @return
	 */
	public PageResult<BizMaterialBean> findMaterialApplyRecords(int pageNum,
			int pageSize, String userId, String title);
	/**
	 * TODO: 根据用户id获取不同的申请记录
	 * TODO: 
	 * @param pageNum
	 * @param pageSize
	 * @param userId userId 为 ""是表示当前请求由物资管理员发出  不为空字符串表示普通用户发出
	 * @param BizMaterialApplyQuery
	 * @return
	 */
	public PageResult<BizMaterialListBean> findMaterialApplyRecords(int pageNum,
			int pageSize, String userId, BizMaterialApplyQuery bizMaterialApplyQuery);
	
	/**
	 * TODO: 获取出库时选择的物品列表信息
	 * TODO: 填入方法说明
	 * @param id 物品领用单id
	 * @return
	 */
	public PageResult<BizMaterialStockBean> findChoosedMateriaById(String id);

	
	
	/**
	 * TODO: 更改物资领用状态
	 * TODO: 填入方法说明
	 * @param id
	 * @param status  1：用户发送申请    2 ：申请通过审批  3：申请未通过审批
	 * @param operator  经办人id
	 * @param operatorOrg  经办人部门id  
	 * @param time 出库时间
	 */
	public void doUpdateStatus(String id, String status, String operator, String operatorOrg, String time);
	
	/**
	 * TODO: 
	 * TODO:  根据物品领用申请记录id获取所选领用物品
	 * @param id
	 * @return
	 */
	public List<BizMaterialStockDetailEntity> findStockDetailByStorageId(String id);

	/**
	 * TODO: 出入库保存出入库详情及物品列表数据
	 * TODO: 填入方法说明
	 * @param bmsEntity
	 * @param marerial
	 * @param action
	 */
	public void doInOrOutStock(BizMaterialStorageEntity bmsEntity, String marerial,
			String action);
	
	/**
	 * TODO: 通过物品领用申请单id删除u一条记录
	 * TODO: 填入方法说明
	 * @param ids
	 */
	public void doDelMaterialApply(String ids);

	public void doUpdateMaterialApply(BizMaterialStorageEntity bmsEntity, String material);
	
}
