#!/usr/bin/perl -w
use strict;
use bytes;

use Test::More tests => 20;

use Digest::Skein ':all';
use Digest ();
use MIME::Base64 'encode_base64';

my $foo_256 = '7C3181538A0B56933AE51E88D938308EAEF834B6A27EAA7EA7E60EFB2D83C700';
my $foo_512 =
'8add53c6889d573b61d8e5072157db1a2f86bc8699841e353cea5c135a744dd3d19865b85cd3645ed7e399ff0ee13781466b51040eecdb6c1081d99f97a13eba';
my $foo_1024 =
'5d50955bd8aa214fab0520d3883c35824725a77ccf40f4d54cc41494d15ae5b1def74e5dd3f3fa1d6b778d1249815ffdd418770861b82adb9c42a67f57607432bcb5edbd30d1f427c5815e9a8bd0f4f5e72c0008567414fef973b5e3e3d345f44c5102c68c88d5c0e0d93103d8a817677d9c9395dc811d027616257180c4e7b7';

is( Digest::Skein::Skein( 256, 'foo' ), $foo_256, 'Skein256("foo")' );

# procedural

is( unpack( 'H*', skein_256('foo') ),  lc $foo_256, );
is( unpack( 'H*', skein_512('foo') ),  lc $foo_512, );
is( unpack( 'H*', skein_1024('foo') ), lc $foo_1024, );

is( skein_256_hex('foo'),  lc $foo_256,  '256_hex(foo)' );
is( skein_512_hex('foo'),  lc $foo_512,  '512_hex(foo)' );
is( skein_1024_hex('foo'), lc $foo_1024, '1024_hex(foo)' );

is( encode_base64( skein_512('foo') ), skein_512_base64('foo'), 'base64' );

# OO interface

ok( my $digest = Digest->Skein(256), 'new 256' );

ok( $digest->add("f"), 'add "f"' );

is( $digest, $digest->add("oo"), 'chaining' );

is( $digest->hexdigest, lc $foo_256, '256(foo)' );

#is( Digest->Skein(512)->add('foo')->hexdigest,  $foo_512,    '512(foo)' );
#is( Digest->Skein(1024)->add('foo')->hexdigest, $foo_1024,   '1024(foo)' );

ok( $digest->new(128) );
is( $digest->hashbitlen, 128 );

$digest->add(qw/f o o/);

ok( $digest->new );
is( $digest->hashbitlen, 128 );
ok( $digest->new(256) );
is( $digest->hashbitlen, 256 );

is( $digest->add("foo")->hexdigest,        lc $foo_256, 'reset() resets the object' );
is( $digest->reset->add("foo")->hexdigest, lc $foo_256, 'reset returns a clean object' );

# vim: ts=4 sw=4 noet
