package Bot::IRC::Ping;
# ABSTRACT: Bot::IRC ping the bot and check its health

use 5.012;
use strict;
use warnings;

# VERSION

sub init {
    my ($bot) = @_;

    $bot->hook(
        {
            to_me => 1,
            text  => qr/^(?<ping>ping)\b/i,
        },
        sub {
            my ( $bot, $in, $m ) = @_;
            ( my $pong = $m->{ping} ) =~ s/(i)/ ( $1 eq 'i' ) ? 'o' : 'O' /ie;
            my $health = $bot->health;

            $bot->reply_to(
                "$pong. Connected to $health->{server} on port $health->{port} (" .
                ( ( $health->{ssl} ) ? 'over SSL/TLS' : 'direct connection' ) . '). ' .
                "Spawned $health->{spawn} child processes. " .
                "There are $health->{hooks} hooks and $health->{ticks} ticks " .
                "installed via $health->{plugins} loaded plugins."
            );
        },
    );

    $bot->helps( ping => 'Ping the bot and check its health. Usage: <bot> ping.' );
}

1;
__END__
=pod

=head1 SYNOPSIS

    use Bot::IRC;

    Bot::IRC->new(
        connect => { server => 'irc.perl.org' },
        plugins => ['Ping'],
    )->run;

=head1 DESCRIPTION

This L<Bot::IRC> plugin causes the bot to respond to pings from users
and reports on the bot's health.

=head2 SEE ALSO

L<Bot::IRC>

=for Pod::Coverage init

=cut
