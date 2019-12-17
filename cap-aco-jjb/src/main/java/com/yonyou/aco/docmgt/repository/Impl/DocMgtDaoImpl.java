package com.yonyou.aco.docmgt.repository.Impl;

import java.util.Date;
import java.util.List;

import javax.persistence.Query;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.hibernate.SQLQuery;
import org.hibernate.transform.Transformers;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Repository;

import com.yonyou.aco.docmgt.entity.BizDocFolderEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoBean;
import com.yonyou.aco.docmgt.entity.BizDocInfoEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoRefMediaBean;
import com.yonyou.aco.docmgt.entity.BizDocInfoRefMediaEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoTypeEntity;
import com.yonyou.aco.docmgt.repository.DocMgtDao;
import com.yonyou.cap.bpm.entity.BpmRuBizInfoBean;
import com.yonyou.cap.bpm.entity.TaskBean;
import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.sys.iweboffice.entity.IWebDocumentEntity;

@Repository("docMgtDao")
public class DocMgtDaoImpl extends BaseDao implements DocMgtDao {
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@SuppressWarnings("unchecked")
	@Override
	public PageResult<BizDocInfoRefMediaBean> findFolderContent(int pageNum,
			int pageSize, String userid, String folderId,String doc_type, String folderName) {
		PageResult<BizDocInfoRefMediaBean> pr = new PageResult<BizDocInfoRefMediaBean>();
		try {
			int firstindex = 0;
			if (pageNum > 0) {
				firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
			}
			int maxresult = pageSize; // 页大小
			
			StringBuffer sb=new StringBuffer();
			sb.append("select a.id_ as id_,a.RELATION_ID as relationId,a.UPLOAD_USER_ID as uploadUserId,"
					+ "a.UPLOAD_TIME as uploadTime,a.UPLOAD_TIME as shareTime,a.DELETEFLAG as deleteFlag,b.file_name as fileName,"
					+ "b.record_id as fileId,b.html_path as filePath,b.file_type as fileType,a.share_user_id as shareUserId,a.folder_id as folderId,"
					+ "c.USER_NAME as uploadUserName,e.USER_NAME as shareUserName from "
					+ "biz_doc_info_ref_media a "
					+ "left join iweb_document b on a.FILE_ID=b.id_  "
					+ "left join isc_user c on a.UPLOAD_USER_ID=c.USER_ID "
					+ "left join isc_user e on a.share_user_id=e.USER_ID "
					+ "left join biz_doc_folder d on a.folder_id=d.catalog_id ");
			sb.append(" where (a.upload_user_id=:userid or d.catalog_type =2) ");
			sb.append(" and a.folder_id=:folderId");
			if(StringUtils.isNotEmpty(folderName)){
				sb.append(" and  b.file_name like :folderName");
			}
			sb.append(" group by  a.id_ order by a.UPLOAD_TIME desc");
			Query query = em.createNativeQuery(sb.toString());
			query.setParameter("userid", userid);
			query.setParameter("folderId", folderId);
			if(StringUtils.isNotEmpty(folderName)){
			    query.setParameter("folderName", "%" + folderName + "%");  
			}
			query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizDocInfoRefMediaBean.class));
			long size = query.getResultList().size();// 总数据长度
			
			/** 通过传过来的页码*每页显示条数和总数进行对比 判断第一条数据的取值 **/
			if (firstindex >= size) {
				if (size > pageSize) {
					query.setFirstResult(((int) size / pageSize - 1) * pageSize).setMaxResults(maxresult);
				} else {
					query.setFirstResult(0).setMaxResults(maxresult);
				}
			} else {
				query.setFirstResult(firstindex).setMaxResults(maxresult);
			}
			List<BizDocInfoRefMediaBean> list = query.getResultList();
			pr.setResults(list);
			pr.setTotalrecord(size);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return pr;
	}

	@Override
	public String findMaxFolder(String pId) {
		String sql = "SELECT max(a.CATALOG_ID) from biz_doc_info_type a where a.PARENT_CATALOG_ID=:pId";
		Query query = em.createNativeQuery(sql);
		query.setParameter("pId", pId);
		String maxId =  (String) query.getSingleResult();
		if(maxId==null){
			return "000";
		}
		return maxId.substring(pId.length(),maxId.length());
	}

	@SuppressWarnings("unchecked")
	@Override
	public PageResult<BizDocInfoBean> findFolderContentPaper(
			int pageNum, int pageSize, String userid, String folderName) {
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
		int maxresult = pageSize; // 页大小
		PageResult<BizDocInfoBean> pr = new PageResult<BizDocInfoBean>();
		StringBuffer sb=new StringBuffer();
		sb.append("SELECT a.id_,c.biz_title_,b.USER_NAME place_user_,a.PLACE_TIME place_time_  from biz_doc_info a "
				+ "LEFT JOIN isc_user b on a.place_user_id=b.USER_ID LEFT JOIN bpm_ru_biz_info c on a.biz_id=c.id_ where a.place_user_id=:userid");
		if(StringUtils.isNotEmpty(folderName)){
			sb.append(" and  c.biz_title_ like :folderName");
		}
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter("userid",userid);
		if(StringUtils.isNotEmpty(folderName)){		
			 query.setParameter("folderName", "%" + folderName + "%");
		}
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizDocInfoBean.class));
		long size = query.getResultList().size();// 总数据长度
		
		/** 通过传过来的页码*每页显示条数和总数进行对比 判断第一条数据的取值 **/
		if (firstindex >= size) {
			if (size > pageSize) {
				query.setFirstResult(((int) size / pageSize - 1) * pageSize).setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}
		List<BizDocInfoBean> list = query.getResultList();
		pr.setResults(list);
		pr.setTotalrecord(size);
		return pr;
	}
	
	@Override
	public void shareFile(List<BizDocInfoRefMediaEntity> media) {
		// TODO Auto-generated method stub
		for(int i=0 ;i<media.size() ; i++){
			BizDocInfoRefMediaEntity bizDocInfoRefMediaEntity=media.get(i);
			this.save(bizDocInfoRefMediaEntity);
		}
	}

	@SuppressWarnings("unchecked")
	@Override
	public BizDocInfoRefMediaBean selectBizDocInfoRefMediaBean(String id) {
		// TODO Auto-generated method stub
		StringBuffer sb=new StringBuffer();
		sb.append("SELECT b.id_ ,b.relation_id relationId,b.file_id fileId,b.folder_id  folderId,b.upload_user_id as uploadUserId,b.share_user_id as shareUserId from biz_doc_info_ref_media b where b.ID_ =:id");
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter("id",id);
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizDocInfoRefMediaBean.class));
		List<BizDocInfoRefMediaBean> list =query.getResultList();
		if(list.size()>0){
			return list.get(0);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public BizDocInfoBean selectDocInfo(String docInfoId) {
		// TODO Auto-generated method stub
		StringBuffer sb=new StringBuffer();
		sb.append("SELECT a.id_,a.biz_id biz_id_,a.place_user_id place_user_id_,a.place_time place_time_ from biz_doc_info a where a.ID_ =:docInfoId");
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter("docInfoId",docInfoId);
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizDocInfoBean.class));
		List<BizDocInfoBean> list =query.getResultList();
		if(list.size()>0){
			return list.get(0);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public IWebDocumentEntity selectIWebDocument(String id) {
		// TODO Auto-generated method stub
		StringBuffer sb=new StringBuffer();
		sb.append("SELECT a.id_ documentId,a.record_id recordId ,a.html_path htmlPath,a.file_name fileName,a.bizid bizid from iweb_document a where a.id_ =:id");
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter("id",id);
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(IWebDocumentEntity.class));
		List<IWebDocumentEntity> list =query.getResultList();
		if(list.size()>0){
			return list.get(0);
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BizDocInfoRefMediaBean> selectBizDocInfoRefMediaBean(
			BizDocInfoRefMediaBean bizDocInfoRefMediaBean) {
		// TODO Auto-generated method stub
		StringBuffer sb=new StringBuffer();
		sb.append("SELECT b.id_ ,b.relation_id relationId,b.file_id fileId from biz_doc_info_ref_media b where b.FOLDER_ID =:shareId and b.FILE_ID=:fileId and b.UPLOAD_USER_ID=:uploadUserId");
		Query query = em.createNativeQuery(sb.toString());
		query.setParameter("fileId",bizDocInfoRefMediaBean.getFileId());
		query.setParameter("shareId",bizDocInfoRefMediaBean.getFolderId());
		query.setParameter("uploadUserId",bizDocInfoRefMediaBean.getUploadUserId());
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizDocInfoRefMediaBean.class));
		List<BizDocInfoRefMediaBean> list =query.getResultList();
		return list;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BizDocFolderEntity> findFolderList(String userid) {
		StringBuffer sb = new StringBuffer();
		sb.append("select * from biz_doc_folder "
				+ " where catalog_type='2' or (user_id=?  and  catalog_type='0') order by CREATE_TIME asc");
		Query query = em.createNativeQuery(sb.toString(),BizDocFolderEntity.class);
		query.setParameter(1, userid);
		return query.getResultList();
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BizDocFolderEntity> findParentFolderList() {
		StringBuffer sb = new StringBuffer();
		sb.append("select * from biz_doc_folder "
				+ " where catalog_type='1'");
		Query query = em.createNativeQuery(sb.toString(),BizDocFolderEntity.class);
		return query.getResultList();
	}

	@SuppressWarnings("unchecked")
	@Override
	public BizDocFolderEntity getBizDocFolderEntityById(String id) {
		Query query = em.createQuery("select o from biz_doc_folder o where id_=:id");
		query.setParameter("id", id);
		BizDocFolderEntity folder=null;
		List<BizDocFolderEntity> list=query.getResultList();
		if(list.size()>0){
			folder=list.get(0);
		}
		return folder;
	}

	@SuppressWarnings("unchecked")
	@Override
	public BizDocInfoRefMediaEntity getBizDocInfoRefMediaEntityById(String id) {
		Query query = em.createQuery("select o from biz_doc_info_ref_media o where id_=:id");
		query.setParameter("id", id);
		BizDocInfoRefMediaEntity media=null;
		List<BizDocInfoRefMediaEntity> list=query.getResultList();
		if(list!=null&&list.size()>0){
			media=list.get(0);
		}
		return media;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String getUserIdByLoginName(String loginName) {
		Query query = em.createNativeQuery("select user_id from isc_user  where acct_login=:loginName");
		query.setParameter("loginName", loginName);
		List<String> list=query.getResultList();
		String userid="";
		if(list!=null&&list.size()>0){
			userid=list.get(0);
		}
		return userid;
	}

	@SuppressWarnings("unchecked")
	@Override
	public BizDocInfoRefMediaBean getFilePath(String ID_) {
		BizDocInfoRefMediaBean media=new BizDocInfoRefMediaBean();
		StringBuffer sb = new StringBuffer();
		sb.append("select b.id_ as id_,b.RELATION_ID as relationId,"
					+ "b.UPLOAD_TIME as uploadTime,b.DELETEFLAG as deleteFlag,a.file_name as fileName,"
					+ "a.record_id as fileId,a.html_path as filePath from iweb_document a inner join biz_doc_info_ref_media b on b.FILE_ID=a.id_ where b.ID_=:ID_");
		Query query  =  em.createNativeQuery(sb.toString());
		query.setParameter("ID_", ID_);
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizDocInfoRefMediaBean.class));
		List<BizDocInfoRefMediaBean> link = query.getResultList();
		if (link != null && link.size() != 0) {
			media= link.get(0);
		}
		return media;
	}

	@SuppressWarnings("unchecked")
	@Override
	public List<BizDocInfoRefMediaBean> getMediaBean(String folderId) {
		StringBuffer sb = new StringBuffer();
		sb.append("select b.id_ as id_,b.RELATION_ID as relationId,"
					+ "b.UPLOAD_TIME as uploadTime,b.DELETEFLAG as deleteFlag,a.file_name as fileName,"
					+ "a.record_id as fileId,a.html_path as filePath from iweb_document a inner join biz_doc_info_ref_media b on b.FILE_ID=a.id_ where b.FOLDER_ID=:FOLDER_ID");
		Query query  =  em.createNativeQuery(sb.toString());
		query.setParameter("FOLDER_ID", folderId);
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BizDocInfoRefMediaBean.class));
		List<BizDocInfoRefMediaBean> link = query.getResultList();
		return link;
	}

	/**
	 * 旧方法  HasDoList
	 */
	@SuppressWarnings("unchecked")
	public PageResult<TaskBean> OLDfindTaskHasDoList(int pageNum, int pageSize,
			String param) {
		String[] arr=null;
		if(!"".equalsIgnoreCase(param)){
			 arr = param.split("&");
		}
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
//		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		int maxresult = pageSize; // 页大小
		PageResult<TaskBean> pr = new PageResult<TaskBean>();
		StringBuffer sb=new StringBuffer();
		sb.append("SELECT" );
		sb.append(" a.sol_id_ solId," );
		sb.append("a.serial_number_ serial_number," );
		sb.append("a.biz_title_ name_," );
		sb.append(" a.urgency_ urgency," );
		sb.append("substr(a.create_time_ " );
		sb.append(" FROM" );
		sb.append(" 1 FOR 10) create_time," );
		sb.append(" a.state_," );
		sb.append(" c.user_name user_name," );
		sb.append(" b.start_time_," );
		sb.append(" b.proc_inst_id_," );
		sb.append(" b.id_," );
		sb.append(" a.id_ bizid," );
		sb.append(" b.end_time_ " );
		sb.append(" FROM" );
		sb.append("    bpm_ru_biz_info a " );
		sb.append("  LEFT JOIN" );
		sb.append("    act_hi_taskinst b " );
		sb.append("       ON b.PROC_INST_ID_ = a.proc_inst_id_ " );
		sb.append("  LEFT JOIN" );
		sb.append("    isc_user c " );
		sb.append("       ON a.CREATE_USER_ID_ = c.USER_ID " );
		sb.append("	 left join  " );
		sb.append("	   biz_doc_info d " );
		sb.append("       ON d.BIZ_ID=a.id_ " );
		sb.append("  where" );
		sb.append("     a.dr_='N' "
//				+ " and user_id='"+user.id+"'"
						+ " and state_='2' and d.BIZ_ID is null" );
		if(arr!=null){
		if(!"null".equalsIgnoreCase(arr[0])&&!"".equalsIgnoreCase(arr[0])){
			sb.append(" and a.biz_title_ like :bizTitle" );
		}
		if(!"null".equalsIgnoreCase(arr[1])&&!"".equalsIgnoreCase(arr[1])){
			sb.append(" and b.end_time_>=:endTime" );
		}if(!"null".equalsIgnoreCase(arr[2])&&!"".equalsIgnoreCase(arr[2])){
			sb.append(" and b.end_time_<=:endTime1"  );
		}}
		sb.append(" GROUP BY" );
		sb.append("    a.id_ " );
		sb.append(" ORDER BY" );
		sb.append("      create_time_ DESC" );
		Query query  =  em.createNativeQuery(sb.toString());
		if(arr!=null){
		if(!"null".equalsIgnoreCase(arr[0])&&!"".equalsIgnoreCase(arr[0])){
			query.setParameter("bizTitle","%"+arr[0]+"%" );
		}
		if(!"null".equalsIgnoreCase(arr[1])&&!"".equalsIgnoreCase(arr[1])){
			query.setParameter("endTime",arr[1]);
		}if(!"null".equalsIgnoreCase(arr[2])&&!"".equalsIgnoreCase(arr[2])){
			query.setParameter("endTime1",arr[2] );
		}}
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(TaskBean.class));	
		long size = query.getResultList().size();// 总数据长度
		/** 通过传过来的页码*每页显示条数和总数进行对比 判断第一条数据的取值 **/
		if (firstindex >= size) {
			if (size > pageSize) {
				query.setFirstResult(((int) size / pageSize - 1) * pageSize).setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}
		pr.setResults(query.getResultList());
		pr.setTotalrecord(size);
		return pr;
	}
	/**
	 * 新方法   HasDoList
	 */
	@SuppressWarnings("unchecked")
	@Override
	public PageResult<BpmRuBizInfoBean> findTaskHasDoList(int pageNum, int pageSize,
			String param,String sortName,String sortOrder) {
		String[] arr=null;
		if(!"".equalsIgnoreCase(param)){
			 arr = param.split("&");
		}
		int firstindex = 0;
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
//		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		int maxresult = pageSize; // 页大小
		PageResult<BpmRuBizInfoBean> pr = new PageResult<BpmRuBizInfoBean>();
		StringBuffer sb=new StringBuffer();
		sb.append("SELECT" );
		sb.append(" a.SOL_ID_ ," );
		sb.append("a.SERIAL_NUMBER_ ," );
		sb.append("a.BIZ_TITLE_ ," );
		sb.append(" a.URGENCY_ ," );
		sb.append("substr(a.CREATE_TIME_ " );
		sb.append(" FROM" );
		sb.append(" 1 FOR 10) CREATE_TIME_," );
		sb.append(" a.STATE_," );
		sb.append(" c.USER_NAME ," );
		sb.append(" trim(b.START_TIME_) START_TIME_," );
		sb.append(" b.PROC_INST_ID_," );
		sb.append(" b.ID_," );
		sb.append(" a.id_ bizid," );
		sb.append(" trim(b.END_TIME_) END_TIME_ " );
		sb.append(" FROM" );
		sb.append("    bpm_ru_biz_info a " );
		sb.append("  LEFT JOIN" );
		sb.append("    act_hi_taskinst b " );
		sb.append("       ON b.PROC_INST_ID_ = a.proc_inst_id_ " );
		sb.append("  LEFT JOIN" );
		sb.append("    isc_user c " );
		sb.append("       ON a.CREATE_USER_ID_ = c.USER_ID " );
		sb.append("	 left join  " );
		sb.append("	   biz_doc_info d " );
		sb.append("       ON d.BIZ_ID = a.id_ " );
		sb.append("  where" );
		sb.append("     a.dr_='N' "
//				+ " and user_id='"+user.id+"'"
						+ " and state_='2' and d.BIZ_ID is null" );
		if(arr!=null){
		if(!"null".equalsIgnoreCase(arr[0])&&!"".equalsIgnoreCase(arr[0])){
			sb.append(" and a.BIZ_TITLE_ like :bizTitle" );
		}
		if(!"null".equalsIgnoreCase(arr[1])&&!"".equalsIgnoreCase(arr[1])){
			sb.append(" and b.END_TIME_>=:endTime" );
		}if(!"null".equalsIgnoreCase(arr[2])&&!"".equalsIgnoreCase(arr[2])){
			sb.append(" and b.END_TIME_<=:endTime1"  );
		}}
		sb.append(" GROUP BY" );
		sb.append("    a.id_ " );
		if(StringUtils.isNotEmpty(sortName)){
			sb. append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sb.append(" order by CREATE_TIME_ "+sortOrder);
		}
		Query query  =  em.createNativeQuery(sb.toString());
		if(arr!=null){
		if(!"null".equalsIgnoreCase(arr[0])&&!"".equalsIgnoreCase(arr[0])){
			query.setParameter("bizTitle","%"+arr[0].trim()+"%" );
		}
		if(!"null".equalsIgnoreCase(arr[1])&&!"".equalsIgnoreCase(arr[1])){
			query.setParameter("endTime",arr[1]);
		}if(!"null".equalsIgnoreCase(arr[2])&&!"".equalsIgnoreCase(arr[2])){
			query.setParameter("endTime1",arr[2] );
		}}
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BpmRuBizInfoBean.class));	
		long size = query.getResultList().size();// 总数据长度
		/** 通过传过来的页码*每页显示条数和总数进行对比 判断第一条数据的取值 **/
		if (firstindex >= size) {
			if (size > pageSize) {
				query.setFirstResult(((int) size / pageSize - 1) * pageSize).setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}
		pr.setResults(query.getResultList());
		pr.setTotalrecord(size);
		return pr;
	}

	/**
	 * 旧方法   HasBelong
	 */
	@SuppressWarnings("unchecked")
	public PageResult<TaskBean> OldfindTaskHasBelongList(int pageNum,
			int pageSize, String param,String id,String sortName,String sortOrder) {
		String[] arr=null;
		if(!"".equalsIgnoreCase(param)){
			 arr = param.split("&");
		}
		
		int firstindex = 0;	
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
//		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		int maxresult = pageSize; // 页大小
		PageResult<TaskBean> pr = new PageResult<TaskBean>();
		StringBuffer sb=new StringBuffer();
		sb.append("SELECT" );
		sb.append(" a.sol_id_ solId," );
		sb.append("a.serial_number_ serial_number," );
		sb.append("a.biz_title_ name_," );
		sb.append(" a.urgency_ urgency," );
		sb.append("substr(a.create_time_ " );
		sb.append(" FROM" );
		sb.append(" 1 FOR 10) create_time," );
		sb.append(" a.state_," );
		sb.append(" c.user_name user_name," );
		sb.append(" b.start_time_," );
		sb.append(" b.proc_inst_id_," );
		sb.append(" b.id_," );
		sb.append(" a.id_ bizid," );
		sb.append("b.end_time_ " );
		sb.append(" FROM" );
		sb.append("    bpm_ru_biz_info a " );
		sb.append("  LEFT JOIN" );
		sb.append("      act_hi_taskinst b " );
		sb.append("       ON b.PROC_INST_ID_ = a.proc_inst_id_ " );
		sb.append("    LEFT JOIN" );
		sb.append("       isc_user c " );
		sb.append("           ON a.CREATE_USER_ID_ = c.USER_ID " );
		sb.append("		inner join  " );
		sb.append("	biz_doc_info d " );
		sb.append("  on d.BIZ_ID=a.id_ " );
		sb.append("   where" );
		sb.append("     a.dr_='N' "
//				+ " and user_id='"+user.id+"'"
						+ " and d.doc_type='"+id+"' and state_='2'" );
		if(arr!=null){
			if(!"null".equalsIgnoreCase(arr[0])&&!"".equalsIgnoreCase(arr[0])){
				sb.append(" and a.biz_title_ like :bizTitle" );
			}
			if(!"null".equalsIgnoreCase(arr[1])&&!"".equalsIgnoreCase(arr[1])){
				sb.append(" and d.place_time>=:endTime" );
			}if(!"null".equalsIgnoreCase(arr[2])&&!"".equalsIgnoreCase(arr[2])){
				sb.append(" and d.place_time<=:endTime1"  );
			}}
		sb.append(" GROUP BY" );
		sb.append("    a.id_ " );
		sb.append(" ORDER BY" );
		sb.append("      create_time_ DESC" );
		Query query  =  em.createNativeQuery(sb.toString());
		if(arr!=null){
		if(!"null".equalsIgnoreCase(arr[0])&&!"".equalsIgnoreCase(arr[0])){
			query.setParameter("bizTitle","%"+arr[0]+"%" );
		}
		if(!"null".equalsIgnoreCase(arr[1])&&!"".equalsIgnoreCase(arr[1])){
			query.setParameter("endTime",arr[1] );
		}if(!"null".equalsIgnoreCase(arr[2])&&!"".equalsIgnoreCase(arr[2])){
			query.setParameter("endTime1",arr[2]);
		}}
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(TaskBean.class));	
		long size = query.getResultList().size();// 总数据长度
		/** 通过传过来的页码*每页显示条数和总数进行对比 判断第一条数据的取值 **/
		if (firstindex >= size) {
			if (size > pageSize) {
				query.setFirstResult(((int) size / pageSize - 1) * pageSize).setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}
		pr.setResults(query.getResultList());
		pr.setTotalrecord(size);
		return pr;
	}
	/**
	 * 新方法   HasBelong
	 */
	@SuppressWarnings("unchecked")
	@Override
	public PageResult<BpmRuBizInfoBean> findTaskHasBelongList(int pageNum,
			int pageSize, String param,String id,String sortName,String sortOrder) {
		String[] arr=null;
		if(!"".equalsIgnoreCase(param)){
			 arr = param.split("&");
		}
		
		int firstindex = 0;	
		if (pageNum > 0) {
			firstindex = (pageNum - 1) * pageSize; // 从第几条数据开始取数据
		}
//		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		int maxresult = pageSize; // 页大小
		PageResult<BpmRuBizInfoBean> pr = new PageResult<BpmRuBizInfoBean>();
		StringBuffer sb=new StringBuffer();
		sb.append("SELECT" );
		sb.append(" a.SOL_ID_ ," );
		sb.append("a.SERIAL_NUMBER_ ," );
		sb.append("a.BIZ_TITLE_ ," );
		sb.append(" a.URGENCY_ ," );
		sb.append("substr(a.CREATE_TIME_ " );
		sb.append(" FROM" );
		sb.append(" 1 FOR 10) CREATE_TIME_," );
		sb.append(" a.STATE_," );
		sb.append(" c.USER_NAME ," );
		sb.append(" trim(d.PLACE_TIME) PLACE_TIME ," );
		sb.append(" b.PROC_INST_ID_," );
		sb.append(" b.ID_," );
		sb.append(" a.id_ bizid," );
		sb.append("trim(b.END_TIME_) END_TIME_ " );
		sb.append(" FROM" );
		sb.append("    bpm_ru_biz_info a " );
		sb.append("  LEFT JOIN" );
		sb.append("      act_hi_taskinst b " );
		sb.append("    ON b.PROC_INST_ID_ = a.PROC_INST_ID_ " );
		sb.append("  LEFT JOIN" );
		sb.append("       isc_user c " );
		sb.append("    ON a.CREATE_USER_ID_ = c.USER_ID " );
		sb.append("	 inner join  " );
		sb.append("	      biz_doc_info d " );
		sb.append("    on d.BIZ_ID=a.id_ " );
		sb.append("  where" );
		sb.append("     a.dr_='N' "+ " and d.DOC_TYPE like '"+id+"%' and STATE_='2'" );
		if(arr!=null){
			if(!"null".equalsIgnoreCase(arr[0])&&!"".equalsIgnoreCase(arr[0])){
				sb.append(" and a.BIZ_TITLE_ like :bizTitle" );
			}
			if(!"null".equalsIgnoreCase(arr[1])&&!"".equalsIgnoreCase(arr[1])){
				sb.append(" and d.PLACE_TIME>=:endTime" );
			}if(!"null".equalsIgnoreCase(arr[2])&&!"".equalsIgnoreCase(arr[2])){
				sb.append(" and d.PLACE_TIME<=:endTime1"  );
			}}
		sb.append(" GROUP BY" );
		sb.append("    a.id_ " );
		if(StringUtils.isNotEmpty(sortName)){
			sb. append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sb.append(" order by CREATE_TIME_ "+sortOrder);
		}
		Query query  =  em.createNativeQuery(sb.toString());
		if(arr!=null){
		if(!"null".equalsIgnoreCase(arr[0])&&!"".equalsIgnoreCase(arr[0])){
			query.setParameter("bizTitle","%"+arr[0].trim()+"%" );
		}
		if(!"null".equalsIgnoreCase(arr[1])&&!"".equalsIgnoreCase(arr[1])){
			query.setParameter("endTime",arr[1] );
		}if(!"null".equalsIgnoreCase(arr[2])&&!"".equalsIgnoreCase(arr[2])){
			query.setParameter("endTime1",arr[2]);
		}}
		query.unwrap(SQLQuery.class).setResultTransformer(Transformers.aliasToBean(BpmRuBizInfoBean.class));	
		long size = query.getResultList().size();// 总数据长度
		/** 通过传过来的页码*每页显示条数和总数进行对比 判断第一条数据的取值 **/
		if (firstindex >= size) {
			if (size > pageSize) {
				query.setFirstResult(((int) size / pageSize - 1) * pageSize).setMaxResults(maxresult);
			} else {
				query.setFirstResult(0).setMaxResults(maxresult);
			}
		} else {
			query.setFirstResult(firstindex).setMaxResults(maxresult);
		}
		pr.setResults(query.getResultList());
		pr.setTotalrecord(size);
		return pr;
	}

	@SuppressWarnings("unchecked")
	@Override
	public BizDocFolderEntity getBizDocFolderEntity(String catalog_id) {
		StringBuffer sb = new StringBuffer();
		sb.append("select * from biz_doc_folder where catalog_id=:catalog_id");
		Query query = em.createNativeQuery(sb.toString(),BizDocFolderEntity.class);
		query.setParameter("catalog_id", catalog_id);
		BizDocFolderEntity folder=null;
		List<BizDocFolderEntity> list=query.getResultList();
		if(list!=null&&list.size()>0){
			folder=list.get(0);
		}
		return folder;
	}

	@SuppressWarnings("unchecked")
	@Override
	public int getSerialNumber(String tableId) {
		StringBuffer sb = new StringBuffer();
		sb.append("SELECT * from iweb_document where file_status ='0' and enabled = '1' and table_id =:tableId"
				+" order by serial_number desc");
		Query query = em.createNativeQuery(sb.toString(),IWebDocumentEntity.class);
		query.setParameter("tableId", tableId);
		List<IWebDocumentEntity> list=query.getResultList();
		
		int serialNumber = 1;
		if (list != null && list.size() > 0) {
			serialNumber = list.get(0).getSerialNumber() + 1;
		}
		return serialNumber;
	}

	@Override
	public void upload(String tableId, String folderId, String recordId,
		Date date, String fileName, String filePath) {
		// 获取附件的排序号
		int serialNumber =this.getSerialNumber(tableId);
		// 获取当前用户
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		// 保存数据
		IWebDocumentEntity document = new IWebDocumentEntity();
		// 文件编号，物理文件名
		document.setRecordId(recordId);
		// 上传用户，当前用户名
		document.setAuthor(user != null ? user.loginName : "");
		// 上传时间
		document.setFileDate(date);
		// 文件类型
		document.setFileType(fileName.substring(fileName.lastIndexOf(".")));
		// 文件物理路径（到上一级）
		document.setHtmlPath(filePath);
		// 文件名
		document.setFileName(fileName);
		// 是否有效 1：有效
		document.setEnabled("1");
		// 文件状态 0：附件，1：正文
		document.setFileStatus("0");
		// 业务ID 多对一关联
		document.setTableId(tableId);
		// 附件顺序号
		document.setSerialNumber(serialNumber);
		// 是否有流程
		document.setIsprocess("0");
		this.save(document);
		//保存文件信息进入附件表
		//节点ID
		String folder_id_=folderId;
		BizDocInfoRefMediaEntity media=new BizDocInfoRefMediaEntity();
		//上传时间
		media.setUploadTime(date);
		//上传用户
		media.setUploadUserId(user != null ? user.id : "");
		
		media.setShareUserId(user != null ? user.id : "");
		//文件记录名
		media.setFileName(recordId);
		//删除标志，已废弃
		media.setDeleteflag(0);
		//与IWebDocument关联ID
		media.setFileId(document.getId());
		//分享标志
		media.setShare(0);
		//与IWebDocument关联ID
		media.setRelationId(document.getId());
		//节点ID
		media.setFolderId(folder_id_);
		this.save(media);
		System.err.println("iii");
	}
	/**
	 * 方法:查询归档类型文件夹
	 * @param userid
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public List<BizDocInfoTypeEntity> findDocTypeList(){
		StringBuffer sb = new StringBuffer();
		sb.append("select * from biz_doc_info_type "
				+ " where catalog_type='0' and dr='N' order by ts asc");
		Query query = em.createNativeQuery(sb.toString(),BizDocInfoTypeEntity.class);
		return query.getResultList();
	}
	@SuppressWarnings("unchecked")
	@Override
	public List<BizDocInfoTypeEntity> findParentDocInfoList() {
		StringBuffer sb = new StringBuffer();
		sb.append("select * from biz_doc_info_type "
				+ " where catalog_type='1' and dr='N'");
		Query query = em.createNativeQuery(sb.toString(),BizDocInfoTypeEntity.class);
		return query.getResultList();
	}
	
	@SuppressWarnings("unchecked")
	public String doCheckRepat(String folderId,String folderName){
		String id="";
		String sql = "SELECT CATALOG_ID from biz_doc_info_type  where dr='N' and CATALOG_TYPE='0' and CATALOG_NAME=? and PARENT_CATALOG_ID= "
				+"(select PARENT_CATALOG_ID from biz_doc_info_type  where dr='N' and CATALOG_ID=?)";
		Query query = em.createNativeQuery(sql).setParameter(1, folderName).setParameter(2, folderId);
		List<String> list = query.getResultList();
		if(list!=null &&list.size()>0){
			id=list.get(0);
		}
		return id;
	}
	@SuppressWarnings("unchecked")
	public String doCheckDelete(String folderId){
		String id="";
		String sql = "SELECT ID_ from biz_doc_info  where DOC_TYPE=?";
		Query query = em.createNativeQuery(sql).setParameter(1, folderId);
		List<String> list = query.getResultList();
		if(list!=null &&list.size()>0){
			id=list.get(0);
		}
		return id;
	}
	@SuppressWarnings("unchecked")
	public String getDocTypeNum(String folderId){
		String count="";
		String sql = "SELECT count from biz_doc_info_type  where dr='N' and CATALOG_TYPE='0' and CATALOG_ID=?";
		Query query = em.createNativeQuery(sql).setParameter(1, folderId);
		List<String> list = query.getResultList();
		if(list!=null &&list.size()>0){
			count=list.get(0);
		}
		return count;
}
	public void setDocTypeNum(String folderId,String num){
		String sql = "UPDATE biz_doc_info_type A SET A.COUNT = ? WHERE A.catalog_id = ?";
		Query query = em.createNativeQuery(sql).setParameter(1, num).setParameter(2, folderId);
		query.executeUpdate();
	}
	@SuppressWarnings("unchecked")
	public String doCheckName(String folderId,String folderName){
		String id="";
		String sql = "SELECT CATALOG_ID from biz_doc_info_type  where dr='N' and CATALOG_TYPE='0' and CATALOG_NAME=? and PARENT_CATALOG_ID=?";
		Query query = em.createNativeQuery(sql).setParameter(1, folderName).setParameter(2, folderId);
		List<String> list = query.getResultList();
		if(list!=null &&list.size()>0){
			id=list.get(0);
		}
		return id;
	}
	@SuppressWarnings("unchecked")
	public String doCheckDel(String folderId){
		String id="";
		String sql = "SELECT ID_ from biz_doc_info_type  where dr='N' and PARENT_CATALOG_ID=?";
		Query query = em.createNativeQuery(sql).setParameter(1, folderId);
		List<String> list = query.getResultList();
		if(list!=null &&list.size()>0){
			id=list.get(0);
		}
		return id;
	}
	public String findMaxNum(String pId) {
		// TODO Auto-generated method stub
		String sql = "SELECT max(a.CATALOG_ID) from biz_doc_folder a where a.PARENT_CATALOG_ID=:pId";
		Query query = em.createNativeQuery(sql);
		query.setParameter("pId", pId);
		String maxId =  (String) query.getSingleResult();
		if(maxId==null){
			return "000";
		}
		return maxId.substring(pId.length(),maxId.length());
	}
	@SuppressWarnings("unchecked")
	public String doCheckFolderName(String folderId,String folderName,ShiroUser user){
		String id="";
		String sql="";
		BizDocFolderEntity parentEntity=getBizDocFolderEntity(folderId);
		if(parentEntity.getCatalogType()==2){
	       sql = "SELECT CATALOG_ID from biz_doc_folder  where  CATALOG_NAME=? and PARENT_CATALOG_ID=?";
		}else{
		   sql = "SELECT CATALOG_ID from biz_doc_folder  where  CATALOG_NAME=? and PARENT_CATALOG_ID=? and USER_ID='"+user.id+"'";
		}		
		Query query = em.createNativeQuery(sql).setParameter(1, folderName).setParameter(2, folderId);
		List<String> list = query.getResultList();
		if(list!=null &&list.size()>0){
			id=list.get(0);
		}
		return id;
	}
	@SuppressWarnings("unchecked")
	public String doCheckFolderRepat(String folderId,String folderName,ShiroUser user){
		String id="";
		String sql="";
		BizDocFolderEntity parentEntity=getBizDocFolderEntity(folderId);
		if(parentEntity.getCatalogType()==2){
		  sql = "SELECT CATALOG_ID from biz_doc_folder  where  CATALOG_NAME=? and PARENT_CATALOG_ID= "
					+"(select PARENT_CATALOG_ID from biz_doc_folder  where CATALOG_ID=?)";
		}else{
			sql = "SELECT CATALOG_ID from biz_doc_folder  where  CATALOG_NAME=? and PARENT_CATALOG_ID= "
					+"(select PARENT_CATALOG_ID from biz_doc_folder  where CATALOG_ID=?) and USER_ID='"+user.id+"'";
		}
		
		Query query = em.createNativeQuery(sql).setParameter(1, folderName).setParameter(2, folderId);
		List<String> list = query.getResultList();
		if(list!=null &&list.size()>0){
			id=list.get(0);
		}
		return id;
	}
	@SuppressWarnings("unchecked")
	public String doDelFolder(String folderId){
		String id="";
		String sql = "SELECT ID_ from biz_doc_folder  where  PARENT_CATALOG_ID=?";
		Query query = em.createNativeQuery(sql).setParameter(1, folderId);
		List<String> list = query.getResultList();
		if(list!=null &&list.size()>0){
			id=list.get(0);
		}
		return id;
	}
	@SuppressWarnings("unchecked")
	public String doFolderDel(String folderId){
		String id="";
		String sql = "SELECT ID_ from biz_doc_info_ref_media  where FOLDER_ID=?";
		Query query = em.createNativeQuery(sql).setParameter(1, folderId);
		List<String> list = query.getResultList();
		if(list!=null &&list.size()>0){
			id=list.get(0);
		}
		return id;
	}
	public void doDeleteDocInfo(BizDocInfoEntity docinfo) {
		String sql = "delete from biz_doc_info  where biz_id=? and doc_type=?   ";
		Query query = em.createNativeQuery(sql);
		query.setParameter(1, docinfo.getBizId());
		query.setParameter(2, docinfo.getDocType());
		query.executeUpdate();		
}}