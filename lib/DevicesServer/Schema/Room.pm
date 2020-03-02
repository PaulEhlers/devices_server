package DevicesServer::Schema::Room;
 
use base qw/DBIx::Class/;
__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('room');
__PACKAGE__->add_columns(qw/room_id name location_id/);
__PACKAGE__->set_primary_key('room_id');

__PACKAGE__->has_many   (devices => 'DevicesServer::Schema::Device',{ 'foreign.room_id' => 'self.room_id' }, { cascade_delete => 1, cache => 0 });
__PACKAGE__->belongs_to     (location => 'DevicesServer::Schema::Location',{ 'foreign.location_id' => 'self.location_id' }, { cascade_delete => 0, cache => 1 });

1;