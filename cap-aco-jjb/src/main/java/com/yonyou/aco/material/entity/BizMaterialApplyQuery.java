package com.yonyou.aco.material.entity;

public class BizMaterialApplyQuery {
	/** 出入库业务id */
	private String id_;
	/**  出入库方向 */
	private String direction_;
	/** 物品领用单标题  */
	private String title_;
	/**  领用人  */
	private String user;
	/** 经办人 */
	private String operator;
	/** 时间 */
	private String register_time_;
	private String startRegisterTime;
	private String endRegisterTime;
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
	public String getDirection_() {
		return direction_;
	}
	public void setDirection_(String direction_) {
		this.direction_ = direction_;
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
	public String getOperator() {
		return operator;
	}
	public void setOperator(String operator) {
		this.operator = operator;
	}
	public String getRegister_time_() {
		return register_time_;
	}
	public void setRegister_time_(String register_time_) {
		this.register_time_ = register_time_;
	}
	public String getStatus_() {
		return status_;
	}
	public void setStatus_(String status_) {
		this.status_ = status_;
	}
	public String getStartRegisterTime() {
		return startRegisterTime;
	}
	public void setStartRegisterTime(String startRegisterTime) {
		this.startRegisterTime = startRegisterTime;
	}
	public String getEndRegisterTime() {
		return endRegisterTime;
	}
	public void setEndRegisterTime(String endRegisterTime) {
		this.endRegisterTime = endRegisterTime;
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
	
}
