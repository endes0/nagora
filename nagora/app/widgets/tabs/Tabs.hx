package app.widgets.tabs;

import js.Browser;

class Tabs extends movim.widget.Base {
    override public function load() : Void {
        Main.post_display.push(this.create);
    }

    public function create() : Void {
      #if hxnodejs
      // We search all the div with "tab" class
      var tabs : js.html.HTMLCollection = cast( Browser.document.querySelectorAll('.tabelem') );
      var current = '';

      // We create the list
      var html = '';
      for( tab in tabs ) {
        if(Browser.window.location.hash == '#' + tab.id + '_tab') {
            current = tab.id;
        }

        html += '<li class="' + tab.id + '" onclick="app.widgets.tabs.Tabs.change(this);">';
        html += '    <a href="#" onclick="return false">' + tab.title + '</a>';
        html += '</li>';
      }

      // We show the first tab
      tabs[0].classList.remove('hide');

      // We insert the list
      Browser.document.querySelector('#navtabs').innerHTML = html;

      var menuTab : js.html.Element;
      if(current != ''){
          var tab = current;
          menuTab = Browser.document.querySelector('li.' + current);
      } else {
          //if no tab is active, activate the first one
          var tab = Browser.document.querySelector('.tabelem').id;
          menuTab = Browser.document.querySelector('li.'+ tab);
      }

      Tabs.change(menuTab);

      Browser.window.onhashchange = function() {
          var hash = Browser.window.location.hash.substr(1, -4);
          if(hash != null && hash != '') {
              Tabs.change(Browser.document.querySelector('li.' + hash));
          }
      }
      #end
    }

    @:expose public static function change(current: js.html.Element) : Void {
      // We grab the tabs list
      var navtabs = Browser.document.querySelectorAll('#navtabs li');
      // We clean the class of the li
      for( tab in navtabs ) {
        cast( tab, js.html.Element ).classList.remove('active');
      }

      // We add the "on" class to the selected li
      var selected = current.className;
      current.classList.add('active');

      // We hide all the div
      var tabs = Browser.document.querySelectorAll('.tabelem');
      for( tab in tabs ) {
        cast( tab, js.html.Element ).classList.add('hide');
      }

      // We show the selected div
      var tabOn = Browser.document.getElementById(selected);
      tabOn.classList.remove('hide');

      Browser.window.history.pushState(null, null, '#' + selected + '_tab');

      // We try to call ajaxDisplay
      /*if(typeof window[tabOn.title + '_ajaxDisplay'] == 'function') {
          window[tabOn.title + '_ajaxDisplay'].apply();
      }*/

      // We reset the scroll
      cast( Browser.document.querySelector('#navtabs').parentNode, js.html.Element ).scrollTop = 0;
  }
}
