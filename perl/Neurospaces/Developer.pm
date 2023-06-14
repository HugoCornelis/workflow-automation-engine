#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


=head3

package Neurospaces::Developer;

Functionality required for convenient maintenance of a Neurospaces
Software based development system.

=cut


package Neurospaces::Developer;


use Neurospaces::Developer::Packages;
use Neurospaces::Developer::Operations;


=head3

package Neurospaces::Developer::Configurator;

Functionality for building and maintaining the local Neurospaces
configuration.

=cut


package Neurospaces::Developer::Configurator;


use Data::Utilities;

use YAML;


our $whole_build_configuration;

our $personal_build_configuration;

our $new_projects_directory = 'projects';


=head4 $default_packages

A hash reference consisting of hashes that describe each package.  The
order key in each package can be used to sort the packages on
dependency order.

=cut

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


=head4 sub default_packages_read()

Enumerate all the configured packages on this system.  Note that the
result is unordered.

This sub should not be used to obtain a valid list of configured
packages.  Use the $default_packages variables instead.

=cut

sub default_packages_read()
{
    my $legacy_directory = 'neurospaces_project';

    my $result
	= {
	   experiment => {
			  dependencies => {
					   'model-container' => 'required during linking, for storing the model in computer memory',
					  },
			  description => 'Experimental protocols',
			  directory => "$ENV{HOME}/$new_projects_directory/experiment/source/snapshots/master",
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
					      git => {
						      # https://github.com/HugoCornelis/experiment.git
						      remote => {
								 host => 'github.com',
								 name => 'github',
								 protocol => 'https',
								 url => 'experiment.git',
								 user => 'HugoCornelis',
								},
						     },
					      branch_name => 'master',
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
					     git => {
						     # https://github.com/HugoCornelis/chemesis3.git
						     remote => {
								host => 'github.com',
								name => 'github',
								protocol => 'https',
								url => 'chemesis3.git',
								user => 'HugoCornelis',
							       },
						    },
					     branch_name => 'master',
					    },
			},
	   configurator => {
			    description => 'common configurations of the Neurospaces tool chain',
			    disabled => 'the Configurator must always be disabled',
			    order => 0.5,
			    tags => [
				     'neurospaces',
				    ],
			    version_control => {
						git => {
							# https://github.com/HugoCornelis/configurator.git
							remote => {
								   host => 'github.com',
								   name => 'github',
								   protocol => 'https',
								   url => 'configurator.git',
								   user => 'HugoCornelis',
								  },
						       },
						branch_name => 'master',
					       },
			    version_script => 0,
			   },
	   dash => {
		    description => 'a single neuron solver that uses dual exponential equations to model channel currents',
		    directory => "$ENV{HOME}/$new_projects_directory/dash/source/snapshots/0",
		    disabled => 1,
		    order => 2,
		    tags => [
			     'genesis3',
			    ],
		    version_script => 0,
		   },
	   geometry => {
			description => 'a collection of algorithms in computational geometry useful for the conversion of EM image stacks ao.',
			directory => "$ENV{HOME}/$new_projects_directory/geometry/source/snapshots/0",
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
				       'ns-sli' => 'for loading G-2 models',
				       chemesis3 => 'for solving biochemical pathways',
				       exchange => 'to load neuroml and nineml model',
				       experiment => 'for the experiment protocol definitions',
				       heccer => 'for solving single neurons',
				       ssp => 'to schedule the solvers',
				      },
		      description => 'an interactive GENESIS shell environment developed in perl',
		      directory => "$ENV{HOME}/$new_projects_directory/gshell/source/snapshots/master",
		      order => 13,
		      tags => [
			       'genesis3',
			      ],
		      version_control => {
					  git => {
						  # https://github.com/HugoCornelis/gshell.git
						  remote => {
							     host => 'github.com',
							     name => 'github',
							     protocol => 'https',
							     url => 'gshell.git',
							     user => 'HugoCornelis',
							    },
						 },
					  branch_name => 'master',
					 },
		      version_script => 'genesis-g3 --version',
		     },
	   'g-tube' => {
			dependencies => {
					 gshell => 'as an interface',
					},
			description => 'GENESIS GUI',
			directory => "$ENV{HOME}/$new_projects_directory/g-tube/source/snapshots/0",
			disabled => 'g-tube is not complete yet',
			order => 30,
			tags => [
				 'genesis3',
				],
			version_control => {
					    branch_name => 0,
					    repository => "$ENV{HOME}/$new_projects_directory/g-tube/source/snapshots/0/.hg",
					   },
			version_script => 0,
		       },
	   heccer => {
		      dependencies => {
				       'model-container' => 'only for compilation',
				       experiment => 'perfectclamp is needed for running the python tests',
				      },
		      description => 'a single neuron solver',
		      directory => "$ENV{HOME}/$new_projects_directory/heccer/source/snapshots/master",
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
					  git => {
						  # https://github.com/HugoCornelis/heccer.git
						  remote => {
							     host => 'github.com',
							     name => 'github',
							     protocol => 'https',
							     url => 'heccer.git',
							     user => 'HugoCornelis',
							    },
						 },
					  branch_name => 'master',
					 },
		     },
	   developer => {
			 description => 'developer utilities that comply for GENESIS 3',
			 directory => "$ENV{HOME}/$new_projects_directory/developer/source/snapshots/master",
			 order => 0,
			 tags => [
				  'genesis3',
				  'neurospaces',
				 ],
			 version_control => {
					     git => {
						     # https://github.com/HugoCornelis/developer.git
						     remote => {
								host => 'github.com',
								name => 'github',
								protocol => 'https',
								url => 'developer.git',
								user => 'HugoCornelis',
							       },
						    },
					     branch_name => 'master',
					    },
			 version_script => 'neurospaces_build --version',
			},
	   'model-container' => {
				 description => 'backend independent model storage',
				 directory => "$ENV{HOME}/$new_projects_directory/model-container/source/snapshots/master",
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
						     git => {
							     # https://github.com/HugoCornelis/model-container.git
							     remote => {
									host => 'github.com',
									name => 'github',
									protocol => 'https',
									url => 'model-container.git',
									user => 'HugoCornelis',
								       },
							    },
						     branch_name => 'master',
						    },
				},
	   exchange => {
			dependencies => {
					 'model-container' => 'for storing the model in computer memory',
					},
			description => 'model exchange using common standars such as NeuroML and NineML',
			directory => "$ENV{HOME}/$new_projects_directory/exchange/source/snapshots/master",
			order => 6.5,
			tags => [
				 'genesis3',
				],
			version_control => {
					    git => {
						    # https://github.com/HugoCornelis/exchange.git
						    remote => {
							       host => 'github.com',
							       name => 'github',
							       protocol => 'https',
							       url => 'exchange.git',
							       user => 'HugoCornelis',
							      },
						   },
					    branch_name => 'master',
					   },
			version_script => 'neurospaces_exchange --version',
		       },
	   neurospaces_prcs => {
				description => 'backend independent model storage -- OLD',
				directory => "$ENV{HOME}/$new_projects_directory/model-container/source/snapshots/prcs.0",
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
					 ssp => 'for some of the tests',
					},
			description => 'GENESIS-2 Backward Compatibility',
			directory => "$ENV{HOME}/$new_projects_directory/ns-sli/source/snapshots/master",
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
					    git => {
						    remote => {
							       host => 'github.com',
							       name => 'github',
							       protocol => 'https',
							       url => 'ns-sli.git',
							       user => 'HugoCornelis',
							      },
						   },
					    branch_name => 'master',
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
				 directory => "$ENV{HOME}/$new_projects_directory/project-browser/source/snapshots/master",
				 disabled => 'parts working, only for experts who are familiar with the Sesa internals',
				 order => 7,
				 tags => [
					  'neurospaces',
					 ],
				 version_control => {
						     git => {
							     remote => {
									host => 'github.com',
									name => 'github',
									protocol => 'https',
									url => 'project-browser.git',
									user => 'HugoCornelis',
								       },
							    },
						     branch_name => 'master',
						    },
				 version_script => 'pb-version',
				},
	   publications => {
			    description => 'prototyping the publication framework',
			    directory => "$ENV{HOME}/$new_projects_directory/publications/source/snapshots/master",
			    disabled => 'Allan\'s experiment working area',
			    order => 32,
			    tags => [
				     'genesis3',
				    ],
			    version_control => {
						git => {
							remote => {
								   host => 'github.com',
								   name => 'github',
								   protocol => 'https',
								   url => 'publications.git',
								   user => 'HugoCornelis',
								  },
						       },
						branch_name => 'master',
					       },
			    version_script => 0,
			   },
	   rtxi => {
		    description => 'interface with the RTXI dynamic clamp software',
		    directory => "$ENV{HOME}/$new_projects_directory/rtxi/source/snapshots/master",
		    disabled => 'slow progress',
		    order => 29,
		    tags => [
			     'genesis3',
			    ],
		    version_control => {
					git => {
						remote => {
							   host => 'github.com',
							   name => 'github',
							   protocol => 'https',
							   url => 'rtxi.git',
							   user => 'HugoCornelis',
							  },
					       },
					branch_name => 'master',
				       },
		    version_script => 0,
		   },
	   ssp => {
		   dependencies => {
				    'model-container' => 'for storing the model in computer memory',
				    heccer => 'for solving single neurons',
				   },
		   description => 'simple scheduler in perl',
		   directory => "$ENV{HOME}/$new_projects_directory/ssp/source/snapshots/master",
		   disabled => 0,
		   order => 3,
		   tags => [
			    'genesis3',
			   ],
		   version_control => {
				       git => {
					       remote => {
							  host => 'github.com',
							  name => 'github',
							  protocol => 'https',
							  url => 'ssp.git',
							  user => 'HugoCornelis',
							 },
					      },
				       branch_name => 'master',
				      },
		  },
	   sspy => {
		    dependencies => {
				     'model-container' => 'for storing the model in computer memory',
				     heccer => 'for solving single neurons',
				    },
		    description => 'simple scheduler in python',
		    directory => "$ENV{HOME}/$new_projects_directory/sspy/source/snapshots/master",
		    order => 3.1,
		    tags => [
			     'genesis3',
			    ],
		    version_control => {
					git => {
						remote => {
							   host => 'github.com',
							   name => 'github',
							   protocol => 'https',
							   url => 'sspy.git',
							   user => 'HugoCornelis',
							  },
					       },
					branch_name => 'master',
				       },
		   },
	   studio => {
		      dependencies => {
				       'model-container' => 'for storing the model in computer memory',
				      },
		      description => 'visualizes and explores models in the model-container',
		      directory => "$ENV{HOME}/$new_projects_directory/studio/source/snapshots/master",
		      disabled => 0,
		      order => 5,
		      tags => [
			       'genesis3',
			       'neurospaces',
			      ],
		      version_control => {
					  git => {
						  remote => {
							     host => 'github.com',
							     name => 'github',
							     protocol => 'https',
							     url => 'studio.git',
							     user => 'HugoCornelis',
							    },
						 },
					  branch_name => 'master',
					 },
		      version_script => 'neurospaces --version',
		     },
	   system => {
		      description => 'system data',
		      directory => "$ENV{HOME}/$new_projects_directory/.",
		      disabled => 1,
		      order => 129,
		      tags => [
			       'neurospaces',
			      ],
		      version_script => 0,
		     },
	   userdocs => {
			description => 'all you need to know about installing, using and simulating using GENESIS 3. ',
			directory => "$ENV{HOME}/$new_projects_directory/userdocs/source/snapshots/master",
			disabled => 0,
			order => 31,
			tags => [
				 'genesis3',
				],
			version_control => {
					    git => {
						    remote => {
							       host => 'github.com',
							       name => 'github',
							       protocol => 'https',
							       url => 'userdocs.git',
							       user => 'HugoCornelis',
							      },
						   },
					    branch_name => 'master',
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


=head4 sub extended_bubble_sort()

Sort the items in the given list using the given comparator, that is
assumed to implement a partial order.

The algorithm is stable at a cost of performance.  Stability is not
always guaranteed with arbitrary topological sorting algorithms.

Difference with a regular bubble sort : assumes the order implemented
by the comparator is a partial order, so the last entry must be
checked too.  If we don''t, we actually assume the order to be fully
transitive and full comparable, which is of course not always the case
for a _partial_ order.

=cut

sub extended_bubble_sort(&@);

sub extended_bubble_sort(&@)
{
    my $comparator = shift;

    my @array = @_;

    my $count = $#array;

    my $i;
    my $j;

    #! note about this loop : read comments for this sub carefully.

    for ($i = 0; $i <= ($count - 1); $i++)
    {
	for ($j = ($i + 1); $j <= ($count); $j++)
	{
	    my $comparison;

	    {
		local $::a = $array[$j];
		local $::b = $array[$i];
		$comparison = &$comparator($array[$j], $array[$i]);
	    }

	    if ($comparison < 0)
	    {
		my $swap = $array[$j];
		$array[$j] = $array[$i];
		$array[$i] = $swap;
	    }
	}
    }

    return @array;
}


=head4 sub package_comparator()

Implements a partial order on the packages using the dependencies
(which must not be cyclic).

=cut

sub package_comparator
{
    my ($package1, $package2) = @_;

    $package1 = $::a;

    $package2 = $::b;

    my $graph_id1 = $package1->{sort_id} || '';
    my $graph_id2 = $package2->{sort_id} || '';

    my $graph_dependencies1 = $package1->{dependencies} || {};
    my $graph_dependencies2 = $package2->{dependencies} || {};

    # if the packages are cycled

    if ($graph_dependencies1->{$graph_id2}
	&& $graph_dependencies2->{$graph_id1})
    {
	print STDERR "$0: *** Warning: package dependency cycle detected between $graph_id1 and graph_id2\n";

	# return unordered (fastest)

	return 0;
    }

    # check command ordering

    if ($graph_dependencies1->{$graph_id2})
    {
	# package1 should come last in list

	return 1;
    }

    if ($graph_dependencies2->{$graph_id1})
    {
	# package2 should come last in list

	return -1;
    }

    # return unordered

    return 0;
}


=head4 sub packages_sort()

Assign order numbers to packages by using their dependencies.  Sorting
on order number sorts the packages on their dependencies such that the
first in the list has no dependencies.

=cut

sub packages_sort
{
    my $all_packages = shift;

    # first assign unique sort IDs to all packages

    foreach my $package_name (keys %$all_packages)
    {
	my $package = $all_packages->{$package_name};

	if (not exists $package->{sort_id})
	{
	    $package->{sort_id} = $package_name;
	}
    }

    # create an array of package references for sorting

    my $package_array
	= [
	   map
	   {
	       my $result = $all_packages->{$_};

	       if (not exists $result->{dependencies}->{developer})
	       {
		   $result->{dependencies}->{developer} = "must always be installed";
	       }

	       if (not exists $result->{dependencies}->{configurator}
		   and $result->{sort_id} ne 'developer')
	       {
		   $result->{dependencies}->{configurator} = "must always come after the developer package";
	       }

	       $result;
	   }
	   keys %$all_packages,
	  ];

    my $transitive_package_array
	= [
	   transifier(\&package_namer, \&package_dependency_enumerator, \&package_dependency_creator, @$package_array),
	  ];

    # order the references to the package definitions

    my $ordered_package_array
	= [
	   extended_bubble_sort(\&package_comparator, @$package_array)
	  ];

    # assign order numbers based on the ordered_package_array

    my $order_number = 1;

    foreach my $package (@$ordered_package_array)
    {
	$package->{order} = $order_number;

	$order_number++;
    }

    # for sake of certainty

    if (exists $all_packages->{developer})
    {
	$all_packages->{developer}->{order} = 0;
    }

    if (exists $all_packages->{configurator})
    {
	$all_packages->{configurator}->{order} = 0.25;
    }

    if (exists $all_packages->{heterarch})
    {
	$all_packages->{heterarch}->{order} = 0.5;
    }

    if (exists $all_packages->{tesseract})
    {
	$all_packages->{tesseract}->{order} = 0.75;
    }

    # return errors of processing

    return undef;
}


sub package_dependency_creator
{
    my $package = shift;

    my $dependency = shift;

    if (not exists $package->{dependencies}->{$dependency})
    {
	$package->{dependencies}->{$dependency} = 'transitive closure';
    }
}


sub package_dependency_enumerator
{
    my $package_name = shift;

    my @packages = @_;

    if ($package_name eq '')
    {
	return ();
    }

    foreach my $package (@packages)
    {
	if (exists $package->{sort_id}
	    && $package->{sort_id} eq $package_name)
	{
	    my $dependencies = $package->{dependencies};

	    return keys %$dependencies;
	}
    }

    return ();
}


sub package_namer
{
    my $package = shift;

    return $package->{sort_id} || '';
}


#
# transifier()
#
# Take care that the order relationship of the items in the given list
# is transitive.  The order relationship is external to this sub, it
# is being defined during execution of this code by the following
# arguments :
#
# $item_namer : a coderef that gives a (unique) name to all items.
#
# $dependency_enumerator : a coderef that, given a item name, returns
# a list of names that the given item depends on.
#
# $dependency_creator : a coderef that takes care that the given item
# becomes dependent on the given name.
#
# I guess this one can easily be combined with (built into) the
# extended_bubble_sort() above.  That would boost the sort quite a bit.
#

sub transifier(&&&@)
{
    my $item_namer = shift;

    my $dependency_enumerator = shift;

    my $dependency_creator = shift;

    my @array = @_;

    # loop over all items in the array

    foreach my $item (@array)
    {
	# initially we did not see any dependencies for this item

	my $seen_dependencies = {};

	# loop over all transitive dependencies of this item (included)

	my $dependency_names = [ &$item_namer($item), ];

	while (@$dependency_names)
	{
	    my $dependency_name = shift @$dependency_names;

	    my @new_dependency_names = &$dependency_enumerator($dependency_name, @array, );

	    foreach my $new_dependency_name (@new_dependency_names)
	    {
		# if the dependency has not been seen yet

		if (!$seen_dependencies->{$new_dependency_name})
		{
		    # create the dependency in the item

		    &$dependency_creator($item, $new_dependency_name);

		    # remember that we saw this dependency

		    $seen_dependencies->{$new_dependency_name} = $new_dependency_name;

		    # add the dependency to the list of dependencies

		    push @$dependency_names, $new_dependency_name;
		}
	    }
	}
    }
}


=head4 sub packages_validate()

Validate packages as follows:

=over 4

=item Check for double port numbers.

=item Fill in the workspace directory of each package using a default
where necessary.

=item Fill in the name of local repository of each package using a
default where necessary.

=back

=cut

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
		    return "package $first_package_name and $second_package_name have the same version control port number";
		}
	    }
	}

	# if the directory of the package is not set

	my $repository_technology = 'git'; # 'monotone';

	if (not exists $first_package->{directory})
	{
	    # set default

	    my $configurator_branch = $repository_technology eq 'git' ? 'master' : '0';

	    $first_package->{directory} = $ENV{HOME} . "/$new_projects_directory/$first_package_name/source/snapshots/$configurator_branch";

	    $first_package->{directory} =~ s(//)(/)g;
	}

	# if the version control repository filesystem location is not set

	if (not exists $first_package->{version_control}->{repository})
	{
	    # set up a default repository configuration

	    if ($repository_technology eq 'git')
	    {
		$first_package->{version_control}->{repository} = $ENV{HOME} . "/$new_projects_directory/$first_package_name/source/repository";

		$first_package->{version_control}->{repository} =~ s(//)(/)g;
	    }
	    else
	    {
		$first_package->{version_control}->{repository} = $ENV{HOME} . "/neurospaces_project/MTN/$first_package_name.mtn";

		$first_package->{version_control}->{repository} =~ s(//)(/)g;
	    }
	}
    }

    return undef;
}


whole_build_configuration_read();

personal_build_configuration_read();

$default_packages = default_packages_read();

my $error1 = packages_sort($default_packages);

if (defined $error1)
{
    die "$0: *** Error: $error1";
}

my $error2 = packages_validate($default_packages);

if (defined $error2)
{
    die "$0: *** Error: $error2";
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
	name => 'create_directories',
	targets => {
		    content_developer => 1,
		    content_user => 1,
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
	name => 'diff',
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


1;


