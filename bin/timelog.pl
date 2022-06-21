#!/usr/bin/perl 
#

use strict;
use warnings;
use POSIX qw(strftime);
use DateTime;

# time table
# | Time | Task | Description
# | 11:10| time tracking | study
# | 12:52| lunch | 
# | 13:17| time tracking | 
# | 14:31-14:59| break|
# | 15:21| ser12345| works. 
#
# How to handle time range?
# 1. caculate the current range task time. 
# 3. if pre_task is range, ignore caculate pre_task


my $wiki_diary_path = "$ENV{HOME}/Dropbox/vimwiki/diary"; 
#my $today = strftime "%F", localtime;
my %tasks = ();
my $debug = 0;
my $task_max_length = 0;


my $today = DateTime->today(time_zone => 'local');
my $yesterday = $today->clone->add(days => -1);

# show a week reports
for( my $i = 6 ; $i >= 0 ; $i--){
    my $day = $today->clone->add(days => -1 * $i);
    &report($day->ymd);
}


sub report {
    my ($date) = @_;
    %tasks = ();
    $task_max_length = 0;

    my $wiki_filepath = "$wiki_diary_path/${date}.wiki";

    if( not -e $wiki_filepath ) {
        print "$date not exits!\n";
        return;
    }

    open (my $wiki_fh,$wiki_filepath) or die "Can't find the files $wiki_filepath $!\n";


    my $pre_task_range = 0;
    my $task_range = 0;
    my $pre_task;
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
        # Get Task
        ################
        $data[2] =~ s/^\s+|\s+$//;

        # check if task is range, if range task we just add to hash
        if( $data[1] =~ /(.*)\-(.*)/ ) {
            my $time_diff = &timediff($2,$1);
            print "[range task] $data[2]: $2 - $1 = $time_diff\n" if $debug;
            &addtime($data[2],$time_diff);
            $task_range = 1;
        } else {
            $task_range = 0;
        }


        # if no pre_task , it is first task we set it to task , then to next
        if( not defined($pre_task) ){
            $pre_time = $data[1];
            $pre_task = $data[2];
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
          &addtime($pre_task,$time_diff);
        }

        # save current task to pre_task, but if current task is range, it need to use second part of data[1] 
        $pre_time = $data[1];
        if($task_range) {
            $data[1] =~/(.*)\-(.*)/;
            $pre_time = $2;
        }

        $pre_task = $data[2];

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
    print "| Task" . " "x($task_max_length-3) . "| Time\n";
    print "| " . "-"x($task_max_length) . " | ----\n";
    foreach my $key ( sort { $tasks{$b} <=> $tasks{$a}}  keys %tasks ) {
        my $value = $tasks{$key};
        print "| $key | " . sprintf("%.2f",$value/60) . "\n";
    }

    close($wiki_fh);
}

# substruct two time and return mins
# 13:10 - 11:20 = 50
sub timediff {
    my ($t1_str,$t2_str) = @_;
    $t1_str =~ /(\d{2}):(\d{2})/;
    my $t1_h = $1;
    my $t1_m = $2;
    my $t1 = ( $t1_h * 60 ) + $t1_m;

    $t2_str =~ /(\d{2}):(\d{2})/;
    my $t2_h = $1;
    my $t2_m = $2;
    my $t2 = ( $t2_h * 60 ) + $t2_m;
    #print( "t1 = $t1_str , t2 = $t2_str \n");
    return $t1 - $t2 ;
}

sub addtime { 
    my ($task,$time) = @_;
    if( not exists $tasks{$task} ) {
        $tasks{$task} = 0;
    }
    if ( length($task) > $task_max_length ) {
        $task_max_length = length($task);
    }
    $tasks{$task}+= $time;
}


