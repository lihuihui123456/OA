package com.yonyou.aco.arc.borr.entity;


public enum BorrDept {
	JIYAOSHI("机要室","1"),CHUSHI("处室","2"),ZONGBIANSHI("总编室","3"),QITA("其它部门","4");
	
	private String chname;
	private String value;
	private BorrDept(String chname, String value) {
		this.chname = chname;
		this.value = value;
	}
	
	/**
	 * 根据值获取一个部门
	 * @param value
	 * @return 如果没有返回null
	 */
	public static BorrDept getFileTypeByValue(String value){
		for(BorrDept temp: BorrDept.values()){
			if(temp.getValue().equals(value)){
				return temp;
			}
		}
		return null;
	}
	
	/**
	 * 根据中文名获取部门
	 * @param chname
	 * @return 如果没有返回null
	 */
	public static BorrDept getFileTypeByChname(String chname){
		for(BorrDept temp: BorrDept.values()){
			if(temp.getChname().equals(chname)){
				return temp;
			}
		}
		return null;
	}
	
	
	public String getChname() {
		return chname;
	}
	public void setChname(String chname) {
		this.chname = chname;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}
	
}
