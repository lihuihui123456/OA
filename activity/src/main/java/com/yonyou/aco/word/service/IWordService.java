package com.yonyou.aco.word.service;

import java.util.List;
import java.util.Map;

import com.yonyou.aco.word.entity.ActHiCommentWordBean;
import com.yonyou.aco.word.entity.ExportWordBean;
import com.yonyou.cap.form.entity.FormTable;

/**
 * 
 * ClassName: IWordService 
 * @Description: 导出Word接口类
 * @author hegd
 * @date 2016-8-24
 */

public interface IWordService {

	
	/**
	 * 
	 * @Description: 根据业务ID获取表单信息
	 * @param @param bizid
	 * @param @return   
	 * @return List<ExportWordBean>  
	 * @throws
	 * @author hegd
	 * @date 2016-8-24
	 */
	public ExportWordBean findWordInfor(String bizid);

	/**
	 * 
	 * @Description: 根据业务ID获取表达批示意见
	 * @param @param bizid
	 * @param @return   
	 * @return List<ActHiCommentWordBean>  
	 * @throws
	 * @author hegd
	 * @date 2016-8-24
	 */
	public List<ActHiCommentWordBean> findCommentMessage(String bizid);
	public FormTable getFormTable(String formId);
	/**
	 * 
	 * @param formId
	 * @return
	 */
	public List<Map<String,String>> getDicColumns(String formId);
}
