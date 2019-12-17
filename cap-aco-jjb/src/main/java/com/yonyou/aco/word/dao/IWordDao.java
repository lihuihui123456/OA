package com.yonyou.aco.word.dao;

import java.util.List;
import java.util.Map;

import com.yonyou.aco.word.entity.ActHiCommentWordBean;
import com.yonyou.aco.word.entity.ExportWordBean;
import com.yonyou.cap.form.entity.FormTable;

/**
 * 
 * ClassName: IWordDao 
 * @Description: 业务表单Word操作Dao类
 * @author hegd
 * @date 2016-8-24
 */
public interface IWordDao {

	public ExportWordBean getWordInfor(String bizId);

	public List<ActHiCommentWordBean> getCommentMessage(String procInstId);
	public FormTable getFormTable(String formId);
	
	public List<Map<String,String>> getDicColumns(String formId);
}
