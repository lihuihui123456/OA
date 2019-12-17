package com.yonyou.aco.arc.utils;

import java.awt.image.BufferedImage;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Map;

import javax.imageio.ImageIO;
import javax.imageio.stream.ImageOutputStream;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.jbarcode.JBarcode;
import org.jbarcode.encode.Code39Encoder;
import org.jbarcode.paint.BaseLineTextPainter;
import org.jbarcode.paint.WideRatioCodedPainter;
import org.springside.modules.utils.PropertiesLoader;

import sun.misc.BASE64Encoder;
import freemarker.template.Configuration;
import freemarker.template.Template;

/**
 * 
 * ClassName: ExportWordUtil
 * 
 * @Description: 导出Word工具类
 * @author hegd
 * @date 2016-8-24
 */
@SuppressWarnings("restriction")
public class ExportWordUtil {

	/**
	 * 在服务器上通过参数生成Word文件
	 * @param map          表单数据
	 * @param template     打印模板
	 * @param serialNumber 流水号
	 * @param fileName     文件名
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public static String createWord(Map<String, Object> map, String template, String serialNumber, String fileName,
			HttpServletResponse response) throws Exception {
		if(StringUtils.isNotEmpty(serialNumber)) {
			JBarcode localJBarcode = new JBarcode(Code39Encoder.getInstance(),
					WideRatioCodedPainter.getInstance(),
					BaseLineTextPainter.getInstance());
			localJBarcode.setShowCheckDigit(false);
			BufferedImage localBufferedImage = localJBarcode.createBarcode(serialNumber);
			ByteArrayOutputStream bs = new ByteArrayOutputStream();  
	        ImageOutputStream imOut = ImageIO.createImageOutputStream(bs); 
            ImageIO.write(localBufferedImage, "png",imOut); 
			BASE64Encoder encoder = new BASE64Encoder(); 
            String s_imageData = encoder.encode(bs.toByteArray()); 
			map.put("serialNumber_",s_imageData);//流水号
		}
		Configuration cfg = new Configuration();
		try {
			String ftlPath = new PropertiesLoader("config.properties").getProperty("ftlPath");
			cfg.setDirectoryForTemplateLoading(new File(ftlPath));
			cfg.setDefaultEncoding("utf-8");
			// 获取模板文件
			Template t = cfg.getTemplate(template);
			fileName = fileName + ".doc";
			File outFile = new File(ftlPath + "\\" + fileName); // 导出文件
			String path = ftlPath + "\\" + fileName;
			Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outFile), "utf-8"));
			t.process(map, out); // 将填充数据填入模板文件并输出到目标文件
			out.flush();
			out.close();
			return path;
		} catch (Exception e) {
			e.printStackTrace();
			return "1";
		}
	}

	/**
	 * 在服务器上通过参数生成Word文件
	 * @param map          表单数据
	 * @param template     打印模板
	 * @param fileName     文件名
	 * @param response
	 * @return
	 * @throws Exception
	 */
	public static String createWord(Map<String, Object> map, String template, String fileName,
			HttpServletResponse response) throws Exception {
		Configuration cfg = new Configuration();
		try {
			String ftlPath = new PropertiesLoader("config.properties").getProperty("ftlPath");
			cfg.setDirectoryForTemplateLoading(new File(ftlPath));
			cfg.setDefaultEncoding("utf-8");
			// 获取模板文件
			Template t = cfg.getTemplate(template);
			fileName = fileName + ".doc";
			File outFile = new File(ftlPath + "\\" + fileName); // 导出文件
			String path = ftlPath + "\\" + fileName;
			Writer out = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(outFile), "utf-8"));
			t.process(map, out); // 将填充数据填入模板文件并输出到目标文件
			out.flush();
			out.close();
			return path;
		} catch (Exception e) {
			e.printStackTrace();
			return "1";
		}
	}
	
	public static String bytes2HexString(byte[] b) {
		StringBuffer result = new StringBuffer();
		String hex;
		for (int i = 0; i < b.length; i++) {
			hex = Integer.toHexString(b[i] & 0xFF);
			if (hex.length() == 1) {
				hex = '0' + hex;
			}
			result.append(hex.toUpperCase());
		}
		return result.toString();
	}
	
}
