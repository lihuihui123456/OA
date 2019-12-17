package com.yonyou.aco.arc.borr.entity;

public enum BorrType {
	ZHIZHI("纸质","1"),DIANZI("电子","2");
	
	private String chname;
	private String value;
	private BorrType(String chname, String value) {
		this.chname = chname;
		this.value = value;
	}
	
	/**
	 * 根据值获取一个部门
	 * @param value
	 * @return 如果没有返回null
	 */
	public static BorrType getBorrTypeByValue(String value){
		for(BorrType temp: BorrType.values()){
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
	public static BorrType getBorrTypeByChname(String chname){
		for(BorrType temp: BorrType.values()){
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
