<?hhp this.widget('Search');?>
<?hhp this.widget('Notification');?>
<?hhp this.widget('VisioLink');?>
<?hhp this.widget('Upload'); ?>

<?hhp this.widget('PostActions');?>

<nav class="color dark">
    <?hhp this.widget('Presence');?>
    <?hhp this.widget('Navigation');?>
</nav>

<?hhp this.widget('BottomNavigation');?>

<main>
    <section style="background-color: var(--movim-background)">
        <?php if(empty($_GET['s'])) { ?>
            <div>
                <header>
                    <ul class="list middle">
                        <li>
                            <p class="center"><?php this.echo(Locale.start().translate('page.communities')); ?></p>
                            <p class="center line"><?php this.echo(Locale.start().translate('communities.empty_text')); ?></p>
                        </li>
                    </ul>
                </header>
                <?hhp this.widget('Tabs');?>
                <?hhp this.widget('Communities'); ?>
                <?hhp this.widget('CommunitiesServers'); ?>
                <?hhp if(this.user.isSupported('pubsub')) { ?>
                    <?hhp this.widget('CommunitySubscriptions'); ?>
                <?hhp } ?>
            </div>
        <?php else if(empty($_GET['n'])) { ?>
            <aside>
                <?hhp this.widget('CommunitiesServerInfo'); ?>
                <?hhp this.widget('NewsNav');?>
            </aside>
            <?hhp this.widget('CommunitiesServer'); ?>

        <?php } else { ?>
            <aside>
                <?hhp this.widget('CommunityData'); ?>
                <?hhp this.widget('CommunityConfig'); ?>
                <?hhp this.widget('CommunityAffiliations'); ?>
            </aside>
            <div id="community">
            <?hhp this.widget('CommunityHeader'); ?>
            <?hhp this.widget('CommunityPosts'); ?>
            </div>
        <?php } ?>
    </section>
</main>
