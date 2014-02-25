package Cookie::Baker::XS;

use 5.008001;
use strict;
use warnings;
use base qw/Exporter/;

our $VERSION = "0.01";
our @EXPORT_OK = qw/crush_cookie/;

use XSLoader;
XSLoader::load(__PACKAGE__, $VERSION);

1;
__END__

=encoding utf-8

=head1 NAME

Cookie::Baker::XS - It's new $module

=head1 SYNOPSIS

    use Cookie::Baker::XS;

=head1 DESCRIPTION

Cookie::Baker::XS is ...

=head1 LICENSE

Copyright (C) Masahiro Nagano.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Masahiro Nagano E<lt>kazeburo@gmail.comE<gt>

=cut

