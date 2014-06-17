#!/bin/perl -w
use strict;
# written by calvin bui


my $INTERVAL = 4;
my %hash;


while ( 1 )
 {
  &linuxiostat();
  sleep $INTERVAL;
  undef %{hash};
 }


sub linuxiostat
{
my $ls = `/bin/ls -l /dev/vx/dsk/*/*`;
if ($? != 0){ die "Failed executing"}
my @ls = `/bin/ls -l /dev/vx/dsk/*/*`;
foreach my $mapping (@ls)
 {
  if ($mapping =~ /,\s+(\d+).*dsk\/(.*)/)
   {
    my $minor="VxVM".$1;
    my $volume=$2;
    $volume =~ s/\//\-/g;
    #print "$minor $volume\n";
    $hash{"$minor"} = $volume;
   }
 }

my @cmd = `/usr/bin/iostat -mx 2 1`;

foreach my $line (@cmd)
 {
  if ($line =~ /^(Vx\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+(\S+)\s+/)
   {
    my ($device, $rrqms, $wrqms, $rs, $ws, $rmbs, $wmbs, $avgrq, $avqqu, $await, $svctm, $util) = ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12);
    print "$hash{$device} $line";
   }
 }
}
