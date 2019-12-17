var rd = "?random=" + Math.random();  
var monthUrl = "bizCalendarController/findToMonthCalendarByUserid"+rd;
var dayUrl = "bizCalendarController/findCalendarByDate"+rd;
var initDate ="";
var CALENDAR_ROW_COUNTS = 0; //日历总行数
/**
 * 加载某年某月的日程信息
 * @param year
 * @param month
 * @param day
 * @param type
 * @param url
 */
function initCalendarInfo(year,month,day,type,url){
	$.ajax({
	    url:url,
		type: 'post',
		data:{'year':year,"month":month,"type":type},
		success:function(data) {
			if(data.events==undefined){
				var events = calendarData.events;
			}else{
				var events = data.events;
				$('#calendar5').css("overflow-y","auto");
				var date = year+"-"+month+"-"+day;
			    initDate = new Date(Date.parse(date.replace(/-/g,  "/"))); 
			    $('.list').empty();
			    $.each(events, function(i, m){
	          		var dayHtml = '';
	          		var dayHead = '<div id="calendar'+m.day+'" class="time_line day-event" date-day="%s" date-month="%s" date-year="%s" data-number="%s">';
	          		dayHtml += calendar.sprintf(dayHead, m.day, m.month, m.year, i);
	          		dayHtml += '</div>';
			   		$('.list').append(dayHtml);
			    })
			    //设置事件
			    setEvent(year);
			    $('tbody td').on('click', function(e) {
					if ($(this).hasClass('event')) {
						onClickDay($(this));
		                $(".list").css("display","block");
		                $(".list").niceScroll({
							cursorcolor : "#454545",
							cursoropacitymax : 0.3,
							cursorwidth : "5px",
							cursorborder : "0",
							cursorborderradius : "5px",
							gesturezoom: true, 
							spacebarenabled: true,
						});
		                $(".calendar").css({"width":"70%"});
						$('tbody.event-calendar td').removeClass('active');
						$(this).addClass('active');
						//$('tbody.event-calendar tr.5 > td:first').css("margin-left","7.5%");
					} else {
						$('tbody.event-calendar td').removeClass('active');
		                $(".list").css("display","none");
		                $(".calendar").css("width","100%");
					};
					var year = $(this).attr('date-year');
					var month = $(this).attr('date-month');
					var day = $(this).attr('date-day');
					if(parseInt(month)<10){
						month="0"+month;	
					}
					if(parseInt(day)<10){
						day="0"+day;	
					}
					var newDate = year+'-'+month+'-'+day;
					var options={
						"text":"日程管理",
						"id":"8a81610c564e5bb201564e5d54a00000",
						"href":"bizCalendarController/index?date="+newDate,
						"icon":"fa fa-calendar"
					};
					window.parent.parent.createTab(options);
				});
			/**
			 * add by hegd 默认加载当天的提成信息 2017年4月11日
			 */
	    	if(parseInt(month)<10){
				month="0"+month;	
			}
			if(parseInt(day)<10){
				day="0"+day;	
			}
			//拼接当天日期串儿
			var defaultDate = year+'-'+month+'-'+day;
			//调用后台接口返回当天日程信息
		    $.ajax({
			    url:dayUrl,
				type: 'post',
				data:{'date':defaultDate},
				success:function(data) {
					if(data.events==undefined){
						var events = calendarData.events;
					}else{
						var events = data.events;
						if(events[0].list!=""){
							//当天日程信息展示
							initDayCalendarInfo(events);
							$(".list").css("display","block");
							$(".calendar").css({"width":"70%"});
							$(".current-day event").addClass('active');
							$(".list").niceScroll({
								cursorcolor : "#454545",
								cursoropacitymax : 0.3,
								cursorwidth : "5px",
								cursorborder : "0",
								cursorborderradius : "5px",
								gesturezoom: true, 
								spacebarenabled: true,
							});
						}
					}
				}
			});	
			}
		}
	});
}

/**
 * 加载某一天的日程信息
 * @param obj
 */
function onClickDay(obj){
	var year = obj.attr('date-year');
	var month = obj.attr('date-month');
	var day = obj.attr('date-day');
	if(parseInt(month)<10){
		month="0"+month;	
	}
	if(parseInt(day)<10){
		day="0"+day;	
	}
	var date = year+'-'+month+'-'+day;
	$.ajax({
	    url:dayUrl,
		type: 'post',
		data:{'date':date},
		success:function(data) {
			if(data.events==undefined){
				var events = calendarData.events;
			}else{
				var events = data.events;
				initDayCalendarInfo(events);
			}
		}
	});
}

/**
 * 右侧日程展示
 * @param events
 */
function initDayCalendarInfo(events){
   		if(events!=""){
   			var calendarDiv = document.getElementById("calendar"+events[0].day);
   			var dateStr = events[0].month+'月'+events[0].day+'日';
   			var dayHtml='<h2 class="title">'+dateStr+'</h2>';
       		$.each(events[0].list, function(k, n){
       			//设置title长度
       			var tl = n.title;
       			if(n.title.length>5){
       				n.title=n.title.substring(0,5)+"...";
       			}
       			var current = Math.round(new Date().getTime()/1000);
       			var todoTime = calendar.strtotimestamp(calendar.sprintf('%s-%s-%s %s:00',events[0].year, events[0].month, events[0].day, n.time));
       			var hourTpl = '<div class="liwrap %s %s"> \
							    <div class="point"> \
							     <i class="fa fa-circle"></i> \
							    </div> \
							    <div class="liright" title= %s > \
							     <p>%s<br />%s</p> \
							    </div> \
							   </div>';
					dayHtml += calendar.sprintf(hourTpl, 
						todoTime > current? 'unfinished':'', 
						k ==  events[0].list.length - 1 ? 'last_one':'',
						tl,
						n.time, 
						n.title);
					calendarDiv.innerHTML=dayHtml;
       		});
   		}
   		
}
/**
 * 初始化整个日程控件
 */
var calendar = {
	init : function() {
		var d = new Date(); //实例一个时间对象；
		var year = d.getFullYear();//获取系统的年；
		var month = d.getMonth()+1;//获取系统月份，由于月份是从0开始计算，所以要加1
		var day = d.getDate();//获取天
		/**
		 * 加载某年末月的日程信息
		 */
		calendar.startCalendar(day,month,year);
	},
	strtotimestamp:function(datestr){
		
		  var new_str = datestr.replace(/:/g,"-");
		  new_str = new_str.replace(/ /g,"-");
		  var arr = new_str.split("-");
		  var datum = new Date(Date.UTC(arr[0],arr[1]-1,arr[2],arr[3],arr[4],arr[5]));
		  return (datum.getTime()/1000 - 3600*8);  
	},

	startCalendar : function(day1,month1,year1) {
		var mon =  '一';
		var tue =  '二';
		var wed =  '三';
		var thur = '四';
		var fri =  '五';
		var sat =  '六';
		var sund = '日';

		/**
		 * Get current date
		 */
		var yearNumber = year1;
		/**
		 * Get current month and set as '.current-month' in title
		 */
		var monthNumber = month1;

		function GetMonthName(monthNumber) {
			var months = ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'];
			return months[monthNumber - 1];
		}

		setMonth(monthNumber, yearNumber,mon, tue, wed, thur, fri, sat, sund);

		function setMonth(monthNumber, year, mon, tue, wed, thur, fri, sat, sund) {
			$('.month').text(year+ '  年   '+monthNumber+' 月');
			$('.month').attr('data-month', monthNumber);
			printDateNumber(monthNumber,year, mon, tue, wed, thur, fri, sat, sund);
		}

		$('.btn-next').off('click'); 
		$('.btn-next').on('click',function(e) {
			$('tbody.event-calendar td').removeClass('active');
            $(".list").css("display","none");
            $(".calendar").css("width","100%");
			var monthNumber = $('.month').attr('data-month');
			if (monthNumber > 11) {
				$('.month').attr('data-month', '0');
				var monthNumber = $('.month').attr('data-month');
				yearNumber = yearNumber + 1;
				setMonth(parseInt(monthNumber) + 1,yearNumber, mon, tue, wed,thur, fri, sat, sund);
				//记载完 - 查询
			} else {
				setMonth(parseInt(monthNumber) + 1, yearNumber,mon, tue, wed, thur, fri, sat, sund);
			}
		});
		$('.btn-prev').off('click'); 
		$('.btn-prev').on('click',function(e) {
			$('tbody.event-calendar td').removeClass('active');
            $(".list").css("display","none");
            $(".calendar").css("width","100%");
			$('.list').empty();
			var monthNumber = $('.month').attr('data-month');
			if (monthNumber < 2) {
				$('.month').attr('data-month', '13');
				var monthNumber = $('.month').attr('data-month');
				yearNumber = yearNumber - 1;
				setMonth(parseInt(monthNumber) - 1, yearNumber, mon, tue, wed, thur, fri, sat, sund);
			} else {
				setMonth(parseInt(monthNumber) - 1,yearNumber, mon, tue, wed, thur, fri, sat, sund);
			};
		});

		/**
		 * Get all dates for current month
		 */

		function printDateNumber(monthNumber2,year2, mon, tue, wed, thur, fri, sat,sund) {
			$($('tbody.event-calendar tr')).each(function(index) {
				$(this).empty();
			});

			$($('thead.event-days tr')).each(function(index) {
				$(this).empty();
			});

			function getDaysInMonth(month, year) {
				// Since no month has fewer than 28 days
				var date = new Date(year, month, 1);
				var days = [];
				while (date.getMonth() === month) {
					days.push(new Date(date));
					date.setDate(date.getDate() + 1);
				}
				return days;
			}

			i = 0;
			setDaysInOrder(mon, tue, wed, thur, fri, sat, sund);
			function setDaysInOrder(mon, tue, wed, thur, fri, sat, sund) {
				var days = getDaysInMonth(monthNumber2 - 1, year2);
				$('thead.event-days tr').append('<td>' + mon + '</td><td>' + tue + '</td><td>' + wed + '</td><td>' + thur + '</td><td>' + fri + '</td><td>' + sat + '</td><td>' + sund + '</td>');
			};
			var beforeBlank=0;
			$(getDaysInMonth(monthNumber2 - 1, year2)).each(function(index) {
				var monthDay = getDaysInMonth(monthNumber2 - 1, year2)[0].toString().substring(0, 3);
				if (monthDay === 'Mon') {
					monthDay=1;
				} else if (monthDay === 'Tue') {
					monthDay=2;
				} else if (monthDay === 'Wed') {
					monthDay=3;
				} else if (monthDay === 'Thu') {
					monthDay=4;
				} else if (monthDay === 'Fri') {
					monthDay=5;
				} else if (monthDay === 'Sat') {
					monthDay=6;
				} else if (monthDay === 'Sun') {
					monthDay=7;
				}
				
				index+=1;
				if (index+monthDay-1< 8) {
					if(index==1){
						beforeBlank=index+monthDay-2;
						for(var i=0;i<index+monthDay-2;i++){
							$('tbody.event-calendar tr.1').append('<td class="removehover"></td>');
						}
					}
					$('tbody.event-calendar tr.1').append('<td date-month="' + monthNumber2 + '" date-day="' + index + '" date-year="' + yearNumber + '">' + index + '</td>');
					
				} else if (index+monthDay-1 < 15) {
					$('tbody.event-calendar tr.2').append('<td date-month="' + monthNumber2 + '" date-day="' + index + '" date-year="' + yearNumber + '">' + index + '</td>');
				} else if (index+monthDay-1 < 22) {
					$('tbody.event-calendar tr.3').append('<td date-month="' + monthNumber2 + '" date-day="' + index + '" date-year="' + yearNumber + '">' + index + '</td>');
				} else if (index+monthDay-1 < 29) {
					$('tbody.event-calendar tr.4').append('<td date-month="' + monthNumber2 + '" date-day="' + index + '" date-year="' + yearNumber + '">' + index + '</td>');
				} else if (index+monthDay-1 < 36) {
					$('tbody.event-calendar tr.5').append('<td date-month="' + monthNumber2 + '" date-day="' + index + '" date-year="' + yearNumber + '">' + index + '</td>');					
					var tatolDay=$(getDaysInMonth(monthNumber2 - 1, year2)).length;
					var afterBlank=36-tatolDay-beforeBlank-1;
					if(afterBlank!=0&&tatolDay==index){
						for(var i=0;i<afterBlank;i++){
							$('tbody.event-calendar tr.5').append('<td class="removehover"></td>');
						}
					}
					CALENDAR_ROW_COUNTS = 5 ;
					// 计算行间距，日历为5行 add by 耿杰 2016-12-29
					if (parent.liCounts==undefined) {
						var num = parent.parent.liCounts();
					} else {
						var num = parent.liCounts();
					}
					var rowCounts = 5;
					var conH = num *42 + 39 - 59 ;
					var tdH = Math.floor((conH - rowCounts*30) / 10)-1;
					$(".calendar tbody td").css({ "margin-top" : tdH, "margin-bottom" : tdH });
				} else if(index+monthDay-1 < 43) {
					$('tbody.event-calendar tr.6').append('<td date-month="' + monthNumber2 + '" date-day="' + index + '" date-year="' + yearNumber + '">' + index + '</td>');
					var tatolDay=$(getDaysInMonth(monthNumber2 - 1, year2)).length;
					var afterBlank=43-tatolDay-beforeBlank-1;
					if(afterBlank!=0&&tatolDay==index){
						for(var i=0;i<afterBlank;i++){
							$('tbody.event-calendar tr.6').append('<td class="removehover"></td>');
						}
					}
					CALENDAR_ROW_COUNTS = 6 ;
					// 计算行间距，日历为6行 add by 耿杰 2016-12-29
					if (parent.opener != null) {
						var num = parent.opener.liCounts();
					} else {
						var num = parent.liCounts();
					}
					var rowCounts = 6;
					var conH = num *42 + 39 - 59 ;
					var tdH = Math.floor((conH - rowCounts*30) / 12)-1;
					$(".calendar tbody td").css({ "margin-top" : tdH, "margin-bottom" : tdH });
				} 
				i++;
			});
			
			setCurrentDay(month1, year1);
			initCalendarInfo(year2,monthNumber2,day1,"",monthUrl);
			displayEvent();
			//$('.removehover').unbind("dblclick",f);
		}

		/**
		 * Get current day and set as '.current-day'
		 */
		function setCurrentDay(month, year) {
			var viewMonth = $('.month').attr('data-month');
			var eventYear = $('.event-days').attr('date-year');
			var d = new Date();
			if (parseInt(year) === yearNumber) {
				if (parseInt(month) === parseInt(viewMonth)) {
					$('tbody.event-calendar td[date-day="' + d.getDate() + '"]').addClass('current-day');
				}
			}
		}
		;

		/**
		 * Add class '.active' on calendar date
		 */
		$('tbody td').on('click', function(e) {
			if ($(this).hasClass('event')) {
				//onClickDay($(this));
                $(".list").css("display","block");
                $(".calendar").css({"width":"70%"});

				$('tbody.event-calendar td').removeClass('active');
				$(this).addClass('active');
				// delete by 徐真 2017-01-06 (当点击有事件的日期后第五行偏移严重)
				//$('tbody.event-calendar tr.5 > td:first').css("margin-left","7.5%");
			} else {
				$('tbody.event-calendar td').removeClass('active');
                $(".list").css("display","none");
                $(".calendar").css("width","100%");
			};
						
		});

		/**
		 * Close day-event
		 */
		$('.close').on('click', function(e) {
			$(this).parent().slideUp('fast');
		});

		/**
		 * Save & Remove to/from personal list
		 */
		$('.save').click(
				function() {
					if (this.checked) {
						$(this).next().text('Remove from personal list');
						var eventHtml = $(this).closest('.day-event').html();
						var eventMonth = $(this).closest('.day-event').attr(
								'date-month');
						var eventDay = $(this).closest('.day-event').attr(
								'date-day');
						var eventNumber = $(this).closest('.day-event').attr(
								'data-number');
						$('.person-list').append(
								'<div class="day" date-month="' + eventMonth
										+ '" date-day="' + eventDay
										+ '" data-number="' + eventNumber
										+ '" style="display:none;">'
										+ eventHtml + '</div>');
						$(
								'.day[date-month="' + eventMonth
										+ '"][date-day="' + eventDay + '"]')
								.slideDown('fast');
						$('.day').find('.close').remove();
						$('.day').find('.save').removeClass('save').addClass(
								'remove');
						$('.day').find('.remove').next().addClass(
								'hidden-print');
						remove();
						sortlist();
					} else {
						$(this).next().text('Save to personal list');
						var eventMonth = $(this).closest('.day-event').attr(
								'date-month');
						var eventDay = $(this).closest('.day-event').attr(
								'date-day');
						var eventNumber = $(this).closest('.day-event').attr(
								'data-number');
						$(
								'.day[date-month="' + eventMonth
										+ '"][date-day="' + eventDay
										+ '"][data-number="' + eventNumber
										+ '"]').slideUp('slow');
						setTimeout(function() {
							$(
									'.day[date-month="' + eventMonth
											+ '"][date-day="' + eventDay
											+ '"][data-number="' + eventNumber
											+ '"]').remove();
						}, 1500);
					}
				});

		function remove() {
			$('.remove').click(
					function() {
						if (this.checked) {
							$(this).next().text('Remove from personal list');
							var eventMonth = $(this).closest('.day').attr(
									'date-month');
							var eventDay = $(this).closest('.day').attr(
									'date-day');
							var eventNumber = $(this).closest('.day').attr(
									'data-number');
							$(
									'.day[date-month="' + eventMonth
											+ '"][date-day="' + eventDay
											+ '"][data-number="' + eventNumber
											+ '"]').slideUp('slow');
							$(
									'.day-event[date-month="' + eventMonth
											+ '"][date-day="' + eventDay
											+ '"][data-number="' + eventNumber
											+ '"]').find('.save').attr(
									'checked', false);
							$(
									'.day-event[date-month="' + eventMonth
											+ '"][date-day="' + eventDay
											+ '"][data-number="' + eventNumber
											+ '"]').find('span').text(
									'Save to personal list');
							setTimeout(function() {
								$(
										'.day[date-month="' + eventMonth
												+ '"][date-day="' + eventDay
												+ '"][data-number="'
												+ eventNumber + '"]').remove();
							}, 1500);
						}
					});
		}

		/**
		 * Sort personal list
		 */
		function sortlist() {
			var personList = $('.person-list');

			personList.find('.day').sort(
					function(a, b) {
						return +a.getAttribute('date-day')
								- +b.getAttribute('date-day');
					}).appendTo(personList);
		}

		/**
		 * Print button
		 */
		$('.print-btn').click(function() {
			window.print();
		});
	},

	sprintf: function() {
		var i = 0,
		a, f = arguments[i++],
		o = [],
		m,
		p,
		c,
		x,
		s = '';
		while (f) {
			if (m = /^[^\x25]+/.exec(f)) {
				o.push(m[0]);
			}
			else if (m = /^\x25{2}/.exec(f)) {
				o.push('%');
			}
			else if (m = /^\x25(?:(\d+)\$)?(\+)?(0|'[^$])?(-)?(\d+)?(?:\.(\d+))?([b-fosuxX])/.exec(f)) {
				if (((a = arguments[m[1] || i++]) == null) || (a == undefined)) {
					//throw('Too few arguments.');
					m[1] = 0;
				}
				if (/[^s]/.test(m[7]) && (typeof(a) != 'number')) {
					throw ('Expecting number but found ' + typeof(a));
				}
				switch (m[7]) {
				case 'b':
					a = a.toString(2);
					break;
				case 'c':
					a = String.fromCharCode(a);
					break;
				case 'd':
					a = parseInt(a);
					break;
				case 'e':
					a = m[6] ? a.toExponential(m[6]) : a.toExponential();
					break;
				case 'f':
					a = m[6] ? parseFloat(a).toFixed(m[6]) : parseFloat(a);
					break;
				case 'o':
					a = a.toString(8);
					break;
				case 's':
					a = ((a = String(a)) && m[6] ? a.substring(0, m[6]) : a);
					break;
				case 'u':
					a = Math.abs(a);
					break;
				case 'x':
					a = a.toString(16);
					break;
				case 'X':
					a = a.toString(16).toUpperCase();
					break;
				}
				a = (/[def]/.test(m[7]) && m[2] && a >= 0 ? '+' + a: a);
				c = m[3] ? m[3] == '0' ? '0': m[3].charAt(1) : ' ';
				x = m[5] - String(a).length - s.length;
				p = m[5] ? str_repeat(c, x) : '';
				o.push(s + (m[4] ? a + p: p + a));
			}
			else {
				throw ('Huh ?!');
			}
			f = f.substring(m[0].length);
		}
		return o.join('');
	}

};

function intervalLoadData(){
	if (parent.parent.IS_SYS_ON_LINE){
		calendar.init('calendar/getUserCalendarByToDay');
	}
}



/**
 * Add '.event' class to all days that has an event
 */
function setEvent(year) {
	$('.day-event').each(function(i) {
		var eventMonth = $(this).attr('date-month');
		var eventDay = $(this).attr('date-day');
		var eventYear = $(this).attr('date-year');
		var eventClass = $(this).attr('event-class');
		if (eventClass === undefined) {
			eventClass = 'event';
		}else {
			eventClass = 'event ' + eventClass;
		}
		if (parseInt(eventYear) === year) {
			$('tbody.event-calendar tr td[date-month="' + eventMonth + '"][date-day="' + eventDay + '"]').addClass(eventClass);
		}
	});
};

/**
 * Get current day on click in calendar and find day-event to display
 */
function displayEvent() {
	$('tbody.event-calendar td').on('click',function(e){
		$('.day-event').slideUp('fast');
		var monthEvent = $(this).attr('date-month');
		var dayEvent = $(this).text();
		$('.day-event[date-month="' + monthEvent + '"][date-day="' + dayEvent + '"]').slideDown('fast');
	});
};
/**
 * 阿拉伯日期转换成中文日期
 * @param date
 * @returns {String}
 */
function dateToChinDate(date){
	    var chinese = ['〇', '一', '二', '三', '四', '五', '六', '七', '八', '九'];  
	    var y = date.getFullYear().toString();  
	    var m = (date.getMonth()+1).toString();  
	    var d = date.getDate().toString();  
	    var result = "";  
	    for (var i = 0; i < y.length; i++) {  
	        result += chinese[y.charAt(i)];  
	    }  
	    result += "年";  
	    if (m.length == 2) {  
	        if (m.charAt(0) == "1") {  
	            result += ("十" + chinese[m.charAt(1)] + "月");  
	        }  
	    }   
	    else {  
	        result += (chinese[m.charAt(0)] + "月");  
	    }   
	    if (d.length == 2) {  
	        result += (chinese[d.charAt(0)] + "十" + chinese[d.charAt(1)] + "日");  
	    }   
	    else {  
	        result += (chinese[d.charAt(0)] + "日");  
	    }  
	  return  result;  
}
