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


my $remote_server = 'localhost';

my $remote_login;

my $packages_tags;


sub create
{
    $packages_tags = Neurospaces::Developer::Packages::package_tags();

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

    # sets the border width of the window.

    $window->set_border_width(10);

    my $vbox = Gtk2::VBox->new();

    $window->add($vbox);

    my $menubar = new Gtk2::MenuBar();

    $vbox->pack_start($menubar, 0,0,2 );

    $menubar->show();

    my $management_menu = new Gtk2::Menu();

    $management_menu->set_tearoff_state(0);

    my $help_menu = new Gtk2::Menu();

    $help_menu->set_tearoff_state(0);

    # create the management menu items

    my $management_menu_remote = new Gtk2::MenuItem( "Connect to a _Remote Neurospaces Server" );

    my $management_menu_new = new Gtk2::MenuItem( "Configure a _New or Foreign Package" );

    my $management_menu_quit = new Gtk2::MenuItem( "_Quit" );

    # add them to the management menu

    $management_menu->append( $management_menu_remote );

    $management_menu->append( $management_menu_new );

    $management_menu->append( $management_menu_quit );

    # attach the callback functions to the activate signal

    $management_menu_remote->signal_connect( 'activate', \&remote_dialog_show );

    $management_menu_new->signal_connect( 'activate', \&package_dialog_show );

    $management_menu_quit->signal_connect( 'activate', sub { Gtk2->main_quit(); } );

    # we do not need the show the menu, but we do need to show the menu items

    $management_menu_new->show();

    $management_menu_quit->show();

    my $management_item = new Gtk2::MenuItem( "_Management" );

    $management_item->show();

    $management_item->set_submenu( $management_menu );

    $menubar->append( $management_item );

    # create the help menu

    my $help_menu_help = new Gtk2::MenuItem( "H_elp" );

    my $help_menu_about = new Gtk2::MenuItem( "_About" );

    # add help items to the menu

    $help_menu->append( $help_menu_help );

    $help_menu->append( $help_menu_about );

    # attach the callback of the menu

    $help_menu_help->signal_connect
	(
	 'activate',
	 sub
	 {
	     &show_dialog('Help', 'See http://www.genesis-sim.org/');
	 },
	);

    $help_menu_about->signal_connect
	(
	 'activate',
	 sub
	 {
	     &show_dialog
		 (
		  'About',
		  "
The neurospaces-manager-gui manages your local Neurospaces configuration.

Written in perl/Gtk
(C) Hugo Cornelis, 2012 -- 2013",
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

    my $tooltip_tags_none = "unselect all tags";

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

    my $package_information_label = Gtk2::Label->new("Local Package Information and Status");

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

	    my $server_prefix = "";

	    if ($remote_server ne 'localhost')
	    {
		$server_prefix = "ssh " . $remote_login . '@' . $remote_server . ' ';
	    }

	    my $command = $server_prefix . "neurospaces_$operation_name " . (join ' ', @$packages) . "\n";

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


sub package_dialog_show
{
    my $menu_item = shift;

    my $package_name = shift;

    my $package;

    if (defined $package_name)
    {
	my $active_packages = Neurospaces::Developer::Packages::packages_all();

	$package = $active_packages->{$package_name};
    }

    my $dlg_package = Gtk2::Dialog->new("Configure a New or Foreign Package", $window_main, 'destroy-with-parent','gtk-ok' => 'ok', 'gtk-cancel' => 'cancel');

    my $lbl_name = Gtk2::Label->new("Package Name: ");

    $lbl_name->show();

    my $tb_name = Gtk2::Entry->new();

    $tb_name->show();

    if (defined $package_name)
    {
	$tb_name->set_text($package_name . " (package name is read only)");

	$tb_name->set_editable(0);
    }

    my $lbl_server = Gtk2::Label->new("Package Server: ");

    $lbl_server->show();

    my $tb_server = Gtk2::Entry->new();

    $tb_server->show();

    if (defined $package_name)
    {
# 	my $server = Neurospaces::Developer::Operations::version_control_translate_server( { package => $package }, '');

	my $server = $package->{version_control}->{server};

	$tb_server->set_text($server);
    }


    my $lbl_port = Gtk2::Label->new(" : ");

    $lbl_port->show();

    my $tb_port = Gtk2::Entry->new();

    $tb_port->show();

    if (defined $package_name)
    {
	my $port = $package->{version_control}->{port_number};

	$tb_port->set_text($port);

	$tb_port->set_editable(0);
    }


    my $hbox_server = Gtk2::HBox->new();

    $hbox_server->pack_start($tb_server, 0, 1, 0);

    $hbox_server->pack_start($lbl_port, 0, 1, 0);

    $hbox_server->pack_start($tb_port, 0, 1, 0);

    $hbox_server->show();


    my $ck_server = Gtk2::CheckButton->new_with_label("Is this PC the Main Repository Server?");

#     $ck_server->show();

#     $ck_server->set_editable(0);

    if (defined $package_name)
    {
	$ck_server->set_active(0);
    }
    else
    {
	$ck_server->set_active(0);
    }

    my $ck_developer = Gtk2::CheckButton->new_with_label("Are you a developer of this package?");

    $ck_developer->show();

    $ck_developer->set_active(0);

    if (defined $package_name)
    {
	$ck_developer->set_active(not $package->{read_only});
    }
    else
    {
	$ck_developer->set_active(0);
    }

    my $ck_heterarch = Gtk2::CheckButton->new_with_label("Is a Heterarch Package?");

    if (defined $package_name)
    {
# 	$ck_heterarch->show();

# 	$ck_heterarch->set_editable(0);
    }
    else
    {
	$ck_heterarch->show();

	$ck_heterarch->set_active(1);
    }

    my $ck_enabled = Gtk2::CheckButton->new_with_label("Should this package be enabled?");

    $ck_enabled->show();

    $ck_enabled->set_active(1);

    if (defined $package_name)
    {
	$ck_enabled->set_active(not $package->{disabled});
    }
    else
    {
	$ck_enabled->set_active(1);
    }

    my $tbl_name = Gtk2::Table->new(5, 2, 1);

    $tbl_name->show();

    $dlg_package->vbox->add($tbl_name);

    $tbl_name->attach_defaults($lbl_name, 0,1,0,1);
    $tbl_name->attach_defaults($tb_name, 1,2,0,1);

    $tbl_name->attach_defaults($lbl_server, 0,1,1,2);
    $tbl_name->attach_defaults($hbox_server, 1,2,1,2);

    $tbl_name->attach_defaults($ck_server, 1,2,2,3);
    $tbl_name->attach_defaults($ck_developer, 1,2,3,4);
    $tbl_name->attach_defaults($ck_heterarch, 1,2,4,5);
    $tbl_name->attach_defaults($ck_enabled, 1,2,5,6);



    my $lbl_tag1 = Gtk2::Label->new("Package Tag 1: ");

    $lbl_tag1->show();

    my $tb_tag1 = Gtk2::Entry->new();

    $tb_tag1->show();

    if (defined $package_name)
    {
	$tb_tag1->set_text(defined $package->{tags}->[0] ? $package->{tags}->[0] : '');
    }

    my $lbl_tag2 = Gtk2::Label->new("Optional Package Tag 2: ");

    $lbl_tag2->show();

    my $tb_tag2 = Gtk2::Entry->new();

    $tb_tag2->show();

    if (defined $package_name)
    {
	$tb_tag2->set_text(defined $package->{tags}->[1] ? $package->{tags}->[1] : '');
    }

    my $lbl_tag3 = Gtk2::Label->new("Optional Package Tag 3: ");

    $lbl_tag3->show();

    my $tb_tag3 = Gtk2::Entry->new();

    $tb_tag3->show();

    if (defined $package_name)
    {
	$tb_tag3->set_text(defined $package->{tags}->[2] ? $package->{tags}->[2] : '');
    }

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
		 if ($package)
		 {
		     print "$0: reconfiguring existing package $package_name\n";

		     # assume we don't have to overwrite the local configuration

		     my $write_configuration = '';

		     # first use the standard developer APIs to check if this configuration is valid

		     my $all_packages = $Neurospaces::Developer::Configurator::default_packages;

		     $all_packages->{$package_name}
			 = {
			    ($ck_heterarch->get_active() ? (dependencies => { heterarch => 'configured using $0', }) : ()),
			    version_control => {
						port_number => $tb_port->get_text(),
						server => $tb_server->get_text(),
					       },
			   };

		     my $error = Neurospaces::Developer::Configurator::packages_validate($all_packages);

		     if (defined $error)
		     {
			 print "$0: *** Error: for component $package_name: $error";
		     }
		     else
		     {
			 #t note: copied from
			 #t neurospaces_new_component, the functionality
			 #t to reconfigure a package should be moved to
			 #t the neurospaces_new_component script to
			 #t allow for remote reconfiguration.

			 # this configuration is valid, register that we have to write the new configuration

			 $write_configuration = " option_repository_server";

			 # if the package was marked as read-only

			 if ($ck_developer->get_active())
			 {
			     # make sure the configuration is overwritten.

			     $write_configuration .= " option_read_only";
			 }

			 if ($write_configuration)
			 {
			     # write the new configuration to the global configuration file

			     my $build_database_filename = "/etc/neurospaces/developer/build.yml";

			     use YAML;

			     my $build_database = YAML::LoadFile($build_database_filename);

			     my $tags
				 = [
				    $tb_tag1->get_text() ? $tb_tag1->get_text() : (),
				    $tb_tag2->get_text() ? $tb_tag2->get_text() : (),
				    $tb_tag3->get_text() ? $tb_tag3->get_text() : (),
				   ];

			     $build_database->{all_packages}->{$package_name}
				 = {
				    ($ck_developer->get_active() ? () : ( read_only => "set from $0" ) ),
				    (scalar @$tags ? (tags => $tags) : ()),
				    (($tb_server->get_text()
				      or $tb_port->get_text()) ?
				     (
				      version_control => {
							  port_number => $tb_server->get_text(),
							  server => $tb_port->get_text(),
							 },
				     )
				     : ()),
				   };

			     YAML::DumpFile($build_database_filename, $build_database);
			 }
		     }

		     $dlg->destroy();
		 }
		 else
		 {
		     print "$0: configuring a new package $package_name\n";

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

		     if ($ck_developer->get_active())
		     {
		     }
		     else
		     {
			 $command .= "--read-only 'you are not a developer of this package' ";
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
	     }
	     else
	     {
		 $dlg->destroy();
	     }

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
	 [],
	);

    $dlg_package->run();

#     $dlg_package->destroy();
}


=head4 sub package_list_cursor_changed()

Update the gtk2_tb_package_information widget with information about
the selected package in the package list.

=cut

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

	my $description = `neurospaces_describe '$package_name'`;

	my $repository = `neurospaces_repositories '$package_name'`;

	my $status = `neurospaces_status '$package_name'`;

	$contents .= join "", $description, $status, $repository;

	$gtk2_tb_package_information->set_text($contents);
    }
}


=head4 sub package_list_row_activated()

Act after a package has been activated in the package list.

Currently opens the mtn-browse monotone browser for any project (also
when it is not versioned with monotone).

Used to open a window with detailed information about the package.

=cut

sub package_list_row_activated
{
    my ($widget, $path, $column) = @_;

    my $row_ref = $widget->get_row_data_from_path($path);

    my $package_name = $row_ref->[0];

#     system "cd '$ENV{HOME}/neurospaces_project/$package_name/source/snapshots/0' && mtn-browse & ";

    package_dialog_show(undef, $package_name);
}


=head4 sub package_list_update()

Act after a package tag checkbox has changed state.

Updates the package list to list packages tagged with one of the
selected package tags.

=cut

sub package_list_update
{
    my $active_tags = shift;

    my $active_packages = Neurospaces::Developer::Packages::packages_by_tags($active_tags);

    # note: working with references would be disconnecting the gtk2
    # internal list from its perl equivalent.  we must use direct
    # access here.

    @{$gtk2_package_list->{data}} = ();

    foreach my $active_package (sort
				{
				    $a->{package} cmp $b->{package}
				}
				@$active_packages)
    {
	push
	    @{$gtk2_package_list->{data}},
		[
		 $active_package->{package},
		];
    }
}


sub remote_dialog_show
{
    my $dlg_remote = Gtk2::Dialog->new("Connect to a Remote Neurospaces Server", $window_main, 'destroy-with-parent','gtk-ok' => 'ok', 'gtk-cancel' => 'cancel');

    my $lbl_login = Gtk2::Label->new("Login Name: ");

    $lbl_login->show();

    my $tb_login = Gtk2::Entry->new();

    $tb_login->show();

    my $lbl_server = Gtk2::Label->new("Server Name: ");

    $lbl_server->show();

    my $tb_server = Gtk2::Entry->new();

    $tb_server->show();

    my $tbl_server = Gtk2::Table->new(4, 2, 1);

    $tbl_server->show();

    $dlg_remote->vbox->add($tbl_server);

    $tbl_server->attach_defaults($lbl_login, 0,1,0,1);
    $tbl_server->attach_defaults($tb_login, 1,2,0,1);

    $tbl_server->attach_defaults($lbl_server, 0,1,1,2);
    $tbl_server->attach_defaults($tb_server, 1,2,1,2);

    $dlg_remote->signal_connect
	(
	 'response',
	 sub
	 {
	     # $data will be the third argument given to ->signal_connect()

	     my ($dlg, $response, $data) = @_;

	     if ($response eq 'ok')
	     {
		 $remote_login = $tb_login->get_text();

		 $remote_server = $tb_server->get_text();

		 my $error = '';

		 if ($error)
		 {
		     print "*** $0: *** Error: $error\n";
		 }
		 else
		 {
# 		     $command .= "--verbose ";

# 		     print "*** $0: executing: $command\n";

# 		     system "$command";

# 		     if ($?)
# 		     {
# 			 print "*** $0: *** Error: Could not create component, check terminal for error messages\n";
# 		     }
# 		     else
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

    $dlg_remote->run();

#     $dlg_remote->destroy();
}


sub show_dialog
{
    my ($title, $message) = @_;

    my $dialog = Gtk2::MessageDialog->new($window_main, 'destroy-with-parent', 'info', 'ok', $message);

    $dialog->set_title($title);

    $dialog->run();

    $dialog->destroy();
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


1;


