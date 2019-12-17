package com.yonyou.aco.arc.prj.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 * TODO: 工程基建档案基本信息类 Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月29日
 * @author hegd
 * @since 1.0.0
 */
@Entity
@Table(name = "biz_arc_prj_cstr")
public class ArcPrjEntity implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;

	/** 档案ID */
	private String arcId;
	/** 项目名称 */
	private String prjName;
	/** 项目地点 */
	private String prjAdd;
	/** 项目编号 */
	private String prjNbr;
	/** 项目联系人 */
	private String prjUser;
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

	public String getPrjName() {
		return prjName;
	}

	public void setPrjName(String prjName) {
		this.prjName = prjName;
	}

	public String getPrjAdd() {
		return prjAdd;
	}

	public void setPrjAdd(String prjAdd) {
		this.prjAdd = prjAdd;
	}

	public String getPrjNbr() {
		return prjNbr;
	}

	public void setPrjNbr(String prjNbr) {
		this.prjNbr = prjNbr;
	}

	public String getPrjUser() {
		return prjUser;
	}

	public void setPrjUser(String prjUser) {
		this.prjUser = prjUser;
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
