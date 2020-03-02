package DevicesServer::Schema::Location;
 
use base qw/DBIx::Class/;
__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('location');
__PACKAGE__->add_columns(qw/location_id street city postcode name/);
__PACKAGE__->set_primary_key('location_id');

__PACKAGE__->has_many   (rooms => 'DevicesServer::Schema::Room',{ 'foreign.location_id' => 'self.location_id' }, { cascade_delete => 1, cache => 0 });

1;