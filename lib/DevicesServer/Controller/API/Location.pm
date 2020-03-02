package DevicesServer::Controller::API::Location;
use Moose;
use namespace::autoclean;

use strict;
use warnings;
use base 'Catalyst::Controller::REST';

BEGIN { extends 'Catalyst::Controller'; }
BEGIN { extends 'DevicesServer::Controller::APIHelper'; }


sub base : Chained('../base_login') PathPart('location') CaptureArgs(0) {
	my ($self, $c) = @_;

	my $user = $c->stash->{user};

	$c->stash->{locations_base_query} = $user->devices->search(
		{},
		{
			join => { 'room' => 'location' },
		}
	);
}

sub baseid : Chained('base') PathPart('') CaptureArgs(1) {
	my ($self, $c, $locationid) = @_;

	my $location_id = $c->stash->{locations_base_query}->search(
		{ 'location.location_id' => $locationid }
		,
		{ 
			+select => ['location.location_id'],
			+as => ['location_id'] 
		})->first();
	my $location = $c->model('DB::Location')->find($location_id ? $location_id->get_column('location_id') : 0);
	unless($location) {
		$self->detach_not_found( $c );
	}

	$c->stash->{location} = $location;
}


sub locations_list : Chained('base') PathPart('') Args(0) ActionClass('REST') {
	my ( $self, $c ) = @_;
}

sub locations_list_GET {
	my ($self, $c) = @_;

	my $locations_rs = $c->stash->{locations_base_query}->search(
		{},
		{
			select => [\['DISTINCT(location.location_id)'],'location.location_id','location.name','me.user_id'],
			as => ['distinct_id','locationid','location_name','userid'],
		}
	);

	$self->return_success(
		$c,
		[ 
			map { 
					{ 
						locationid => $_->get_column('locationid'),
						location_name => $_->get_column('location_name'),
					} 
				} 
			$locations_rs->all() 
		]
	);
}


__PACKAGE__->meta->make_immutable;
1;