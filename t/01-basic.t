#!/usr/bin/perl -w
use strict;
use bytes;

use Test::More tests => 24;

use Digest::Skein ':all';
use Digest ();
use MIME::Base64 'encode_base64';

my $foo_256 = '7C3181538A0B56933AE51E88D938308EAEF834B6A27EAA7EA7E60EFB2D83C700';
my $foo_512 =
'22e49f5118a69ffd073a9b5772671adeea8dea2c921dd0ccbef272117456bb8bd0dca32a5a015c28fcecdbb4e92b1e060c71a79b10913cb94d03f1b6c7d96bae';
my $foo_1024 =
'ff57163fe90b3148c44797e7856d7e452073162775c39bf58d517c205d0a8ad71a280ddaa00fd33c5d42aa39569b3030c087aa601ecb964fd5cad1bd9c1aae4468eb3ad09143da9e3a32a36692d810192189ffe0c1d136a3bc90c16c27f9789b4884f644f787c96f2a7fb8a62fef98db271ae4fd423246723e381de4652cd36b';

is( Digest::Skein::Skein( 256, 'foo' ), $foo_256, 'Skein256("foo")' );

# procedural

is( unpack( 'H*', skein_256('foo') ),  lc $foo_256,  'skein_256("foo")'  );
is( unpack( 'H*', skein_512('foo') ),  lc $foo_512,  'skein_512("foo")'  );
is( unpack( 'H*', skein_1024('foo') ), lc $foo_1024, 'skein_1024("foo")' );

is( skein_256_hex('foo'),  lc $foo_256,  '256_hex(foo)'  );
is( skein_512_hex('foo'),  lc $foo_512,  '512_hex(foo)'  );
is( skein_1024_hex('foo'), lc $foo_1024, '1024_hex(foo)' );

is( encode_base64( skein_512('foo') ), skein_512_base64('foo'), 'base64' );

# OO interface

ok( my $digest = Digest->Skein(256), 'new 256' );
ok( $digest->add("f"), 'add "f"' );

is( $digest,            $digest->add("oo"), 'chaining' );
is( $digest->hexdigest, lc $foo_256,        '256(foo)' );

is( Digest->new('Skein')->add('bar')->hexdigest, Digest->Skein->new(512)->add('bar')->hexdigest, 'default=512' );

is( Digest->Skein(256)->add('foo')->hexdigest,  lc $foo_256,  '256(foo)'  );
is( Digest->Skein(512)->add('foo')->hexdigest,  lc $foo_512,  '512(foo)'  );
is( Digest->Skein(1024)->add('foo')->hexdigest, lc $foo_1024, '1024(foo)' );

ok( $digest->new(128), 'new(128)' );
is( $digest->hashbitlen, 128, 'hashbitlen()' );

$digest->add(qw/f o o/);

ok( $digest->new,             'new() as a method' );
is( $digest->hashbitlen, 128, 'new() as a method retains hashbitlen by default' );
ok( $digest->new(256),        '...but hashbitlen can be forced...' );
is( $digest->hashbitlen, 256, '...and it actually works' );

is( $digest->add("foo")->hexdigest,        lc $foo_256, 'reset() resets the object' );
is( $digest->reset->add("foo")->hexdigest, lc $foo_256, 'reset returns a clean object' );

# vim: ts=4 sw=4 noet
