package com.yonyou.jjb.contractmgr.entity;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "biz_contract")
public class BizContractEntity implements Serializable{

	private static final long serialVersionUID = -1587944429940791131L;
	/** id */
	private String id;
	/** BIZ */
	private String bizId_;
	/** 合同名称 */
	private String title_;
	/** 项目名称 */
	private String projectName_;
	/** 合同文号 */
	private String contractNum_;
	/** 合同/协议类型 */
	private String contractType_;
	/** 合同签订时间 */
	private String contractTime_;
	/** 甲方/发包方/委托方 */
	private String client_;
	/** 乙方/承包方/承担方 */
	private String bearer_;
	/** 丙方 */
	private String third_;
	/** 录入时间 */
	private String entryTime_;
	/** 存续时间 */
	private String survivalTime_;
	/** 金额 */
	private String money_;
	/** 支付方式（账号等） */
	private String payType_;
	/** 办内经办人 */
	private String agent_;
	/** 公司联系人（联系方式） */
	private String contact_;
	/** 备注 */
	private String remark_;
	/** 删除标识 N:未删除 Y：已删除 */
	private String dr;
	/** 人员*/
	private String data_user_id;
	/** 部门*/
	private String data_dept_id;
	/** 单位*/
	private String data_org_id;
	private String createTime_;
	@Id
	@Column(name = "id", unique = true, nullable = false, length = 64)
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getBizId_() {
		return bizId_;
	}
	public void setBizId_(String bizId_) {
		this.bizId_ = bizId_;
	}
	public String getTitle_() {
		return title_;
	}
	public void setTitle_(String title_) {
		this.title_ = title_;
	}
	public String getProjectName_() {
		return projectName_;
	}
	public void setProjectName_(String projectName_) {
		this.projectName_ = projectName_;
	}
	public String getContractNum_() {
		return contractNum_;
	}
	public void setContractNum_(String contractNum_) {
		this.contractNum_ = contractNum_;
	}
	public String getContractType_() {
		return contractType_;
	}
	public void setContractType_(String contractType_) {
		this.contractType_ = contractType_;
	}
	public String getContractTime_() {
		return contractTime_;
	}
	public void setContractTime_(String contractTime_) {
		this.contractTime_ = contractTime_;
	}
	public String getClient_() {
		return client_;
	}
	public void setClient_(String client_) {
		this.client_ = client_;
	}
	public String getBearer_() {
		return bearer_;
	}
	public void setBearer_(String bearer_) {
		this.bearer_ = bearer_;
	}
	public String getThird_() {
		return third_;
	}
	public void setThird_(String third_) {
		this.third_ = third_;
	}
	public String getEntryTime_() {
		return entryTime_;
	}
	public void setEntryTime_(String entryTime_) {
		this.entryTime_ = entryTime_;
	}
	public String getSurvivalTime_() {
		return survivalTime_;
	}
	public void setSurvivalTime_(String survivalTime_) {
		this.survivalTime_ = survivalTime_;
	}
	public String getMoney_() {
		return money_;
	}
	public void setMoney_(String money_) {
		this.money_ = money_;
	}
	public String getPayType_() {
		return payType_;
	}
	public void setPayType_(String payType_) {
		this.payType_ = payType_;
	}
	public String getAgent_() {
		return agent_;
	}
	public void setAgent_(String agent_) {
		this.agent_ = agent_;
	}
	public String getContact_() {
		return contact_;
	}
	public void setContact_(String contact_) {
		this.contact_ = contact_;
	}
	public String getRemark_() {
		return remark_;
	}
	public void setRemark_(String remark_) {
		this.remark_ = remark_;
	}
	public String getDr() {
		return dr;
	}
	public void setDr(String dr) {
		this.dr = dr;
	}
	public String getData_user_id() {
		return data_user_id;
	}
	public void setData_user_id(String data_user_id) {
		this.data_user_id = data_user_id;
	}
	public String getData_dept_id() {
		return data_dept_id;
	}
	public void setData_dept_id(String data_dept_id) {
		this.data_dept_id = data_dept_id;
	}
	public String getData_org_id() {
		return data_org_id;
	}
	public void setData_org_id(String data_org_id) {
		this.data_org_id = data_org_id;
	}
	public String getCreateTime_() {
		return createTime_;
	}
	public void setCreateTime_(String createTime_) {
		this.createTime_ = createTime_;
	}
}
