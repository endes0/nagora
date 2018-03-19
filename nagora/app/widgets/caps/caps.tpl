<div id="caps_widget" class="tabelem paddedtop" title="Capabilities">
    <h1>Capabilities</h1>

    <h2>Legend</h2>
    <table>
        <tbody>
            <tr>
                <td>Chat</td>
                <td class="chat yes">0xxx</td>
                <td>Jingle</td>
                <td class="jingle yes">0xxx</td>
                <td>Rayo</td>
                <td class="rayo yes">0xxx</td>
                <td>IoT</td>
                <td class="iot yes">0xxx</td>
                <td>Profile</td>
                <td class="profile yes">0xxx</td>
                <td>Client</td>
                <td class="client yes">0xxx</td>
                <td>Social</td>
                <td class="social yes">0xxx</td>
            </tr>
        </tbody>
    </table>

    <h2>Table</h2>
    <table>
        <thead>
            <tr>
                <th>Client</th>
                <th>Count</th>
                <?hpp for(key in this.data.nslist.keys()) { ?>
                    <th><a href="#" onclick="Main.change_page('about', [<?hpp this.echo(key) ?>], 'xep_widget')"><?hpp this.echo(key) ?></a></th>
                <?hpp } ?>
            </tr>
        </thead>

        <tbody>
            <?hpp for(key in this.data.table.keys()) { ?>
            <tr>
                <td title="<?hpp this.echo(key) ?>"><?hpp this.echo(key) ?></td>
                <td><?hpp this.echo(this.data.table[key].length) ?></td>
                <?hpp var client = this.data.table[key] ?>
                <?hpp for(key in this.data.nslist.keys()) { ?>
                    <?hpp this.isImplemented(client, key); ?>
                <?hpp } ?>
            </tr>
            <?hpp } ?>
        </tbody>
    </table>
</div>
