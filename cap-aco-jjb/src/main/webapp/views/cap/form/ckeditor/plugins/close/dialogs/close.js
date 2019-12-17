(function() {  
    CKEDITOR.dialog.add("插件名称",   
    function(a) {  
        return {  
            title: "插件名称",  
            minWidth: "500px",  
            minHeight:"500px",  
            contents: [{  
                id: "tab1",  
                label: "",  
                title: "",  
                expand: true,  
                width: "500px",  
                height: "500px",  
                padding: 0,  
                elements: [{  
                    type: "html",  
                    style: "width:500px;height:500px",  
                    html: '内容测试'  
                }]  
            }],  
            onOk: function() {  
                  
            }  
        }  
    })  
})();  