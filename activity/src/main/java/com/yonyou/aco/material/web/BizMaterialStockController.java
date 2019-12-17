package com.yonyou.aco.material.web;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
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

import com.yonyou.aco.material.entity.BizMaterialBean;
import com.yonyou.aco.material.entity.BizMaterialStockBean;
import com.yonyou.aco.material.entity.BizMaterialStockDetailListEntity;
import com.yonyou.aco.material.entity.BizMaterialStockDetailQuery;
import com.yonyou.aco.material.entity.BizMaterialStockQuery;
import com.yonyou.aco.material.entity.BizMaterialStorageEntity;
import com.yonyou.aco.material.service.IBizMaterialStockService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.org.service.IOrgService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;


/**
 * 
 * <p>概述：物资库存管理控制层 
 * <p>功能：1、物品库存页跳转  2、库存变动明细页跳转  3、获取物品库存信息  4、获取出入库时选择的物品信息  5、入库方法 6、获取物品变动明信息 
 * <p>作者：贺国栋
 * <p>创建时间：2016-08-03
 * <p>类调用特殊情况：无
 */

@Controller
@RequestMapping("/bizMaterialStockController")
public class BizMaterialStockController {

	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	@Resource 
	IBizMaterialStockService iBizMaterialStockService;
	@Resource
	IOrgService iOrgService;
	
	/**
	 * TODO: 跳转到库存页.
	 * @return
	 */
	@RequestMapping(value = "/stockList")
	public ModelAndView stockList() {
		ModelAndView mv = new ModelAndView();
		// 查询库存物品预警的物品数目
		/*long number = stockService.getWarningNumber();
		mv.addObject("number", number);*/
		mv.setViewName("/aco/material/stock-list");
		return mv;
	}

	/**
	 * TODO: 跳转到库存变动明细页
	 * 
	 * @return
	 */
	@RequestMapping(value = "/stockChange")
	public String stockChange() {
		return "/aco/material/stock-detial";
	}

	/**
	 * TODO: 获取物品库存信息
	 * @param pageNum 
	 * @param pageSize
	 * @param mode  获取方式默认为 getAll 表示获取所有启用物品， 当不为getAll 时表示获取预警的物品库存信息
	 * @param mname 查询参数  
	 * @return  getAllStock
	 */
	@ResponseBody
	@RequestMapping(value = "/findAllStock")
	public Map<String, Object> findAllStock(
			@RequestParam(value = "page", defaultValue = "0") int pageNum,
			@RequestParam(value = "rows", defaultValue = "10") int pageSize,
			@RequestParam(value = "mode", defaultValue = "getAll") String mode,
			@RequestParam(value = "mname", defaultValue = "") String mname) {
		String newMname;
		Map<String, Object> map = new HashMap<String, Object>();
		PageResult<BizMaterialStockBean> page;
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		if (StringUtils.isNotEmpty(mname)) {
			try {
				newMname = new String(mname.getBytes("iso-8859-1"), "utf-8");
			} catch (UnsupportedEncodingException e) {
				newMname="";
				logger.error("error",e);
			}
			// 按搜索参数模糊查询
			page = iBizMaterialStockService.findAllStock(pageNum, pageSize, mode,
					newMname);
		} else {
			// 不执行模糊查询
			page = iBizMaterialStockService.findAllStock(pageNum, pageSize, mode);
		}
		map.put("total", page.getTotalrecord());
		map.put("rows", page.getResults());

		return map;
	}
	/**
	 * TODO: 获取物品库存信息
	 * @param pageNum 
	 * @param pageSize
	 * @param mode  获取方式默认为 getAll 表示获取所有启用物品， 当不为getAll 时表示获取预警的物品库存信息
	 * @param mname 查询参数  
	 * @return  getAllStock
	 */
	@ResponseBody
	@RequestMapping(value = "/findAllStockQuery")
	public Map<String, Object> findAllStockQuery(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,		
			@ModelAttribute BizMaterialStockQuery bizMaterialStockQuery) {
		Map<String, Object> map = new HashMap<String, Object>();
		PageResult<BizMaterialStockBean> page;
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		try {
			bizMaterialStockQuery.setM_name_(new String(bizMaterialStockQuery.getM_name_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockQuery.setM_number_(new String(bizMaterialStockQuery.getM_number_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockQuery.setStandard_(new String(bizMaterialStockQuery.getStandard_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockQuery.setUnit_(new String(bizMaterialStockQuery.getUnit_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockQuery.setSupplier_(new String(bizMaterialStockQuery.getSupplier_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockQuery.setAmount_(new String(bizMaterialStockQuery.getAmount_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockQuery.setInventory_floor_(new String(bizMaterialStockQuery.getInventory_floor_().getBytes("iso-8859-1"), "utf-8"));
		} catch (Exception e) {
			e.printStackTrace();
		}
		page = iBizMaterialStockService.findAllStock(pageNum, pageSize,bizMaterialStockQuery);
		/*		if (StringUtils.isNotEmpty(mname)) {
			try {
				newMname = new String(mname.getBytes("iso-8859-1"), "utf-8");
			} catch (UnsupportedEncodingException e) {
				newMname="";
				logger.error("error",e);
			}
			// 按搜索参数模糊查询
			page = iBizMaterialStockService.findAllStock(pageNum, pageSize, mode,
					newMname);
		} else {
			// 不执行模糊查询
			page = iBizMaterialStockService.findAllStock(pageNum, pageSize, mode);
		}*/
		map.put("total", page.getTotalrecord());
		map.put("rows", page.getResults());

		return map;
	}
	/**
	 * TODO: 获取物品库存信息
	 * @param pageNum 
	 * @param pageSize
	 * @param mode  获取方式默认为 getAll 表示获取所有启用物品， 当不为getAll 时表示获取预警的物品库存信息
	 * @param mname 查询参数  
	 * @return  getAllStock
	 */
	@ResponseBody
	@RequestMapping(value = "/searchStock")
	public Map<String, Object> searchStock(
			@RequestParam(value = "page", defaultValue = "0") int pageNum,
			@RequestParam(value = "rows", defaultValue = "10") int pageSize,
			@RequestParam(value = "mode", defaultValue = "getAll") String mode,
			@RequestParam(value = "mname", defaultValue = "") String mname) {
		String newMname;
		Map<String, Object> map = new HashMap<String, Object>();
		PageResult<BizMaterialStockBean> page;
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		if (StringUtils.isNotEmpty(mname)) {
			try {
				newMname = new String(mname.getBytes("iso-8859-1"), "utf-8");
			} catch (UnsupportedEncodingException e) {
				newMname="";
				logger.error("error",e);
			}
			// 按搜索参数模糊查询
			page = iBizMaterialStockService.findAllStock(pageNum, pageSize, mode,
					newMname);
		} else {
			// 不执行模糊查询
			page = iBizMaterialStockService.findAllStock(pageNum, pageSize, mode);
		}
		map.put("total", page.getTotalrecord());
		map.put("rows", page.getResults());

		return map;
	}

	/**
	 * TODO: 通过物品id获取出入库时选择的物品库存信息
	 * TODO: 
	 * @param ids 选择入库的物品 id 数组
	 * @return getChoosedStock
	 */
	@ResponseBody
	@RequestMapping(value = "/findChoosedStock")
	public Map<String, Object> findChoosedStock(
			@RequestParam(value = "ids[]", required = false) String ids[]) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			if (ids != null && ids.length > 0) {
				PageResult<BizMaterialStockBean> page = iBizMaterialStockService.findChoosedStock(ids);
				map.put("total", page.getTotalrecord());
				map.put("rows", page.getResults());
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return map;
	}

	/**
	 * TODO: 获取出入库时选择的物品库存信息
	 * 
	 * @param pagen
	 * @param rows
	 * @return  getChoosedMaterial
	 */
	@ResponseBody
	@RequestMapping(value = "/findChoosedMaterialById/{id}")
	public Map<String, Object> findChoosedMaterial(
			@PathVariable String id) {
		Map<String, Object> map = new HashMap<String, Object>();
		try {
			PageResult<BizMaterialStockBean> page = iBizMaterialStockService.findChoosedMateriaById(id);
			map.put("total", page.getTotalrecord());
			map.put("rows", page.getResults());
		} catch (Exception e) {
			logger.error("error",e);
		}
		return map;
	}
	
	/**
	 * TODO: 查看物品和及其库存信息
	 * 
	 * @param materialsid
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/viewMaterialAndStock")
	public BizMaterialStockBean viewGooodsAndStock(
			@RequestParam(value = "id") String materialId) {
		try {
			BizMaterialStockBean bmsEntity;
			bmsEntity = iBizMaterialStockService.findStockByMaterialId(materialId);
			return bmsEntity;
		} catch (Exception e) {
			logger.error("error",e);
			return null;
		}
	}

	/**
	 * TODO: 入库时保存入库详情数据，保存入库物品数据，修改物品库存
	 * 
	 * @param bmsEntity
	 * @param material
	 * @param response  inStock
	 * @throws IOException
	 */
	@RequestMapping(value = "/doInStock/{material}")
	public void inStock(@Valid BizMaterialStorageEntity bmsEntity,
			@PathVariable String material, HttpServletResponse response)
			throws IOException {
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			/*Org org = iOrgService.findOrgByUserId(user.getUserId());
			String orgId = "";
			if (org != null) {
				orgId = org.getOrgId();
			}*/
			if(null != user){
				String orgId = user.orgid;
				bmsEntity.setId(null);
				bmsEntity.setOperatorId_(user.getUserId());
				bmsEntity.setOperatororgId_(orgId);
				String time = findServerTime();
				bmsEntity.setEndTime_(time);
				bmsEntity.setStatus_("2");
				bmsEntity.setDirection_("入库");
				// 保存出入库详情
				iBizMaterialStockService.doInOrOutStock(bmsEntity, material, "入库");
				response.getWriter().write("true");
				response.getWriter().flush();
			}
		} catch (Exception e) {
			logger.error("error",e);
			response.getWriter().write("false");
			response.getWriter().flush();
		}
	}

	/**
	 * 获取物品库存变动信息
	 * @param pagen
	 * @param rows
	 * @param mname
	 * @param operator
	 * @return getStockDetials
	 */
	@ResponseBody
	@RequestMapping(value = "/findStockDetials")
	public Map<String, Object> findStockDetials(
			@RequestParam(value = "page", defaultValue = "0") int pageNum,
			@RequestParam(value = "rows", defaultValue = "10") int pageSize,
			@RequestParam(value = "mname", defaultValue = "") String mname,
			@RequestParam(value = "name", defaultValue = "") String name,
			@RequestParam(value = "user", defaultValue = "") String user,
			@RequestParam(value = "operator", defaultValue = "") String operator) {
		String newMname;
		String newUser;
		String newOperator;
		String newname;
		try {
			newMname = new String(mname.getBytes("iso-8859-1"), "utf-8");
			newUser = new String(user.getBytes("iso-8859-1"), "utf-8");
			newOperator = new String(operator.getBytes("iso-8859-1"), "utf-8");
			newname = new String(name.getBytes("iso-8859-1"), "utf-8");
		} catch (UnsupportedEncodingException e) {
			newMname = "";
			newUser = "";
			newOperator ="";
			newname = "";
			logger.error("error",e);
		}
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		StringBuilder wheresql = new StringBuilder();
		if(!StringUtils.isEmpty(mname)){
			wheresql.append("AND m_name_ LIKE '%" + newMname.trim() + "%' ");
		}
		if(!StringUtils.isEmpty(user)){
			wheresql.append("AND user LIKE '%" + newUser.trim() + "%' ");
		}
		if(!StringUtils.isEmpty(operator)){
			wheresql.append("AND operator LIKE '%" + newOperator.trim() + "%' ");
		}
		if(!StringUtils.isEmpty(name)){
			wheresql.append("AND m_name_ LIKE '%" + newname.trim() + "%' ");
		}
		PageResult<BizMaterialBean> page = iBizMaterialStockService
				.findStockDetials(pageNum, pageSize, wheresql.toString());
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("total", page.getTotalrecord());
		map.put("rows", page.getResults());
		return map;

	}
	/**
	 * 获取物品库存变动信息
	 * @param pagen
	 * @param rows
	 * @param BizMaterialStockDetailQuery
	 * @return getStockDetials
	 */
	@ResponseBody
	@RequestMapping(value = "/findStockDetialsQuery")
	public Map<String, Object> findStockDetialsQuery(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,		
			@ModelAttribute BizMaterialStockDetailQuery bizMaterialStockDetailQuery) {
		try {
			bizMaterialStockDetailQuery.setM_name_(new String(bizMaterialStockDetailQuery.getM_name_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockDetailQuery.setM_number_(new String(bizMaterialStockDetailQuery.getM_number_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockDetailQuery.setStandard_(new String(bizMaterialStockDetailQuery.getStandard_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockDetailQuery.setDirection_(new String(bizMaterialStockDetailQuery.getDirection_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockDetailQuery.setAmount_(new String(bizMaterialStockDetailQuery.getAmount_().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockDetailQuery.setUser(new String(bizMaterialStockDetailQuery.getUser().getBytes("iso-8859-1"), "utf-8"));
			bizMaterialStockDetailQuery.setOperator(new String(bizMaterialStockDetailQuery.getOperator().getBytes("iso-8859-1"), "utf-8"));
		} catch (UnsupportedEncodingException e) {
			logger.error("error",e);
		}
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		PageResult<BizMaterialStockDetailListEntity> page = iBizMaterialStockService
				.findStockDetials(pageNum, pageSize, bizMaterialStockDetailQuery);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("total", page.getTotalrecord());
		map.put("rows", page.getResults());
		return map;

	}

	/** 获取当前服务器时间 */
	private String findServerTime() {
		String time = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
		return time;
	}
	
}
