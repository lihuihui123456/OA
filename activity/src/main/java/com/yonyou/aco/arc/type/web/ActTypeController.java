package com.yonyou.aco.arc.type.web;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.HttpServletResponse;
import javax.validation.Valid;

import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import com.yonyou.aco.arc.type.entity.ArcTypeBean;
import com.yonyou.aco.arc.type.entity.ArcTypeEntity;
import com.yonyou.aco.arc.type.service.IActTypeService;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * 
 * TODO: 类型Controller TODO: 档案类型controller入口 历史记录: Date, Author, Descriptions
 * ---------------------------------------------------------
 * 
 * @Date 2016年12月21日
 * @author hegd
 * @since 1.0.0
 */
@Controller
@RequestMapping("/actTypeController")
public class ActTypeController {

	@Autowired
	IActTypeService actTypeService;

	/**
	 * 
	 * TODO: 档案管理类型主页
	 * 
	 * @return
	 */
	@RequestMapping("/goToIndex")
	@ResponseBody
	public ModelAndView goToIndex() {
		ModelAndView mv = new ModelAndView();
		StringBuffer sb = new StringBuffer("[");
		List<ArcTypeEntity> list = new ArrayList<ArcTypeEntity>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			list = actTypeService.findTypeFolderList(user.id);
			ArcTypeEntity arcTypeEntity=new ArcTypeEntity();
			arcTypeEntity.setId("123456");
			arcTypeEntity.setTypeName("所有文件");
			arcTypeEntity.setPrntId("");
			arcTypeEntity.setArcType("");
			list.add(0, arcTypeEntity);
			// 形成树
			if (list != null && list.size() > 0) {
				for (int i = 0; i < list.size(); i++) {			
					ArcTypeEntity folder = list.get(i);
					if(!"123456".equalsIgnoreCase(folder.getId())){
						folder.setPrntId("123456");	
					}				
					sb.append("{'id':'").append(folder.getId() + "'");
					sb.append(",'name':'").append(folder.getTypeName() + "'");
					sb.append(",'type':'").append("1234" + "'");
					sb.append(",'pId':'").append(folder.getPrntId() + "'}");
					if (i != list.size() - 1) {
						sb.append(",");
					}
				}
			}
			sb.append("]");
			mv.addObject("treeList", sb);
		}
		mv.setViewName( "/aco/arc/arctype/arctype-list");
		return mv;
	}

	/**
	 * 
	 * TODO: 获取所有档案类型
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param typeName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findAllArcTypeData")
	public Map<String, Object> findAllArcTypeData(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "typeName", defaultValue = "") String typeName,
			@RequestParam(value = "creUser", defaultValue = "") String creUser,
			@RequestParam(value = "startTime", defaultValue = "") String startTime,
			@RequestParam(value = "endTime", defaultValue = "") String endTime,
			@RequestParam(value = "remark", defaultValue = "") String remark,
			@RequestParam(value = "typeId", defaultValue = "") String typeId
			) {
		try {
			typeName = new String(typeName.getBytes("iso-8859-1"), "utf-8");
			creUser = new String(creUser.getBytes("iso-8859-1"), "utf-8");
			remark = new String(remark.getBytes("iso-8859-1"), "utf-8");

			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			Map<String, Object> map = new HashMap<String, Object>();
			PageResult<ArcTypeBean> pags;
			pags = actTypeService.findAllArcTypeData(pageNum, pageSize,
					typeName,creUser,startTime,endTime,remark,typeId);
			map.put("total", pags.getTotalrecord());
			map.put("rows", pags.getResults());
			return map;
		} catch (Exception e) {
			return null;
		}
	}

	/**
	 * 
	 * TODO: 获取所有档案类型
	 * 
	 * @param pageNum
	 * @param pageSize
	 * @param typeName
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/findArcTypeInfo")
	public List<ArcTypeEntity> findArcTypeInfo() {
		return actTypeService.findArcTypeInfo();
	}

	/**
	 * 
	 * TODO: 添加档案管理类型信息
	 * 
	 * @param atEntity
	 * @param response
	 * @throws IOException
	 */
	@RequestMapping("/doAddArcTypeInfo")
	public void doAddArcTypeInfo(@Valid ArcTypeEntity atEntity,
			HttpServletResponse response) throws IOException {
		try {
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject()
					.getPrincipal();
			String id = atEntity.getId();
			if (StringUtils.isEmpty(id) && user != null) {
				String userId = user.getUserId();
				Date carDate = new Date();
				atEntity.setId(null);
				atEntity.setCreTime(carDate);
				atEntity.setDataDeptCode(user.getDeptCode());
				atEntity.setDr("N");
				atEntity.setDataOrgId(user.getOrgid());
				atEntity.setDataUserId(userId);
				atEntity.setPrntId(atEntity.getPrntId());
				atEntity.setHref(atEntity.getHref());
				atEntity.setArcType("1");
				atEntity.setIsPrnt("N");
				//设置orderby属性
				String maxOrderBy=actTypeService.selectMaxOrderBy();
				atEntity.setOrderBy(Integer.parseInt(maxOrderBy)+1);
				actTypeService.doAddArcTypeInfo(atEntity);
				//添加配置文件配置
				String  url=getProperTy(atEntity.getPrntId());
				setProperty(atEntity.getId(), url);
			}else{
				ArcTypeEntity arcTypeEntity = actTypeService.selectArcTypeInfoById(id);
				arcTypeEntity.setHref(atEntity.getHref());
				arcTypeEntity.setTypeName(atEntity.getTypeName());
		/*		String userId = user.getUserId();
				Date carDate = new Date();
				atEntity.setCreTime(carDate);
				atEntity.setDataDeptCode(user.getDeptCode());
				atEntity.setDr("N");
				atEntity.setDataOrgId(user.getOrgid());
				atEntity.setDataUserId(userId);*/
				actTypeService.doUpdateArcTypeInfo(arcTypeEntity);
			}
			response.getWriter().write("true");
			response.getWriter().flush();
		} catch (IOException e) {
			e.printStackTrace();
			response.getWriter().write("false");
			response.getWriter().flush();
		}
	}

	/**
	 * 方法: 跳转到文件夹列表. 说明: 填入方法说明
	 * 
	 * @return
	 */
	@RequestMapping("/toArcDocTree")
	public ModelAndView toArcDocTree() {

		ModelAndView mv = new ModelAndView();
		StringBuffer sb = new StringBuffer("[");
		List<ArcTypeEntity> list = new ArrayList<ArcTypeEntity>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			list = actTypeService.findFolderList(user.id);
		}
		// 形成树
		if (list != null && list.size() > 0) {
			for (int i = 0; i < list.size(); i++) {
				ArcTypeEntity folder = list.get(i);
				sb.append("{'id':'").append(folder.getId() + "'");
				sb.append(",'href':'").append(folder.getHref() + "'");
				sb.append(",'name':'").append(folder.getTypeName() + "'");
				sb.append(",'pId':'").append(folder.getPrntId() + "'}");
				if (i != list.size() - 1) {
					sb.append(",");
				}
			}
		}
		sb.append("]");
		mv.addObject("treeList", sb);
		mv.setViewName("/aco/arc/arcdoc/folderContentMng");
		return mv;
	}

	@RequestMapping("/findArcTypeInfoById")
	@ResponseBody
	public List<ArcTypeBean> findArcTypeInfoById(
			@RequestParam(value = "Id", defaultValue = "") String Id) {
		List<ArcTypeBean> list = null;
		if(StringUtils.isNotEmpty(Id)){
			list = actTypeService.findArcTypeInfoById(Id);
		}else{
			list = actTypeService.findAllParentArcTypeData();
		}
		return list;
	}
	
	@RequestMapping("/doDelArcTypeById")
	@ResponseBody
	public String doDelArcTypeById(
			@RequestParam(value = "Id", defaultValue = "") String Id) {
		String flag = actTypeService.validate(Id);
		String res = "";
		if(flag == "Y"){
			res =actTypeService.doDelArcTypeById(Id);
			delProperty(Id);
		}
		return res;
	}
	public void setProperty(String key, String value){
        ///保存属性到b.properties文件
		String path = getClass().getResource("/").getFile().toString()
				+ "arctype-url.properties";
		     InputStream in;
			try {
				in = new BufferedInputStream(new FileInputStream(path));
			     Properties p = new Properties();
			     p.load(in);
			     in.close();
	             FileOutputStream oFile = new FileOutputStream(path, false);//true表示追加打开
	             p.setProperty(key, value);
	             p.store(oFile, "The New properties file");
	             oFile.close();           
			} catch (Exception e) {
				e.printStackTrace();
			}
	
	}
	public String getProperTy(String key){
		String path = getClass().getResource("/").getFile().toString()
				+ "arctype-url.properties";
		     InputStream in;
		     String url="";
		 	try {
				in = new BufferedInputStream(new FileInputStream(path));
			     Properties p = new Properties();
			     p.load(in);
			 	 url = p.getProperty(key);
				in.close();
			  
			} catch (Exception e) {
				e.printStackTrace();
			}
		 	  return url; 
	}
	public void delProperty(String key){
		 ///保存属性到b.properties文件
		String path = getClass().getResource("/").getFile().toString()
				+ "arctype-url.properties";
		     InputStream in;
			try {
				in = new BufferedInputStream(new FileInputStream(path));
			     Properties p = new Properties();
			     p.load(in);
			     in.close();
	             FileOutputStream oFile = new FileOutputStream(path, false);//true表示追加打开
	             p.remove(key);
	             p.store(oFile, "The New properties file");
	             oFile.close();           
			} catch (Exception e) {
				e.printStackTrace();
			}
	
	}
	/**
	 * 换位排序，当需要换位的类型在一页的开始或最后
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/orderByType")
	public String orderByType(	
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "firstOrLast", defaultValue = "") String firstOrLast,
			@RequestParam(value = "typeId", defaultValue = "") String typeId,
			@RequestParam(value = "id", defaultValue = "") String id){
		    if (pageNum != 0) {
			  pageNum = pageNum / pageSize;
		    }
		pageNum++;
		    PageResult<ArcTypeBean> pags=null;
		if("first".equalsIgnoreCase(firstOrLast)){
			pags = actTypeService.findAllArcTypeData(pageNum-1, pageSize,
					"",typeId);
			ArcTypeBean arcTypeBean = pags.getResults().get(pageSize-1);
			ArcTypeEntity arcTypeEntity=new ArcTypeEntity();
			arcTypeEntity = actTypeService.selectArcTypeInfoById(arcTypeBean.getId());
			arcTypeEntity.setOrderBy(arcTypeEntity.getOrderBy()+1);
			actTypeService.doUpdateArcTypeInfo(arcTypeEntity);
			arcTypeEntity = actTypeService.selectArcTypeInfoById(id);
			arcTypeEntity.setOrderBy(arcTypeEntity.getOrderBy()-1);
			actTypeService.doUpdateArcTypeInfo(arcTypeEntity);
			
		}
		else if("last".equalsIgnoreCase(firstOrLast)){
			pags = actTypeService.findAllArcTypeData(pageNum+1, pageSize,
					"",typeId);
			ArcTypeBean arcTypeBean = pags.getResults().get(0);
			ArcTypeEntity arcTypeEntity=new ArcTypeEntity();
			arcTypeEntity = actTypeService.selectArcTypeInfoById(arcTypeBean.getId());
			arcTypeEntity.setOrderBy(arcTypeEntity.getOrderBy()-1);
			actTypeService.doUpdateArcTypeInfo(arcTypeEntity);
			arcTypeEntity = actTypeService.selectArcTypeInfoById(id);
			arcTypeEntity.setOrderBy(arcTypeEntity.getOrderBy()+1);
			actTypeService.doUpdateArcTypeInfo(arcTypeEntity);
			
		}
		return "true";
	}
	/**
	 * 换位排序，当需要换位的类型在一页的中间
	 * @param idUp 换位后在上的类型
	 * @param idDown 换位后在下的类型
	 * @return
	 */
	@ResponseBody
	@RequestMapping(value = "/orderByTypeBase")
	public String orderByTypeBase(
			@RequestParam(value = "idUp", defaultValue = "") String idUp,
			@RequestParam(value = "idDown", defaultValue = "") String idDown){
		ArcTypeEntity  arcTypeEntity = actTypeService.selectArcTypeInfoById(idUp);
		ArcTypeEntity  arcTypeEntity1 = actTypeService.selectArcTypeInfoById(idDown);
		int orderBy=arcTypeEntity.getOrderBy();
		arcTypeEntity.setOrderBy(arcTypeEntity1.getOrderBy());
		arcTypeEntity1.setOrderBy(orderBy);
		actTypeService.doUpdateArcTypeInfo(arcTypeEntity);
		actTypeService.doUpdateArcTypeInfo(arcTypeEntity1);
		return "true";
	}

}
