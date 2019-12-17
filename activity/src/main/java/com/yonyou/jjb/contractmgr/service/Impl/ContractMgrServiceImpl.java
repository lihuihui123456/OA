package com.yonyou.jjb.contractmgr.service.Impl;

import java.util.LinkedHashMap;

import javax.annotation.Resource;

import org.apache.commons.lang.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Service;

import com.yonyou.jjb.contractmgr.dao.IContractMgrDao;
import com.yonyou.jjb.contractmgr.entity.BizContractEntity;
import com.yonyou.jjb.contractmgr.entity.BpmRuBizInfoBean;
import com.yonyou.jjb.contractmgr.service.IContractMgrService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.dataauth.datarule.entity.DataRuleEnum;
import com.yonyou.cap.isc.dataauth.datarule.entity.SqlParam;
import com.yonyou.cap.isc.dataauth.datarule.service.IDataRuleService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
@Service("contractMgrService")
public class ContractMgrServiceImpl implements IContractMgrService{
	@Resource
	private IContractMgrDao contractMgrDao;
	@Resource
	IDataRuleService dataRuleService;
	/**
	 * 分页合同管理信息并排序
	 */
	@Override
	public PageResult<BizContractEntity> getAllData(int pageNum, int pageSize,String modCode) {
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		StringBuffer wheresql = new StringBuffer();
	    wheresql.append(" dr='N' ");
	 if(!"办领导".equals(user.getDeptName())){
		 wheresql.append("and data_user_id='"+user.getId()+"'"); 
	 }	
		orderby.put("createTime_", "desc");
		return contractMgrDao.getPageData(BizContractEntity.class, pageNum, pageSize,wheresql.toString(), null,orderby);
	}

	/**
	 * 模糊查询合同信息 实现分页
	 */
	@Override
	public PageResult<BizContractEntity> getAllData(int pageNum, int pageSize, String searchInfo,String modCode) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		StringBuffer wheresql = new StringBuffer();
		wheresql.append( " title_ like '%" + searchInfo + "%' and dr='N' ");
		if(!"办领导".equals(user.getDeptName())){
			 wheresql.append("and data_user_id='"+user.getId()+"'"); 
		}
		LinkedHashMap<String, String> orderby = new LinkedHashMap<String, String>();
		orderby.put("createTime_", "desc");

		return contractMgrDao.getPageData(BizContractEntity.class, pageNum, pageSize, wheresql.toString(), null, orderby);
	}

	/**
	 * 删除方法
	 */
	@Override
	public void doDelLeaveInfo(String userid) {	
		BizContractEntity bizContractEntity=contractMgrDao.findEntityByPK(BizContractEntity.class, userid);
		bizContractEntity.setDr("Y");
		contractMgrDao.update(bizContractEntity);
	}

	/**
	 * 通过id获取一条记录
	 */
	@Override
	public BizContractEntity findLeaveInfoById(String id) {
		return contractMgrDao.findEntityByPK(BizContractEntity.class, id);
	}
	
	/**
	 * 更新方法
	 */
	@Override
	public void doUpdateContractInfo(BizContractEntity contractEntity) {
		contractMgrDao.update(contractEntity);
	}
	
	
	
	
	
	
	
	
	public PageResult<BpmRuBizInfoBean> findBpmRuBizInfoBeanBySolId(String modCode,int pageNum,
			int pageSize, String userId, String solId, String title,String sortName,String sortOrder) {
		//String modCode ="";
		SqlParam sqlParam = dataRuleService.createSqlParam(modCode,"a",DataRuleEnum.DATA_ORG_ID);
		StringBuffer sb = new StringBuffer();
		sb.append("select * from ( ");
		sb.append("select a.ID_,a.SOL_ID_,a.BIZ_TITLE_,c.xmmc xmmc,a.TABLE_NAME_,a.KEY_,a.PRO_DEF_ID_,a.PROC_INST_ID_,a.SERIAL_NUMBER_,trim(a.ARCHIVE_STATE_) ARCHIVE_STATE_,a.ARCHIVE_ID_,a.CREATE_USER_ID_,a.CREATE_DEPT_ID_,");
		sb.append("trim(a.UPDATE_TIME_) UPDATE_TIME_,a.TS_,trim(a.DR_) DR_,a.REMARK_,a.TENANT_ID,a.BIZ_TYPE_,a.SEND_STATE_,trim(a.TIME_LIMIT_) TIME_LIMIT_,a.BIZ_DOC_NUM,a.DATA_USER_ID,a.DATA_DEPT_CODE,a.DATA_ORG_ID,a.DATA_TENANT_ID,"
				+ "a.URGENCY_,a.STATE_,trim(a.CREATE_TIME_) CREATE_TIME_ ,b.id_ TASK_ID from bpm_ru_biz_info a ");
		sb.append(" left join act_hi_taskinst b on a.proc_inst_id_=b.PROC_INST_ID_  ");
		sb.append(" left join fd_htgl c on a.id_=c.id  ");

		sb.append("where  1=1 ");
		
		if (StringUtils.isNotBlank(sqlParam.getParam())&& sqlParam.isHasDataRole()) {
			sb.append(sqlParam.getParam());
		}else{
			sb.append(" and CREATE_USER_ID_ ='"+ userId +"' ");
		}
		sb.append(" and SOL_ID_ = '"+ solId +"' AND DR_ = 'N' and STATE_!='3' AND BIZ_TITLE_ like '%"+ title.trim()+"%' ");
		sb.append(" order by CREATE_TIME_ "+sortOrder);
		sb.append(" ) o group by o.id_ ");
		if(StringUtils.isNotEmpty(sortName)){
			sb.append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sb.append(" order by CREATE_TIME_ "+sortOrder);
		}
		return contractMgrDao.getPageData(BpmRuBizInfoBean.class, pageNum, pageSize, sb.toString() );
	}
	public PageResult<BpmRuBizInfoBean> findBpmRuBizInfoBeanBySolId(String modCode,int pageNum,
			int pageSize, String userId, String solId, String title,String state,String sortName,String sortOrder) {
		//String modCode ="";
		SqlParam sqlParam = dataRuleService.createSqlParam(modCode,"a",DataRuleEnum.DATA_ORG_ID);
		StringBuffer sb = new StringBuffer();
		sb.append("select * from ( ");
		sb.append("select a.ID_,a.SOL_ID_,a.BIZ_TITLE_,c.xmmc xmmc,a.TABLE_NAME_,a.KEY_,a.PRO_DEF_ID_,a.PROC_INST_ID_,a.SERIAL_NUMBER_,trim(a.ARCHIVE_STATE_) ARCHIVE_STATE_,a.ARCHIVE_ID_,a.CREATE_USER_ID_,a.CREATE_DEPT_ID_,");
		sb.append("trim(a.UPDATE_TIME_) UPDATE_TIME_,a.TS_,trim(a.DR_) DR_,a.REMARK_,a.TENANT_ID,a.BIZ_TYPE_,a.SEND_STATE_,trim(a.TIME_LIMIT_) TIME_LIMIT_,a.BIZ_DOC_NUM,a.DATA_USER_ID,a.DATA_DEPT_CODE,a.DATA_ORG_ID,a.DATA_TENANT_ID,"
				+ "a.URGENCY_,a.STATE_,trim(a.CREATE_TIME_) CREATE_TIME_ ,b.id_ TASK_ID from bpm_ru_biz_info a ");
		sb.append(" left join act_hi_taskinst b on a.proc_inst_id_=b.PROC_INST_ID_  ");
		sb.append(" left join fd_htgl c on a.id_=c.id  ");
		sb.append("where 1=1 ");
		if (StringUtils.isNotBlank(sqlParam.getParam())&& sqlParam.isHasDataRole()) {
			sb.append(sqlParam.getParam());
		}else{
			sb.append(" and CREATE_USER_ID_ ='"+ userId +"' ");
		}
		sb.append(" and SOL_ID_ = '"+ solId +"' AND DR_ = 'N'  AND BIZ_TITLE_ like '%"+ title.trim()+"%' ");
		if("ready".equals(state)){
			sb.append( " AND STATE_ = 0  ");
		}else if("already".equals(state)){
			sb.append( " AND STATE_ in (1,2,4) ");
		}
		sb.append(" order by CREATE_TIME_ "+sortOrder);
		sb.append(" ) o group by o.id_ ");
		if(StringUtils.isNotEmpty(sortName)){
			sb.append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sb.append(" order by CREATE_TIME_ "+sortOrder);
		}
		return contractMgrDao.getPageData(BpmRuBizInfoBean.class, pageNum, pageSize, sb.toString() );
	}
	public PageResult<BpmRuBizInfoBean> findBpmRuBizInfoBeanByQueryParams(
			String modCode,int pageNum, int pageSize, String userId, String solId,
			String queryParams,String sortName,String sortOrder) {
		//String modCode ="";
		SqlParam sqlParam = dataRuleService.createSqlParam(modCode,"a",DataRuleEnum.DATA_ORG_ID);
		StringBuilder sql = new StringBuilder();
		sql.append("select * from ( ");
		sql.append("select a.ID_,a.SOL_ID_,a.BIZ_TITLE_,c.xmmc xmmc,a.TABLE_NAME_,a.KEY_,a.PRO_DEF_ID_,a.PROC_INST_ID_,a.SERIAL_NUMBER_,trim(a.ARCHIVE_STATE_) ARCHIVE_STATE_,a.ARCHIVE_ID_,a.CREATE_USER_ID_,a.CREATE_DEPT_ID_,");
		sql.append("trim(a.UPDATE_TIME_) UPDATE_TIME_,a.TS_,trim(a.DR_) DR_,a.REMARK_,a.TENANT_ID,a.BIZ_TYPE_,a.SEND_STATE_,trim(a.TIME_LIMIT_) TIME_LIMIT_,a.BIZ_DOC_NUM,a.DATA_USER_ID,a.DATA_DEPT_CODE,a.DATA_ORG_ID,a.DATA_TENANT_ID,"
				+ "a.URGENCY_,a.STATE_,trim(a.CREATE_TIME_) CREATE_TIME_ ,b.id_ TASK_ID  from bpm_ru_biz_info a ");
		sql.append(" left join act_hi_taskinst b on a.proc_inst_id_=b.PROC_INST_ID_  ");
		sql.append(" left join fd_htgl c on a.id_=c.id  ");
		sql.append("where 1=1 AND ");

		if(queryParams != null) {
			String[] paramsArr = queryParams.split("&");
			if(paramsArr != null && paramsArr.length > 0) {
				String[] keyValueArr;
				boolean allStateBoo = true; //如果没查询条件，则查询state ！=3 ；
				for (String keyValue : paramsArr) {
					keyValueArr = keyValue.split("=");
					if(keyValueArr.length == 2) {
						String key = keyValueArr[0];
						String value = keyValueArr[1];
						if(StringUtils.isNotBlank(key)&&StringUtils.isNotBlank(value)) {
							if("bizTitle_".equals(key)){
								sql.append("BIZ_TITLE_ like '%" + value.trim() + "%' AND ");
							}else if("URGENCY_".equals(key)){
								sql.append("URGENCY_ = '" + value + "' AND ");
							}else if("STATE_".equals(key)){
								allStateBoo = false;
								sql.append("STATE_ = '" + value + "' AND ");
							}else if("startTime".equals(key)){
								sql.append(" CREATE_TIME_ >= '"+value+"' AND ");
							}else if("endTime".equals(key)){
								sql.append(" CREATE_TIME_ <= '"+value+"' AND ");
							}else if("STATE_".equals(key)){
								sql.append("STATE_ = '" + value + "' AND ");
							}
						}
					}
				}
				if(allStateBoo){
					sql.append(" STATE_ != '3'  AND ");
				}
			}
		}
		
		sql.append(" SOL_ID_ = '"+ solId +"' AND DR_ = 'N'  ");
		if (StringUtils.isNotBlank(sqlParam.getParam())&& sqlParam.isHasDataRole()) {
			sql.append(sqlParam.getParam());
		}else{
			sql.append(" and CREATE_USER_ID_ ='"+ userId +"' ");
		}
		sql.append(" order by CREATE_TIME_ "+sortOrder);
		sql.append(" ) o group by o.id_ ");
		if(StringUtils.isNotEmpty(sortName)){
			sql.append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sql.append(" order by CREATE_TIME_ "+sortOrder);
		}
		return contractMgrDao.getPageData(BpmRuBizInfoBean.class, pageNum, 
				pageSize, sql.toString() );
	}
	public PageResult<BpmRuBizInfoBean> findBpmRuBizInfoBeanBySolId(String modCode, int pageNum,
			int pageSize, String userId, String solId,String sortName,String sortOrder) {
		//String modCode ="";
		SqlParam sqlParam = dataRuleService.createSqlParam(modCode,"a",DataRuleEnum.DATA_ORG_ID);
		StringBuffer sb = new StringBuffer();
		sb.append("select * from ( ");
		sb.append("select a.ID_,a.SOL_ID_,a.BIZ_TITLE_,c.xmmc xmmc,a.TABLE_NAME_,a.KEY_,a.PRO_DEF_ID_,a.PROC_INST_ID_,a.SERIAL_NUMBER_,trim(a.ARCHIVE_STATE_) ARCHIVE_STATE_,a.ARCHIVE_ID_,a.CREATE_USER_ID_,a.CREATE_DEPT_ID_,");
		sb.append("trim(a.UPDATE_TIME_) UPDATE_TIME_,a.TS_,trim(a.DR_) DR_,a.REMARK_,a.TENANT_ID,a.BIZ_TYPE_,a.SEND_STATE_,trim(a.TIME_LIMIT_) TIME_LIMIT_,a.BIZ_DOC_NUM,a.DATA_USER_ID,a.DATA_DEPT_CODE,a.DATA_ORG_ID,a.DATA_TENANT_ID,"
				+ "a.URGENCY_,a.STATE_,trim(a.CREATE_TIME_) CREATE_TIME_ , b.id_ TASK_ID　from bpm_ru_biz_info a ");
		sb.append(" left join act_hi_taskinst b on a.proc_inst_id_=b.PROC_INST_ID_  ");
		sb.append(" left join fd_htgl c on a.id_=c.id  ");
		sb.append("where 1=1 ");
		if (StringUtils.isNotBlank(sqlParam.getParam())&& sqlParam.isHasDataRole()) {
			sb.append(sqlParam.getParam());
		}else{
			sb.append(" and CREATE_USER_ID_ ='"+ userId +"' ");
		}
		sb.append(" and SOL_ID_ = '"+ solId +"' AND DR_ = 'N' and STATE_!='3' ");
		sb.append(" order by CREATE_TIME_ "+sortOrder);
		sb.append(" ) o group by o.id_ ");
		if(StringUtils.isNotEmpty(sortName)){
			sb.append(" order by CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sb.append(" order by CREATE_TIME_ "+sortOrder);
		}
		return contractMgrDao.getPageData(BpmRuBizInfoBean.class, pageNum, pageSize, sb.toString() );
	}
}
