package DevicesServer::Controller::API::Device;
use Moose;
use namespace::autoclean;

use strict;
use warnings;
use base 'Catalyst::Controller::REST';

BEGIN { extends 'Catalyst::Controller'; }
BEGIN { extends 'DevicesServer::Controller::APIHelper'; }


sub base : Chained('../base_login') PathPart('device') CaptureArgs(0) {
	my ($self, $c) = @_;
}

sub baseid : Chained('base') PathPart('') CaptureArgs(1) {
	my ($self, $c, $deviceid) = @_;

	my $user = $c->stash->{user};

	my $device = $user->devices->find($deviceid);
	unless($device) {
		$self->detach_not_found( $c );
	}

	$c->stash->{device} = $device;
}

sub single_device : Chained('baseid') PathPart('') Args(0) ActionClass('REST') {
	my ( $self, $c ) = @_;
}

sub single_device_PUT {
	my ( $self, $c ) = @_;

	my $device = $c->stash->{device};

	if($c->req->params->{type}) {
		$device->update({ type => $c->req->params->{type} });
	}

	$self->return_success(
		$c,
		{}
	);
}

sub single_device_DELETE {
	my ( $self, $c ) = @_;

	my $device = $c->stash->{device};

	$device->delete();

	$self->return_success(
		$c,
		{}
	);
}

sub devices_list : Chained('base') PathPart('') Args(0) ActionClass('REST') {
	my ( $self, $c ) = @_;
}

sub devices_list_GET {
	my ($self, $c) = @_;

	my $user = $c->stash->{user};

	my $devices_rs = $user->devices->search(
		{},
		{
			select => ['me.type','me.device_id','me.setup_date','room.name','location.name'],
			as => ['type','device_id','setup_date','room_name','location_name'],
			join => { 'room' => 'location' },
		}
	);

	if($c->req->params->{roomid}) {
		$devices_rs = $devices_rs->search({ 'room.room_id' => $c->req->params->{roomid} });
	}

	if($c->req->params->{locationid}) {
		$devices_rs = $devices_rs->search({ 'location.location_id' => $c->req->params->{locationid} });
	}

	my @devices = map { { 
		type => $_->get_column('type'), 
		id => $_->get_column('device_id'), 
		setup_date => $_->get_column('setup_date'),
		location_name => $_->get_column('location_name'),
		room_namer => $_->get_column('room_name'),
		 } } $devices_rs->all();

	$self->return_success(
		$c,
		\@devices
	);
}


__PACKAGE__->meta->make_immutable;
1;