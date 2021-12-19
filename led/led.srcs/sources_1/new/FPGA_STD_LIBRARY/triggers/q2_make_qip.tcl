#!/bin/sh
#\
exec tclsh "$0" "$@"

#
# Making quartus <file>.qip file
# There are 2 way to usage: 1- run with intput parameters, 2- run with internal parameters
# Parameters:
#   <file_name> - output file name
#   <path>      - path to find files (valid range: "./" or "./ core" or "core1 ../core2", etc.)
#
# Example usage:
#  q2_make_qip.tcl all.qip ./
#  q2_make_qip.tcl all.qip "./ ../core2"
#  source q2_make_qip.tcl                           (for example from Quartus tcl console)
#  exec tclsh q2_make_qip.tcl all.qip "./ ../core2" (for example from Quartus tcl console)
#  or edit code: EDIT HERE...END; and run q2_make_qip.tcl
#

if {[llength $argv]>0} {
	puts "-------------------------------------------------------"
	puts "Input parameters:"
	set  file_name [lindex $argv 0]
	set  path      [lindex $argv 1]
	puts " file name : '$file_name'"
	puts " path      : '$path'"
} else {
	# EDIT HERE:
	set file_name	"std_triggers.qip"
	set path		"./"
	# END;
}

set p_file		[open $file_name w]
set cnt			0

#foreach i [ glob -nocomplain $path/$pattern ] {
proc find {file_name path pattern key_word  } {
	foreach i [ glob -nocomplain $pattern ] {
		if {$i != $file_name} {
			puts $::p_file "set_global_assignment -name $key_word \[file join \$::quartus(qip_path) \"$i\"\]"
		}
		global cnt
		incr cnt
	}
}

proc find_in_path {file_name path } {
	find  $file_name $path *.sv   SYSTEMVERILOG_FILE
	find  $file_name $path *.svh  SYSTEMVERILOG_FILE
	find  $file_name $path *.v    VERILOG_FILE
	find  $file_name $path *.sdc  SDC_FILE
	find  $file_name $path *.vhd  VHDL_FILE
	find  $file_name $path *.vhdl VHDL_FILE
	find  $file_name $path *.tdf  AHDL_FILE
    find  $file_name $path *.qip  QIP_FILE
}

foreach p $path {
	find_in_path $file_name $p
	puts $::p_file ""
}


close $p_file
puts "-------------------------------------------------------"
puts " Find $cnt files"
puts " Making file '$file_name'"
puts " Press 'Enter' to exit ..."
gets stdin