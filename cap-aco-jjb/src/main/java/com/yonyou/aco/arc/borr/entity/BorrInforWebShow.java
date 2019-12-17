package com.yonyou.aco.arc.borr.entity;

import java.io.Serializable;

public class BorrInforWebShow implements Serializable{

	/**
	 * 
	 */
	private static final long serialVersionUID = -1975518726176137967L;
	public BorrInfor borrInfor;
	//public String 
	public String borrUserName;
	
	public String creUserName;
	
	public String arcName;
	
	public String dengjiBumen;
	
	public String arcTypeName;
	
	public String jieyueBumen;
	
	public BorrInfor getBorrInfor() {
		return borrInfor;
	}
	public void setBorrInfor(BorrInfor borrInfor) {
		this.borrInfor = borrInfor;
	}
	public String getCreUserName() {
		return creUserName;
	}
	public void setCreUserName(String creUserName) {
		this.creUserName = creUserName;
	}
	public String getArcName() {
		return arcName;
	}
	public void setArcName(String arcName) {
		this.arcName = arcName;
	}
	public String getDengjiBumen() {
		return dengjiBumen;
	}
	public void setDengjiBumen(String dengjiBumen) {
		this.dengjiBumen = dengjiBumen;
	}
	public String getArcTypeName() {
		return arcTypeName;
	}
	public void setArcTypeName(String arcTypeName) {
		this.arcTypeName = arcTypeName;
	}
	public String getJieyueBumen() {
		return jieyueBumen;
	}
	public void setJieyueBumen(String jieyueBumen) {
		this.jieyueBumen = jieyueBumen;
	}
	public String getBorrUserName() {
		return borrUserName;
	}
	public void setBorrUserName(String borrUserName) {
		this.borrUserName = borrUserName;
	}

}
