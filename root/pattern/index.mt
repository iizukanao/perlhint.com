? extends 'common/base';

<? block title => sub {?>Patterns | PerlHint<? } ?>

? block content => sub {
<div class="breadcrumb">
<a href="<?= $c->uri_for('/') ?>">Top</a> &gt; Patterns
</div>
<? if ( stash->{flash} ) { ?>
  <div class="flash">
    <?= stash->{flash} ?>
  </div>
<? } ?>
<? my $patterns = $c->stash->{patterns}; ?>
<? my $num_patterns = $c->stash->{num_patterns}; ?>
<?= $num_patterns ?> <?= PL('pattern', $num_patterns) ?><br />
<br />
<a href="<?= $c->uri_for('/pattern/add_new') ?>">&raquo; 新しいパターンを作成</a><br />
<br />
<? foreach my $name (keys %$patterns) { ?>
<? my $pattern = $patterns->{$name}; ?>
<div class="set" style="margin-bottom:1em">
<div class="name"><a href="<?= $c->uri_for('/pattern/show/'.$pattern->{id}) ?>"><?= $name ?></a></div>
<div class="params" style="margin-left:1em">
<div class="pattern"><?= $pattern->{pattern} ?></div>
<div class="description"><?= $pattern->{description} ?></div>
</div>
</div>
<? } ?>
? }
