package com.yonyou.aco.material.web;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.material.entity.BizMaterialApplyQuery;
import com.yonyou.aco.material.entity.BizMaterialBean;
import com.yonyou.aco.material.entity.BizMaterialListBean;
import com.yonyou.aco.material.entity.BizMaterialStockDetailEntity;
import com.yonyou.aco.material.entity.BizMaterialStockEntity;
import com.yonyou.aco.material.entity.BizMaterialStorageEntity;
import com.yonyou.aco.material.service.IBizMaterialService;
import com.yonyou.aco.material.service.IBizMaterialStockService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.entity.Org;
import com.yonyou.cap.isc.org.service.IOrgService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.service.IUserService;

/**
 * 
 * <p>概述：物资领用控制层
 * <p>功能：物资领用控制层
 * <p>作者：贺国栋
 * <p>创建时间：2016-08-03
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/bizMaterialApplyController")
public class BizMaterialApplyController {
	@Resource
	IBizMaterialService iBizMaterialService;
	
	@Resource
	IBizMaterialStockService iBizMaterialStockService;
	
	@Resource
	IOrgService iOrgService;
	

	@Resource
	IUserService iUserService;

	private final Logger logger = LoggerFactory.getLogger(this.getClass());

	
	
	/**
	 * TODO: 跳转到申请列表页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/applyList")
	public String applyList() {
		return "/aco/material/apply-list";
	}
	
	/**
	 * TODO: 跳转到申请列表页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/allApplyList")
	public String allApplyList() {
		return "/aco/material/all-apply-list";
	}
	
	@RequestMapping("/tab")
	public ModelAndView tab(
			@RequestParam(value="action") String action,
			@RequestParam(value="id",defaultValue="") String id){
		ModelAndView mv = new ModelAndView();
		String iframeUrl;
		String url = "/aco/material/tab-index";
		if("new".equals(action)){
			iframeUrl = "bizMaterialApplyController/doAddApply";
		}else if("edit".equals(action)){
			iframeUrl = "bizMaterialApplyController/doEditApply/"+id;
		}else{
			iframeUrl = "bizMaterialApplyController/viewApply/"+id;
			url = "/aco/material/tab-view";
		}
		mv.addObject("applyid", id);//把id传到页面，用来页面找到父iframe
		mv.addObject("action", action);
		mv.addObject("url", iframeUrl);
		mv.setViewName(url);
		return mv;
	}
	
	
	/**
	 * TODO: 跳转到填写出库单
	 * 
	 * @return newApply
	 */
	@RequestMapping(value = "/doAddApply")
	public ModelAndView doAddApply() {
		ModelAndView mv = new ModelAndView();
		//获取当前登录人信息
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		/*// 登录人部门id
		String orgId = "";
		//登录人部门名称
		String orgName = "";
		String userId = "";
		String userName = "";*/
		if(null != user){
			//根据登录人id 获取登录部门信息
			/*org = iOrgService.findOrgByUserId(user.getUserId());
			if (org != null) {
				orgName = org.getOrgName();
				orgId = org.getOrgId();
				orgName = user.orgName;
				orgId = user.deptId;*/
			/*}*/
			String orgId = user.orgid;
			String orgName = user.orgName;
			String userId = user.getUserId();
			String userName = user.getName();
			mv.addObject("time", getTime());
			mv.addObject("userId", userId);
			mv.addObject("userName", userName);
			mv.addObject("orgId", orgId);
			mv.addObject("orgName", orgName);
		}
		mv.setViewName("/aco/material/new-apply");
		return mv;

	}
	
	
	/**
	 * TODO: 跳转到修改物品领用页
	 * 
	 * @return editApply
	 */
	@RequestMapping(value = "/doEditApply/{id}")
	public ModelAndView editApply(@PathVariable String id) {
		ModelAndView mv = new ModelAndView();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		BizMaterialStorageEntity bmsEntity = iBizMaterialStockService.findEntityByPK(BizMaterialStorageEntity.class, id);
		/*Org org = iOrgService.findOrgByUserId(user.getUserId());
		String orgName = "";
		if (org != null) {
			orgName = org.getOrgName();
		}*/
		if(user != null){
			String orgName = user.orgName;
			mv.addObject("userName", user.getName());
			mv.addObject("orgName", orgName);
			mv.addObject("data", bmsEntity);
		}
		mv.setViewName("/aco/material/edit-apply");
		return mv;
	}
	
	/**
	 * TODO: 跳转到查看物品领用页
	 * 
	 * @return
	 * @change by zhangdyd 
	 */
	@RequestMapping(value = "/viewApply/{id}")
	public ModelAndView viewApply(@PathVariable String id) {
		ModelAndView mv = new ModelAndView();
		//ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		BizMaterialStorageEntity bmsEntity = iBizMaterialStockService.findEntityByPK(BizMaterialStorageEntity.class, id);
		User user = iUserService.findUserById(bmsEntity.getUserId_());
		Org org = iOrgService.findOrgByUserId(user.getUserId());
		String orgName = "";
		if (org != null) {
			orgName = org.getOrgName();
		}
		mv.addObject("userName", user.getUserName());
		mv.addObject("orgName", orgName);
		mv.addObject("data", bmsEntity);
		mv.setViewName("/aco/material/view-apply");
		return mv;
	}
	
	/**
	 * TODO: 根据用户身份获取物品领用 申请记录
	 * TODO: 填入方法说明
	 * @param identity  manager 表示物资管理员  检索出所有已发以及处理过的申请记录   
	 * 					consumer 普通用户身份  仅获取自己素有的申请记录
	 * @param pageNum applyRecords
	 * @param pageSize
	 * @return
	 */
	@RequestMapping("/findMaterialApplyRecords/{identity}")
	public @ResponseBody Map<String, Object> findMaterialApplyRecords(
			@PathVariable String identity,
			@RequestParam(value = "pageNum",defaultValue="0") int pageNum,
			@RequestParam(value = "pageSize",defaultValue="10") int pageSize,
			@RequestParam(value = "title",defaultValue="") String title) {
		Map<String, Object> map = new HashMap<String, Object>();
		String newTitle;
		try {
			newTitle = new String(title.getBytes("iso-8859-1"), "utf-8");
		} catch (UnsupportedEncodingException e) {
			newTitle ="";
			logger.error("error",e);
		}
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		String userId = "";
		if(!"manager".equals(identity) && identity !=null){
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				userId = user.getUserId();
			}
		}
		PageResult<BizMaterialBean> page = iBizMaterialStockService.findMaterialApplyRecords(pageNum, pageSize, userId, newTitle);
		map.put("total", page.getTotalrecord());
		map.put("rows", page.getResults());
		return map;
	}
	/**
	 * TODO: 根据用户身份获取物品领用 申请记录
	 * TODO: 填入方法说明
	 * @param identity  manager 表示物资管理员  检索出所有已发以及处理过的申请记录   
	 * 					consumer 普通用户身份  仅获取自己素有的申请记录
	 * @param pageNum applyRecords
	 * @param pageSize
	 *@param bizMaterialApplyQuery  添加了高级查询，根据列表的每一个列字段进行查询和排序
	 * @return
	 */
	@RequestMapping("/findMaterialApplyRecordsQuery/{identity}")
	public @ResponseBody Map<String, Object> findMaterialApplyRecordsQuery(
			@PathVariable String identity,
			@RequestParam(value = "pageNum",defaultValue="0") int pageNum,
			@RequestParam(value = "pageSize",defaultValue="10") int pageSize,
			@ModelAttribute BizMaterialApplyQuery bizMaterialApplyQuery) {
		Map<String, Object> map = new HashMap<String, Object>();
		String newTitle;
		try {
			newTitle = new String(bizMaterialApplyQuery.getTitle_().getBytes("iso-8859-1"), "utf-8");
			bizMaterialApplyQuery.setTitle_(newTitle);
			bizMaterialApplyQuery.setStatus_(new String(bizMaterialApplyQuery.getStatus_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialApplyQuery.setUser(new String(bizMaterialApplyQuery.getUser().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialApplyQuery.setOperator(new String(bizMaterialApplyQuery.getOperator().getBytes("iso-8859-1"), "utf-8"));
		} catch (UnsupportedEncodingException e) {
			newTitle ="";
			logger.error("error",e);
		}
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		String userId = "";
		if(!"manager".equals(identity) && identity !=null){
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				userId = user.getUserId();
			}
		}
		PageResult<BizMaterialListBean> page = iBizMaterialStockService.findMaterialApplyRecords(pageNum, pageSize, userId, bizMaterialApplyQuery);
		map.put("total", page.getTotalrecord());
		map.put("rows", page.getResults());
		return map;
	}
	/**
	 * TODO: 出库时保存出库详情数据，保存出库物品数据
	 * 
	 * @param bmsEntity
	 * @param material
	 * @param response
	 * @throws IOException newMaterialApply
	 */
	@RequestMapping(value = "/doAddMaterialApply/{material}/{action}")
	public void doAddMaterialApply(@Valid BizMaterialStorageEntity bmsEntity,
			@PathVariable String material, @PathVariable String action,
			HttpServletResponse response) throws IOException {
		try {
			if(!"send".equals(action)){
				bmsEntity.setStatus_("0");
			}else{
				bmsEntity.setStatus_("1");
			}
			bmsEntity.setDirection_("出库");
			// 保存出出库详情
			iBizMaterialStockService.doInOrOutStock(bmsEntity, material, "出库");
			response.getWriter().write("true");
			response.getWriter().flush();
		} catch (Exception e) {
			logger.error("error",e);
			response.getWriter().write("false");
			response.getWriter().flush();
		}
	}
	
	/**
	 * TODO: 出库时保存出库详情数据，保存出库物品数据
	 * 
	 * @param bmsEntity
	 * @param material
	 * @param response
	 * @throws IOException updateMaterialApply
	 */
	@RequestMapping(value = "/doUpdateMaterialApply/{material}/{action}")
	public void doUpdateMaterialApply(@Valid BizMaterialStorageEntity bmsEntity,
			@PathVariable String material, @PathVariable String action,
			HttpServletResponse response) throws IOException {
		try {
			if(!"send".equals(action)){
				bmsEntity.setStatus_("0");
			}else{
				bmsEntity.setStatus_("1");
			}
			bmsEntity.setDirection_("出库");
			// 保存出出库详情
			iBizMaterialStockService.doUpdateMaterialApply(bmsEntity, material);
			response.getWriter().write("true");
			response.getWriter().flush();
		} catch (Exception e) {
			logger.error("error",e);
			response.getWriter().write("false");
			response.getWriter().flush();
		}
	}
	
	/**
	 * TODO: 删除未发的物品领用申请记录
	 * TODO: 删除记录同时也将该记录对应的物品领用详情表中对应记录删除
	 * @param id
	 * @return deleteByIds
	 */
	@RequestMapping("/doDeleteByIds")
	public @ResponseBody String doDeleteById(@RequestParam(value="ids") String ids){
			// 删除物资领用申请及其所选出库物品信息
		if(StringUtils.isNotEmpty(ids)){
			iBizMaterialStockService.doDelMaterialApply(ids);
			return "true";
		}else{
			return "false";
		}
	}
	
	/**
	 * TODO: 物品申请人或管理员处理物品领用申请方法
	 * TODO: 通过时将该条请求状态改为 2表示已审批通过，同时修改物品库存   
	 * 		   不通过时将该条记录请求状态改为3表示未通过审批并且不用修改物品库存
	 * @param id  要处理的物品领用单id
	 * @param action 处理动作 ：send表示申请人送交此申请记录，    true表示物资管理员申请通过 ， false表示物资管理员不通过
	 * @return “2”: 正常
	 * 			“3”：异常
	 * 			“1”: 库存量不足。
	 */
	@RequestMapping("/doDealApply")
	@ResponseBody 
	public String doDealApply(
			@RequestParam(value = "id") String id,
			@RequestParam(value = "action") String action) {
		try {
			String status;
			String orgId;
			String time;
			String userId;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user != null){
				// 获取当前登录人信息
				time = getTime();
				if ("send".equals(action)) {
					status = "1";// status 为 1表示申请状态为已发出
					userId ="";
					orgId = "";
				} else {
					// 根据登录人id 获取登录部门信息
					orgId = user.orgid;
					userId = user.id;
					if (!"true".equals(action)) {
						status = "3"; //status 为 3表示申请未通过
					} else {
						status = "2"; //status 为 2表示申请通过
						//to check if the storage amount enough
						List<BizMaterialStockDetailEntity> list = iBizMaterialStockService.findStockDetailByStorageId(id);
						String materialIds = "";
						int amount ;
						List<BizMaterialStockEntity> entity;
						for (int i = 0; i < list.size(); i++) {
							materialIds += list.get(i).getMaterialId_();
							entity =	iBizMaterialStockService.findByProperty(BizMaterialStockEntity.class, "materialId_", materialIds) ;
							amount = list.get(i).getAmount_();
							if(entity!=null&&!entity.isEmpty()){
								if(Integer.parseInt(entity.get(0).getAmount_())-amount<0){
									return "1";
								}
							}
						}
					}
				}
				// 更改领用申请状态
				iBizMaterialStockService.doUpdateStatus(id, status, userId, orgId, time);
			}
			return "2";
		} catch (Exception e) {
			logger.error("error",e);
			return "3";
		}
	}
	
	/** 获取当前服务器时间*/
	private String getTime() {
		String time = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
		return time;
	}
	
}
