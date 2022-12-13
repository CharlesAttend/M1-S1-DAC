
namespace eval PlugHelp {

    proc controls {} {
	wm title .z "example flags"
        radiobox PlugHelp::flg1 "first flag" "quiet verbose" "-q -v" -v
        fieldsbox PlugHelp::values "parameters" "first second" "0 none"
        radiobox PlugHelp::flg2 "second flag" "slow fast" "-O1 -O6" -O1
    }

    proc command {} {
        return "plughelp [list $::home] $::intype \
	        [list $PlugHelp::values(first)] $PlugHelp::flg1 \
	        $PlugHelp::flg2 [list $PlugHelp::values(second)]"
    }
}
