" Filename:     systemd.vim
" Purpose:      Vim syntax file
" Language:     systemd unit files
" Maintainer:   Will Woods <wwoods@redhat.com>
" Last Change:  Sep 15, 2011

if exists("b:current_syntax") && !exists ("g:syntax_debug")
  finish
endif

syn case match
syntax sync fromstart
setlocal iskeyword+=-

" special sequences, common data types, comments, includes {{{1
" hilight errors with this
syn match sdErr contained /\s*\S\+/ nextgroup=sdErr
" this doesn't set nextgroup - useful for list items
syn match sdErrItem contained /\S\+/ contains=sdErr

" environment args and format strings
syn match sdEnvArg    contained /\$\i\+\|\${\i\+}/
syn match sdFormatStr contained /%[bCEfhHiIjJLmnNpPsStTgGuUvV%]/ containedin=ALLBUT,sdComment,sdErr

" common data types
syn match sdUInt     contained nextgroup=sdErr /\d\+/
syn match sdInt      contained nextgroup=sdErr /-\=\d\+/
syn match sdOctal    contained nextgroup=sdErr /0\o\{3,4}/
syn match sdByteVal  contained /\<\%(\d\|\d\d\|1\d\d\|2[0-4]\d\|25[0-5]\)\>/

" sdDuration, sdCalendar: see systemd.time(7)
syn match sdDuration contained nextgroup=sdErr /\d\+/
syn match sdDuration contained nextgroup=sdErr /\%(\d\+\s*\%(usec\|msec\|seconds\=\|minutes\=\|hours\=\|days\=\|weeks\=\|months\=\|years\=\|us\|ms\|sec\|min\|hr\|[smhdwMy]\)\s*\)\+/

" todo: make these not case-sensitive
syn keyword sdCalendarDayNames Monday Tuesday Wednesday Thursday Friday Saturday Sunday Mon Tue Wed Thu Fri Sat Sun
syn keyword sdCalendarInterval minutely hourly daily monthly weekly yearly quarterly semiannually
syn match sdCalendarDays contained /\i\+\,\=\|\i\+\.\.\i\+\,\=/ contains=sdCalendarDayNames,sdErr
syn match sdCalendarRepeat contained /\/\d\+\%(\.\d\+\)\=/
syn match sdCalendarSep  contained /[,~:-]\|../
syn match sdCalendarYear contained /\d{4}\|\*/
syn match sdCalendarMonth contained /0\=[1-9]\|1[012]\|*/
syn match sdCalendarDay contained /0\=[1-9]\|12[0-9]\|3[01]\|*/
syn match sdCalendarHour contained /[01]\=[0-9]\|2[0-4]\|*/
syn match sdCalendarMinute contained /[0-5]\=[0-9]\|*/
syn match sdCalendarSecond contained /\%([0-5]\=[0-9]\|60\)\%(\.\d+\)\=\|\*/
syn match sdCalendarTZ contained /UTC\|\i\+\/\i\+/
syn match sdCalendar contained /\%([A-Za-z,.]\+\s+\)\=\%([0-9*.,/-]\+\%(\s\+[0-9*.,/:]\+\)\=\|[0-9*.,/:]\+\)\%(\s\+\w\+\/\w\+\)/

" Calendar examples, from systemd.time(7)
"              Sat,Thu,Mon..Wed,Sat..Sun → Mon..Thu,Sat,Sun *-*-* 00:00:00
"                  Mon,Sun 12-*-* 2,1:23 → Mon,Sun 2012-*-* 01,02:23:00
"                                Wed *-1 → Wed *-*-01 00:00:00
"                       Wed..Wed,Wed *-1 → Wed *-*-01 00:00:00
"                             Wed, 17:48 → Wed *-*-* 17:48:00
"            Wed..Sat,Tue 12-10-15 1:2:3 → Tue..Sat 2012-10-15 01:02:03
"                            *-*-7 0:0:0 → *-*-07 00:00:00
"                                  10-15 → *-10-15 00:00:00
"                    monday *-12-* 17:00 → Mon *-12-* 17:00:00
"              Mon,Fri *-*-3,1,2 *:30:45 → Mon,Fri *-*-01,02,03 *:30:45
"                   12,14,13,12:20,10,30 → *-*-* 12,13,14:10,20,30:00
"                        12..14:10,20,30 → *-*-* 12..14:10,20,30:00
"              mon,fri *-1/2-1,3 *:30:45 → Mon,Fri *-01/2-01,03 *:30:45
"                         03-05 08:05:40 → *-03-05 08:05:40
"                               08:05:40 → *-*-* 08:05:40
"                                  05:40 → *-*-* 05:40:00
"                 Sat,Sun 12-05 08:05:40 → Sat,Sun *-12-05 08:05:40
"                       Sat,Sun 08:05:40 → Sat,Sun *-*-* 08:05:40
"                       2003-03-05 05:40 → 2003-03-05 05:40:00
"             05:40:23.4200004/3.1700005 → *-*-* 05:40:23.420000/3.170001
"                         2003-02..04-05 → 2003-02..04-05 00:00:00
"                   2003-03-05 05:40 UTC → 2003-03-05 05:40:00 UTC
"                             2003-03-05 → 2003-03-05 00:00:00
"                                  03-05 → *-03-05 00:00:00
"                                 hourly → *-*-* *:00:00
"                                  daily → *-*-* 00:00:00
"                              daily UTC → *-*-* 00:00:00 UTC
"                                monthly → *-*-01 00:00:00
"                                 weekly → Mon *-*-* 00:00:00
"                weekly Pacific/Auckland → Mon *-*-* 00:00:00 Pacific/Auckland
"                                 yearly → *-01-01 00:00:00
"                               annually → *-01-01 00:00:00
"                                  *:2/3 → *-*-* *:02/3:00


syn match sdDatasize contained nextgroup=sdErr /\d\+[KMGT]/
syn match sdFilename contained nextgroup=sdErr /\/\S*/
syn match sdPercent  contained nextgroup=sdErr /\d\+%/
syn keyword sdBool   contained nextgroup=sdErr 1 yes true on 0 no false off
syn match sdUnitName contained /\S\+\.\(automount\|mount\|swap\|socket\|service\|target\|path\|timer\|device\|slice\|scope\)\_s/

" Signal names generated with:
"   echo $(bash -c 'kill -l' | grep -o 'SIG[A-Z0-9]\+' | uniq)
syn keyword sdSignalName contained SIGHUP SIGINT SIGQUIT SIGILL SIGTRAP SIGABRT SIGBUS SIGFPE SIGKILL SIGUSR1 SIGSEGV SIGUSR2 SIGPIPE SIGALRM SIGTERM SIGSTKFLT SIGCHLD SIGCONT SIGSTOP SIGTSTP SIGTTIN SIGTTOU SIGURG SIGXCPU SIGXFSZ SIGVTALRM SIGPROF SIGWINCH SIGIO SIGPWR SIGSYS SIGRTMIN SIGRTMAX
syn match sdSignal     /SIG\w\+/ contained contains=sdSignalName,sdErr nextgroup=sdErr
syn match sdSignalList /.\+/     contained contains=sdSignalName,sdByteVal,sdErrItem

" generated with: echo $(systemd-analyze exit-status | awk '/[0-9]/ { print $1 }')
syn keyword sdExitStatusName contained SUCCESS FAILURE INVALIDARGUMENT NOTIMPLEMENTED NOPERMISSION NOTINSTALLED NOTCONFIGURED NOTRUNNING USAGE DATAERR NOINPUT NOUSER NOHOST UNAVAILABLE SOFTWARE OSERR OSFILE CANTCREAT IOERR TEMPFAIL PROTOCOL NOPERM CONFIG CHDIR NICE FDS EXEC MEMORY LIMITS OOM_ADJUST SIGNAL_MASK STDIN STDOUT CHROOT IOPRIO TIMERSLACK SECUREBITS SETSCHEDULER CPUAFFINITY GROUP USER CAPABILITIES CGROUP SETSID CONFIRM STDERR PAM NETWORK NAMESPACE NO_NEW_PRIVILEGES SECCOMP SELINUX_CONTEXT PERSONALITY APPARMOR ADDRESS_FAMILIES RUNTIME_DIRECTORY CHOWN SMACK_PROCESS_LABEL KEYRING STATE_DIRECTORY CACHE_DIRECTORY LOGS_DIRECTORY CONFIGURATION_DIRECTORY NUMA_POLICY CREDENTIALS BPF EXCEPTION
syn match sdExitStatusNum  /\d\+/ contained contains=sdByteVal nextgroup=sdErr
syn match sdExitStatus     /\S\+/ contained contains=sdExitStatusName,sdExitStatusNum nextgroup=sdErr
syn match sdExitStatusList /.*/   contained contains=sdExitStatusName,sdSignalName,sdByteVal,sdErrItem

" type identifiers used in `systemd --dump-config`, from most to least common:
" 189 OTHER
" 179 BOOLEAN
" 136 LIMIT
"  46 CONDITION
"  36 WEIGHT
"  30 MODE
"  27 PATH
"  25 PATH [...]
"  24 SECONDS, STRING
"  20 SIGNAL
"  15 UNIT [...]
"  12 BANDWIDTH, DEVICEWEIGHT, SHARES, UNSIGNED
"  11 PATH [ARGUMENT [...]]
"   8 BOUNDINGSET, LEVEL, OUTPUT, PATH[:PATH[:OPTIONS]] [...], SOCKET [...]
"   6 ACTION, DEVICE, DEVICELATENCY, POLICY, SLICE, TIMER
"   5 KILLMODE
"   4 ARCHS, CPUAFFINITY, CPUSCHEDPOLICY, CPUSCHEDPRIO, ENVIRON, ERRNO, FACILITY, FAMILIES, FILE, INPUT, IOCLASS, IOPRIORITY, LABEL, MOUNTFLAG [...], NAMESPACES, NANOSECONDS, NICE, NOTSUPPORTED, OOMSCOREADJUST, PERSONALITY, SECUREBITS, SYSCALLS
"   3 INTEGER, SIZE, STATUS
"   2 LONG, UNIT
"   1 ACCESS, NETWORKINTERFACE, SERVICE, SERVICERESTART, SERVICETYPE, SOCKETBIND, SOCKETS, TOS, URL


" .include
syn match sdInclude /^.include/ nextgroup=sdFilename

" comments
syn match   sdComment /^[;#].*/ contains=sdTodo containedin=ALL
syn keyword sdTodo contained TODO XXX FIXME NOTE

" [Unit] {{{1
" see systemd.unit(5)
syn region sdUnitBlock matchgroup=sdHeader start=/^\[Unit\]/ end=/^\[/me=e-2 contains=sdUnitKey
syn match sdUnitKey contained /^Description=/
syn match sdUnitKey contained /^Documentation=/ nextgroup=sdDocURI
syn match sdUnitKey contained /^SourcePath=/ nextgroup=sdFilename,sdErr
syn match sdUnitKey contained /^\%(Requires\|RequiresOverridable\|Requisite\|RequisiteOverridable\|Wants\|Binds\=To\|PartOf\|Conflicts\|Before\|After\|OnFailure\|Names\|Propagates\=ReloadTo\|ReloadPropagatedFrom\|PropagateReloadFrom\|JoinsNamespaceOf\)=/ nextgroup=sdUnitList
syn match sdUnitKey contained /^\%(OnFailureIsolate\|IgnoreOnIsolate\|IgnoreOnSnapshot\|StopWhenUnneeded\|RefuseManualStart\|RefuseManualStop\|AllowIsolate\|DefaultDependencies\)=/ nextgroup=sdBool,sdErr
syn match sdUnitKey contained /^OnFailureJobMode=/ nextgroup=sdFailJobMode,sdErr
syn match sdUnitKey contained /^\%(StartLimitInterval\|StartLimitIntervalSec\|JobTimeoutSec\)=/ nextgroup=sdDuration,sdErr
syn match sdUnitKey contained /^\%(StartLimitAction\|JobTimeoutAction\)=/ nextgroup=sdLimitAction,sdErr
syn match sdUnitKey contained /^StartLimitBurst=/ nextgroup=sdUInt,sdErr
syn match sdUnitKey contained /^\%(FailureAction\|SuccessAction\)=/ nextgroup=sdLimitAction,sdFailAction,sdErr
syn match sdUnitKey contained /^\%(FailureAction\|SuccessAction\)ExitStatus=/ nextgroup=sdExitStatusNum,sdErr
syn match sdUnitKey contained /^\%(RebootArgument\|JobTimeoutRebootArgument\)=/
syn match sdUnitKey contained /^RequiresMountsFor=/ nextgroup=sdFileList,sdErr
" TODO: JobRunningTimeoutSec
" ConditionXXX/AssertXXX. Note that they all have an optional '|' after the '='.
syn match sdUnitKey contained /^\%(Condition\|Assert\)\(PathExists\|PathExistsGlob\|PathIsDirectory\|PathIsMountPoint\|PathIsReadWrite\|PathIsSymbolicLink\|DirectoryNotEmpty\|FileNotEmpty\|FileIsExecutable\)=|\=!\=/ contains=sdConditionFlag nextgroup=sdFilename,sdErr
syn match sdUnitKey contained /^\%(Condition\|Assert\)Virtualization=|\=!\=/ contains=sdConditionFlag nextgroup=sdVirtType,sdErr
syn match sdUnitKey contained /^\%(Condition\|Assert\)Security=|\=!\=/ contains=sdConditionFlag nextgroup=sdSecurityType,sdErr
syn match sdUnitKey contained /^\%(Condition\|Assert\)Capability=|\=!\=/ contains=sdConditionFlag nextgroup=sdAnyCapName,sdErr
syn match sdUnitKey contained /^\%(Condition\|Assert\)\%(KernelCommandLine\|Host\)=|\=!\=/ contains=sdConditionFlag
syn match sdUnitKey contained /^\%(Condition\|Assert\)\%(ACPower\|Null\|FirstBoot\)=|\=/ contains=sdConditionFlag nextgroup=sdBool,sdErr
syn match sdUnitKey contained /^\%(Condition\|Assert\)NeedsUpdate=|\=!\=/ contains=sdConditionFlag nextgroup=sdCondUpdateDir,sdErr
syn match sdUnitKey contained /^\%(Condition\|Assert\)Architecture=|\=!\=/ contains=sdConditionFlag nextgroup=sdArch,sdErr
syn match sdUnitKey contained /^\%(Condition\|Assert\)User=|\=/ contains=sdConditionFlag nextgroup=sdUser,sdCondUser,sdErr
syn match sdUnitKey contained /^\%(Condition\|Assert\)Group=|\=/ contains=sdConditionFlag nextgroup=sdUser,sdErr
syn match sdUnitKey contained /^\%(Condition\|Assert\)ControlGroupController=|\=/ contains=sdConditionFlag nextgroup=sdController,sdErr
syn match sdUnitKey contained /^\%(Condition\|Assert\)KernelVersion=|\=/ contains=sdConditionFlag nextgroup=sdKernelVersion,sdErr

" extra bits
syn match sdUnit           contained /\S\+/ contains=sdUnitName,sdErr nextgroup=sdErr
syn match sdUnitList       contained /.\+/ contains=sdUnitName,sdErr
syn match sdConditionFlag  contained /[!|]/
syn match sdCondUpdateDir  contained nextgroup=sdErr /\%(\/etc\|\/var\)/
syn keyword sdVirtType     contained nextgroup=sdErr vm container qemu kvm zvm vmware microsoft oracle xen bochs uml bhyve qnx openvz openvz lxc lxc-libvirt systemd-nspawn docker podman rkt wsl acrn private-users
syn keyword sdSecurityType contained nextgroup=sdErr selinux apparmor tomoyo ima smack audit uefi-secureboot
syn keyword sdFailJobMode  contained nextgroup=sdErr fail replace replace-irreversibly
syn keyword sdLimitAction  contained nextgroup=sdErr none reboot reboot-force reboot-immediate poweroff poweroff-force poweroff-immediate
syn keyword sdFailAction   contained nextgroup=sdErr exit exit-force
syn keyword sdArch         contained nextgroup=sdErr x86 x86_64 ppc ppc-le ppc64 ppc64-le ia64 parisc parisc64 s390 s390x sparc sparc64 mips mips-le mips64 mips64-le alpha arm arm-be arm64 arm64-be sh sh64 m68k tilegx cris arc arc-be native
syn keyword sdController   contained cpu cpuacct io blkio memory devices pids nextgroup=sdController,sdErr
syn match sdCondUser       contained /@system/
syn match sdUser           contained nextgroup=sdErr /\d\+\|[A-Za-z_][A-Za-z0-9_-]*/
syn match sdDocUri         contained /\%(https\=:\/\/\|file:\|info:\|man:\)\S\+\s*/ nextgroup=sdDocUri,sdErr

" [Install] {{{1
" see systemd.unit(5)
syn region sdInstallBlock matchgroup=sdHeader start=/^\[Install\]/ end=/^\[/me=e-2 contains=sdInstallKey
syn match sdInstallKey contained /^\%(WantedBy\|Alias\|Also\|RequiredBy\)=/ nextgroup=sdUnitList
syn match sdInstallKey contained /^DefaultInstance=/ nextgroup=sdInstance
" TODO: sdInstance - what's valid there? probably [^@/]\+, but that's a guess

" Execution options common to [Service|Socket|Mount|Swap] {{{1
" see systemd.exec(5)
syn match sdExecKey contained /^Exec\%(Start\%(Pre\|Post\|\)\|Reload\|Stop\|StopPost\|Condition\)=/ nextgroup=sdExecFlag,sdExecFile,sdErr
syn match sdExecKey contained /^\%(WorkingDirectory\|RootDirectory\|TTYPath\|RootImage\)=/ nextgroup=sdFilename,sdErr
syn match sdExecKey contained /^\%(Runtime\|State\|Cache\|Logs\|Configuration\)Directory=/ nextgroup=sdFilename,sdErr
syn match sdExecKey contained /^\%(Runtime\|State\|Cache\|Logs\|Configuration\)DirectoryMode=/ nextgroup=sdOctal,sdErr
syn match sdExecKey contained /^User=/ nextgroup=sdUser,sdErr
syn match sdExecKey contained /^Group=/ nextgroup=sdUser,sdErr
" TODO: NUMAPolicy, NUMAMask
" TODO: Pass/UnsetEnvironment
" TODO: StandardInput\%(Text\|Data\)
" TODO: Generally everything from 'WorkingDirectory' on down
" TODO: handle some of these better
" FIXME: some of these have moved to Resource Control
" CPUAffinity is: list of uint
" BlockIOWeight is: uint\|filename uint
" BlockIO\%(Read\|Write\)Bandwidth is: filename datasize
syn match sdExecKey contained /^\%(SupplementaryGroups\|CPUAffinity\|SyslogIdentifier\|PAMName\|TCPWrapName\|ControlGroup\|ControlGroupAttribute\|UtmpIdentifier\)=/
syn match sdExecKey contained /^Limit\%(CPU\|FSIZE\|DATA\|STACK\|CORE\|RSS\|NOFILE\|AS\|NPROC\|MEMLOCK\|LOCKS\|SIGPENDING\|MSGQUEUE\|NICE\|RTPRIO\|RTTIME\)=/ nextgroup=sdRlimit
syn match sdExecKey contained /^\%(CPUSchedulingResetOnFork\|TTYReset\|TTYVHangup\|TTYVTDisallocate\|SyslogLevelPrefix\|ControlGroupModify\|DynamicUser\|RemoveIPC\|NoNewPrivileges\|RestrictRealtime\|RestrictSUIDSGID\|LockPersonality\|MountAPIVFS\)=/ nextgroup=sdBool,sdErr
syn match sdExecKey contained /^Private\%(Tmp\|Network\|Devices\|Users\|Mounts\)=/ nextgroup=sdBool,sdErr
syn match sdExecKey contained /^Protect\%(KernelTunables\|KernelModules\|KernelLogs\|Clock\|ControlGroups\|Hostname\)=/ nextgroup=sdBool,sdErr
syn match sdExecKey contained /^\%(Nice\|OOMScoreAdjust\)=/ nextgroup=sdInt,sdErr
syn match sdExecKey contained /^\%(CPUSchedulingPriority\|TimerSlackNSec\)=/ nextgroup=sdUInt,sdErr
" 'ReadOnlyDirectories' et al. are obsolete versions of ReadOnlyPaths' et al.
syn match sdExecKey contained /^\%(ReadWrite\|ReadOnly\|Inaccessible\)Directories=/ nextgroup=sdFileList
syn match sdExecKey contained /^\%(ReadWrite\|ReadOnly\|Inaccessible\|Exec\|NoExec\)Paths=/ nextgroup=sdExecPathList
syn match sdExecKey contained /^CapabilityBoundingSet=/ nextgroup=sdCapNameList
syn match sdExecKey contained /^Capabilities=/ nextgroup=sdCapability,sdErr
syn match sdExecKey contained /^UMask=/ nextgroup=sdOctal,sdErr
syn match sdExecKey contained /^StandardInput=/ nextgroup=sdStdin,sdErr
syn match sdExecKey contained /^Standard\%(Output\|Error\)=/ nextgroup=sdStdout,sdErr
syn match sdExecKey contained /^SecureBits=/ nextgroup=sdSecureBitList
syn match sdExecKey contained /^SyslogFacility=/ nextgroup=sdSyslogFacil,sdErr
syn match sdExecKey contained /^SyslogLevel=/ nextgroup=sdSyslogLevel,sdErr
syn match sdExecKey contained /^IOSchedulingClass=/ nextgroup=sdIOSchedClass,sdErr
syn match sdExecKey contained /^IOSchedulingPriority=/ nextgroup=sdIOSchedPrio,sdErr
syn match sdExecKey contained /^CPUSchedulingPolicy=/ nextgroup=sdCPUSchedPol,sdErr
syn match sdExecKey contained /^MountFlags=/ nextgroup=sdMountFlags,sdErr
syn match sdExecKey contained /^\%(IgnoreSIGPIPE\|MemoryDenyWriteExecute\)=/ nextgroup=sdBool,sdErr
syn match sdExecKey contained /^Environment=/ nextgroup=sdEnvDefs
syn match sdExecKey contained /^EnvironmentFile=-\=/ contains=sdEnvDashFlag nextgroup=sdFilename,sdErr

syn match   sdExecFlag      contained /-\=@\=/ nextgroup=sdExecFile,sdErr
syn match   sdExecFile      contained /\S\+/ nextgroup=sdExecArgs
syn match   sdExecArgs      contained /.*/ contains=sdEnvArg
syn match   sdEnvDefs       contained /.*/ contains=sdEnvDef
syn match   sdEnvDashFlag   contained /-/ nextgroup=sdFilename,sdErr
syn match   sdEnvDef        contained /\i\+=/he=e-1
syn match   sdFileList      contained /.*/ contains=sdFilename,sdErr
syn match   sdExecPathList  contained /.*/ contains=sdExecPath,sdErr
syn match   sdExecPath      contained /-\=+\=\/\S\+\s*/
" CAPABILITIES WOOO {{{
syn case ignore
syn match   sdCapNameList   contained /.*/ contains=sdAnyCapName,sdErr
syn match   sdAnyCapName    contained /CAP_[A-Z_]\+\s*/ contains=sdCapName
syn keyword sdCapName       contained CAP_AUDIT_CONTROL CAP_AUDIT_WRITE CAP_CHOWN CAP_DAC_OVERRIDE CAP_DAC_READ_SEARCH
syn keyword sdCapName       contained CAP_FOWNER CAP_FSETID CAP_IPC_LOCK CAP_IPC_OWNER CAP_KILL CAP_LEASE
syn keyword sdCapName       contained CAP_LINUX_IMMUTABLE CAP_MAC_ADMIN CAP_MAC_OVERRIDE CAP_MKNOD
syn keyword sdCapName       contained CAP_NET_ADMIN CAP_NET_BIND_SERVICE CAP_NET_BROADCAST CAP_NET_RAW
syn keyword sdCapName       contained CAP_SETGID CAP_SETFCAP CAP_SETPCAP CAP_SETUID
syn keyword sdCapName       contained CAP_SYS_ADMIN CAP_SYS_BOOT CAP_SYS_CHROOT CAP_SYS_MODULE CAP_SYS_NICE CAP_SYS_PACCT
syn keyword sdCapName       contained CAP_SYS_PTRACE CAP_SYS_RAWIO CAP_SYS_RESOURCE CAP_SYS_TIME CAP_SYS_TTY_CONFIG
syn case match
syn cluster sdCap           contains=sdCapName,sdCapOps,sdCapFlags
syn match   sdCapOps        contained /[=+-]/
syn match   sdCapFlags      contained /\<[eip]\+/
syn match   sdCapability    contained /\%(\%([A-Za-z_]\+,\=\)*\|all\)\%(=[eip]*\|[+-][eip]\+\)\s*/ contains=@sdCap nextgroup=sdCapability,sdErr
"}}}
syn keyword sdStdin         contained nextgroup=sdErr null tty-force tty-fail socket tty
syn match   sdStdout        contained nextgroup=sdErr /\%(syslog\|kmsg\|journal\)\%(+console\)\=/
syn keyword sdStdout        contained nextgroup=sdErr inherit null tty socket
syn keyword sdSyslogFacil   contained nextgroup=sdErr kern user mail daemon auth syslog lpr news uucp cron authpriv ftp
syn match   sdSyslogFacil   contained nextgroup=sdErr /\<local[0-7]\>/
syn keyword sdSyslogLevel   contained nextgroup=sdErr emerg alert crit err warning notice info debug
syn keyword sdIOSchedClass  contained nextgroup=sdErr 0 1 2 3 none realtime best-effort idle
syn keyword sdIOSchedPrio   contained nextgroup=sdErr 0 1 2 3 4 5 6 7
syn keyword sdCPUSchedPol   contained nextgroup=sdErr other batch idle fifo rr
syn keyword sdMountFlags    contained nextgroup=sdErr shared slave private
syn match   sdRlimit        contained nextgroup=sdErr /\<\%(\d\+\|infinity\)\>/
syn keyword sdSecureBits    contained nextgroup=sdErr keep-caps keep-caps-locked noroot noroot-locked no-setuid-fixup no-setuid-fixup-locked

" TODO: which section does this come from?
syn match sdExecKey  contained /^TimeoutSec=/ nextgroup=sdDuration,sdErr

" Process killing options for [Service|Socket|Mount|Swap|Scope] {{{1
" see systemd.kill(5)
syn match sdKillKey  contained /^KillSignal=/ nextgroup=sdSignal,sdErr
syn match sdKillKey  contained /^KillMode=/ nextgroup=sdKillMode,sdErr
syn match sdKillKey  contained /^\%(SendSIGKILL\|SendSIGHUP\)=/ nextgroup=sdBool,sdErr
syn keyword sdKillMode contained nextgroup=sdErr control-group process mixed none

" Resource Control options for [Service|Socket|Mount|Swap|Slice|Scope] {{{1
" see systemd.resource-control(5)
syn match sdResCtlKey contained /^Slice=/ nextgroup=sdSliceName,sdErr
syn match sdResCtlKey contained /^\%(CPUAccounting\|MemoryAccounting\|IOAccounting\|BlockIOAccounting\|TasksAccounting\|IPAccounting\|Delegate\)=/ nextgroup=sdBool,sdErr
syn match sdResCtlKey contained /^\%(CPUQuota\)=/ nextgroup=sdPercent,sdErr
syn match sdResCtlKey contained /^\%(CPUShares\|StartupCPUShares\)=/ nextgroup=sdUInt,sdErr
syn match sdResCtlKey contained /^MemoryLow=/ nextgroup=sdDatasize,sdPercent,sdErr
syn match sdResCtlKey contained /^\%(MemoryLimit\|MemoryHigh\|MemoryMax\)=/ nextgroup=sdDatasize,sdPercent,sdInfinity,sdErr
syn match sdResCtlKey contained /^TasksMax=/ nextgroup=sdUInt,sdInfinity,sdErr
syn match sdResCtlKey contained /^\%(IOWeight\|StartupIOWeight\|BlockIOWeight\|StartupBlockIOWeight\)=/ nextgroup=sdUInt,sdErr
syn match sdResCtlKey contained /^DeviceAllow=/ nextgroup=sdDevAllow,sdErr
syn match sdResCtlKey contained /^DevicePolicy=/ nextgroup=sdDevPolicy,sdErr

syn match sdSliceName contained /\S\+\.slice\_s/ contains=sdUnitName
syn keyword sdInfinity contained infinity

syn match   sdDevAllow      contained /\%(\/dev\/\|char-\|block-\)\S\+\s\+/ nextgroup=sdDevAllowPerm
syn match   sdDevAllowPerm  contained /\S\+/ contains=sdDevAllowErr nextgroup=sdErr
syn match   sdDevAllowErr   contained /[^rwm]\+/
syn keyword sdDevPolicy     contained strict closed auto

" [Service] {{{1
syn region sdServiceBlock matchgroup=sdHeader start=/^\[Service\]/ end=/^\[/me=e-2 contains=sdServiceKey,sdExecKey,sdKillKey,sdResCtlKey
syn match sdServiceKey contained /^BusName=/
syn match sdServiceKey contained /^\%(RemainAfterExit\|GuessMainPID\|PermissionsStartOnly\|RootDirectoryStartOnly\|NonBlocking\|ControlGroupModify\)=/ nextgroup=sdBool,sdErr
syn match sdServiceKey contained /^\%(SysVStartPriority\|FsckPassNo\)=/ nextgroup=sdUInt,sdErr
syn match sdServiceKey contained /^\%(Restart\|Timeout\|TimeoutStart\|TimeoutStop\|TimeoutAbort\|Watchdog\|RuntimeMax\)Sec=/ nextgroup=sdDuration,sdErr
syn match sdServiceKey contained /^Sockets=/ nextgroup=sdUnitList
syn match sdServiceKey contained /^PIDFile=/ nextgroup=sdFilename,sdErr
syn match sdServiceKey contained /^Type=/ nextgroup=sdServiceType,sdErr
syn match sdServiceKey contained /^Restart=/ nextgroup=sdRestartType,sdErr
syn match sdServiceKey contained /^NotifyAccess=/ nextgroup=sdNotifyType,sdErr
syn match sdServiceKey contained /^StartLimitInterval=/ nextgroup=sdDuration,sdErr
syn match sdServiceKey contained /^StartLimitAction=/ nextgroup=sdLimitAction,sdErr
syn match sdServiceKey contained /^StartLimitBurst=/ nextgroup=sdUInt,sdErr
syn match sdServiceKey contained /^FailureAction=/ nextgroup=sdLimitAction,sdFailAction,sdErr
syn match sdServiceKey contained /^\%(RestartPrevent\|RestartForce\)ExitStatus=/ nextgroup=sdSignalList
syn match sdServiceKey contained /^SuccessExitStatus=/ nextgroup=sdExitStatusList
syn match sdServiceKey contained /^RebootArgument=/
syn keyword sdServiceType contained nextgroup=sdErr simple exec forking dbus oneshot notify idle
syn keyword sdRestartType contained nextgroup=sdErr no on-success on-failure on-abort always
syn keyword sdNotifyType  contained nextgroup=sdErr none main all

" [Socket] {{{1
syn region sdSocketBlock matchgroup=sdHeader start=/^\[Socket\]/ end=/^\[/me=e-2 contains=sdSocketKey,sdExecKey,sdKillKey,sdResCtlKey
syn match sdSocketKey contained /^Listen\%(Stream\|Datagram\|SequentialPacket\|FIFO\|Special\|Netlink\|MessageQueue\)=/
syn match sdSocketKey contained /^Listen\%(FIFO\|Special\)=/ nextgroup=sdFilename,sdErr
syn match sdSocketKey contained /^\%(Socket\|Directory\)Mode=/ nextgroup=sdOctal,sdErr
syn match sdSocketKey contained /^\%(Backlog\|MaxConnections\|Priority\|ReceiveBuffer\|SendBuffer\|IPTTL\|Mark\|PipeSize\|MessageQueueMaxMessages\|MessageQueueMessageSize\)=/ nextgroup=sdUInt,sdErr
syn match sdSocketKey contained /^\%(Accept\|KeepAlive\|FreeBind\|Transparent\|Broadcast\|Writable\|NoDelay\|PassCredentials\|PassSecurity\|ReusePort\|RemoveOnStop\|SELinuxContextFromNet\)=/ nextgroup=sdBool,sdErr
syn match sdSocketKey contained /^BindToDevice=/
syn match sdSocketKey contained /^Service=/ nextgroup=sdUnit
syn match sdSocketKey contained /^BindIPv6Only=/ nextgroup=sdBindIPv6,sdErr
syn match sdSocketKey contained /^IPTOS=/ nextgroup=sdIPTOS,sdUInt,sdErr
syn match sdSocketKey contained /^TCPCongestion=/ nextgroup=sdTCPCongest
syn keyword sdBindIPv6   contained nextgroup=sdErr default both ipv6-only
syn keyword sdIPTOS      contained nextgroup=sdErr low-delay throughput reliability low-cost
syn keyword sdTCPCongest contained nextgroup=sdErr westwood veno cubic lp

" [Timer|Automount|Mount|Swap|Path|Slice|Scope] {{{1
" [Timer]
syn region sdTimerBlock matchgroup=sdHeader start=/^\[Timer\]/ end=/^\[/me=e-2 contains=sdTimerKey
syn match sdTimerKey contained /^On\%(Active\|Boot\|Startup\|UnitActive\|UnitInactive\)Sec=/ nextgroup=sdDuration,sdErr
syn match sdTimerKey contained /^\%(Accuracy\|RandomizedDelay\)Sec=/ nextgroup=sdDuration,sdErr
syn match sdTimerKey contained /^\%(Persistent\|WakeSystem\|RemainAfterElapse\|OnClockChange\|OnTimezoneChange\)=/ nextgroup=sdBool,sdErr
syn match sdTimerKey contained /^OnCalendar=/ nextgroup=sdCalendar
syn match sdTimerKey contained /^Unit=/ nextgroup=sdUnitList
" TODO: sdCalendar

" [Automount]
syn region sdAutoMountBlock matchgroup=sdHeader start=/^\[Automount\]/ end=/^\[/me=e-2 contains=sdAutomountKey
syn match sdAutomountKey contained /^Where=/ nextgroup=sdFilename,sdErr
syn match sdAutomountKey contained /^DirectoryMode=/ nextgroup=sdOctal,sdErr

" [Mount]
syn region sdMountBlock matchgroup=sdHeader start=/^\[Mount\]/ end=/^\[/me=e-2 contains=sdMountKey,sdAutomountKey,sdExecKey,sdKillKey,sdResCtlKey
syn match sdMountKey contained /^\%(SloppyOptions\|LazyUnmount\|ForceUnmount\)=/ nextgroup=sdBool,sdErr
syn match sdMountKey contained /^\%(What\|Type\|Options\)=/

" [Swap]
syn region sdSwapBlock matchgroup=sdHeader start=/^\[Swap\]/ end=/^\[/me=e-2 contains=sdSwapKey,sdExecKey,sdKillKey,sdResCtlKey
syn match sdSwapKey contained /^What=/ nextgroup=sdFilename,sdErr
syn match sdSwapKey contained /^Priority=/ nextgroup=sdUInt,sdErr
syn match sdSwapKey contained /^Options=/

" [Path]
syn region sdPathBlock matchgroup=sdHeader start=/^\[Path\]/ end=/^\[/me=e-2 contains=sdPathKey
syn match sdPathKey contained /^\%(PathExists\|PathExistsGlob\|PathChanged\|PathModified\|DirectoryNotEmpty\)=/ nextgroup=sdFilename,sdErr
syn match sdPathKey contained /^MakeDirectory=/ nextgroup=sdBool,sdErr
syn match sdPathKey contained /^DirectoryMode=/ nextgroup=sdOctal,sdErr
syn match sdPathKey contained /^Unit=/ nextgroup=sdUnitList

" [Slice]
syn region sdSliceBlock matchgroup=sdHeader start=/^\[Slice\]/ end=/^\[/me=e-2 contains=sdSliceKey,sdResCtlKey,sdKillKey

" [Scope]
syn region sdScopeBlock matchgroup=sdHeader start=/^\[Scope\]/ end=/^\[/me=e-2 contains=sdScopeKey,sdResCtlKey,sdKillKey
syn match sdScopeKey contained /^TimeoutStopSec=/ nextgroup=sdDuration,sdErr

" [Container] {{{1
syn region sdContainerBlock matchgroup=sdHeader start=/^\[Container\]/ end=/^\[/me=e-2 contains=sdContainerKey
syn match sdContainerKey contained /^AddCapability=/
syn match sdContainerKey contained /^AddDevice=/
syn match sdContainerKey contained /^AddHost=/
syn match sdContainerKey contained /^Annotation=/
syn match sdContainerKey contained /^AutoUpdate=/
syn match sdContainerKey contained /^CgroupsMode=/
syn match sdContainerKey contained /^ContainerName=/
syn match sdContainerKey contained /^ContainersConfModule=/
syn match sdContainerKey contained /^DNS=/
syn match sdContainerKey contained /^DNSOption=/
syn match sdContainerKey contained /^DNSSearch=/
syn match sdContainerKey contained /^DropCapability=/
syn match sdContainerKey contained /^Entrypoint=/
syn match sdContainerKey contained /^Environment=/ nextgroup=sdEnvDefs
syn match sdContainerKey contained /^EnvironmentFile=-\=/ contains=sdEnvDashFlag nextgroup=sdFilename,sdErr
syn match sdContainerKey contained /^EnvironmentHost=/
syn match sdContainerKey contained /^Exec=/
syn match sdContainerKey contained /^ExposeHostPort=/
syn match sdContainerKey contained /^GIDMap=/
syn match sdContainerKey contained /^GlobalArgs=/
syn match sdContainerKey contained /^Group=/
syn match sdContainerKey contained /^GroupAdd=/
syn match sdContainerKey contained /^HealthCmd=/
syn match sdContainerKey contained /^HealthInterval=/ nextgroup=sdDuration,sdErr
syn match sdContainerKey contained /^HealthLogDestination=/
syn match sdContainerKey contained /^HealthMaxLogCount=/ nextgroup=sdUInt,sdErr
syn match sdContainerKey contained /^HealthMaxLogSize=/
syn match sdContainerKey contained /^HealthOnFailure=/
syn match sdContainerKey contained /^HealthRetries=/ nextgroup=sdUInt,sdErr
syn match sdContainerKey contained /^HealthStartPeriod=/ nextgroup=sdDuration,sdErr
syn match sdContainerKey contained /^HealthStartupCmd=/
syn match sdContainerKey contained /^HealthStartupInterval=/ nextgroup=sdDuration,sdErr
syn match sdContainerKey contained /^HealthStartupRetries=/ nextgroup=sdUInt,sdErr
syn match sdContainerKey contained /^HealthStartupSuccess=/ nextgroup=sdUInt,sdErr
syn match sdContainerKey contained /^HealthStartupTimeout=/ nextgroup=sdDuration,sdErr
syn match sdContainerKey contained /^HealthTimeout=/ nextgroup=sdDuration,sdErr
syn match sdContainerKey contained /^HostName=/
syn match sdContainerKey contained /^Image=/
syn match sdContainerKey contained /^IP=/
syn match sdContainerKey contained /^IP6=/
syn match sdContainerKey contained /^Label=/
syn match sdContainerKey contained /^LogDriver=/
syn match sdContainerKey contained /^LogOpt=/
syn match sdContainerKey contained /^Mask=/
syn match sdContainerKey contained /^Memory=/
syn match sdContainerKey contained /^Mount=/
syn match sdContainerKey contained /^Network=/
syn match sdContainerKey contained /^NetworkAlias=/
syn match sdContainerKey contained /^NoNewPrivileges=/
syn match sdContainerKey contained /^Notify=/ nextgroup=sdContainerNotifyType,sdErr
syn match sdContainerKey contained /^PidsLimit=/
syn match sdContainerKey contained /^Pod=/
syn match sdContainerKey contained /^PodmanArgs=/
syn match sdContainerKey contained /^PublishPort=/
syn match sdContainerKey contained /^Pull=/
syn match sdContainerKey contained /^ReadOnly=/
syn match sdContainerKey contained /^ReadOnlyTmpfs=/
syn match sdContainerKey contained /^ReloadCmd=/
syn match sdContainerKey contained /^ReloadSignal=/
syn match sdContainerKey contained /^Retry=/
syn match sdContainerKey contained /^RetryDelay=/
syn match sdContainerKey contained /^Rootfs=/
syn match sdContainerKey contained /^RunInit=/
syn match sdContainerKey contained /^SeccompProfile=/
syn match sdContainerKey contained /^Secret=/
syn match sdContainerKey contained /^SecurityLabelDisable=/
syn match sdContainerKey contained /^SecurityLabelFileType=/
syn match sdContainerKey contained /^SecurityLabelLevel=/
syn match sdContainerKey contained /^SecurityLabelNested=/
syn match sdContainerKey contained /^SecurityLabelType=/
syn match sdContainerKey contained /^ShmSize=/
syn match sdContainerKey contained /^StartWithPod=/
syn match sdContainerKey contained /^StopSignal=/
syn match sdContainerKey contained /^StopTimeout=/
syn match sdContainerKey contained /^SubGIDMap=/
syn match sdContainerKey contained /^SubUIDMap=/
syn match sdContainerKey contained /^Sysctl=/
syn match sdContainerKey contained /^Timezone=/
syn match sdContainerKey contained /^Tmpfs=/
syn match sdContainerKey contained /^UIDMap=/
syn match sdContainerKey contained /^Ulimit=/
syn match sdContainerKey contained /^Unmask=/
syn match sdContainerKey contained /^User=/
syn match sdContainerKey contained /^UserNS=/
syn match sdContainerKey contained /^Volume=/ nextgroup=sdFilename,sdContainerVolume,sdErr
syn match sdContainerKey contained /^WorkingDir=/

syn match sdContainerVolume contained nextgroup=sdErr /\S*.volume:\/\S*/
syn keyword sdContainerNotifyType contained nextgroup=sdErr true false healthy
"}}}

" [Pod] {{{1
syn region sdPodBlock matchgroup=sdHeader start=/^\[Pod\]/ end=/^\[/me=e-2 contains=sdPodKey
syn match sdPodKey contained /^AddHost/
syn match sdPodKey contained /^ContainersConfModule/
syn match sdPodKey contained /^DNS/
syn match sdPodKey contained /^DNSOption/
syn match sdPodKey contained /^DNSSearch/
syn match sdPodKey contained /^GIDMap/
syn match sdPodKey contained /^GlobalArgs/
syn match sdPodKey contained /^HostName/
syn match sdPodKey contained /^IP/
syn match sdPodKey contained /^IP6/
syn match sdPodKey contained /^Label/
syn match sdPodKey contained /^Network/
syn match sdPodKey contained /^NetworkAlias/
syn match sdPodKey contained /^PodmanArgs/
syn match sdPodKey contained /^PodName/
syn match sdPodKey contained /^PublishPort/
syn match sdPodKey contained /^ServiceName/
syn match sdPodKey contained /^ShmSize/
syn match sdPodKey contained /^SubGIDMap/
syn match sdPodKey contained /^SubUIDMap/
syn match sdPodKey contained /^UIDMap/
syn match sdPodKey contained /^UserNS/
syn match sdPodKey contained /^Volume/
"}}}

" [Kube] {{{1
syn region sdPodBlock matchgroup=sdHeader start=/^\[Kube\]/ end=/^\[/me=e-2 contains=sdKubeKey
syn match sdKubeKey contained /^AutoUpdate/
syn match sdKubeKey contained /^ConfigMap/
syn match sdKubeKey contained /^ContainersConfModule/
syn match sdKubeKey contained /^ExitCodePropagation/
syn match sdKubeKey contained /^GlobalArgs/
syn match sdKubeKey contained /^KubeDownForce/
syn match sdKubeKey contained /^LogDriver/
syn match sdKubeKey contained /^Network/
syn match sdKubeKey contained /^PodmanArgs/
syn match sdKubeKey contained /^PublishPort/
syn match sdKubeKey contained /^SetWorkingDirectory/
syn match sdKubeKey contained /^UserNS/
syn match sdKubeKey contained /^Yaml/
"}}}

" [Network] {{{1
syn region sdNetworkBlock matchgroup=sdHeader start=/^\[Network\]/ end=/^\[/me=e-2 contains=sdNetworkKey
syn match sdNetworkKey contained /^ContainersConfModule/
syn match sdNetworkKey contained /^DisableDNS/
syn match sdNetworkKey contained /^DNS/
syn match sdNetworkKey contained /^Driver/
syn match sdNetworkKey contained /^Gateway/
syn match sdNetworkKey contained /^GlobalArgs/
syn match sdNetworkKey contained /^InterfaceName/
syn match sdNetworkKey contained /^Internal/
syn match sdNetworkKey contained /^IPAMDriver/
syn match sdNetworkKey contained /^IPRange/
syn match sdNetworkKey contained /^IPv6/
syn match sdNetworkKey contained /^Label/
syn match sdNetworkKey contained /^NetworkDeleteOnStop/
syn match sdNetworkKey contained /^NetworkName/
syn match sdNetworkKey contained /^Options/
syn match sdNetworkKey contained /^PodmanArgs/
syn match sdNetworkKey contained /^Subnet/
"}}}

" [Volume] {{{1
syn region sdVolumeBlock matchgroup=sdHeader start=/^\[Volume\]/ end=/^\[/me=e-2 contains=sdVolumeKey
syn match sdVolumeKey contained /^ContainersConfModule/
syn match sdVolumeKey contained /^Copy/
syn match sdVolumeKey contained /^Device/
syn match sdVolumeKey contained /^Driver/
syn match sdVolumeKey contained /^GlobalArgs/
syn match sdVolumeKey contained /^Group/
syn match sdVolumeKey contained /^Image/
syn match sdVolumeKey contained /^Label/
syn match sdVolumeKey contained /^Options/
syn match sdVolumeKey contained /^PodmanArgs/
syn match sdVolumeKey contained /^Type/
syn match sdVolumeKey contained /^User/
syn match sdVolumeKey contained /^VolumeName/
"}}}

" [Build] {{{1
syn region sdBuildBlock matchgroup=sdHeader start=/^\[Build\]/ end=/^\[/me=e-2 contains=sdBuildKey
syn match sdBuildKey contained /^Annotation/
syn match sdBuildKey contained /^Arch/
syn match sdBuildKey contained /^AuthFile/
syn match sdBuildKey contained /^ContainersConfModule/
syn match sdBuildKey contained /^DNS/
syn match sdBuildKey contained /^DNSOption/
syn match sdBuildKey contained /^DNSSearch/
syn match sdBuildKey contained /^Environment/
syn match sdBuildKey contained /^File/
syn match sdBuildKey contained /^ForceRM/
syn match sdBuildKey contained /^GlobalArgs/
syn match sdBuildKey contained /^GroupAdd/
syn match sdBuildKey contained /^ImageTag/
syn match sdBuildKey contained /^Label/
syn match sdBuildKey contained /^Network/
syn match sdBuildKey contained /^PodmanArgs/
syn match sdBuildKey contained /^Pull/
syn match sdBuildKey contained /^Retry/
syn match sdBuildKey contained /^RetryDelay/
syn match sdBuildKey contained /^Secret/
syn match sdBuildKey contained /^SetWorkingDirectory/
syn match sdBuildKey contained /^Target/
syn match sdBuildKey contained /^TLSVerify/
syn match sdBuildKey contained /^Variant/
syn match sdBuildKey contained /^Volume/
"}}}

" [Image] {{{1
syn region sdImageBlock matchgroup=sdHeader start=/^\[Image\]/ end=/^\[/me=e-2 contains=sdImageKey
syn match sdImageKey contained /^AllTags/
syn match sdImageKey contained /^Arch/
syn match sdImageKey contained /^AuthFile/
syn match sdImageKey contained /^CertDir/
syn match sdImageKey contained /^ContainersConfModule/
syn match sdImageKey contained /^Creds/
syn match sdImageKey contained /^DecryptionKey/
syn match sdImageKey contained /^GlobalArgs/
syn match sdImageKey contained /^Image/
syn match sdImageKey contained /^ImageTag/
syn match sdImageKey contained /^OS/
syn match sdImageKey contained /^PodmanArgs/
syn match sdImageKey contained /^Retry/
syn match sdImageKey contained /^RetryDelay/
syn match sdImageKey contained /^TLSVerify/
syn match sdImageKey contained /^Variant/
"}}}

" Coloring definitions {{{1
hi def link sdComment       Comment
hi def link sdTodo          Todo
hi def link sdInclude       PreProc
hi def link sdHeader        Type
hi def link sdEnvArg        PreProc
hi def link sdFormatStr     Special
hi def link sdErr           Error
hi def link sdEnvDef        Identifier
hi def link sdUnitName      PreProc
hi def link sdKey           Statement
hi def link sdValue         Constant
hi def link sdSymbol        Special

" Coloring links: keys {{{1

" It'd be nice if this worked..
"hi def link sd.\+Key           sdKey
hi def link sdUnitKey           sdKey
hi def link sdInstallKey        sdKey
hi def link sdExecKey           sdKey
hi def link sdKillKey           sdKey
hi def link sdResCtlKey         sdKey
hi def link sdSocketKey         sdKey
hi def link sdServiceKey        sdKey
hi def link sdServiceCommonKey  sdKey
hi def link sdTimerKey          sdKey
hi def link sdMountKey          sdKey
hi def link sdAutomountKey      sdKey
hi def link sdSwapKey           sdKey
hi def link sdPathKey           sdKey
hi def link sdScopeKey          sdKey
hi def link sdContainerKey      sdKey
hi def link sdPodKey            sdKey
hi def link sdKubeKey           sdKey
hi def link sdNetworkKey        sdKey
hi def link sdVolumeKey         sdKey
hi def link sdBuildKey          sdKey
hi def link sdImageKey          sdKey

" Coloring links: constant values {{{1
hi def link sdInt               sdValue
hi def link sdUInt              sdValue
hi def link sdBool              sdValue
hi def link sdOctal             sdValue
hi def link sdByteVal           sdValue
hi def link sdDuration          sdValue
hi def link sdPercent           sdValue
hi def link sdInfinity          sdValue
hi def link sdDatasize          sdValue
hi def link sdVirtType          sdValue
hi def link sdServiceType       sdValue
hi def link sdNotifyType        sdValue
hi def link sdSecurityType      sdValue
hi def link sdSecureBits        sdValue
hi def link sdMountFlags        sdValue
hi def link sdKillMode          sdValue
hi def link sdFailJobMode       sdValue
hi def link sdLimitAction       sdValue
hi def link sdRestartType       sdValue
hi def link sdSignalName        sdValue
hi def link sdExitStatusName    sdValue
hi def link sdStdin             sdValue
hi def link sdStdout            sdValue
hi def link sdSyslogFacil       sdValue
hi def link sdSyslogLevel       sdValue
hi def link sdIOSched           sdValue
hi def link sdCPUSched          sdValue
hi def link sdRlimit            sdValue
hi def link sdCapName           sdValue
hi def link sdDevPolicy         sdValue
hi def link sdDevAllowPerm      sdValue
hi def link sdContainerNotifyType sdValue
hi def link sdDevAllowErr       Error

" Coloring links: symbols/flags {{{1
hi def link sdExecFlag          sdSymbol
hi def link sdConditionFlag     sdSymbol
hi def link sdEnvDashFlag       sdSymbol
hi def link sdCapOps            sdSymbol
hi def link sdCapFlags          Identifier
"}}}

let b:current_syntax = "systemd"
" vim: fdm=marker
