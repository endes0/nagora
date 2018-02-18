<?php $this->widget('Search');?>
<?php $this->widget('Notification');?>
<?php $this->widget('VisioLink');?>
<?php $this->widget('Stickers');?>

<nav class="color dark">
    <?php $this->widget('Presence');?>
    <?php $this->widget('Navigation');?>
</nav>

<?php $this->widget('BottomNavigation');?>

<main>
    <section>
        <div>
            <?php $this->widget('Chats');?>
            <?php $this->widget('Rooms');?>
        </div>
        <?php $this->widget('Upload');?>
        <?php $this->widget('Chat');?>
    </section>
</main>

