# Date: 06/20/2011 00:07:45
# Author: Saint Atique

if ($args.Count -lt 1) {
    echo "Please provide correct commandline"
}

# Message ID represents correction of syntax, that means how much
# lazy can we remain without modifying the string and we call this
# superstition as spirit, just for fun!
$msgid = 0

# cmd is only program command whereas cargs only args
$cmd = [string] $args[0]

# switch starts, alphabetical order
# ss cd: go home
if ($cmd.Equals("cd")) {
    cd $env:homedir
    break
}

# ss ep: edit profile
if ($cmd.Equals("ep")) {
    echo "File: $env:homedir\Microsoft.PowerShell_profile.ps1"
    & $env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell_ise.exe $env:homedir\Microsoft.PowerShell_profile.ps1
    break
}

# ss ise: call powershell_ise editor
if ($cmd.ToLower().Equals("ise")) {
    $cargs = [string]$args[1]
    
    $cpath = $cargs
    # if the file 
    if ($cargs.IndexOf("\") -eq "-1") {
        $cpath =$(get-location).path+"\$cargs"
    }
    elseif ($cargs.StartsWith("..\")) {
        $cpath =$(get-location).path
        $cpath =$cpath.Substring(0, $cpath.LastIndexOf("\"))
        $cpath +=$cargs.TrimStart("..")
    } 
    elseif ($cargs.StartsWith(".\")) {
        $cpath =$(get-location).path+$cargs.TrimStart(".")
    }
    
    if (Test-Path $cpath) {
        # echo "1. Path: $cpath"
        & $env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell_ise.exe $cpath
    }
    else {
        echo "Creating File $cpath as it does not exist."
        echo "# Date: $(get-date)"> $cpath
        echo "# Author: $env:USERNAME">> $cpath
        & $env:SystemRoot\system32\WindowsPowerShell\v1.0\powershell_ise.exe $cpath
    }
    break
}

# ss list-programs: list available registry programs
if ($cmd.ToLower().Equals("list-programs")) {
    ls "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths"
    break
}
# switch ends

if ($args.Count -gt 1) {
    $cargs = [string] $args
    $cargs = $cargs.TrimStart($cmd)
    $cargs = $cargs.TrimStart()
    if ($cargs.StartsWith(".\")) {
        $cargs = $cargs.TrimStart(".\")
    }
}
else {
    $cargs = "";
}

$origcmd = $cmd

if ($cmd.StartsWith(".\") -or $cmd.StartsWith("./")) {
    $msgid += 1
}
elseif ($cmd.IndexOf("\") -eq "-1") {
        $cmd = ".\" + $cmd
}

#if ($cmd.EndsWith(".ps1") -or $cmd.EndsWith(".cmd") -or $cmd.EndsWith(".bat")) {
if ($cmd.EndsWith(".ps1")) {
    $msgid = $msgid + 2
}

if ($msgid -eq 0) {
    # write.exe resolved a space was being added garbage
    # $regitem = dir "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" -recurse -include *notepad* | Select-Object -first 1
    # dir "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths" -recurse -include *notepad* | Select-Object -first 1
    if (Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$cmd.exe") {
        echo "Starting program $origcmd"
        $regitem = Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\$cmd.exe"
        # Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\notepad++.exe"
        $regcmd = $regitem."(default)"
        # Modify the command so that arguments don't get splitted
        $regcmd = $regcmd.TrimStart("`"")
        $regcmd = $regcmd.TrimEnd("`"")
        & "$regcmd" $cargs
        break
    }
    elseif (!(Test-Path "$env:homedir\$cmd.ps1")) {
        echo "Please check your command"
        break
    }
    
}
elseif ($msgid -eq 1) {
    echo "* Spirited syntax"
}
elseif ($msgid -eq 3) {
    echo "* Spirited syntax *"
}

& $env:homedir\$cmd $cargs
