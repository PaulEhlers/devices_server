#!/usr/bin/env perl
use FindBin;
use lib "$FindBin::Bin/../lib";

use utf8;
use strict;
use warnings;
use Module::Load;
use File::Slurp;

use 5.20.1;
use feature 'postderef', 'signatures', 'switch';
no warnings "experimental::postderef", "experimental::signatures", "experimental::smartmatch";

# load the model and Schema classes
load 'Catalyst::Test', 'DevicesServer';
my($res, $c) = ctx_request('/');      # HTTP::Response & context object
my $schema = $c->model('DB');


# Drop all tables
foreach my $table (qw/company device user room location/) {
	_sql_do($c, "DROP TABLE IF EXISTS ".$table);
}

my $database_sql = read_file("./db.sql");
my @sql_commands = split /;/, $database_sql;

_sql_do($c, $_) foreach @sql_commands;

my $company = $c->model('DB::Company')->find_or_create({
	name => "Test Company",
});

my $example_user = $c->model('DB::User')->find_or_create( {
		password => "test",
	    fullname    => "test",
	    email => 'test@test.de',
	    company_id => $company->id,
	}
);

my $other_example_user = $c->model('DB::User')->find_or_create( {
		password => "test",
	    fullname    => "test",
	    email => 'test2@test.de',
	    company_id => $company->id,
	}
);

my $lonely_example_user = $c->model('DB::User')->find_or_create( {
		password => "test",
	    fullname    => "test",
	    email => 'test3@test.de',
	    company_id => $company->id,
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

sub _sql_do {
  my ( $c, $sql ) = @_ ;
  return $c->model('DB')->storage->dbh_do(
    sub {
      my ( $storage , $dbh , $sql ) = @_ ;
      my $sth = $dbh->prepare( $sql ) ;
      $sth->execute() ;
    },
    $sql
  );
}