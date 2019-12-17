package com.yonyou.aco.arc.dclr.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.springframework.format.annotation.DateTimeFormat;

@Entity
@Table(name = "biz_arc_dclr_ifno")
public class ArcDclrEntity implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;

	/** 档案Id */
	private String arcId;
	/** 项目名称 */
	private String proName;
	/** 申报时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date decTime;
	/** 承担部门 */
	private String bearDept;
	/** 申报人 */
	private String decUser;
	/** 金额 */
	private int decMny;
	/** 立项单位 */
	private String proCom;
	/** 单位Id */
	private String dataOrgId;
	/** 部门CODE */
	private String dataDeptCode;
	/** 用户ID */
	private String dataUserId;
	/** 租户ID */
	private String tenantId;
	/** 时间戳 */
	private String ts;
	
	@Id
	@Column(name = "arcId", unique = true, nullable = false, length = 64)
	public String getArcId() {
		return arcId;
	}

	public void setArcId(String arcId) {
		this.arcId = arcId;
	}

	public String getProName() {
		return proName;
	}

	public void setProName(String proName) {
		this.proName = proName;
	}

	public Date getDecTime() {
		return decTime;
	}

	public void setDecTime(Date decTime) {
		this.decTime = decTime;
	}

	public String getBearDept() {
		return bearDept;
	}

	public void setBearDept(String bearDept) {
		this.bearDept = bearDept;
	}

	public String getDecUser() {
		return decUser;
	}

	public void setDecUser(String decUser) {
		this.decUser = decUser;
	}

	public int getDecMny() {
		return decMny;
	}

	public void setDecMny(int decMny) {
		this.decMny = decMny;
	}

	public String getProCom() {
		return proCom;
	}

	public void setProCom(String proCom) {
		this.proCom = proCom;
	}

	public String getDataOrgId() {
		return dataOrgId;
	}

	public void setDataOrgId(String dataOrgId) {
		this.dataOrgId = dataOrgId;
	}

	public String getDataDeptCode() {
		return dataDeptCode;
	}

	public void setDataDeptCode(String dataDeptCode) {
		this.dataDeptCode = dataDeptCode;
	}

	public String getDataUserId() {
		return dataUserId;
	}

	public void setDataUserId(String dataUserId) {
		this.dataUserId = dataUserId;
	}

	public String getTenantId() {
		return tenantId;
	}

	public void setTenantId(String tenantId) {
		this.tenantId = tenantId;
	}

	public String getTs() {
		return ts;
	}

	public void setTs(String ts) {
		this.ts = ts;
	}

}
