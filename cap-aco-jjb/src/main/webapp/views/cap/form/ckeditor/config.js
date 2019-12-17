/**
 * @license Copyright (c) 2003-2016, CKSource - Frederico Knabben. All rights reserved.
 * For licensing, see LICENSE.md or http://ckeditor.com/license
 */

CKEDITOR.editorConfig = function( config ) {
	// Define changes to default configuration here. For example:
	// config.language = 'fr';
	// config.uiColor = '#AADC6E';
	 config.enterMode = CKEDITOR.ENTER_BR;
	 config.shiftEnterMode = CKEDITOR.ENTER_BR;
	 //zzf 2016-12-07 所有的情况都出现在有空格&nbsp;的地方，而ckeditor对于空行是自动添加段落标记"<p></p>"的，而如果这一行里没有内容的话，又自动在里面添加”&nbsp;“，所以可以控制ckeditor不让它自动添加“nbsp”，在config.js里加上语句“config.fillEmptyBlocks=false;”
	 config.fillEmptyBlocks=false;
	 config.skin='kama';
	 config.font_names = '华文仿宋/STFangsong;华文中宋/STZhongsong;'+config.font_names;
	    config.height = 1800;
	    //config.extraPlugins = 'close';//注册插件
};
