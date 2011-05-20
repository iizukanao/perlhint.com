package PerlHint::Controller::Pattern;
use Ark 'Controller';

with 'Ark::ActionClass::Form';

# ヒントパターン一覧表示
sub index :Path {
    my ($self, $c) = @_;

    $c->stash->{flash} = $c->session->get('flash');
    $c->session->remove('flash');

    my $patterns = $c->model('Schema::Pattern')->get_all_patterns;
    $c->{stash}->{patterns} = $patterns;
    $c->{stash}->{num_patterns} = scalar keys %$patterns;
}

# display form for a new pattern
sub add_new :Local :Form('PerlHint::Form::Pattern') {
    my ($self, $c) = @_;

    $c->stash->{form} = $self->form;
    $c->view('MT')->template('pattern/add_new');
}

# add new pattern
sub create :Local :Form('PerlHint::Form::Pattern') {
    my ($self, $c) = @_;

    # accept POST only
    $c->redirect_and_detach('/pattern/add_new') if $c->req->method ne 'POST';

    unless ( $self->form->submitted_and_valid ) {
        $c->forward('add_new');
        $c->detach;
    }

    my $name = $c->req->param('name');
    my $pattern     = $c->req->param('pattern');
    my $description = $c->req->param('description');

    my $row = $c->model('Schema::Pattern')->create({
        name        => $name,
        pattern     => $pattern,
        description => $description,
    });

    $c->log->info($c->req->address." created pattern ".$row->id.": name=$name pattern=$pattern description=$description");
    $c->session->set( flash => "$name を作成しました" );
    $c->redirect_and_detach('/pattern/show/'.$row->id);
}

sub show :Local :Args(1) {
    my ($self, $c, $id) = @_;

    $c->stash->{flash} = $c->session->get('flash');
    $c->session->remove('flash');

    my $pattern = $c->model('Schema::Pattern')->find({
        id => $id
    });
    $c->forward_404 unless $pattern;
    $c->stash->{pattern} = $pattern;
}

sub edit :Local :Args(1) {
    my ($self, $c, $id) = @_;

    my $pattern = $c->model('Schema::Pattern')->find({
        id => $id
    });
    $c->forward_404 unless $pattern;
    $c->stash->{pattern} = $pattern;
}

# update pattern
sub post :Local :Args(1) {
    my ($self, $c, $id) = @_;

    # accept POST only
    $c->forward_404 if $c->req->method ne 'POST';

    my $name        = $c->req->param('name');
    my $pattern     = $c->req->param('pattern');
    my $description = $c->req->param('description');

    # start transaction
    my $txn = $c->model('Schema')->txn_scope_guard;

    my $row = $c->model('Schema::Pattern')->find_or_create({
        id => $id
    });
    $row->update({
        name        => $name,
        pattern     => $pattern,
        description => $description,
    });

    $txn->commit;

    $c->log->info($c->req->address." updated pattern $id: name=$name pattern=$pattern description=$description");
    $c->session->set( flash => "$name を更新しました" );
    $c->redirect_and_detach('/pattern/show/'.$id);
}

sub delete :Local :Args(1) {
    my ($self, $c, $id) = @_;

    my $row = $c->model('Schema::Pattern')->find({
        id => $id
    });
    $row->delete;

    $c->log->info($c->req->address." deleted pattern $id: name=".$row->name." pattern=".$row->pattern." description=".$row->description);
    $c->session->set( flash => $row->name.' を削除しました' );
    $c->redirect_and_detach('/pattern/');
}

__PACKAGE__->meta->make_immutable;
