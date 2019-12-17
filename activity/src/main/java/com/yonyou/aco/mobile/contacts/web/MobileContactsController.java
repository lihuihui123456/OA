package com.yonyou.aco.mobile.contacts.web;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.json.JSONArray;

import org.apache.commons.lang.StringUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.yonyou.aco.contacts.entity.BizContactsUserBean;
import com.yonyou.aco.contacts.service.IBizContactsService;

@RequestMapping("/mobileContactsController")
@Controller
public class MobileContactsController {

	@Resource
	IBizContactsService iBizContactsService;

	@SuppressWarnings({ "rawtypes", "unchecked" })
	@RequestMapping("/findContactsInfo")
	@ResponseBody
	public String findContactsInfo(HttpServletRequest request,
			HttpServletResponse reponse) throws JSONException {
		/** json参数 **/
		String paramJson = request.getParameter("json");
		/** 用户名 **/
		String userId = "";
		/** 密码 **/
		// String type = "";

		JSONObject jsonObject = new JSONObject(paramJson);
		if (jsonObject.has("uid")) {
			userId = jsonObject.getString("uid");
		}
		if (jsonObject.has("type")) {
			// type = jsonObject.getString("type");
		}
		JSONObject json = new JSONObject();

		String picUrl = "/cap-aco/uploader/uploadfile?pic=";
		if (userId != null || !"".equals(userId)) {
			List<BizContactsUserBean> list = iBizContactsService
					.findMobileBizContactsUserInfo(userId);
			List resList = new ArrayList();
			if (list != null && !list.isEmpty()) {
				for (int i = 0; i < list.size(); i++) {
					Map<String, String> map = new HashMap<String, String>();
					BizContactsUserBean bcub = list.get(i);
					String deptName = bcub.getDeptName();
					if (StringUtils.isEmpty(deptName)) {
						deptName = "";
					}
					String orgName = bcub.getOrgName();
					if (StringUtils.isEmpty(orgName)) {
						orgName = "";
					}
					String userCode = bcub.getUserCode();
					if (StringUtils.isEmpty(userCode)) {
						userCode = "";
					}
					String tel = bcub.getTel();
					if (StringUtils.isEmpty(tel)) {
						tel = "";
					}
					String email = bcub.getUserEmail();
					if (StringUtils.isEmpty(email)) {
						email = "";
					}
					String imgUrl = bcub.getPicUrl();
					if (StringUtils.isEmpty(imgUrl)) {
						imgUrl = picUrl + imgUrl;
					} else {
						imgUrl = "";
					}
					String mobile = bcub.getUserMobile();
					if (StringUtils.isEmpty(mobile)) {
						mobile = "";
					}
					map.put("id", bcub.getUserId());
					map.put("userName", bcub.getUserName());
					map.put("departmentName", deptName);
					map.put("company", orgName);
					map.put("userCode", userCode);
					map.put("phone", mobile);
					map.put("tel", tel);
					map.put("email", email);
					map.put("ImgUrl", imgUrl);
					resList.add(map);
				}
				json.put("errorCode", "0");
				json.put("errorMessage", "查询成功");
				json.put("items", JSONArray.fromObject(resList).toString());
			} else {
				json.put("errorCode", "1");
				json.put("errorMessage", "查询失败");
				json.put("items", "");
			}
		} else {
			json.put("erroCode", "2");
			json.put("errorMessage", "用户ID得到！");
			json.put("items", "");
		}
		return json.toString();
	}
}
