package com.yonyou.aco.lucene.service;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;

import com.yonyou.aco.lucene.entity.DbsSql;

/**
 * 创建结构化数据索引
 */
public interface DbsIndexService {
	
	public String createDbsIndex(DbsSql dbsql,HttpServletRequest request) throws ClassNotFoundException, SQLException, IOException;
	
	public String deleteIndex(String id,String indexType,HttpServletRequest request) throws ClassNotFoundException, SQLException, IOException;
}