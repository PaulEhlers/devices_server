package DevicesServer::Schema::Company;
 
use base qw/DBIx::Class/;
__PACKAGE__->load_components(qw/Core/);
__PACKAGE__->table('company');
__PACKAGE__->add_columns(qw/company_id name/);
__PACKAGE__->set_primary_key('company_id');
 
__PACKAGE__->has_many   (users => 'DevicesServer::Schema::User',{ 'foreign.company_id' => 'self.company_id' }, { cascade_delete => 1, cache => 0 });
1;