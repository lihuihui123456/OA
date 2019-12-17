package com.yonyou.aco.docquery.dao;

import java.util.List;

import com.yonyou.aco.docquery.entity.SearchEntity;
import com.yonyou.cap.common.base.IBaseDao;


public interface IDocqueryDao  extends IBaseDao{
	boolean updateSignTime(String bizId,String date);
	List<SearchEntity> getExcel_fw(Class<SearchEntity> class1, String sql);
}
