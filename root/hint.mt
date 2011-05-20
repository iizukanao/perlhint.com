? extends 'common/base';

? block head => sub {
<script src="js/jquery-latest.min.js"></script>
<script src="js/jquery.tools.min.js"></script>
<script src="js/hint.js"></script>
<link rel="stylesheet" href="css/style.css" />
? }

? block content => sub {
<h3>Toggles (TODO)</h3>
<ul>
    <li>special variables</li>
    <li>modules</li>
</ul>

<div class="code">

<pre>
<?= raw_string( stash->{pre_code} ) ?>
</pre>
</div>

<?= raw_string( stash->{tip_code} ) ?>
? }
