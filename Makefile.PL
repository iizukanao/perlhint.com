use inc::Module::Install;
name 'PerlHint';
all_from 'lib/PerlHint.pm';

requires 'Ark';
requires 'PPI';
requires 'HTML::Entities';
requires 'Text::MicroTemplate::Extended';
requires 'Text::Markdown';

tests 't/*.t';

build_requires 'Test::More';
use_test_base;
auto_include;
WriteAll;
