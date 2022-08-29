#!/usr/bin/perl -w
use strict;
use Getopt::Long qw(:config no_ignore_case);

my $usage = qq{
Synopsis:
    This script will print out only contigs/scaffolds based on a minimum length

Reqiured arguments:
    -i <input_contigs.fa>       contigs file
    -o <output_prefix>          output prefix
    -l <int>                    keep contigs/scaffolds longer than <int> bases

Optional arguments:
    -s <int>                    output each fasta contig with multiple lines of length <int> (default: 100)
    -S                          output each fasta contig sequence on one line instead of multiple lines
    -n                          trim leading and trailing Ns from contigs
    -z                          gzip output fasta file


Sample commands:
    cmd_parse_contigs.pl -i default-contigs.fa -o mouse_build -l 500 -n
   };

my ($infile, $help);
my $min_length;
my $output_prefix = 'output';
my $zip_output = 0;
my $trim_ns = 0;
my $one_line_contigs = 0;
my $seq_row_length = 100;

GetOptions (   
                "i=s" => \$infile,
				"o=s" => \$output_prefix,
				"l=i" => \$min_length,
				"n"   => \$trim_ns,
				"s=i" => \$seq_row_length,
				"S"   => \$one_line_contigs,
				"z"   => \$zip_output,
                "h|help" => \$help,
);
if ($help) {
	print "$usage\n";
	exit;
}

if (! defined $infile) {
    print "\n$usage\n\n=====> Required use of -i to specify an input file.\n\n";
    exit;
}

if (! defined $min_length) {
    print "\n$usage\n\n=====> Required use of -l to specify contig minimum length to keep.\n\n";
    exit;
}

if ($seq_row_length != 100 && $one_line_contigs) {
    print "\n$usage\n\n=====> -s and -S cannot be used together.\n\n";
    exit;
}

if (-e "${output_prefix}.fasta.gz" || -e "${output_prefix}.fasta") {
    print "output file [${output_prefix}.fasta.gz] already exists.\n";
    print "either delete the existing output file or select a new prefix.\n";
    exit;
}

if ($zip_output) {
    open (OUTFILE, " | gzip > ${output_prefix}.fasta.gz") || die $!;
}
else {
    open (OUTFILE, ">", "${output_prefix}.fasta") || die $!;
}

$/ = "\n>";
if ($infile =~ /gz$/) {
	open (INFILE, "gzip -d -c $infile |") || die $!;
}
else {
	open (INFILE, $infile) || die $!;
}
my $seqs_printed = 0;

while (<INFILE>) {
	chomp;
    my $chunk = $_;
    chomp($chunk);
    my @chunk_array = split("\n", $chunk);
    my $header = shift @chunk_array;
    $header =~ s/^>//;
    my $seq = join('', @chunk_array);
    if ($trim_ns) {
        $seq =~ s/^N+//i;
        $seq =~ s/N+$//i;
    }
    if (length($seq) >= $min_length) {
        print OUTFILE ">$header\n";
        unless ($one_line_contigs) {
            while ($seq =~ s/^\S{$seq_row_length}//) {
                print OUTFILE "$&\n";
            }
        }
        print OUTFILE "$seq\n";
        $seqs_printed++;
    }

}
close INFILE;
close OUTFILE;

if ($seqs_printed == 0) {
    print "\n\n\tThere were 0 sequences kept with min length set at $min_length\n\n";
}
