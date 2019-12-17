//*********************************************************************
// 系统名称：cap-base-arc
// Branch. All rights reserved.
// 版本信息：cap-base-arc0.0.1
// Copyright(C)2016-2020 UFIDA Software Co. Ltd. All rights reserved.
// #作者：李争辉$手机：18336070328#
// SVN版本号                    日   期                 作     者              变更记录
// ArcPubInfoController-001     2016/12/21   李争辉                 新建
//*********************************************************************
package com.yonyou.aco.arc.otherarc.web;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoBean;
import com.yonyou.aco.arc.otherarc.entity.ArcPubInfoEntity;
import com.yonyou.aco.arc.otherarc.service.IArcPubInfoService;
import com.yonyou.aco.arc.type.entity.ArcTypeBean;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.aco.arc.type.service.IActTypeService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.org.entity.Dept;
import com.yonyou.cap.isc.org.service.IDeptService;
import com.yonyou.cap.isc.org.service.IOrgService;
import com.yonyou.cap.isc.org.service.IPostService;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.service.IUserService;

/**
 * <p>
 * 概述：业务模块其它档案管理Controller层
 * <p>
 * 功能：实现其它档案管理的业务请求处理
 * <p>
 * 作者：lzh
 * <p>
 * 创建时间：2016-12-21
 * <p>
 * 类调用特殊情况：无
 */
@Controller
@RequestMapping("/arcPubInfo")
public class ArcPubInfoController {
	@Resource
	IArcPubInfoService arcPubInfoService;
	@Autowired
	private HttpServletRequest request;
	@Resource
	IActTypeService actTypeService;
	@Resource
	IUserService iUserService;
	@Resource
	private IOrgService orgService;
	@Resource
	private IDeptService deptService;
	@Resource
	private IPostService postService;

	/**
	 * 根据名字查询档案
	 * 
	 * @add zhangduoyi
	 * @change 添加了返回档案类型
	 * @param arcName
	 * @return
	 */
	@RequestMapping("/index")
	@ResponseBody
	public ModelAndView index() {
		ModelAndView mv = new ModelAndView();
		List<ArcTypeEntity> arcTypeList = actTypeService.findAllArcTypeList();
		String modCode = request.getParameter("modCode");
		mv.addObject("modCode", modCode);
		mv.addObject("arcType", arcTypeList);
		mv.setViewName("/aco/arc/arcpubinfo/pubInfoIndex");
		return mv;
	}

	@RequestMapping("/doPageFindByArcName")
	@ResponseBody
	public TreeGridView<ArcPubInfoEntity> doPageFindByArcName(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize) {
		String arcName = request.getParameter("arcName");

		TreeGridView<ArcPubInfoEntity> plist = new TreeGridView<ArcPubInfoEntity>();
		if (arcName != null && !"NULL".equalsIgnoreCase(arcName)
				&& !"".equals(arcName)) {
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<ArcPubInfoEntity> pags = arcPubInfoService
					.pageArcPubInfoEntityList(pageNum, pageSize, arcName);
			List<ArcPubInfoEntity> list = pags.getResults();
			plist.setRows(list);
			plist.setTotal(pags.getTotalrecord());

			return plist;
		}
		return plist;
	}

	/**
	 * 根据名字查询档案
	 * 
	 * @add zhangduoyi
	 * @param arcName
	 * @return
	 */
	@RequestMapping("/doFindByArcName")
	@ResponseBody
	public ArcPubInfoEntity doFindByArcName(
			@RequestParam(value = "arcName") String arcName) {
		if (arcName == null || "NULL".equalsIgnoreCase(arcName)
				|| "".equals(arcName)) {
			return null;
		} else {

			return arcPubInfoService.findByArcName(arcName);
		}
	}

	@RequestMapping("/add")
	@ResponseBody
	public void addArcPubInfo() {
		ArcPubInfoEntity arcPubInfoEntity = new ArcPubInfoEntity();
		/* arcPubInfoEntity.setArcId("123"); */
		arcPubInfoEntity.setArcName("文档");
		/*
		 * arcPubInfoService.addArcPubInfo(arcPubInfoEntity);
		 */arcPubInfoService
				.deleteArcPubInfo("8a814ff959200d9f015920130af50000");
	}

	/**
	 * 
	 * TODO: 归档按钮（修改归档状态） TODO: 填入方法说明
	 * 
	 * @param arcId
	 * @return
	 */
	@RequestMapping("/doUpdateFileStartByArcId")
	@ResponseBody
	public String doUpdateFileStartByArcId(
			@RequestParam(value = "arcId", defaultValue = "") String arcId) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			return arcPubInfoService.doUpdateFileStartByArcId(arcId,user);
		}
		return "";
	}

	/**
	 * 
	 * TODO: 通过档案Id修改归档状态（修改归档状态,针对附件可追加上传）——追加归档 TODO: 填入方法说明
	 * 
	 * @param arcId
	 * @return
	 */
	@RequestMapping("/doAddFileUpdateFileStartByArcId")
	@ResponseBody
	public String doAddFileUpdateFileStartByArcId(
			@RequestParam(value = "arcId", defaultValue = "") String arcId) {
		return arcPubInfoService.doAddFileUpdateFileStartByArcId(arcId);
	}

	/**
	 * 
	 * TODO: 通过档案Id删除档案信息 TODO: 填入方法说明
	 * 
	 * @param arcId
	 * @return
	 */
	@RequestMapping("/doDelArcInfoByArcId")
	@ResponseBody
	public String doDelArcInfoByArcId(
			@RequestParam(value = "arcId", defaultValue = "") String arcId) {
		return arcPubInfoService.doDelArcInfoByArcId(arcId);
	}

	/**
	 * 
	 * TODO: 通过档案Id设置档案作废 TODO: 填入方法说明
	 * 
	 * @param arcId
	 * @return
	 */
	@RequestMapping("/doInvArcInfoByArcId")
	@ResponseBody
	public String doInvArcInfoByArcId(
			@RequestParam(value = "arcId", defaultValue = "") String arcId) {
		return arcPubInfoService.doInvArcInfoByArcId(arcId);
	}

	/**
	 * 
	 * 根据arcid还原档案
	 * 
	 * @param arcId
	 * @return
	 */
	@RequestMapping("/doHuanyuanByArcId")
	@ResponseBody
	public Map<String, Object> doHuanyuanByArcId(
			@RequestParam(value = "arcId", defaultValue = "") String arcId) {
		Map<String, Object> resultMap = new HashMap<String, Object>();

		try {
			arcPubInfoService.doHuanyuanByArcId(arcId);
			resultMap.put("result", true);
		} catch (Exception e) {
			e.printStackTrace();
			resultMap.put("result", false);
			return resultMap;
		}
		return resultMap;
	}

	/**
	 * 分页查询已作废和到期的文档
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param arcMtgSummAll
	 * @return
	 */
	@RequestMapping("/arcList")
	@ResponseBody
	public TreeGridView<ArcPubInfoEntity> pageArcMtgSummEntity(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "arcName") String arcName,
			@RequestParam(value = "startTime") String startTime,
			@RequestParam(value = "endTime") String endTime) {
		TreeGridView<ArcPubInfoEntity> plist = new TreeGridView<ArcPubInfoEntity>();
		try {
			arcName = new String(arcName.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<ArcPubInfoEntity> pags = arcPubInfoService
					.pageArcPubInfoEntityList(pageNum, pageSize, arcName,
							startTime, endTime);
			List<ArcPubInfoEntity> list = pags.getResults();
			plist.setRows(list);
			plist.setTotal(pags.getTotalrecord());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return plist;
	}

	/**
	 * 分页查询文档
	 * @change zhangduoyi 添加档案类型参数
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @arcType arcType 
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	@RequestMapping("/arcPubInfoList")
	@ResponseBody
	public TreeGridView<ArcPubInfoEntity> pageArcPubInfoEntity(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "arcName") String arcName,
			@RequestParam(value = "arcType") String arcType,
			@RequestParam(value = "fileUser") String fileUser,
			@RequestParam(value = "fileDept") String fileDept,
			@RequestParam(value = "fileStartTime") String startTime,
			@RequestParam(value = "fileEndTime") String endTime,
			@RequestParam(value = "modCode") String modCode) {

		TreeGridView<ArcPubInfoEntity> plist = new TreeGridView<ArcPubInfoEntity>();
		try {
			arcName = new String(arcName.getBytes("iso-8859-1"), "utf-8");
			fileDept = new String(fileDept.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<ArcPubInfoEntity> pags = arcPubInfoService
					.pageArcPubInfoEntity(pageNum, pageSize, arcName, fileUser,
							fileDept,arcType, startTime, endTime, modCode);
			List<ArcPubInfoEntity> list = pags.getResults();
			for (ArcPubInfoEntity arcPubInfoEntity : list) {
				List<ArcTypeBean> findArcTypeInfoById = actTypeService
						.findArcTypeInfoById(arcPubInfoEntity.getArcType());
				User user = null;
				if (StringUtils.isNotEmpty(arcPubInfoEntity.getFileUser())) {
					user = iUserService.findUserById(arcPubInfoEntity
							.getFileUser());
					arcPubInfoEntity.setFileUser(user.getUserName());
				}
				if (findArcTypeInfoById != null) {
					arcPubInfoEntity.setArcTypeName(findArcTypeInfoById.get(0)
							.getTypeName());
				}
				if (arcPubInfoEntity.getFileDept() != null) {
					Dept findDeptById = deptService
							.findDeptById(arcPubInfoEntity.getFileDept());
					arcPubInfoEntity.setFileDept(findDeptById.getDeptName());
				}
			}
			plist.setRows(list);
			plist.setTotal(pags.getTotalrecord());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return plist;
	}
	/**
	 * 分页查询文档
	 * @change zhangduoyi 添加档案类型参数
	 * @param pageNum
	 * @param pageSize
	 * @param arcName
	 * @arcType arcType 
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	@RequestMapping("/arcPubInfoListPage")
	@ResponseBody
	public TreeGridView<ArcPubInfoBean> arcPubInfoListPage(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "arcName") String arcName,
			@RequestParam(value = "arcType") String arcType,
			@RequestParam(value = "fileUser") String fileUser,
			@RequestParam(value = "fileDept") String fileDept,
			@RequestParam(value = "fileStartTime") String startTime,
			@RequestParam(value = "fileEndTime") String endTime,
			@RequestParam(value = "modCode") String modCode,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder) {

		TreeGridView<ArcPubInfoBean> plist = new TreeGridView<ArcPubInfoBean>();
		try {
			arcName = new String(arcName.getBytes("iso-8859-1"), "utf-8");
			fileDept = new String(fileDept.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<ArcPubInfoBean> pags = arcPubInfoService
					.pageArcPubInfoEntity(pageNum, pageSize, arcName, fileUser,
							fileDept,arcType, startTime, endTime, modCode, sortName,sortOrder);
			List<ArcPubInfoBean> list = pags.getResults();
			for (ArcPubInfoBean arcPubInfoEntity : list) {
/*				List<ArcTypeBean> findArcTypeInfoById = actTypeService
						.findArcTypeInfoById(arcPubInfoEntity.getArcType());*/
				User user = null;
				if (StringUtils.isNotEmpty(arcPubInfoEntity.getFile_user())) {
					user = iUserService.findUserById(arcPubInfoEntity
							.getFile_user());
					arcPubInfoEntity.setFile_user(user.getUserName());
				}
			/*	if (findArcTypeInfoById != null) {
					arcPubInfoEntity.setArcTypeName(findArcTypeInfoById.get(0)
							.getTypeName());
				}*/
				if (arcPubInfoEntity.getFile_dept() != null) {
					Dept findDeptById = deptService
							.findDeptById(arcPubInfoEntity.getFile_dept());
					arcPubInfoEntity.setFile_dept(findDeptById.getDeptName());
				}
			}
			plist.setRows(list);
			plist.setTotal(pags.getTotalrecord());
		} catch (Exception e) {
			e.printStackTrace();
		}
		return plist;
	}
	@RequestMapping("/getArcTypeUrl")
	@ResponseBody
	public String getArcTypeUrl(
			@RequestParam(value = "id", defaultValue = "") String id) {
		String url = "";
		try {
			String path = getClass().getResource("/").getFile().toString()
					+ "arctype-url.properties";
			InputStream in = new BufferedInputStream(new FileInputStream(path));
			Properties p = new Properties();
			p.load(in);
			url = p.getProperty(id);
			in.close();

		} catch (IOException e) {
			e.printStackTrace();
		}
		return url.trim();
	}
}
