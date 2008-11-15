package Digest::Skein;

use 5.008000;
use strict;

require Exporter;

our @ISA = qw(Exporter);

our %EXPORT_TAGS = (
	'all' => [
		qw(
		  skein_256
		  skein_512
		  skein_1024
		  skein_256_hex
		  skein_512_hex
		  skein_1024_hex
		  skein_256_base64
		  skein_512_base64
		  skein_1024_base64
		  ),
	],
);

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our $VERSION    = '0.01';
our $XS_VERSION = $VERSION;
$VERSION = eval $VERSION;

require XSLoader;
XSLoader::load( 'Digest::Skein', $XS_VERSION );

use bytes;
use base qw( Digest::base );

sub new {
	my ( undef, $hashbits ) = @_;
	$hashbits ||= 512;
	return
	    $hashbits <= 256 ? Digest::Skein::256->new($hashbits)
	  : $hashbits <= 512 ? Digest::Skein::512->new($hashbits)
	  :                    Digest::Skein::1024->new($hashbits);
}

sub skein_256_hex  { unpack 'H*', skein_256(@_) }
sub skein_512_hex  { unpack 'H*', skein_512(@_) }
sub skein_1024_hex { unpack 'H*', skein_1024(@_) }

sub skein_256_base64  { require MIME::Base64; MIME::Base64::encode( skein_256(@_) ) }
sub skein_512_base64  { require MIME::Base64; MIME::Base64::encode( skein_512(@_) ) }
sub skein_1024_base64 { require MIME::Base64; MIME::Base64::encode( skein_1024(@_) ) }

@Digest::Skein::256::ISA  = qw/ Digest::base /;
@Digest::Skein::512::ISA  = qw/ Digest::base /;
@Digest::Skein::1024::ISA = qw/ Digest::base /;

1;
__END__

=head1 NAME

Digest::Skein - Perl interface to the Skein digest algorithm

=head1 SYNOPSIS

  use Digest::Skein qw/ digest_512 digest_512_hex /;
  my $digest    = digest_512('foo bar baz');
  my $hexdigest = digest_512_hex('foo bar baz');

OO interface:

  my $digest = Digest::Skein->new(512)->add('foo bar baz')->digest;
  my $base64 = Digest::Skein->new(512)->add('foo bar baz')->b64digest;

  # using the Digest API
  my $hex    = Digest->Skein(256)->add('foo bar baz')->hexdigest;

=head1 DESCRIPTION

Digest::Skein implements the Skein digest algorithm, submitted to NIST
for the SHA-3 competition.

This module follows the Digest.pm API.  See L<Digest> for more details.

=head2 EXPORT

Nothing by default.

=head2 Exportable functions

  skein_256()
  skein_512()
  skein_1024()
  skein_256_hex()
  skein_512_hex()
  skein_1024_hex()
  skein_256_base64()
  skein_512_base64()
  skein_1024_base64()

=head1 SEE ALSO

L<http://www.schneier.com/skein.html>,
L<Digest>

=head1 AUTHOR

Radoslaw Zielinski E<lt>radek@pld-linux.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2008 by Radoslaw Zielinski

The core functionality of this library is provided by code written by Niels
Ferguson, Stefan Lucks, Bruce Schneier, Doug Whiting, Mihir Bellare, Tadayoshi
Kohno, Jon Callas, Jesse Walker; see L<http://www.schneier.com/skein.html> for
details.

This library is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License (GPL).

=cut
