use strict;
use warnings;
use File::Basename;
use Sort::Naturally;

local $/ = '>';
my ( %files, %query, %omit, @F );
$omit{$_}++ for ( $ARGV[0], basename $0);

while (<>) {
    chomp;
    $query{ $F[0] } = $F[1] if @F = split;
}

local $/ = "\n";
my @files = nsort @ARGV = grep !$omit{$_}, <*>;

while (<>) {
    next if /^>/;
    chomp;
    $files{$_}{$ARGV}++;
}

select STDOUT;

print join( "\t", 'tag', 'seq', @files ), "\n";

for my $key ( nsort keys %query ) {
    my @seqCount;
    push @seqCount, $files{ $query{$key} }->{$_} || 0 for @files;
    print join( "\t", $key, $query{$key}, @seqCount ), "\n";
}