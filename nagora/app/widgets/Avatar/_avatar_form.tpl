<br />

<h3 class="block large">{$c->__('page.avatar')}</h3>

<div class="flex">
    <div id="avatar_preview" class="block">
        <div>
            <form name="avatarform" id="avatarform">
                {if="isset($photobin) && $photobin != ''"}
                    <img src="data:image/jpeg;base64,{$photobin}">
                {else}
                    <img src="#" class="error">
                    <ul class="list thick">
                        <li>
                            <span class="primary icon bubble color {$me->jid|stringToColor}">
                                <i class="zmdi zmdi-account"></i>
                            </span>
                            <p class="normal line">{$c->__('avatar.missing')}</p>
                        </li>
                    </ul>
                {/if}
                <input type="hidden" name="photobin" value="{$photobin}"/>
            </form>
        </div>
    </div>
    <div class="block">
        <ul class="list thick divided">
            <li>
                <span class="primary icon bubble color green">
                    <i class="zmdi zmdi-attachment-alt"></i>
                </span>
                <p>{$c->__('avatar.file')}</p>
                <p><input type="file" onchange="Avatar.file(this.files);"></p>
            </li>
        </ul>
    </div>
</div>
    <!--
    <div class="block">
        <input type="file" onchange="vCardImageLoad(this.files);">
        <label for="avatar">{$c->__('page.avatar')}</label>
        <input type="hidden" name="photobin"  value="{$photobin}"/>
    </div>

    {if="isset($gravatar)"}
    <div class="block">
        <h4>Gravatar</h4>
        {$gravatar->entry[0]|var_dump}
        <img src="http://www.gravatar.com/avatar/{$gravatar->entry[0]->hash}?s=500" />
    </div>
    {/if}

    <div class="block" id="result">
        <img id="vCardPhotoPreview" src="data:image/jpeg;base64,{$photobin}">
        <span id="picturesize" class="clean"></span>
    </div>

    <div id="camdiv" class="block">
        <video id="runningcam" class="squares" autoplay></video>
        <canvas style="display:none;"></canvas>

        <a
            id="shoot"
            class="button flat oppose"
            onclick="return false;">
            {$c->__('avatar.cheese')}
        </a>
        <a
            id="capture"
            class="button flat"
            onclick="
                showVideo();
                return false;">
            {$c->__('avatar.snapshot')}
        </a>
        <label for="url">{$c->__('avatar.webcam')}</label>
    </div>-->

<div class="block large">
    <button
        type="button"
        onclick="
            {$submit}
            this.value = '{$c->__('button.submitting')}';
            this.className='button inactive oppose';"
        class="button color oppose"
        id="avatarvalidate"
        >{$c->__('button.submit')}</button>
</div>
