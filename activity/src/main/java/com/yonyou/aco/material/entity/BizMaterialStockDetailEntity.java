package com.yonyou.aco.material.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 
 * <p>
 * 概述：实体类
 * <p>
 * 功能：出入库物品实体类
 * <p>
 * 作者：贺国栋
 * <p>
 * 创建时间：2016-08-03
 * <p>
 * 类调用特殊情况：无
 */

@Entity
@Table(name = "biz_material_stock_detail")
public class BizMaterialStockDetailEntity extends IdEntity implements
		Serializable {

	private static final long serialVersionUID = 1L;
	/**  出入库业务id  */
	private String storageId_;
	/** 商品id  */
	private String materialId_;
	/** 出入库数量 */
	private Integer amount_;

	public String getStorageId_() {
		return storageId_;
	}

	public void setStorageId_(String storageId_) {
		this.storageId_ = storageId_;
	}

	public String getMaterialId_() {
		return materialId_;
	}

	public void setMaterialId_(String materialId_) {
		this.materialId_ = materialId_;
	}

	public Integer getAmount_() {
		return amount_;
	}

	public void setAmount_(Integer amount_) {
		this.amount_ = amount_;
	}

}
