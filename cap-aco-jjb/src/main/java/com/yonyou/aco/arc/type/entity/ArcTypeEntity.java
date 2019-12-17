package com.yonyou.aco.arc.type.entity;

import java.io.Serializable;
import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.Table;

import org.hibernate.annotations.GenericGenerator;
import org.springframework.format.annotation.DateTimeFormat;

/**
 * 
 * TODO: 类型实体类 TODO: 档案管理类型实体类 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月21日
 * @author hegd
 * @since 1.0.0
 */
@Entity
@Table(name = "biz_arc_type_info")
public class ArcTypeEntity  implements Serializable {

	/**
	 * TODO: 填入栏位说明
	 */
	private static final long serialVersionUID = 1L;
	
	/** 档案类型ID */
	private String Id;
	/** 类型名称 */
	private String typeName;
	/** 创建时间 */
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date creTime;
	/** 创建人 */
	private String creUser;
	/** 备注 */
	private String remark;
	/** 是否父节点Y：是N：不是 */
	private String isPrnt;
	/** 父节点ID */
	private String prntId;
	/** 档案类型 0：档案类型1：文件类型 */
	private String arcType;
	/** 类型排序 */
	private int orderBy;
	/** 链接地址 */
	private String href;
	/** 单位ID */
	private String dataOrgId;
	/** 部门CODE */
	private String dataDeptCode;
	/** 用户ID */
	private String dataUserId;
	/** 租户ID */
	private String tenantId;
	/** 时间戳 */
	private String ts;
	/** 删除 Y已删除 N未删除 */
	private String dr;
	
	@Id
	@GenericGenerator(name = "idGenerator", strategy = "uuid")
	@GeneratedValue(generator = "idGenerator")
	@Column(name = "id", unique = true, nullable = false, length = 64)
	public String getId() {
		return Id;
	}

	public void setId(String id) {
		Id = id;
	}

	public String getTypeName() {
		return typeName;
	}

	public void setTypeName(String typeName) {
		this.typeName = typeName;
	}

	public Date getCreTime() {
		return creTime;
	}

	public void setCreTime(Date creTime) {
		this.creTime = creTime;
	}

	public String getCreUser() {
		return creUser;
	}

	public void setCreUser(String creUser) {
		this.creUser = creUser;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getIsPrnt() {
		return isPrnt;
	}

	public void setIsPrnt(String isPrnt) {
		this.isPrnt = isPrnt;
	}

	public String getPrntId() {
		return prntId;
	}

	public void setPrntId(String prntId) {
		this.prntId = prntId;
	}

	public String getArcType() {
		return arcType;
	}

	public void setArcType(String arcType) {
		this.arcType = arcType;
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

	public String getDr() {
		return dr;
	}

	public void setDr(String dr) {
		this.dr = dr;
	}

	public int getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(int orderBy) {
		this.orderBy = orderBy;
	}

	public String getHref() {
		return href;
	}

	public void setHref(String href) {
		this.href = href;
	}

}
