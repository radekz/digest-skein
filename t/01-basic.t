#!/usr/bin/perl -w
use strict;
use bytes;

use Test::More tests => 25;

use Digest::Skein ':all';
use Digest ();
use MIME::Base64 'encode_base64';

my $foo_256 = 'a04efd9a0aeed6ede40fe5ce0d9361ae7b7d88b524aa19917b9315f1ecf00d33';
my $foo_512 =
'fd8956898113510180aa4658e6c0ac85bd74fb47f4a4ba264a6b705d7a8e8526756e75aecda12cff4f1aca1a4c2830fbf57f458012a66b2b15a3dd7d251690a7';
my $foo_1024 =
'8b0a579ff35592663d210ba645454eb84c0cc5cf5386315f2782390297ccae9dad4b453c72cf211b4d5088fa62c7f7145b24f016498c355145b2b19db6be86efe082432fd43989f6cd358482a61bd3b7b906a550f4d8cca38a63bdba7542995a7e7db8328fd4012d81b44c13b316026c89c59d38e391328cee6fb7116ce8fa67';

is( lc Digest::Skein::Skein( 256, 'foo' ), lc $foo_256, 'Skein256("foo")' );

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

is( $digest->add("foo")->hexdigest,        lc $foo_256, 'prepare for reset() test...' );
is( $digest->reset->add("foo")->hexdigest, lc $foo_256, 'reset() returns a clean object' );
is( $digest->add("foo")->hexdigest,        lc $foo_256, 'digest() also resets the object' );

# vim: ts=4 sw=4 noet
