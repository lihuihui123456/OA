package com.yonyou.aco.arc.inv.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

import org.springframework.format.annotation.DateTimeFormat;

/**
 * 
 * TODO: 项目投资基本信息实体类 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月29日
 * @author hegd
 * @since 1.0.0
 */
@Entity
@Table(name = "biz_arc_inv_info")
public class ArcInvEntity implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;

	/** 档案Id */
	private String arcId;
	/** 投资项目名称 */
	private String proName;
	/** 投资金额 */
	private String mny;
	/** 投资占比 */
	private String invPro;
	/** 投资形式 */
	private String invType;
	/** 投资时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date invTime;
	/** 资金来源 */
	private String bankSrc;
	/** 投资收益情况 */
	private String invIncm;
	/** 投资收益处置 */
	private String invDeal;
	/** 项目来源 */
	private String proSource;
	/** 项目金额 */
	private String proMny;
	/** 项目开始时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date startTime;
	/** 项目结束时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date endTime;
	/** 注册资本 */
	private String regCap;
	/** 注册时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date invRegTime;
	/** 法人 */
	private String legalPrsn;
	/** 懂事 */
	private String dir;
	/** 监事 */
	private String spvs;
	/** 注册地 */
	private String regAdd;
	/** 主营业务 */
	private String mainCore;
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

	public String getMny() {
		return mny;
	}

	public void setMny(String mny) {
		this.mny = mny;
	}

	public String getInvPro() {
		return invPro;
	}

	public void setInvPro(String invPro) {
		this.invPro = invPro;
	}

	public String getInvType() {
		return invType;
	}

	public void setInvType(String invType) {
		this.invType = invType;
	}

	public Date getInvTime() {
		return invTime;
	}

	public void setInvTime(Date invTime) {
		this.invTime = invTime;
	}

	public String getBankSrc() {
		return bankSrc;
	}

	public void setBankSrc(String bankSrc) {
		this.bankSrc = bankSrc;
	}

	public String getInvIncm() {
		return invIncm;
	}

	public void setInvIncm(String invIncm) {
		this.invIncm = invIncm;
	}

	public String getInvDeal() {
		return invDeal;
	}

	public void setInvDeal(String invDeal) {
		this.invDeal = invDeal;
	}

	public String getRegCap() {
		return regCap;
	}

	public void setRegCap(String regCap) {
		this.regCap = regCap;
	}

	public String getProSource() {
		return proSource;
	}

	public void setProSource(String proSource) {
		this.proSource = proSource;
	}

	public String getProMny() {
		return proMny;
	}

	public void setProMny(String proMny) {
		this.proMny = proMny;
	}

	public Date getStartTime() {
		return startTime;
	}

	public void setStartTime(Date startTime) {
		this.startTime = startTime;
	}

	public Date getEndTime() {
		return endTime;
	}

	public void setEndTime(Date endTime) {
		this.endTime = endTime;
	}

	public Date getInvRegTime() {
		return invRegTime;
	}

	public void setInvRegTime(Date invRegTime) {
		this.invRegTime = invRegTime;
	}

	public String getLegalPrsn() {
		return legalPrsn;
	}

	public void setLegalPrsn(String legalPrsn) {
		this.legalPrsn = legalPrsn;
	}

	public String getDir() {
		return dir;
	}

	public void setDir(String dir) {
		this.dir = dir;
	}

	public String getSpvs() {
		return spvs;
	}

	public void setSpvs(String spvs) {
		this.spvs = spvs;
	}

	public String getRegAdd() {
		return regAdd;
	}

	public void setRegAdd(String regAdd) {
		this.regAdd = regAdd;
	}

	public String getMainCore() {
		return mainCore;
	}

	public void setMainCore(String mainCore) {
		this.mainCore = mainCore;
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
