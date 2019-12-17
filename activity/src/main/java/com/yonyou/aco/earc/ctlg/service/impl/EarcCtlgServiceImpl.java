package com.yonyou.aco.earc.ctlg.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.earc.ctlg.dao.IEarcCtlgDao;
import com.yonyou.aco.earc.ctlg.entity.EarcCtlgEntity;
import com.yonyou.aco.earc.ctlg.entity.EarcCtlgTreeBean;
import com.yonyou.aco.earc.ctlg.service.IEarcCtlgService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;


/**
 * 
 * TODO: 档案目录管理service实现类
 * TODO: 填写Class详细说明 
 * 历史记录:
 * Date, Author, Descriptions
 * --------------------------------------------------------- 
 * @Date    2017年4月18日
 * @author  贺国栋
 * @since   1.0.0
 */
@Service("earcCtlgService")
public class EarcCtlgServiceImpl implements IEarcCtlgService {


	@Resource IEarcCtlgDao earcCtlgDao;

	@Override
	public List<EarcCtlgTreeBean> findCtlgInfoByUserId(String userId) {
		return earcCtlgDao.findCtlgInfoByUserId(userId);
	}

	@Override
	public void doAddCtlgInfo(EarcCtlgEntity acEntity) {
		earcCtlgDao.save(acEntity);
	}

	@Override
	public PageResult<EarcCtlgEntity> findArcCtlgDataByCtlgId(int pageNum,
			int pageSize, String ctlgId, String ctlgName, String sortName,
			String sortOrder) {
		
		StringBuilder sb = new StringBuilder();
		sb.append("SELECT ID_,EARC_CTLG_NAME,EARC_CTLG_NBR,CREATE_USER_NAME,trim(CREATE_TIME) CREATE_TIME,"
				+ "PARENT_ID,trim(DR) DR,DATA_ORG_ID,DATA_DEPT_ID,DATA_DEPT_CODE,DATA_USER_ID,"
				+ "TENANT_ID,TS FROM earc_ctlg_info WHERE DR='N'");
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		sb.append("  AND DATA_USER_ID= '"+user.getUserId()+"' AND ID_!='0' ");
		if(StringUtils.isNotBlank(ctlgId)){
			sb.append(" AND PARENT_ID = '"+ctlgId+"'");
		}
		if(StringUtils.isNotBlank(ctlgName)){
			sb.append(" AND EARC_CTLG_NAME LIKE '%"+ctlgName+"%'");
		}
		if(StringUtils.isNotBlank(sortName)&&StringUtils.isNotBlank(sortOrder)){
			sb.append(" ORDER BY CONVERT("+ sortName +" USING gbk) "+sortOrder);
		}else{
			sb.append(" ORDER BY ORDER_BY+0 ASC");
		}
		try {
			return earcCtlgDao.getPageData(EarcCtlgEntity.class, pageNum, pageSize, sb.toString());
		} catch (Exception e) {
			e.printStackTrace();
			 return earcCtlgDao.getPageData(EarcCtlgEntity.class, pageNum, pageSize, sb.toString());
		}
		
	}

	@Override
	public String isCtlgParent(String Id) {
		
		return earcCtlgDao.isCtlgParent(Id);
	}

	@Override
	public String doDelCtlgDataById(String Id) {
		return earcCtlgDao.doDelCtlgDataById(Id);
	}

	@Override
	public EarcCtlgEntity findCtlgInfoByCtlgId(String ctlgId) {
		return earcCtlgDao.findCtlgInfoByCtlgId(ctlgId);
	}

	@Override
	public void doUpdateCtlgInfo(EarcCtlgEntity acEntity) {
		earcCtlgDao.update(acEntity);
	}

	@Override
	public EarcCtlgEntity findCtlgInfoByPk(String ctlgId) {
		return earcCtlgDao.findEntityByPK(EarcCtlgEntity.class, ctlgId);
	}

	@Override
	public String getMaxOrderBy(EarcCtlgEntity acEntity) {
		return earcCtlgDao.getMaxOrderBy(acEntity);
	}
	
}
