/**
 * Movim Websocket
 *
 * This file define the websocket behaviour and handle its connection
 */

WebSocket.prototype.unregister = function() {
    this.send(JSON.stringify({'func' : 'unregister'}));
};

WebSocket.prototype.register = function(host) {
    this.send(JSON.stringify({'func' : 'register', 'host' : host}));
};

/**
 * @brief Definition of the MovimWebsocket object
 * @param string error
 */

var MovimWebsocket = {
    connection: null,
    attached: [],
    registered: [],
    attempts: 1,
    pong: false,
    closed: false,

    launchAttached : function() {
        // We hide the Websocket error
        document.getElementById('error_websocket').classList.add('hide');

        for(var i = 0; i < MovimWebsocket.attached.length; i++) {
            MovimWebsocket.attached[i]();
        }
    },

    launchRegistered : function() {
        for(var i = 0; i < MovimWebsocket.registered.length; i++) {
            MovimWebsocket.registered[i]();
        }
    },

    init : function() {
        if(SECURE_WEBSOCKET) {
            var uri = 'wss://' + BASE_HOST + '/ws/';
        } else {
            var uri = 'ws://' + BASE_HOST + '/ws/';
        }

        if(this.connection
        && this.connection.readyState == 1) {
            this.connection.onclose = null;
            this.connection.close();
        }

        var date = new Date();

        this.connection = new WebSocket(uri +
            '?path=' + MovimUtils.urlParts().page +
            '&offset=' + date.getTimezoneOffset());

        this.connection.onopen = function(e) {
            console.log("Connection established!");
            MovimWebsocket.attempts = 1;
            MovimWebsocket.launchAttached();
            setTimeout(function(){
                MovimWebsocket.ping();
            }, 10000);
        };

        this.connection.onmessage = function(e) {
            var obj = JSON.parse(e.data);

            if(obj != null) {
                if(obj.func == 'registered') {
                    MovimWebsocket.launchRegistered();
                }

                if(obj.func == 'disconnected') {
                    MovimUtils.disconnect();
                }

                if(obj.func == 'pong') {
                    MovimWebsocket.pong = true;
                }

                if(obj.func == 'block') {
                    MovimWebsocket.clearAttached();
                    document.body.classList.add('disabled');
                }

                MovimWebsocket.handle(obj);
            }
        };

        this.connection.onclose = function(e) {
            console.log("Connection closed by the server or session closed");

            if(e.code == 1008) {
                // The server closed the connection and asked to keep it this way
                this.closed = true;
                document.getElementById('error_websocket').classList.remove('hide');
                MovimWebsocket.connection.close();
            } if(e.code == 1006) {
                MovimWebsocket.reconnect();
            } else if(e.code == 1000) {
                MovimUtils.disconnect();
            }
        };

        this.connection.onerror = function(e) {
            console.log("Connection error!");

            // We show the Websocket error
            document.getElementById('error_websocket').classList.remove('hide');

            MovimWebsocket.reconnect();

            // We prevent the onclose launch
            this.onclose = null;
        };
    },

    send : function(widget, func, params) {
        if(this.connection.readyState == 1) {
            this.connection.send(
                JSON.stringify(
                    {'func' : 'message', 'body' :
                        {
                            'widget' : widget,
                            'func' : func,
                            'params' : params
                        }
                    }
                )
            );
        }
    },

    sendAjax : function(widget, func, params) {
        let xhr = new XMLHttpRequest;

        xhr.open('POST', '?ajax');
        xhr.setRequestHeader('Content-Type', 'application/json;charset=UTF-8');
        xhr.send(JSON.stringify(
            {'func' : 'message', 'body' :
                {
                    'widget' : widget,
                    'func' : func,
                    'params' : params
                }
            }
        ));

        return xhr;
    },

    // A ping/pong system to handle socket errors for buggy browser (Chrome on Linux…)
    ping : function() {
        if(this.connection.readyState == 1 && !this.closed) {
            this.connection.send(
                JSON.stringify(
                    {'func' : 'ping'}
                )
            );

            setTimeout(function(){
                if(MovimWebsocket.pong == false) {
                    MovimWebsocket.connection.onerror();
                } else {
                    MovimWebsocket.pong = false;
                    MovimWebsocket.ping();
                }
            }, 10000);
        }
    },

    attach : function(func) {
        if(typeof(func) === "function") {
            this.attached.push(func);
        }
    },

    register : function(func) {
        if(typeof(func) === "function") {
            this.registered.push(func);
        }
    },

    clearAttached : function() {
        this.attached = [];
    },

    handle : function(funcall) {
        if(funcall.func != null && (typeof window[funcall.func] == 'function')) {
            try {
                window[funcall.func].apply(null, funcall.params);
            } catch(err) {
                console.log("Error caught: "
                    + err.toString()
                    + " - "
                    + funcall.func
                    + ":"
                    + JSON.stringify(funcall.params)
                );
            }
        } else if(funcall.func != null) {
            var funcs  = funcall.func.split('.');
            var called = funcs[0];
            if(typeof window[called] == 'object'
            && typeof window[funcs[0]][funcs[1]] != 'undefined') {
                window[funcs[0]][funcs[1]].apply(null, funcall.params);
            }
        }
    },

    unregister : function(reload) {
        this.connection.unregister();
    },

    reconnect : function() {
        var interval = MovimWebsocket.generateInterval();
        console.log("Try to reconnect");
        setTimeout(function () {
            // We've tried to reconnect so increment the attempts by 1
            MovimWebsocket.attempts++;

            // Connection has closed so try to reconnect every 10 seconds.
            MovimWebsocket.init();
        }, interval);
    },

    generateInterval :function() {
        var maxInterval = (Math.pow(2, MovimWebsocket.attempts) - 1) * 1000;

        if (maxInterval > 30*1000) {
            maxInterval = 30*1000; // If the generated interval is more than 30 seconds, truncate it down to 30 seconds.
        }

        // generate the interval to a random number between 0 and the maxInterval determined from above
        return Math.random() * maxInterval;
    }
}

window.onbeforeunload = function() {
    MovimWebsocket.connection.onclose = function () {}; // disable onclose handler first
    MovimWebsocket.connection.close()
};

document.addEventListener("DOMContentLoaded", function(event) {
    // And we start it
    MovimWebsocket.init();
});
