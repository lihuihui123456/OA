package com.yonyou.aco.docmgt.service;

import java.util.Date;
import java.util.List;

import com.yonyou.aco.docmgt.entity.BizDocFolderEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoBean;
import com.yonyou.aco.docmgt.entity.BizDocInfoEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoRefMediaBean;
import com.yonyou.aco.docmgt.entity.BizDocInfoRefMediaEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoTypeEntity;
import com.yonyou.aco.docmgt.entity.BizDocRelationshipEntity;
import com.yonyou.cap.bpm.entity.BpmRuBizInfoBean;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.sys.iweboffice.entity.IWebDocumentEntity;
/**
 * <p>概述：业务模块文档管理service层
 * <p>功能：文档管理service层
 * <p>作者：薛志超，葛鹏，李争辉
 * <p>创建时间：2016年11月1日
 * <p>类调用特殊情况：无
 */
public interface DocMgtService {

	/**
	 * 方法: 根据当前用户查询文件夹.
	 * @param userid
	 * @return
	 */
	public List<BizDocFolderEntity> findFolderList(String userid);
	
	/**
	 * 方法: 查询根节点文件夹.
	 * @return
	 */
	public List<BizDocFolderEntity> findParentFolderList();
	
	/**
	 * 方法: 保存归档信息.
	 * 说明: 填入方法说明
	 * @param docinfo
	 * @return
	 */
	public void doSaveDocInfo(BizDocInfoEntity docinfo);
	/**
	 * 方法: 修改归档信息.
	 * @param docinfo
	 */
	public void doUpdateDocInfo(BizDocInfoEntity docinfo);
	/**
	 * 方法: 删除归档信息.
	 * 说明: 填入方法说明
	 * @param docinfo
	 * @return
	 */
	public void doDeleteDocInfo(BizDocInfoEntity docinfo);
	/**
	 * 方法: 保存正文信息
	 * @param media
	 */
	public void doSaveDocumentInfo(BizDocInfoRefMediaEntity media);
	
	/**
	 * 方法: 批量保存附件信息.
	 * @param mediaList
	 */
	public void doSaveMediaList(List<BizDocInfoRefMediaEntity> mediaList);
	
	/**
	 * 方法: 查询当前文件夹下的数据.
	 * @param pageNum
	 * @param pageSize
	 * @param userid
	 * @param folderId
	 * @return
	 */
	public PageResult<BizDocInfoRefMediaBean> findFolderContent(int pageNum, int pageSize,String userid,String folderId,String doc_type,String folderName);
	
	/**
	 * 方法: 查询当前文件夹下的数据.
	 * @param pageNum
	 * @param pageSize
	 * @param userid
	 * @param folderId
	 * @return
	 */
	public PageResult<BizDocInfoBean> findFolderContentPaper(int pageNum, int pageSize,String userid,String folderName);
	/**
	 * 方法: 根据文件夹中信息的id查询正文和附件
	 * @param docInfoId
	 * @return
	 */
	public List<BizDocInfoRefMediaEntity> findMediaList(String docInfoId);
	
	/**
	 * 方法: 根据文件夹中信息的id查询正文或附件
	 * 说明: 填入方法说明
	 * @param docInfoId
	 * @param docType 文件类型 
	 * @return
	 */
	public BizDocInfoRefMediaEntity findMediaByPK(String id);
	
	/**
	 * 方法:保存文件夹信息.
	 * @param docFolder
	 */
	public void doSaveFolder(BizDocFolderEntity docFolder);
	
	/**
	 * 方法: 通过父节点查询当前节点的最大值.
	 * @param pId
	 * @return
	 */
	public String findMaxFolder(String pId);
	/**
	 * 
	 * 方法: 获取上传文件信息存入附件表
	 * 
	 */
	public void doSaveFileToDb(BizDocInfoRefMediaEntity media);
	
	/**
	 *	方法：插入文件共享关联表 
	 * 
	 */
	public void doSaveBizDocRelationship(BizDocRelationshipEntity relation);
	/**
	 *   方法：根据ID查询个人文件夹表
	 * 
	 */
	public BizDocFolderEntity getBizDocFolderEntityById(String id);
	/**
	 * 
	 * 
	 *  根据用户登陆名查询用户ID
	 * 
	 */
	public String getUserIdByLoginName(String loginName);
	
	/**
	 * 拼接ID
	 * @param parentId
	 * @param id
	 * @return
	 */
	public String getCatalogId(String parentId,String id);
	
	
	/**
	 * 删除节点 
	 * 
	 * 
	 **/
	public void deleteFolder(String folderId);
	/**
	 * 修改节点 
	 * 
	 * 
	 **/
	public void modifyFolder(String folderId,String folderName);
	/**
	 *  
	 * 得到文件信息
	 * 
	 */
	public BizDocInfoRefMediaBean getFilePath(String ID_);
	/**
	 * 
	 * @param 多个文件共享
	 */
	public void shareFile(List<BizDocInfoRefMediaEntity> media);
	/**
	 *通过id查询上传的文件
	 * @return
	 */
	public BizDocInfoRefMediaBean selectBizDocInfoRefMediaBean(String id);
	/**
	 * 根据公文id查询公文的正文和附件
	 * @param id
	 * @return
	 */
	public List<IWebDocumentEntity> selectBiz(String id);
	/**
	 * 
	 * @param docInfoId
	 * @return 查询一条归档信息
	 */
	public BizDocInfoBean selectDocInfo(String docInfoId);
	/**
	 * 获取正文附件信息
	 */
	public IWebDocumentEntity selectIWebDocument(String id);
	/**
	 * 
	 *  通过Id得到Media实体
	 * 
	 */
	public BizDocInfoRefMediaEntity getBizDocInfoRefMediaEntityById(String id);
	/**
	 * 
	 *	删除media 
	 * 
	 * 
	 */
	public void doDeleteBizDocInfoRefMedia(String id);
	
	/**获取文件表bean
	 * @param folderId
	 * @return
	 */
	public List<BizDocInfoRefMediaBean> getMediaBean(String folderId);
	/**
	 * 查询未归档
	 * 
	 */
	public PageResult<BpmRuBizInfoBean> findTaskHasDoList(int pageNum, int pageSize,String param,
			String sortName,String sortOrder);
	/**
	 * 查询已归档
	 * 
	 */
	public PageResult<BpmRuBizInfoBean> findTaskHasBelongList(int pageNum, int pageSize,String param,String id,
			String sortName,String sortOrder);
	/**
	 * 更新公文归档标志
	 * 
	 */
	public void updateHasBelong(String id_,String archive_state_);
	/**
	 * 根据条件查询实体是否已经存在
	 * @param bizDocInfoRefMediaBean
	 * @return
	 */
	public List<BizDocInfoRefMediaBean> selectBizDocInfoRefMediaBean(BizDocInfoRefMediaBean bizDocInfoRefMediaBean);
	/**
	 * 根据catalog_id得到实体
	 * @param catalog_id
	 * @return
	 */
	public BizDocFolderEntity getBizDocFolderEntity(String catalog_id);
	
	/**
	 * 上传文件到服务器上
	 * @param tableId 手动生成
	 * @param folderId 节点ID
	 * @param recordId 文件记录名
	 * @param date 日期
	 * @param fileName 文件实名
	 * @param filePath 文件路径
	 */
	public void upload(String tableId,String folderId,String recordId,Date date,String fileName,String filePath);
	/**
	 * 方法:查询归档类型文件夹
	 * @param userid
	 * @return
	 */
	public List<BizDocInfoTypeEntity> findDocTypeList();

	/**
	 * 方法: 查询归档类型根节点文件夹.
	 * @return
	 */
	public List<BizDocInfoTypeEntity> findParentDocInfoList();
	/**
	 * 方法: 通过父节点查询当前节点的最大值.
	 * @param pId
	 * @return
	 */
	public String findMaxDocType(String pId);
	/**
	 * 方法:保存归档类型信息.
	 * @param docFolder
	 */
	public void doSaveDocType(BizDocInfoTypeEntity docFolder);
	/**
	 * 修改节点 
	 * 
	 * 
	 **/
	public void modifyDocType(String folderId,String folderName);
	/**
	 * 删除节点 
	 * 
	 * 
	 **/
	public void deleteDocType(String folderId);
	/**
	 * 修改归档类型时校验名称是否重复
	 * @param id
	 * @return
	 */
	public String doCheckRepat(String folderId,String folderName);
	/**
	 * 删除归档类型时校验
	 * @param id
	 * @return
	 */
	public String doCheckDelete(String folderId);
	/**
	 * @param 列出所有有效的归档类型数据
	 * @param pagesize
	 * @return
	 */
	public PageResult<BizDocInfoTypeEntity> listAllDocType(int pagenum,
			int pagesize,String title);
	/**
	 * 查找每个归档类型下的文件个数
	 * @param id
	 * @return
	 */
	public String getDocTypeNum(String folderId);
	/**
	 * 归档类型下的文件个数加1
	 * @param id
	 * @return
	 */
	public void setDocTypeNum(String folderId,String num);
	/**
	 * 增加归档类型时校验名称是否重复
	 * @param id
	 * @return
	 */
	public String doCheckName(String folderId,String folderName);
	/**
	 * 删除归档类型时校验
	 * @param id
	 * @return
	 */
	public String doCheckDel(String folderId);
	/**
	 * 方法: 通过父节点查询当前节点的最大值.
	 * @param pId
	 * @return
	 */
	public String findMaxNum(String pId);
	/**
	 * 增加文档时校验名称是否重复
	 * @param id
	 * @return
	 */
	public String doCheckFolderName(String folderId,String folderName,ShiroUser user);
	/**
	 * 修改文档时校验名称是否重复
	 * @param id
	 * @return
	 */
	public String doCheckFolderRepat(String folderId,String folderName,ShiroUser user);
	/**
	 * 删除文档时校验
	 * @param id
	 * @return
	 */
	public String doDelFolder(String folderId);
	/**
	 * 删除文档时校验
	 * @param id
	 * @return
	 */
	public String doFolderDel(String folderId);
}