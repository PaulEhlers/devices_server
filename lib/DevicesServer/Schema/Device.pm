package DevicesServer::Schema::Device;
 
use base qw/DBIx::Class/;
__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('device');
__PACKAGE__->add_columns(qw/device_id type setup_date user_id room_id/);
__PACKAGE__->set_primary_key('device_id');

__PACKAGE__->belongs_to     (room => 'DevicesServer::Schema::Room',{ 'foreign.room_id' => 'self.room_id' }, { cascade_delete => 0, cache => 1 });

1;