package com.yonyou.aco.earc.acctvchr.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * 
 * TODO: 档案业务信息实体
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2017年5月3日
 * @author  贺国栋
 * @since   1.0.0
 */
@Entity
@Table(name = "earc_biz_info")
public class EarcBizIEntity implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 业务主键ID
	 */
	private String ID;

	/**
	 * 档案ID
	 */
	private String EARC_ID;

	/**
	 * 档案状态
	 */
	private String EARC_STATE;

	/**
	 * 档案目录ID
	 */
	private String EARC_CTLG_ID;

	/**
	 * 操作人
	 */
	private String OPER_USER;

	/**
	 * 操作时间
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date OPER_TIME;
	
	/**
	 * 档案类型
	 */
	private String EARC_TYPE;
	
	/**
	 * 档案密级
	 */
	private String SECURITY_LEVEL;
	
	/**
	 * 保管年限
	 */
	private String TERM;

	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getEARC_ID() {
		return EARC_ID;
	}

	public void setEARC_ID(String eARC_ID) {
		EARC_ID = eARC_ID;
	}

	public String getEARC_STATE() {
		return EARC_STATE;
	}

	public void setEARC_STATE(String eARC_STATE) {
		EARC_STATE = eARC_STATE;
	}

	public String getEARC_CTLG_ID() {
		return EARC_CTLG_ID;
	}

	public void setEARC_CTLG_ID(String eARC_CTLG_ID) {
		EARC_CTLG_ID = eARC_CTLG_ID;
	}

	public String getOPER_USER() {
		return OPER_USER;
	}

	public void setOPER_USER(String oPER_USER) {
		OPER_USER = oPER_USER;
	}

	public Date getOPER_TIME() {
		return OPER_TIME;
	}

	public void setOPER_TIME(Date oPER_TIME) {
		OPER_TIME = oPER_TIME;
	}

	public String getEARC_TYPE() {
		return EARC_TYPE;
	}

	public void setEARC_TYPE(String eARC_TYPE) {
		EARC_TYPE = eARC_TYPE;
	}

	public String getSECURITY_LEVEL() {
		return SECURITY_LEVEL;
	}

	public void setSECURITY_LEVEL(String sECURITY_LEVEL) {
		SECURITY_LEVEL = sECURITY_LEVEL;
	}

	public String getTERM() {
		return TERM;
	}

	public void setTERM(String tERM) {
		TERM = tERM;
	}

	

}
