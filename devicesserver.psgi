use strict;
use warnings;

use DevicesServer;

my $app = DevicesServer->apply_default_middlewares(DevicesServer->psgi_app);
$app;

