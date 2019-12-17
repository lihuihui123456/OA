package com.yonyou.aco.docmgt.repository;

import java.util.Date;
import java.util.List;

import com.yonyou.aco.docmgt.entity.BizDocFolderEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoBean;
import com.yonyou.aco.docmgt.entity.BizDocInfoEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoRefMediaBean;
import com.yonyou.aco.docmgt.entity.BizDocInfoRefMediaEntity;
import com.yonyou.aco.docmgt.entity.BizDocInfoTypeEntity;
import com.yonyou.cap.bpm.entity.BpmRuBizInfoBean;
import com.yonyou.cap.common.base.IBaseDao;
import com.yonyou.cap.common.util.PageResult;
import com.yonyou.cap.isc.shiro.ShiroDbRealm.ShiroUser;
import com.yonyou.cap.sys.iweboffice.entity.IWebDocumentEntity;

/**
 * <p>概述：业务模块文档管理Dao层
 * <p>功能：文档管理Dao层
 * <p>作者：薛志超，葛鹏，李争辉
 * <p>创建时间：2016年11月1日
 * <p>类调用特殊情况：无
 */
public interface DocMgtDao extends IBaseDao {

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
	public PageResult<BizDocInfoBean> findFolderContentPaper(int pageNum, int pageSize,String userid, String folderName);

	/**
	 * 方法: 通过父节点查询当前节点的最大值.
	 * @param pId
	 * @return
	 */
	public String findMaxFolder(String pId);
	/**
	 * 多个文件共享
	 * @param media
	 */
	public void shareFile(List<BizDocInfoRefMediaEntity> media);
	/**
	 *通过id查询上传的文件
	 * @return
	 */
	public BizDocInfoRefMediaBean selectBizDocInfoRefMediaBean(String id);
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
	 * 根据条件查询实体是否已经存在
	 * @param bizDocInfoRefMediaBean
	 * @return
	 */
	public List<BizDocInfoRefMediaBean> selectBizDocInfoRefMediaBean(BizDocInfoRefMediaBean bizDocInfoRefMediaBean);
	/**
	 * 根据用户查询文件夹信息
	 * @param userid
	 * @return
	 */
	public List<BizDocFolderEntity> findFolderList(String userid);
	/**
	 * 查询最上级父节点
	 * @return
	 */
	public List<BizDocFolderEntity> findParentFolderList();
	/**
	 * 通过ID查询实体
	 * @param id
	 * @return
	 */
	public BizDocFolderEntity getBizDocFolderEntityById(String id);
	
	/**
	 * 通过ID查询附件表
	 * @param id
	 * @return
	 */
	public BizDocInfoRefMediaEntity getBizDocInfoRefMediaEntityById(String id);
	
	/**
	 * 通过登录名查询Userid
	 * @param loginName
	 * @return
	 */
	public String getUserIdByLoginName(String loginName);
	
	
	/**查询附件表信息
	 * @param ID_
	 * @return
	 */
	public BizDocInfoRefMediaBean getFilePath(String ID_);
	/**
	 * @param folderId
	 * @return
	 */
	public List<BizDocInfoRefMediaBean> getMediaBean(String folderId);
	/**
	 * 未归档
	 * @param pageNum
	 * @param pageSize
	 * @param param
	 * @return
	 */
	public PageResult<BpmRuBizInfoBean> findTaskHasDoList(int pageNum, int pageSize,String param,
			String sortName,String sortOrder);
	/**
	 * 已归档
	 * @param pageNum
	 * @param pageSize
	 * @param param
	 * @return
	 */
	public PageResult<BpmRuBizInfoBean> findTaskHasBelongList(int pageNum, int pageSize,String param,String id,
			String sortName,String sortOrder);
	
	/**
	 * @param catalog_id
	 * @return
	 */
	public BizDocFolderEntity getBizDocFolderEntity(String catalog_id);
	
	
	/**
	 * 获取SerialNumber
	 * @param tableId
	 * @return SerialNumber
	 */
	public int getSerialNumber(String tableId);
	
	
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
	/**
	 * 删除文档下关联文件
	 * */
	public void doDeleteDocInfo(BizDocInfoEntity docinfo);
}
