package com.yonyou.aco.cloudydisk.web;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.aco.cloudydisk.entity.CloudAuthNodes;
import com.yonyou.aco.cloudydisk.entity.CloudFileEntity;
import com.yonyou.aco.cloudydisk.service.ICloudDiskService;
import com.yonyou.aco.cloudydisk.util.ZipUtils;
import com.yonyou.cap.common.audit.operatelog.annotation.AroundAspect;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.common.util.TreeGridView;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;

/**
 * <p>
 * 概述：业务模块办公云盘查询controller层
 * <p>
 * 功能：1.个人办公云存储 2.共享
 * <p>
 * 作者：葛鹏
 * <p>
 * 创建时间：2017年3月10日
 * <p>
 * 类调用特殊情况：无
 */
@Controller
@RequestMapping("/clouddiskq")
public class CloudDiskQueryController {
	@Resource
	ICloudDiskService service;

	@RequestMapping("/queryFiles")
	@AroundAspect(description = "办公云盘-分页查询文件和文件夹列表")
	public @ResponseBody TreeGridView<CloudFileEntity> queryFiles(
			@RequestParam(value = "page", defaultValue = "0") int pagenum,
			@RequestParam(value = "rows", defaultValue = "10") int pagesize,
			@RequestParam(value = "sortName", defaultValue = "") String sortName,
			@RequestParam(value = "sortOrder", defaultValue = "") String sortOrder,
			@RequestParam(value = "filters", defaultValue = "") String filters,
			@RequestParam(value = "orFilters", defaultValue = "") String orFilters) {
		TreeGridView<CloudFileEntity> page = new TreeGridView<CloudFileEntity>();
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user == null) {
			return null;
		}
		try {
			filters = java.net.URLDecoder.decode(filters, "UTF-8");
			orFilters = java.net.URLDecoder.decode(orFilters, "UTF-8");
			if (pagenum != 0) {
				pagenum = pagenum / pagesize;
			}
			pagenum++;
			PageResult<CloudFileEntity> pags = service.findCloudFileByUser(user, pagenum, pagesize, sortName, sortOrder,
					filters, orFilters);
			page.setRows(pags.getResults());
			page.setTotal(pags.getTotalrecord());

		} catch (Exception e) {
			e.printStackTrace();
		}
		return page;
	}

	@RequestMapping("/queryAuths")
	@AroundAspect(description = "办公云盘-查询当前用户对当前文件的所有权限")
	public @ResponseBody String queryAuths(@RequestParam(value = "fileId", defaultValue = "") String fileId) {
		ShiroUser user = (ShiroUser) SecurityUtils.getSubject().getPrincipal();
		if (user == null) {
			return null;
		}
		StringBuilder sb = new StringBuilder();
		List<CloudAuthNodes> list = service.findAuths(fileId, user.getId());
		sb.append("[");
		for (int i = 0; i < list.size(); i++) {
			CloudAuthNodes auths = list.get(i);
			sb.append("{id:'" + auths.getAuthUserId() + "',name:'" + auths.getAuthUserName() + "',fileId:'"
					+ auths.getFileId() + "',type:'" + auths.getAuthType() + "',");
			if (i == list.size() - 1) {
				sb.append(auths.getNodes() + "}");
			} else {
				sb.append(auths.getNodes() + "},");
			}
		}
		sb.append("]");
		return sb.toString();
	}

	@RequestMapping("/showImage")
	@AroundAspect(description = "办公云盘-预览图片")
	public @ResponseBody void showImage(HttpServletRequest request, 
			HttpServletResponse response) throws IOException {
		response.setContentType("text/html; charset=UTF-8");
		response.setContentType("image/jpeg");
		String fileId = request.getParameter("fileId");
		CloudFileEntity fileEntity=service.findFileById(fileId);
		String path=fileEntity.getFilePath()+"/"+fileEntity.getRecordId();
		String tempFolderPath=fileEntity.getFilePath()+"/"+new Date().getTime();
		File tempFolder=new File(tempFolderPath);
		if(!tempFolder.exists()){
			tempFolder.mkdirs();
		}
		String path_=tempFolderPath+"/"+fileEntity.getFileName();
		ZipUtils.copyFile(path,path_,true);
		FileInputStream fis = new FileInputStream(path_);
		OutputStream os = response.getOutputStream();
		try {
			int count = 0;
			byte[] buffer = new byte[1024 * 1024];
			while ((count = fis.read(buffer)) != -1){
				os.write(buffer, 0, count);
			}
			os.flush();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (os != null)
				os.close();
			if (fis != null)
				fis.close();
		}
		File tempFile=new File(path_);
		if(tempFile!=null&&tempFile.exists()){
			tempFile.delete();
		}
		if(tempFolder!=null&&tempFolder.exists()){
			tempFolder.delete();
		}
	}
}
