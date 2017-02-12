package Bot::IRC::Math;
# ABSTRACT: Bot::IRC evaluate math expressions and return results

use 5.012;
use strict;
use warnings;

use Math::Expression;

# VERSION

sub init {
    my ($bot) = @_;
    my $expr = Math::Expression->new( PrintErrFunc => sub {} );

    $bot->hook(
        {
            command => 'PRIVMSG',
            text    => qr/^[\d\s\+\-\/\*\%\^\(\)]+$/,
        },
        sub {
            my ( $bot, $in ) = @_;
            my $value = $expr->EvalToScalar( $expr->Parse( $in->{text} ) );
            ( my $clean_text = $in->{text} ) =~ s/\s+//g;
            $bot->reply($value) if ( $value and $value ne $clean_text );
        },
    );

    $bot->helps( math => 'Evaluate math expressions. Usage: <math expression>.' );
}

1;
__END__
=pod

=head1 SYNOPSIS

    use Bot::IRC;

    Bot::IRC->new(
        connect => { server => 'irc.perl.org' },
        plugins => ['Math'],
    )->run;

=head1 DESCRIPTION

This L<Bot::IRC> plugin gives the bot the capability to evaluate math
expressions and return the results.

See L<Math::Expression> for details. Message text is evaluated with C<Parse>
and C<EvalToScalar> from L<Math::Expression>. If there's a value generated, the
bot replies with the value.

=head2 SEE ALSO

L<Bot::IRC>

=for Pod::Coverage init

=cut
