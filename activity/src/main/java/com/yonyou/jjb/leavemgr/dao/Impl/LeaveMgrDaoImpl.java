package com.yonyou.jjb.leavemgr.dao.Impl;

import java.util.LinkedHashMap;
import java.util.List;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Repository;

import com.yonyou.cap.common.base.impl.BaseDao;
import com.yonyou.cap.isc.dataauth.datarule.entity.DataRuleEnum;
import com.yonyou.cap.isc.dataauth.datarule.entity.SqlParam;
import com.yonyou.cap.isc.dataauth.datarule.service.IDataRuleService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.jjb.leavemgr.dao.ILeaveMgrDao;
import com.yonyou.jjb.leavemgr.entity.BizLeaveBean;
import com.yonyou.jjb.leavemgr.entity.BizLeaveEntity;
@Repository("leaveMgrDao")
public class LeaveMgrDaoImpl extends BaseDao implements ILeaveMgrDao{
	@Resource
	IDataRuleService dataRuleService;
	public List<BizLeaveEntity> findAllLeaveInfo(String sql,String modCode) {
		StringBuffer wheresql = new StringBuffer();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		wheresql.append(" dr='N'");
		 SqlParam sqlx = dataRuleService.createSqlParam(modCode,"a",DataRuleEnum.DATA_ORG_ID);
			if(sqlx.isHasDataRole()){
				if(!sqlx.isSql()){
					wheresql.append(sqlx.getParam());
				}
			}else{
				wheresql.append(" and 1=1 ");
			}
			wheresql.append(" and (state='0' or data_user_id='"+user.getId()+"')");
		if(!"".equals(sql)){
			wheresql.append(sql);
		}
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put("ts", "desc");
		List<BizLeaveEntity> list=null;
		list=getListBySql(BizLeaveEntity.class,wheresql.toString(),null,orderby);
		return list;
	}
	@Override
	public List<BizLeaveBean> findAllLeaveBeanInfo(String sql, String modCode) {
		StringBuffer wheresql = new StringBuffer();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		wheresql.append(" dr='N'");
		 SqlParam sqlx = dataRuleService.createSqlParam(modCode,"a",DataRuleEnum.DATA_ORG_ID);
			if(sqlx.isHasDataRole()){
				if(!sqlx.isSql()){
					wheresql.append(sqlx.getParam());
				}
			}else{
				wheresql.append(" and 1=1 ");
			}
			wheresql.append(" and (state='0' or data_user_id='"+user.getId()+"')");
		if(!"".equals(sql)){
			wheresql.append(sql);
		}
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put("ts", "desc");
		List<BizLeaveBean> list=null;
		list=getListBySql(BizLeaveBean.class,wheresql.toString(),null,orderby);
		return list;
	}
}
