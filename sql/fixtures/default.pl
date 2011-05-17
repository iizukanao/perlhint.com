#use utf8;

my $patterns = {
        "pm_return_true" => {
            pattern => "#{Number:1}#{Structure:;}(?:#{Whitespace})*#{EOF}",
            description => "pmファイルは最後にtrue値を返す必要がある",
        },
        "anon_fh" => {
            pattern => "#{QuoteLike::Readline:<>}",
            description => "<STDIN>と同じ",
        },
        "use_strict" => {
            pattern => "#{Word:use}#{Whitespace}#{Word:strict}#{Structure:;}",
            description => "厳格な構文チェックを有効にする",
        },
        "use_warnings" => {
            pattern => "#{Word:use}#{Whitespace}#{Word:warnings}#{Structure:;}",
            description => "警告をできるだけ多く出力",
        },
        "package" => {
            pattern => "#{Word:package}#{Whitespace}#{Word:(.*?)}#{Structure:;}",
            description => "ここから\$1パッケージ",
        },
        "defaultvar" => {
            pattern => '#{Magic:\$_}',
            description => "デフォルト変数",
        },
        "sub_args" => {
            pattern => '#{Magic:@_}',
            description => "サブルーチンの引数が入った配列",
        },
        "use_parent" => {
            pattern => "#{Word:use}#{Whitespace}#{Word:parent}#{Whitespace}#{QuoteLike::Words:.*?}#{Structure:;}",
            description => "親クラスを指定してメソッド等を継承する",
        },
        "use_carp" => {
            pattern => "#{Word:use}#{Whitespace}#{Word:Carp}#{Structure:;}",
            description => "die(), warn() の代わりとなるモジュール",
        },
        "module_version" => {
            pattern => '#{Word:our}#{Whitespace}#{Symbol:\$VERSION}#{Whitespace}.*?#{Structure:;}',
            description => "モジュールのバージョンを宣言 ([versionモジュール](http://search.cpan.org/~jpeacock/version-0.88/lib/version.pod)から情報が利用できる)",
        },
        "__package__" => {
            pattern => "#{Word:__PACKAGE__}",
            description => "現在いるパッケージ",
        },
        "do_scope" => {
            pattern => "#{Word:do}(?:#{Whitespace})?#{Structure:{}",
            description => "変数のスコープを作成 ([参考](http://d.hatena.ne.jp/unau/20100313/1268452346))",
        },
        "sub_import" => {
            pattern => "#{Word:sub}#{Whitespace}#{Word:import}",
            description => "このモジュールがuseされた時に呼ばれる",
        },
        "sub_unimport" => {
            pattern => "#{Word:sub}#{Whitespace}#{Word:unimport}",
            description => "このモジュールがnoされた時に呼ばれる",
        },
        "mk_accessors" => {
            pattern => '#{Word:mk_accessors}#{Structure:\(}#{QuoteLike::Words:qw/(.*?)/}#{Structure:\)}#{Structure:;}',
            description => 'setter/getterを作成 (親クラス[Class::Accessor](http://search.cpan.org/~kasei/Class-Accessor-0.34/lib/Class/Accessor.pm)のメソッド)',
        },
        "no_strict_refs" => {
            pattern => "#{Word:no}#{Whitespace}#{Word:strict}#{Whitespace}#{Quote::Single:'refs'}#{Structure:;}",
            description => "これ以降シンボリックリファレンスを使用してもエラーを出さない ([参考](http://www14.atpages.jp/jelfe/07/22.html))",
        },
        "can" => {
            pattern => '#{Operator:->}#{Word:can}#{Structure:\(}#{Quote::Single:\'(.*?)\'}#{Structure:\)}',
            description => '左のオブジェクトの$1というメソッドへのリファレンスを返す',
        },
        "croak" => {
            pattern => '#{Word:croak}',
            description => '呼び出し元を表示してdieする ([Carpモジュール](http://search.cpan.org/~rjbs/perl-5.12.3/lib/Carp.pm)のメソッド)',
        },
        "ref" => {
            pattern => '#{Word:ref}',
            description => 'この後に続く変数がリファレンスならその型を返し、リファレンスではない場合は空文字列を返す',
        },
        "__end__" => {
            pattern => "#{Separator:__END__}",
            description => "この行以降は実行しない",
        },
        "use_VERSION" => {
            pattern => '#{Word:use}#{Whitespace}#{Number::Float:(\d).0+(\d+?)0+(\d+)}#{Structure:;}',
            description => 'perlのバージョンが$1.$2.$3未満の場合は例外を出す',
        },
        "use_namespace_autoclean" => {
            pattern => '#{Word:use}#{Whitespace}#{Word:namespace::autoclean}#{Structure:;}',
            description => 'importした関数をこのパッケージのメソッドにしない ([参考](http://search.cpan.org/~bobtfish/namespace-autoclean-0.12/lib/namespace/autoclean.pm))',
        },
        "use_moose" => {
            pattern => '#{Word:use}#{Whitespace}#{Word:Moose}#{Structure:;}',
            description => 'Perlでオブジェクト指向をエレガントに使うためのモジュール。より高速化されたMouseというモジュールもある。',
        },
};

foreach my $name (keys %$patterns) {
    my $pat = $patterns->{$name};
    models('Schema::Pattern')->create({
        name => $name,
        pattern => $pat->{pattern},
        description => $pat->{description},
    });
}

1;
