package com.yonyou.aco.arc.intl.entity;

import java.io.Serializable;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

/**
 * 
 * TODO: 内部项目档案实体类 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月29日
 * @author hegd
 * @since 1.0.0
 */
@Entity
@Table(name = "biz_arc_intl_info")
public class ArcIntlEntity implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;

	/** 档案ID */
	private String arcId;
	/** 文号 */
	private String docNbr;
	/** 项目名称 */
	private String proName;
	/** 协议编号 */
	private String agrNbr;
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

	public String getDocNbr() {
		return docNbr;
	}

	public void setDocNbr(String docNbr) {
		this.docNbr = docNbr;
	}

	public String getProName() {
		return proName;
	}

	public void setProName(String proName) {
		this.proName = proName;
	}

	public String getAgrNbr() {
		return agrNbr;
	}

	public void setAgrNbr(String agrNbr) {
		this.agrNbr = agrNbr;
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
