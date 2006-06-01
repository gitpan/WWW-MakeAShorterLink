# $Id: MakeAShorterLink.pm,v 1.7 2006/06/01 18:29:46 dave Exp $

=head1 NAME

MakeAShorterLink - Perl interface to makeashorterlink.com

=head1 SYNOPSIS

  use WWW::MakeAShorterLink;

  $short_url = makeashorterlink($long_url);

  $long_url  = makealongerlink($short_url);

=head1 DESCRIPTION

A Perl interface to the web site makeashorterlink.com (MASL to its
friends). MASL simply maintains a database of long URLs, each of which
has a unique identifier.

=head1 DEPRECATED

This module is deprecated and will be removed from CPAN at some point in
the next year. Its functionality is replaced by WWW::Shorten and its
various subclasses.

=cut

package WWW::MakeAShorterLink;

use 5.006;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);
our @EXPORT = qw(makeashorterlink makealongerlink);
our $VERSION = sprintf "%d.%02d", '$Revision: 1.7 $ ' =~ /(\d+)\.(\d+)/;

use LWP;
use Carp;

=head1 FUNCTIONS

=head2 makeashorterlink

The function C<makeashorterlink> will call the MASL web site passing it 
your long URL and will return the shorter MASL version.

=cut

sub makeashorterlink {
  my $masl = 'http://www.makeashorterlink.com/index.php';
  my $url = shift or croak 'No URL passed to makeashorterlink';

  my $ua = LWP::UserAgent->new;

  my $resp = $ua->post($masl,
                       [ url => $url ]);

  return unless $resp->is_success;

  if ($resp->content =~ m!Your shorter link is: <a href="(.*)">!) {
    return $1;
  }
  return;
}

=head2 makealongerlink

The function C<makealongerlink> does the reverse. C<makealongerlink>
will accept as an argument either the full MASL URL or just the MASL
identifier.

If anything goes wrong, then either function will return C<undef>.

=cut

sub makealongerlink {
  my $masl_url = shift 
    or croak 'No MASL key / URL passed to makealongerlink';

  $masl_url = "http://www.makeashorterlink.com/?$masl_url"
    unless $masl_url =~ m!^http://!i;

  my $ua = LWP::UserAgent->new;

  my $resp = $ua->get($masl_url);

  return unless $resp->is_success;

  return
    if $resp->content =~ m!That doesn\'t look like a Make A Shorter Link key.!;

  if ($resp->content =~ m!<meta HTTP-EQUIV="Refresh" CONTENT="5\; URL=(.*)"!i) {
    return $1;
  }
  return;
}

1;

__END__

=head2 EXPORT

makeashorterlink, makealongerlink

=head1 AUTHOR

Dave Cross <dave@mag-sol.com>
Original LWP hacking by Alex Page <grimoire@corinne.cpio.org>
C<makealongerlink> idea by Simon Batistoni <simon@hitherto.net>

=head1 SEE ALSO

L<perl>, L<http://makeashorterlink.com/>

=cut

#
# $Log: MakeAShorterLink.pm,v $
# Revision 1.7  2006/06/01 18:29:46  dave
# Added deprecation notice.
#
# Revision 1.6  2004/10/23 21:55:18  dave
# Reorganise POD
#
#
