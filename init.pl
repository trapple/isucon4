use strict;
use warnings;
use FindBin qw/$Bin/;
use Cache::Memcached::Fast;
use DDP;
use feature 'say';

my $users_tsv = "$Bin/../../sql/dummy_users.tsv";
my $users_used_tsv = "$Bin/../../sql/dummy_users_used.tsv";

my $memd = Cache::Memcached::Fast->new({servers => [ "localhost:11211" ]});
$memd->flush_all;

my %users;

die "source file not found: $users_tsv" unless -e $users_tsv;
die "source file not found: $users_used_tsv" unless -e $users_used_tsv;

&read_users;
&read_users_used;
#&chk;

sub read_users {
  open(FILE, "<$users_tsv") or die $!;
  while(my $line = <FILE>){
    chomp $line;
    my ($id, $username, undef, undef) = split /\t/, $line;
    $memd->set($id, 0);
  }
  close(FILE);
}

sub read_users_used {
  open(FILE, "<$users_used_tsv") or die $!;
  while(my $line = <FILE>){
    chomp $line;
    my ($id, $username, $cnt) = split /\t/, $line;
    $memd->set($id, $cnt);
  }
  close(FILE);
}

sub chk {
  open(FILE, "<$users_tsv") or die $!;
  while(my $line = <FILE>){
    chomp $line;
    my ($id, $username, undef, undef) = split /\t/, $line;
    say $memd->get($id);
  }
  close(FILE);
}
