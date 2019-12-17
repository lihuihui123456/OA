package com.yonyou.aco.material.service.Impl;

import java.util.ArrayList;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.yonyou.aco.material.dao.IBizMaterialStockDao;
import com.yonyou.aco.material.entity.BizMaterialApplyQuery;
import com.yonyou.aco.material.entity.BizMaterialBean;
import com.yonyou.aco.material.entity.BizMaterialListBean;
import com.yonyou.aco.material.entity.BizMaterialStockBean;
import com.yonyou.aco.material.entity.BizMaterialStockDetailEntity;
import com.yonyou.aco.material.entity.BizMaterialStockDetailListEntity;
import com.yonyou.aco.material.entity.BizMaterialStockDetailQuery;
import com.yonyou.aco.material.entity.BizMaterialStockQuery;
import com.yonyou.aco.material.entity.BizMaterialStorageEntity;
import com.yonyou.aco.material.service.IBizMaterialStockService;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
@Service("iBizMaterialStockService")
public class BizMaterialStockServiceImpl extends BaseDao implements
		IBizMaterialStockService {

	@Resource
	IBizMaterialStockDao ibsDao;

	@Override
	public BizMaterialStockBean findStockByMaterialId(String materialId) {
		return ibsDao.findStockByMaterialId(materialId);
	}

	@Override
	public PageResult<BizMaterialBean> findStockDetials(int pageNum,
			int pageSize, String whereSql) {
		return ibsDao.findStockDetials(pageNum, pageSize, whereSql);
	}

	@Override
	public long getWarningNumber() {
		return ibsDao.findWarningNumber();
	}

	@Override
	public PageResult<BizMaterialStockBean> findChoosedStock(String[] ids) {
		return ibsDao.findChoosedStock(ids);
	}
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum,
			int pageSize,BizMaterialStockQuery bizMaterialStockQuery) {
		return ibsDao.findAllStock(pageNum, pageSize,bizMaterialStockQuery);
	}
	
	@Override
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum,
			int pageSize, String mode, String mname) {
		return ibsDao.findAllStock(pageNum, pageSize, mode, mname);
	}

	@Override
	public PageResult<BizMaterialStockBean> findAllStock(int pageNum,
			int pageSize, String mode) {
		return ibsDao.findAllStock(pageNum, pageSize, mode);
	}

	@Override
	public PageResult<BizMaterialBean> findMaterialApplyRecords(int pageNum,
			int pageSize, String userId, String title) {
		return ibsDao.findMaterialApplyRecords(pageNum, pageSize, userId, title);
	}
	public PageResult<BizMaterialListBean> findMaterialApplyRecords(int pageNum,
			int pageSize, String userId, BizMaterialApplyQuery bizMaterialApplyQuery){
		return ibsDao.findMaterialApplyRecords(pageNum, pageSize, userId, bizMaterialApplyQuery);
	}
	@Override
	public PageResult<BizMaterialStockBean> findChoosedMateriaById(String id) {
		return ibsDao.findChoosedMateriaById(id);
	}

	@Override
	public void doUpdateStatus(String id, String status, String operator,
			String operatorOrg, String time) {
		if ("2".equals(status)) { // 2表示通过审批 需要对申请的物品做出库操作
			// 获取物品领用所选择的物品详情
			List<BizMaterialStockDetailEntity> list = findStockDetailByStorageId(id);
			ibsDao.doUpdateStatus(id, status, operator, operatorOrg, time, list);
		} else {
			ibsDao.doUpdateStatus(id, status, operator, operatorOrg, time);
		}

	}

	@Override
	public List<BizMaterialStockDetailEntity> findStockDetailByStorageId(
			String id) {
		String wheresql = " storage_id_ = '" + id + "' ";
		return ibsDao.getListBySql(BizMaterialStockDetailEntity.class,
				wheresql, null, null);
	}

	@Override
	public void doInOrOutStock(BizMaterialStorageEntity bmsEntity,
			String marerial, String action) {
		String[] materialIdAndAmount;
		List<BizMaterialStockDetailEntity> list = new ArrayList<BizMaterialStockDetailEntity>();
		if (!"".equals(marerial) && marerial != null) {
			materialIdAndAmount = marerial.split(",");
			for (int i = 0; i < materialIdAndAmount.length; i++) {
				String str = materialIdAndAmount[i];
				String[] str1 = str.split("==");
				BizMaterialStockDetailEntity temp = new BizMaterialStockDetailEntity();
				String materialId = str1[0];// 物品ID
				int amount = Integer.parseInt(str1[1]);// 入库数量
				temp.setMaterialId_(materialId);
				temp.setAmount_(amount);
				list.add(temp);
			}
			if ("入库".equals(action)) {
				ibsDao.doInStock(bmsEntity, list);
			} else {
				ibsDao.doOutStock(bmsEntity, list);
			}
		}

	}

	@Override
	public void doDelMaterialApply(String ids) {
		ibsDao.doDelMaterialApply(ids);

	}

	@Override
	public void doUpdateMaterialApply(BizMaterialStorageEntity bmsEntity,
			String material) {
		String[] materialIdAndAmount;
		List<BizMaterialStockDetailEntity> list = new ArrayList<BizMaterialStockDetailEntity>();
		if (!"".equals(material) && material != null) {
			materialIdAndAmount = material.split(",");
			for (int i = 0; i < materialIdAndAmount.length; i++) {
				String str = materialIdAndAmount[i];
				String[] str1 = str.split("==");
				BizMaterialStockDetailEntity temp = new BizMaterialStockDetailEntity();
				String materialId = str1[0];// 物品ID
				int amount = Integer.parseInt(str1[1]);// 入库数量
				temp.setMaterialId_(materialId);
				temp.setStorageId_(materialId);
				temp.setAmount_(amount);
				list.add(temp);
			}
		}
		ibsDao.doUpdateMaterialApply(bmsEntity, list);

	}

	@Override
	public PageResult<BizMaterialStockDetailListEntity> findStockDetials(
			int pageNum, int pageSize,
			BizMaterialStockDetailQuery bizMaterialStockDetailQuery) {
		return ibsDao.findStockDetials(pageNum, pageSize, bizMaterialStockDetailQuery);
	}

}
