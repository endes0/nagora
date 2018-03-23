var DesktopNotification = Notification;

var Notification = {
    inhibed : false,
    focused : false,
    tab_counter1 : 0,
    tab_counter2 : 0,
    tab_counter1_key : 'chat',
    tab_counter2_key : 'news',
    document_title_init : null,
    document_title : document.title,
    notifs_key : '',
    favicon : null,
    electron : null,

    inhibit : function(sec) {
        Notification.inhibed = true;

        if(sec == null) sec = 5;

        setTimeout(function() {
                Notification.inhibed = false;
            },
            sec*1000);
    },
    refresh : function(keys) {
        var counters = document.querySelectorAll('.counter');
        for(i = 0; i < counters.length; i++) {
            var n = counters[i];
            if(n.dataset.key != null
            && keys[n.dataset.key] != null) {
                n.innerHTML = keys[n.dataset.key];
            }
        }

        for(var key in keys) {
            var counter = keys[key];
            Notification.setTab(key, counter);
        }

        Notification.displayTab();
    },
    counter : function(key, counter) {
        var counters = document.querySelectorAll('.counter');
        for(i = 0; i < counters.length; i++) {
            var n = counters[i];
            if(n.dataset.key != null
            && n.dataset.key == key) {
                n.innerHTML = counter;
            }
        }

        Notification.setTab(key, counter);
        Notification.displayTab();
    },
    setTab : function(key, counter) {
        if(counter == '') counter = 0;

        if(Notification.tab_counter1_key == key) {
            Notification.tab_counter1 = counter;
        }
        if(Notification.tab_counter2_key == key) {
            Notification.tab_counter2 = counter;
        }
    },
    displayTab : function() {
        if(Notification.tab_counter1 == 0 && Notification.tab_counter2 == 0) {
            document.title = Notification.document_title;

            if(Notification.favicon != null)
                Notification.favicon.badge(0);

            if(Notification.electron != null)
                Notification.electron.notification(false);
        } else {
            document.title =
                '('
                + Notification.tab_counter1
                + '/'
                + Notification.tab_counter2
                + ') '
                + Notification.document_title;

            if(Notification.favicon != null)
                Notification.favicon.badge(Notification.tab_counter1 + Notification.tab_counter2);

            if(Notification.electron != null)
                Notification.electron.notification(Notification.tab_counter1 + Notification.tab_counter2);
        }
    },
    current : function(key) {
        Notification.notifs_key = key;
        Notification_ajaxCurrent(Notification.notifs_key);
    },
    toast : function(title) {
        // Android notification
        if(typeof Android !== 'undefined') {
            Android.showToast(title);
            return;
        }

        target = document.getElementById('toast');

        if(target) {
            target.innerHTML = title;
        }

        setTimeout(function() {
            target = document.getElementById('toast');
            target.innerHTML = '';
        }, 3000);
    },
    snackbar : function(html, time) {
        if(typeof Android !== 'undefined'
        || Notification.inhibed == true) return;

        target = document.getElementById('snackbar');

        if(target) {
            target.innerHTML = html;
        }

        setTimeout(function() {
            Notification.snackbarClear();
        }, time*1000);
    },
    snackbarClear : function() {
        target = document.getElementById('snackbar');
        target.innerHTML = '';
    },
    desktop : function(title, body, picture, action, execute) {
        if(Notification.inhibed == true
        || Notification.focused
        || typeof DesktopNotification === 'undefined') return;

        var notification = new DesktopNotification(title, { icon: picture, body: body });

        if(action !== null) {
            notification.onclick = function() {
                window.location.href = action;
                Notification.snackbarClear();
                this.close();
            }
        }

        if(execute !== null) {
            notification.onclick = function() {
                eval(execute);
                Notification.snackbarClear();
                this.close();
            }
        }
    },
    android : function(title, body, picture, action) {
        if(typeof Android !== 'undefined') {
            Android.showNotification(title, body, picture, action);
            return;
        }
    }
}

Notification.document_title_init = document.title;

if(typeof MovimWebsocket != 'undefined') {
    MovimWebsocket.attach(function() {
        if(typeof Favico != 'undefined') {
            Notification.favicon = new Favico({
                animation: 'none',
                fontStyle: 'normal',
                bgColor: '#FF5722'
            });
        }

        if(typeof require !== 'undefined') {
            var remote = require('electron').remote;
            Notification.electron = remote.getCurrentWindow();
        }

        Notification.document_title = Notification.document_title_init;
        Notification.tab_counter1 = Notification.tab_counter2 = 0;
        Notification_ajaxGet();
        Notification.current(Notification.notifs_key);

        document.addEventListener('blur', function() {
            Notification.focused = false;
            Notification_ajaxCurrent('blurred');
        });

        document.addEventListener('focus', function() {
            Notification.focused = true;
            Notification.current(Notification.notifs_key);
            Notification_ajaxClear(Notification.notifs_key);
        });
    });
}

