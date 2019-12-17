package com.yonyou.aco.delegate.service.Impl;

import java.io.UnsupportedEncodingException;
import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;
import org.apache.commons.lang.StringUtils;

import com.yonyou.aco.delegate.dao.IDelegateDao;
import com.yonyou.aco.delegate.service.IDelegateService;
import com.yonyou.cap.bpm.entity.BizRuDelegateEntity;
import com.yonyou.cap.bpm.entity.BizSolBean;
import com.yonyou.cap.bpm.entity.BizSolRelationEntity;
import com.yonyou.cap.common.util.PageResult;
@Service("delegateService")
public class DelegateServiceImpl implements IDelegateService{
	@Resource
	IDelegateDao delegateDao;
	public PageResult<BizRuDelegateEntity> findDelegateList(int pageNum, int pageSize,String title,String sortName,String sortOrder,String userid){		
		StringBuilder wheresql = new StringBuilder();
		wheresql.append(" (TRUST_USER_ID='"+userid+"' or CREATE_USER_ID_='"+userid+"' or USER_ID='"+userid+"')" );
		if (StringUtils.isNotEmpty(title)){
			try {
				title = new String(title.getBytes("iso-8859-1"), "utf-8");
				wheresql.append(" and (user_name like '%"+title+"%' or trust_user_name like '%"+title+"%')");
			} catch (UnsupportedEncodingException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}		
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		if(StringUtils.isNotEmpty(sortName)){
			orderby.put(sortName, sortOrder);
		}else{
			orderby.put("ts", sortOrder);
		}
		return delegateDao.getPageData(BizRuDelegateEntity.class, pageNum, pageSize,
				wheresql.toString(), null, orderby);	
	}
	public PageResult<BizSolBean> findSolList(int pageNum, int pageSize,String userid,String title){
		return delegateDao.findSolList(pageNum,pageSize,userid,title);
	}
	public void doAddDelegate(BizRuDelegateEntity delegateEntity){
		delegateDao.save(delegateEntity);
	}
	public void doUpdateDelegate(BizRuDelegateEntity delegateEntity){
		delegateDao.update(delegateEntity);
	}
	public void doAddSolRelation(BizSolRelationEntity solRelationEntity){
		delegateDao.save(solRelationEntity);
	}
	public void doDelDelegate(String[] ids,String[] delegates){
		for (int i = 0; i < ids.length; i++){
			delegateDao.delete(BizRuDelegateEntity.class, ids[i]);
			List<BizSolBean> list=delegateDao.findSolRelations(delegates[i]);
			for(int j=0;j<list.size();j++){
				delegateDao.delete(BizSolRelationEntity.class, list.get(j).getId_());	
			}			
		}
	}
	public List<BizSolBean> findSolRelations(String delegateId){
		return delegateDao.findSolRelations(delegateId);
	}
	public BizRuDelegateEntity findBizRuDelegateEntityById(String id){
		return delegateDao.findEntityByPK(BizRuDelegateEntity.class, id);
	}
	public void doDelete(String id){
		delegateDao.delete(BizSolRelationEntity.class, id);
	}
}
