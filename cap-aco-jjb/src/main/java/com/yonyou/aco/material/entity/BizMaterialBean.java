package com.yonyou.aco.material.entity;

/**
 * 
 * <p>概述：实体类
 * <p>功能：物资管理虚拟实体，用于联合查询
 * <p>作者：贺国栋
 * <p>创建时间：2016-08-03
 * <p>类调用特殊情况：无
 */
public class BizMaterialBean {

	/** 出入库业务id */
	private String billid;
	/** 物品名称  */
	private String mname;
	/** 物品编号 */
	private String mnumber;
	/** 规格型号 */
	private String standard;
	/** 供货商 */
	private String supplier;
	/**  出入库方向 */
	private String direction;
	/** 出入库数量  */
	private Integer amount;
	/**  计量单位  */
	private String unit;
	/** 物品领用单标题  */
	private String title;
	/**  领用人  */
	private String user;
	/**  领用人部门  */
	private String userorg;
	/** 经办人 */
	private String operator;
	/** 经办人部门 */
	private String operatororg;
	/** 时间 */
	private String time;
	/** 状态 */
	private String status;
	
	public String getBillid() {
		return billid;
	}
	public void setBillid(String billid) {
		this.billid = billid;
	}
	
	
	
	public String getMname() {
		return mname;
	}
	public void setMname(String mname) {
		this.mname = mname;
	}
	public String getMnumber() {
		return mnumber;
	}
	public void setMnumber(String mnumber) {
		this.mnumber = mnumber;
	}
	public String getStandard() {
		return standard;
	}
	public void setStandard(String standard) {
		this.standard = standard;
	}
	public String getSupplier() {
		return supplier;
	}
	public void setSupplier(String supplier) {
		this.supplier = supplier;
	}
	public String getDirection() {
		return direction;
	}
	public void setDirection(String direction) {
		this.direction = direction;
	}
	
	public Integer getAmount() {
		return amount;
	}
	public void setAmount(Integer amount) {
		this.amount = amount;
	}
	public String getUnit() {
		return unit;
	}
	public void setUnit(String unit) {
		this.unit = unit;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
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
	public String getTime() {
		return time;
	}
	public void setTime(String time) {
		this.time = time;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}
	
	
	
}
