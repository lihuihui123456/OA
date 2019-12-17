package com.yonyou.aco.circularize.service.Impl;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Repository;

import com.yonyou.aco.circularize.dao.CircularizeDao;
import com.yonyou.aco.circularize.entity.BizCircularizeBasicInfoEntity;
import com.yonyou.aco.circularize.entity.BizCircularizeLinkEntity;
import com.yonyou.aco.circularize.service.CircularizeService;
import com.yonyou.cap.bpm.entity.DeskTaskBean;
import com.yonyou.cap.common.util.PageResult;


@Repository("circularizeService")
public class CircularizeServiceImpl implements CircularizeService{

	@Resource
	CircularizeDao dao;
	
	@Override
	public PageResult<BizCircularizeBasicInfoEntity> getAllBasicinfo(int pageNum,
			int pageSize, String wheresql) {
		return dao.getPageData(BizCircularizeBasicInfoEntity.class, pageNum, pageSize, wheresql, null, null);
	}
	@Override
	public String saveInfo(BizCircularizeBasicInfoEntity basicinformation) {
		try {
			dao.save(basicinformation);
			//System.out.println(basicinformation.getId());
			return basicinformation.getId()+"";
		} catch (Exception e) {
			e.printStackTrace();
			return "保存失败";
		}
	}
	
	@Override
	public String doUpdateInfo(BizCircularizeBasicInfoEntity basicinformation) {
		try {
			dao.update(basicinformation);
			return basicinformation.getId()+"";
		} catch (Exception e) {
			e.printStackTrace();
			return "保存失败";
		}
	}
	
	@Override
	public BizCircularizeBasicInfoEntity queryBasicById(String id) {
		return dao.findEntityByPK(BizCircularizeBasicInfoEntity.class, id);
	}
	@Override
	public String queryGTasksstatus(Long id) {
		String Gt  =dao.queryGTasksstatus(id);
		if (Gt == null && "".equals(Gt)) {
			return "0";
		}else{
			return Gt;
		}
	}
	@Override
	public void saveLink(String circulatedpeopleid, String mustseeid,String sceneid,String id) {
		String[] must = mustseeid.split(",");
		String[] scene = sceneid.split(",");
		System.out.println(must.length);
		
		Date now = new Date();
		BizCircularizeLinkEntity link = null;
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");//可以方便地修改日期格式
		String time = dateFormat.format( now ); 
		for (int i = 0; i < must.length; i++) {
			link = dao.findLinkInfoByUserId(id,must[i]);
			if(link != null || must[i] == null || "".equals(must[i])){
				continue;
			}else{
				link = new BizCircularizeLinkEntity();
			}
			
			link.setBid(id);
			link.setReceiveuid(must[i]);
			link.setSenduid(circulatedpeopleid);
			link.setSendtime(time);
			link.setCircularizestatus(1);
			link.setImportance("1");
			link.setStatus("0");
			dao.save(link);
		}
		for (int i = 0; i < scene.length; i++) {
			link = dao.findLinkInfoByUserId(id,scene[i]);
			if(link != null || scene[i] == null || "".equals(scene[i])){
				continue;
			}else{
				link = new BizCircularizeLinkEntity();
			}
			
			link.setBid(id);
			link.setReceiveuid(scene[i]);
			link.setSenduid(circulatedpeopleid);
			link.setSendtime(time);
			link.setCircularizestatus(1);
			link.setImportance("0");
			link.setStatus("0");
			dao.save(link);
		}
	}
	@Override
	public List<DeskTaskBean> findCyLinkList(String userid) {
		return dao.findCyLinkList(userid);
	}	
	@Override
	public String getMaxTableid() {
		return dao.getMaxTableid();
	}
	@Override
	public PageResult<BizCircularizeBasicInfoEntity> getAllBasicinfoJs(int pageNum,
			int pageSize, String userid,String query) {
		
		return dao.getAllBasicinfoJs(pageNum, pageSize,userid,query);
	}
	@Override
	public BizCircularizeLinkEntity queryLinkById(String id, String bid) {
		return dao.queryLinkById(id,bid);
	}
	@Override
	public void saveLinkInfo(BizCircularizeLinkEntity bean) {
		dao.save(bean);
	}
	@Override
	public PageResult<BizCircularizeLinkEntity> getAllLinkinfo(String id) {
		return dao.getAllLinkinfo(id);
	}
	@Override
	public void deleteById(String id) {
		dao.delete(BizCircularizeBasicInfoEntity.class, id);
	}
	@Override
	public BizCircularizeLinkEntity getCount(String id) {
		return dao.getCount(id);
	}

}
 