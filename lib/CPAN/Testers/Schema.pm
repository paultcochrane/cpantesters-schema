package CPAN::Testers::Schema;
our $VERSION = '0.001';
# ABSTRACT: Schema for CPANTesters database processed from test reports

=head1 SYNOPSIS

    my $schema = CPAN::Testers::Schema->connect( $dsn, $user, $pass );
    my $rs = $schema->resultset( 'Stats' )->search( { dist => 'Test-Simple' } );
    for my $row ( $rs->all ) {
        if ( $row->state eq 'fail' ) {
            say sprintf "Fail report from %s: http://cpantesters.org/cpan/report/%s",
                $row->tester, $row->guid;
        }
    }

=head1 DESCRIPTION

This is a L<DBIx::Class> Schema for the CPANTesters statistics database.
This database is generated by processing the incoming data from L<the
CPANTesters Metabase|http://metabase.cpantesters.org>, and extracting
the useful fields like distribution, version, platform, and others (see
L<CPAN::Testers::Schema::Result::Stats> for a full list).

This is its own distribution so that it can be shared by the backend
processing and the frontend web application.

=head1 SEE ALSO

=over 4

=item L<CPAN::Testers::Schema::Result::Stats>

=item L<DBIx::Class>

=item L<http://github.com/cpan-testers/cpantesters-project>

For an overview of how the CPANTesters project works, and for information about
project goals and to get involved.

=back

=cut

use strict;
use warnings;
use base 'DBIx::Class::Schema';

__PACKAGE__->load_namespaces;

# Convenience connect method
sub connect_from_config {
    my $schema = shift->connect(
        "DBI:mysql:mysql_read_default_file=$ENV{HOME}/.cpanstats.cnf;".
        "mysql_read_default_group=application;mysql_enable_utf8=1",
        undef,  # user
        undef,  # pass
        {
            AutoCommit => 1,
            RaiseError => 1,
            mysql_enable_utf8 => 1,
            quote_char => '`',
            name_sep   => '.',
        },
    );
    $schema->txn_begin;
    return $schema;
}

1;
