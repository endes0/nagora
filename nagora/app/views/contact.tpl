<?hhp this.widget('Notification');?>
<?hhp this.widget('Search');?>
<?hhp this.widget('VisioLink');?>
<?hhp this.widget('PostActions');?>
<?hhp this.widget('ContactActions');?>

<nav class="color dark">
    <?hhp this.widget('Presence');?>
    <?hhp this.widget('Navigation');?>
</nav>

<?hhp this.widget('BottomNavigation');?>

<main>
    <section style="background-color: var(--movim-background);">
        <?php if(empty($_GET['s'])) { ?>
            <aside>
                <?hhp this.widget('ContactDisco');?>
            </aside>
            <div>
                <?hhp this.widget('Invitations');?>
                <?hhp this.widget('Tabs');?>

                <?hhp this.widget('Roster');?>
                <?hhp this.widget('ContactDiscoPosts');?>
            </div>
        <?php } else { ?>
            <aside>
                <?hhp this.widget('ContactData'); ?>
                <?hhp this.widget('AdHoc'); ?>
            </aside>
            <div>
                <?hhp this.widget('ContactHeader'); ?>
                <?hhp this.widget('CommunityPosts'); ?>
            </div>
        <?php } ?>
    </section>
</main>
