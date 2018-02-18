<div id="visio" class="">
    <header class="fixed">
        <ul class="list">
            <li>
                <span id="toggle_fullscreen" class="control icon color transparent active" onclick="Visio.toggleFullScreen()">
                    <i class="zmdi zmdi-fullscreen"></i>
                </span>
                <span id="toggle_audio" class="control icon color transparent active" onclick="Visio.toggleAudio()">
                    <i class="zmdi zmdi-mic"></i>
                </span>
                <span id="toggle_video" class="control icon color transparent active" onclick="Visio.toggleVideo()">
                    <i class="zmdi zmdi-videocam"></i>
                </span>
            </li>
        </ul>
    </header>

    <ul class="list infos" class="list middle">
        {$url = $contact->getPhoto('l')}
        <li>
            {if="$url"}
                <p class="center">
                    <img src="{$url}">
                </p>
            {/if}

            <p class="normal center	">
                {$contact->getTrueName()}
            </p>
            <p class="normal state center"></p>
        </li>
    </ul>

    <video id="video" autoplay muted></video>
    <video id="remote_video" autoplay></video>
    <canvas class="level"></canvas>
    <div class="controls">
        <a id="main" class="button action color gray">
            <i class="zmdi zmdi-phone"></i>
        </a>
    </div>
</div>
<script type="text/javascript">
Visio.states = {
    calling: '{$c->__('visio.calling')}',
    ringing: '{$c->__('visio.ringing')}',
    in_call: '{$c->__('visio.in_call')}',
    failed: '{$c->__('visio.failed')}',
    connecting: '{$c->__('visio.connecting')}'
}
</script>
