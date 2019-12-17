package com.yonyou.aco.word.service.Impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import com.yonyou.aco.word.dao.IWordDao;
import com.yonyou.aco.word.entity.ActHiCommentWordBean;
import com.yonyou.aco.word.entity.ExportWordBean;
import com.yonyou.aco.word.service.IWordService;
import com.yonyou.cap.form.entity.FormTable;

/**
 * 
 * ClassName: WordServiceImpl
 * 
 * @Description: 导出Word实现类
 * @author hegd
 * @date 2016-8-24
 */
@Repository(value = "wordService")
public class WordServiceImpl implements IWordService {

	@Resource
	IWordDao wordDao;

	@Override
	public ExportWordBean findWordInfor(String bizid) {
		return wordDao.getWordInfor(bizid);
	}

	@Override
	public List<ActHiCommentWordBean> findCommentMessage(String bizid) {
		return wordDao.getCommentMessage(bizid);
	}

	@Override
	public FormTable getFormTable(String formId) {
		return wordDao.getFormTable(formId);
	}
	
	public List<Map<String,String>> getDicColumns(String formId) {
		
		return wordDao.getDicColumns(formId);
	}
}
