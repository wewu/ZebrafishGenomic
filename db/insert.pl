#!perl

@arr = &read_file("ipi_v3.59.dat");
my $len = @arr;
write_file("out.wri", "");

for (my $i = 0; $i < $len; $i++)
{
   $arr[$i] =~ s/\'/\\\'/g;
}

show("start");
$i = 0;
while ($i < $len)
{
   my ($ipi, $end, $oneipistr) = &get_one_ipi($i);
show ("$ipi");

   append_file("out.wri", "insert into bioentry_records values (0, '$oneipistr', '$ipi');");
   $i = $end + 1;
}

show("\nupdate bioentry_records a, bioentries b  set a.bioentry_id = b.id where a.ipi = b.accession;");

sub get_one_ipi
{
   my ($j) = @_;
   my $ipi = "";
   my @barr = "";
   my $k = 0;

   while ($arr[$j] ne "//")
   {
      if ($arr[$j] =~ /ID\s+(IPI\d+)\.\d\s+IPI;\s+PRT/)
      {
         $ipi = $1;
      }
      $barr[$k++] = $arr[$j++];
   }
   
   my $bstr = &comb_arr("\\n", @barr);
   ($ipi, $j, $bstr);
}


## ==========================
sub read_file
{
   my ($fname) = @_;
   
   open (Fmsg, "< $fname" ) || print("\t\tCan't open $fname file!\n");
   my @fmsg = <Fmsg>;
   my $len = @fmsg;

   for (my $i=0; $i<$len; $i++)
   {
      chomp($fmsg[$i]);
   }
   close Fmsg;
   @fmsg; 
}

sub write_file
{
   my ($fname, $msg) = @_;
   open (Fmsg, "> $fname" ) || print("Can't write $fname file!\n");
   if (length($msg)>0)
   {   
      print Fmsg "$msg\n";
   }
   close Fmsg;
}

sub comb_arr
{ 
   my ($sep, @arr) = @_;
   my $str = "";
   my $len = @arr;

   if ($len > 0)
   {
      $str = $arr[0];
   }
   for (my $y=1; $y<$len; $y++)
   {
      $str = $str.$sep.$arr[$y];
   }
   $str;
}
sub append_file
{
   my ($fname, $msg) = @_;
   open (Fmsg, ">> $fname" ) || print_and_append_log("Can't append $fname file1!\n");
   if (length($msg)>0)
   {   
      print Fmsg "$msg\n";
   }
   close Fmsg;
}

sub show_arr
{
   my ($name, @arr) = @_;
   my $len = @arr;
   
   print "$name\t";
   for (my $k=0; $k<$len; $k++)
   {
      print "$k->$arr[$k]; ";
   }
   print "\n";
}

sub show
{
   my ($str) = @_;
   print "\n$str\n";
}

