#!/usr/bin/perl
$| = 1;

$username = `whoami`;
chomp $username;

$masterLog = "/home/student/jourmeob/.myTalk/masterLog.txt";
# User log file is not used as of now.
$userLog = "/home/student/jourmeob/.myTalk/userLog.txt";
$LOGFILE = "/home/student/" . $username . "/.myTalk/log.txt";

$pid;

# Command line argument switch.
# Only look for -i if --start-nw was used
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
   
   ###added to add color   
   $temp = qx(whoami | shasum | cut -d' ' -f1 | sed -r 's/[a-z]+/0/g');
   @temp1 = $temp =~ /./sg;
   $x =0;
   foreach(@temp1){
      $x= $x + $temp1[$i];
      $i++
   }
   $x = $x % 8 + 40;
   chomp($x);
   ###end color things, anyway feel free to simplify.
   chomp($time);

   open($MYFILE,">> $masterLog") or die("Error opening file\n");
   print $MYFILE "$x__[$time] $username: $in\n";
   close $MYFILE;
   select(undef, undef, undef, 0.5);
   exit(0);
#### end main ####

#### functions ####

# Quietly kills all tails (that the user has permission to kill,
# and tailTalk, which cleans up after itself
sub killer
{
   # Overkill tail
   system("killall tail 2>> /dev/null");
   system("killall tailTalk 2>> /dev/null");
}

# Starts the main client (tailTalk) in either it's own window,
# interactive (current window) or no-window (background)
sub start
{
   $cmd = shift;

   my $childID = fork();
   if($childID == 0) #Child
   {
      sleep(2);
      # Only notify the user that tail talk started if in
      # no-window, non interactive mode...
      # If they used a window, or interactive mode, they
      # know that myTalk has started...
      if($cmd eq "nw"){
         print "\ntailTalk started\n\n";
      }
      system("~/.myTalk/myt start: logging on");
   }
   else
   {

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
   }
}

# Prints whether or not tailTalk is running
sub status
{

   $tail = getTails();

   if ($tail eq ""){
      print "tailTalk is not running\n";
   }else{
      print "tailTalk is running\n";
   }
}

# Returns the pid(s) of all instances of *tailTalk*
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
   print "Version 0.2.6\n";
   print "Check ~/.myTalk/notes.txt for release notes\n";
}

# A nice list of all the users logged on. This is a bit broken...
sub who
{
   print "This functionality is currently under development\n";
   print "Check ~/.myTalk/notes.txt for more details\n";
}

# Reprints the last 3 lines in the logfile, in case the user missed it..
sub printLast
{
   $lastLine = `tail -n 3 $masterLog`;
   print $lastLine;
}
