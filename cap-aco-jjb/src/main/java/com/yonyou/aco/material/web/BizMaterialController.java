package com.yonyou.aco.material.web;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.aco.material.entity.BizMaterialBeanNew;
import com.yonyou.aco.material.entity.BizMaterialBeanNewQuery;
import com.yonyou.aco.material.entity.BizMaterialEntity;
import com.yonyou.aco.material.service.IBizMaterialService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;

/**
 * 
 * <p>概述：物资基本信息理控制层
 * <p>功能：实现了对物资基础信息的维护功能，包括新增物品，修改物品，获取物品类表数据，按条件查询物品信息，删除物品（删除同时会将物品对应的库存信息也删除）
 * <p>作者：贺国栋
 * <p>创建时间：2016-08-03
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/bizMaterialController")
public class BizMaterialController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@Resource
	IBizMaterialService iBizMaterialService;
	

	@RequestMapping(value = "/materialList")
	public String goodsList() {
		return "/aco/material/material-list";
	}
	
	/**
	 * TODO: 根据id获取一条记录
	 * TODO: 填入方法说明
	 * @param id  getDataById
	 * @return
	 */
	@RequestMapping(value="/findMaterialById/{id}")
	public @ResponseBody BizMaterialBeanNew getDataById(@PathVariable String id){
		BizMaterialBeanNew bmEntity = new BizMaterialBeanNew();
		try {
			bmEntity = iBizMaterialService.findMaterialById(id);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return bmEntity;
	}

	/**
	 * 获取所有物品
	 * 
	 * @param pagen
	 * @param rows
	 * @param roomName
	 * @return getAllData
	 */
	@ResponseBody
	@RequestMapping(value = "/findAllMaterialData")
	public Map<String, Object> getAllData(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "mname", defaultValue = "") String mname,
			@RequestParam(value = "sortName",defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder",defaultValue = "") String sortOrder) {
		String newMname;
		try {
			newMname = new String(mname.getBytes("iso-8859-1"), "utf-8");
		} catch (UnsupportedEncodingException e) {
			newMname="";
			logger.error("error",e);
		}
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		Map<String, Object> map = new HashMap<String, Object>();
		PageResult<BizMaterialBeanNew> pags;
		if (StringUtils.isEmpty(newMname) && StringUtils.isEmpty(sortName)) {
			pags = iBizMaterialService.findAllMaterialData(pageNum, pageSize);
		} else {
			pags = iBizMaterialService.findAllMaterialData(pageNum, pageSize, newMname,sortName,sortOrder);
		}
		map.put("total", pags.getTotalrecord());
		map.put("rows", pags.getResults());
		return map;
	}

	/**
	 * 获取所有物品
	 * 
	 * @param pagen
	 * @param rows
	 * @param roomName
	 * @return getAllData
	 */
	@ResponseBody
	@RequestMapping(value = "/findAllMaterialDataQuery")
	public Map<String, Object> findAllMaterialDataQuery(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,		
			@ModelAttribute BizMaterialBeanNewQuery bizMaterialBeanNewQuery) {
		try {
			bizMaterialBeanNewQuery.setM_name_(new String(bizMaterialBeanNewQuery.getM_name_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialBeanNewQuery.setM_number_(new String(bizMaterialBeanNewQuery.getM_number_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialBeanNewQuery.setStandard_(new String(bizMaterialBeanNewQuery.getStandard_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialBeanNewQuery.setUnit_(new String(bizMaterialBeanNewQuery.getUnit_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialBeanNewQuery.setSupplier_(new String(bizMaterialBeanNewQuery.getSupplier_().getBytes("iso-8859-1"), "utf-8"));
		}catch(Exception e){
			logger.error("error",e);
		}
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		Map<String, Object> map = new HashMap<String, Object>();
		PageResult<BizMaterialBeanNew> pags;
		pags = iBizMaterialService.findAllMaterialData(pageNum, pageSize,bizMaterialBeanNewQuery);
		map.put("total", pags.getTotalrecord());
		map.put("rows", pags.getResults());
		return map;
	}

	/**
	 * TODO: 新增物品 TODO: 新增物品时同时会给物品创建库存记录
	 * 
	 * @param bmEntity
	 * @param response   addMaterial
	 * @return "01":物品名称重复
	 * 			"02":物品编码重复
	 * 			"03":保存成功
	 * 			"04":保存失败
	 * @throws IOException
	 */
	@RequestMapping(value = "/doAddMaterial")
	@ResponseBody
	public Map<String,Object> saveOneData(BizMaterialBeanNew bmEntity, HttpServletResponse response)
			throws IOException {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		try {
			//@add by zhangdyd
			//check the repeat "mName_"
			if(bmEntity.getM_name_()!=null&&!"".equals(bmEntity.getM_name_())){
				List<BizMaterialEntity> tempList = iBizMaterialService.findByProperty(BizMaterialEntity.class, "mName_", bmEntity.getM_name_());
				if(tempList!=null&&tempList.size()>0){
					for(int i =0;i<tempList.size();i++){
						if("1".equals(tempList.get(i).getIsRemove_())){
							resultMap.put("result", "01");
							return resultMap;
						}
					}
				}
			}
			//check the repeat "mNumber_"
			if(bmEntity.getM_number_()!=null&&!"".equals(bmEntity.getM_number_())){
				List<BizMaterialEntity> tempList = iBizMaterialService.findByProperty(BizMaterialEntity.class, "mNumber_", bmEntity.getM_number_());
				if(tempList!=null&&tempList.size()>0){
					for(int i =0;i<tempList.size();i++){
						if("1".equals(tempList.get(i).getIsRemove_())){
							resultMap.put("result", "02");
							return resultMap;
						}
					}
				}
			}
			// 新增物品
			String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
			/*bmEntity.setId(null);*/
			BizMaterialEntity bmEntity2=new BizMaterialEntity();
			bmEntity2.setId(null);
			bmEntity2.setStatus_("1");
			bmEntity2.setIndate_(date);
			bmEntity2.setSort_(findCount());
			bmEntity2.setIsRemove_("1");
			bmEntity2.setInventoryFloor_(bmEntity.getInventory_floor_());
			bmEntity2.setmName_(bmEntity.getM_name_());
			bmEntity2.setmNumber_(bmEntity.getM_number_());
			bmEntity2.setRemark_(bmEntity.getRemark_());
			bmEntity2.setUnit_(bmEntity.getUnit_());
			bmEntity2.setSupplier_(bmEntity.getSupplier_());
			bmEntity2.setStandard_(bmEntity.getStandard_());
			iBizMaterialService.save(bmEntity2);
			resultMap.put("result", "03");
			return resultMap;
		} catch (Exception e) {
			logger.error("error",e);
			resultMap.put("result", "04");
		}
		return resultMap;
	}

	/**
	 * 
	 * TODO:获取当前排序
	 * 
	 * @return
	 */
	public String findCount() {
		String count = iBizMaterialService.findCount();
		int newCount = Integer.parseInt(count);
		newCount++;
		return String.valueOf(newCount);
	}

	/**
	 * 修改物品
	 * 
	 * @param bmEntity
	 * @return  "01":物品名称重复
	 * 			"02":物品编号重复
	 * 			"03":更新成功
	 * 			"04":更新失败
	 * @throws IOException
	 */
	@RequestMapping(value = "/doUpdateMaterial")
	@ResponseBody
	public Map<String,Object> updateMaterial(BizMaterialBeanNew bmEntity,
			HttpServletResponse response) throws IOException {
		Map<String,Object> resultMap = new HashMap<String,Object>();
		BizMaterialEntity bmEntity2=new BizMaterialEntity();
		try {
			Boolean condition=true;
			//add by zhangdyd
			//check the repeat "mName_" 
			if(bmEntity.getM_name_()!=null&&!"".equals(bmEntity.getM_name_())){
				List<BizMaterialEntity> tempList = iBizMaterialService.findByProperty(BizMaterialEntity.class, "mName_", bmEntity.getM_name_());
				if(tempList!=null){
					if(tempList.size() == 1){
						if(tempList.get(0).getId().equals(bmEntity.getId_())){
							//modify self
							condition = true;
						}else{
							condition = false;
							resultMap.put("result", "01");
							return resultMap;
						}
					}else if(tempList.size()>1) {
						//log the "the data in the database error, there multiple 'BizMaterialEntity' with same 'mName_' "
						logger.info("数据库数据错误，在物品管理中存在形同物品名称的记录，这是不应该发生的!");
						condition = false;
						resultMap.put("result", "01");
						return resultMap;
					}
				}
			}
			//check the repeat "mNumber_"
			if(bmEntity.getM_number_()!=null&&!"".equals(bmEntity.getM_number_())){
				List<BizMaterialEntity> tempList = iBizMaterialService.findByProperty(BizMaterialEntity.class, "mNumber_", bmEntity.getM_number_());
				if(tempList!=null){
					if(tempList.size() == 1){
						if(tempList.get(0).getId().equals(bmEntity.getId_())){
							//modify self
							condition = true;
						}else{
							condition = false;
							resultMap.put("result", "02");
							return resultMap;
						}
					}else if(tempList.size()>1) {
						//log the "the data in the database error, there multiple 'BizMaterialEntity' with same 'mName_' "
						logger.info("数据库数据错误，在物品管理中存在形同物品编码的记录，这是不应该发生的!");
						condition = false;
						resultMap.put("result", "02");
						return resultMap;
					}
				}
			}
			//there no repeat "mName_" and "mNumber_"
			if(condition){
				bmEntity2.setIsRemove_("1");
				bmEntity2.setmName_(bmEntity.getM_name_());
				bmEntity2.setmNumber_(bmEntity.getM_number_());
				bmEntity2.setId(bmEntity.getId_());
				bmEntity2.setIndate_(bmEntity.getIndate_());
				bmEntity2.setInventoryFloor_(bmEntity.getInventory_floor_());
				bmEntity2.setRemark_(bmEntity.getRemark_());
				bmEntity2.setSort_(bmEntity.getSort_());
				bmEntity2.setStandard_(bmEntity.getStandard_());
				bmEntity2.setStatus_(bmEntity.getStatus_());
				bmEntity2.setSupplier_(bmEntity.getSupplier_());
				bmEntity2.setUnit_(bmEntity.getUnit_());
				iBizMaterialService.updateMaterial(bmEntity2);
				resultMap.put("result", "03");
				return resultMap;
			}
		} catch (Exception e) {
			logger.error("error",e);
			resultMap.put("result", "04");
			return resultMap;
		}
		return resultMap;
	}

	/**
	 * 删除物品同时删除物品对应的库存记录（支持批量删除）
	 * 
	 * @param ids
	 * @return 
	 */
	@ResponseBody
	@RequestMapping(value = "/doDelMaterial")
	public String delGoods(@RequestParam(value = "ids", defaultValue="")String ids) {
		try {
			if (ids != null && !"".equals(ids)) {
				iBizMaterialService.delMaterialAndStock(ids);
			}
			return "true";
		} catch (Exception e) {
			logger.error("error",e);
			return "fasle";
		}
	}
	
	@ResponseBody
	@RequestMapping(value = "/findCountById")
	public String findCountById(@RequestParam(value = "id") String id){
		try {
			if(StringUtils.isNotEmpty(id)){
				return iBizMaterialService.findCountById(id);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "";
	}
	
}
