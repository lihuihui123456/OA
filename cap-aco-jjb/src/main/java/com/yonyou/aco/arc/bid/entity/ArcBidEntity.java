package com.yonyou.aco.arc.bid.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.springframework.format.annotation.DateTimeFormat;

@Entity
@Table(name = "biz_arc_bid_info")
public class ArcBidEntity implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;
	/** 档案ID */
	private String arcId;
	/** 项目名称 */
	private String bidName;
	/** 项目编号 */
	private String proNbr;
	/** 招标时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date bidTime;
	/** 中标单位 */
	private String bidCo;
	/** 单位联系人 */
	private String unitCntctUser;
	/** 单位联系方式 */
	private String unitCntct;
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

	public String getBidName() {
		return bidName;
	}

	public void setBidName(String bidName) {
		this.bidName = bidName;
	}

	public String getProNbr() {
		return proNbr;
	}

	public void setProNbr(String proNbr) {
		this.proNbr = proNbr;
	}

	public Date getBidTime() {
		return bidTime;
	}

	public void setBidTime(Date bidTime) {
		this.bidTime = bidTime;
	}

	public String getBidCo() {
		return bidCo;
	}

	public void setBidCo(String bidCo) {
		this.bidCo = bidCo;
	}

	public String getUnitCntctUser() {
		return unitCntctUser;
	}

	public void setUnitCntctUser(String unitCntctUser) {
		this.unitCntctUser = unitCntctUser;
	}

	public String getUnitCntct() {
		return unitCntct;
	}

	public void setUnitCntct(String unitCntct) {
		this.unitCntct = unitCntct;
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
