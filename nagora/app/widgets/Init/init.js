var Init = {
    checkNode : function() {
        // TODO : very ugly, need to refactor this
        var username = localStorage.getItem("username");
        if(username == null) return;

        var jid = username.replace("@", "at");
        var init = localStorage.getObject(jid + "_Init3") || {};
        if(init.initialized != 'true') {
            Init_ajaxCreatePersistentStorage('storage:bookmarks');
            Init_ajaxCreatePersistentPEPStorage('urn:xmpp:vcard4');
            Init_ajaxCreatePersistentPEPStorage('urn:xmpp:avatar:data');
            Init_ajaxCreatePersistentPEPStorage('http://jabber.org/protocol/geoloc');
            Init_ajaxCreatePersistentPresenceStorage('urn:xmpp:pubsub:subscription');
            Init_ajaxCreatePersistentPresenceStorage('urn:xmpp:microblog:0');
        }
    },
    setNode : function(node) {
        // TODO : need to refactor this too
        var username = localStorage.getItem("username");
        if(username == null) return;

        var jid = username.replace("@", "at");
        var init = localStorage.getObject(jid + "_Init3") || {};
        init.initialized = 'true';
        localStorage.setObject(jid + "_Init3", init);
    }
}

MovimWebsocket.attach(function()
{
    Init.checkNode();
});
