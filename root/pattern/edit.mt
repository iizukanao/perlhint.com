? extends 'common/base';

<? block title => sub {?>Edit Pattern | PerlHint<? } ?>

? block content => sub {
<? my $pattern = stash->{pattern}; ?>
<div class="breadcrumb">
<a href="<?= $c->uri_for('/') ?>">Top</a> &gt; <a href="<?= $c->uri_for('/pattern/') ?>">Patterns</a> &gt; <a href="<?= $c->uri_for('/pattern/show/'.$pattern->id) ?>"><?= $pattern->name ?></a> &gt; Edit
</div>
<form method="POST" class="pattern-form" action="<?= $c->uri_for('/pattern/post/'.$pattern->id) ?>">
パターン名<br />
<input type="text" class="name" name="name" value="<?= $pattern->name ?>" /><br />
正規表現<br />
<input type="text" class="pattern" name="pattern" value="<?= $pattern->pattern ?>" /><br />
解説<br />
<input type="text" class="description" name="description" value="<?= $pattern->description ?>" /><br />
<br />
<input type="submit" value="　更新　" />
</form>
? }
