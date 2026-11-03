# Copyright (c) 2026, IvorySQL Global Development Team
use strict;
use warnings FATAL => 'all';

use PostgreSQL::Test::Cluster;
use PostgreSQL::Test::Utils;
use Test::More;

my $node = PostgreSQL::Test::Cluster->new('ivy_out');
$node->init;
$node->start;

foreach my $api ('legacy', 'typed')
{
	foreach my $case (
		['empty', 'rows=0 indicator=-1 value=empty'],
		['null', 'rows=1 indicator=-1 value=null'],
		['value', 'rows=1 indicator=0 value=returned'])
	{
		$node->command_checks_all(
			['libpq_testclient', '--ivy-out', $node->connstr('postgres'),
				$api, $case->[0]],
			0, [qr/^\Q$case->[1]\E$/m], [],
			"$api OUT binding with $case->[0] result");
	}
}

done_testing();
