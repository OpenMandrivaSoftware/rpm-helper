#!/usr/bin/perl
# $Id: gprintify 257533 2009-05-23 12:45:15Z guillomovitch $

use strict;
use warnings;
use Test::More;
use Digest::MD5;
use FindBin qw/$Bin/;
use File::Temp;
use lib "$Bin/../lib";

my @selector_tests = (
    [ [ qw/local1 debug emerg/ ], 'local1.*' , 'debug -> emerg' ],
    [ [ qw/local1 info emerg/ ], 'local1.info' , 'info -> emerg' ],
    [ [ qw/local1 debug alert/ ], 'local1.=debug;local1.=info;local1.=notice;local1.=warning;local1.=err;local1.=crit;local1.=alert' , 'debug -> alert' ],
    [ [ qw/local1 info alert/ ], 'local1.=info;local1.=notice;local1.=warning;local1.=err;local1.=crit;local1.=alert' , 'info -> alert' ],
);

plan tests => 5 + scalar @selector_tests;

# test loading
ok(require("add-syslog"), "loading file OK");

# test string function
foreach my $test (@selector_tests) {
    is(get_selector(@{$test->[0]}), $test->[1], $test->[2]);
}

# test service configuration file modification
my $file;
$file = setup(<<EOF);
SYSLOGD_OPTIONS=
EOF

add_new_source('/tmp/log', $file);

is(
    get_syslog_option($file),
    '"-a /tmp/log"',
    'new source, without prior option'
);
unlink($file) unless $ENV{TEST_DEBUG};

$file = setup(<<EOF);
SYSLOGD_OPTIONS=-x
EOF

add_new_source('/tmp/log', $file);

is(
    get_syslog_option($file),
    '"-x -a /tmp/log"',
    'new source, with prior unquoted option'
);
unlink($file) unless $ENV{TEST_DEBUG};

$file = setup(<<EOF);
SYSLOGD_OPTIONS="-a /dev/log"
EOF

add_new_source('/tmp/log', $file);

is(
    get_syslog_option($file),
    '"-a /dev/log -a /tmp/log"',
    'new source, with prior quoted option'
);
unlink($file) unless $ENV{TEST_DEBUG};

$file = setup(<<EOF);
SYSLOGD_OPTIONS="-a /tmp/log"
EOF

add_new_source('/tmp/log', $file);

is(
    get_syslog_option($file),
    '"-a /tmp/log"',
    'new source, already defined'
);
unlink($file) unless $ENV{TEST_DEBUG};

sub setup {
    my ($content) = @_;

    my $out = File::Temp->new(UNLINK => 0);
    print $out $content;
    close $out;

    return $out->filename();
}

sub get_syslog_option {
    my ($file) = @_;

    my $options;
    open(my $in, '<', $file) or die "can't read $file: $!";
    while (my $line = <$in>) {
        chomp $line;
        next unless $line =~ /^SYSLOGD_OPTIONS=(.+)/;
        $options = $1;
        last;
    }
    close($in);

    return $options;
}

