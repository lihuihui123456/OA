package com.yonyou.aco.userinfo.web;

import java.io.IOException;
import java.io.OutputStream;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.yonyou.cap.common.util.QRCodeUtil;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/QRCodeController")
public class QRCodeController {
	
	private final Logger logger = LoggerFactory.getLogger(this.getClass());
	
	@RequestMapping(value = "getQRCode")
	public void getQRCodeImg(HttpServletRequest request,
			HttpServletResponse response) throws IOException {
		try {
			String url = request.getParameter("url");
			if (url == null || "".equals(url)) {
				return;
			}
			response.setHeader("Pragma", "No-cache");
			response.setHeader("Cache-Control", "no-cache");
			response.setDateHeader("Expires", 0L);
			String type = "png";
			response.setContentType("image/" + type);
			OutputStream out = response.getOutputStream();
			QRCodeUtil.EncodeToStream(out, type, url,200,200);
			out.flush();
			out.close();
		} catch (Exception e) {
			logger.error("error",e);
			return;
		}
	}
}
