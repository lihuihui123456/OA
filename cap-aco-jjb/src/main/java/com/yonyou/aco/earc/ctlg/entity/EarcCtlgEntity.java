package com.yonyou.aco.earc.ctlg.entity;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;

import com.fasterxml.jackson.annotation.JsonProperty;


/**
 * 
 * TODO: 档案目录管理实体类
 * TODO: 涉及到bootstrap-table排序问题属性名称需要大写
 * 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2017年4月18日
 * @author 贺国栋
 * @since 1.0.0
 */
@Entity
@Table(name="earc_ctlg_info")
public class EarcCtlgEntity implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;

	
	/**
	 * 主键ID
	 */
	@JsonProperty("ID_")  
	private String ID_;
	/**
	 * 档案目录名称
	 */
	@JsonProperty("EARC_CTLG_NAME")  
	private String EARC_CTLG_NAME;

	/**
	 * 档案目录号
	 */
	@JsonProperty("EARC_CTLG_NBR")  
	private String EARC_CTLG_NBR;

	/**
	 * 档案目录创建人
	 */
	@JsonProperty("CREATE_USER_NAME")  
	private String CREATE_USER_NAME;

	/**
	 * 档案目录创建时间
	 */
	@JsonProperty("CREATE_TIME")  
	private String CREATE_TIME;

	/**
	 * 档案目录父ID
	 */
	@JsonProperty("PARENT_ID")  
	private String PARENT_ID;

	/**
	 * 是否删除
	 */
	@JsonProperty("DR")  
	private String DR;
	/**
	 * 单位Id
	 */
	@JsonProperty("DATA_ORG_ID")  
	private String DATA_ORG_ID;

	/**
	 * 部门Id
	 */
	@JsonProperty("DATA_DEPT_ID")  
	private String DATA_DEPT_ID;

	/**
	 * 部门CODE
	 */
	@JsonProperty("DATA_DEPT_CODE")  
	private String DATA_DEPT_CODE;

	/**
	 * 用户ID
	 */
	@JsonProperty("DATA_USER_ID")  
	private String DATA_USER_ID;

	/**
	 * 租户ID
	 */
	@JsonProperty("TENANT_ID")  
	private String TENANT_ID;
	/**
	 * 树等级
	 */
	@JsonProperty("ORDER_BY")  
	private String ORDER_BY;
	/**
	 * 时间戳
	 */
	@JsonProperty("TS")  
	private String TS;

	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	public String getID_() {
		return ID_;
	}

	public void setID_(String iD_) {
		ID_ = iD_;
	}

	

	public String getEARC_CTLG_NAME() {
		return EARC_CTLG_NAME;
	}

	public void setEARC_CTLG_NAME(String eARC_CTLG_NAME) {
		EARC_CTLG_NAME = eARC_CTLG_NAME;
	}

	public String getEARC_CTLG_NBR() {
		return EARC_CTLG_NBR;
	}

	public void setEARC_CTLG_NBR(String eARC_CTLG_NBR) {
		EARC_CTLG_NBR = eARC_CTLG_NBR;
	}

	public String getCREATE_USER_NAME() {
		return CREATE_USER_NAME;
	}

	public void setCREATE_USER_NAME(String cREATE_USER_NAME) {
		CREATE_USER_NAME = cREATE_USER_NAME;
	}

	public String getCREATE_TIME() {
		return CREATE_TIME;
	}

	public void setCREATE_TIME(String cREATE_TIME) {
		CREATE_TIME = cREATE_TIME;
	}

	public String getPARENT_ID() {
		return PARENT_ID;
	}

	public void setPARENT_ID(String pARENT_ID) {
		PARENT_ID = pARENT_ID;
	}

	
	
	public String getDR() {
		return DR;
	}

	public void setDR(String dR) {
		DR = dR;
	}

	public String getDATA_ORG_ID() {
		return DATA_ORG_ID;
	}

	public void setDATA_ORG_ID(String dATA_ORG_ID) {
		DATA_ORG_ID = dATA_ORG_ID;
	}

	public String getDATA_DEPT_ID() {
		return DATA_DEPT_ID;
	}

	public void setDATA_DEPT_ID(String dATA_DEPT_ID) {
		DATA_DEPT_ID = dATA_DEPT_ID;
	}

	public String getDATA_DEPT_CODE() {
		return DATA_DEPT_CODE;
	}

	public void setDATA_DEPT_CODE(String dATA_DEPT_CODE) {
		DATA_DEPT_CODE = dATA_DEPT_CODE;
	}

	public String getDATA_USER_ID() {
		return DATA_USER_ID;
	}

	public void setDATA_USER_ID(String dATA_USER_ID) {
		DATA_USER_ID = dATA_USER_ID;
	}

	public String getTENANT_ID() {
		return TENANT_ID;
	}

	public void setTENANT_ID(String tENANT_ID) {
		TENANT_ID = tENANT_ID;
	}

	public String getTS() {
		return TS;
	}

	public void setTS(String tS) {
		TS = tS;
	}

	public String getORDER_BY() {
		return ORDER_BY;
	}

	public void setORDER_BY(String oRDER_BY) {
		ORDER_BY = oRDER_BY;
	}

}
