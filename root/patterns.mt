? extends 'common/base';

<? block title => sub {?>Patterns | PerlHint<? } ?>

? block content => sub {
<? my $patterns = $c->stash->{patterns}; ?>
<? foreach my $name (keys %$patterns) { ?>
<div style="margin-bottom:1em">
<?= $name ?><br />
<div style="margin-left:1em">
<input type="text" size="100" value="<?= $patterns->{$name}->{pattern} ?>" /><br />
<input type="text" size="100" value="<?= $patterns->{$name}->{description} ?>" /><br />
</div>
</div>
<? } ?>
? }
