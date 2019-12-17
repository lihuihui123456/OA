package com.yonyou.aco.arc.bid.web;

import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.arc.bid.entity.ArcBidBean;
import com.yonyou.aco.arc.bid.entity.ArcBidEntity;
import com.yonyou.aco.arc.bid.entity.ArcBidListBean;
import com.yonyou.aco.arc.bid.service.IArcBidService;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.otherarc.entity.SearchBean;
import com.yonyou.aco.arc.otherarc.service.IArcPubInfoService;
import com.yonyou.aco.arc.utils.DateUtil;
import com.yonyou.aco.arc.utils.ExcelUtil;
import com.yonyou.cap.common.util.BeanUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 招投标档案Controller TODO: 填写Class详细说明 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月22日
 * @author hegd
 * @since 1.0.0
 */
@Controller
@RequestMapping("/arcBidController")
public class ArcBidController {

	@Resource
	IArcBidService arcBidService;
	@Resource
	IArcPubInfoService arcPubInfoService;

	/**
	 * 
	 * TODO:跳转招投标列表主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToMain")
	public ModelAndView goToMain(@RequestParam(value = "id") String typeId) {

		ModelAndView mv = new ModelAndView();
		mv.addObject("typeId", typeId);
		mv.setViewName("/aco/arc/arcbid/list/arcbid-list");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转招投标新增主页 TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToIndex")
	public String goToIndex() {
		return "/aco/arc/arcbid/template/arcbid-index";
	}

	/**
	 * 
	 * TODO: 跳转招投标表单页. TODO: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/goToForm")
	public String goToForm() {
		return "/aco/arc/arcbid/template/arcbid-form";
	}

	@RequestMapping("/goToAttr")
	public ModelAndView goToAttr(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "type", defaultValue = "") String type) {
		ModelAndView mv = new ModelAndView();
		mv.addObject("arcId", arcId);
		mv.addObject("type", type);
		mv.setViewName("/aco/arc/arcbid/bidatt/bid-att");
		return mv;
	}

	/**
	 * 
	 * TODO: 跳转到
	 * 
	 * @param arcId
	 * @return
	 */
	@RequestMapping("/goToArcBidAdd")
	public ModelAndView goToArcBidAdd(
			@RequestParam(value = "typeId", defaultValue = "0") String typeId) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcBidController/goToForm");
		map.put("typeId", typeId);
		map.put("attUrl", "arcBidController/goToAttr?arcId=");
		map.put("type", "add");
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/arcbid/template/arcbid-index");
		return mv;
	}

	@RequestMapping("/goToArcBidView")
	public ModelAndView goToArcBidView(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart,
			@RequestParam(value = "type", defaultValue = "0") String type) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcBidController/viewArcBid?arcId=" + arcId
				+ "&fileStart=" + fileStart);
		map.put("type", type);
		map.put("attUrl", "arcBidController/goToAttr?arcId=" + arcId
				+ "&type=view");
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/arcbid/template/arcbid-index");
		return mv;
	}

	@RequestMapping("/viewArcBid")
	public ModelAndView viewArcBid(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		ArcBidBean bean = arcBidService.findArcBidByArcId(arcId, fileStart);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bean", bean);
		mv.setViewName("/aco/arc/arcbid/template/arcbid-view-form");
		return mv;
	}

	@RequestMapping("/goToArcBidUpdate")
	public ModelAndView goToArcBidUpdate(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "typeId", defaultValue = "0") String typeId,
			@RequestParam(value = "type", defaultValue = "0") String type,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("fromUrl", "arcBidController/updateArcBid?arcId=" + arcId
				+ "&type=" + type);
		map.put("type", type);
		map.put("typeId", typeId);
		map.put("attUrl", "arcBidController/goToAttr?arcId=" + arcId);
		ModelAndView mv = new ModelAndView();
		mv.addAllObjects(map);
		mv.setViewName("/aco/arc/arcbid/template/arcbid-update");
		return mv;
	}

	@RequestMapping("/updateArcBid")
	public ModelAndView updateArcBid(
			@RequestParam(value = "arcId", defaultValue = "0") String arcId,
			@RequestParam(value = "type", defaultValue = "0") String type,
			@RequestParam(value = "fileStart", defaultValue = "0") String fileStart) {
		ArcBidBean bean = arcBidService.findArcBidByArcId(arcId, fileStart);
		ModelAndView mv = new ModelAndView();
		mv.addObject("bean", bean);
		mv.addObject("type", type);
		mv.setViewName("/aco/arc/arcbid/template/arcbid-update-from");
		return mv;
	}

	/**
	 * 
	 * TODO: 获取所有招投标档案信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param typeName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findAllArcBidData")
	public Map<String, Object> findAllArcBidData(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "bidName", defaultValue = "") String bidName,
			@RequestParam(value = "bidCo", defaultValue = "") String bidCo,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(value = "year", defaultValue = "") String year,
			@RequestParam(value = "fileStart", defaultValue = "") String fileStart,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder

	) {
		try {
			bidName = new String(bidName.getBytes("iso-8859-1"), "utf-8");
			bidCo = new String(bidCo.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<ArcBidListBean> pags;
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			if (user != null) {
				pags = arcBidService.findAllArcBidData(pageNum, pageSize,
						bidName, bidCo, startTime, endTime, year, fileStart,
						user, sortName, sortOrder);
				map.put("total", pags.getTotalrecord());
				map.put("rows", pags.getResults());
			}
			return map;
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * 
	 * TODO: 添加招投标档案信息 TODO: 填入方法说明
	 * 
	 * @param aBean
	 * @return
	 */
	@RequestMapping("/doAddArcBidInfo")
	@ResponseBody
	public String doAddArcBidInfo(@Valid ArcBidBean aBean) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user == null) {
			return "";
		}
		ArcBidEntity abEntity = new ArcBidEntity();
		ArcPubInfoEntity apEntity = new ArcPubInfoEntity();
		BeanUtil.copy(abEntity, aBean);
		BeanUtil.copy(apEntity, aBean);
		abEntity.setDataDeptCode(user.getDeptCode());
		abEntity.setDataOrgId(user.getOrgid());
		abEntity.setDataUserId(user.getUserId());
		arcBidService.doAddArcBidInfo(abEntity);
		int num = Integer.parseInt(aBean.getExpiryDate());
		Date expiryDate = DateUtil.getExpiryDate(num, aBean.getRegTime());
		apEntity.setExpiryDateTime(expiryDate);
		apEntity.setDr("N");
		apEntity.setIsInvalid("0");
		apEntity.setId(null);
		apEntity.setFileStart("0");
		arcPubInfoService.addArcPubInfo(apEntity);
		return "Y";
	}

	/**
	 * TODO: 修改内部项目信息
	 * 
	 * @param aBean
	 * @return
	 */
	@RequestMapping("/doUpdateSaveArcBidInfo")
	@ResponseBody
	public String doUpdateSaveArcBidInfo(@Valid ArcBidBean aBean) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user == null) {
			return "error";
		}
		ArcBidEntity adEntity = new ArcBidEntity();
		ArcPubInfoEntity apEntity = new ArcPubInfoEntity();
		BeanUtil.copy(adEntity, aBean);
		BeanUtil.copy(apEntity, aBean);
		adEntity.setDataDeptCode(user.getDeptCode());
		adEntity.setDataOrgId(user.getOrgid());
		adEntity.setDataUserId(user.getUserId());
		arcBidService.doUpdateArcBidInfo(adEntity);
		int num = Integer.parseInt(aBean.getExpiryDate());
		Date expiryDate = DateUtil.getExpiryDate(num, aBean.getRegTime());
		apEntity.setDataDeptCode(user.getDeptCode());
		apEntity.setDataDeptId(user.getDeptId());
		apEntity.setDataUserId(user.getUserId());
		apEntity.setDataOrgId(user.getOrgid());
		apEntity.setExpiryDateTime(expiryDate);
		apEntity.setDr("N");
		apEntity.setIsInvalid("0");
		apEntity.setFileStart("0");
		arcPubInfoService.updatePubInfoSumm(apEntity);
		return "";
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @param sbean
	 *            查询条件
	 */
	@RequestMapping("/exportBidExcel")
	public void exportBidExcel(HttpServletRequest request,
			HttpServletResponse response, @ModelAttribute SearchBean sbean) {

		try {
			List<ArcBidBean> list = new ArrayList<ArcBidBean>();
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			if (user != null) {
				if (!StringUtils.isBlank(sbean.getSelectIds())) {
					// 支持单选功能
					ArcBidBean findArcBidByArcId = arcBidService
							.findArcBidByArcId(sbean.getSelectIds(), "");
					list.add(findArcBidByArcId);
				} else {
					String bidName = "";
					String proName = "";
					if (StringUtils.isNotBlank(sbean.getBidName())) {
						bidName = new String(sbean.getBidName().getBytes(
								"iso-8859-1"), "utf-8");
					}
					if (StringUtils.isNotBlank(sbean.getSproName())) {
						proName = new String(sbean.getSproName().getBytes(
								"iso-8859-1"), "utf-8");
					}

					PageResult<ArcBidBean> page = arcBidService
							.findAllArcBidData(1, Integer.MAX_VALUE, bidName,
									proName, sbean.getStartTime(),
									sbean.getEndTime(),
									sbean.getSearchregYear(),
									sbean.getFileStart(), user);
					list = page.getResults();
				}

				OutputStream ops = response.getOutputStream();
				HSSFWorkbook workbook = null;
				// 表头和对象属性
				String[] columnNames = { "文件标题", "项目名称", "招标日期", "登记人", "中标单位",
						"存放位置", "项目编号", "关键字", "中标单位联系人", "中标单位联系方式" };
				String[] columnValues = { "arcName", "bidName", "bidDate",
						"regUser", "bidCo", "depPos", "proNbr", "keyWord",
						"unitCntctUser", "unitCntct" };
				workbook = ExcelUtil.generateExcelFile(list, columnNames,
						columnValues);
				workbook.write(ops);
				String filename = "招投标档案信息";
				filename = new String(filename.getBytes("gb2312"), "ISO8859-1");
				response.setContentType("text/html");
				response.setHeader("Content-Disposition",
						"attachment;filename=" + filename + ".xls");
				ops.close();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
