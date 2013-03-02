#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


=head3

package Neurospaces::Developer::Operations;

=cut


package Neurospaces::Developer::Operations;


package Neurospaces::Developer::Operations::Package::Debian;


sub condition
{
    return $::option_pkg_deb;
}


sub description
{
    return 'Build a debian package';
}


sub implementation
{
    my $package_information = shift;

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

   # change the directory

    chdir $directory;

    my $command = parse_release_tags('pkg-deb');

    operation_execute
	(
	 $operations,
	 {
	  description => $description,
	  keywords => 0,
	  package_name => $package_name,
	 },
	 $command,
	);

    # Debian format:
    #    <name>_<version>-<release>_<architecture>.deb

    # Code isn't needed for now.
    # 		my $deb_prefix = "$package_name" . "_" . "$major.$minor";
		
    # 		if (defined $micro)
    # 		{
    # 		  $deb_prefix .= ".$micro";
    # 		}

    # 		$deb_prefix .= "-$label";

    my $deb = `find $directory | grep $package_name | grep \\\\.deb\$`;
    chomp($deb);

    my $dsc = `find $directory | grep $package_name | grep \\.dsc\$`;
    chomp($dsc);

    my $changes = `find $directory | grep $package_name | grep \\.changes\$`;
    chomp($changes);

    my $build_log = $directory . "/build_debian.log";
    chomp($build_log);

    if (! -e $deb)
    {
	print "Debian package for package $package_name was not created.\n";
    }
    else
    {
	print "Debian package for package $package_name was created: $deb\n";
    }

    if ($::option_pkg_deb_dir)
    {
	if (!-d $::option_pkg_deb_dir)
	{
	    operation_execute
		(
		 $operations,
		 {
		  description => $description,
		  keywords => 0,
		  package_name => $package_name,
		 },
		 [
		  'mkdir', '-p', $::option_pkg_deb_dir,
		 ],
		);
	}

	# Since this produces multiple files we need to place them all into a directory.

	my $deb_dir = $::option_pkg_deb_dir;

	if (!-d $deb_dir)
	{
	    operation_execute
		(
		 $operations,
		 {
		  description => $description,
		  keywords => 0,
		  package_name => $package_name,
		 },
		 [
		  'mkdir', '-p', $deb_dir,
		 ],
		);
	}

	# now we copy over each file built in the debian package build.
	# perform a check for the existence of the file to prevent it from
	# stopping the neurospaces_build script. The build log should always
	# be copied over.

	if (-d $deb_dir)
	{
	    if (-e $deb)
	    {
		operation_execute
		    (
		     $operations,
		     {
		      description => $description,
		      keywords => 0,
		      package_name => $package_name,
		     },
		     [
		      'cp', '-f', $deb, $deb_dir,
		     ],
		    );
	    }

	    if (-e $dsc)
	    {
		operation_execute
		    (
		     $operations,
		     {
		      description => $description,
		      keywords => 0,
		      package_name => $package_name,
		     },
		     [
		      'cp', '-f', $dsc, $deb_dir,
		     ],
		    );
	    }

	    if (-e $changes)
	    {
		operation_execute
		    (
		     $operations,
		     {
		      description => $description,
		      keywords => 0,
		      package_name => $package_name,
		     },
		     [
		      'cp', '-f', $changes, $deb_dir,
		     ],
		    );
	    }

	    my $target_build_log = $deb_dir . "/build_" . $package_name . ".log";

	    if (-e $build_log)
	    {
		operation_execute
		    (
		     $operations,
		     {
		      description => $description,
		      keywords => 0,
		      package_name => $package_name,
		     },
		     [
		      'cp', '-f', $build_log, $target_build_log,
		     ],
		    );
	    }
	}
	else
	{
	    print "Error: Directory $deb_dir could not be created.\n";

	    print "Can't copy deb files.\n";
	}

    }
}


package Neurospaces::Developer::Operations::Package::RPM;


sub condition
{
    return $::option_pkg_rpm;
}


sub description
{
    return 'Build an RPM package';
}


sub implementation
{
    my $package_information = shift;

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    # change the directory

    chdir $directory;

    my $command = parse_release_tags('pkg-rpm');

    operation_execute
	(
	 $operations,
	 {
	  description => $description,
	  keywords => 0,
	  package_name => $package_name,
	 },
	 $command,
	);

    my $pkgdir = $directory . "/RPM_BUILD";

    my @rpmfiles = `find $pkgdir/RPMS | grep $package_name | grep \\.rpm\$`;
    chomp(@rpmfiles);
		
    my $srpmfile = `find $pkgdir/SRPMS | grep $package_name | grep \\.rpm\$`;
    chomp($srpmfile);

    my $build_log = $directory . "/build_rpm.log";
    chomp($build_log);

    if ( @rpmfiles > 0 )
    {

	if (! -e $rpmfiles[0])
	{
	    print "RPM file for package $package_name was not created.\n";

	    return;
	}
	else
	{
	    print "RPM file for package $package_name was created: $rpmfiles[0]\n";
	}
    }

    if ($::option_pkg_rpm_dir)
    {
	# Since this produces multiple files we need to place them all into a directory.

	my $rpm_dir = $::option_pkg_rpm_dir;
		
	if (! -d $rpm_dir)
	{
	    operation_execute
		(
		 $operations,
		 {
		  description => $description,
		  keywords => 0,
		  package_name => $package_name,
		 },
		 [
		  'mkdir', '-p', $rpm_dir,
		 ],
		);
	}

	# copy over each rpm file.

	if (-d $rpm_dir)
	{
	    foreach my $rpmfile(@rpmfiles)
	    {
		if (-e $rpmfile)
		{
		    operation_execute
			(
			 $operations,
			 {
			  description => $description,
			  keywords => 0,
			  package_name => $package_name,
			 },
			 [
			  'cp', '-f', $rpmfile, $rpm_dir,
			 ],
			);
		}
	    }

	    # Assuming we only have one source rpm.

	    if (-e $srpmfile)
	    {
		operation_execute
		    (
		     $operations,
		     {
		      description => $description,
		      keywords => 0,
		      package_name => $package_name,
		     },
		     [
		      'cp', '-f', $srpmfile, $rpm_dir,
		     ],
		    );
	    }

	    my $target_build_log = $rpm_dir . "/build_" . $package_name . ".log";

	    if (-e $build_log)
	    {
		operation_execute
		    (
		     $operations,
		     {
		      description => $description,
		      keywords => 0,
		      package_name => $package_name,
		     },
		     [
		      'cp', '-f', $build_log, $target_build_log,
		     ],
		    );
	    }
	}
	else
	{
	    print "Error: Directory $rpm_dir could not be created.\n";

	    print "Can't copy RPM files.\n";
	}
    }
}


package Neurospaces::Developer::Operations::Package::Tar;


sub condition
{
    return $::option_pkg_tar;
}


sub description
{
    return 'build a source tarball';
}


sub implementation
{
    my $package_information = shift;

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    # change the directory

    chdir $directory;

    my $command = parse_release_tags('dist');

    operation_execute
	(
	 $operations,
	 {
	  description => $description,
	  keywords => 0,
	  package_name => $package_name,
	 },
	 $command,
	);

    # May reuse this code later.
    # 		my $tarball = "$package_name-$major.$minor";
		
    # 		if(defined $micro)
    # 		{
    # 		  $tarball .= ".$micro";
    # 		}

    # 		$tarball .= "-$label.tar.gz";

    #t this type of test cannot work reliably: fi what if multiple tarballs are found?

    # mando 9/17/2010: Added a '-' to the end of the package name to narrow
    # down the hits, only thing that should meet the criteria is a developer tarball.
    # Also added the maxdepth option to ensure it only searched the top level directory.
    # Only way it can fail is if there is more than one developer tarball in the top
    # level directory. Should not happen on cron runs alone since it performs a clean.

    my $tarball = `find $directory -maxdepth 1| grep $package_name- | grep \.tar\.gz\$`;

    chomp($tarball);

    if (! -e $tarball)
    {
	print "Source dist for package $package_name was not created.\n";

	return;
    }
    else
    {
	print "Source dist for package $package_name was created: $tarball\n";
    }

    if ($::option_pkg_tar_dir)
    {
	if (! -d $::option_pkg_tar_dir)
	{
	    operation_execute
		(
		 $operations,
		 {
		  description => $description,
		  keywords => 0,
		  package_name => $package_name,
		 },
		 [
		  'mkdir', '-p', $::option_pkg_tar_dir,
		 ],
		);
	}

	if (-d $::option_pkg_tar_dir)
	{
	    # At this point the tarball exists so we
	    # delete the old tarball before copying over
	    # the new.

	    operation_execute
		(
		 $operations,
		 {
		  description => $description,
		  keywords => 0,
		  package_name => $package_name,
		 },
		 [
		  'rm', '-f', "$::option_pkg_tar_dir/$package_name-*.tar.gz",
		 ],
		);

	    operation_execute
		(
		 $operations,
		 {
		  description => $description,
		  keywords => 0,
		  package_name => $package_name,
		 },
		 [
		  'cp', '-f', $tarball, $::option_pkg_tar_dir,
		 ],
		);
	}
	else
	{
	    print "Error: Directory $::option_pkg_tar_dir could not be created.\n";
	}
    }
}


package Neurospaces::Developer::Operations::Repository::Init;


sub condition
{
    return $::option_repo_init;
}


sub description
{
    return 'initializing repository';
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    #      hg init http://repo-genesis3.cbi.utsa.edu/hg/g-tube ${HOME}/neurospaces_project/g-tube/source/snapshots/0/
    # performs a clone of a repository if the project workspace isn't present.

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    #
    # Check to see if the repository name ends with .mtn, if not we assume it ends
    # in .hg, in which case we don't need the port number since mercurial serves over http.
    #

    if ($repository_name =~ m/^.*\.mtn$/)
    {
	# initialize the repository if necessary

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'test', '-f', $repository_name, '||', 'mtn', '--db', $repository_name, 'db', 'init',
	     ],
	    );
    }
    else
    {
	# 		    my $repo_server = version_control_translate_server($package_information, 'default');

	# MERCURIAL init

	# operations:
	#   initialize the repo:
	#      hg init ${HOME}/neurospaces__project/g-tube/source/snapshots/0
	#
	# Initializes an empty repository
	#
	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'test', '-f', $repository_name, '||', 'hg', 'init', $directory,
	     ],
	    );
    }
}


package Neurospaces::Developer::Operations::Repository::Keys;


sub condition
{
    $::option_repo_keys;
}

sub description
{
    return 'querying repository for public keys';
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    #      hg init http://repo-genesis3.cbi.utsa.edu/hg/g-tube ${HOME}/neurospaces_project/g-tube/source/snapshots/0/
    # performs a clone of a repository if the project workspace isn't present.

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    #
    # Check to see if the repository name ends with .mtn, if not we assume it ends
    # in .hg, in which case we don't need the port number since mercurial serves over http.
    #

    if ($repository_name =~ m/^.*\.mtn$/)
    {
	# initialize the repository if necessary

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'test', '-f', $repository_name, '&&', 'mtn', '--db', $repository_name, 'ls', 'keys',
	     ],
	    );
    }
    else
    {
	# 		    my $repo_server = version_control_translate_server($package_information, 'default');

	# MERCURIAL init

	# operations:
	#   initialize the repo:
	#      hg init ${HOME}/neurospaces__project/g-tube/source/snapshots/0
	#
	# Initializes an empty repository
	#
	# 		    operation_execute
	# 			(
	# 			 $operations,
	# 			 {
	# 			  description => $description,

	# 			  #t always zero here, but I guess this simply depends on working in client mode ?

	# 			  keywords => 0,
	# 			  package_name => $package_name,
	# 			 },
	# 			 [
	# 			  'test', '-f', $repository_name, '||', 'hg', 'init', $directory,
	# 			 ],
	# 			);
    }
}


package Neurospaces::Developer::Operations::Repository::CheckOut;


sub condition
{
    return $::option_repo_co;
}


sub description
{
    return "checkout or update the workspace source code from a local repository";
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    my $port_number = $package_information->{package}->{version_control}->{port_number};

    # if not enough information for checkout

    if (not -f $repository_name and not -d $repository_name)
    {
	die "$0: *** Error: cannot checkout from repository, repository_name not set";
    }

    #t port number commented out, impedes the automated
    #t addition of new software components

    # 		if (not $port_number and $repository_name =~ m/^.*\.mtn$/)
    # 		{
    # 		    die "$0: *** Error: cannot checkout from repository, port_number not set";
    # 		}

    # change the directory

    if (not chdir $directory)
    {
	die "$0: *** Error: cannot change to directory $directory";
    }

    # merge code

    if ($repository_name =~ m/^.*\.mtn$/)
    {
	my $branch_name
	    = (exists $package_information->{package}->{version_control}->{branch_name}
	       ? $package_information->{package}->{version_control}->{branch_name}
	       : $package_name);

	# but only if allowed by the configuration, default is yes

	my $automated_merges = Neurospaces::Developer::Configurator::whole_build_configuration_automated_merges();

	if (Neurospaces::Developer::Configurator::whole_build_configuration_automated_merges())
	{
	    operation_execute
		(
		 $operations,
		 {
		  description => $description,

		  #t always zero here, but I guess this simply depends on working in client mode ?

		  keywords => 0,
		  package_name => $package_name,
		 },
		 [
		  'mtn', '--db', $repository_name, '--branch', $branch_name, 'merge',
		 ],
		);
	}

	# checkout code

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'test', '-d', '_MTN',
	      '||', 'mtn', '--db', $repository_name, '--branch', $branch_name, 'co', '.',
	     ],
	    );

	# update code

	my @update_args;

	my $upstream_version_options = [ '--branch', $branch_name, ];

	if ($::option_upstream_version)
	{
	    $upstream_version_options = [ split /\s/, $::option_upstream_version, ];
	}

	my $monotone_version = monotone_version();

	if ($monotone_version >= 0.45)
	{
	    @update_args = [
			    '/bin/echo', '-n', 'from', 'base_revision_id', ' ',
			    '&&', 'mtn', 'automate', 'get_base_revision_id',
			    '&&', 'mtn', '--db', $repository_name, @$upstream_version_options, 'update','--move-conflicting-paths',
			    '&&', '/bin/echo', '-n', 'to', 'base_revision_id', ' ',
			    '&&', 'mtn', 'automate', 'get_base_revision_id',
			   ];
	}
	else
	{
	    @update_args = [
			    '/bin/echo', '-n', 'from', 'base_revision_id', ' ',
			    '&&', 'mtn', 'automate', 'get_base_revision_id',
			    '&&', 'mtn', '--db', $repository_name, @$upstream_version_options, 'update',
			    '&&', '/bin/echo', '-n', 'to', 'base_revision_id', ' ',
			    '&&', 'mtn', 'automate', 'get_base_revision_id',
			   ];
	}

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     @update_args,
	    );

    }
    else
    {
	# MERCURIAL merge
	# command: hg merge

	#t check first for outstanding changes in the workspace
	#t   if found, die
	#t
	#t then hg merge (as below, puts the result in the workspace)
	#t
	#t automated hg commit (with -C option for checkin comment?)
	#t
	#t then continue with test -d .hg

	# change the directory

	if (not chdir $directory)
	{
	    die "$0: *** Error: cannot change to directory $directory";
	}

	# note: mercurial aborts if there is nothing to merge

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'hg', 'merge', '||', 'true',
	     ],
	    );

	# checkout code

	my $branch_name
	    = (exists $package_information->{package}->{version_control}->{branch_name}
	       ? $package_information->{package}->{version_control}->{branch_name}
	       : $package_name);

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'test', '-d', '.hg',
	      '||', 'hg', 'checkout', '-r', $branch_name,
	     ],
	    );

	# update code

	# MERCURIAL update checkout
	# these two are actually aliased to each other because of how it pulls a workspace.
	# You simply update to a particular revision number.
	# hg update [-r revision]

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'hg', 'update',
	     ],
	    );

    }

}


package Neurospaces::Developer::Operations::Repository::Clone;


sub condition
{
    return (0 and $::option_repo_clone);
}


sub description
{
    return "checkout or update the workspace source code from a remote repository";
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    my $port_number = $package_information->{package}->{version_control}->{port_number};

    # if not enough information for clone

    if (not -f $repository_name and not -d $repository_name)
    {
	die "$0: *** Error: cannot clone from repository, repository_name not set";
    }

    if (not $port_number and $repository_name =~ m/^.*\.mtn$/)
    {
	die "$0: *** Error: cannot clone from repository, port_number not set";
    }

    # change the directory

    if (not chdir $directory)
    {
	die "$0: *** Error: cannot change to directory $directory";
    }

    #
    # Check to see if the repository name ends with .mtn, if not we assume it ends
    # in .hg, in which case we don't need the port number since mercurial serves over http.
    #

    if ($repository_name =~ m/^.*\.mtn$/)
    {
	# initialize the repository if necessary

	#t MONOTONE

	my $port_number = $package_information->{package}->{version_control}->{port_number};

	# create repository directory

	my $repository_directory = $repository_name;

	$repository_directory =~ s((.*)/.*)($1);

	# translate well known names to a routable address

	my $repo_server = version_control_translate_server($package_information, $::option_repo_clone);

	my $branch_name
	    = (exists $package_information->{package}->{version_control}->{branch_name}
	       ? $package_information->{package}->{version_control}->{branch_name}
	       : $package_name);

	# clone the source code in the remote repository

	# monotone

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'mtn', '--db', $repository_name, 'clone', "$repo_server:$port_number", '--branch', $branch_name,
	     ],
	    );

    }
    else
    {

	# MERCURIAL REMOTE CHECKOUT

	#t Mando?
    }
}


package Neurospaces::Developer::Operations::Repository::History;


sub condition
{
    return $::option_repo_history;
}


sub description
{
    return 'asking for past revision information';
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    my $port_number = $package_information->{package}->{version_control}->{port_number};

    # print header

    my $text = "$0: *** package $package_name";

    print "\n\n" . ("-" x length $text) . "\n$text\n";

    # 		# if not enough information for comparing

    # 		if (not -f $repository_name and not -d $repository_name)
    # 		{
    # 		    die "$0: *** Error: cannot compare with repository, repository_name not set";
    # 		}

    # 		if (not $port_number and $repository_name =~ m/^.*\.mtn$/)
    # 		{
    # 		    die "$0: *** Error: cannot compare with repository, port_number not set";
    # 		}

    # change the directory

    my $success = chdir $directory;

    if (!$success)
    {
	die "$0: *** Error: package $package_name cannot change from directory to directory ($directory): $!";
    }

    # construct a default set with information commands

    my $history_sets
	= {
	   #t for MERCURIAL
	   #t hg log

	   log => [ "mtn", "log", "--last", $::option_repo_history_last, ],
	   status => [ 'mtn', 'status', ],
	  };

    # go through all log operations

    foreach my $history_set (
			     qw(
				   status
				   log
			      )
					)
		{
		    # and overwrite with specific commands for this package if applicable

		    #! exists such that a '0' or undef can erase the default history_set command

		    if (exists $package_information->{package}->{version_control}->{commands}->{$history_set})
		    {
			$history_sets->{$history_set}
			    = $package_information->{package}->{version_control}->{commands}->{$history_set};
		    }
		}

		# go through all log operations

		foreach my $history_set (
					 qw(
					       status
					       log
					  )
					)
		{
		    # if the history_set command is defined

		    if ($history_sets->{$history_set})
		    {
			# execute the history_set command

			operation_execute
			    (
			     $operations,
			     {
			      description => "history_set $history_set",

			      #t always zero here, but I guess this simply depends on working in client mode ?

			      keywords => 0,
			      package_name => $package_name,
			     },
			     $history_sets->{$history_set},
			    );
		    }
		}
	    }


package Neurospaces::Developer::Operations::Repository::Pull;


sub condition
{
    return $::option_repo_pull;
}


sub description
{
    return "pulling repository";
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    my $repo_server = version_control_translate_server($package_information, $::option_repo_pull);

    #
    # Check to see if the repository name ends with .mtn, if not we assume it ends
    # in .hg, in which case we don't need the port number since mercurial serves over http.
    #

    if ($repository_name =~ m/^.*\.mtn$/)
    {
	# initialize the repository if necessary

	my $port_number = $package_information->{package}->{version_control}->{port_number};

	# create repository directory

	my $repository_directory = $repository_name;

	$repository_directory =~ s((.*)/.*)($1);

	operation_execute
	    (
	     $operations,
	     {
	      description => "$description (creating repository directory)",

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'mkdir', '-p', $repository_directory,
	     ],
	    );

	operation_execute
	    (
	     $operations,
	     {
	      description => "$description: (initializing the repository)",

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'test', '-f', $repository_name, '||', 'mtn', '--db', $repository_name, 'db', 'init',
	     ],
	    );

	# if not enough information for pulling

	if (not -f $repository_name)
	{
	    die "$0: *** Error: cannot pull repository, repository_name not set";
	}

	if (not $port_number and $repository_name =~ m/^.*\.mtn$/)
	{
	    die "$0: *** Error: cannot pull repository, port_number not set";
	}

	my $branch_name
	    = (exists $package_information->{package}->{version_control}->{branch_name}
	       ? $package_information->{package}->{version_control}->{branch_name}
	       : $package_name);

	# translate well known names to a routable address

	# pull the repository

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'mtn', '--db', $repository_name, 'pull', '--ticker=count', "$repo_server:$port_number", "'$branch_name'",
	     ],
	    );

    }
    else
    {
	# MERCURIAL PULL

	# mercurial server is  http://repo-genesis3.cbi.utsa.edu/hg/g-tube
	# command:
	#   hg pull http://$repo_server/hg/$package_name -R $ENV{HOME}/neurospaces_project/g-tube/source/snapshots/0 --update
	#
		
	if(not -d $repository_name)
	{

	    operation_execute
		(
		 $operations,
		 {
		  description => "$description: (initializing the repository)",
		  keywords => 0,
		  package_name => $package_name,
		 },
		 [
		  'hg', 'init', $directory,
		 ],
		);
	}


	if (not -d $repository_name)
	{
	    die "$0: *** Error: cannot pull repository, $repository_name doesn't exist";
	}

	my $mercurial_server = "http://" . $repo_server . "/hg/" . $package_name;

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,
	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'hg', 'pull', $mercurial_server, '-R', $directory, '--update',
	     ],
	    );

    }
}


package Neurospaces::Developer::Operations::Repository::Push;


sub condition
{
    return $::option_repo_push;
}


sub description
{
    return "pushing repository";
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    my $port_number = $package_information->{package}->{version_control}->{port_number};

    # create repository directory

    my $repository_directory = $repository_name;

    $repository_directory =~ s((.*)/.*)($1);

    operation_execute
	(
	 $operations,
	 {
	  description => "$description (creating repository directory)",

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  'mkdir', '-p', $repository_directory,
	 ],
	);

    # initialize the repository if necessary

    #t MONOTONE

    operation_execute
	(
	 $operations,
	 {
	  description => "$description: (initializing the repository)",

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  'test', '-f', $repository_name, '||', 'mtn', '--db', $repository_name, 'db', 'init',
	 ],
	);

    # if not enough information for pushing

    if (not -f $repository_name and not -d $repository_name)
    {
	die "$0: *** Error: cannot push repository, repository_name not set";
    }

    if (not $port_number and $repository_name =~ m/^.*\.mtn$/)
    {
	die "$0: *** Error: cannot push repository, port_number not set";
    }

    # translate well known names to a routable address

    my $repo_server = version_control_translate_server($package_information, $::option_repo_push);

    my $branch_name
	= (exists $package_information->{package}->{version_control}->{branch_name}
	   ? $package_information->{package}->{version_control}->{branch_name}
	   : $package_name);

    # push the repository

    operation_execute
	(
	 $operations,
	 {
	  description => $description,

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  'mtn', '--db', $repository_name, 'push', '--ticker=count', "$repo_server:$port_number", "'$branch_name'",
	 ],
	);

    # MERCURIAL 
    # hg push http://repo-genesis3.cbi.utsa.edu/hg/g-tube

}


package Neurospaces::Developer::Operations::Repository::Serve;


sub condition
{
    return $::option_repo_serve;
}


sub description
{
    return 'serving source code repositories';
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    my $port_number = $package_information->{package}->{version_control}->{port_number};

    # if not enough information for serving

    if (not -f $repository_name and not -d $repository_name)
    {
	die "$0: *** Error: cannot serve repository, repository_name not set";
    }

    if (not $port_number and $repository_name =~ m/^.*\.mtn$/)
    {
	die "$0: *** Error: cannot serve repository, port_number not set";
    }

    # 		# translate well krnown names to a routable address

    # 		my $repo_server = version_control_translate_server($package_information, $::option_repo_serve);

    # initialize the repository if necessary

    #t MONOTONE

    operation_execute
	(
	 $operations,
	 {
	  description => $description,

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  'test', '-f', $repository_name, '||', 'mtn', '--db', $repository_name, 'db', 'init',
	 ],
	);

    # detach

    my $pid
	= daemonize
	    (1,
	     {
	      message => "$0: daemonizing for $description, $package_name\n",
	      return => 1,
	     },
	    );

    if ($pid ne 1)
    {
	# serve the repository

	# MERCURIAL serve
	# command: hg serve
	# Very different from monotone, uses a simple http gateway to serve the repository
	# and provides a web interface for browsing the code. You can still designate a port
	# like in monotone. The mercurial repository uses a different method for serving
	# the repos.

	#t MONOTONE

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      # 		      'mtn', '--db', $repository_name, 'serve', "$repo_server:$port_number",
	      'mtn', '--db', $repository_name, 'serve', "--bind=0.0.0.0:$port_number",
	     ],
	    );

	# never return

	exit 1;
    }
}


package Neurospaces::Developer::Operations::Repository::Synchronize;


sub condition
{
    return $::option_repo_sync;
}


sub description
{
    return 'syncing repository';
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    # translate well known names to a routable address

    my $repo_server = version_control_translate_server($package_information, $::option_repo_sync);

    #
    # Check to see if the repository name ends with .mtn, if not we assume it ends
    # in .hg, in which case we don't need the port number since mercurial serves over http.
    #

    if ($repository_name =~ m/^.*\.mtn$/)
    {
	# monotone

	my $port_number = $package_information->{package}->{version_control}->{port_number};

	# if not enough information for syncing for monotone

	if (not -f $repository_name)
	{
	    die "$0: *** Error: cannot sync repository, repository not found in the filesystem";
	}

	if (not $port_number and $repository_name =~ m/^.*\.mtn$/)
	{
	    die "$0: *** Error: cannot sync repository, port_number not set";
	}

	# initialize the repository if necessary

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'test', '-f', $repository_name, '||', 'mtn', '--db', $repository_name, 'db', 'init',
	     ],
	    );

	# sync the repository

	my $branch_name
	    = (exists $package_information->{package}->{version_control}->{branch_name}
	       ? $package_information->{package}->{version_control}->{branch_name}
	       : $package_name);

	# monotone

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'mtn', '--db', $repository_name, 'sync', '--ticker=count', "$repo_server:$port_number", $branch_name,
	     ],
	    );
    }
    else
    {
	# MERCURIAL sync

	# operations:
	#      hg pull http://repo-genesis3.cbi.utsa.edu/hg/g-tube -R $ENV{HOME}/neurospaces_project/g-tube/source/snapshots/0/ --update
	#   hg push -R $ENV{HOME}/neurospaces_project/g-tube/source/snapshots/0/

	# performs a clone of a repository if the project workspace isn't present.
	my $mercurial_server = "http://" . $repo_server . "/hg/" . $package_name;

	if (not -d $repository_name)
	{
	    die "$0: *** Error: cannot sync mercurial repository, $repository_name doesn't exist";
	}

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,
	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'test', '-f', $repository_name, '||', 'hg', 'pull', $mercurial_server, '-R', $directory, '--update'
	     ],
	    );

	# then perform a push, a sync must be done in two operations.
	# note: repo-genesis3 uses ssh authentication.
	# This should work if the user has properly set up 
	# mercurial and their ssh key.

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,
	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'hg', 'push', '-R', $directory,
	     ],
	    );
    }
}


package Neurospaces::Developer::Operations::Workspace::CheckIn;


sub condition
{
    return $::option_repo_ci;
}


sub description
{
    return "checkin to a local repository";
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    my $port_number = $package_information->{package}->{version_control}->{port_number};

    # if not enough information for checkout

    if (not -f $repository_name and not -d $repository_name)
    {
	die "$0: *** Error: cannot checkout from repository, repository_name not set";
    }

    if (not $port_number and $repository_name =~ m/^.*\.mtn$/)
    {
	die "$0: *** Error: cannot checkout from repository, port_number not set";
    }

    # change the directory

    if (not chdir $directory)
    {
	die "$0: *** Error: cannot change to directory $directory";
    }

    my $branch_name
	= (exists $package_information->{package}->{version_control}->{branch_name}
	   ? $package_information->{package}->{version_control}->{branch_name}
	   : $package_name);

    # merge code

    #t MERCURIAL merge
    # command: hg merge

    operation_execute
	(
	 $operations,
	 {
	  description => $description,

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  # 		      'test', '-d', '_MTN',
	  # 		      '||',
	  'mtn', '--db', $repository_name, '--branch', $branch_name, 'merge',
	 ],
	);

    # checkin code

    #t MERCURAL commit
    # hg commit

    $branch_name
	= (exists $package_information->{package}->{version_control}->{branch_name}
	   ? $package_information->{package}->{version_control}->{branch_name}
	   : $package_name);

    operation_execute
	(
	 $operations,
	 {
	  description => $description,

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  # 		      'test', '-d', '_MTN',
	  # 		      '||',
	  'mtn', '--db', $repository_name, '--branch', $branch_name, 'ci', '.', '--message', $::option_repo_ci,
	 ],
	);

    # update code

    #t MONOTONE
		
    # MERCURIAL update checkout
    # these two are actually aliased to each other because of how it pulls a workspace.
    # You simply update to a particular revision number.
    # hg update [-r revision]

    my @update_args;

    $branch_name
	= (exists $package_information->{package}->{version_control}->{branch_name}
	   ? $package_information->{package}->{version_control}->{branch_name}
	   : $package_name);

    my $upstream_version_options = [ '--branch', $branch_name, ];

    if ($::option_upstream_version)
    {
	$upstream_version_options = [ split /\s/, $::option_upstream_version, ];
    }

    my $monotone_version = monotone_version();

    if ($monotone_version >= 0.45)
    {
	@update_args = [ 'mtn', 'automate', 'get_base_revision_id',
			 '&&', 'mtn', '--db', $repository_name, @$upstream_version_options, 'update','--move-conflicting-paths', ];
    }
    else
    {
	@update_args = [ 'mtn', 'automate', 'get_base_revision_id',
			 '&&', 'mtn', '--db', $repository_name, @$upstream_version_options, 'update', ];
    }

    operation_execute
	(
	 $operations,
	 {
	  description => $description,

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 @update_args,
	);
}


package Neurospaces::Developer::Operations::Workspace::Directory;


sub condition
{
    return $::option_directories_create;
}


sub description
{
    return "creating directory";
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    # create directory

    operation_execute
	(
	 $operations,
	 {
	  description => $description,

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  'mkdir', '-p', $directory,
	 ],
	);
}


package Neurospaces::Developer::Operations::Workspace::CountCode;


sub condition
{
    return $::option_countcode;
}


sub description
{
    return "count lines, words, characters in the implementation files";
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $filename = $package_information->{filename};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    # change the directory

    chdir $directory;

    # countcode on C implementation files

    operation_execute
	(
	 $operations,
	 {
	  description => $description,

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  'wc', '</dev/null', '2>/dev/null', '`', 'find', '.', '-type', 'f', '-iname', '"*.c"', '-o', '-iname', '"*.h"', '|', 'grep', '-v', '"_Inline"', '`', '||', 'true',
	 ],
	);

    # countcode on perl implementation files

    operation_execute
	(
	 $operations,
	 {
	  description => $description,

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  'wc', '</dev/null', '2>/dev/null', '`', '(', 'find', '.', '-type', 'f', '-iname', '"*.pm"', '&&', 'find', '2>/dev/null', 'perl', '-type', 'f', ')', '|', 'sort', '|', 'uniq', '|', 'grep', '-v', '"~$"', '|', 'grep', '-v', '"_Inline"', '`', '||', 'true',
	 ],
	);

    # countcode on python implementation files

    operation_execute
	(
	 $operations,
	 {
	  description => $description,

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  'wc', '</dev/null', '2>/dev/null', '`', '(', 'find', '.', '-type', 'f', '-iname', '"*.py"', '&&', 'find', '2>/dev/null', 'python', '-type', 'f', ')', '|', 'sort', '|', 'uniq', '|', 'grep', '-v', '"~$"', '|', 'grep', '-v', '"_Inline"', '`', '||', 'true',
	 ],
	);

    # countcode on script files

    operation_execute
	(
	 $operations,
	 {
	  description => $description,

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  'wc', '</dev/null', '2>/dev/null', '2>/dev/null', '`', '(', 'find', '2>/dev/null', 'bin', '-type', 'f', ')', '|', 'sort', '|', 'uniq', '|', 'grep', '-v', '"~$"', '|', 'grep', '-v', '"_Inline"', '`', '||', 'true',
	 ],
	);

    # countcode on ndf implementation files

    operation_execute
	(
	 $operations,
	 {
	  description => $description,

	  #t always zero here, but I guess this simply depends on working in client mode ?

	  keywords => 0,
	  package_name => $package_name,
	 },
	 [
	  'wc', '</dev/null', '2>/dev/null', '`', '(', 'find', '.', '-type', 'f', '-iname', '"*.ndf"', ')', '|', 'sort', '|', 'uniq', '|', 'grep', '-v', '"~$"', '|', 'grep', '-v', '"_Inline"', '`', '||', 'true',
	 ],
	);

}


package Neurospaces::Developer::Operations::Workspace::Difference;


sub condition
{
    return $::option_repo_diff;
}


sub description
{
    return "show workspace differences against the local repository";
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    my $port_number = $package_information->{package}->{version_control}->{port_number};

    # print header

    my $text = "$0: *** package $package_name";

    print "\n\n" . ("-" x length $text) . "\n$text\n";

    # 		# if not enough information for comparing

    # 		if (not -f $repository_name and not -d $repository_name)
    # 		{
    # 		    die "$0: *** Error: cannot compare with repository, repository_name not set";
    # 		}

    # 		if (not $port_number and $repository_name =~ m/^.*\.mtn$/)
    # 		{
    # 		    die "$0: *** Error: cannot compare with repository, port_number not set";
    # 		}

    # change the directory

    my $success = chdir $directory;

    if (!$success)
    {
	die "$0: *** Error: package $package_name cannot change from directory to directory ($directory): $!";
    }

    # construct a default set with information commands

    my $information_sets
	= {
	   #t MERCURIAL
	   #t hg diff

	   diff => [ 'mtn', 'diff', ],
	  };

    # go through all informational operations

    foreach my $information_set (
				 qw(
				       diff
				  )
				)
    {
	# and overwrite with specific commands for this package if applicable

	#! exists such that a '0' or undef can erase the default information_set command

	if (exists $package_information->{package}->{version_control}->{commands}->{$information_set})
	{
	    $information_sets->{$information_set}
		= $package_information->{package}->{version_control}->{commands}->{$information_set};
	}
    }

    # go through all informational operations

    foreach my $information_set (
				 qw(
				       diff
				  )
				)
    {
	# if the information_set command is defined

	if ($information_sets->{$information_set})
	{
	    # execute the information_set command

	    operation_execute
		(
		 $operations,
		 {
		  description => "information_set $information_set",

		  #t always zero here, but I guess this simply depends on working in client mode ?

		  keywords => 0,
		  package_name => $package_name,
		 },
		 $information_sets->{$information_set},
		);
	}
    }
}


package Neurospaces::Developer::Operations::Workspace::Migrate;


sub condition
{
    return $::option_repo_migrate;
}


sub description
{
    return 'migrating monotone repositories to latest schema';
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    #
    # Check to see if the repository name ends with .mtn, if not we assume it ends
    # in .hg, in which case we don't need the port number since mercurial serves over http.
    #

    if ($repository_name =~ m/^.*\.mtn$/)
    {
	# initialize the repository if necessary

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'test', '-f', $repository_name, '&&', 'mtn', '--db', $repository_name, 'db', 'migrate',
	     ],
	    );
    }
		
}


package Neurospaces::Developer::Operations::Workspace::Revert;


sub condition
{
    return $::option_repo_revert;
}


sub description
{
    return 'reverting workspace';
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    # change the directory

    my $current_directory = getcwd();

    if ($::option_verbose > 1)
    {
	print "$0: package $package_name, chdir from ($current_directory) to ($directory)\n";
    }

    my $success = chdir $directory;

    if (!$success)
    {
	die "$0: *** Error: package $package_name cannot change from directory ($current_directory) to directory ($directory): $!";
    }

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    if ($repository_name =~ m/^.*\.mtn$/)
    {
	if (not -f $repository_name)
	{
	    die "$0: *** Error: cannot revert repository, $repository_name doesn't exist";
	}

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,
	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'mtn', 'revert', '.',
	     ],
	    );
    }
    else
    {
	if (not -d $repository_name)
	{
	    die "$0: *** Error: cannot revert mercurial repository, $repository_name doesn't exist";
	}

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,
	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'hg', 'revert', '--all',
	     ],
	    );


    }
		
    # change back to the previous current directory

    $success = chdir $current_directory;

    if (!$success)
    {
	die "$0: *** Error: package $package_name, cannot change from directory ($directory) to directory ($current_directory): $!";
    }
}


package Neurospaces::Developer::Operations::Workspace::Setup;


sub condition
{
    return $::option_repo_setup;
}


sub description
{
    return 'creating the interface between the workspace and the source code repositories';
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    my $port_number = $package_information->{package}->{version_control}->{port_number};

    # if not enough information for serving

    if (not -f $repository_name and not -d $repository_name)
    {
	die "$0: *** Error: cannot find repository, repository_name not set";
    }

    # 		if (not $port_number and $repository_name =~ m/^.*\.mtn$/)
    # 		{
    # 		    die "$0: *** Error: cannot serve repository, port_number not set";
    # 		}

    # change the directory

    if (not chdir $directory)
    {
	die "$0: *** Error: cannot change to directory $directory";
    }

    # 		# translate well krnown names to a routable address

    # 		my $repo_server = version_control_translate_server($package_information, $::option_repo_serve);

    # initialize the interface if necessary

    if ($repository_name =~ m/^.*\.mtn$/)
    {
	# monotone

	my $branch_name
	    = (exists $package_information->{package}->{version_control}->{branch_name}
	       ? $package_information->{package}->{version_control}->{branch_name}
	       : $package_name);

	operation_execute
	    (
	     $operations,
	     {
	      description => $description,

	      #t always zero here, but I guess this simply depends on working in client mode ?

	      keywords => 0,
	      package_name => $package_name,
	     },
	     [
	      'test', '-d', '_MTN', '||', 'mtn', '--db', $repository_name, '--branch', $branch_name, 'setup',
	     ],
	    );
    }
    else
    {
	# MERCURIAL WORKSPACE INITIALIZATION

	#t Mando?
    }
}


package Neurospaces::Developer::Operations::Workspace::Status;


sub condition
{
    return $::option_repo_status;
}


sub description
{
    return 'comparing workspace with source code repository branch head';
}


sub implementation
{
    my $package_information = shift;

    # get specific arguments

    my $description = $package_information->{description};

    my $directory = $package_information->{directory};

    my $operations = $package_information->{operations};

    my $package_name = $package_information->{package_name};

    #t where does this default value come from?  Cannot work correctly?

    my $repository_name
	= $package_information->{package}->{version_control}->{repository}
	    || $directory . '/' . $package_name . '/' . 'mtn';

    my $port_number = $package_information->{package}->{version_control}->{port_number};

    # print header

    my $text = "$0: *** package $package_name";

    print "\n\n" . ("-" x length $text) . "\n$text\n";

    # 		# if not enough information for comparing

    # 		if (not -f $repository_name and not -d $repository_name)
    # 		{
    # 		    die "$0: *** Error: cannot compare with repository, repository_name not set";
    # 		}

    # 		if (not $port_number and $repository_name =~ m/^.*\.mtn$/)
    # 		{
    # 		    die "$0: *** Error: cannot compare with repository, port_number not set";
    # 		}

    # change the directory

    my $success = chdir $directory;

    if (!$success)
    {
	die "$0: *** Error: package $package_name cannot change from directory to directory ($directory): $!";
    }

    # construct a default set with information commands

    my $information_sets
	= {
	   #t MERCURIAL
	   #t hg status

	   missing => [ "mtn", "ls", "missing", ],
	   status => [ 'mtn', 'status', ],
	   unknown => [ "mtn", "ls", "unknown", ],
	  };

    # go through all informational operations

    foreach my $information_set (
				 qw(
				       missing
				       unknown
				       status
				  )
				)
    {
	# and overwrite with specific commands for this package if applicable

	#! exists such that a '0' or undef can erase the default information_set command

	if (exists $package_information->{package}->{version_control}->{commands}->{$information_set})
	{
	    $information_sets->{$information_set}
		= $package_information->{package}->{version_control}->{commands}->{$information_set};
	}
    }

    # go through all informational operations

    foreach my $information_set (
				 qw(
				       status
				       missing
				       unknown
				  )
				)
    {
	# if the information_set command is defined

	if ($information_sets->{$information_set})
	{
	    # execute the information_set command

	    operation_execute
		(
		 $operations,
		 {
		  description => "information_set $information_set",

		  #t always zero here, but I guess this simply depends on working in client mode ?

		  keywords => 0,
		  package_name => $package_name,
		 },
		 $information_sets->{$information_set},
		);
	}
    }
}


package Neurospaces::Developer::Operations;


#
# Returns the monotone version.
#

sub monotone_version
{

  my $tmp = `mtn --version`;

  my @tmp = split(/ /,$tmp);

  return $tmp[1];

}


my $tag_set_in_tag_database = 0;


sub construct_all
{
    my $all_operations
	= [
	   {
	    condition => \&Neurospaces::Developer::Operations::Repository::Init::condition,
	    description => \&Neurospaces::Developer::Operations::Repository::Init::description,
	    operation => \&Neurospaces::Developer::Operations::Repository::Init::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Repository::Keys::condition,
	    description => \&Neurospaces::Developer::Operations::Repository::Keys::description,
	    operation => \&Neurospaces::Developer::Operations::Repository::Keys::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Workspace::Migrate::condition,
	    description => \&Neurospaces::Developer::Operations::Workspace::Migrate::description,
	    operation => \&Neurospaces::Developer::Operations::Workspace::Migrate::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Repository::Serve::condition,
	    description => \&Neurospaces::Developer::Operations::Repository::Serve::description,
	    operation => \&Neurospaces::Developer::Operations::Repository::Serve::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Workspace::Directory::condition,
	    description => \&Neurospaces::Developer::Operations::Workspace::Directory::description,
	    operation => \&Neurospaces::Developer::Operations::Workspace::Directory::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Repository::Pull::condition,
	    description => \&Neurospaces::Developer::Operations::Repository::Pull::description,
	    operation => \&Neurospaces::Developer::Operations::Repository::Pull::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Repository::Push::condition,
	    description => \&Neurospaces::Developer::Operations::Repository::Push::description,
	    operation => \&Neurospaces::Developer::Operations::Repository::Push::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Workspace::Setup::condition,
	    description => \&Neurospaces::Developer::Operations::Workspace::Setup::description,
	    operation => \&Neurospaces::Developer::Operations::Workspace::Setup::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Repository::Clone::condition,
	    description => \&Neurospaces::Developer::Operations::Repository::Clone::description,
	    operation => \&Neurospaces::Developer::Operations::Repository::Clone::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Repository::CheckOut::condition,
	    description => \&Neurospaces::Developer::Operations::Repository::CheckOut::description,
	    operation => \&Neurospaces::Developer::Operations::Repository::CheckOut::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Workspace::Difference::condition,
	    description => \&Neurospaces::Developer::Operations::Workspace::Difference::description,
	    operation => \&Neurospaces::Developer::Operations::Workspace::Difference::implementation,
	   },
	   {
	    condition => $::option_distclean && !$::option_uninstall,
	    operation => [ 'make', 'distclean', ],
	   },
	   {
	    condition => $::option_distkeywords,
	    operation => [
			  #! after keyword expansion, regenerate the
			  #! autotool related files that perhaps are
			  #! checked in.

			  ( 'make', 'dist-keywords', ),
			  ( '&&', 'make', 'clean', ),
			  ( '&&', 'make', 'clean', ),
			 ],
	   },
	   {
	    condition => $::option_tag,
	    operation => [
			  #t MONOTONE

			  # MERCURIAL
			  # hg status
			  # this shows all changed or missing files in the repository. 
			  # doesn't have any exact equivalen to monotones missing or unknown commands.
			  # status essentially does all of it.
			  ( "test", "!", '"`mtn ls unknown && mtn ls missing && mtn ls changed`"', ),
			  ( '&&', 'release-expand', "--package", "'%package'", "--major", "'%release_major'",
			    "--minor", "'%release_minor'", "--micro", "'%release_micro'", "--label",
			    "'%release_major-%release_minor'", "--email",'hugo.cornelis@gmail.com', '--verbose', ),

			  #! after keyword expansion, regenerate the
			  #! autotool related files that perhaps are
			  #! checked in.

			  ( '&&', 'make', 'clean', ),
			  ( '&&', 'make', 'clean', ),
			  # 			  ( "&&", 'mtn', 'ci', "-m", "'1. Keywords only: $::option_tag\n'", ),
			  ( "&&", "test", "!", '"`mtn ls unknown && mtn ls missing`"', ),
			 ],
	   },
	   {
	    condition => $::option_tag,
	    operation => [
			  #t MONOTONE

			  #! in a separate operation such that we have the correct %version
			  #! gets replaced by `mtn automate get_base_revision_id`
			  #! during build variable substitution in sub operation_execute()

			  ( 'mtn', 'tag', '\'%version\'', "'$::option_tag'", ),
			 ],

	    # MERCURIAL
	    # hg tag -m '\'%version\'' $::option_tag
	    # needs to be noted that in mercurial a tag is just an alias for
	    # branch so this may not be what we need here. The arbitrary metadata
	    # system described earlier is probably more in line with what monotone
	    # uses as tags.

	   },
	   {
	    condition => $::option_tag,
	    description => "putting the tag in the tag database",
	    operation =>
	    sub
	    {
		my $package_information = shift;

		# get specific arguments

		my $description = $package_information->{description};

		my $directory = $package_information->{directory};

		my $filename = $package_information->{filename};

		my $package_name = $package_information->{package_name};

		my $url = $package_information->{url};

		# if the tag has already been added for this run

		if ($tag_set_in_tag_database)
		{
		    # return

		    return;
		}

		use YAML;

		my $tag_database_filename = '/etc/neurospaces/tag_database.yml';

		my $tag_database = YAML::LoadFile($tag_database_filename);

		if (!$tag_database)
		{
		    die "$0: *** Error: cannot read $tag_database_filename";
		}

		if ($::option_verbose > 1)
		{
		    print "$0: package $package_name [$description ($::option_tag)] executing\n";
		}

		my $tags = $tag_database->{tags};

		push
		    @$tags,
		    {
		     'date' => `date`,
		     'regex-selector' => $::option_regex_selector,
		     'label' => $::option_tag,
		    };

		YAML::DumpFile($tag_database_filename, $tag_database);

		# we do this at most once per run

		$tag_set_in_tag_database = 1;

		#t do a checkin of the configuration package (contains
		#t the tag_database).
	    },
	   },
	   {
	    condition => $::option_download_server,
	    description => "downloading",
	    operation =>
	    sub
	    {
		my $package_information = shift;

		# get specific arguments

		my $description = $package_information->{description};

		my $directory = $package_information->{directory};

		my $operations = $package_information->{operations};

		my $filename = $package_information->{filename};

		my $package_name = $package_information->{package_name};

		my $url = $package_information->{url};

		# create the directory

		operation_execute
		    (
		     $operations,
		     {
		      description => $description,

		      #t always zero here, but I guess this simply depends on working in client mode ?

		      keywords => 0,
		      package_name => $package_name,
		     },
		     [
		      'mkdir', '-p', $directory,
		     ],
		    );

		if ($::option_verbose > 1)
		{
		    print "$0: package $package_name [$description from $url to $filename] executing\n";
		}

		if ($::option_download_server =~ m(^file://))
		{
		    # create the directory

		    operation_execute
			(
			 $operations,
			 {
			  description => $description,

			  #t always zero here, but I guess this simply depends on working in client mode ?

			  keywords => 0,
			  package_name => $package_name,
			 },
			 [
			  'mkdir', '-p', $directory,
			 ],
			);

		    # copy the tarball

		    operation_execute
			(
			 $operations,
			 {
			  description => $description,

			  #t always zero here, but I guess this simply depends on working in client mode ?

			  keywords => 0,
			  package_name => $package_name,
			 },
			 [
			  'cp', $filename, $directory . $filename,
			 ],
			);

		}
		else
		{
		    # download the package

		    use LWP::Simple;

		    my $http_response = getstore($url, $directory . '/' . $filename);

		    if (!is_success($http_response))
		    {
			warn "$0: *** Warning: $description from $::option_download_server: $http_response";
		    }
		}
	    },
	   },
	   {
	    condition => $::option_download_server || $::option_unpack,
	    description => "unpacking",
	    operation =>
	    sub
	    {
		my $package_information = shift;

		# get specific arguments

		my $description = $package_information->{description};

		my $directory = $package_information->{directory};

		my $filename = $package_information->{filename};

		my $operations = $package_information->{operations};

		my $package_name = $package_information->{package_name};

		# change the directory

		chdir $directory;

		# unpack the package

		operation_execute
		    (
		     $operations,
		     {
		      description => $description,

		      #t always zero here, but I guess this simply depends on working in client mode ?

		      keywords => 0,
		      package_name => $package_name,
		     },
		     [
		      'tar', 'xfvz', $filename,
		     ],
		    );
	    },
	   },

	   # everything that is compilation related needs a configure script, so create it.


	   {
	    condition => $::option_configure || $::option_compile || $::option_check || $::option_install,
	    #
	    # If a change is made to the automake files (Makefile.am and confgiure.ac) that changes
	    # file paths then autogen.sh must be rerun. A previously existing configure file may exist
	    # but the test command prevents a new one from being generated. An error that can stop
	    # a build can occur when autoheader is not rerun.
	    #
	    #	    operation => [ 'test', '-f', './configure', '||', './autogen.sh', ],
	    operation => [ './autogen.sh', ],
	   },
	   {
	    condition => $::option_mac_universal && $::option_configure_with_prefix == 0,
	    operation => [ './configure', '--with-universal', '--disable-dependency-tracking',],
	   },
	   {
	    condition => $::option_configure && $::option_mac_universal == 0 && $::option_configure_with_prefix == 0,
	    operation => [ './configure', ],
	   },

	   # for the luebeck workshop: have a configure prefix different from /usr/local

	   {
	    condition => $::option_configure_with_prefix && $::option_mac_universal == 0,
	    operation => [ './configure', '--prefix', '/usr/local/poolsoft/genesis3',],
	   },

	   # everything that is compilation related needs makefiles, so create them.

	   {
	    condition => $::option_mac_universal || $::option_compile || $::option_check || $::option_install,
	    operation => [ 'test', '-f', './Makefile', '||', './configure', ],
	   },
	   {
	    condition => $::option_clean,
	    operation => [ 'make', 'clean', ],
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Workspace::CountCode::condition,
	    description => \&Neurospaces::Developer::Operations::Workspace::CountCode::description,
	    operation => \&Neurospaces::Developer::Operations::Workspace::CountCode::implementation,
	   },
	   {
	    condition => $::option_compile,
	    operation => [ 'make', ],
	   },
	   {
	    condition => $::option_check,
	    operation => [ 'make', 'check', ],
	   },
	   {
	    condition => $::option_dist,
	    operation => [ 'export', 'NEUROSPACES_RELEASE=1', '&&', 'make', 'dist'],
	   },
	   {
	    condition => $::option_distcheck,
	    operation => [ 'export', 'NEUROSPACES_RELEASE=1', '&&', 'make', 'distcheck', ],
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Package::Debian::condition,
	    description => \&Neurospaces::Developer::Operations::Package::Debian::description,
	    operation => \&Neurospaces::Developer::Operations::Package::Debian::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Package::RPM::condition,
	    description => \&Neurospaces::Developer::Operations::Package::RPM::description,
	    operation => \&Neurospaces::Developer::Operations::Package::RPM::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Package::Tar::condition,
	    description => \&Neurospaces::Developer::Operations::Package::Tar::description,
	    operation => \&Neurospaces::Developer::Operations::Package::Tar::implementation,
	   },
	   {
	    #! always make as the regular user to avoid cluttering the
	    #! source directory with root owned files

	    condition => $::option_compile && !$::option_uninstall && $::option_install,
	    operation => [ 'make', '&&', 'sudo', 'make', 'install', ],
	   },
	   {
	    condition => $::option_docs,
	    operation => [ 'make', 'docs', ],
	   },
	   {
	    condition => $::option_website_prepare,
	    operation => [ 'make', 'website-prepare', ],
	   },
	   {
	    condition => $::option_website_upload,
	    operation => [ 'make', 'html-upload', ],
	   },
	   {
	    condition => $::option_installed_versions,
	    description => 'installed versions',
	    operation =>
	    sub
	    {
		my $package_information = shift;

		my $package = $package_information->{package};

		my $version_script = $package->{version_script};

		if (!defined $version_script)
		{
		    $version_script = "$package_information->{package_name} --version";
		}

		if ($version_script ne 0)
		{
		    system $version_script;
		}
	    },
	   },
	   {
	    condition => $::option_uninstall,
	    operation => [ 'make', 'clean', '&&', 'sudo', 'make', 'uninstall', ],
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Workspace::CheckIn::condition,
	    description => \&Neurospaces::Developer::Operations::Workspace::CheckIn::description,
	    operation => \&Neurospaces::Developer::Operations::Workspace::CheckIn::implementation,
	   },
	   {
	    condition => $::option_upload_server,
	    description => "uploading",
	    operation =>
	    sub
	    {
		my $package_information = shift;

		# get specific arguments

		my $description = $package_information->{description};

		my $directory = $package_information->{directory};

		my $filename = $package_information->{filename};

		my $operations = $package_information->{operations};

		my $package_name = $package_information->{package_name};

		my $url = $package_information->{url};

		if (!$filename)
		{
		    die "$0: *** Error: no filename defined for uploading";
		}

		if ($::option_verbose)
		{
		    print "$0: package $package_name [$description $filename to $::option_upload_server] executing\n";
		}

		# change the directory

		chdir $directory;

		# upload the package

		$::option_upload_server =~ m(((.*)://)?([^/]+)(.*));

		my $upload_protocol = $2 || 'https';

		my $upload_host = $3;

		my $upload_directory = $4;

		my $module_names
		    = {
		       file => '-1',
		       ftp => 'Net::FTP',
		       https => 'HTTP::DAV',
		       sftp => 'Net::SFTP',
		      };

		my $module_name = $module_names->{$upload_protocol};

		my $login_info = YAML::LoadFile("$ENV{HOME}/.sourceforge_login");

		my $user = $login_info->{user};

		my $password = $login_info->{password};

		my $try_something_very_sophisticated_with_broken_libraries = 'no';

		if ($try_something_very_sophisticated_with_broken_libraries eq 'yes')
		{
		    my $loaded_protocol_module = eval "require $module_name";

		    if ($@)
		    {
			no strict "refs";

			if (exists ${"::"}{verbose} && $::option_verbose)
			{
			    print STDERR "$0: cannot load protocol module $module_name because of: $@\n";
			    print STDERR "$0: continuing.\n";
			}
		    }

		    my $ftp;

		    if ($upload_protocol =~ /^s?ftp$/)
		    {
			$ftp
			    = eval "$module_name->new('$upload_host', Debug => 0, user => '$user', password => '$password', )"
				or die "$0: *** Error: for $filename: cannot connect to $upload_host: $@";
		    }
		    else
		    {
			$ftp
			    = eval "HTTP::DAV->new()"
				or die "$0: *** Error: for $filename: cannot connect to $upload_host: $@";

			$ftp->credentials
			    (
			     -user=> $user,
			     -pass => $password,
			     -url => $::option_upload_server,
			    );

			$ftp->open( -url=> $::option_upload_server, )
			    or die("$0: *** Error: cannot open $::option_upload_server: " . $ftp->message() . "\n");
		    }

		    # 		    $ftp->login("anonymous", '-anonymous@')
		    # 			or die "$0: *** Error: for $filename: cannot login to $upload_host", $ftp->message();

		    $ftp->cwd($upload_directory)
			or die "$0: *** Error: for $filename: cannot change working directory to $upload_directory", $ftp->message();

		    if ($upload_protocol =~ /^s?ftp$/)
		    {
			$ftp->binary()
			    or die "$0: *** Error: for $filename: cannot switch to binary ftp mode", $ftp->message();

			$ftp->hash()
			    or die "$0: *** Error: for $filename: cannot enable hash printing", $ftp->message();
		    }

		    $ftp->put($filename)
			or die "$0: *** Error: for $filename: Net::FTP::put() failed ", $ftp->message();

		    if ($upload_protocol =~ /^s?ftp$/)
		    {
			$ftp->quit();
		    }
		    else
		    {
			$ftp->unlock();
		    }
		}

		# else we are trying a hardcoded solution that should work

		else
		{
		    if ($upload_protocol eq 'sftp')
		    {
			use Expect;

			my $expector = Expect->new();

			#! see the expect manual for this one

			$expector->raw_pty(1);

			$expector->spawn('sftp', "$user\@$upload_host",)
			    or die "$0: cannot spawn 'sftp': $!\n";

			my ($matched_pattern_position,
			    $error,
			    $successfully_matching_string,
			    $before_match,
			    $after_match)
			    = $expector->expect(15, "word:", );

			$expector->send("$password\n");

			my $prompt = "sftp>";

			($matched_pattern_position,
			 $error,
			 $successfully_matching_string,
			 $before_match,
			 $after_match)
			    = $expector->expect(5, $prompt, );

			$upload_directory =~ s|^/||;

			$expector->send("cd $upload_directory\n");

			($matched_pattern_position,
			 $error,
			 $successfully_matching_string,
			 $before_match,
			 $after_match)
			    = $expector->expect(5, $prompt, );

			$expector->send("put '$filename'\n");

			($matched_pattern_position,
			 $error,
			 $successfully_matching_string,
			 $before_match,
			 $after_match)
			    = $expector->expect(600, $prompt, );

			$expector->send("quit\n");
		    }
		    elsif ($upload_protocol eq 'file')
		    {
			# construct the target directory

			my $target_directory = $upload_host . $upload_directory;

			# make sure the target directory is rooted

			if ($target_directory !~ /^\//)
			{
			    $target_directory = "/$target_directory";
			}

			# create the directory

			operation_execute
			    (
			     $operations,
			     {
			      description => $description,

			      #t always zero here, but I guess this simply depends on working in client mode ?

			      keywords => 0,
			      package_name => $package_name,
			     },
			     [
			      'mkdir', '-p', $target_directory,
			     ],
			    );

			# copy the tarball

			operation_execute
			    (
			     $operations,
			     {
			      description => $description,

			      #t always zero here, but I guess this simply depends on working in client mode ?

			      keywords => 0,
			      package_name => $package_name,
			     },
			     [
			      'cp', $filename, $target_directory,
			     ],
			    );

		    }
		    else
		    {
			die "$0: *** Error: unknown upload protocol $upload_protocol";
		    }
		}
	    },
	   },
	   {
	    condition => (scalar @$::option_dist_dir),
	    description => "copying files to the distribution directories",
	    operation =>
	    sub
	    {
		my $package_information = shift;

		# get specific arguments

		my $description = $package_information->{description};

		my $directory = $package_information->{directory};

		my $filename = $package_information->{filename};

		my $operations = $package_information->{operations};

		my $package_name = $package_information->{package_name};

		my $url = $package_information->{url};

		if (!$filename)
		{
		    die "$0: *** Error: no filename defined to copy to the distribution directories";
		}

		# change the directory

		chdir $directory;

		foreach my $dist_dir (@$::option_dist_dir)
		{
		    # create directory

		    if (!-d $dist_dir)
		    {
			operation_execute
			    (
			     $operations,
			     {
			      description => $description,

			      #t always zero here, but I guess this simply depends on working in client mode ?

			      keywords => 0,
			      package_name => $package_name,
			     },
			     [
			      'mkdir', '-p', $dist_dir,
			     ],
			    );
		    }

		    # copy the package

		    operation_execute
			(
			 $operations,
			 {
			  description => $description,

			  #t always zero here

			  keywords => 0,
			  package_name => $package_name,
			 },
			 [
			  'cp', $filename, $dist_dir,
			 ],
			);
		}
	    },
	   },
	   {
	    condition => $::option_certification_report,

	    #t MONOTONE

	    operation => [ 'mtn', 'cert', '\'%version\'', '--', 'build_report', '\'%report\'', ],

	    # MERCURIAL cert
	    # mercurial doesn't yet have it's own cert functionality. 
	    # It's on a TODO, more info here: http://mercurial.selenic.com/wiki/ArbitraryMetadata
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Workspace::Status::condition,
	    description => \&Neurospaces::Developer::Operations::Workspace::Status::description,
	    operation => \&Neurospaces::Developer::Operations::Workspace::Status::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Repository::History::condition,
	    description => \&Neurospaces::Developer::Operations::Repository::History::description,
	    operation => \&Neurospaces::Developer::Operations::Repository::History::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Workspace::Revert::condition,
	    description => \&Neurospaces::Developer::Operations::Workspace::Revert::description,
	    operation => \&Neurospaces::Developer::Operations::Workspace::Revert::implementation,
	   },
	   {
	    condition => \&Neurospaces::Developer::Operations::Repository::Synchronize::condition,
	    description => \&Neurospaces::Developer::Operations::Repository::Synchronize::description,
	    operation => \&Neurospaces::Developer::Operations::Repository::Synchronize::implementation,
	   },
	  ];
   }


1;


