package DevicesServer::Schema;
use base qw/DBIx::Class::Schema/;
 
__PACKAGE__->load_classes(qw/User Device Location Room/);
 
1;