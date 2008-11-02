use Test::More 'no_plan';
use Digest::Skein ':all';

sub check_short {
	my $bitlen = shift;
	local $/ = '';
	open my $fh, '<:crlf', "ShortMsgKAT_$bitlen.txt" or die $!;
	while ( my $record = <$fh> ) {
		my ( $len, $msg, $md ) = ( $record =~ /Len = (\d+)\s+Msg = (\S+)\s+MD = (\S+)/ ) or next;
		my $message = pack '(H2)*', $msg =~ /(..)/g;
		next if !$len or $len % 8;
		is( Digest::Skein->new($bitlen)->add($message)->hexdigest, lc $md, "$bitlen Len = $len  Msg = $msg" ) or die;
		is( Digest::Skein::Skein( $bitlen, $message ), $md, "$bitlen Len = $len  Msg = $msg" );    #or die;
	}
}

1;
