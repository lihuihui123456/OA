package com.yonyou.aco.docmgt.service.Impl;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.yonyou.aco.docmgt.entity.BizDocFolderEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoBean;
import com.yonyou.aco.docmgt.entity.BizDocInfoEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoRefMediaBean;
import com.yonyou.aco.docmgt.entity.BizDocInfoRefMediaEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoTypeEntity;
import com.yonyou.aco.docmgt.entity.BizDocRelationshipEntity;
import com.yonyou.aco.docmgt.repository.DocMgtDao;
import com.yonyou.aco.docmgt.service.DocMgtService;
import com.yonyou.cap.bpm.entity.BpmRuBizInfoBean;
import com.yonyou.cap.bpm.entity.BpmRuBizInfoEntity;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.sys.iweboffice.entity.IWebDocumentEntity;
import com.yonyou.cap.sys.iweboffice.service.DocumentService;
@Service("docMgtService")
public class DocMgtServiceImpl extends BaseDao implements DocMgtService {

	@Resource
	DocMgtDao docMgtDao;
	@Resource
	DocumentService documentService;
	@Resource
	IBpmRuBizInfoService bpmRuBizInfoService;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Override
	public List<BizDocFolderEntity> findFolderList(String userid) {
		return docMgtDao.findFolderList(userid);
	}

	@Override
	public List<BizDocFolderEntity> findParentFolderList() {
		return docMgtDao.findParentFolderList();
	}

	@Override
	public void doSaveDocInfo(BizDocInfoEntity docinfo) {
		docMgtDao.save(docinfo);
	}

	@Override
	public void doUpdateDocInfo(BizDocInfoEntity docinfo) {
		docMgtDao.update(docinfo);
	}

	@Override
	public void doSaveDocumentInfo(BizDocInfoRefMediaEntity media) {
		docMgtDao.save(media);
	}

	@Override
	public void doSaveMediaList(List<BizDocInfoRefMediaEntity> mediaList) {
		docMgtDao.saveEntitys(mediaList);
	}

	@Override
	public PageResult<BizDocInfoRefMediaBean> findFolderContent(int pageNum,
			int pageSize, String userid, String folderId, String doc_type,
			String folderName) {
		return docMgtDao.findFolderContent(pageNum, pageSize, userid, folderId,
				doc_type, folderName);
	}

	@Override
	public PageResult<BizDocInfoBean> findFolderContentPaper(int pageNum,
			int pageSize, String userid, String folderName) {
		return docMgtDao.findFolderContentPaper(pageNum, pageSize, userid, folderName);
	}
	
	@Override
	public List<BizDocInfoRefMediaEntity> findMediaList(String docInfoId) {
		String wheresql = "";
		wheresql += "doc_info_id_=?";
		Object[] obj=new Object[1];
		obj[0]=docInfoId;
		return docMgtDao.getListBySql(BizDocInfoRefMediaEntity.class, wheresql,
				obj, null);
	}

	@Override
	public BizDocInfoRefMediaEntity findMediaByPK(String id) {
		return docMgtDao.findEntityByPK(BizDocInfoRefMediaEntity.class, id);
	}

	@Override
	public void doSaveFolder(BizDocFolderEntity docFolder) {
		docMgtDao.save(docFolder);
	}

	@Override
	public String findMaxFolder(String pId) {
		return docMgtDao.findMaxFolder(pId);
	}

	@Override
	public void doSaveFileToDb(BizDocInfoRefMediaEntity media) {
		docMgtDao.save(media);
	}

	@Override
	public void doSaveBizDocRelationship(BizDocRelationshipEntity relation) {
		docMgtDao.save(relation);
	}

	@Override
	public BizDocFolderEntity getBizDocFolderEntityById(String id) {
		return docMgtDao.getBizDocFolderEntityById(id);
	}
	
	@Override
	public BizDocInfoRefMediaEntity getBizDocInfoRefMediaEntityById(String id) {
		return docMgtDao.getBizDocInfoRefMediaEntityById(id);
	}
	@Override
	public String getUserIdByLoginName(String loginName) {
		return docMgtDao.getUserIdByLoginName(loginName);
	}
	@Override
	public String getCatalogId(String parentId, String id) {
		String reId="";
		for(int i=id.length();i<=4-id.length();i++){
			reId+="0";
		}
		reId+=id;
		return parentId+reId;
	}

	@Override
	public void deleteFolder(String folderId) {
		String wheresql = "";
		wheresql += " catalog_id=?";
		Object[] obj=new Object[1];
		obj[0]=folderId;
		List<BizDocFolderEntity> list=docMgtDao.getListBySql(BizDocFolderEntity.class, wheresql, obj,
				null);
		for(int i=0;i<list.size();i++){
			BizDocFolderEntity folder=null;
			if(list.size()>0){
				folder=list.get(i);
			}
			docMgtDao.delete(BizDocFolderEntity.class, folder.getId());
			List<BizDocInfoRefMediaBean> beanList=this.getMediaBean(folderId);
			for(int j=0;j<beanList.size();j++){
				BizDocInfoRefMediaBean bean=beanList.get(j);
				this.doDeleteBizDocInfoRefMedia(bean.getId_());
				String path = bean.getFilePath() + "/" + bean.getFileId();
				File file=new File(path);
				if(file.exists()){
					file.delete();
				}
			}
			
		}
		String wheresqlsub = " parent_catalog_id=?";
		obj[0]=folderId;
		List<BizDocFolderEntity> listsub=docMgtDao.getListBySql(BizDocFolderEntity.class, wheresqlsub, obj,
				null);
		for(int i=0;i<listsub.size();i++){
			BizDocFolderEntity foldersub=null;
			if(listsub.size()>0){
				foldersub=listsub.get(i);
			}
			this.deleteFolder(foldersub.getCatalogId());
		}
	}
	@Override
	public BizDocInfoRefMediaBean getFilePath(String ID_) {
		return docMgtDao.getFilePath(ID_);
	}
	@Override
	public List<BizDocInfoRefMediaBean> getMediaBean(String folderId) {
		return docMgtDao.getMediaBean(folderId);
	}

	@Override
	public void modifyFolder(String folderId,String folderName) {
		String wheresql = "";
		wheresql += " catalog_id=?";
		Object[] obj=new Object[1];
		obj[0]=folderId;
		List<BizDocFolderEntity> list=docMgtDao.getListBySql(BizDocFolderEntity.class, wheresql, obj,
				null);
		BizDocFolderEntity folder=null;
		if(list.size()>0){
			folder=list.get(0);
		}
		folder.setCatalogName(folderName);
		docMgtDao.save(folder);
		
	}
	public void shareFile(List<BizDocInfoRefMediaEntity> media) {
		docMgtDao.shareFile(media);
	}

	@Override
	public BizDocInfoRefMediaBean selectBizDocInfoRefMediaBean(String id) {
		return docMgtDao.selectBizDocInfoRefMediaBean(id);
	}

	@Override
	public void doDeleteBizDocInfoRefMedia(String id) {
		docMgtDao.delete(BizDocInfoRefMediaEntity.class, id);
		String shareSql = "";
		shareSql += " relation_id=?";
		Object[] obj=new Object[1];
		obj[0]=id;
		List<BizDocInfoRefMediaEntity> shareList=docMgtDao.getListBySql(BizDocInfoRefMediaEntity.class, shareSql, obj,
				null);
		for(int k=0;k<shareList.size();k++){
			BizDocInfoRefMediaEntity mediaShare=new BizDocInfoRefMediaEntity();
			mediaShare=shareList.get(k);
			docMgtDao.delete(BizDocInfoRefMediaEntity.class, mediaShare.getId());
		}
	}

	@Override
	public BizDocInfoBean selectDocInfo(String docInfoId) {
		return docMgtDao.selectDocInfo(docInfoId);
	}

	@Override
	public IWebDocumentEntity selectIWebDocument(String id) {
		return docMgtDao.selectIWebDocument(id);
	}
	@Override
	public List<IWebDocumentEntity> selectBiz(String bizId) {
		List<IWebDocumentEntity> list=new ArrayList<IWebDocumentEntity>();
		list=documentService.findMediaByBizid(bizId);
		//正文name为公文标题
		//通过bizId查询原文件
	   BpmRuBizInfoEntity oldActicle = bpmRuBizInfoService.findBpmRuBizInfoEntityById(bizId);
		IWebDocumentEntity iWebDocumentEntity=documentService.findDocumentByBizid(bizId);
		if(iWebDocumentEntity!=null){
			iWebDocumentEntity.setFileName(oldActicle.getBizTitle_());
		    list.add(iWebDocumentEntity);
		}
		return list;
	}
	@Override
	public PageResult<BpmRuBizInfoBean> findTaskHasDoList(int pageNum, int pageSize,String param,
			String sortName,String sortOrder) {
		return docMgtDao.findTaskHasDoList(pageNum, pageSize, param, sortName, sortOrder);
	}

	@Override
	public PageResult<BpmRuBizInfoBean> findTaskHasBelongList(int pageNum, int pageSize,String param,String id,
			String sortName,String sortOrder) {
		return docMgtDao.findTaskHasBelongList(pageNum, pageSize, param,id, sortName, sortOrder);
	}

	@Override
	public void updateHasBelong(String id_,String archive_state_) {
		BpmRuBizInfoEntity entity=docMgtDao.findEntityByPK(BpmRuBizInfoEntity.class, id_);
		entity.setArchiveState_(archive_state_);
		docMgtDao.update(entity);
	}

	@Override
	public List<BizDocInfoRefMediaBean> selectBizDocInfoRefMediaBean(
			BizDocInfoRefMediaBean bizDocInfoRefMediaBean) {
		// TODO Auto-generated method stub
		return docMgtDao.selectBizDocInfoRefMediaBean(bizDocInfoRefMediaBean);
	}

	@Override
	public BizDocFolderEntity getBizDocFolderEntity(String catalog_id) {
		return docMgtDao.getBizDocFolderEntity(catalog_id);
	}

	@Override
	public void upload(String tableId,String folderId,String recordId,Date date,String fileName,String filePath) {
		docMgtDao.upload(tableId, folderId, recordId, date, fileName, filePath);
	}
	@Override
	public List<BizDocInfoTypeEntity> findDocTypeList(){
		return docMgtDao.findDocTypeList();
	}
	@Override
	public List<BizDocInfoTypeEntity> findParentDocInfoList() {
		return docMgtDao.findParentDocInfoList();
	}
	@Override
	public String findMaxDocType(String pId) {
		return docMgtDao.findMaxFolder(pId);
	}
	@Override
	public void doSaveDocType(BizDocInfoTypeEntity docFolder) {
		docMgtDao.save(docFolder);
	}
	@Override
	public void modifyDocType(String folderId,String folderName) {
		String wheresql = "";
		wheresql += " catalog_id=?";
		Object[] obj=new Object[1];
		obj[0]=folderId;
		List<BizDocInfoTypeEntity> list=docMgtDao.getListBySql(BizDocInfoTypeEntity.class, wheresql, obj,
				null);
		BizDocInfoTypeEntity folder=null;
		if(list.size()>0){
			folder=list.get(0);
		}
		folder.setCatalogName(folderName);
		docMgtDao.save(folder);
		
	}
	@Override
	public void deleteDocType(String folderId) {
		String wheresql = "";
		wheresql += " catalog_id=?";
		Object[] obj=new Object[1];
		obj[0]=folderId;
		List<BizDocInfoTypeEntity> list=docMgtDao.getListBySql(BizDocInfoTypeEntity.class, wheresql, obj,
				null);
		BizDocInfoTypeEntity folder=null;
		if(list.size()>0){
		  folder=list.get(0);
	    }
		  folder.setDr("Y");
		  docMgtDao.save(folder);
	}
	public String doCheckRepat(String folderId,String folderName){
		String falg="N";
		String id= docMgtDao.doCheckRepat(folderId,folderName);
		if(StringUtils.isNotEmpty(id)){
			if(!id.equals(folderId)){
				falg="Y";
			}
		}
		return falg;
	}
	public String doCheckDelete(String folderId){
		String falg="N";
		String id= docMgtDao.doCheckDelete(folderId);
		if(StringUtils.isNotEmpty(id)){			
			falg="Y";
		}
		return falg;
	}
	public PageResult<BizDocInfoTypeEntity> listAllDocType(int pagenum,
			int pagesize,String title){
		
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		StringBuffer wheresql = new StringBuffer();
	    wheresql.append(" catalogType='0' and dr='N' ");
	    try {
	    if(StringUtils.isNotEmpty(title)){
			title= new String(title.getBytes("iso-8859-1"), "utf-8");
			wheresql.append("  and catalogName like '%"+title+"%' ");
	    }} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
	    	logger.error("error",e);
		}
		orderby.put("count", "desc");
		return docMgtDao.getPageData(BizDocInfoTypeEntity.class, pagenum, pagesize,wheresql.toString(), null,orderby);
		}
	public String getDocTypeNum(String folderId){
		return docMgtDao.getDocTypeNum(folderId);
	}
	public void setDocTypeNum(String folderId,String num){
		docMgtDao.setDocTypeNum(folderId, num);
	}
	public String doCheckName(String folderId,String folderName){
		String falg="N";
		String id= docMgtDao.doCheckName(folderId,folderName);
		if(StringUtils.isNotEmpty(id)){
				falg="Y";
		}
		return falg;
	}
	public String doCheckDel(String folderId){
		String falg="N";
		String id= docMgtDao.doCheckDel(folderId);
		if(StringUtils.isNotEmpty(id)){			
			falg="Y";
		}
		return falg;
	}
	@Override
	public String findMaxNum(String pId) {
		return docMgtDao.findMaxNum(pId);
	}
	public String doCheckFolderName(String folderId,String folderName,ShiroUser user){
		String falg="N";
		String id= docMgtDao.doCheckFolderName(folderId,folderName,user);
		if(StringUtils.isNotEmpty(id)){
				falg="Y";
		}
		return falg;
	}
	public String doCheckFolderRepat(String folderId,String folderName,ShiroUser user){
		String falg="N";
		String id= docMgtDao.doCheckFolderRepat(folderId,folderName,user);
		if(StringUtils.isNotEmpty(id)){
			if(!id.equals(folderId)){
				falg="Y";
			}
		}
		return falg;
	}
	public String doDelFolder(String folderId){
		String falg="N";
		String id= docMgtDao.doDelFolder(folderId);
		if(StringUtils.isNotEmpty(id)){			
			falg="Y";
		}
		return falg;
	}
	public String doFolderDel(String folderId){
		String falg="N";
		String id= docMgtDao.doFolderDel(folderId);
		if(StringUtils.isNotEmpty(id)){			
			falg="Y";
		}
		return falg;
	}

	@Override
	public void doDeleteDocInfo(BizDocInfoEntity docinfo) {
		docMgtDao.doDeleteDocInfo(docinfo);
	}
}