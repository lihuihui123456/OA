package com.yonyou.aco.mobile.util;

import java.math.BigDecimal;

public class MobileUtils {

	/**
	 * 字符串为null处理
	 * 
	 * @param str
	 * @return
	 */
	public String isNull(String str) {
		if (str == null || "null".equals(str)) {
			return "";
		} else {
			return str;
		}
	}

	/**
	 * 移动端 数字转换：紧急程度 密级  已读未读
	 * 
	 * @param str
	 * @param type
	 *            :1:紧急程度 2：密级
	 * @return
	 */
	public String numberToStrgin(String str, String type) {
		String newSte = null;
		if ("1".equals(type)) {
			if ("1".equals(str)) {
				newSte = ConstantInterface.ORDINARY_FILE;
			}
			if ("2".equals(str)) {
				newSte = ConstantInterface.EMERGENCY_FILE;
			}
			if ("3".equals(str)) {
				newSte = ConstantInterface.URGENT_FILE;
			}
		}
		if ("2".equals(type)) {
			if ("1".equals(str)) {
				newSte = ConstantInterface.PUBLICITY;
			}
			if ("2".equals(str)) {
				newSte = ConstantInterface.INTERNAL;
			}
		}
		if ("3".equals(str)) {
			if ("0".equals(str)) {
				newSte = ConstantInterface.UNREAD;
			}
			if ("1".equals(str)) {
				newSte = ConstantInterface.READ;
			}
		}
		return newSte;

	}

	/**
	 * 获取文件大小
	 * @param size
	 * @return
	 */
	public String getFormatSize(double size) {
		double kiloByte = size / 1024;
		if (kiloByte < 1) {
			return size + "Byte(s)";
		}

		double megaByte = kiloByte / 1024;
		if (megaByte < 1) {
			BigDecimal result1 = new BigDecimal(Double.toString(kiloByte));
			return result1.setScale(2, BigDecimal.ROUND_HALF_UP)
					.toPlainString() + "KB";
		}

		double gigaByte = megaByte / 1024;
		if (gigaByte < 1) {
			BigDecimal result2 = new BigDecimal(Double.toString(megaByte));
			return result2.setScale(2, BigDecimal.ROUND_HALF_UP)
					.toPlainString() + "MB";
		}

		double teraBytes = gigaByte / 1024;
		if (teraBytes < 1) {
			BigDecimal result3 = new BigDecimal(Double.toString(gigaByte));
			return result3.setScale(2, BigDecimal.ROUND_HALF_UP)
					.toPlainString() + "GB";
		}
		BigDecimal result4 = BigDecimal.valueOf(teraBytes);
		return result4.setScale(2, BigDecimal.ROUND_HALF_UP).toPlainString()
				+ "TB";
	}
}
