#!/usr/bin/perl

use File::Find;

find(
	{
		wanted => sub {
			my $path = $File::Find::name;
			if( $path =~ /\.obj$/ || $path =~ /\.pdb$/ || $path =~ /\.so$/
			 || $path =~ /\.idb$/ || $path =~ /\.res$/ || $path =~ /BuildLog(\w*)\.htm$/i
			 || $path =~ /\.ncb$/ || $path =~ /\.suo$/ || $path =~ /\.exp$/
			 || $path =~ /mt\.dep$/ || $path =~ /\.intermediate\.manifest$/i )
			{
				print "$path\n";
				unlink $path;
			}
		},

		preprocess => sub {
			grep { $_ ne '.svn' } @_;
		},
		
		no_chdir => 1
	},
	'.'
);
