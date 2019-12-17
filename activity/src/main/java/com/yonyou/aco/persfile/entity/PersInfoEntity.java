package com.yonyou.aco.persfile.entity;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.persistence.Transient;
@Entity
@Table(name = "fd_biz_people")
public class PersInfoEntity {
	@SuppressWarnings("unused")
	private static final long serialVersionUID = 1L;
	/** 档案ID */

	/**  */
	private String ts;
	/**  */
	private String data_user_id;
	/**  */
	private String data_dept_code;
	/**  */
	private String data_org_id;
	/**  */
	private String data_tenant_id;
	/**  */
	private String dr;
	/**  */
	private String c_uid;
	/**  */
	private String dynamic_data;
	/**  */
	private String userName_;
	/**  */
	private String user_sex;
	/**  */
	private String user_height;
	/**  */
	private String marital_status;
	/**  */
	private String user_native_place;
	/**  */
	private String user_police_type;
	/**  */
	private String user_nation;
	/**  */
	private String user_cert_code;
	/**  */
	private String user_bitrth;
	/**  */
	private String user_education;
	/**  */
	private String user_degree;
	/**  */
	private String join_time;
	/**  */
	private String entry_time;
	/**  */
	private String work_time;
	/**  */
	private String office_phone;
	/**  */
	private String telephone;
	/**  */
	private String user_email;
	/**  */
	private String user_address;
	/**  */
	private String user_seniority;
	/**  */
	private String user_duty_type;
	/**  */
	private String deptName_;
	/**  */
	private String user_qq;
	/**  */
	private String duty_post;
	 @Id
	@Column(name="id", unique=true, length=64, nullable=false)
	/**  */
	private String id;
	/**  */
	private String dept_;
	/**  */
	private String appointment;
	

	public String getTs() {
		return ts;
	}
	public void setTs(String ts) {
		this.ts = ts;
	}
	public String getData_user_id() {
		return data_user_id;
	}
	public void setData_user_id(String data_user_id) {
		this.data_user_id = data_user_id;
	}
	public String getData_dept_code() {
		return data_dept_code;
	}
	public void setData_dept_code(String data_dept_code) {
		this.data_dept_code = data_dept_code;
	}

	public String getData_org_id() {
		return data_org_id;
	}
	public void setData_org_id(String data_org_id) {
		this.data_org_id = data_org_id;
	}
	public String getData_tenant_id() {
		return data_tenant_id;
	}
	public void setData_tenant_id(String data_tenant_id) {
		this.data_tenant_id = data_tenant_id;
	}
	@Transient
	public String getDr() {
		return dr;
	}
	public void setDr(String dr) {
		this.dr = dr;
	}
	public String getC_uid() {
		return c_uid;
	}
	public void setC_uid(String c_uid) {
		this.c_uid = c_uid;
	}
	public String getDynamic_data() {
		return dynamic_data;
	}
	public void setDynamic_data(String dynamic_data) {
		this.dynamic_data = dynamic_data;
	}
	public String getUserName_() {
		return userName_;
	}
	public void setUserName_(String userName_) {
		this.userName_ = userName_;
	}
	public String getUser_sex() {
		return user_sex;
	}
	public void setUser_sex(String user_sex) {
		this.user_sex = user_sex;
	}
	public String getUser_height() {
		return user_height;
	}
	public void setUser_height(String user_height) {
		this.user_height = user_height;
	}
	public String getMarital_status() {
		return marital_status;
	}
	public void setMarital_status(String marital_status) {
		this.marital_status = marital_status;
	}
	public String getUser_native_place() {
		return user_native_place;
	}
	public void setUser_native_place(String user_native_place) {
		this.user_native_place = user_native_place;
	}
	public String getUser_police_type() {
		return user_police_type;
	}
	public void setUser_police_type(String user_police_type) {
		this.user_police_type = user_police_type;
	}
	public String getUser_nation() {
		return user_nation;
	}
	public void setUser_nation(String user_nation) {
		this.user_nation = user_nation;
	}
	public String getUser_cert_code() {
		return user_cert_code;
	}
	public void setUser_cert_code(String user_cert_code) {
		this.user_cert_code = user_cert_code;
	}
	public String getUser_bitrth() {
		return user_bitrth;
	}
	public void setUser_bitrth(String user_bitrth) {
		this.user_bitrth = user_bitrth;
	}
	public String getUser_education() {
		return user_education;
	}
	public void setUser_education(String user_education) {
		this.user_education = user_education;
	}
	public String getUser_degree() {
		return user_degree;
	}
	public void setUser_degree(String user_degree) {
		this.user_degree = user_degree;
	}
	public String getJoin_time() {
		return join_time;
	}
	public void setJoin_time(String join_time) {
		this.join_time = join_time;
	}
	public String getEntry_time() {
		return entry_time;
	}
	public void setEntry_time(String entry_time) {
		this.entry_time = entry_time;
	}
	public String getWork_time() {
		return work_time;
	}
	public void setWork_time(String work_time) {
		this.work_time = work_time;
	}
	public String getOffice_phone() {
		return office_phone;
	}
	public void setOffice_phone(String office_phone) {
		this.office_phone = office_phone;
	}
	public String getTelephone() {
		return telephone;
	}
	public void setTelephone(String telephone) {
		this.telephone = telephone;
	}
	public String getUser_email() {
		return user_email;
	}
	public void setUser_email(String user_email) {
		this.user_email = user_email;
	}
	public String getUser_address() {
		return user_address;
	}
	public void setUser_address(String user_address) {
		this.user_address = user_address;
	}
	public String getUser_seniority() {
		return user_seniority;
	}
	public void setUser_seniority(String user_seniority) {
		this.user_seniority = user_seniority;
	}
	public String getUser_duty_type() {
		return user_duty_type;
	}
	public void setUser_duty_type(String user_duty_type) {
		this.user_duty_type = user_duty_type;
	}
	public String getDeptName_() {
		return deptName_;
	}
	public void setDeptName_(String deptName_) {
		this.deptName_ = deptName_;
	}
	public String getUser_qq() {
		return user_qq;
	}
	public void setUser_qq(String user_qq) {
		this.user_qq = user_qq;
	}
	public String getDuty_post() {
		return duty_post;
	}
	public void setDuty_post(String duty_post) {
		this.duty_post = duty_post;
	}
	public String getId() {
		return id;
	}
	public void setId(String id) {
		this.id = id;
	}
	public String getDept_() {
		return dept_;
	}
	public void setDept_(String dept_) {
		this.dept_ = dept_;
	}
	public String getAppointment() {
		return appointment;
	}
	public void setAppointment(String appointment) {
		this.appointment = appointment;
	}

	
}
