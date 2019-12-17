(function() {  
	var b = "close";
    CKEDITOR.plugins.add(b, {  
        requires: ["dialog"],  
        init: function(a) {  
            a.addCommand(b, new CKEDITOR.dialogCommand(b));  
            a.ui.addButton(b, {  
                label: b,//调用dialog时显示的名称  
                command: b,  
                icon: this.path + "placeholder.png"//在toolbar中的图标  
   
            });  
            CKEDITOR.dialog.add(b, this.path + "dialogs/close.js")  
   
        }  
   
    })  
   
})();