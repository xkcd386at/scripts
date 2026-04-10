#!/usr/bin/perl
use warnings;
use strict;
use 5.10.0;

# **NOTE**: No AI was used in writing this program.  Not for the code (I've
# been doing perl since 1995 so if I need an LLM to come up with something
# this trivial I need to get tested for Alzheimers or something), not for the
# readme, not for anything else.

use Data::Dumper;

# See f9-README.md for details.

# There is not much error checking/validation so watch out!

my @c;
my $f9 = 0;
my %fs_by_name;             # formulas by name

sub sum {
    my $i = shift;
    my $ret = 0;
    # sum column $i for rows 1 to $f9 - 1
    for my $r (1 .. $f9-1) {
        $ret += $c[$r][$i] || 0;
    }
    return $ret;
}

sub compute {
    my $i = shift;          # current column.  ($f9 is current row)
    my $formula = shift;

    return 0 unless $formula =~ s/^=//;
    $formula = $fs_by_name{$formula} if $fs_by_name{$formula};

    my @terms = split /((?:U)?L(?:\d))/, $formula;
    my $expr = '';  # replace UL1, L1, etc., with the respective values and place here.
    for my $t (@terms) {
        next unless $t;         # split produces an empty field when string *starts* with the "delimiter"
        $t =~ s/SUM/sum($i)/e;  # literally the 3 letters SUM get replaced!
        if ($t !~ /^U?L\d/) {
            $expr .= $t;    # nothing to interpolate
            next;
        }
        my $row = $f9;
        my $col = $i;
        ($t =~ s/^U//) and $row--;
        ($t =~ s/^L//) and $col -= $t;
        ($t =~ s/^R//) and $col += $t;
        $expr .= $c[$row][$col] || 0;
    }
    die "bad expression '$expr'\n" if $expr =~ /[^-+*\/() 0-9.]/;
    return eval $expr;
}

while (<>) {
    chomp;

    if (/^<!-- f9 ((\w+) = (.*) )?-->$/i) {
        say;
        $f9 = 1;
        $fs_by_name{$2} = $3 if $1;
        next;
    }

    if ($f9) {
        # we need to allow a blank line between the "<!-- f9 ..." marker and
        # the actual table because some implementations don't render the table
        # properly otherwise.
        if (/^$/ and $f9 == 1) {
            say;
            next;
        }

        if (/^\|/) {            # still inside the table?
            $f9++;              # doubles as a row counter
            my @a = split /\|/;
            # we don't like deleting trailing empty fields; we need them to build the line back
            push @a, "" if /\|$/;

            for my $i ( 0 .. $#a ) {
                if ($a[$i] =~ /^ *(-?\d+(\.\d+)?) *$/) {
                    # tip: use 0.5, not .5
                    $c[$f9][$i] = $1;
                } elsif ($a[$i] =~ /^ *(<!-- (.*) -->) (.*) *$/) {
                    my ($fc, $f, $cv) = ($1, $2, $3);
                    # formula+comment marker, formula, current value

                    # TODO indicate precision required, somehow
                    my $nv = sprintf("%0.2f", compute($i,$f));

                    # make formulas in subsequent cells find *this* (just computed) value!
                    $c[$f9][$i] = $nv;
                    $a[$i] = " $fc $nv ";
                }
            }
            say join("|", @a);

        } else {
            say;
            # we are now outside the table
            # say STDERR Dumper \@c if @c;
            @c = ();
            $f9 = 0;
            %fs_by_name = ();

        }
    } else {
        say;
    }
}
