//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcPubInfoServiceImpl-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.otherarc.service.impl;

import java.util.List;

import javax.annotation.Resource;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.arc.otherarc.dao.IArcPubInfoDao;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoBean;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.otherarc.service.IArcPubInfoService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * <p>
 * 概述：业务模块—其它档案管理功能接口实现类
 * <p>
 * 功能：其它档案管理功能实现类
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-21
 * <p>
 * 类调用特殊情况：无
 */
@Service("arcPubInfoService")
public class ArcPubInfoServiceImpl implements IArcPubInfoService {
	@Resource
	IArcPubInfoDao arcPubInfoDao;
	@Override
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntityList(int pageNum,
			int pageSize, String arcName) {
		return arcPubInfoDao.getPageData(ArcPubInfoEntity.class, pageNum,pageSize," o.dr='N' AND o.arcName=?  ORDER BY o.regTime DESC ", new Object[]{arcName}, null);
	}
	@Override
	public ArcPubInfoEntity findByArcName(String arcName) {
		List<ArcPubInfoEntity> list = arcPubInfoDao.getListBySql(ArcPubInfoEntity.class, " o.dr='N' AND o.arcName=?  ORDER BY o.regTime DESC ", new Object[]{arcName}, null);
		if(list!=null&&list.size()>0){
			return list.get(0);
		}
		return null;
	}
	
	@Override
	public void addArcPubInfo(ArcPubInfoEntity arcPubInfoEntity) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			arcPubInfoEntity.setDataDeptCode(user.getDeptCode());
			arcPubInfoEntity.setDataDeptId(user.getDeptId());
			arcPubInfoEntity.setDataUserId(user.getUserId());
			arcPubInfoEntity.setDataOrgId(user.getOrgid());
			arcPubInfoDao.save(arcPubInfoEntity);
		}
	}

	@Override
	public void deleteArcPubInfo(String id) {		
		arcPubInfoDao.delete(ArcPubInfoEntity.class, id);
	}

	@Override
	public ArcPubInfoEntity selectPubInfoEntityById(String arcId) {
		return arcPubInfoDao.selectArcPubInfoEntityByArcId(arcId);
	}

	@Override
	public void updatePubInfoSumm(ArcPubInfoEntity arcPubInfoEntity) {
		arcPubInfoDao.update(arcPubInfoEntity);
	}

	@Override
	public String doUpdateFileStartByArcId(String arcId,ShiroUser user) {
		String result="true";
		if(StringUtils.isEmpty(arcId)){
			result="false";
		}else{
			arcPubInfoDao.doUpdateFileStartByArcId(arcId,user);
		}
		return result;
	}

	@Override
	public String doAddFileUpdateFileStartByArcId(String arcId) {
		String result="true";
		if(StringUtils.isEmpty(arcId)){
			result="false";
		}else{
			arcPubInfoDao.doAddFileUpdateFileStartByArcId(arcId);
		}
		return result;
	}

	@Override
	public String doDelArcInfoByArcId(String arcId) {
		String result="true";
		if(StringUtils.isEmpty(arcId)){
			result="false";
		}else{
			arcPubInfoDao.doDelArcInfoByArcId(arcId);
		}
		return result;
	}

	@Override
	public String doInvArcInfoByArcId(String arcId) {
		String result="true";
		if(StringUtils.isEmpty(arcId)){
			result="false";
		}else{
			arcPubInfoDao.doInvArcInfoByArcId(arcId);
		}
		return result;
	}

	@Override
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntityList(int pageNum,
			int pageSize,String arcName,String startTime,String endTime) {
		return arcPubInfoDao.pageArcPubInfoEntityList(pageNum, pageSize,arcName,startTime,endTime);
	}
	@Override
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntity(int pageNum,
			int pageSize, String arcName,String fileUser,String fileDept, String startTime, String endTime,String modCode) {
		return arcPubInfoDao.pageArcPubInfoEntity(pageNum, pageSize, arcName,fileUser,fileDept, startTime, endTime,modCode);
	}
	/**
	 * @add by zhang duoyi 2017.01.17
	 * 
	 */
	@Override
	public void doHuanyuanByArcId(String arcId) {
		arcPubInfoDao.doHuanyuanByArcId(arcId);
	}
	/* (non-Javadoc)
	 * @see com.yonyou.aco.arc.otherarc.service.IArcPubInfoService#pageArcPubInfoEntity(int, int, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String, java.lang.String)
	 */
	@Override
	public PageResult<ArcPubInfoEntity> pageArcPubInfoEntity(int pageNum,
			int pageSize, String arcName, String fileUser, String fileDept,
			String arcType, String startTime, String endTime, String modCode) {
		return arcPubInfoDao.pageArcPubInfoEntity(pageNum, pageSize, arcName,fileUser,fileDept, startTime, endTime,arcType,modCode);
	}
	@Override
	public PageResult<ArcPubInfoBean> pageArcPubInfoEntity(int pageNum,
			int pageSize, String arcName, String fileUser, String fileDept,
			String arcType, String startTime, String endTime, String modCode,
			String sortName, String sortOrder) {
		return arcPubInfoDao.pageArcPubInfoEntity(pageNum, pageSize, arcName,fileUser,fileDept, startTime, endTime,arcType,modCode,sortName,sortOrder);

	}

}
