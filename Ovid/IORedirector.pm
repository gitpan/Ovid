package Ovid::IORedirector;

use strict;

use Ovid::Common;
use Ovid::Error;

@Ovid::IORedirector::ISA = qw(Ovid::Common Ovid::Error);

sub init
{
  my $self = shift;
  if (my $t = $self->handle){
    $self->redirect_io($t, $self->logfile);
  }
}

sub accessors {
  return {scalar => [qw(handle tmp_handle logfile active)]};
}

sub defaults
{
  return { logfile => '/dev/null', active => 0};
}


sub redirect_io
{
  my ($self, $handle, $logfile) = @_;
  
  my $tmp_handle;
  
  my $fd = fileno($handle); 

  $self->handle($handle);

  unless (open($tmp_handle, ">&$fd")){
      fatal "cannot dup handle $handle: $!";
  }
  
  $self->tmp_handle(*$tmp_handle{IO});
  close $handle; 
  open $handle, ">>$logfile" or die "cannot redirect handle to file [$logfile]: $!";
  
  select $handle; $| = 1;     # make unbuffered
  
  $self->active(1);
}

sub restore_io
{
  my ($self) = @_;
  return unless $self->active;
  if (my ($t, $s) = ($self->handle, $self->tmp_handle)){
    my $fd = fileno($s);
    close($t);
    open $t, ">&$fd"  or fatal "cannot restore handle: $!";
    $self->active(0);
  }
}

sub DESTROY
{
  my $self = shift;
  $self->restore_io if $self->active;
}


1;

