package com.yonyou.aco.cloudydisk.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.nio.channels.FileChannel;

public class MergeFileUtil {
	@SuppressWarnings("resource")
	public static boolean mergeFiles(String fpath, String resultPath) {
	    if (fpath == null||"".contentEquals(fpath)) {
	        return false;
	    }

	    File tempFolder=new File(fpath);
	    File[] files = tempFolder.listFiles();
	    for (int i = 0; i < files.length; i ++) {
	        if (!files[i].exists() || !files[i].isFile()) {
	            return false;
	        }
	    }

	    File resultFile = new File(resultPath);

	    try {
	        FileChannel resultFileChannel = new FileOutputStream(resultFile, true).getChannel();
	        for (int i = 0; i < files.length; i ++) {
	            FileChannel blk = new FileInputStream(files[i]).getChannel();
	            resultFileChannel.transferFrom(blk, resultFileChannel.size(), blk.size());
	            blk.close();
	        }
	        resultFileChannel.close();
	    } catch (FileNotFoundException e) {
	        e.printStackTrace();
	        return false;
	    } catch (IOException e) {
	        e.printStackTrace();
	        return false;
	    }

	    for (int i = 0; i < files.length; i ++) {
	        files[i].delete();
	    }

	    return true;
	}
}
