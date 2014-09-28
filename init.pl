use strict;
use warnings;
use Cache::Memcached::Fast;

my $memd = Cache::Memcached::Fast->new({servers => [ "localhost:11211" ]});
$memd->flush_all;

