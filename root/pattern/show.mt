? extends 'common/base';
<? my $pattern = stash->{pattern}; ?>

<? block title => sub {?>Pattern <?= $pattern->name ?> | PerlHint<? } ?>

? block content => sub {
<div class="breadcrumb">
<a href="<?= $c->uri_for('/') ?>">Top</a> &gt; <a href="<?= $c->uri_for('/pattern/') ?>">Patterns</a> &gt; <?= $pattern->name ?>
</div>
<? if ( stash->{flash} ) { ?>
  <div class="flash">
    <?= stash->{flash} ?>
  </div>
<? } ?>
<a href="<?= $c->uri_for('/pattern/edit/'.$pattern->id) ?>">[編集]</a>&nbsp;&nbsp;
<a href="<?= $c->uri_for('/pattern/delete/'.$pattern->id) ?>" onclick="return confirm('本当に削除しますか？')">[削除]</a><br />
<h3><?= $pattern->name ?></h3>
<dl>
    <dt>正規表現</dt>
    <dd><?= $pattern->pattern ?></dd>
    <dt>解説</dt>
    <dd><?= $pattern->description ?></dd>
</dl>
<br />
? }
