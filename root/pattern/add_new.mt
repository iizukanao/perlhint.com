? extends 'common/base';

<? block title => sub {?>New Pattern | PerlHint<? } ?>

? block content => sub {
<div class="breadcrumb">
<a href="<?= $c->uri_for('/') ?>">Top</a> &gt; <a href="<?= $c->uri_for('/pattern/') ?>">Patterns</a> &gt; New
</div>
<form method="POST" class="pattern-form" action="<?= $c->uri_for('/pattern/create') ?>">
パターン名（[a-zA-Z0-9_-]）<br />
<? if ( form->error_message('name') ) { ?>
  <div class="error">
    <?= raw_string( form->error_message('name') ) ?>
  </div>
<? } ?>
<?= raw_string( form->input('name') ) ?><br />
<br />
正規表現（TODO: 書き方）<br />
<? if ( form->error_message('pattern') ) { ?>
  <div class="error">
    <?= raw_string( form->error_message('pattern') ) ?><br />
  </div>
<? } ?>
<?= raw_string( form->input('pattern') ) ?><br />
<br />
解説（$1使用可）<br />
<? if ( form->error_message('description') ) { ?>
  <div class="error">
    <?= raw_string( form->error_message('description') ) ?><br />
  </div>
<? } ?>
<?= raw_string( form->input('description') ) ?><br />
<br />
<input type="submit" value="　作成　" />
</form>
? }
