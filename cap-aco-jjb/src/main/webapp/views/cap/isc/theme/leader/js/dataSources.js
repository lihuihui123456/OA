    var Flow = function(){

        var init = function(){
            noticeArea();
            //traceArea();
           // todoArea();
        }

        var todoArea = function(){
            var tpl = '<tbody> \
            			<tr>\
							<td width="%s">%s</td>\
							<td width="%s">%s</td>\
							<td width="%s">%s</td>\
						</tr> \
            			</tbody>';
            var list = loadDataTodo();
            $.each (list, function (i, m){
                var tr = Util.sprintf(tpl, 
                		'75%',
                        m.bCon,
                        '6%',
                        m.bPerson,
                        '9%',
                        m.bTime
                    );
                $('#todoArea').append (tr);
            });
        }

        var noticeArea = function(){
        		var rd = "?random=" + Math.random();  
            	//var num = parent.liCounts();
                var list = null;
                var date = new Date();
        	    var seperator1 = "-";
        	    var seperator2 = ":";
        	    var month = date.getMonth() + 1;
        	    var strDate = date.getDate();
        	    if (month >= 1 && month <= 9) {
        	        month = "0" + month;
        	    }
        	    if (strDate >= 0 && strDate <= 9) {
        	        strDate = "0" + strDate;
        	    }
        	    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate;
                $.ajax({
    		        url :'notice/findNoticeList'+rd,
    		        dataType: 'json',
    		        async: false, //同步
    		       // data:{num:num},
    				success: function (text) {
    					 $('#notice').html('');
    					var list = text;
    		            var tpl = '<li class="list-group-item" onclick="%s"; title="%s"> \
                            <span class="mark"><i class="fa fa-%s"></i></span> \
                            <a class="con">%s \
                                <span class="%s"></span> \
                            </a> \
                            <span class="time">%s</span> \
                        </li>';
    		           // $('#notice').empty();
		                $.each (list, function (i, m){
		                	var id = m.id;
		                    var li = Util.sprintf(tpl, 
		                    		"addTab('"+id+"')",
		                    		m.title,
		                    		"comment",
		                            /*m.title.substr(0, 15)+"...",*/
		                    		compare(m.title),
		                            m.creationtime.split(' ')[0] == currentdate ? 'new':'', 
		                            m.creationtime.split(' ')[0]
		                        );
		                    $('#notice').append (li);
		                });
		                parent.parent.noticeiFrameReady=true;
    				},
    				error: function (text) {
    					//alert("执行出现异常！");
    				}
    			});
        }

        
        var traceArea = function(){
            var tpl = '<li class="list-group-item"> \
                            <span class="count %s">%s</span> \
                            <a href="javascript:;" class="con">%s \
                                <span class="%s"></span> \
                            </a> \
                            <span class="time">%s</span> \
                        </li>';
            var color = ['red', 'green', 'blue'];
            var list = loadData();
            $.each (list, function (i, m){
                var li = Util.sprintf(tpl,
                        color[i],
                        i + 1,
                        m.liCon,
                        '',
                        m.liTime
                    );
                $('#traceArea').append (li);
            });
        }
        return {
            init:function(){
                init();
            }

        };

    }();

    Flow.init();   
    function compare(title){
    	if(null != title && title.length > 10){
    		return title.substr(0, 10)+"...";
    	}
    	return title;
    }