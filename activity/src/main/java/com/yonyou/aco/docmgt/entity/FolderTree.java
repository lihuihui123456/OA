package com.yonyou.aco.docmgt.entity;

import java.io.Serializable;

public class FolderTree implements Serializable{
	
	private static final long serialVersionUID = 1L;
	
	private String  id;
	private String  name;
	private String  pId;
//	private boolean open;
	
	public String getId() {
		return id;
	}
	
	public void setId(String id) {
		this.id = id;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getpId() {
		return pId;
	}

	public void setpId(String pId) {
		this.pId = pId;
	}
}