package com.yonyou.aco.material.entity;
/**
 * 
 * <p>概述：实体类
 * <p>功能：物品及库存信息虚拟实体 
 * <p>作者：贺国栋
 * <p>创建时间：2016-08-03
 * <p>类调用特殊情况：无
 */
public class BizMaterialStockBean {

	/** 物品id */
	private String id_;
	/** 物品名称  */
	private String m_name_;
	/** 物品编号 */
	private String m_number_;
	/** 规格型号 */
	private String standard_;
	/** 供货商 */
	private String supplier_;
	/** 计量单位 */
	private String unit_;
	/** 库存下限 */
	private Integer inventory_floor_;
	/** 状态 */
	private String status_;
	/** 入库日期 */
	private String indate_;
	/** 备注 */
	private String remark_;
	/** 排序数 */
	private String sort_;
	/** 物品数量 */
	private Integer amount_;
	/** 物品库存数量 */
	private Integer stock_;
	
	private String is_remove_;

	public String getId_() {
		return id_;
	}

	public void setId_(String id_) {
		this.id_ = id_;
	}

	public String getM_name_() {
		return m_name_;
	}

	public void setM_name_(String m_name_) {
		this.m_name_ = m_name_;
	}

	public String getM_number_() {
		return m_number_;
	}

	public void setM_number_(String m_number_) {
		this.m_number_ = m_number_;
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

	public Integer getInventory_floor_() {
		return inventory_floor_;
	}

	public void setInventory_floor_(Integer inventory_floor_) {
		this.inventory_floor_ = inventory_floor_;
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

	public Integer getAmount_() {
		return amount_;
	}

	public void setAmount_(Integer amount_) {
		this.amount_ = amount_;
	}

	public Integer getStock_() {
		return stock_;
	}

	public void setStock_(Integer stock_) {
		this.stock_ = stock_;
	}

	public String getIs_remove_() {
		return is_remove_;
	}

	public void setIs_remove_(String is_remove_) {
		this.is_remove_ = is_remove_;
	}
}
