package com.yonyou.aco.lucene.service.Impl;

import java.io.File;
import java.io.IOException;
import java.sql.SQLException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.lucene.analysis.Analyzer;
import org.apache.lucene.analysis.standard.StandardAnalyzer;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.apache.lucene.document.Field.Store;
import org.apache.lucene.document.StringField;
import org.apache.lucene.document.TextField;
import org.apache.lucene.index.IndexWriter;
import org.apache.lucene.index.IndexWriterConfig;
import org.apache.lucene.index.Term;
import org.apache.lucene.store.Directory;
import org.apache.lucene.store.FSDirectory;
import org.apache.lucene.util.Version;
import org.springframework.stereotype.Service;

import com.yonyou.aco.lucene.entity.DbsSql;
import com.yonyou.aco.lucene.service.DbsIndexService;
import com.yonyou.cap.common.util.LuceneConstant;
import com.yonyou.cap.sys.iweboffice.service.DocumentService;
import com.yonyou.cap.sys.lucene.service.ILuceneService;

@Service
public class DbsIndexServiceImpl implements DbsIndexService {

	@Resource
	DocumentService documentService;
	@Resource
	private ILuceneService luceneService;
	
	@Override
	public String createDbsIndex(DbsSql dbsql,HttpServletRequest request)  throws ClassNotFoundException, SQLException, IOException{
		
		if (dbsql == null) {
			return "创建失败,获取索引信息失败!";
		}
		
		String bizid = dbsql.getLuce_condition();// 正文字段
		IndexWriter indexWriter = getIndexWriter(dbsql.getIndex_type(),request);
		try {
			StringBuilder roleuser = new StringBuilder();
			String path = dbsql.getLuce_path();

			String text = "";
			String fileName = "";
			String annexid = dbsql.getLuce_annex();// 附件id字段
			if (annexid != null && !"".equals(annexid)) {

				String document = dbsql.getLuce_document();
				if ("table_id".equals(document)) {
					document = "tableId";
				} else if ("biz_id".equals(document)) {
					document = "bizid";
				}
				text = documentService.getFileContentByKey(document,
						annexid);
				fileName = documentService.getFileName(document, annexid);
			}
			Document document = new Document();
			String docid = dbsql.getLuce_id();
			
			document.add(new StringField("id", docid, Field.Store.YES));
			String keyvalue = dbsql.getLuce_key();
			if (keyvalue == null) keyvalue = "";
			
			document.add(new StringField("luce_key", keyvalue, Store.YES));
			document.add(new StringField("type", dbsql.getIndex_type(),
					Store.YES));
			String doctitle = dbsql.getLuce_title();
			if (doctitle == null) doctitle = "";
			
			document.add(new TextField("title", doctitle, Store.YES));
			String doccontent = dbsql.getLuce_contents();
			if (doccontent == null) doccontent = "";
			
			if (bizid != null && !"".equals(bizid)) {
				String biztext = documentService.getFileContentByKey(
						"bizid", bizid);
				doccontent += biztext;
			}
			document.add(new TextField("content", doccontent, Store.YES));
			document.add(new TextField("text", text, Store.YES));
			document.add(new TextField("fileName", fileName, Store.YES));
			document.add(new TextField("path", path, Store.YES));
			document.add(new TextField("roleuser", roleuser.toString(), Store.YES));
			String doctime = dbsql.getLuce_time();
			if (doctime == null) doctime = "";
			document.add(new TextField("lastModify", doctime, Store.YES));
			Term term = new Term("id", dbsql.getLuce_id().toString());
			luceneService.addDocument(term, document,dbsql.getIndex_type(), indexWriter);
			
			indexWriter.commit();
			indexWriter.close();
		} catch (Exception ex) {
			indexWriter.commit();
			indexWriter.close();
			return "创建失败,执行出现异常!";
		} 
		return "1";
	}
	
	@Override
	public String deleteIndex(String id,String indexType,HttpServletRequest request)  throws ClassNotFoundException, SQLException, IOException{
		
		if (StringUtils.isBlank(id)) {
			return "删除失败,获取索引信息失败!";
		}
		if (StringUtils.isBlank(indexType)) {
			return "删除失败,获取索引类型失败!";
		}
		IndexWriter indexWriter = null;
		try {
			indexWriter = this.getIndexWriter(indexType,request);
			Term term = new Term("id", id);
			
			indexWriter.deleteDocuments(term);
			indexWriter.commit();
			indexWriter.close();
		} catch (Exception ex) {
			indexWriter.commit();
			indexWriter.close();
			return "删除失败,执行出现异常!";
		} 
		return "1";
	}
	
	public IndexWriter getIndexWriter(String type,HttpServletRequest request) throws IOException {
		try {
			String indexDir = LuceneConstant.getIndexDir(request) + "\\";
			Directory directory = FSDirectory.open(new File(
					indexDir + type));
			Version version = Version.LUCENE_44;
			Analyzer analyzer = new StandardAnalyzer(version);
			IndexWriterConfig indexWriterConfig = new IndexWriterConfig(
					version, analyzer);
			indexWriterConfig
					.setOpenMode(IndexWriterConfig.OpenMode.CREATE_OR_APPEND);
			IndexWriter indexWriter = new IndexWriter(directory,
					indexWriterConfig);
			return indexWriter;
		} catch (Exception ex) {
			System.out.println(ex.getMessage());
			return null;
		}
	}
}