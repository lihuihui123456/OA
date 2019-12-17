package com.yonyou.aco.earc.ctlg.web;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import net.sf.json.JSONArray;
import net.sf.json.JSONObject;

import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.PropertiesLoader;





import com.yonyou.aco.earc.ctlg.entity.EarcCtlgEntity;
import com.yonyou.aco.earc.ctlg.entity.EarcCtlgTreeBean;
import com.yonyou.aco.earc.ctlg.service.IEarcCtlgService;
import com.yonyou.aco.earc.util.ExcelUtil;
import com.yonyou.aco.earc.util.NumberToChinese;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 电子档案目录控制层 TODO: 电子档案目录功能入口 例：增、删、改 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2017年4月18日
 * @author 贺国栋
 * @since 1.0.0
 */
@Controller
@RequestMapping("/earcCtlgController")
public class EarcCtlgController {

	@Resource
	IEarcCtlgService earcCtlgService;
	// 导出功能使用
	private List<Object> rowAll = new ArrayList<Object>();
	private List<String> row = new ArrayList<String>();

	/**
	 * 
	 * TODO: 档案目录管理主页
	 * 
	 * @return
	 */
	@RequestMapping("/gotoIndex")
	public ModelAndView toIndex() {
		ModelAndView mv = new ModelAndView();
		List<EarcCtlgTreeBean> list;
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user != null) {
			list = earcCtlgService.findCtlgInfoByUserId(user.getUserId());
		} else {
			list = new ArrayList<EarcCtlgTreeBean>();
		}
		mv.addObject("treeList", JSONArray.fromObject(list).toString());
		mv.setViewName("/aco/biz/earcmgr/earcctlg/ctlg-index");
		return mv;
	}
	@RequestMapping("/getTreeList")
	public void getTreeList(HttpServletRequest request,
			HttpServletResponse response) {
			List<EarcCtlgTreeBean> list;
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user != null) {
			list = earcCtlgService.findCtlgInfoByUserId(user.getUserId());
		} else {
			list = new ArrayList<EarcCtlgTreeBean>();
		}
		try {
			response.getWriter().print(JSONArray.fromObject(list).toString());
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 
	 * TODO: 添加档案目录信息
	 * 
	 * @param acEntity
	 * @return
	 */
	@RequestMapping("/doAddCtlgInfo")
	@ResponseBody
	public String doAddCtlgInfo(@Valid EarcCtlgEntity acEntity) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user != null) {
			acEntity.setDATA_DEPT_CODE(user.getDeptCode());
			acEntity.setDATA_DEPT_ID(user.getDeptId());
			acEntity.setDATA_ORG_ID(user.getOrgid());
			acEntity.setDATA_USER_ID(user.getUserId());
			acEntity.setDR("N");
			if (StringUtils.isNotBlank(acEntity.getID_())) {
				EarcCtlgEntity findCtlgInfoByPk = earcCtlgService.findCtlgInfoByPk(acEntity.getID_());
				acEntity.setORDER_BY(findCtlgInfoByPk.getORDER_BY());
				earcCtlgService.doUpdateCtlgInfo(acEntity);
			} else {
				//获取排序字段最大值
				acEntity.setID_(null);
				String maxOrderBy=earcCtlgService.getMaxOrderBy(acEntity);
				int orderBy=0;
				if(StringUtils.isNotBlank(maxOrderBy)){
					orderBy=Integer.parseInt(maxOrderBy)+1;
				}
				acEntity.setORDER_BY(orderBy+"");
				earcCtlgService.doAddCtlgInfo(acEntity);
			}
			return "0";
		} else {
			return "1";
		}
	}

	/**
	 * 
	 * TODO: 通过用户Id获取档案目录信息
	 * 
	 * @return
	 */
	@RequestMapping("/findCtlgDataByUserId")
	@ResponseBody
	public List<EarcCtlgTreeBean> findCtlgDataByUserId() {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<EarcCtlgTreeBean> list;
		if (user != null) {
			list = earcCtlgService.findCtlgInfoByUserId(user.getUserId());
		} else {
			list = new ArrayList<EarcCtlgTreeBean>();
		}
		return list;
	}
	/**
	 * 
	 * TODO: 通过用户Id获取档案目录信息
	 * 
	 * @return
	 */
	@RequestMapping("/findCtlgDataListByUserId")
	@ResponseBody
	public List<EarcCtlgTreeBean> findCtlgDataListByUserId(			
			@RequestParam(value = "id", defaultValue = "") String id) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<EarcCtlgTreeBean> list=new ArrayList<EarcCtlgTreeBean>();
		List<EarcCtlgTreeBean> listRes=new ArrayList<EarcCtlgTreeBean>();
		if (user != null) {
			list = earcCtlgService.findCtlgInfoByUserId(user.getUserId());
		} else {
			list = new ArrayList<EarcCtlgTreeBean>();
		}
		listRes=list;
		if(!StringUtils.isBlank(id)){
			findChildLink(id);
			List<String> listChild=this.listResult;
/*			listChild.add(id);
*/			this.listResult=new ArrayList<String>();
			for(int i=0; i<list.size(); i++){
				for(int j=0; j<listChild.size(); j++){
					if(list.get(i).getId().equals(listChild.get(j))){
						listRes.remove(list.get(i));
					}
				}
			}
		}
		
		return listRes;
	}
	/**
	 * 
	 * TODO: 多条件分页获取档案目管理需信息
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param ctlgId
	 * @param ctlgName
	 * @param sortName
	 * @param sortOrder
	 * @return
	 */
	@RequestMapping("/findArcCtlgDataByCtlgId")
	@ResponseBody
	public Map<String, Object> findArcCtlgDataByCtlgId(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "ctlgId", defaultValue = "") String ctlgId,
			@RequestParam(value = "ctlgName", defaultValue = "") String ctlgName,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder) {
		try {
			ctlgName = new String(ctlgName.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<EarcCtlgEntity> pags = earcCtlgService
					.findArcCtlgDataByCtlgId(pageNum, pageSize, ctlgId,
							ctlgName, sortName, sortOrder);
			map.put("total", pags.getTotalrecord());
			map.put("rows", pags.getResults());
			return map;
		} catch (Exception e) {
			return null;
		}

	}

	/**
	 * 
	 * TODO: 通过ID删除档案目录信息
	 * 
	 * @param selectionIds
	 * @return
	 */
	@RequestMapping("/doDelCtlgDataByCtlgId")
	@ResponseBody
	public String doDelCtlgDataByCtlgId(
			@RequestParam(value = "Ids", defaultValue = "") String Ids) {
		String[] idArr = Ids.split(",");
		String res = "";
		for (int i = 0; i < idArr.length; i++) {
			res = earcCtlgService.doDelCtlgDataById(idArr[i]);
		}
		return res;
	}

	/**
	 * 
	 * TODO: 通过目录ID判断当前目录是否是父目录
	 * 
	 * @param Id
	 * @return
	 */
	@RequestMapping("/isCtlgParent")
	@ResponseBody
	public String isCtlgParent(
			@RequestParam(value = "Ids", defaultValue = "") String Ids) {
		String[] idArr = Ids.split(",");
		String res = "";
		List<String> list = new ArrayList<String>();
		for (int i = 0; i < idArr.length; i++) {
			res = earcCtlgService.isCtlgParent(idArr[i]);
			list.add(res);
		}
		if (list != null && list.size() > 0) {
			if (list.contains("1")) {
				res = "1";
			} else {
				res = "0";
			}
		}
		return res;
	}

	/**
	 * 
	 * TODO: 通过ID获取档案目录信息
	 * 
	 * @param ctlgId
	 * @return
	 */
	@RequestMapping("/findCtlgInfoByCtlgId")
	@ResponseBody
	public EarcCtlgEntity findCtlgInfoByCtlgId(
			@RequestParam(value = "ctlgId", defaultValue = "") String ctlgId) {
		return earcCtlgService.findCtlgInfoByCtlgId(ctlgId);
	}

	/**
	 * 
	 * @param request
	 * @param response
	 * @param flag 1:导出 2：打印
	 *            查询条件
	 */
	@SuppressWarnings("unchecked")
	@RequestMapping("/exportExcel")
	@ResponseBody
	public void exportExcel(HttpServletRequest request,
			HttpServletResponse response,
			@RequestParam(value = "flag", defaultValue = "") String flag) {
		try {// 递归
			rowAll = new ArrayList<Object>();
			row = new ArrayList<String>();
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			List<EarcCtlgTreeBean> list = earcCtlgService
					.findCtlgInfoByUserId(user.getUserId());
			List<String> listNumOne = new ArrayList<String>();
			for (EarcCtlgTreeBean arcCtlgTreeBean : list) {
		/*		if (StringUtils.isBlank(arcCtlgTreeBean.getpId())
						|| "0".equalsIgnoreCase(arcCtlgTreeBean.getpId())) {
					listNumOne.add(arcCtlgTreeBean.getId());
				}*/
				if (StringUtils.isBlank(arcCtlgTreeBean.getpId())) {
					listNumOne.add(arcCtlgTreeBean.getId());
				}
			}
			for (String str : listNumOne) {
				getLowest(str, 0);
			}
			for (String str : row) {
				List<String> findRowResult = findRowResult(str);
				rowAll.add(findRowResult);
				listResult1 = new ArrayList<String>();
			}
			int maxNum = 0;
			List<Object> rowAllCopy = new ArrayList<Object>();
			rowAllCopy = rowAll;
			// 计算高树级数和对集合排序（由高到低）

			for (int j = 0; j < rowAll.size(); j++) {
				List<String> listSort = new ArrayList<String>();
				List<String> rst = (List<String>) rowAll.get(j);
				if (rst.size() > maxNum) {
					maxNum = rst.size();
				}
				for (int i = rst.size() - 1; i >= 0; i--) {
					if (i != 0) {
						// 除了最低树层其他用name显示
						EarcCtlgEntity findCtlgInfoByCtlgId = earcCtlgService
								.findCtlgInfoByCtlgId(rst.get(i));
						listSort.add(findCtlgInfoByCtlgId.getEARC_CTLG_NAME());
					} else {
						listSort.add(rst.get(i));
					}

				}
				rst = listSort;
				rowAllCopy.set(j, rst);
			}
			// 不够处添加空格和添加创建人和时间
			for (int j = 0; j < rowAll.size(); j++) {
				List<String> rst = (List<String>) rowAll.get(j);
				EarcCtlgEntity findCtlgInfoByCtlgId = earcCtlgService
						.findCtlgInfoByCtlgId(rst.get(rst.size() - 1));
				rst.set(rst.size() - 1, findCtlgInfoByCtlgId.getEARC_CTLG_NAME());
				for (int i = rst.size(); i < maxNum; i++) {
					rst.add("");
				}
				rst.add(findCtlgInfoByCtlgId.getCREATE_USER_NAME());
				rst.add(findCtlgInfoByCtlgId.getCREATE_TIME());
				rowAllCopy.set(j, rst);
			}
			List<String> columnNames = new ArrayList<String>();
			for (int i = 0; i < maxNum; i++) {
				String str=NumberToChinese.numberToChinese(i+1);
				columnNames.add(str + "级分类");
			}
			columnNames.add("创建人");
			columnNames.add("创建时间");
			HSSFWorkbook workbook = null;
			workbook = ExcelUtil.generateExcelFile(rowAllCopy, columnNames);
			String filename = "档案目录";
			if("1".equalsIgnoreCase(flag)){	
			OutputStream ops = response.getOutputStream();
			workbook.write(ops);
			String agent = request.getHeader("USER-AGENT");
			if (null != agent && -1 != agent.indexOf("MSIE") || null != agent
					&& -1 != agent.indexOf("Trident")) {// ie

				String name = java.net.URLEncoder.encode(filename, "UTF8");

				filename = name;
			} else if (null != agent && -1 != agent.indexOf("Mozilla")) {// 火狐,chrome等
				filename = new String(filename.getBytes("UTF-8"), "iso-8859-1");
			}
			response.setContentType("text/html");
			response.setHeader("Content-Disposition", "attachment;filename="
					+ filename + ".xls");

			ops.close();	
			}else{
				String ftlPath = new PropertiesLoader("config.properties").getProperty("rootPath");
				File f=new File(ftlPath + "/excel/");
				if(!f.exists()){
					f.mkdirs();
					} 
				File outFile = new File(ftlPath + "/excel/" + filename + ".xls"); // 导出文件
			    FileOutputStream out = new FileOutputStream(outFile); 
				workbook.write(out);
				out.flush();
				out.close();
				JSONObject json = new JSONObject();
				json.put("filename", filename);
				response.setContentType("text/xml;charset=utf-8");
				json.toString().getBytes("utf-8");
				response.getWriter().print(json);
				response.getWriter().flush();
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	/**
	 * 跳转至文本编辑页面，并初始化一些文本编辑页面所需要的基本数据
	 * fileType：文件类型
	 * UserName：用户名称；editType：文本编辑类型
	 * 
	 * @param request
	 * @return
	 */
	@RequestMapping("/openExcel")
	public ModelAndView toDocumentEdit(HttpServletRequest request) {
		String mFileType = request.getParameter("fileType");
		String mFileName = request.getParameter("mFileName");
		String newmFileName = "";
		try {
			newmFileName = new String(mFileName.getBytes("ISO-8859-1"),"UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		ModelAndView mv = new ModelAndView();
		// 自动获取OfficeServer和OCX文件完整URL路径
		String mHttpUrlName = request.getRequestURI();
		String mScriptName = request.getServletPath();
		String mServerName = "OfficeServer";
		String mServerUrl = "http://"
				+ request.getServerName() + ":" + request.getServerPort()
				+ mHttpUrlName.substring(0, mHttpUrlName.lastIndexOf(mScriptName)) + "/"
				+ mServerName+"?encryption=0";// 取得OfficeServer文件的完整URL

		// 设置文档类型初始值
		if (mFileType == null || "".equals(mFileType)) {
			mFileType = ".xls";
		}
		String filePath = new PropertiesLoader("config.properties").getProperty("rootPath");
		String mFilePath=filePath+"/excel/";
		mv.addObject("mFilePath", mFilePath);
		boolean mIsMax = true;
		mFileName = newmFileName + mFileType; // 取得完整的文档名称
		mv.addObject("mServerUrl", mServerUrl);
		mv.addObject("mFileName", mFileName);
		if(user != null){
			mv.addObject("mUserName", user.name);
		}
		mv.addObject("mFilePath", mFilePath);
		mv.addObject("mEditType", "0");
		mv.addObject("mIsMax", mIsMax);
		mv.addObject("mFileType", mFileType);
		mv.addObject("encryption", "0");
		mv.setViewName("/aco/biz/earcmgr/earcctlg/earcDocumentEdit");
		return mv;
	}
	/**
	 * 获取最低节点id,封装到row集合
	 */
	@SuppressWarnings("unused")
	private int getLowest(String prtId, int num) {
		// 获取子节点
		List<String> list = findChild(prtId);
		if (list.size() == 0) {
			EarcCtlgEntity findCtlgInfoByCtlgId = earcCtlgService
					.findCtlgInfoByCtlgId(prtId);
			row.add(prtId);
		} else {
			for (int i = 0; i < list.size(); i++) {
				getLowest(list.get(i), num++);
			}

		}
		return num;
	}

	/* 查询节点的孩子节点 */
	public List<String> findChild(String prtId) {
		List<String> listResult = new ArrayList<String>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<EarcCtlgTreeBean> list = earcCtlgService.findCtlgInfoByUserId(user
				.getUserId());
		for (EarcCtlgTreeBean arcCtlgTreeBean : list) {
			if (prtId.equalsIgnoreCase(arcCtlgTreeBean.getpId())) {
				listResult.add(arcCtlgTreeBean.getId());
			}
		}
		return listResult;
	}

	private List<String> listResult1 = new ArrayList<String>();

	/* 获取从低到高的几个父子联系节点用来导出Excel */
	public List<String> findRowResult(String childId) {
		EarcCtlgEntity findCtlgInfoByCtlgId = earcCtlgService
				.findCtlgInfoByCtlgId(childId);
		listResult1.add(findCtlgInfoByCtlgId.getID_());
		EarcCtlgTreeBean findParent = findParent(findCtlgInfoByCtlgId
				.getPARENT_ID());
		if (findParent != null) {
			findRowResult(findParent.getId());
		}
		return listResult1;
	}

	/* 判断节点是否为最高节点 如果不是返回当前节点*/
	public EarcCtlgTreeBean findParent(String childId) {
		if ("0".equalsIgnoreCase(childId)) {
			return null;
		}
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<EarcCtlgTreeBean> list = earcCtlgService.findCtlgInfoByUserId(user
				.getUserId());
		for (EarcCtlgTreeBean arcCtlgTreeBean : list) {
			if (childId.equalsIgnoreCase(arcCtlgTreeBean.getId())) {
				return arcCtlgTreeBean;
			}
		}
		return null;
	}
	/**
	 * 换位排序
	 * @param idUp 换位后在上的类型
	 * @param idDown 换位后在下的类型
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/orderByTypeBase")
	public String orderByTypeBase(
			@RequestParam(value = "id", defaultValue = "") String id,
			@RequestParam(value = "upOrdown", defaultValue = "") String upOrdown){
		//
		EarcCtlgEntity findCtlgInfo = earcCtlgService.findCtlgInfoByPk(id);
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
       if("up".equalsIgnoreCase(upOrdown)){
    	   //判断节点是否有父节点
    	      if("0".equalsIgnoreCase(findCtlgInfo.getPARENT_ID())){
   			List<EarcCtlgTreeBean> list = earcCtlgService
					.findCtlgInfoByUserId(user.getUserId());
			List<String> listNumOne = new ArrayList<String>();
			for (EarcCtlgTreeBean arcCtlgTreeBean : list) {
				if (StringUtils.isBlank(arcCtlgTreeBean.getpId())
						|| "0".equalsIgnoreCase(arcCtlgTreeBean.getpId())) {
					listNumOne.add(arcCtlgTreeBean.getId());
				}
			}
			//获取当前节点同级但是在它上的节点
			for(int i=0;i<listNumOne.size();i++){
				if(id.equals(listNumOne.get(i))){
					if(i==0){
						//证明节点时树的最高点
						return "0";
					}else{
						EarcCtlgEntity findCtlgInfoByCtlgId = earcCtlgService.findCtlgInfoByPk(id);
						EarcCtlgEntity findCtlgInfoByCtlgIdUp = earcCtlgService.findCtlgInfoByPk(listNumOne.get(i-1));
                        String orederBy=findCtlgInfoByCtlgId.getORDER_BY();
                        findCtlgInfoByCtlgId.setORDER_BY(findCtlgInfoByCtlgIdUp.getORDER_BY());
                        findCtlgInfoByCtlgIdUp.setORDER_BY(orederBy);
						earcCtlgService.doUpdateCtlgInfo(findCtlgInfoByCtlgId);
						earcCtlgService.doUpdateCtlgInfo(findCtlgInfoByCtlgIdUp);
					}
				}
			}
    	   }
    	   else{//非最高一层节点，通过父节点获取同层节点
    		   List<String> findChild = this.findChild(findCtlgInfo.getPARENT_ID());
   			//获取当前节点同级但是在它上的节点
   			for(int i=0;i<findChild.size();i++){
   				if(id.equals(findChild.get(i))){
   					if(i==0){
   						//证明节点时树的最高点
   						return "0";
   					}else{
   						EarcCtlgEntity findCtlgInfoByCtlgId = earcCtlgService.findCtlgInfoByPk(id);
   						EarcCtlgEntity findCtlgInfoByCtlgIdUp = earcCtlgService.findCtlgInfoByPk(findChild.get(i-1));
                           String orederBy=findCtlgInfoByCtlgId.getORDER_BY();
                           findCtlgInfoByCtlgId.setORDER_BY(findCtlgInfoByCtlgIdUp.getORDER_BY());
                           findCtlgInfoByCtlgIdUp.setORDER_BY(orederBy);
   						earcCtlgService.doUpdateCtlgInfo(findCtlgInfoByCtlgId);
   						earcCtlgService.doUpdateCtlgInfo(findCtlgInfoByCtlgIdUp);
   					}
   				}
   			}
    	   }
       }
       else if("down".equalsIgnoreCase(upOrdown)){
    	   //判断节点是否有父节点
  	      if("0".equalsIgnoreCase(findCtlgInfo.getPARENT_ID())){
   			List<EarcCtlgTreeBean> list = earcCtlgService
					.findCtlgInfoByUserId(user.getUserId());
			List<String> listNumOne = new ArrayList<String>();
			for (EarcCtlgTreeBean arcCtlgTreeBean : list) {
				if (StringUtils.isBlank(arcCtlgTreeBean.getpId())
						|| "0".equalsIgnoreCase(arcCtlgTreeBean.getpId())) {
					listNumOne.add(arcCtlgTreeBean.getId());
				}
			}
			//获取当前节点同级但是在它下的节点
			for(int i=0;i<listNumOne.size();i++){
				if(id.equals(listNumOne.get(i))){
					if(i==listNumOne.size()-1){
						//证明节点时树的最低点
						return "1";
					}else{
						EarcCtlgEntity findCtlgInfoByCtlgId = earcCtlgService.findCtlgInfoByPk(id);
						EarcCtlgEntity findCtlgInfoByCtlgIdUp = earcCtlgService.findCtlgInfoByPk(listNumOne.get(i+1));
                        String orederBy=findCtlgInfoByCtlgId.getORDER_BY();
                        findCtlgInfoByCtlgId.setORDER_BY(findCtlgInfoByCtlgIdUp.getORDER_BY());
                        findCtlgInfoByCtlgIdUp.setORDER_BY(orederBy);
						earcCtlgService.doUpdateCtlgInfo(findCtlgInfoByCtlgId);
						earcCtlgService.doUpdateCtlgInfo(findCtlgInfoByCtlgIdUp);
					}
				}
			}
    	   }
    	   else{//非最高一层节点
    		   List<String> findChild = this.findChild(findCtlgInfo.getPARENT_ID());
   			//获取当前节点同级但是在它上的节点
   			for(int i=0;i<findChild.size();i++){
   				if(id.equals(findChild.get(i))){
   					if(i==findChild.size()-1){
						//证明节点时树的最低点
						return "1";
					}else{
   						EarcCtlgEntity findCtlgInfoByCtlgId = earcCtlgService.findCtlgInfoByPk(id);
   						EarcCtlgEntity findCtlgInfoByCtlgIdUp = earcCtlgService.findCtlgInfoByPk(findChild.get(i+1));
                           String orederBy=findCtlgInfoByCtlgId.getORDER_BY();
                           findCtlgInfoByCtlgId.setORDER_BY(findCtlgInfoByCtlgIdUp.getORDER_BY());
                           findCtlgInfoByCtlgIdUp.setORDER_BY(orederBy);
   						earcCtlgService.doUpdateCtlgInfo(findCtlgInfoByCtlgId);
   						earcCtlgService.doUpdateCtlgInfo(findCtlgInfoByCtlgIdUp);
   					}
   				}
   			}
    	   }
       }
		return "true";
	}
	//递归查询节点下的所有子节点和删除一个节点
	private List<String> listResult=new ArrayList<String>();
	public void findChildLink(String prtId){
		 List<EarcCtlgTreeBean> listResult1=new ArrayList<EarcCtlgTreeBean>();

		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		List<EarcCtlgTreeBean> list = earcCtlgService.findCtlgInfoByUserId(user
				.getUserId());
		for (EarcCtlgTreeBean arcCtlgTreeBean : list) {
			
			if (prtId.equalsIgnoreCase(arcCtlgTreeBean.getpId())) {
				listResult1.add(arcCtlgTreeBean);
			}
		}	
		if(listResult1.size()>=1){
			listResult.add(prtId);
			for(EarcCtlgTreeBean arcCtlgTreeBean1 : listResult1){
				findChildLink(arcCtlgTreeBean1.getId());
			}
		}
		else{
			listResult.add(prtId);
			return;
		}
	}
}
