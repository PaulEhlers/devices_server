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

sub user_list : Chained('base') PathPart('') Args(0) ActionClass('REST') { }

sub user_list_GET {
    my ( $self, $c ) = @_;
 
    my %user_list;
    my $user_rs = $c->model('DB::User')->search;
    my @users = ();
    while ( my $user_row = $user_rs->next ) {
        push(@users, { fullname => $user_row->fullname,user_id => $user_row->user_id,email => $user_row->email })
    }
    $self->return_success( $c, \@users );
}



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

sub check_login : Chained('base') PathPart('check_login') Args(0) ActionClass('REST') {
    my ( $self, $c ) = @_;
}

sub check_login_GET {
    my ( $self, $c) = @_;
 	
    my $check_data = $c->req->data;

    my $user = $c->model('DB::User')->search({ email => $check_data->{email}, password => $check_data->{password} })->first();
    if ( defined($user) ) {
        $self->return_success($c);
    }
    else {
        $self->detach_not_found( $c );
    }
}

sub supply_test_data : Chained('base') PathPart('supply_test_data') Args(0) ActionClass('REST') {
    my ( $self, $c ) = @_;
}

sub supply_test_data_GET {
	my ( $self, $c ) = @_;

	my $example_user = $c->model('DB::User')->find_or_create( {
			password => "test",
		    fullname    => "test",
		    email => 'test@test.de',
		}
	);

	my $other_example_user = $c->model('DB::User')->find_or_create( {
			password => "test",
		    fullname    => "test",
		    email => 'test2@test.de',
		}
	);

	my $lonely_example_user = $c->model('DB::User')->find_or_create( {
			password => "test",
		    fullname    => "test",
		    email => 'test3@test.de',
		}
	);

	for my $example_string ( qw/Muster Test/ ) {
		my $location = $c->model('DB::Location')->create({
			city => $example_string,
			name => $example_string,
			street => "$example_string Street 123",
			postcode => "12345",
		});

		for my $room_name ( qw/ Matheraum Chemieraum Physikraum/ ) {
			my $room = $location->rooms->create({
					name => $room_name				
				});
			for my $user ( ($example_user, $other_example_user) ) {
				for my $device_type (qw/ WIFI Router Switch PC /) {
					my $device = $room->devices->create({
							type => $device_type,
							user_id => $user->id,
						});
				}
			}
		}
	}

	my $location = $c->model('DB::Location')->create({
			city => "Lonely",
			name => "Lonely",
			street => "Lonely Street 123",
			postcode => "12345",
		});

	my $room = $location->rooms->create( { name => "Lonely Room" } );
	$room->devices->create({ type => "Lonely Device", user_id => $lonely_example_user->id });

	$self->return_success($c, {});

}

__PACKAGE__->meta->make_immutable;

1;
