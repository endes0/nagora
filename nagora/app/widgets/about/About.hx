/**
 * @package Widgets
 *
 * @file About.php
 * This file is part of MOVIM.
 *
 * @brief A widget which display some help
 *
 * @author endes
 * @author Timothée
 *
 * See COPYING for licensing information.
 */
package app.widgets.about;

class About extends movim.widget.Base {
    override public function load() : Void {
    }

    override public function display() : Void {
        this.view[this.name].data = {version: Main.app.version};
    }
}
