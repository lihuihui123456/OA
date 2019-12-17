package com.yonyou.aco.material.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.Table;

import com.yonyou.cap.common.util.IdEntity;

/**
 * 
 * <p>概述：实体类
 * <p>功能：出入库表单实体类 
 * <p>作者：贺国栋
 * <p>创建时间：2016-08-02
 * <p>类调用特殊情况：无
 */
@Entity
@Table(name = "biz_material_storage")
public class BizMaterialStorageEntity  extends IdEntity implements Serializable{

	private static final long serialVersionUID = 1L;

	/** 标题 */
	private String title_;
	/** 领用人id */
	private String userId_;
	/** 领用人部门id */
	private String userorgId_;
	/** 出入库经办人id */
	private String operatorId_;
	/** 出入库经办人部门id */
	private String operatororgId_;
	/** 填表时间 */
	private String registerTime_;
	/** 出库时间 */
	private String endTime_;
	/** 申请原因 */
	private String reason_;
	/** 出入库方向 */
	private String direction_;
	/** 状态 */
	private String status_;
	/** 备注 */
	private String remark_;
	public String getTitle_() {
		return title_;
	}
	public void setTitle_(String title_) {
		this.title_ = title_;
	}
	public String getUserId_() {
		return userId_;
	}
	public void setUserId_(String userId_) {
		this.userId_ = userId_;
	}
	public String getUserorgId_() {
		return userorgId_;
	}
	public void setUserorgId_(String userorgId_) {
		this.userorgId_ = userorgId_;
	}
	public String getOperatorId_() {
		return operatorId_;
	}
	public void setOperatorId_(String operatorId_) {
		this.operatorId_ = operatorId_;
	}
	public String getOperatororgId_() {
		return operatororgId_;
	}
	public void setOperatororgId_(String operatororgId_) {
		this.operatororgId_ = operatororgId_;
	}
	public String getRegisterTime_() {
		return registerTime_;
	}
	public void setRegisterTime_(String registerTime_) {
		this.registerTime_ = registerTime_;
	}
	public String getEndTime_() {
		return endTime_;
	}
	public void setEndTime_(String endTime_) {
		this.endTime_ = endTime_;
	}
	public String getReason_() {
		return reason_;
	}
	public void setReason_(String reason_) {
		this.reason_ = reason_;
	}
	public String getDirection_() {
		return direction_;
	}
	public void setDirection_(String direction_) {
		this.direction_ = direction_;
	}
	public String getStatus_() {
		return status_;
	}
	public void setStatus_(String status_) {
		this.status_ = status_;
	}
	public String getRemark_() {
		return remark_;
	}
	public void setRemark_(String remark_) {
		this.remark_ = remark_;
	}
}
