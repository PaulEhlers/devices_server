package DevicesServer::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'DevicesServer::Schema',
    
    
);

=head1 NAME

DevicesServer::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<DevicesServer>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<DevicesServer::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.65

=head1 AUTHOR

Paul Ehlers

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;