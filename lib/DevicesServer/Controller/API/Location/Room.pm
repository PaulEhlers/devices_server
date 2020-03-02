package DevicesServer::Controller::API::Location::Room;
use Moose;
use namespace::autoclean;

use strict;
use warnings;
use base 'Catalyst::Controller::REST';

BEGIN { extends 'Catalyst::Controller'; }
BEGIN { extends 'DevicesServer::Controller::APIHelper'; }


sub base : Chained('../baseid') PathPart('room') CaptureArgs(0) {
	my ($self, $c) = @_;

	my $location = $c->stash->{location};

	$c->stash->{rooms_base_query} = $location->rooms;
}


sub rooms_list : Chained('base') PathPart('') Args(0) ActionClass('REST') {
	my ( $self, $c ) = @_;
}

sub rooms_list_GET {
	my ($self, $c) = @_;

	my $rooms_rs = $c->stash->{rooms_base_query};

	$self->return_success(
		$c,
		[ 
			map { 
					{ 
						roomid => $_->room_id,
						name => $_->name,
					} 
				} 
			$rooms_rs->all() 
		]
	);
}


__PACKAGE__->meta->make_immutable;
1;