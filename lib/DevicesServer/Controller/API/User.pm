package DevicesServer::Controller::API::User;
use Moose;
use namespace::autoclean;

use strict;
use warnings;
use base 'Catalyst::Controller::REST';

BEGIN { extends 'Catalyst::Controller'; }
BEGIN { extends 'DevicesServer::Controller::APIHelper'; }

sub base : Chained('../base') PathPart('user') CaptureArgs(0) {
	my ( $self, $c ) = @_;
}

sub base_login : Chained('../base_login') PathPart('user') CaptureArgs(0) {
	my ( $self, $c ) = @_;
}

sub user_list : Chained('base') PathPart('') Args(0) ActionClass('REST') { }

sub user_list_POST {
    my ( $self, $c ) = @_;
 
    my $new_user_data = $c->req->data;
    if ( !defined($new_user_data) ) {
    	return $self->status_bad_request( $c, "You must provide a user to create or modify!" );
    }
	foreach my $required (qw(fullname email password)) {
    	return $self->detach_bad_request( $c,
        "Missing required field: " . $required )
      	if !exists( $new_user_data->{$required} );
	}
	print Data::Dumper::Dumper $c->model('DB::User')->search({ email => $new_user_data->{email} } )->count();
	if($c->model('DB::User')->search({ email => $new_user_data->{email} } )->count()) {
		$self->detach_bad_request( $c,
        "Email already in use: " . $new_user_data->{email} );
	}
	my $user = $c->model('DB::User')->create( {
	password => $new_user_data->{'password'},
    fullname    => $new_user_data->{'fullname'},
    email => $new_user_data->{'email'},
}
	);
	my $return_entity = {
	    user_id     => $user->user_id,
	    fullname    => $user->fullname,
	    email => $user->email,
	};

    $self->return_success($c,$return_entity);
}

sub check_login : Chained('base_login') PathPart('check_login') Args(0) ActionClass('REST') {
    my ( $self, $c ) = @_;
}

sub check_login_GET {
    my ( $self, $c) = @_;
 	
    my $user = $c->stash->{user};

    if ( defined($user) ) {
        $self->return_success($c, {});
    }
    else {
        $self->detach_permission_denied( $c );
    }
}

__PACKAGE__->meta->make_immutable;

1;
