(function($) {
    $(document).ready(function() {
        // Check if there was a saved application state
        //var stateCookie = org.cometd.COOKIE ? org.cometd.COOKIE.get('cn.yonyou.cap-base.cometd.state') : null;
        //var state = stateCookie ? org.cometd.JSON.fromJSON(stateCookie) : null;
        var chat = new Chat(null);
        chatGlobal=chat;
        chatGlobal.join(currenUser);
    });

    /**
     * @param state
     */
    function Chat(state) {
        var _self = this;
        var _connected = false;
        var _username;
        var _lastUser;
        var _disconnecting;
        var _chatSubscription;
        var _membersSubscription;

        this.join = function(username) {
            _disconnecting = false;
            _username = username;
            if (!_username) {
                layerAlert('服务器出错，请重新登录！');
                return;
            }

            var cometdURL = location.protocol + "//" + location.host + config.contextPath + "/cometd";

            //layerAlert(cometdURL);
            $.cometd.configure({
                url: cometdURL,
                logLevel: 'debug'
            });
            $.cometd.handshake();

        };

        this.leave = function() {
            $.cometd.batch(function() {
                $.cometd.publish('/service/online', {
                    user: _username,
                    membership: 'leave',
                    chat: _username + ' has left'
                });
                _unsubscribe();
            });
            $.cometd.disconnect();

            $('#join').show();
            $('#joined').hide();
            $('#username').focus();
            $('#members').empty();
            _username = null;
            _lastUser = null;
            _disconnecting = true;
        };

        this.send = function(userMessage) {
            var text = userMessage.msgContent;
            var toUser = userMessage.msgTo;
            if (!text || !text.length) return;
            
            if(!toUser||toUser=='undefined') {
            	return;
            }
            $.cometd.publish('/service/privatechat', {
                room: '/chat/demo',
                user: _username,
                chat: text,
                peer: toUser
            });
        };

        this.receive = function(message) {
            var fromUser = message.data.user;
            var text = message.data.chat;

            var chat = $('#chat');
            if (message.data.scope == 'private') {
               //TODO show the message
    			var messages=[];
    			var temp=new Object();
    			temp.msgFrom=fromUser;
    			temp.msgTo=currenUser;
    			temp.msgTime="";
    			temp.msgContent=text;
    			messages.push(temp);
    			operateMsg(messages,temp.msgFrom);
            }
        };

        /**
         * Updates the members list.
         * This function is called when a message arrives on channel /chat/members
         */
        this.members = function(message) {
//            var list = '';
//            $.each(message.data, function() {
//                list += this + '<br />';
//            });
//            $('#members').html(list);
        	//TODO user online message
        };
        /**
         * show the message about the connection of the server
         * This function is called when connection events happen
         */
        this.serverInfor = function(message){
            var text = message.data.chat;
        	var currChat=getCurrentChatbox();
        	
        	//get chatbox id, this id is to user
        	var toUser=$(currChat).attr("id");
        	
        	var messages=[];
        	var msg=new Object();
        	msg.msgContent=text;
        	msg.msgFrom=currenUser;
        	msg.msgTo=toUser;
        	var mydate = new Date();
        	msg.msgTime=mydate.toLocaleString();
        	messages.push(msg);
        	
        	//load the send message in the talkbox
        	//loadMsgs( messages, toUser );
        	
        };
        
        //取消订阅
        function _unsubscribe() {
        	//如果成功添加预订，则取消
            if (_chatSubscription) {
                $.cometd.unsubscribe(_chatSubscription);
            }
            _chatSubscription = null;
            if (_membersSubscription) {
                $.cometd.unsubscribe(_membersSubscription);
            }
            _membersSubscription = null;
        }

        function _subscribe() {
        	//添加订阅信息的处理函数
            _chatSubscription = $.cometd.subscribe('/service/privatechat', _self.receive);
            //添加订阅好友情况的处理函数
            _membersSubscription = $.cometd.subscribe('/service/online', _self.members);
        }

        function _connectionInitialized() {
            // first time connection for this client, so subscribe tell everybody.
            $.cometd.batch(function() {
                _subscribe();
                $.cometd.publish('/service/online', {
                    user: _username,
                    membership: 'join',
                    chat: _username + ' has joined'
                });
            });
            //once handshake success, then get messages manually
            starRecMsg();
        }

        function _connectionEstablished() {
            // connection establish (maybe not for first time), so just
            // tell local user and update membership
            _self.serverInfor({
                data: {
                    user: 'system',
                    chat: 'Connection to Server Opened'
                }
            });
            $.cometd.publish('/service/online', {
                user: _username,
                room: '/chat/demo'
            });
        }

        function _connectionBroken() {
            _self.serverInfor({
                data: {
                    user: 'system',
                    chat: 'Connection to Server Broken'
                }
            });
            //$('#members').empty();
           // $.cometd.disconnect();
        }

        function _connectionClosed() {
            _self.serverInfor({
                data: {
                    user: 'system',
                    chat: 'Connection to Server Closed'
                }
            });
           // $.cometd.disconnect();
        }

        function _metaConnect(message) {
            if (_disconnecting) {
                _connected = false;
                _connectionClosed();
            } else {
                var wasConnected = _connected;
                _connected = message.successful === true;
                if (!wasConnected && _connected) {
                    _connectionEstablished();
                } else if (wasConnected && !_connected) {
                    _connectionBroken();
                }
            }
        }
        //process the handshake
        function _metaHandshake(message) {
            if (message.successful) {
                _connectionInitialized();
            }
        }

        $.cometd.addListener('/meta/handshake', _metaHandshake);
        $.cometd.addListener('/meta/connect', _metaConnect);

//        // Restore the state, if present
//        if (state) {
//            setTimeout(function() {
//                // This will perform the handshake
//                _self.join(state.username);
//            }, 0);
//        }
//
//        $(window).unload(function() {
//            $.cometd.reload();
//            // Save the application state only if the user was chatting
//            if (_username) {
//                var expires = new Date();
//                expires.setTime(expires.getTime() + 5 * 1000);
//                org.cometd.COOKIE.set('cn.yonyou.nxtbgms.cometd.state', org.cometd.JSON.toJSON({
//                    username: _username,
//                }), {'max-age': 5, expires: expires});
//                $.cometd.getTransport().abort();
//            } else {
//                $.cometd.disconnect();
//            }
//        });
    }

})(jQuery);

