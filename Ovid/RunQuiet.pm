package Ovid::Redirect;

sub new
{
  my $self = bless {}, __PACKAGE__;
  open(TMPOUT,  ">&STDOUT");
  open(TMPERR,  ">&STDERR");
  
  open(STDERR, ">&TMPOUT");
  open(STDOUT, ">&TMPERR");      

  $self->{stdout} = *TMPOUT{IO};
  $self->{stderr} = *TMPERR{IO};
  return $self;
}

sub restore  {
  my $self = shift;
  open(STDERR, ">&$self->{stderr}");
  open(STDOUT, ">&$self->{stdout}");
}

package Ovid::RunQuiet;

use strict;

use Ovid::Common;
use Ovid::Error;

@Ovid::RunQuiet::ISA = qw(Ovid::Common Ovid::Error);

sub accessors { return { scalar => [qw()]}; }


sub run
  {
    my ($routine) = @_;
    my $io = Ovid::Redirect->new;
    &$routine;
    $io->restore;
  }


1;

