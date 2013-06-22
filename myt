#!/usr/bin/perl


#use Tie::File;

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
   start("nw");
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

#$in = join(' ', @ARGV);
#$time=`date +"%H:%M:%S"`;
#chomp($time);

##write to the master..
#open($MYFILE,">> $masterLog") or die("Error opening file\n");

#print $MYFILE "[$time] $username: $in\n";
#close $MYFILE;

## now print to all the users file
#open($USERFILE, "< $userLog") or die("Error opening file\n");
#while(<$USERFILE>)
#{
#   $st = $_;
#   $st = chomp($sp); 
#   open($OTHERFILE, ">> /home/student/".$st.".myTalk/log.txt");
#   print $OTHERFILE "[$time] $username: $in\n";
#   close $OTHERFILE;
#}

#select(undef, undef, undef, 0.3);
#exit(0);






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
#   tie @temparray, 'Tie::File', $userLog or die "cannot open userLog\n";
#   $l = $temparray;
#   for($p=0;$p<$l;$p++){
#      if(@temparray[$p] eq "$username\n" ){
#         splice(@temparray, $p, 1);    # delete the username from the file
#      }
#   }

#   untie @temparray;


   $tail = getTails();
   if($tail eq ""){
      print "tailTalk is not running\n";
   }else{
      system("~/.myTalk/myt \"quit: logging off\"");
      system("kill `pgrep tailTalk` 2>> /dev/null");
      system("kill `pgrep tail` 2>> /dev/null");
      print "tailTalk killed\n";
   }
}

sub start
{
   $cmd = shift;

#print "DEBUGG THIS IS CMD: $cmd\n";
   if($cmd eq "w")
   {
      system("~/.myTalk/starter");
   }elsif($cmd eq "nw"){
      system("~/.myTalk/starter nw");
   }

# # handle the userLog file I/O
#   tie @temparray, 'Tie::File', $userLog or die "cannot open userLog\n";
#      
#   push(@temparray,$username);
#   untie @temparray;

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
   $pid = `ps aux | grep "/home/student/$username/.myTalk/tailTalk"`;

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
   print "Version 0.2.4\n";
   print "Check ~/.myTalk/notes.txt for release notes\n";
}

sub who
{
#   open($theUsers, "< ", $userLog) 
#      or die("Unable to open file ". $userLog);
#   @allUsers = <$theUsers>;
#   $l = $allUsers;
#   if($1 == 0){
#      print "There are no users on-line\n";
#   }else{
#      print "The following users are on-line\n";
#      for($p=0;p<$l;$p++){
#         print "@allUsers[$p]\n";
#      }
#   }

   print "This functionality is currently under development\n";
   print "Check ~/.myTalk/notes.txt for more details\n";

}


