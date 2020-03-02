package DevicesServer::Controller::API;
use Moose;
use namespace::autoclean;

use strict;
use warnings;
use base 'Catalyst::Controller::REST';

BEGIN { extends 'Catalyst::Controller'; }
BEGIN { extends 'DevicesServer::Controller::APIHelper'; }

sub base : Chained('/') PathPart('api') CaptureArgs(0) { 
	my ($self, $c) = @_;
}

sub base_login : Chained('base') PathPart('') CaptureArgs(0) {
	my ( $self, $c) = @_;

    my ($email, $password) = $c->req->headers->authorization_basic();

    my $user = $c->model('DB::User')->search({ email => $email, password => $password })->first();
    unless ( defined($user) ) {
        $self->detach_permission_denied($c, "Please login!");
    }
    $c->stash->{user} = $user;
}


__PACKAGE__->meta->make_immutable;
1;