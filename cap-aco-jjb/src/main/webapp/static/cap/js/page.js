	    var move = function (obj)
	    {
	        var sel1 = document.getElementById ('sel1');
	        var sel2 = document.getElementById ('sel2');
	        if (obj.value == '>'){
	        	var x = sel1.children[0];
	                if (x.selected)
	                {
	                    sel2.appendChild (x);
	                }
	        }else if(obj.value == '<'){
	        	var x = sel2.children[0];
	                if (x.selected)
	                {
	                    sel1.appendChild (x);
	                }
	        }
	        if (obj.value == '>>')
	        {
	            for ( var i = 0; i < sel1.children.length; i++)
	            {
	                var x = sel1.children[i];
	                if (x.selected)
	                {
	                    sel2.appendChild (x);
	                    i = -1;
	                    continue;
	                }
	            }
	        }
	        else if (obj.value == '<<')
	        {
	            for ( var i = 0; i < sel2.children.length; i++)
	            {
	                var x = sel2.children[i];
	                if (x.selected)
	                {
	                    sel1.appendChild (x);
	                    i = -1;
	                    continue;
	                }
	            }
	        }
	    }