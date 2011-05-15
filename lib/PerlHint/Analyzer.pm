package PerlHint::Analyzer;

use strict;
use warnings;
use PPI;
use HTML::Entities;
use Text::MicroTemplate qw(encoded_string);
use Text::Markdown 'markdown';
use utf8;

# TODO: DBに格納してユーザが編集できるようにする
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
};

my $escape_chars = '<>&"';

# パターン一覧を返す
sub patterns {
    return $patterns;
}

# $$source_refを解析して結果を返す
sub analyze {
    my ($source_ref) = @_;

    $$source_ref =~ s/\r\n?/\n/g;
    my $lexer = PPI::Lexer->new;
    my $tokenizer = PPI::Tokenizer->new($source_ref);
    my $doc = $lexer->lex_tokenizer($tokenizer);
    # PPIのTokenに分解
    my $tokens = $tokenizer->all_tokens;
    my $loc;
    my $str = '';
    my $locations = {};
    my $index = 0;
    my @lines = map { "$_\n" } split /\n/, $$source_ref;

    # ソース全体をPPIのTokenで表す文字列を構築
    foreach my $token (@$tokens) {
        my $type = ref($token);
        my $content;
        $type =~ s/^PPI::Token:://;
        my $this_token;
        if ($type eq 'Whitespace') {
            $this_token = "#{Whitespace}";
        } else {
            $content = $token->content;
            $this_token = "#{$type:$content}";
        }
        $locations->{$index} = {
            type => $type,
            content => $content,
            location => $token->location,
        };
        $index += length($this_token);
        $str .= $this_token;
    }
    $str .= "#{EOF}";
    my $end_line_end_char = length($lines[$#lines]);
    $locations->{$index} = {
        type => 'EOF',
        content => '',
        location => [ scalar(@lines), $end_line_end_char, $end_line_end_char, scalar(@lines) ],
    };

    my @annotations;

    # 各パターンにマッチさせる
    foreach my $name (keys %$patterns) {
        my $name_count = 1;
        my $pattern = $patterns->{$name};
        my $re_text = $pattern;
        my $re = qr/$pattern->{pattern}/;
        while ($str =~ /$re/g) {
            my $start_index = $-[0];
            my $text = $pattern->{description};
            my $capture = "1";
            my $l = scalar @-;
            # キャプチャした文字列で説明文を置換
            for (my $i = 1; $i < $l; $i++) {
                my $replaced = substr($str, $-[$i], $+[$i] - $-[$i]);
                $text =~ s/\$$i/$replaced/g;
            }
            my $end_index = $+[0];
            my $matched_str = substr($str, $start_index, $end_index - $start_index);
            my $start_loc = $locations->{$start_index};
            my $start_line;
            my $start_char;
            if ($start_loc) {
                my $l = $start_loc->{location};
                $start_line = $l->[0];
                $start_char = $l->[1];
            } else {
                warn "location not found\n";
            }
            my $last_token_index = rindex($matched_str, "#{") + $start_index;
            my $last_loc = $locations->{$last_token_index};
            my $end_line;
            my $end_char;
            if ($last_loc) {
                my $l = $last_loc->{location};
                $end_line = $l->[0];
                $end_char = $l->[1] + length($last_loc->{content});
            } else {
                warn "location not found\n";
            }
            push @annotations, {
                start => {
                    line => $start_line,
                    char => $start_char,
                },
                end => {
                    line => $end_line,
                    char => $end_char,
                },
                name => $name.$name_count++,
                description => $text,
            };
        }
    }

    # 全部のアノテーションを開始位置でソート
    @annotations = sort {
        my $cmp = $a->{start}->{line} <=> $b->{start}->{line};
        if ($cmp == 0) {
            $cmp = $a->{start}->{char} <=> $b->{start}->{char};
        }
        $cmp;
    } @annotations;

    my $i = 0;
    my $pre_code;
    my @copied = @annotations;
    # 行ごとにアノテーションを挿入
    # TODO: 行をまたぐパターンや、入れ子構造になっているパターンを使えるようにする
    foreach my $line (@lines) {
        my $inserted_length = 0;
        my $end_border;
        my $end_tag = "</a>";
        my $changed = 0;
        while (@annotations) {
            my $annot = $annotations[0];
            if ($annot->{start}->{line} > $i + 1) {
                last;
            }
            my $name = $annot->{name};
            my $insert_tag = qq(<a href="javascript:void(0)" class="syn syn_$name">);
            my $border = $annot->{start}->{char} + $inserted_length - 1;
            my $before = substr($line, 0, $border);
            my $after = substr($line, $border);
            my $before_escaped;
            if (defined $end_border) {
                $end_border += length($end_tag);
                my $leading = substr($before, 0, $end_border);
                my $trailing = substr($before, $end_border);
                $before_escaped = $leading . encode_entities($trailing, $escape_chars);
            } else {
                $before_escaped = encode_entities($before, $escape_chars);
            }
            $line = $before_escaped . $insert_tag . $after;
            $inserted_length += length($insert_tag);
            $changed = (length($before_escaped) - length($before));
            $inserted_length += $changed;

            $end_border = $annot->{end}->{char} + $inserted_length - 1;
            $before = substr($line, 0, $end_border);
            my $border_end = $border + length($insert_tag) + $changed;
            my $lead = substr($before, 0, $border_end);
            my $trail = substr($before, $border_end);
            $before_escaped = $lead . encode_entities($trail, $escape_chars);
            $changed += length($before_escaped) - length($before);
            $after = substr($line, $end_border);
            $line = $before_escaped . $end_tag . $after;
            $inserted_length += length($end_tag);
            $inserted_length += (length($before_escaped) - length($before));

            shift @annotations;
        }
        if (defined $end_border) {
            $end_border += length($end_tag) + $changed;
            if ($end_border < length($line)) {
                my $leading = substr($line, 0, $end_border);
                my $trailing = substr($line, $end_border);
                $line = $leading . encode_entities($trailing);
            }
        } else {
            $line = encode_entities($line);
        }
        $pre_code .= "".($i+1).":\t".$line;
        $i++;
    }
    my $tip_code = '';
    foreach my $annot (@copied) {
        my $key = $annot->{name};
        my $description = $annot->{description};
        $description = encode_entities($description, '<>&"');
        $description = markdown($description);
        $tip_code .= qq(<div id="tip_$key" class="tooltip">\n);
        $tip_code .= $description . "\n";
        $tip_code .= qq(</div>\n);
    }

    return {
        pre_code => $pre_code,
        tip_code => $tip_code,
        source   => $str,
    };
}

1;
