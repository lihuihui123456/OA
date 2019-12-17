package com.yonyou.aco.leaddesktop.service.impl;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Service;

import com.yonyou.aco.leaddesktop.dao.LeadDeskTopDao;
import com.yonyou.aco.leaddesktop.entity.LeadDktpMenuBean;
import com.yonyou.aco.leaddesktop.entity.LeadDktpMenuEntity;
import com.yonyou.aco.leaddesktop.entity.LeadDktpYjEntity;
import com.yonyou.aco.leaddesktop.service.LeadDeskTopService;
import com.yonyou.cap.bpm.entity.BizGwCircularsEntity;
import com.yonyou.cap.bpm.entity.DeskTaskBean;
import com.yonyou.cap.isc.adapter.IIscModuleAdapter;
import com.yonyou.cap.isc.menu.entity.Module;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
@Service("LeadDeskTopService")
public class LeadDeskTopServiceImpl implements LeadDeskTopService{
	@Resource
	IIscModuleAdapter module;
	@Resource
	LeadDeskTopDao dao;
	@Override
	public List<LeadDktpMenuBean> getVirtualMenu(ShiroUser user) throws Exception {
			List<LeadDktpMenuBean> reList=new ArrayList<LeadDktpMenuBean>();
			List<Module> list=module.findModulesByUserId(user.getUserId(), user.getUserId(), "N","8a81595755e866880155e8ec40050003");
			for(int i=0;i<list.size();i++){
				Module module=list.get(i);
				LeadDktpMenuBean bean=new LeadDktpMenuBean();
				bean.setModId(module.getModId());
				bean.setModName(module.getModName());
				bean.setModUrl(module.getModUrl());
				bean.setIsRoot(module.getIsRoot());
				bean.setIsVrtlNode(module.getIsVrtlNode());
				bean.setModCode(module.getModCode());
				bean.setSort(module.getSort());
				bean.setParentModId(module.getParentModId());
				bean.setModIcon("");
				reList.add(bean);
			}
		return reList;
	}

	@Override
	public List<LeadDktpMenuBean> getNonVirtualMenu(ShiroUser user) throws Exception {
		List<Module> list=module.findModulesByUserId(user.getUserId(), user.getUserId(), "Y","8a81595755e866880155e8ec40050003");
		List<LeadDktpMenuBean> reList=new ArrayList<LeadDktpMenuBean>();
		for(int i=0;i<list.size();i++){
			Module module=list.get(i);
			LeadDktpMenuBean bean=new LeadDktpMenuBean();
			bean.setModId(module.getModId());
			bean.setModName(module.getModName());
			bean.setModUrl(module.getModUrl());
			bean.setIsRoot(module.getIsRoot());
			bean.setIsVrtlNode(module.getIsVrtlNode());
			bean.setModCode(module.getModCode());
			bean.setSort(module.getSort());
			bean.setParentModId(module.getParentModId());
//			String isChecked=dao.isChecked(module.getModId());
//			bean.setIsChecked(isChecked);
			bean.setModIcon("");
			reList.add(bean);
		}
		return reList;
	}

	@Override
	public void addCustomMenu(String modId) throws Exception {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		Module module=dao.getModuleById(modId);
		LeadDktpMenuEntity entity=new LeadDktpMenuEntity();
		entity.setModId(modId);
		entity.setModName(module.getModName());
		entity.setModUrl(module.getModUrl());
		entity.setUserId(user.getUserId());
		dao.saveLeadDktpEntity(entity);
	}

	@Override
	public void removeCustomMenu(String modId,ShiroUser user) throws Exception {
		dao.removeCustomMenu(modId,user);
	}

	@Override
	public void updateCustomMenu(String modIds,ShiroUser user) throws Exception {
		//先批量删除
		dao.removeAll(user);
		//新增
		String[] modId=modIds.split(",");
		for(int i=0;i<modId.length;i++){
			this.addCustomMenu(modId[i]);
		}
	}

	@Override
	public List<LeadDktpMenuEntity> getChecked(ShiroUser user) throws Exception {
		return dao.getChecked(user);
	}

	@Override
	public LeadDktpYjEntity findYj(String clyj,ShiroUser user) throws Exception {
		return dao.findYj(clyj,user);
	}

	@Override
	public void updateCount(LeadDktpYjEntity leader) throws Exception {
		dao.update(leader);
	}

	@Override
	public void addComment(LeadDktpYjEntity leader) throws Exception {
		dao.save(leader);
	}

	@Override
	public List<LeadDktpYjEntity> findAllComment(String userId)
			throws Exception {
		return dao.findAllComment(userId);
	}
	public List<DeskTaskBean> findDeskTaskList(String bizid){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		String userid = user.id;// 当前用户
		return dao.findDeskTaskList(bizid, userid);
	}
	public String findActTypeByActId(String actId){		
		   return dao.findActTypeByActId(actId);
	}
	public String findCirculate(String ids){
		String flag="0";
		String id="";
		String[] reviewIds=null;
		if(ids!=null&&!"".equals(ids)){
			reviewIds=ids.split(",");
			for(int i=0;i<reviewIds.length;i++){
				id=reviewIds[i];
				BizGwCircularsEntity bizcir =dao.findEntityByPK(BizGwCircularsEntity.class, id);
				bizcir.setIsread("1");
				bizcir.setView_time(new Date());
				dao.update(bizcir);
			}
		}				
		return flag;
	}
}
