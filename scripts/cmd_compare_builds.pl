#!/usr/bin/env perl
use strict;
use Getopt::Long qw(:config no_ignore_case);

my $help;
my $genome_size = 0;
my $scaffolds_only = 0;
GetOptions (
    "g|genome_size=s" => \$genome_size,
    "s|scaffolds_only" => \$scaffolds_only,
    "h|help" => \$help,
);

my $usage = qq/\nUSAGE:   $0 -g genome_size build1.fasta build2.fasta
OPTIONS: -s   only print scaffold stats\n\n/;

unless ($genome_size) {
    print "$usage";
    print "== genome_size is requried\n\n";
    exit;
} 

if (defined $help || @ARGV == 0) {
    print "$usage\n";
    exit;
}

my %stats;
my @params;
my $build_num = 1;
my @build_names;
my $pwd = `pwd`;
chomp $pwd;
print "pwd:     $pwd\n";
foreach (@ARGV) {
    if (! -e $_) {
        print "ERROR: file not found $_\n\n";
        exit 1;
    }
    print "build $build_num: $_\n";
    $build_num++;
}

$build_num = 1;

foreach (@ARGV) {
    my @stats = `assemblathon_stats.pl -genome_size $genome_size $_`;
    foreach (@stats) {
        chomp;
        next if /^$/;
        my $line = $_;
        last if $line =~ /Number of contigs/ && $scaffolds_only;
        # get build name
        if ($line =~ /^----.+'(.+)'/) {
            my $build_name = $1;
            $build_name =~ s/.+\///;
            push(@build_names, $build_name);
            next;
        }
        $line =~ s/^ +//;
        $line =~ s/ +$//;
        $line =~ s/ {2,}/\t/g;
        # Total size of contigs 4221641463
        $line =~ s/Total size of contigs (\d)/Total size of contigs\t\1/;
        $line =~ s/Total size of scaffolds (\d)/Total size of scaffolds\t\1/;

        my @values = split(/\t/, $line);
        push(@params, $values[0]) if $build_num == 1;
        $stats{"$values[0]"}{$build_num} = $values[1];
    }
    $build_num++;
}

print "\n";

$build_num = 1;
printf '%65s', "PARAMETER |";
foreach (@build_names) {
    printf '%20s' , "$build_num) $_\t";
    $build_num++;
}
print "\n\n";

foreach my $param (@params) {
    printf '%65s', "$param |";
    foreach (1 .. ($build_num - 1)) {
        my $value = commify($stats{$param}{$_});
        $value =~ s/ .+$//;
        printf '%20s' , "$value";
        print "\t";
    }
    print "\n";
}

sub commify {
   local $_ = shift;
   1 while s/^(-?\d+)(\d{3})/$1,$2/;
   return $_;
}
