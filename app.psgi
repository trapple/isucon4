use FindBin;
use lib "$FindBin::Bin/extlib/lib/perl5";
use lib "$FindBin::Bin/lib";
use File::Basename;
use Plack::Builder;
use Isu4Qualifier::Web;
use Plack::Session::State::Cookie;
#use Plack::Session::Store::File;
use Plack::Session::Store::Cache;
use Cache::Memcached::Fast;

my $root_dir = File::Basename::dirname(__FILE__);
my $session_dir = "/tmp/isu4_session_plack";
mkdir $session_dir;

my $app = Isu4Qualifier::Web->psgi($root_dir);
builder {
  enable 'ReverseProxy';
  enable 'Static',
    path => qr!^/(?:stylesheets|images)/!,
    root => $root_dir . '/public';
  enable 'Session',
    store => Plack::Session::Store::Cache->new(
      cache => Cache::Memcached::Fast->new({servers => [ "localhost:11211" ]})
    ),
    state => Plack::Session::State::Cookie->new(
      httponly    => 1,
      session_key => "isu4_session",
    ),
    #store => Plack::Session::Store::File->new(
    #  dir         => $session_dir,
    #),
    ;
  $app;
};
