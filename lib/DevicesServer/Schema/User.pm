package DevicesServer::Schema::User;
 
use base qw/DBIx::Class/;
__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('user');
__PACKAGE__->add_columns(qw/user_id fullname password email/);
__PACKAGE__->set_primary_key('user_id');
 
__PACKAGE__->has_many   (devices => 'DevicesServer::Schema::Device',{ 'foreign.user_id' => 'self.user_id' }, { cascade_delete => 1, cache => 0 });
1;