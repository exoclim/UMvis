#!/usr/bin/perl
use strict; 

my $P=1;

print "T_IRO = 1759K \n"; 

# Calculate temperatures at depths greater than 10 bar. 
print "T_night deeper than 10 bar is ";
my $Tnight=5529.7168 - 6869.6504*$P + 4142.7231*($P**2) - 936.23053*($P**3) + 87.120975*($P**4);
print "$Tnight K\n";
print "T_day deeper than 10 bar is identical to T_night\n";

# Now calculate temperatures at depths less than 10 bar (radiative regime)
$Tnight = 1388.2145 + 267.66586*$P - 215.53357*($P**2) + 61.814807*($P**3) + 135.68661*($P**4) + 2.0149044*($P**5) - 40.907246*($P**6) 
- 19.015628*($P**7) - 3.8771634*($P**8) - 0.38413901*($P**9) - 0.015089084*($P**10);
print "T_night at 10 bar is ";
print "$Tnight K\n";

my $Tday = 2149.9581 + 4.1395571*$P - 186.24851*($P**2) + 135.52524*($P**3)+ 106.20433*($P**4) - 35.851966*($P**5) -50.022826*($P**6) 
- 18.462489*($P**7) - 3.3319965*($P**8) - 0.30295925*($P**9) - 0.011122316*($P**10); 
print "T_day at 10 bar is ";
print "$Tday K\n";

