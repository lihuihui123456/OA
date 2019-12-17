package com.yonyou.aco.material.entity;

public class BizMaterialStockDetailQuery {
	/** 出入库业务id */
	private String id_;
	/** 物品名称  */
	private String m_name_;
	/** 物品编号 */
	private String m_number_;
	/** 规格型号 */
	private String standard_;
	/** 供货商 */
	private String supplier_;
	/**  出入库方向 */
	private String direction_;
	/** 出入库数量  */
	private String amount_;
	/**  计量单位  */
	private String unit_;
	/** 物品领用单标题  */
	private String title_;
	/**  领用人  */
	private String user;
	/**  领用人部门  */
	private String userorg;
	/** 经办人 */
	private String operator;
	/** 经办人部门 */
	private String operatororg;
	/** 时间 */
	private String end_time_; 
	private String startTime;
	private String endTime;
	/** 状态 */
	private String status_;
	/** 排序变量 */
	private String sortName;
	private String sortOrder;
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
	public String getDirection_() {
		return direction_;
	}
	public void setDirection_(String direction_) {
		this.direction_ = direction_;
	}

	public String getAmount_() {
		return amount_;
	}
	public void setAmount_(String amount_) {
		this.amount_ = amount_;
	}
	public String getUnit_() {
		return unit_;
	}
	public void setUnit_(String unit_) {
		this.unit_ = unit_;
	}
	public String getTitle_() {
		return title_;
	}
	public void setTitle_(String title_) {
		this.title_ = title_;
	}
	public String getUser() {
		return user;
	}
	public void setUser(String user) {
		this.user = user;
	}
	public String getUserorg() {
		return userorg;
	}
	public void setUserorg(String userorg) {
		this.userorg = userorg;
	}
	public String getEnd_time_() {
		return end_time_;
	}
	public void setEnd_time_(String end_time_) {
		this.end_time_ = end_time_;
	}
	public String getStatus_() {
		return status_;
	}
	public void setStatus_(String status_) {
		this.status_ = status_;
	}
	public String getStartTime() {
		return startTime;
	}
	public void setStartTime(String startTime) {
		this.startTime = startTime;
	}
	public String getEndTime() {
		return endTime;
	}
	public void setEndTime(String endTime) {
		this.endTime = endTime;
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
	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}
	public String getOperatororg() {
		return operatororg;
	}
	public void setOperatororg(String operatororg) {
		this.operatororg = operatororg;
	}
	
}
