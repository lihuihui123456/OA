package com.yonyou.aco.earc.seddread.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
import org.springframework.format.annotation.DateTimeFormat;

@Entity
@Table(name = "earc_sedd_red_info")
public class EarcSeddRedEntity implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * 主键ID
	 */
	private String ID;
	/**
	 * 接收人
	 */
	private String RECEIVE_USER;
	/**
	 * 发送人
	 */
	private String SEND_USER;
	/**
	 * 调阅开始日期
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date START_DATE;
	/**
	 * 调阅结束日期
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd")
	private Date END_DATE;
	/**
	 * 档案ID
	 */
	private String EARC_ID;

	
	
	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getRECEIVE_USER() {
		return RECEIVE_USER;
	}

	public void setRECEIVE_USER(String rECEIVE_USER) {
		RECEIVE_USER = rECEIVE_USER;
	}

	public String getSEND_USER() {
		return SEND_USER;
	}

	public void setSEND_USER(String sEND_USER) {
		SEND_USER = sEND_USER;
	}

	public Date getSTART_DATE() {
		return START_DATE;
	}

	public void setSTART_DATE(Date sTART_DATE) {
		START_DATE = sTART_DATE;
	}

	public Date getEND_DATE() {
		return END_DATE;
	}

	public void setEND_DATE(Date eND_DATE) {
		END_DATE = eND_DATE;
	}

	public String getEARC_ID() {
		return EARC_ID;
	}

	public void setEARC_ID(String eARC_ID) {
		EARC_ID = eARC_ID;
	}

}
