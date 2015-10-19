package App::Tel::Color;

use strict;
use warnings;
use Carp;
use Module::Load;
require Exporter;
our @ISA = qw(Exporter);
our @EXPORT = qw();
our @EXPORT_OK = qw ( load_syntax );

=head1 NAME

App::Tel::Color - Methods for managing App::Tel::Color:: modules

=cut

=head2 load_syntax

   my $mod = $self->load_syntax('Cisco');

This attempts to load syntax highlighting modules.  In the above example,
Cisco would append Colors to the end and get CiscoColors.pm.  If it can't find
the module it just won't load it.

Returns an arrayref of module references.

Multiple files can be chain loaded by using plus:

    my $ret = $self->load_syntax('Default+Cisco');

=cut

sub load_syntax {
    my ($list, $debug) = @_;
    return () if (!defined $list);
    my @return = ();
    my @syntax;
    push(@syntax, $list);
    if (ref($list) eq 'ARRAY') {
        @syntax = @$list;
    }

    foreach my $l (@syntax) {
        for(split(/\+/, $l)) {

            eval {
                my $module = 'App::Tel::Color::'.$_;
                Module::Load::load $module;
                push(@return, $module->new);
            };
            if ($@) {
                carp $@ if ($debug);
            }
        }
    }
    return @return;
}

1;
