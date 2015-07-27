###########################################################################" 
# 
# NAME: Microsoft.PowerShell_profile.ps1 
# 
# AUTHOR: Saint Atique
# EMAIL: unix9n@gmail.com
# 
# COMMENT: Profile Script to make tasks easier
# 
# You have a royalty-free right to use, modify, reproduce, and 
# distribute this script file in any way you find useful, provided that 
# you agree that the creator, owner above has no warranty, obligations, 
# or liability for such use. 
# 
# VERSION HISTORY: 
# 1.0 20.06.2011 - Initial release 
#
# Style followed from Jan Egil Ring
###########################################################################"

# Please change according to your need
$env:homedir = "E:\Scripts"

# get the last part of path
function get-diralias ([string]$loc) {
    # check if we are in our home script dir
    # in that case return grave sign
    if ($loc.Equals($env:homedir)) {
        return "~"
    }
    
    # if it ends with \ that means we are in root of drive
    # in that case return drive
    $lastindex = [int] $loc.lastindexof("\")
    if ($loc.EndsWith("\")) {
        return $loc.Remove($lastindex, 1)
    }
    
    # Otherwise return only the dir name
    $lastindex += 1
    $loc = $loc.Substring($lastindex)
    return $loc
}

# Set prompt
function prompt {
    # because I like to think as matrix :P
    return "[sa@matrix $(get-diralias($(get-location)))]$ "
}

# My intension is to to keep this file smaller
function ss() {
    if ($args.Count -lt 1) {
        return "Please provide correct commandline"
    }
    elseif ($args.Count -eq 1) {
        & "$env:homedir\ss.ps1" $args
    }
    else {
        $cmd = $args[0]
        # echo "cmd: `"$cmd`""
        $cargs = [string]$args
        # echo "cargs: `"$cargs`""
        $cargs = $cargs.TrimStart($cmd)
        $cargs = $cargs.TrimStart()
        # echo "cargs: `"$cargs`""
        & "$env:homedir\ss.ps1" $args[0] $cargs
    }
    
    return ""
}
