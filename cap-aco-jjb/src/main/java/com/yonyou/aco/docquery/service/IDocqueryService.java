package com.yonyou.aco.docquery.service;

import com.yonyou.aco.docquery.entity.SearchBean;
import com.yonyou.cap.common.util.PageResult;

public interface IDocqueryService {
	public PageResult<SearchBean> getAllBasicinfo(int pageNum,int pageSize,String[] params,String title,String sortName,String sortOrder);
	PageResult<SearchBean> getAllBasicinfo_fw(int pageNum, int pageSize,String[] params,String title,String sortName,String sortOrder);
	public boolean updateSignTime(String bizId,String date);
	public String getExcel_fw(String[] params,String inputWordfw,String gwbt_fw,String bwzt_fw,String regUser,
			String jjcd_fw,String sfgd_fw);
	public String getExcel(String[] params,String InputWordsw,String gwbt,String regUser,String sfgd,String bwzt);
}
