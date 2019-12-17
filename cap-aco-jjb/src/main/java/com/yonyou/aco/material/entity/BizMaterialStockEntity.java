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
 * 功能：物品库存实体类
 * <p>
 * 作者：贺国栋
 * <p>
 * 创建时间：2016-08-02
 * <p>
 * 类调用特殊情况：无
 */
@Entity
@Table(name = "biz_material_stock")
public class BizMaterialStockEntity extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;

	/** 商品id */
	private String materialId_;
	/** 商品数量 */
	private String amount_;
	/** 是否删除 */
	private String isRemove_;

	public String getMaterialId_() {
		return materialId_;
	}

	public void setMaterialId_(String materialId_) {
		this.materialId_ = materialId_;
	}

	public String getAmount_() {
		return amount_;
	}

	public void setAmount_(String amount_) {
		this.amount_ = amount_;
	}

	public String getIsRemove_() {
		return isRemove_;
	}

	public void setIsRemove_(String isRemove_) {
		this.isRemove_ = isRemove_;
	}
}
