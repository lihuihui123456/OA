package com.yonyou.aco.arc.borr.entity;

public enum BorrSHR {
	YIFEN("一份","1"),LIANGFEN("两份","2"),SANFEN("三份","3"),SIFEN("四份","4");
	
	private String chname;
	private String value;
	private BorrSHR(String chname, String value) {
		this.chname = chname;
		this.value = value;
	}
	
	/**
	 * 根据值获取一个部门
	 * @param value
	 * @return 如果没有返回null
	 */
	public static BorrSHR getFileTypeByValue(String value){
		for(BorrSHR temp: BorrSHR.values()){
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
	public static BorrSHR getFileTypeByChname(String chname){
		for(BorrSHR temp: BorrSHR.values()){
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
