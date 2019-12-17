package com.yonyou.aco.indexlibrary.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;


/**
 * 指标库实体
 * 
 * @author 王建坤
 * @since 2017-06-27
 * */

@Entity
@Table(name = "index_library")
public class IndexLibrary  implements Serializable {
	private static final long serialVersionUID = -4995796268913578125L;
	/** 主键 */
	private String id;
	/** 部门主键 */
	private String deptId;
	/** 部门名称 */
	private String deptName;
	/** 项目名称 0:"双优"评选项目1："丹柯杯"项目2：基本经费 */
	private String proName;
	/** 功能分类 0：会议费1：招待费 */
	private String funcType;
	/** 预算总金额 */
	private String budgetAmount;
	/** 部门执行金额 */
	private String deptExtAmount;
	/** 部门剩余指标 */
	private String deptResIndex;
	/** 财务执行金额 */
	private String fincExtAmount;
	/** 实际剩余指标 */
	private String actResIndex;
	/** 创建人主键 */
	private String createUserName;
	
	/**备注*/
	private String remarks;
	
	/**
	 * 创建时间
	 */
	private String createTime;

	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getDeptId() {
		return deptId;
	}

	public void setDeptId(String deptId) {
		this.deptId = deptId;
	}

	public String getDeptName() {
		return deptName;
	}

	public void setDeptName(String deptName) {
		this.deptName = deptName;
	}

	public String getProName() {
		return proName;
	}

	public void setProName(String proName) {
		this.proName = proName;
	}

	public String getFuncType() {
		return funcType;
	}

	public void setFuncType(String funcType) {
		this.funcType = funcType;
	}

	public String getBudgetAmount() {
		return budgetAmount;
	}

	public void setBudgetAmount(String budgetAmount) {
		this.budgetAmount = budgetAmount;
	}

	public String getDeptExtAmount() {
		return deptExtAmount;
	}

	public void setDeptExtAmount(String deptExtAmount) {
		this.deptExtAmount = deptExtAmount;
	}

	public String getDeptResIndex() {
		return deptResIndex;
	}

	public void setDeptResIndex(String deptResIndex) {
		this.deptResIndex = deptResIndex;
	}

	public String getFincExtAmount() {
		return fincExtAmount;
	}

	public void setFincExtAmount(String fincExtAmount) {
		this.fincExtAmount = fincExtAmount;
	}

	public String getActResIndex() {
		return actResIndex;
	}

	public void setActResIndex(String actResIndex) {
		this.actResIndex = actResIndex;
	}

	public String getCreateUserName() {
		return createUserName;
	}

	public void setCreateUserName(String createUserName) {
		this.createUserName = createUserName;
	}

	public String getCreateTime() {
		return createTime;
	}

	public void setCreateTime(String createTime) {
		this.createTime = createTime;
	}

	public String getRemarks() {
		return remarks;
	}

	public void setRemarks(String remarks) {
		this.remarks = remarks;
	}


}
