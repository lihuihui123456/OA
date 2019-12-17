package com.yonyou.aco.arc.type.entity;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

public class ArcTypeBean {

	private String Id;
	private String typeName;
	private String userName;
	private String arcType;
	@DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
	private Date createTime;
	private String remark;
	private String creTime;
	private String isPrnt;
	private String prntId;
    private String href;
	private int orderBy;
	
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

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getArcType() {
		return arcType;
	}

	public void setArcType(String arcType) {
		this.arcType = arcType;
	}

	public Date getCreateTime() {
		return createTime;
	}

	public void setCreateTime(Date createTime) {
		this.createTime = createTime;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getCreTime() {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		if(createTime!=null){
			creTime = sdf.format(createTime);
		}
		return creTime;
	}

	public void setCreTime(String creTime) {
		this.creTime = creTime;
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

	public String getHref() {
		return href;
	}

	public void setHref(String href) {
		this.href = href;
	}

	public int getOrderBy() {
		return orderBy;
	}

	public void setOrderBy(int orderBy) {
		this.orderBy = orderBy;
	}
	
	

}
