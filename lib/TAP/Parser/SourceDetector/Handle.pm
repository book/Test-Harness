package TAP::Parser::SourceDetector::Handle;

use strict;
use vars qw($VERSION @ISA);

use TAP::Parser::SourceDetector   ();
use TAP::Parser::SourceFactory    ();
use TAP::Parser::Iterator::Stream ();

@ISA = qw(TAP::Parser::SourceDetector);

TAP::Parser::SourceFactory->register_detector(__PACKAGE__);

=head1 NAME

TAP::Parser::SourceDetector::Handle - Stream TAP from an IO::Handle or a GLOB.

=head1 VERSION

Version 3.18

=cut

$VERSION = '3.18';

=head1 SYNOPSIS

  use TAP::Parser::SourceDetector::Handle;
  my $source = TAP::Parser::SourceDetector::Handle->new;
  my $stream = $source->raw_source( \*TAP_FILE )->get_stream;

=head1 DESCRIPTION

This is a I<raw TAP stored in an IO Handle> L<TAP::Parser::SourceDetector> class.  It
has 2 jobs:

1. Figure out if the I<raw> source it's given is an L<IO::Handle> or GLOB
containing raw TAP output.  See L<TAP::Parser::SourceFactory> for more details.

2. Takes raw TAP from the handle/GLOB given and converts into an iterator.

Unless you're writing a plugin or subclassing L<TAP::Parser>, you probably
won't need to use this module directly.

=head1 METHODS

=head2 Class Methods

=head3 C<can_handle>

  my $vote = $class->can_handle( $source );

Casts the following votes:

  0.9 if $source is an IO::Handle
  0.8 if $source is a glob

=cut

sub can_handle {
    my ( $class, $src ) = @_;
    my $meta = $src->meta;

    return 0.9
      if $meta->{is_object}
          && UNIVERSAL::isa( $src->raw, 'IO::Handle' );

    return 0.8 if $meta->{is_glob};

    return 0;
}

=head3 C<make_iterator>

  my $iterator = $class->make_iterator( $source );

Returns a new L<TAP::Parser::Iterator::Stream> for the source.

=cut

sub make_iterator {
    my ( $class, $source ) = @_;

    $class->_croak('$source->raw must be a glob ref or an IO::Handle')
      unless $source->meta->{is_glob}
	|| UNIVERSAL::isa( $source->raw, 'IO::Handle' );

    return $class->iterator_class->new( $source->raw );
}

=head3 C<iterator_class>

The class of iterator to use, override if you're sub-classing.  Defaults
to L<TAP::Parser::Iterator::Stream>.

=cut

use constant iterator_class => 'TAP::Parser::Iterator::Stream';

1;

=head1 SUBCLASSING

Please see L<TAP::Parser/SUBCLASSING> for a subclassing overview.

=head1 SEE ALSO

L<TAP::Object>,
L<TAP::Parser>,
L<TAP::Parser::Iterator>,
L<TAP::Parser::Iterator::Stream>,
L<TAP::Parser::SourceFactory>,
L<TAP::Parser::SourceDetector>,
L<TAP::Parser::SourceDetector::Executable>,
L<TAP::Parser::SourceDetector::Perl>,
L<TAP::Parser::SourceDetector::File>,
L<TAP::Parser::SourceDetector::RawTAP>

=cut
