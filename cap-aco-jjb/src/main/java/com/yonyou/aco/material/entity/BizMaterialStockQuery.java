package com.yonyou.aco.material.entity;

public class BizMaterialStockQuery {
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
	private String inventory_floor_;
	/** 状态 */
	private String status_;
	/** 入库日期 */
	private String indate_;
	private String startIndate;
	private String endIndate;
	/** 物品数量 */
	private String amount_;
	/** 物品库存数量 */
	private String stock_;
	/** 排序变量 */
	private String sortName;
	private String sortOrder;
	private String pageNum;
	private String pageSize;
	private String mode="getAll";
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

	public String getInventory_floor_() {
		return inventory_floor_;
	}
	public void setInventory_floor_(String inventory_floor_) {
		this.inventory_floor_ = inventory_floor_;
	}
	public String getAmount_() {
		return amount_;
	}
	public void setAmount_(String amount_) {
		this.amount_ = amount_;
	}
	public String getStock_() {
		return stock_;
	}
	public void setStock_(String stock_) {
		this.stock_ = stock_;
	}
	public String getSortName() {
		return sortName;
	}
	public void setSortName(String sortName) {
		this.sortName = sortName;
	}
	public String getSortOrder() {
		return sortOrder;
	}
	public void setSortOrder(String sortOrder) {
		this.sortOrder = sortOrder;
	}
	public String getPageNum() {
		return pageNum;
	}
	public void setPageNum(String pageNum) {
		this.pageNum = pageNum;
	}
	public String getPageSize() {
		return pageSize;
	}
	public void setPageSize(String pageSize) {
		this.pageSize = pageSize;
	}
	public String getMode() {
		return mode;
	}
	public void setMode(String mode) {
		this.mode = mode;
	}
	public String getStartIndate() {
		return startIndate;
	}
	public void setStartIndate(String startIndate) {
		this.startIndate = startIndate;
	}
	public String getEndIndate() {
		return endIndate;
	}
	public void setEndIndate(String endIndate) {
		this.endIndate = endIndate;
	}
	
}
