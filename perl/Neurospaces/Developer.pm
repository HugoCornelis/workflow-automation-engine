#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package Neurospaces::Developer;


sub unique(@);


sub packages_by_tags
{
    my $active_tags = shift;

    if (scalar @$active_tags)
    {
    }
    else
    {
	push @$active_tags, "ZZZZZZZZ";
    }

    my $command = "neurospaces_repositories " . (join ' ', map  { '--package-tags "' . $_ . '"' } @$active_tags);

    print "$command\n";

    my $packages_text = `$command`;

    if ($@)
    {
	die "$0: *** Error: cannot find package information, does the 'neurospaces_repositories' command work correctly?";
    }

#     use Data::Dumper;

#     print Dumper($packages_text);

    my $packages = YAML::Load($packages_text);

    $packages = [ %$packages, ];

    $packages = [ @{$packages->[1]->{repositories}}, ];
}


sub packages
{
    my $packages_text = `neurospaces_repositories`;

    if ($@)
    {
	die "$0: *** Error: cannot find package information, does the 'neurospaces_repositories' command work correctly?";
    }

    my $packages = YAML::Load($packages_text);

    $packages = [ %$packages, ];

    my $result = [ @{$packages->[1]->{repositories}}, ];

    return($result);
}


sub package_tags
{
    my $packages = Neurospaces::Developer::packages();

    my $tags = [];

    foreach my $package (@$packages)
    {
	$tags = [ @$tags, @{$package->{tags} || []}, ];
    }

    my $packages_tags = [ unique sort @$tags, ];

    my $result
	= {
	   map
	   {
	       $_ => {},
	   }
	   @$packages_tags,
	  };

    return $result;
}


sub unique(@)
{
    return unless defined wantarray;  # void context, do nothing

    my $array = [ sort @_, ];

    my $hash
	= {
	   map
	   {
	       $_ => 1,
	   }
	   @$array,
	  };

    return (keys %$hash);
}


package Neurospaces::Developer::Configurator;


use Data::Utilities;

use YAML;


our $whole_build_configuration;

our $personal_build_configuration;

our $default_packages;


sub whole_build_configuration_automated_merges
{
    # automated merges on a server only if allowed by the configuration, default is yes

    my $no_automated_merges
	= $Neurospaces::Developer::Configurator::whole_build_configuration->{no_automated_merges};

    return not $no_automated_merges;
}


sub whole_build_configuration_read
{
    if (-f '/etc/neurospaces/developer/build.yml')
    {
	eval
	{
	    $whole_build_configuration = YAML::LoadFile('/etc/neurospaces/developer/build.yml');
	};

	if ($@)
	{
	    die "$0: *** Error: reading file /etc/neurospaces/developer/build.yml ($@)";
	}
    }
}


sub personal_build_configuration_read
{
    if (-f $ENV{HOME} . '/.neurospaces/developer/build.yml')
    {
	eval
	{
	    $personal_build_configuration = YAML::LoadFile($ENV{HOME} . '/.neurospaces/developer/build.yml');
	};

	if ($@)
	{
	    die "$0: *** Error: reading file $ENV{HOME}/.neurospaces/developer/build.yml ($@)";
	}
    }
}


sub default_packages_read()
{
    my $result
	= {
	   experiment => {
			  description => 'Experimental protocols',
			  directory => "$ENV{HOME}/neurospaces_project/experiment/source/snapshots/0",
			  operations => {
					 './configure' => {
							   debug => [
								     "CFLAGS=-g -O0",
								    ],
							   release => [
								       "CFLAGS=-g -O9",
								      ],
							  },
					},
			  order => 1.5,
			  tags => [
				   'genesis3',
				  ],
			  version_control => {
					      branch_name => 0,
					      port_number => 4703,
					     },
			 },
	   chemesis3 => {
			 dependencies => {
					  experiment => 'for running the tests',
					 },
			 description => 'a simple reaction-diffusion solver',
			 operations => {
					'./configure' => {
							  debug => [
								    'CFLAGS=-g -O0',
								   ],
							  release => [
								      'CFLAGS=-g -O9',
								     ],
							 },
				       },
			 tags => [
				  'genesis3',
				 ],
			 order => 2.5,
			 version_control => {
					     branch_name => 0,
					     port_number => 4706,
					     #server => '91.183.94.6',
					    },
			},
	   configurator => {
			    dependencies => {
					    },
			    description => 'common configurations of the Neurospaces tool chain',
			    disabled => 'the Configurator must always be disabled',
			    order => 0.5,
			    tags => [
				     'neurospaces',
				    ],
			    version_control => {
						branch_name => 0,
						port_number => 4707,
						server => '91.183.94.6',
					       },
			    version_script => 0,
			   },
	   dash => {
		    dependencies => {
				    },
		    description => 'a single neuron solver that uses dual exponential equations to model channel currents',
		    directory => "$ENV{HOME}/neurospaces_project/dash/source/snapshots/0",
		    disabled => 1,
		    order => 2,
		    tags => [
			     'genesis3',
			    ],
		    version_script => 0,
		   },
	   geometry => {
			dependencies => {
					},
			description => 'a collection of algorithms in computational geometry useful for the conversion of EM image stacks ao.',
			directory => "$ENV{HOME}/neurospaces_project/geometry/source/snapshots/0",
			disabled => 'far from finished.',
			order => 4,
			tags => [
				 'genesis3',
				],
			version_script => 0,
		       },
	   gshell => {
		      dependencies => {
				       'model-container' => 'for storing the model in computer memory',
				       heccer => 'for solving single neurons',
				       ssp => 'to schedule the solvers',
				      },
		      description => 'an interactive GENESIS shell environment developed in perl',
		      directory => "$ENV{HOME}/neurospaces_project/gshell/source/snapshots/0",
		      order => 13,
		      tags => [
			       'genesis3',
			      ],
		      version_control => {
					  branch_name => 0,
					  port_number => 4699,
					 },
		      version_script => 'genesis-g3 --version',
		     },
	   'g-tube' => {
			directory => "$ENV{HOME}/neurospaces_project/g-tube/source/snapshots/0",
			description => 'GENESIS GUI',
			#		   disabled => 'g-tube is not complete yet',
			order => 30,
			tags => [
				 'genesis3',
				],
			version_control => {
					    branch_name => 0,
					    repository => "$ENV{HOME}/neurospaces_project/g-tube/source/snapshots/0/.hg",
					   },
			version_script => 0,
		       },
	   heccer => {
		      dependencies => {
				       'model-container' => 'for storing the model in computer memory',
				      },
		      description => 'a single neuron solver',
		      directory => "$ENV{HOME}/neurospaces_project/heccer/source/snapshots/0",
		      disabled => 0,
		      operations => {
				     './configure' => {
						       debug => [
								 "CFLAGS=-g -O0",
								],
						       release => [
								   "CFLAGS=-g -O9",
								  ],
						      },
				    },
		      order => 2,
		      tags => [
			       'genesis3',
			      ],
		      version_control => {
					  branch_name => 0,
					  port_number => 4694,
					 },
		     },
	   developer => {
			 description => 'developer utilities that comply for GENESIS 3',
			 directory => "$ENV{HOME}/neurospaces_project/developer/source/snapshots/0",
			 disabled => 0, # disabled => 1,
			 order => 0,
			 tags => [
				  'genesis3',
				  'neurospaces',
				 ],
			 version_control => {
					     branch_name => 0,
					     port_number => 4696,
					    },
			 version_script => 'neurospaces_build --version',
			},
	   'model-container' => {
				 description => 'backend independent model storage',
				 directory => "$ENV{HOME}/neurospaces_project/model-container/source/snapshots/0",
				 disabled => 0,
				 operations => {
						'./configure' => {
								  debug => [
									    "CFLAGS=-g -O0",
									   ],
								  release => [
									      "CFLAGS=-g -O9",
									     ],
								 },
					       },
				 order => 1,
				 tags => [
					  'genesis3',
					  'neurospaces',
					 ],
				 version_control => {
						     branch_name => 0,
						     port_number => 4693,
						    },
				},
	   exchange => {
			dependencies => {
					 'model-container' => 'for storing the model in computer memory',
					},
			description => 'model exchange using common standars such as NeuroML and NineML',
			directory => "$ENV{HOME}/neurospaces_project/exchange/source/snapshots/0",
			order => 6.5,
			tags => [
				 'genesis3',
				],
			version_control => {
					    branch_name => 0,
					    port_number => 4701,
					   },
			version_script => 'neurospaces_exchange --version',
		       },
	   neurospaces_prcs => {
				description => 'backend independent model storage -- OLD',
				directory => "$ENV{HOME}/neurospaces_project/model-container/source/snapshots/prcs.0",
				disabled => 'obsoleted by the model-container under mtn control rather than prcs',
				order => 0.5,
				tags => [
					 'neurospaces',
					],
				version_control => {
						    commands => {
								 missing => undef,
								 status => [
									    'prcs',
									    'diff',
									    'neurospaces.prj',
									    '`prcs 2>/dev/null execute --not ".*\(directory\|symlink\)" neurospaces.prj | grep -v "neurospaces\.prj" | grep -v "purkinjespine" `',
									    '--',
									    '--unified',
									   ],
								 unknown => undef,
								},
						   },
				version_script => 'prcsentry Project-Version',
			       },
	   'ns-sli' => {
			dependencies => {
					 'model-container' => 'for storing the model in computer memory',
					 heccer => 'for solving single neurons',
					},
			description => 'GENESIS-2 Backward Compatibility',
			directory => "$ENV{HOME}/neurospaces_project/ns-sli/source/snapshots/0",
			order => 6,
			operations => {
				       './configure' => {
							 debug => [
								   "CFLAGS=-g -O0",
								  ],
							 release => [
								     "CFLAGS=-g -O9",
								    ],
							},
				      },
			tags => [
				 'genesis3',
				],
			version_control => {
					    branch_name => 0,
					    port_number => 4692,
					   },
			version_script => 0,
		       },
	   'project-browser' => {
				 dependencies => {
						  'model-container' => 'for storing the model in computer memory',
						  heccer => 'for solving single neurons',
						  ssp => 'to schedule the solvers',
						 },
				 description => 'inspect and compare simulation output',
				 directory => "$ENV{HOME}/neurospaces_project/project-browser/source/snapshots/0",
				 disabled => 'parts working, only for experts who are familiar with the Sesa internals',
				 order => 7,
				 tags => [
					  'neurospaces',
					 ],
				 version_control => {
						     branch_name => 0,
						     port_number => 4697,
						     repository => "$ENV{HOME}/neurospaces_project/MTN/neurospacesweb.mtn",
						    },
				 version_script => 'pb-version',
				},
	   publications => {
			    description => 'prototyping the publication framework',
			    directory => "$ENV{HOME}/neurospaces_project/publications/source/snapshots/0",
			    disabled => 'Allan\'s experiment working area',
			    order => 32,
			    tags => [
				     'genesis3',
				    ],
			    version_control => {
						branch_name => 0,
						port_number => 4702,
					       },
			    version_script => 0,
			   },
	   rtxi => {
		    description => 'interface with the RTXI dynamic clamp software',
		    directory => "$ENV{HOME}/neurospaces_project/rtxi/source/snapshots/0",
		    disabled => 'slow progress, yet important',
		    order => 29,
		    tags => [
			     'genesis3',
			    ],
		    version_control => {
					branch_name => 0,
					port_number => 4704,
				       },
		    version_script => 0,
		   },
	   ssp => {
		   dependencies => {
				    'model-container' => 'for storing the model in computer memory',
				    heccer => 'for solving single neurons',
				   },
		   description => 'simple scheduler in perl',
		   directory => "$ENV{HOME}/neurospaces_project/ssp/source/snapshots/0",
		   disabled => 0,
		   order => 3,
		   tags => [
			    'genesis3',
			   ],
		   version_control => {
				       branch_name => 0,
				       port_number => 4695,
				      },
		  },
	   sspy => {
		    dependencies => {
				     'model-container' => 'for storing the model in computer memory',
				     heccer => 'for solving single neurons',
				    },
		    description => 'simple scheduler in python',
		    directory => "$ENV{HOME}/neurospaces_project/sspy/source/snapshots/0",
		    order => 3.1,
		    tags => [
			     'genesis3',
			    ],
		    version_control => {
					branch_name => 0,
					port_number => 4705,
				       },
		   },
	   studio => {
		      dependencies => {
				       'model-container' => 'for storing the model in computer memory',
				       heccer => 'for solving single neurons',
				       ssp => 'to schedule the solvers',
				      },
		      description => 'visualizes and explores models in the model-container',
		      directory => "$ENV{HOME}/neurospaces_project/studio/source/snapshots/0",
		      disabled => 0,
		      order => 5,
		      tags => [
			       'neurospaces',
			      ],
		      version_control => {
					  branch_name => 0,
					  port_number => 4698,
					 },
		      version_script => 'neurospaces --version',
		     },
	   system => {
		      description => 'system data',
		      directory => "$ENV{HOME}/neurospaces_project/.",
		      disabled => 1,
		      order => 129,
		      tags => [
			       'neurospaces',
			      ],
		      version_script => 0,
		     },
	   userdocs => {
			description => 'all you need to know about installing, using and simulating using GENESIS 3. ',
			directory => "$ENV{HOME}/neurospaces_project/userdocs/source/snapshots/0",
			disabled => 0,
			order => 31,
			tags => [
				 'genesis3',
				],
			version_control => {
					    branch_name => 0,
					    port_number => 4700,
					   },
			version_script => 0,
		       },
	  };

    # if there is a local package configuration

    if ($whole_build_configuration)
    {
	# merge

	my $merged_packages = Data::Merger::merger($result, $whole_build_configuration->{all_packages});
    }

    # if there is a personal package configuration

    if ($personal_build_configuration)
    {
	my $merged_packages = Data::Merger::merger($result, $personal_build_configuration->{all_packages});
    }

    return $result;
}


sub packages_validate
{
    my $all_packages = shift;

    # check validity of the package configuration

    foreach my $first_package_name (keys %$all_packages)
    {
	my $first_package = $all_packages->{$first_package_name};

	foreach my $second_package_name (keys %$all_packages)
	{
	    next if $first_package_name eq $second_package_name;

	    my $second_package = $all_packages->{$second_package_name};

	    # if the version control port numbers are the same

	    #! to support version control systems other than monotone,
	    #! we only compare port numbers if they have been defined.

	    if ($first_package->{version_control}
		and $first_package->{version_control}->{port_number}
		and $second_package->{version_control}
		and $second_package->{version_control}->{port_number})
	    {
		if ($first_package->{version_control}->{port_number}
		    eq $second_package->{version_control}->{port_number})
		{
		    return "$0: *** Error: package $first_package_name and $second_package_name have the same version control port number";
		}
	    }
	}

	# if the directory of the package is not set

	if (not exists $first_package->{directory})
	{
	    # set default

	    my $configurator_branch = '0';

	    $first_package->{directory} = $ENV{HOME} . "/neurospaces_project/$first_package_name/source/snapshots/$configurator_branch";

	    $first_package->{directory} =~ s(//)(/)g;
	}

	# if the version control repository filesystem location is not set

	if (not exists $first_package->{version_control}->{repository})
	{
	    # set default

	    $first_package->{version_control}->{repository} = $ENV{HOME} . "/neurospaces_project/MTN/$first_package_name.mtn";

	    $first_package->{version_control}->{repository} =~ s(//)(/)g;
	}
    }

    return undef;
}


whole_build_configuration_read();

personal_build_configuration_read();

$default_packages = default_packages_read();

my $error = packages_validate($default_packages);

if (defined $error)
{
    die $error;
}


package Neurospaces::Developer::Manager;


our $operations
    = [
       {
	name => 'repositories',
	targets => {
		    content_developer => 1,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
       {
	name => 'status',
	targets => {
		    content_developer => 1,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
       {
	name => 'upgrade',
	targets => {
		    content_developer => 1,
		    content_user => 1,
		    software_developer => 1,
		   },
       },
       {
	name => 'pull',
	targets => {
		    content_developer => 0,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
       {
	name => 'sync',
	targets => {
		    content_developer => 0,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
       {
	clicked => 'content',
	name => 'content_sync',
	targets => {
		    content_developer => 1,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
       {
	name => 'clean',
	targets => {
		    content_developer => 0,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
       {
	name => 'update',
	targets => {
		    content_developer => 0,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
       {
	name => 'configure',
	targets => {
		    content_developer => 0,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
       {
	name => 'install',
	targets => {
		    content_developer => 0,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
       {
	name => 'check',
	targets => {
		    content_developer => 0,
		    content_user => 1,
		    software_developer => 1,
		   },
       },
       {
	clicked => 'content',
	name => 'content_build',
	targets => {
		    content_developer => 1,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
       {
	clicked => 'content',
	name => 'content_check',
	targets => {
		    content_developer => 1,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
       {
	name => 'dev_uninstall',
	targets => {
		    content_developer => 1,
		    content_user => 1,
		    software_developer => 1,
		   },
       },
       {
	name => 'serve',
	targets => {
		    content_developer => 1,
		    content_user => 0,
		    software_developer => 1,
		   },
       },
      ];


$0 =~ m(.*/(.*));

my $program_name = $1;

$program_name =~ m((.*)[_-](.*));

our $documentation_set_name = $1;
our $root_operation_name = $2;

my $role = 'empty';

if ($documentation_set_name ne 'neurospaces-manager')
{
    $role = 'content_developer';
}
else
{
    $role = 'software_developer';
}

our $assigned_role = $role;


package Neurospaces::Developer::Manager::GUI;


use Glib qw/TRUE FALSE/;

use Gtk2 '-init';
use Gtk2::Helper;
use Gtk2::SimpleList;


our $gtk2_package_list;
our $gtk2_tb_package_information;
our $tooltips = Gtk2::Tooltips->new();


sub create
{
    my $packages_tags = shift;

    my $assigned_role = $Neurospaces::Developer::Manager::assigned_role;

    my $window = Gtk2::Window->new('toplevel');

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

    my $hbox = Gtk2::HBox->new();

    $window->add($hbox);

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


