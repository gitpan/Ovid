package Ovid::RunQuiet;

use strict;

use Ovid::Common;
use Ovid::IORedirector;
use Ovid::Error;

@Ovid::RunQuiet::ISA = qw(Ovid::Common Ovid::Error);

sub accessors { return { scalar => [qw(logfile)]}; }

sub run
  {
    my ($self, $routine, $logfile) = @_;
    
    my $io_stdout = Ovid::IORedirector->new(handle => \*STDOUT, logfile => $logfile);
    my $io_stderr = Ovid::IORedirector->new(handle => \*STDERR, logfile => $logfile);
    my ($io_stdout, $io_stderr);
    my $results = &$routine;
    undef $io_stderr;
    undef $io_stdout;
    my $caller = caller();
    return $results;
  }

1;

