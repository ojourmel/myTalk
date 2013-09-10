#!/usr/bin/perl

$| = 1;

$username = `whoami`;
chomp $username;

$masterLog = "/home/student/jourmeob/.myTalk/masterLog.txt";
$userLog = "/home/student/jourmeob/.myTalk/userLog.txt";
$LOGFILE = "/home/student/" . $username . "/.myTalk/log.txt";

$pid;

if(@ARGV[0] eq "--kill")
{
   killer();
   exit(0);
}

if(@ARGV[0] eq "--start")
{
   start("w");
   exit(0);
}

if(@ARGV[0] eq "--start-nw")
{
   if(@ARGV[1] eq "-i")
   {
      start("nwi");
   }
   else
   {
      start("nw");
   }
   exit(0);
}

if(@ARGV[0] eq "-r")
{
   printLast();
   exit(0);
}

if(@ARGV[0] eq "--stat")
{
   status();
   exit(0);
}

if(@ARGV[0] eq "--who")
{
   who();
   exit(0);
}

if(@ARGV[0] eq "--update")
{
   update();
   exit(0);
}

if(@ARGV[0] eq "--version")
{
   version();
   exit(0);
}

if(@ARGV[0] eq "--help")
{
   help();
   exit(0);
}

#### main ####

   $in = join(' ', @ARGV);
   $time=`date +"%H:%M:%S"`;
   chomp($time);

   open($MYFILE,">> $masterLog") or die("Error opening file\n");
   print $MYFILE "[$time] $username: $in\n";
   close $MYFILE;
   select(undef, undef, undef, 0.5);
   exit(0);

#### end main ####

#### functions ####

sub killer
{
   $tail = getTails();
   system("killall tail 2>> /dev/null");
   
   if($tail ne "")
   {
      system("~/.myTalk/myt \"quit: logging off\"");
      system("killall tailTalk 2>> /dev/null");
      print "tailTalk killed\n";
   }
}

sub start
{
   $cmd = shift;

   if($cmd eq "w")
   {
      system("~/.myTalk/starter w");
   }
   elsif($cmd eq "nw")
   {
      system("~/.myTalk/starter nw");
   }
   elsif($cmd eq "nwi")
   {
      system("~/.myTalk/starter nw true");
   }

# clean up and be done
   sleep(1);
   system("~/.myTalk/myt start: logging on");
   print "\ntailTalk started\n\n";
}

sub status
{

   $tail = getTails();

   if ($tail eq ""){
      print "tailTalk is not running\n";
   }else{
      print "tailTalk is running\n";
   }
}

sub getTails
{
   $pid = `ps aux | grep -e $username.*tailTalk`;

   @tmp = split ('\n',$pid);
   pop @tmp; # ignore the last two elements, it's the calls to grep
   pop @tmp; # and a new line

   $pid = join ("\n",@tmp);
}

sub update
{
   print "use \"make update\" inside the ~/.myTalk/ folder\n";
}

sub help
{
   system("less ~/.myTalk/README");
}

sub version
{
   print "Version 0.2.5\n";
   print "Check ~/.myTalk/notes.txt for release notes\n";
}

sub who
{
   print "This functionality is currently under development\n";
   print "Check ~/.myTalk/notes.txt for more details\n";
}

sub printLast
{
   $lastLine = `tail -n 3 $masterLog`;
   print $lastLine;
}

