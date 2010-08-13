#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package Neurospaces::Tester::Comparators;


sub trace_2_array
{
    my $string = shift;

    my $texts = [ split '\n', $string, ];

    my $result = [];

    foreach my $text (@$texts)
    {
	while ($text =~ s/([+-]?\.?\d+(\.[0-9]+)?(e[+-]?[0-9]+)?)/HERE_WAS_A_NUMBER/)
	{
	    my $number = $1;

	    push @$result, $number;
	}
    }

    return $result;
}


sub signal_trace_voltage
{
    my $command_test = shift;

    my $values = shift;

    my $expected_characteristics = shift;

    my $current_diffs = shift;

    my $result = $current_diffs;

    print "*** Checking voltage traces ($command_test->{description})\n";

    # convert the values to an array

    if (!ref $values)
    {
	$values = trace_2_array($values);
    }

    # extract the characteristics from the values

    my $previous_value = undef;

    my $threshold = 0;

    my $seen_characteristics
	= {
	   average => undef,
	   average_count => undef,
	   max => undef,
	   min => undef,
	   spike_count => 0,
	  };

    foreach my $value (@$values)
    {
	# minimum

	if (not defined $seen_characteristics->{min})
	{
	    $seen_characteristics->{min} = $value;
	}
	else
	{
	    if ($value < $seen_characteristics->{min})
	    {
		$seen_characteristics->{min} = $value;
	    }
	}

	# maximum

	if (not defined $seen_characteristics->{max})
	{
	    $seen_characteristics->{max} = $value;
	}
	else
	{
	    if ($value < $seen_characteristics->{max})
	    {
		$seen_characteristics->{max} = $value;
	    }
	}

	# average

	if (not defined $seen_characteristics->{average})
	{
	    $seen_characteristics->{average_count} = 1;

	    $seen_characteristics->{average} = $value;
	}
	else
	{
	    if ($value < $seen_characteristics->{average})
	    {
		$seen_characteristics->{average_count} += 1;

		$seen_characteristics->{average} += $value / $seen_characteristics->{average_count};
	    }
	}

	# spike_count

	if (defined $previous_value)
	{
	    if ($previous_value < $threshold
		and $value >= $threshold)
	    {
		$seen_characteristics->{spike_count}++;
	    }
	}

	$previous_value = $value;
    }

    return $result;
}


sub numerical
{
    my $command_test = shift;

    my $string1 = shift;

    my $string2 = shift;

    my $current_diffs = shift;

    my $result = $current_diffs;

    print "*** Checking numerical values ($command_test->{description})\n";

    if (($string1 eq '' and $string2 ne '')
	or ($string2 eq '' and $string1 ne ''))
    {
	return 'numerical_compare(): one empty string, the other not.';
    }

    my $texts1 = [ split '\n', $string1, ];

    my $numbers1 = [];

    foreach my $text (@$texts1)
    {
	while ($text =~ s/([+-]?\.?\d+(\.[0-9]+)?(e[+-]?[0-9]+)?)/HERE_WAS_A_NUMBER/)
	{
	    my $number = $1;

	    push @$numbers1, $number;
	}
    }

    my $texts2 = [ split '\n', $string2, ];

    my $numbers2 = [];

    foreach my $text (@$texts2)
    {
	while ($text =~ s/([+-]?\.?\d+(\.[0-9]+)?(e[+-]?[0-9]+)?)/HERE_WAS_A_NUMBER/)
	{
	    my $number = $1;

	    push @$numbers2, $number;
	}
    }

    # from here on the default result is no error

    $result = '';

    # and can be overwritten by the next tests

    # line up the numbers expected

    # but the number of numbers must not differ by more than say 5

    my $number_shifts = 5;

    while (scalar @$numbers1 > scalar @$numbers2)
    {
	shift @$numbers1;

	$number_shifts++;

# 	return 'numerical_compare(): different number count, aborting with error';
    }

    while (scalar @$numbers1 < scalar @$numbers2)
    {
	shift @$numbers2;

	$number_shifts++;

# 	return 'numerical_compare(): different number count, aborting with error';
    }

    # we also line up the texts expected

    my $text_shifts = 5;

    while (scalar @$texts1 > scalar @$texts2)
    {
	shift @$texts1;

	$text_shifts++;

# 	return 'numerical_compare(): different text count, aborting with error';
    }

    while (scalar @$texts1 < scalar @$texts2)
    {
	shift @$texts2;

	$text_shifts++;

# 	return 'numerical_compare(): different text count, aborting with error';
    }

    # when we had to do to many textual corrections

    if ($number_shifts < 0
	or $text_shifts < 0)
    {
	# flag this as an error

	return 'numerical_compare(): amount of data expected is to different from amount of seen data (number_shifts is $number_shifts, text_shifts is $text_shifts), aborting with an error';
    }

    # compare the texts between the numbers

    foreach my $index (0 .. $#$texts1)
    {
	if ($texts1->[$index] ne $texts2->[$index])
	{
	    return 'numerical_compare(): texts differ ($texts1->[$index] ne $texts2->[$index]), aborting with an error';
	}
    }

    # numerical compare of numbers

    foreach my $index (0 .. $#$numbers1)
    {
	if ($numbers1->[$index] != $numbers2->[$index])
	{
	    my $diff = $numbers1->[$index] - $numbers2->[$index];

	    #t the 1000 is a bit arbitrary, quite large differences allowed ...

	    if (abs($diff) > abs($numbers1->[$index] / 1000))
	    {
		return 'numerical_compare(): numbers differ above accuracy ($numbers1->[$index] != $numbers2->[$index]), aborting with an error';
	    }
	}
    }

    # return result

    #! if we get here, it means no error

    return $result;
}


1;


