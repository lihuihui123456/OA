package com.yonyou.aco.leave.entity;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * 
 * TODO: 请假管理实体类
 * 
 * @Date 2017年6月6日
 * @author 贺国栋
 * @since 1.0.0
 */
@Entity
@Table(name="biz_leave_info")
public class LeaveEntity {

	/**
	 * 主键ID
	 */
	public String ID;

	/**
	 * 请假业务ID
	 */
	public String LEAVE_ID;

	/**
	 * 请假状态
	 */
	public String STATE;

	/**
	 * 请假类型
	 */
	public String LEAVE_TYPE;

	/**
	 * 请假开始时间
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date START_TIME;

	/**
	 * 请假介绍时间
	 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	public Date END_TIME;

	/**
	 * 请假天数
	 */
	public String LEAVE_DAYS;

	/**
	 * 是否出京
	 */
	public String IS_BJ;

	/**
	 * 是否出境
	 */
	public String IS_EXIT;

	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	public String getID() {
		return ID;
	}

	public void setID(String iD) {
		ID = iD;
	}

	public String getLEAVE_ID() {
		return LEAVE_ID;
	}

	public void setLEAVE_ID(String lEAVE_ID) {
		LEAVE_ID = lEAVE_ID;
	}

	public String getSTATE() {
		return STATE;
	}

	public void setSTATE(String sTATE) {
		STATE = sTATE;
	}

	public String getLEAVE_TYPE() {
		return LEAVE_TYPE;
	}

	public void setLEAVE_TYPE(String lEAVE_TYPE) {
		LEAVE_TYPE = lEAVE_TYPE;
	}

	public Date getSTART_TIME() {
		return START_TIME;
	}

	public void setSTART_TIME(Date sTART_TIME) {
		START_TIME = sTART_TIME;
	}

	public Date getEND_TIME() {
		return END_TIME;
	}

	public void setEND_TIME(Date eND_TIME) {
		END_TIME = eND_TIME;
	}

	public String getLEAVE_DAYS() {
		return LEAVE_DAYS;
	}

	public void setLEAVE_DAYS(String lEAVE_DAYS) {
		LEAVE_DAYS = lEAVE_DAYS;
	}

	public String getIS_BJ() {
		return IS_BJ;
	}

	public void setIS_BJ(String iS_BJ) {
		IS_BJ = iS_BJ;
	}

	public String getIS_EXIT() {
		return IS_EXIT;
	}

	public void setIS_EXIT(String iS_EXIT) {
		IS_EXIT = iS_EXIT;
	}

}
