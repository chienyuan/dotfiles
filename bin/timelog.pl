#!/usr/bin/perl 
use strict;
use warnings;
use POSIX qw(strftime);

# FIXME: DateTime not work for perl 5.8.8
#use DateTime;

# time table
# | Time | Task | Description
# | 11:10| time tracking | study
# | 12:52| break |  lunch
# | 13:17| time tracking | 
# | 14:31-14:59| break|
# | 15:21| ser12345| works. 
# | 99:99| end | it is current time, for real time check, should delete at the end of date.
#
# How to handle time range?
# 1. caculate the current range task time. 
# 3. if pre_task is range, ignore caculate pre_task


my $wiki_diary_path = "$ENV{HOME}/dev/vimwiki/diary"; 
$wiki_diary_path = $ENV{'TIMELOG_DIR'} if  defined $ENV{'TIMELOG_DIR'};

my $today = strftime "%F", localtime;
my %tasks = ();
my %descs = (); # use desc ask key , and task as value, when report , show all the key for that task
my $debug = 0;

use constant ONE_DAY => 24 * 60 * 60;



############################################################3
# FIXME: DateTime not work for perl 5.8.8
#my $today = DateTime->today(time_zone => 'local');
#my $yesterday = $today->clone->add(days => -1);
#
# show a week reports
#for( my $i = 6 ; $i >= 0 ; $i--){
#    my $day = $today->clone->add(days => -1 * $i);
#    &report($day->ymd);
#}
############################################################3

for( my $i = 6 ; $i >= 0 ; $i--){
    my @report_time = localtime time - ( $i * ONE_DAY) ;
    my $day = strftime "%F", @report_time;
    &report($day);
}

#&report($today);

sub report {
    my $task_max_length = 17;
    my $desc_max_length = 100;
    my ($date) = @_;
    %tasks = ();
    %descs = ();

    my $wiki_filepath = "$wiki_diary_path/${date}.wiki";

    if( not -e $wiki_filepath ) {
        print "$date not exits!\n";
        return;
    }

    open (my $wiki_fh,$wiki_filepath) or die "Can't find the files $wiki_filepath $!\n";


    my $pre_task_range = 0;
    my $task_range = 0;
    my $pre_task;
    my $pre_desc;
    my $pre_time;

    while(<$wiki_fh>){
        my @data = split '\|';
        ################
        # Get Time
        ################
        next if not defined $data[1];

        # trim space of time
        $data[1] =~ s/^\s+|\s+$//;

        # if it is not time , go next 
        next if $data[1] !~ /^\d{2}:\d{2}/;

        ################
        # Get Task and Desc
        ################
        $data[2] =~ s/^\s+|\s+$//;
        $data[3] =~ s/^\s+|\s+$//;
        if ( length($data[2]) > $task_max_length ) {
            $task_max_length = length($data[2]);
        }

        # check if task is range, if range task we just add to hash
        if( $data[1] =~ /(.*)\-(.*)/ ) {
            my $time_diff = &timediff($2,$1);
            print "[range task] $data[2]: $2 - $1 = $time_diff\n" if $debug;
            &addtime($data[2],$time_diff,$data[3]);
            $task_range = 1;
        } else {
            $task_range = 0;
        }


        # if no pre_task , it is first task we set it to task , then to next
        if( not defined($pre_task) ){
            $pre_time = $data[1];
            $pre_task = $data[2];
            $pre_desc = $data[3];
            # if first task is range, it doesn't matter want's in pre_time, because we don't need to count range task.
            if ( $task_range ) {
                $data[1] =~/(.*)\-(.*)/;
               $pre_time = $2; 
            }
            #    print "first task: $data[2]-$data[1]\n";
            next;
        }


        # if pre_task is range , just set pre_task , ignore the calucation. 
        #if ( $pre_task_range ) {
        #    # save current task to pre_task
        #    $pre_time = $data[1];
        #    $pre_task = $data[2];
        #    $pre_task_range = 0;
        #    next;
        #}

        # if task_range, curr_time need to use to the first part of data[1]
        my $cur_time = $data[1];
        if ( $task_range ) {
            $data[1] =~/(.*)\-(.*)/;
           $cur_time = $1; 
        }

        # count for pre_task if pre_task isn't range 
        if( not $pre_task_range ) {
          my $time_diff = &timediff($cur_time,$pre_time);
          print "$pre_task: $cur_time - $pre_time = $time_diff\n" if $debug;
          &addtime($pre_task,$time_diff,$pre_desc);
        }

        # save current task to pre_task, but if current task is range, it need to use second part of data[1] 
        $pre_time = $data[1];
        if($task_range) {
            $data[1] =~/(.*)\-(.*)/;
            $pre_time = $2;
        }

        $pre_task = $data[2];
        $pre_desc = $data[3];

        # save task_range for pre_task_range
        if( $task_range ) {
            $pre_task_range = 1;
        } else {
            $pre_task_range = 0;
        }
    }

    print "[Last Task] $pre_task:  $pre_time \n" if $debug;

    print "task max length=$task_max_length \n" if $debug;
    print "\nSummary: $date\n";
    print "| Task" . " "x($task_max_length-5) . "|  Time | Desc\n";
    print "| " . "-"x($task_max_length-2) . " | ----- |" . "-" x ($desc_max_length) . "\n";
    my $total = 0;
    my $break  = 0;
	foreach my $key ( sort { $tasks{$b} <=> $tasks{$a}}  keys %tasks ) {
        my $value = $tasks{$key};
        my $hours = sprintf("%.2f",$value/60);
        $total += $hours;

        my $all_descs = "";
        foreach my $desc_key ( keys %descs) {
            if( $descs{$desc_key} eq $key ) {
              $desc_key =~ s/^\s+|\s+$//;
              $all_descs .= ($desc_key . ", " );  
          }
        }

        printf "| $key| %5s | $all_descs \n", $hours;
        $key =~ s/^\s+|\s+$//;
		  	$break += $hours if $key eq "break" or $key eq  "lunch" or $key eq "commute" ;
    }
    
    print "| " . "-"x($task_max_length-2) . " | ----- |" . "-" x ($desc_max_length) . "\n";
    my $space = " "x($task_max_length-15);
    printf "| Total         %s| %5s \n" , $space, $total;
    printf "| Total no break%s| %5s \n" , $space, $total-$break;

    close($wiki_fh);
}

# substruct two time and return mins
# 13:10 - 11:20 = 50
sub timediff {
    # curr_time, pre_time
    my ($t1_str,$t2_str) = @_;
    if( $t1_str =~ /99:99/ ) {
      $t1_str = strftime "%R", localtime;
      # print "use current system time for 99:99\n";
   } 
    $t1_str =~ /(\d{2}):(\d{2})/;
    my $t1_h = $1;
    my $t1_m = $2;
    my $t1 = ( $t1_h * 60 ) + $t1_m;

    # if crr_time is 99:99, then it use the system current time.

    $t2_str =~ /(\d{2}):(\d{2})/;
    my $t2_h = $1;
    my $t2_m = $2;
    my $t2 = ( $t2_h * 60 ) + $t2_m;
    #print( "t1 = $t1_str , t2 = $t2_str \n");
    return $t1 - $t2 ;
}

sub addtime { 
    my ($task,$time,$desc) = @_;
    if( not exists $tasks{$task} ) {
        $tasks{$task} = 0;
    }
    $tasks{$task}+= $time;
    $descs{$desc} = $task if not $desc eq "";
}


