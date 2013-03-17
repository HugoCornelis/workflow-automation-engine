#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


=head3

package Neurospaces::Developer::Packages;

Functionality for building list of selected Neurospaces packages.

=cut


package Neurospaces::Developer::Packages;


sub unique(@);


=head4 sub packages_by_tags()

Enumerate packages given a series of tags.  The result is a list
reference consisting of hashes that describe a package each.

=cut

sub packages_by_tags
{
    my $active_tags = shift;

    my $package_include_disabled = shift;

    if (scalar @$active_tags)
    {
    }
    else
    {
	push @$active_tags, "ZZZZZZZZ";
    }

    my $command = "neurospaces_repositories " . (join ' ', map  { '--package-tags "' . $_ . '"' } @$active_tags) . ($package_include_disabled ? " --package-disabled-included" : "");

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

    return $packages;
}


=head4 sub packages()

Enumerate all packages.  The result is a list reference consisting of
hashes that describe a package each.

Note: this sub should not be used anymore, instead, use packages_all()

=cut

sub packages
{
    my $all_info = shift;

    if (defined $all_info)
    {
	return(packages_all());
    }
    else
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
}


=head4 sub packages_all()

Enumerate all packages.  The result is a list reference consisting of
hashes that describe a package each.

Note: this sub should not be used anymore, instead, use packages_all()

=cut

sub packages_all
{
    my $result = $Neurospaces::Developer::Configurator::default_packages;

    return($result);
}


=head4 sub package_tags()

Enumerate all tags found in all the enabled packages.  The result is a
hash reference where the keys are the tag names.

=cut

sub package_tags
{
    my $packages = Neurospaces::Developer::Packages::packages();

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


1;


