package com.yonyou.aco.docmgt.web;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONObject;

import org.apache.shiro.SecurityUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springside.modules.utils.Identities;
import org.springside.modules.utils.PropertiesLoader;

import com.yonyou.aco.docmgt.entity.BizDocFolderEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoBean;
import com.yonyou.aco.docmgt.entity.BizDocInfoEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoRefMediaBean;
import com.yonyou.aco.docmgt.entity.BizDocInfoRefMediaEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoTypeEntity;
import com.yonyou.aco.docmgt.service.DocMgtService;
import com.yonyou.cap.bpm.entity.BpmRuBizInfoBean;
import com.yonyou.cap.bpm.service.IBpmRuBizInfoService;
import com.yonyou.cap.common.util.DateUtil;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.sys.iweboffice.entity.IWebDocumentEntity;
import com.yonyou.cap.sys.iweboffice.service.DocumentService;
/**
 * <p>概述：业务模块文档管理Controller层
 * <p>功能：实现文档管理的业务请求处理0
 * <p>作者：薛志超，葛鹏，李争辉
 * <p>创建时间：2016年11月1日
 * <p>类调用特殊情况：无
 */
@Controller
@RequestMapping("/docmgt")
public class DocMgtController {

	@Resource
	DocMgtService docMgtService;
	@Resource 
	IBpmRuBizInfoService bpmRuBizInfoService;
	@Resource
	DocumentService documentService;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 方法: 生成文件夹树
	 * 说明: 以{'id':'XXX',name:'XXX','pId':'XXX'}的格式传递到前台生成zTree树
	 * @return {'id':'XXX',name:'XXX','pId':'XXX'.....}
	 */
	@RequestMapping("/toMngFolderTree")
	public ModelAndView toMngFolderTree(){
		
		ModelAndView mv=new ModelAndView();
		StringBuffer sb = new StringBuffer("[");
		List<BizDocFolderEntity> list=new ArrayList<BizDocFolderEntity>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if(user != null){
			list=docMgtService.findFolderList(user.id);
		}
		List<BizDocFolderEntity> listfoot=new ArrayList<BizDocFolderEntity>();
		listfoot=docMgtService.findParentFolderList();
		list.addAll(listfoot);
		//形成树
		if(list != null && list.size()>0) {
			for(int i = 0;i < list.size();i++) {
				BizDocFolderEntity folder= list.get(i);
				sb.append("{'id':'").append(folder.getCatalogId()+"'");
				sb.append(",'name':'").append(folder.getCatalogName()+"'");
				sb.append(",'pId':'").append(folder.getParentCatalogId()+"'}");
				if (i != list.size() - 1) {
					sb.append(",");
				}
			}
		}
		sb.append("]");
		mv.addObject("treeList", sb);
		mv.setViewName("/aco/docmgt/mngFolderTree");
		return mv;
	}
	
	/**
	 * 方法: 保存归档信息.
	 * 说明: 将已办结置入归档信息中
	 * @param bizid 归档表业务主键
	 * @param folder_id 文件夹id
	 * @param checkval 保存内容
	 * @return 保存结果 result:success/error
	 */
	@RequestMapping("/doAddFolderInfo")
	public @ResponseBody String doAddFolderInfo(@RequestParam(value = "bizid",defaultValue = "") String bizid,
			@RequestParam(value = "id",defaultValue = "") String id){
		try{
			//String count="";
			String [] ids=id.substring(0,id.length()-1).split(",");
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			String []bizId=bizid.split(",");
			for(int i=0; i<bizId.length; i++){
				for(int j=0; j<ids.length; j++){
					//count=docMgtService.getDocTypeNum(ids[j]);
					//count=String.valueOf(Integer.parseInt(count)+1);
					BizDocInfoEntity bizDocInfoEntity=new BizDocInfoEntity();
					bizDocInfoEntity.setBizId(bizId[i]);
					if(user != null){
						bizDocInfoEntity.setPlaceUserId(user.getId());	
					}
					bizDocInfoEntity.setPlaceTime(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
					bizDocInfoEntity.setDocType(ids[j]);
					//docMgtService.setDocTypeNum(ids[j], count);
					docMgtService.doSaveDocInfo(bizDocInfoEntity);					
				}
				docMgtService.updateHasBelong(bizId[i],"1");
			}	
			return "{\"result\":\"success\"}";
		}catch(Exception e){
			logger.error("error",e);
			return "{\"result\":\"error\"}";
		}
	}
	/**
	 * 方法: 还原归档信息.
	 * 说明: 将归档文件还原为未归档
	 * @param bizid 归档表业务主键
	 * @param folder_id 文件夹id
	 * @return 保存结果 result:success/error
	 */
	@RequestMapping("/doDeleteFolderInfo")
	public @ResponseBody String doDeleteFolderInfo(@RequestParam(value = "bizid",defaultValue = "") String bizid,@RequestParam(value = "id",defaultValue = "") String id){
		try{
			//String count="";
/*			String [] ids=id.substring(0,id.length()-1).split(",");
*/			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			String []bizId=bizid.split(",");
			for(int i=0; i<bizId.length; i++){
				//删除BizDocInfoEntity
				BizDocInfoEntity bizDocInfoEntity=new BizDocInfoEntity();
				bizDocInfoEntity.setBizId(bizId[i]);
				if(user != null){
					bizDocInfoEntity.setPlaceUserId(user.getId());	
				}
				bizDocInfoEntity.setPlaceTime(DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss"));
				bizDocInfoEntity.setDocType(id);
				docMgtService.doDeleteDocInfo(bizDocInfoEntity);
				docMgtService.updateHasBelong(bizId[i],"0");
			}
			return "{\"result\":\"success\"}";
		}catch(Exception e){
			logger.error("error",e);
			return "{\"result\":\"error\"}";
		}
	}
	/**
	 * 方法: 个人文件夹树加载.
	 * @return 跳转
	 */
	@RequestMapping("/toFolderContentTree")
	public ModelAndView toFolderContentTree(){
		ModelAndView mv=new ModelAndView();
		try {
			
			StringBuffer sb = new StringBuffer("[");
			List<BizDocFolderEntity> list=new ArrayList<BizDocFolderEntity>();
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user!=null){
				list=docMgtService.findFolderList(user.id);
				List<BizDocFolderEntity> listfoot=new ArrayList<BizDocFolderEntity>();
				listfoot=docMgtService.findParentFolderList();
				list.addAll(listfoot);
				//形成树
				if(list != null && list.size()>0) {
					for(int i = 0;i < list.size();i++) {
						BizDocFolderEntity folder= (BizDocFolderEntity)list.get(i);
						sb.append("{'id':'").append(folder.getCatalogId()+"'");
						sb.append(",'name':'").append(folder.getCatalogName()+"'");
						sb.append(",'pId':'").append(folder.getParentCatalogId()+"'}");
						if (i != list.size() - 1) {
							sb.append(",");
						}
					}
				}
				sb.append("]");
			}
			mv.addObject("treeList", sb);
			mv.addObject("userId", user.getUserId());
			mv.setViewName("/aco/docmgt/folderContentMng");
		} catch (Exception e) {
			logger.error("error",e);
		}
		return mv;
		
	}
	
	/**
	 * 方法: 归档管理
	 * @return
	 */
	@RequestMapping("/toFolderContentTreePaper")
	public ModelAndView toFolderContentTreePaper(){
		ModelAndView mv=new ModelAndView();
		try {
			StringBuffer sb = new StringBuffer("[");
			List<BizDocInfoTypeEntity> list=new ArrayList<BizDocInfoTypeEntity>();
			list=docMgtService.findDocTypeList();
			List<BizDocInfoTypeEntity> listfoot=new ArrayList<BizDocInfoTypeEntity>();
			listfoot=docMgtService.findParentDocInfoList();
			list.addAll(listfoot);
			//形成树
			if(list != null && list.size()>0) {
				for(int i = 0;i < list.size();i++) {
					BizDocInfoTypeEntity folder= (BizDocInfoTypeEntity)list.get(i);
					sb.append("{'id':'").append(folder.getCatalogId()+"'");
					sb.append(",'name':'").append(folder.getCatalogName()+"'");
					//sb.append(",'open':'").append(true+"'");
					sb.append(",'pId':'").append(folder.getParentCatalogId()+"'}");
					if (i != list.size() - 1) {
						sb.append(",");
					}
				}
			}
			sb.append("]");
			mv.addObject("treeList", sb);
			mv.setViewName("/aco/docmgt/folderContentMngPaper");
		} catch (Exception e) {
			logger.error("error",e);
		}
		return mv;
	}
	/**
	 * 查询已办结未归档
	 * @param pageNum
	 * @param pageSize
	 * @param myArr 条件参数
	 * @return
	 */
	@RequestMapping("/findHasDone")
	@ResponseBody
	public TreeGridView<BpmRuBizInfoBean> findHasDone(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "query") String myArr
			){
		
		TreeGridView<BpmRuBizInfoBean> plist = new TreeGridView<BpmRuBizInfoBean>();
		try {	
			myArr=new String(myArr.getBytes("iso-8859-1"), "utf-8");
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		PageResult<BpmRuBizInfoBean> pags = docMgtService.findTaskHasDoList(pageNum, pageSize,myArr,sortName,sortOrder);
		plist.setRows(pags.getResults());
		plist.setTotal(pags.getTotalrecord());
		} catch (Exception e) {
			logger.error("error",e);
			}
		return plist;
	}
	/**
	 * 已归档
	 * @param pageNum
	 * @param pageSize
	 * @param myArr
	 * @return
	 */
	@RequestMapping("/findHasBelong")
	@ResponseBody
	public TreeGridView<BpmRuBizInfoBean> findHasBelong(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "query") String myArr,@RequestParam(value = "id") String id
			){
		TreeGridView<BpmRuBizInfoBean> plist = new TreeGridView<BpmRuBizInfoBean>();
		try {		
		//myArr=new String(myArr.getBytes("iso-8859-1"), "utf-8");
		if (pageNum != 0) {
			pageNum = pageNum / pageSize;
		}
		pageNum++;
		PageResult<BpmRuBizInfoBean> pags = docMgtService.findTaskHasBelongList(pageNum, pageSize,myArr,id, sortName, sortOrder);
		plist.setRows(pags.getResults());
		plist.setTotal(pags.getTotalrecord());
		} catch (Exception e) {
			logger.error("error",e);
		}
		return plist;
	}
	/**
	 * 方法: 当前节点下的文件信息
	 * 说明: 填入方法说明
	 * @param folder_id_
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	@RequestMapping("/findFolderContent")
	@ResponseBody
	public TreeGridView<BizDocInfoRefMediaBean> findFolderContent(
			@RequestParam(value = "folder_id_",defaultValue = "") String folder_id_,
			@RequestParam(value = "doc_type",defaultValue = "") String doc_type,
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "folder_name_",defaultValue = "") String folder_name_){
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		TreeGridView<BizDocInfoRefMediaBean> plist = new TreeGridView<BizDocInfoRefMediaBean>();
		try {
			folder_name_=new String(folder_name_.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			pageNum++;
			PageResult<BizDocInfoRefMediaBean> pags = docMgtService.findFolderContent(pageNum, pageSize,user.id,folder_id_,doc_type,folder_name_);
			plist.setRows(pags.getResults());
			plist.setTotal(pags.getTotalrecord());
		} catch (Exception ex) {
			logger.error("error",ex);
			return null;
		}
		return plist;
	}
	
	/**
	 * 方法: 填入方法概括.
	 * 说明: 查询归档公文
	 * @param folder_name_
	 * @param pageNum
	 * @param pageSize
	 * @return
	 */
	@RequestMapping("/findFolderContentPaper")
	@ResponseBody
	public TreeGridView<BizDocInfoBean> findFolderContentPaper(
			@RequestParam(value = "pageNum", defaultValue = "0") int pageNum,
			@RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
			@RequestParam(value = "folder_name_",defaultValue = "") String folder_name_) {
		
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		TreeGridView<BizDocInfoBean> plist = new TreeGridView<BizDocInfoBean>();
		try {
			folder_name_=new String(folder_name_.getBytes("iso-8859-1"), "utf-8");
			if (pageNum != 0) {
				pageNum = pageNum / pageSize;
			}
			if(user == null){
				return null;
			}
			pageNum++;
			PageResult<BizDocInfoBean> pags = docMgtService.findFolderContentPaper(pageNum, pageSize,user.id,folder_name_);
			plist.setRows(pags.getResults());
			plist.setTotal(pags.getTotalrecord());
		} catch (Exception ex) {
			logger.error("error",ex);
			return null;
		}
		return plist;
	}
	
	/**
	 * 方法: 列出正文和附件的相关信息.
	 * @param bizId代表归档id，用来查询biz真实的id
	 * @return 
	 */
	@RequestMapping("/toLoadMediaList")
	public ModelAndView toLoadMediaList(@RequestParam(value = "bizId") String bizId){
		ModelAndView mv = new ModelAndView();
		BizDocInfoBean bizDocInfoBean=docMgtService.selectDocInfo(bizId);
		//修改为根据公文id查询正文和附件
		List<IWebDocumentEntity> list = docMgtService.selectBiz(bizDocInfoBean.getBiz_id_());
		mv.addObject("list", list);
		mv.setViewName("/aco/docmgt/folderMediaList");
		return mv;
	}
	
	/**
	 * 方法: 跳转到节点新增页面.
	 * @return
	 */
	@RequestMapping("/toNewNodeInfo")
	public String toNewNodeInfo(){
		return "/aco/docmgt/newNodeInfo";
	}
	
	/**
	 * 方法: 保存文件夹信息.
	 * @param docFolder
	 * @return
	 */
	@RequestMapping("/addFolder")
	public @ResponseBody String addFolder(@RequestParam(value = "parentFolderId") String parentFolderId,
							@RequestParam(value = "folderName") String folderName){
		try{
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user == null){
				return "";
			}
			String maxId=docMgtService.findMaxNum(parentFolderId);
			maxId=String.valueOf(Integer.parseInt(maxId)+1);
			BizDocFolderEntity folder=new BizDocFolderEntity();
//			String name=new String(folderName.getBytes("iso-8859-1"), "utf-8");
			folder.setCatalogName(folderName);
			String number=docMgtService.getCatalogId(parentFolderId, maxId);
			folder.setCatalogId(number);
			folder.setUserId(user.id);
			BizDocFolderEntity parentEntity=docMgtService.getBizDocFolderEntity(parentFolderId);
			if(parentEntity.getCatalogType()==2){
				folder.setCatalogType(2);
			}else{
				folder.setCatalogType(0);
			}
			folder.setCreateTime(new Date());
			folder.setParentCatalogId(parentFolderId);
			docMgtService.doSaveFolder(folder);
			return number;
		}catch(Exception e){
			logger.error("error",e);
			return "";
			
		}
		
	}
	/**
	 * 修改节点名
	 * @param folderId
	 * @param folderName
	 */
	@RequestMapping("/modifyFolder")
	public void doModifyFolder(@RequestParam(value = "folderId") String folderId,
			@RequestParam(value = "folderName") String folderName){
		try {
			docMgtService.modifyFolder(folderId, folderName);
		} catch (Exception e) {
			logger.error("error",e);
		}
	}
	/**
	 * 删除节点
	 * @param folderId
	 */
	@RequestMapping("/deleteFolder")
	public void doDeleteFolder(@RequestParam(value = "folderId") String folderId){
		try {
			docMgtService.deleteFolder(folderId);
		} catch (Exception e) {
			logger.error("error",e);
		}
	}
	
	/**
	 * 上传文件
	 * @param file
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "docUpload")
	public @ResponseBody void docUpload(@RequestParam("file") MultipartFile file, HttpServletRequest request,
			HttpServletResponse response) throws Exception {
		//生成tableId
		String tableId=Identities.uuid2();
		// 当前时间
		String newDate = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
		Date date = DateUtil.parseDate(newDate, "yyyy-MM-dd HH:mm:ss");
	try {
		// 文件名称
		String fileName = file.getOriginalFilename();
		String fileType =fileName.substring(fileName.lastIndexOf("."));
		// 获取服务器保存的文件名
		Random random = new Random();
		String recordId = DateUtil.getCurDate("yyMMddHHmmssS") + random.nextInt(9);
	
			// 取服务器文件目录
			String filePath = new PropertiesLoader("config.properties").getProperty("rootPath");
			filePath += ("/" + DateUtil.getCurDate("yy") + "/" + DateUtil.getCurDate("MM") + "/"
					+ DateUtil.getCurDate("dd"));

			File file2 = new File(filePath, recordId+fileType);
			if (!file2.exists()) {
				file2.mkdirs();
			}
			// 保存文件
			file.transferTo(file2);
			docMgtService.upload(tableId, request.getParameter("chooseNode"), recordId, date, fileName, filePath);
			response.getWriter().write("{\"status\":true,\"newName\":\"" + file.getOriginalFilename() + "\"}");
		} catch (Exception e) {
			logger.error("error",e);
			response.getWriter().write("{\"status\":false}");
		}
	}
	/**
	 * 文件共享给指定用户
	 * @param docInfoId：共享文件id
	 * @param userId：指定共享文件的用户id
	 * @return
	 */
	@RequestMapping("/shareFile")
	public @ResponseBody String shareFile(
			@RequestParam(value = "docInfoId") String docInfoId,
			@RequestParam(value = "userId") String userId,
			@RequestParam(value = "shareFold") String shareFold){
		JSONObject json=new JSONObject();
		String [] userIdArray=userId.split(",");
		int flag=0;//0表示要共享的文件不在共享文件夹中，1表示要共享的文件在共享文件夹中
		String relationId="";
		try{
			BizDocInfoRefMediaBean bizDocInfoRefMediaBean =docMgtService.selectBizDocInfoRefMediaBean(docInfoId);
			String uploadUserId=bizDocInfoRefMediaBean.getShareUserId();
			if(shareFold.equals(bizDocInfoRefMediaBean.getFolderId())){
				flag=1;
				relationId=bizDocInfoRefMediaBean.getRelationId();
			}
			List<BizDocInfoRefMediaEntity> list=new ArrayList<BizDocInfoRefMediaEntity>();
			for(int i=0;i<userIdArray.length;i++){
				//查询目标用户的文件中是否包含此文件
				bizDocInfoRefMediaBean.setFolderId(shareFold);
				bizDocInfoRefMediaBean.setUploadUserId(userIdArray[i]);
				List<BizDocInfoRefMediaBean> selectBizDocInfoRefMediaBean = docMgtService.selectBizDocInfoRefMediaBean(bizDocInfoRefMediaBean);
				if(selectBizDocInfoRefMediaBean!=null&&selectBizDocInfoRefMediaBean.size()>0){
					break;
				}
				BizDocInfoRefMediaEntity bizDocInfoRefMediaEntity=new BizDocInfoRefMediaEntity();
				bizDocInfoRefMediaEntity.setFileId(bizDocInfoRefMediaBean.getFileId());
				if(flag==1){
					bizDocInfoRefMediaEntity.setRelationId(relationId);	
				}else{
					bizDocInfoRefMediaEntity.setRelationId(docInfoId);
				}
				bizDocInfoRefMediaEntity.setUploadUserId(userIdArray[i]);
				bizDocInfoRefMediaEntity.setFolderId(shareFold);
				bizDocInfoRefMediaEntity.setShare(1);
				bizDocInfoRefMediaEntity.setUploadTime(new Date());
				bizDocInfoRefMediaEntity.setShareUserId(uploadUserId);
				list.add(bizDocInfoRefMediaEntity);	
			}
			
			docMgtService.shareFile(list);	
			json.put("result", 1);
			return json.toString();
			
		}catch(Exception e){
			logger.error("error",e);
		}
			   json.put("result", 0);
			   return json.toString();
	}
	/**
	 * 删除文件
	 * @param id
	 * @return
	 */
	@RequestMapping("/deleteFile")
	public @ResponseBody String doDeleteFile(@RequestParam(value = "id") String id){
		try {
			BizDocInfoRefMediaBean bean = docMgtService.getFilePath(id);
			if (bean != null) {
				String path = bean.getFilePath() + "/" + bean.getFileId();
				File file=new File(path);
				if(file.exists()){
					file.delete();
				}
				docMgtService.doDeleteBizDocInfoRefMedia(id);
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return "true";
	}
	/**
	 * 上传文件
	 * @param id
	 * @return
	 */
	@RequestMapping(value = "index")
	public ModelAndView index(HttpServletRequest request) {
		ModelAndView mv=new ModelAndView();
		String chunk = request.getParameter("chunk");
		String url = request.getParameter("url");
		mv.addObject("chunk", chunk);
		mv.addObject("url", url);
		mv.setViewName("aco/docmgt/fileUpload");
		return mv;
	}
	/**
	 * 方法: 保存归档类型.
	 * @param docFolder
	 * @return
	 */
	@RequestMapping("/addDocType")
	public @ResponseBody String addDocType(@RequestParam(value = "parentFolderId") String parentFolderId,
							@RequestParam(value = "folderName") String folderName){
		try{
			ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
			if(user == null){
				return "";
			}
			String date = DateUtil.getCurDate("yyyy-MM-dd HH:mm:ss");
			String maxId=docMgtService.findMaxDocType(parentFolderId);
			maxId=String.valueOf(Integer.parseInt(maxId)+1);
			BizDocInfoTypeEntity folder=new BizDocInfoTypeEntity();
//			String name=new String(folderName.getBytes("iso-8859-1"), "utf-8");
			folder.setCatalogName(folderName);
			String number=docMgtService.getCatalogId(parentFolderId, maxId);
			folder.setCatalogId(number);
			folder.setUserId(user.id);
			folder.setCatalogType(0);
			folder.setCreateTime(date);
			folder.setTs(date);
			folder.setParentCatalogId(parentFolderId);
			folder.setDr("N");
			folder.setCount("0");
			docMgtService.doSaveDocType(folder);
			return number;
		}catch(Exception e){
			logger.error("error",e);
			return "";
			
		}
		
	}
	/**
	 * 修改节点名
	 * @param folderId
	 * @param folderName
	 */
	@RequestMapping("/modifyDocType")
	public @ResponseBody void modifyDocType(@RequestParam(value = "folderId") String folderId,
			@RequestParam(value = "folderName") String folderName){
		try {
			docMgtService.modifyDocType(folderId, folderName);
		} catch (Exception e) {
			logger.error("error",e);
		}
	}
	/**
	 * 删除节点
	 * @param folderId
	 */
	@RequestMapping("/deleteDocType")
	public void deleteDocType(@RequestParam(value = "folderId") String folderId){
		try {
			docMgtService.deleteDocType(folderId);
		} catch (Exception e) {
			logger.error("error",e);
		}
	}
	/**
	 * 修改归档类型时校验名称是否重复
	 * @param id
	 * @return
	 */
	@RequestMapping("/doCheckRepat")
	public @ResponseBody String doCheckRepat(@RequestParam(value = "folderId") String folderId,@RequestParam(value = "folderName") String folderName){
		String flag="N";
		try {
			flag=docMgtService.doCheckRepat(folderId,folderName);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return flag;
	}
	/**
	 * 删除归档类型时校验
	 * @param id
	 * @return
	 */
	@RequestMapping("/doCheckDelete")
	public @ResponseBody String doCheckDelete(@RequestParam(value = "folderId") String folderId){
		String flag="N";
		try {
			flag=docMgtService.doCheckDelete(folderId);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return flag;
	}
	/**
	 * @跳转到关联文件页面
	 */
	@RequestMapping("/enclosureFile")
	public ModelAndView enclosureFile(HttpServletRequest request){
		ModelAndView mv=new ModelAndView();
		StringBuffer sb = new StringBuffer("[");
		List<BizDocInfoTypeEntity> list=new ArrayList<BizDocInfoTypeEntity>();
		list=docMgtService.findDocTypeList();
		List<BizDocInfoTypeEntity> listfoot=new ArrayList<BizDocInfoTypeEntity>();
		listfoot=docMgtService.findParentDocInfoList();
		list.addAll(listfoot);
		//形成树
		if(list != null && list.size()>0) {
			for(int i = 0;i < list.size();i++) {
				BizDocInfoTypeEntity folder= (BizDocInfoTypeEntity)list.get(i);
				sb.append("{'id':'").append(folder.getCatalogId()+"'");
				sb.append(",'name':'").append(folder.getCatalogName()+"'");
				//sb.append(",'open':'").append(true+"'");				
				sb.append(",'pId':'").append(folder.getParentCatalogId()+"'}");
				if (i != list.size() - 1) {
					sb.append(",");
				}
			}
		}
		sb.append("]");
		mv.addObject("treeList", sb);
		mv.setViewName("aco/docmgt/doc-type-list");
		return mv;
	}
	/**
	 * @param 列出所有有效的归档类型数据
	 * @param pagesize
	 * @return
	 */
	@RequestMapping("/listAllDocType")
	public @ResponseBody TreeGridView<BizDocInfoTypeEntity> listAllDocType(
							@RequestParam(value = "page", defaultValue = "0") int pagenum,
							@RequestParam(value = "rows", defaultValue = "10") int pagesize,
							@RequestParam(value = "title") String title) {
			
		try {
			TreeGridView<BizDocInfoTypeEntity> page = new TreeGridView<BizDocInfoTypeEntity>();
			if (pagenum != 0) {
				pagenum = pagenum / pagesize;
			}
			pagenum++;
			PageResult<BizDocInfoTypeEntity> pags = docMgtService.listAllDocType(pagenum, pagesize,title);
			page.setRows(pags.getResults());
			page.setTotal(pags.getTotalrecord());
			return page;
		} catch (Exception ex) {
			logger.error("error",ex);
			return null;
		}
	}
	/**
	 * 增加归档类型时校验名称是否重复
	 * @param id
	 * @return
	 */
	@RequestMapping("/doCheckName")
	public @ResponseBody String doCheckName(@RequestParam(value = "folderId") String folderId,@RequestParam(value = "folderName") String folderName){
		String flag="N";
		try {
			flag=docMgtService.doCheckName(folderId,folderName);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return flag;
	}
	/**
	 * 删除归档类型时校验
	 * @param id
	 * @return
	 */
	@RequestMapping("/doCheckDel")
	public @ResponseBody String doCheckDel(@RequestParam(value = "folderId") String folderId){
		String flag="N";
		try {
			flag=docMgtService.doCheckDel(folderId);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return flag;
	}
	/**
	 * 增加文档时校验名称是否重复
	 * @param id
	 * @return
	 */
	@RequestMapping("/doCheckFolderName")
	public @ResponseBody String doCheckFolderName(@RequestParam(value = "folderId") String folderId,@RequestParam(value = "folderName") String folderName){
		String flag="N";
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		try {
			if(user != null){
				flag=docMgtService.doCheckFolderName(folderId,folderName,user);
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return flag;
	}
	/**
	 * 修改文档时校验名称是否重复
	 * @param id
	 * @return
	 */
	@RequestMapping("/doCheckFolderRepat")
	public @ResponseBody String doCheckFolderRepat(@RequestParam(value = "folderId") String folderId,@RequestParam(value = "folderName") String folderName){
		String flag="N";
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		try {
			if(user != null){
				flag=docMgtService.doCheckFolderRepat(folderId,folderName,user);
			}
		} catch (Exception e) {
			logger.error("error",e);
		}
		return flag;
	}
	/**
	 * 删除文档时校验
	 * @param id
	 * @return
	 */
	@RequestMapping("/doDelFolder")
	public @ResponseBody String doDelFolder(@RequestParam(value = "folderId") String folderId){
		String flag="N";
		try {
			flag=docMgtService.doDelFolder(folderId);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return flag;
	}
	/**
	 * 删除文档时校验
	 * @param id
	 * @return
	 */
	@RequestMapping("/doFolderDel")
	public @ResponseBody String doFolderDel(@RequestParam(value = "folderId") String folderId){
		String flag="N";
		try {
			flag=docMgtService.doFolderDel(folderId);
		} catch (Exception e) {
			logger.error("error",e);
		}
		return flag;
	}
}