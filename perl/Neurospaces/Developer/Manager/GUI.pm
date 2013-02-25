package Neurospaces::Developer::Manager::GUI;


use strict;


use Glib qw/TRUE FALSE/;

use Gtk2 '-init';
use Gtk2::Helper;
use Gtk2::SimpleList;


our $gtk2_package_list;
our $gtk2_tb_package_information;
our $tooltips = Gtk2::Tooltips->new();

our $window_main;


sub create
{
    my $packages_tags = shift;

    my $assigned_role = $Neurospaces::Developer::Manager::assigned_role;

    my $window = Gtk2::Window->new('toplevel');

    $window_main = $window;

    $window->set_title("Neurospaces Developer Management Console");

    $window->set_default_size(1000, 550);

    # When the window is given the "delete_event" signal (this is given
    # by the window manager, usually by the "close" option, or on the
    # titlebar), we ask it to call the delete_event () functio
    # as defined above. No data is passed to the callback function.
    $window->signal_connect
	(
	 delete_event =>
	 sub
	 {
	     $window->destroy();

	     Gtk2->main_quit();
	 },
	);

#     # Here we connect the "destroy" event to a signal handler.
#     # This event occurs when we call Gtk2::Widget::destroy on the window,
#     # or if we return FALSE in the "delete_event" callback. Perl supports
#     # anonymous subs, so we can use one of them for one line callbacks.
#     $window->signal_connect(destroy => sub { Gtk2->main_quit(); });

    # Sets the border width of the window.
    $window->set_border_width(10);

    my $vbox = Gtk2::VBox->new();

    $window->add($vbox);

    my $menubar = new Gtk2::MenuBar();
    $vbox->pack_start($menubar, 0,0,2 );
    $menubar->show();

    my $file_menu = new Gtk2::Menu();
    $file_menu->set_tearoff_state(0);

    my $help_menu = new Gtk2::Menu();
    $help_menu->set_tearoff_state(0);


    # Create the file menu
    my $file_menu_new = new Gtk2::MenuItem( "Create a _New Package" );
    my $file_menu_quit = new Gtk2::MenuItem( "_Quit" );

    # Add them to the menu
    $file_menu->append( $file_menu_new );
    $file_menu->append( $file_menu_quit );

    # Attach the callback functions to the activate signal
    $file_menu_new->signal_connect( 'activate', \&show_dialog_new_package );
    $file_menu_quit->signal_connect( 'activate', sub { Gtk2->main_quit(); } );

    # We do not need the show the menu, but we do need to show the menu items
    $file_menu_new->show();
    $file_menu_quit->show();

    my $file_item = new Gtk2::MenuItem( "_File" );
    $file_item->show();
    $file_item->set_submenu( $file_menu );

    $menubar->append( $file_item );

    # Create the help menu
    my $help_menu_help = new Gtk2::MenuItem( "H_elp" );
    my $help_menu_about = new Gtk2::MenuItem( "_About" );

    # add help items to the menu
    $help_menu->append( $help_menu_help );
    $help_menu->append( $help_menu_about );

    #attach the callback of the menu
    $help_menu_help->signal_connect
	(
	 'activate',
	 sub
	 {
	     &show_dialog('See http://www.genesis-sim.org/', 'help');
	 },
	);
    $help_menu_about->signal_connect
	(
	 'activate',
	 sub
	 {
	     &show_dialog
		 ("
The neurospaces-manager-gui manages your local Neurospaces configuration.

Written in perl/Gtk
(C) Hugo Cornelis, 2012--2013",
 'about',
		 );
	 }
	);

    # show the items
    $help_menu_help->show();
    $help_menu_about->show();

    my $help_item = new Gtk2::MenuItem( "_Help" );
    $help_item->show();
    $help_item->set_submenu( $help_menu );

    $menubar->append( $help_item );

    my $hbox = Gtk2::HBox->new();

    $vbox->add($hbox);

    # left: tag check boxes

    my $tooltip_tags = "These are tags found on your local system";

    my $vframe_tags = Gtk2::Frame->new("Locally Available Package Tags");

    #t this seems to be doing nothing

    $vframe_tags->set_shadow_type('none');

#     {
# 	no strict "refs";

# 	use Data::Dumper;

# 	print Dumper(\%{'::Gtk2::ShadowType::'});
#     }

    $tooltips->set_tip($vframe_tags, $tooltip_tags);

    $hbox->pack_start($vframe_tags, 0, 1, 0);

    my $vbox_tags = Gtk2::VBox->new(0, 6);

    $vframe_tags->add($vbox_tags);

    my $label_tags = Gtk2::Label->new("Locally Available Package Tags");

    $tooltips->set_tip($label_tags, $tooltip_tags);

#     $vbox_tags->pack_start($label_tags, 0, 1, 0);

    my $tags_all_button = Gtk2::Button->new("Select all");

    $tags_all_button->signal_connect
	(
	 clicked =>
	 sub
	 {
	     my $self = shift;

	     my $operation = shift;

	     foreach my $tag_name (sort keys %$packages_tags)
	     {
		 my $tag = $packages_tags->{$tag_name};

		 my $checkbox = $tag->{checkbox};

		 $checkbox->set_active(1);
	     }
	 },
	 'all',
	);

    my $tooltip_tags_all = "select all tags";

    $tooltips->set_tip($tags_all_button, $tooltip_tags_all);

    $vbox_tags->pack_start($tags_all_button, 0, 1, 0);

    my $tags_none_button = Gtk2::Button->new("Unselect all");

    $tags_none_button->signal_connect
	(
	 clicked =>
	 sub
	 {
	     my $self = shift;

	     my $operation = shift;

	     foreach my $tag_name (sort keys %$packages_tags)
	     {
		 my $tag = $packages_tags->{$tag_name};

		 my $checkbox = $tag->{checkbox};

		 $checkbox->set_active(0);
	     }
	 },
	 'none',
	);

    my $tooltip_tags_none = "unselect all packages";

    $tooltips->set_tip($tags_none_button, $tooltip_tags_none);

    $vbox_tags->pack_start($tags_none_button, 0, 1, 0);

    foreach my $tag (sort keys %$packages_tags)
    {
	my $checkbox = Gtk2::CheckButton->new($tag);

# 	$checkbox->signal_connect
# 	    (
# 	     clicked =>
# 	     sub
# 	     {
# 		 my $self = shift;

# 		 print "relisting repos\n";
# 	     },
# 	     $checkbox,
# 	    );

	$checkbox->set_active(1);

	$checkbox->signal_connect
	    (
	     toggled =>
	     sub
	     {
		 my $self = shift;

		 my $active_tags = [];

		 foreach my $package_tag (keys %$packages_tags)
		 {
		     if ($packages_tags->{$package_tag}->{checkbox}->get_active())
		     {
			 push @$active_tags, $package_tag;
		     }
		 }

		 package_list_update($active_tags);
	     },
	     $checkbox,
	    );

	$packages_tags->{$tag}->{checkbox} = $checkbox;

	my $tooltip = "include all packages with tag $tag";

	$tooltips->set_tip($checkbox, $tooltip);

	$vbox_tags->pack_start($checkbox, 0, 1, 0);
    }

    # aside the tag checkboxes: available packages

    my $tooltip_packages = "these are the packages found on your system
satisfying one or more of the selected tags";

    my $vframe_packages = Gtk2::Frame->new("Locally Available Packages");

    $tooltips->set_tip($vframe_packages, $tooltip_packages);

    $hbox->pack_start($vframe_packages, 1, 1, 0);

    my $vbox_packages = Gtk2::VBox->new(0, 6);

    $vframe_packages->add($vbox_packages);

    my $label_packages = Gtk2::Label->new("Locally Available Packages");

#     $tooltips->set_tip($label_packages, $tooltip_packages);

#     $vbox_packages->pack_start($label_packages, 0, 1, 0);

    my $packages_all_button = Gtk2::Button->new("Select all");

    $packages_all_button->signal_connect
	(
	 clicked =>
	 sub
	 {
	     my $self = shift;

	     my $operation = shift;

	     my $selection = $gtk2_package_list->get_selection();

	     $selection->select_all();
	 },
	 'all',
	);

    my $tooltip_packages_all = "select all packages";

    $tooltips->set_tip($packages_all_button, $tooltip_packages_all);

    $vbox_packages->pack_start($packages_all_button, 0, 1, 0);

    my $packages_none_button = Gtk2::Button->new("Unselect all");

    $packages_none_button->signal_connect
	(
	 clicked =>
	 sub
	 {
	     my $self = shift;

	     my $operation = shift;

	     my $selection = $gtk2_package_list->get_selection();

	     $selection->unselect_all();
	 },
	 'none',
	);

    my $tooltip_packages_none = "unselect all packages";

    $tooltips->set_tip($packages_none_button, $tooltip_packages_none);

    $vbox_packages->pack_start($packages_none_button, 0, 1, 0);

    my $scroller_package_list = Gtk2::ScrolledWindow->new();

    $scroller_package_list->set_size_request(250, 100);

    $scroller_package_list->set_policy(qw/automatic automatic/);

    $vbox_packages->pack_start($scroller_package_list, 1, 1, 0);

    my $list
	= Gtk2::SimpleList->new
	    (
	     'Name' => 'text',
	    );

    $gtk2_package_list = $list;

    $list->get_selection()->set_mode('extended');

    $scroller_package_list->add($list);

    $list->signal_connect
	(
	 row_activated => sub { package_list_row_activated(@_); },
	);

    $list->signal_connect
	(
	 cursor_changed => sub { package_list_cursor_changed(@_); },
	);

    # right from the available packages: package information

    my $vbox_package_information = Gtk2::VBox->new(0, 6);

    $hbox->pack_start($vbox_package_information, 0, 1, 0);

    my $package_information_label = Gtk2::Label->new("Package Information");

    my $tooltip_label = "information of a single selected package";

    $tooltips->set_tip($package_information_label, $tooltip_label);

    $vbox_package_information->pack_start($package_information_label, 0, 1, 0);

    my $scroller_package_information = Gtk2::ScrolledWindow->new();

    $scroller_package_information->set_size_request(550, 500);

    $scroller_package_information->set_policy (qw/automatic automatic/);

    $vbox_package_information->pack_start($scroller_package_information, 0, 1, 0);

    my $tb_package_information = Gtk2::TextBuffer->new();

    $gtk2_tb_package_information = $tb_package_information;

    my $tv_package_information = Gtk2::TextView->new();

    $tv_package_information->set_editable(FALSE);

    $tv_package_information->set_buffer($tb_package_information);

    $scroller_package_information->add($tv_package_information);

    # right from the package information: command buttons

    my $vbox_operations = Gtk2::VBox->new(0, 6);

    $hbox->pack_start($vbox_operations, 0, 1, 0);

    my $operations_label = Gtk2::Label->new("Package Operations");

    my $tooltip = "run operations on selected packages";

    $tooltips->set_tip($operations_label, $tooltip);

    $vbox_operations->pack_start($operations_label, 0, 1, 0);

    my $clicked_content =
	sub
	{
	    my $self = shift;

	    my $operation_name = shift;

	    $operation_name =~ /(.*)_(.*)/;

	    $operation_name = $2;

	    my $selection = $gtk2_package_list->get_selection();

	    my $rows = [ $selection->get_selected_rows(), ];

	    my $indices = [ map { $_->get_indices(), } @$rows, ];

	    my $packages = [ map { $gtk2_package_list->{data}->[$_]->[0], } @$indices, ];

	    foreach my $package_name (@$packages)
	    {
		my $path = "/usr/local/bin";

		my $command = $path . "/$package_name-$operation_name";

		if (-x $command)
		{
		    print "$command\n";

		    system "$command";

		    # 		 my $output = `$command >/tmp/output 2>&1 &`;

		    if ($@)
		    {
			print STDERR "$0: *** Error: $@\n";

			print STDOUT "$0: *** Error: $@\n";
		    }
		    else
		    {
			print STDOUT "$0: *** Ok\n";
		    }
		}
		else
		{
		    print STDERR "$0: *** Warning: $command not found or not executable\n";
		}
	    }
	};

    my $clicked_default =
	sub
	{
	    my $self = shift;

	    my $operation_name = shift;

	    my $selection = $gtk2_package_list->get_selection();

	    my $rows = [ $selection->get_selected_rows(), ];

	    my $indices = [ map { $_->get_indices(), } @$rows, ];

	    my $packages = [ map { $gtk2_package_list->{data}->[$_]->[0], } @$indices, ];

	    # 		 use Data::Dumper;

	    # 		 print Dumper($packages);

	    my $command = "neurospaces_$operation_name " . (join ' ', @$packages) . "\n";

	    print "$command\n";

	    system "$command";

	    # 		 my $output = `$command >/tmp/output 2>&1 &`;

	    if ($@)
	    {
		print STDERR "$0: *** Error: $@\n";

		print STDOUT "$0: *** Error: $@\n";
	    }
	    else
	    {
		print STDOUT "$0: *** Ok\n";
	    }
	};

    foreach my $operation (@$Neurospaces::Developer::Manager::operations)
    {
	if (not $operation->{targets}->{$assigned_role})
	{
	    next;
	}

	my $operation_name = $operation->{name};

	my $button = Gtk2::Button->new($operation_name);

	my $clicked = $operation->{clicked} || $clicked_default;

	if ($clicked eq 'content')
	{
	    $clicked = $clicked_content;
	}

	$button->signal_connect
	    (
	     clicked => $clicked,
 	     $operation_name,
	    );

	my $tooltip = "run operation neurospaces_$operation_name";

	$tooltips->set_tip($button, $tooltip);

	$vbox_operations->pack_start($button, 0, 1, 0);
    }

    # global initialization

    $tooltips->enable();

    $window->show_all();

    my $active_tags = [];

    foreach my $package_tag (keys %$packages_tags)
    {
	if ($packages_tags->{$package_tag}->{checkbox}->get_active())
	{
	    push @$active_tags, $package_tag;
	}
    }

    package_list_update($active_tags);

#     system "touch /tmp/output && tail -f /tmp/output &";

    Gtk2->main();
}


sub package_list_cursor_changed
{
    my ($widget) = @_;

#     my $cursor = $widget->get_cursor();

    my ($path, $focus_column) = $widget->get_cursor();

    if ($path)
    {
	my $indices = [ $path->get_indices(), ];

	my $package_names = [ map { $gtk2_package_list->{data}->[$_]->[0], } @$indices, ];

	my $package_name = $package_names->[0];

	my $contents = "Selected package information: $package_name\n";

	my $repository = `neurospaces_repositories '$package_name'`;

	my $status = `neurospaces_status '$package_name'`;

	$contents .= join "\n", $repository, $status;

	$gtk2_tb_package_information->set_text($contents);
    }
}


sub package_list_row_activated
{
    my ($widget, $path, $column) = @_;

    my $row_ref = $widget->get_row_data_from_path($path);

    my $package_name = $row_ref->[0];

    window_package_create($package_name);
}


sub package_list_update
{
    my $active_tags = shift;

    my $active_packages = Neurospaces::Developer::packages_by_tags($active_tags);

    # note: working with references would be disconnecting the gtk2
    # internal list from its perl equivalent.  we must use direct
    # access here.

    @{$gtk2_package_list->{data}} = ();

    foreach my $active_package (@$active_packages)
    {
	push
	    @{$gtk2_package_list->{data}},
		[
		 $active_package->{package},
		];
    }
}


sub show_dialog
{
    my ($message, $title) = @_;

    my $dialog = Gtk2::MessageDialog->new($window_main, 'destroy-with-parent', 'info', 'ok', $message);

    $dialog->set_title($title);

    $dialog->run;

    $dialog->destroy;
}


sub show_dialog_new_package
{
    my $dlg_package = Gtk2::Dialog->new("Create a Neurospaces Package", $window_main, 'destroy-with-parent','gtk-ok' => 'ok', 'gtk-cancel' => 'cancel');

    my $lbl_name = Gtk2::Label->new("Package Name: ");

    $lbl_name->show();

    my $tb_name = Gtk2::Entry->new();

    $tb_name->show();


    my $lbl_server = Gtk2::Label->new("Package Server: ");

    $lbl_server->show();

    my $tb_server = Gtk2::Entry->new();

    $tb_server->show();


    my $lbl_port = Gtk2::Label->new(" : ");

    $lbl_port->show();

    my $tb_port = Gtk2::Entry->new();

    $tb_port->show();

    my $hbox_server = Gtk2::HBox->new();

    $hbox_server->pack_start($tb_server, 0, 1, 0);

    $hbox_server->pack_start($lbl_port, 0, 1, 0);

    $hbox_server->pack_start($tb_port, 0, 1, 0);

    $hbox_server->show();


    my $ck_server = Gtk2::CheckButton->new_with_label("Is this PC the Main Repository Server?");

    $ck_server->show();

    $ck_server->set_active(0);

    my $ck_heterarch = Gtk2::CheckButton->new_with_label("Is a Heterarch Package?");

    $ck_heterarch->show();

    $ck_heterarch->set_active(1);


    my $tbl_name = Gtk2::Table->new(4, 2, 1);

    $tbl_name->show();

    $dlg_package->vbox->add($tbl_name);

    $tbl_name->attach_defaults($lbl_name, 0,1,0,1);
    $tbl_name->attach_defaults($tb_name, 1,2,0,1);

    $tbl_name->attach_defaults($lbl_server, 0,1,1,2);
    $tbl_name->attach_defaults($hbox_server, 1,2,1,2);

    $tbl_name->attach_defaults($ck_server, 1,2,2,3);
    $tbl_name->attach_defaults($ck_heterarch, 1,2,3,4);



    my $lbl_tag1 = Gtk2::Label->new("Package Tag 1: ");

    $lbl_tag1->show();

    my $tb_tag1 = Gtk2::Entry->new();

    $tb_tag1->show();

    my $lbl_tag2 = Gtk2::Label->new("Optional Package Tag 2: ");

    $lbl_tag2->show();

    my $tb_tag2 = Gtk2::Entry->new();

    $tb_tag2->show();

    my $lbl_tag3 = Gtk2::Label->new("Optional Package Tag 3: ");

    $lbl_tag3->show();

    my $tb_tag3 = Gtk2::Entry->new();

    $tb_tag3->show();

    my $tbl_tags = Gtk2::Table->new(3, 2, 1);

    $dlg_package->vbox->add($tbl_tags);

    $tbl_tags->show();

    $tbl_tags->attach_defaults($lbl_tag1, 0,1,0,1);
    $tbl_tags->attach_defaults($tb_tag1, 1,2,0,1);

    $tbl_tags->attach_defaults($lbl_tag2, 0,1,1,2);
    $tbl_tags->attach_defaults($tb_tag2, 1,2,1,2);

    $tbl_tags->attach_defaults($lbl_tag3, 0,1,2,3);
    $tbl_tags->attach_defaults($tb_tag3, 1,2,2,3);


    $dlg_package->signal_connect
	(
	 'response',
	 sub
	 {
	     # $data will be the third argument given to ->signal_connect()

	     my ($dlg, $response, $data) = @_;

	     if ($response eq 'ok')
	     {
		 my $error;

		 my $command = "neurospaces_new_component ";

		 my $package_name = $tb_name->get_text();

		 if (not $package_name)
		 {
		     if (not $error)
		     {
			 $error = "no package name given";
		     }
		 }
		 else
		 {
		     $command .= "--component-name '$package_name' ";
		 }

		 if ($ck_heterarch->get_active())
		 {
		     $command .= "--heterarch-set ";
		 }
		 else
		 {
		 }

		 if ($ck_server->get_active())
		 {
		     $command .= "--as-server ";
		 }
		 else
		 {
		 }

		 my $server = $tb_server->get_text();

		 if (not $server)
		 {
		     if (not $error)
		     {
			 $error = "no server name given";
		     }
		 }
		 else
		 {
		 }

		 my $port = $tb_port->get_text();

		 if (not $port)
		 {
		     if (not $error)
		     {
			 $error = "no server port given";
		     }
		 }
		 else
		 {
		     $command .= "--repository-server '$server:$port' ";
		 }

		 my $tag1 = $tb_tag1->get_text();

		 if (not $tag1)
		 {
		     if (not $error)
		     {
			 $error = "the first tag name must be defined";
		     }
		 }
		 else
		 {
		     $command .= "--package-tags '$tag1' ";
		 }

		 my $tag2 = $tb_tag2->get_text();

		 if (not $tag2)
		 {
		 }
		 else
		 {
		     $command .= "--package-tags '$tag2' ";
		 }

		 my $tag3 = $tb_tag3->get_text();

		 if (not $tag3)
		 {
		 }
		 else
		 {
		     $command .= "--package-tags '$tag3' ";
		 }

		 if ($error)
		 {
		     print "*** $0: *** Error: $error\n";
		 }
		 else
		 {
		     $command .= "--verbose ";

		     print "*** $0: executing: $command\n";

		     system "$command";

		     if ($?)
		     {
			 print "*** $0: *** Error: Could not create component, check terminal for error messages\n";
		     }
		     else
		     {
			 $dlg->destroy();
		     }
		 }
	     }
	     else
	     {
		 $dlg->destroy();
	     }
	 },
	 [],
	);

    $dlg_package->run();
#     $dlg_package->destroy();
}


# example of how to use the TreeView widget

sub show_dialog_tree
{
    my $dlg_tree = Gtk2::Dialog->new("Create a Neurospaces Package", $window_main, 'destroy-with-parent','gtk-ok' => 'ok');

    my $model = Gtk2::ListStore -> new('Glib::String', 'Glib::String','Glib::String', 'Glib::String');
    my $list = Gtk2::TreeView -> new_with_model($model);
    $dlg_tree->vbox->add($list);

    my $colDate = Gtk2::TreeViewColumn -> new_with_attributes('Datum',Gtk2::CellRendererText->new, text => 0);
    my $colDown = Gtk2::TreeViewColumn -> new_with_attributes('Download',Gtk2::CellRendererText->new, text => 1);
    my $colUp = Gtk2::TreeViewColumn -> new_with_attributes('Upload',Gtk2::CellRendererText->new, text => 2);
    my $colTotal = Gtk2::TreeViewColumn -> new_with_attributes('Totaal',Gtk2::CellRendererText->new, text => 3);

    $list->append_column($colDate);
    $list->append_column($colDown);
    $list->append_column($colUp);
    $list->append_column($colTotal);

    my $i = 0;

    my $composed_values
	= [
	   [ 2, 3, 4, 5, ],
	   [ 12, 13, 14, 15, ],
	  ];

    my $iter;

    foreach my $decomposed_value (@$composed_values)
    {
	$iter->[$i] = $model->insert($i);

	my $y = 0;

	foreach my $value (@$decomposed_value)
	{
	    $model->set_value($iter->[$i], $y, $value);

	    $y++;
	}

	$i++;
    }

    $list->show();
    $dlg_tree->run();
    $dlg_tree->destroy();
}


sub window_package_create
{
    my $package_name = shift;

    my $window = Gtk2::Window->new('toplevel');

    $window->set_title("Neurospaces Developer Management Console: package $package_name");

    $window->set_default_size(800, 550);

    # When the window is given the "delete_event" signal (this is given
    # by the window manager, usually by the "close" option, or on the
    # titlebar), we ask it to call the delete_event () functio
    # as defined above. No data is passed to the callback function.
    $window->signal_connect
	(
	 delete_event =>
	 sub
	 {
	     $window->destroy();
	 },
	);

    # Sets the border width of the window.
    $window->set_border_width(10);

    my $hbox = Gtk2::HBox->new();

    $window->add($hbox);

    # left: tag check boxes

    my $vbox_tags = Gtk2::VBox->new(0, 6);

    $hbox->pack_start($vbox_tags, 0, 1, 0);

    $window->show_all();
}


1;


