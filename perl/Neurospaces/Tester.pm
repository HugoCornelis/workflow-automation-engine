#!/usr/bin/perl -w
#!/usr/bin/perl -d:ptkdb -w
#


use strict;


package Neurospaces::Tester::Comparators;


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


