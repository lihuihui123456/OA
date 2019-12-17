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
 * 功能：物品信息实体类
 * <p>
 * 作者：贺国栋
 * <p>
 * 创建时间：2016-08-02
 * <p>
 * 类调用特殊情况：无
 */
@Entity
@Table(name = "biz_material_info")
public class BizMaterialEntity extends IdEntity implements Serializable {

	private static final long serialVersionUID = 1L;

	/**  物品名称 */
	private String mName_;
	/**  物品编号  */
	private String mNumber_;
	/**  规格型号  */
	private String standard_;
	/** 供货商 */
	private String supplier_;
	/** 计量单位 */
	private String unit_;
	/**  库存下限 */
	private int inventoryFloor_;
	/**  状态 */
	private String status_;
	/** 入库日期 */
	private String indate_;
	/**  备注  */
	private String remark_;
	/**  排序数 */
	private String sort_;
	/** 删除标记 */
	private String isRemove_;

	public String getmName_() {
		return mName_;
	}

	public void setmName_(String mName_) {
		this.mName_ = mName_;
	}

	public String getmNumber_() {
		return mNumber_;
	}

	public void setmNumber_(String mNumber_) {
		this.mNumber_ = mNumber_;
	}

	public String getStandard_() {
		return standard_;
	}

	public void setStandard_(String standard_) {
		this.standard_ = standard_;
	}

	public String getSupplier_() {
		return supplier_;
	}

	public void setSupplier_(String supplier_) {
		this.supplier_ = supplier_;
	}

	public String getUnit_() {
		return unit_;
	}

	public void setUnit_(String unit_) {
		this.unit_ = unit_;
	}

	public int getInventoryFloor_() {
		return inventoryFloor_;
	}

	public void setInventoryFloor_(int inventoryFloor_) {
		this.inventoryFloor_ = inventoryFloor_;
	}

	public String getStatus_() {
		return status_;
	}

	public void setStatus_(String status_) {
		this.status_ = status_;
	}

	public String getIndate_() {
		return indate_;
	}

	public void setIndate_(String indate_) {
		this.indate_ = indate_;
	}

	public String getRemark_() {
		return remark_;
	}

	public void setRemark_(String remark_) {
		this.remark_ = remark_;
	}

	public String getSort_() {
		return sort_;
	}

	public void setSort_(String sort_) {
		this.sort_ = sort_;
	}

	public String getIsRemove_() {
		return isRemove_;
	}

	public void setIsRemove_(String isRemove_) {
		this.isRemove_ = isRemove_;
	}

}
