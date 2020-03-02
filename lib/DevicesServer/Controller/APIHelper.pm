use utf8;
package DevicesServer::Controller::APIHelper;

use Moose;
use JSON;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::REST'; }

use 5.20.1;
use feature 'postderef', 'signatures';
no warnings "experimental::postderef", "experimental::signatures";

sub return_json($self, $c, %params) {
    $c->response->status($params{http_status} || 500);
    my $entity = {
        success     => $params{success} ? JSON::true : JSON::false,
    };
    $entity->{data} = $params{data} if exists $params{data};
    $entity->{message} = $params{message} if exists $params{message};
    $entity->{pager} = {
            current_page => $params{pager}->current_page+0,
            total_entries => $params{pager}->total_entries+0,
            entries_per_page => $params{pager}->entries_per_page+0,
        } if exists $params{pager};
    $self->_set_entity( $c, $entity );
}

sub return_success($self, $c, $data, $pager=undef) {
    $self->return_json(
        $c,
        http_status => 200,
        success     => JSON::true,
        data => $data,
        $pager ? (pager => $pager) : (),
    );
}

sub detach_not_found($self, $c) {
    $self->return_json(
        $c,
        http_status => 404,
        success     => JSON::false,
        message     => "the resource could not be found",
    );
    $c->detach();
}

sub detach_permission_denied($self, $c, $message=undef) {
    $self->return_json(
        $c,
        http_status => 403,
        success     => JSON::false,
        message     => $message || "you do not have permission to access this resource",
    );
    $c->detach();
}

sub detach_bad_request($self, $c, $message=undef) {
    $self->return_json(
        $c,
        http_status => 400,
        success     => JSON::false,
        message     => $message || "some request parameters were invalid",
    );
    $c->detach();
}

sub server_error($self, $c, $message='internal server error') {
    $self->return_json(
        $c,
        success     => JSON::false,
        http_status => 500,
        message     => $message,
    );
    $c->detach();
}

sub end : ActionClass('Serialize') {
    my ( $self, $c ) = @_;

    # Print custom error page for the user and errors to the log
    if ( scalar @{ $c->error } ) {
        my @error = @{ $c->error };
        $c->log->error(join("\n",@error));
        $c->error(0);
        $self->server_error($c);
    }
}

1;
