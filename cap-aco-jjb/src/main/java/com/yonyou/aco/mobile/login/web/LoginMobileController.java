package com.yonyou.aco.mobile.login.web;

import java.io.IOException;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.subject.Subject;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import sun.misc.BASE64Decoder;

import com.yonyou.cap.isc.shiro.LicenseUtil;
import com.yonyou.cap.isc.shiro.token.MyUsernamePasswordToken;
import com.yonyou.cap.isc.user.entity.User;
import com.yonyou.cap.isc.user.service.IUserService;

@SuppressWarnings("restriction")
@RequestMapping("/loginMobile")
@Controller
public class LoginMobileController {
	
	@Resource IUserService iUserService;
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	/**
	 * 
	 * @Title: loginApp
	 * @Description: 手机端APP登录
	 * @param request
	 * @param reponse
	 * @throws JSONException
	 */
	@RequestMapping("/loginApp")
	public void loginApp(HttpServletRequest request, HttpServletResponse reponse)
			throws JSONException {
		/** json参数 **/
		String paramJson = request.getParameter("json");
		/**头像Url**/
		String picUrl = "/cap-aco/uploader/uploadfile?pic=";
		JSONObject jsonObject = new JSONObject(paramJson);
		/** 用户名 **/
		String username = "";
		/** 密码 **/
		String pwd = "";
		if (jsonObject.has("uid")) {
			username = jsonObject.getString("uid");
		}
		if (jsonObject.has("pwd")) {
			pwd = jsonObject.getString("pwd");
			pwd = getFromBASE64(pwd);
		}
		JSONObject json = new JSONObject();
		/** 结果信息 **/
		String message = "";
		/** 结果code **/
		String erroCode = "0";
		// 开始进入shiro的认证流程
		
		if(LicenseUtil.mobileMode==0){
			message = "移动端能力未授权！！";                            
			logger.error("error",message);
			erroCode = "5";
		}else{
			try {
				Subject currentUser = SecurityUtils.getSubject();
				MyUsernamePasswordToken token = new 
						MyUsernamePasswordToken(username, pwd, false, null, null, null, null);
				currentUser.login(token);
				message = "登录成功！";

			} catch (UnknownAccountException uae) {
				logger.error("error",uae);
				message = "用户名不存在！";
				erroCode = "1";
			} catch (IncorrectCredentialsException ice) {
				logger.error("error",ice);
				message = "用户名密码不匹配，请重试！";
				erroCode = "2";
			} catch (LockedAccountException lae) {
				logger.error("error",lae);
				message = "用户名被锁定，请联系管理员！";
				erroCode = "3";
			} catch (AuthenticationException ae) {
				logger.error("error",ae);
				message = "系统错误！";
				erroCode = "4";
			}
		}

		/** 用户对象 **/
		User user = iUserService.findByLoginName(username);
		
		if (user != null) {
			String userId = user.getUserId();
			String userName = user.getUserName();
			json.put("userId", userId);
			json.put("userName", userName);
			json.put("errorCode", erroCode);
			json.put("errorMessage", message);
			json.put("departmentName", user.getDeptName());
			json.put("company", user.getOrgName());
			json.put("userCode", user.getAcctLogin());
			json.put("phone", user.getUserMobile());
			json.put("tel", user.getUserTel());
			json.put("email", user.getUserEmail());
			json.put("ImgUrl", picUrl+user.getPicUrl());
			
		} else {
			json.put("userId", "");
			json.put("userName", username);
			json.put("errorCode", erroCode);
			json.put("errorMessage", message);
		}
		try {
			String res = json.toString();
			res.getBytes("utf-8");
			reponse.setContentType("text/xml;charset=utf-8");
			reponse.getWriter().print(res);
			reponse.getWriter().flush();
		} catch (IOException e) {
			logger.error("error",e);
		}
		
	}

	/**
	 * 
	 * @Title: getFromBASE64
	 * @Description: 字符串解码
	 * @param s
	 * @return
	 */
	public static String getFromBASE64(String s) {
		if (s == null)
			return null;
		BASE64Decoder decoder = new BASE64Decoder();
		try {
			byte[] b = decoder.decodeBuffer(s);
			return new String(b);
		} catch (Exception e) {
			return null;
		}
	}
}
