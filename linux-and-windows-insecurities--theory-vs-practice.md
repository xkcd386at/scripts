There's a popular website by someone called "madaidans" which lists a lot of issues with Linux security, and claims Windows does it better.  All of the points are *technically* true, but in the real world the picture is somewhat different, which that site and its fans appear to ignore.

I got tired of debating this with them; their arguments are subjective, often patronising, and interacting with them is very enervating.  At the same time, I wasn't going to let go without *something* to add when someone asks a genuine question.

This is the result: a list of **in the wild** exploits that have happened on both OSs (see "scope" in the next section for more).

Let me emphasise this for people whose knee-jerk response is "CVE counting is not a good metric".  These are not *just* CVEs, these are actual, in the wild, exploits that were/are actively used by attackers.  **If you're a sysadmin (even a competent one who does all the right things) this is your reality to deal with, and neither the theoretical arguments in madaidnas's page nor any other kind of rationalising will change that.**

Of course, there *is* a Linux section, though as of 2022-11-09 it has only one entry.  Feel free to send me any links to Linux issues that are "in scope" which I may have missed.  Also, if you think one of the entries should actually be "out of scope" by the criteria below, let me know.  All other responses will be cheerfully ignored.

# what is in scope

-   I arbitrarily picked Jan 1, 2022 as the earliest I will go.
-   (Update: I stopped working on this in early 2023, so you could say this data is for the full year 2022.  If you do a similar exercise for later years, please post a link to reddit's /r/linux; I'm pretty sure the overall trend will continue to be similar.)
-   I include vulnerabilities for which an "in the wild" attack has happened or was suspected to have happened at some point *before* a patch became available.
-   I exclude vulnerabilities (regardless of severity) that were exploited *after* a patch became available (for instance, because people failed to upgrade).
-   For Windows, I also ignore ancillary products like Exchange, IE/Edge, MS Office, etc.

# other notes

Sources of similar information:

-   <https://www.cisa.gov/known-exploited-vulnerabilities-catalog> is a good place to look at.  Download the CSV, and fiddle with it using the excellent [`visidata`](https://www.visidata.org/) tool or if you're more comfortable use a spreadsheet.  Delete all rows for "vendorProject" other than Microsoft and Linux.  Then, in the Microsoft set, delete all rows for "product" other than "Windows" and "Win32k".  As of 2022-06-01, this leaves 97 rows for Microsoft (breakup: 77 Windows, 20 Win32k), and 5 rows for Linux.

Other notable responses to that page:

*   <https://www.reddit.com/r/PrivacyGuides/comments/v1luh1/looking_for_more_context_and_viewpoints_on/iaodpdn/> is easily one of the best, most cogent, and cleanly written, responses to this question -- hats off !)


# bonus link

<https://www.reddit.com/r/linux/comments/hzyu8j/comment/fznndez/> is from Jason Donenfeld, the guy who created the wireguard VPN.  He describes the problems in trying to port it to Windows in language that... well here is the juiciest quote:

>   layers and layers of complexity, and so many competing ideas and modalities all put into adjacent and overlapping libraries, with functionality duplicated and contradictory all over the place, and a million ways that different Microsoft binaries do different things, and highly complex state machines with multiple interlocking moving parts, and endless abstractions upon abstractions, and separations upon separations combined with layering violation upon layering violation, and a supremely interesting kernel design

So much for the "theory" of windows being better at security.

----

# windows

(Reverse chronological order)

*   2023-01-13: <https://www.theregister.com/2023/01/11/patch_tuesday_january_2023/>
    *   "*Microsoft fixed 98 security flaws in its first Patch Tuesday of 2023 including one that's already been exploited and another listed as publicly known. Of the new January vulnerabilities, 11 are rated critical because they lead to remote code execution.*" \
        \
        "*The bug that's under exploit, tracked as CVE-2023-21674, is an advanced local procedure call elevation of privilege vulnerability that received an 8.8 CVSS rating.*"

*   2022-11-09: <https://www.theregister.com/2022/11/09/microsoft_november_2022_patch_tuesday/> ("Microsoft squashes six security bugs already exploited in the wild")
    *   I have not had time to dig deeper, but 2 of those 6 appear to be MS Exchange bugs, so technically out of scope for this document (see "what is in scope" section above)
    *   Even so, **four actively exploited** vulns is a pretty big jump, in the space of 3 months since my last update!
    *   "*Another 22 vulnerabilities in the Windows giant's products have been labeled "more likely to be exploited" than not.*"

*   2022-08-10: <https://www.theregister.com/2022/08/09/august_patch_tuesday_microsoft/>
    *   another MSDT vulnerability that MS describes as "under active attack"
    *   this is NOT the same as the one below (Follina), though it is the same component.  This one is [CVE-2022-34713](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2022-34713), the older one was [CVE-2022-30190](https://msrc.microsoft.com/update-guide/vulnerability/CVE-2022-30190)
    *   update 2022-08-13: <https://tech.slashdot.org/story/22/08/12/2037213/microsoft-urges-windows-users-to-run-patch-for-dogwalk-zero-day-exploit> is instructive (emphasis mine in the quote below)
        >   DogWalk **affects all Windows versions under support**, including the latest client and server releases, Windows 11 and Windows Server 2022.
        >   The vulnerability was first reported in January 2020 but at the time, Microsoft said it didn't consider the exploit to be a security issue. **This is the second time in recent months that Microsoft has been forced to change its position on a known exploit**, having initially rejected reports that another Windows MSDT zero-day, known as Follina, posed a security threat. A patch for that exploit was released in June's Patch Tuesday update

*   2022-05-31: Follina, <https://www.securityweek.com/microsoft-confirms-exploitation-follina-zero-day-vulnerability>
    *   "*Follina was initially described as a Microsoft Office zero-day vulnerability, but Microsoft says it actually affects the Microsoft Support Diagnostic Tool (MSDT), which collects information that is sent to Microsoft support.*"
        *   note: this is why I am including it; if it was just MS Office I would not have
    <!-- *   "*“The document uses the Word remote template feature to retrieve a HTML file from a remote webserver, which in turn uses the ms-msdt MSProtocol URI scheme to load some code and execute some PowerShell,” Beaumont explained, adding, “That should not be possible.”*" -- (Beaumont is the researcher who found the problem according to <https://www.securityweek.com/document-exploiting-new-microsoft-office-zero-day-seen-wild>) -->
    *   "*The researcher noted that the code is executed even if macros are disabled [...] Microsoft Defender currently does not appear to be capable of preventing execution.*"
    <!-- *   "*“[...] if you change the document to RTF form, it runs without even opening the document (via the preview tab in Explorer) let alone Protected View,” Beaumont said.*" -->

*   2022-05-11: PrintNightMare, <https://www.securityweek.com/windows-print-spooler-vulnerabilities-increasingly-exploited-attacks>
    *   this one has been ongoing since June 2021, as far as I can make out
    *   over on /r/sysadmin there often are threads about it; here's a sample from last week (May 2022): <https://www.reddit.com/r/sysadmin/comments/uxm10z/is_the_printnightmare_over/> 

*   2022-05-10: <https://www.securityweek.com/patch-tuesday-microsoft-warns-new-zero-day-being-exploited>
    *   "*"An unauthenticated attacker could call a method on the LSARPC interface and coerce the domain controller to authenticate to the attacker using NTLM,"*"

*   2022-05-04: <https://www.securityweek.com/kaspersky-warns-fileless-malware-hidden-windows-event-logs>
    *   "*Threat hunters at Kaspersky are publicly documenting a malicious campaign that abuses Windows event logs to store fileless last stage Trojans and keep them hidden in the file system.*"
    *   "*The use of event logs for malware stashing is a technique that Kaspersky’s security researchers say they have not seen before in live malware attacks.*"
    *   "*The researchers [...] say that the group stands out because it patches Windows native API functions associated with event tracking and the anti-malware scan interface to ensure the infection remains stealthy.*"
    *   also, from <https://securelist.com/a-new-secret-stash-for-fileless-malware/106393/>
        *   "*Dropper modules also patch Windows native API functions, related to event tracing (ETW) and anti-malware scan interface (AMSI), to make the infection process stealthier.*"
        *   "*[...] the attackers are free to use this feature widely to inject the next modules into Windows system processes or trusted applications such as DLP.*"

*   2022-04-05: DLL Side Loading, <https://www.bleepingcomputer.com/news/security/chinese-hackers-abuse-vlc-media-player-to-launch-malware-loader/>
    *   "*The technique is known as DLL side-loading and it is widely used by threat actors to load malware into legitimate processes to hide the malicious activity.*"
    <!--
    *   what I understand is that windows works as if you had the equivalent of `ldconfig .` in Linux, and malware takes advantage of that
        *   sidenote: `ldconfig .` does not actually work in linux; it requires an absolute path
        *   an easier to understand analogy might be putting `.` at the beginning of `$PATH` (except this is for DLLs, not executables)
        *   nothing deeply technical here, only the impact is deep; see other links below
    -->
    *   older links
        *   2021 Sep: (from date within PDF): https://www.mandiant.com/resources/dll-side-loading-a-thorn-in-the-side-of-the-anti-virus-industry
            *   "***Software publishers must remain alert to any DLL-side-loading vulnerabilities in their products.***"
        *   2020 March: Mitre ATT\&CK entry <https://attack.mitre.org/techniques/T1574/002/>
            *   "*takes advantage of the DLL search order used by the loader by positioning both the victim application and malicious payload(s) alongside each other*"

*   2022-02-09: LOLBin Regsvr32 <https://threatpost.com/cybercriminals-windows-utility-regsvr32-malware/178333/> (title: Cybercriminals Swarm Windows Utility Regsvr32 to Spread Malware)
    *   "*A Windows living-off-the-land binary (LOLBin) known as Regsvr32 is seeing a big uptick in abuse of late, researchers are warning, mainly spreading trojans like Lokibot and Qbot.*"

*   2022-02-07: <https://threatpost.com/cisa-orders-federal-agencies-to-fix-actively-exploited-windows-bug/178270/>
    *   "*CVE-2022-21882 is a privilege-escalation bug in Windows 10 that doesn’t require much in the way of privileges to exploit: a nasty scenario, particularly given that an exploit requires zero user interaction.*"

# Linux

*   2022-01-25: Pwnkit, <https://www.bleepingcomputer.com/news/security/linux-system-service-bug-gives-root-on-all-major-distros-exploit-released/>
    *   "*An exploit has already emerged in the public space, less than three hours after Qualys published the technical details for PwnKit. BleepingComputer has compiled and tested the available exploit, which proved to be reliable as it gave us root privileges on the system on all attempts.*"
    *   note: I've actually not been able to find any news items that say this was being exploited in the wild, but including it because of the quote above.  At the same time, we also have:
    *   "*Linux distros had access to the patch a couple of weeks before today’s coordinated disclosure from Qualys and are expected to release updated pkexec packages starting today.*"
    *   so it was a bit of a judgement call if it fits or not, but I chose to include it

This section has no more entries.  Some "also ran"s:

*   Dirty pipe was the biggest one this year so far, but I was unable to find any evidence that it was exploited -- it was discovered, responsibly disclosed, fixed, and only then announced.
*   "Nimbuspwn" was the most recent (<https://www.securityweek.com/microsoft-warns-nimbuspwn-security-flaws-haunting-linux>) but even there I was unable to find any evidence of it being in the wild before it was found and patched.

# out of scope, but interesting nevertheless

*   2023-07-11 <https://www.theregister.com/2023/07/11/microsoft_patch_tuesday/>
    *   out of scope because it is MS Office, but it's a big 0-day under active exploitation
    *   >   Crucially, there is no patch yet for CVE-2023-36884, and one may be provided via an emergency update or future scheduled Patch Tuesday, we\'re told. Microsoft went public early with some details of the flaw because a Russian crew, dubbed Storm-0978, apparently used the vulnerability to [target attendees](https://www.microsoft.com/en-us/security/blog/2023/07/11/storm-0978-attacks-reveal-financial-and-espionage-motives/) of the ongoing [NATO summit](https://www.nato.int/cps/en/natohq/news_217051.htm) in Lithuania on Russia\'s invasion of Ukraine.

*   2022-05-22: <https://www.bleepingcomputer.com/news/security/fake-windows-exploits-target-infosec-community-with-cobalt-strike/>
    *   I'm marking this out of scope because it is targeting security researchers, not everyone
    *   including it only for the irony value :)

*   2022-02-12: HiveNightmare, <https://www.securityweek.com/cisa-says-hivenightmare-windows-vulnerability-exploited-attacks>
    *   "*[...] CISA recently confirmed for SecurityWeek that it’s aware of real world attacks for each flaw included in the catalog, even if in some cases there do not appear to be any public reports of malicious exploitation. The agency said it does not publicly provide details about exploitation.*"
    *   the reason this is out of scope is because, while I couldn't get exact dates quickly enough, it *seems* that the patch was out before the "in the wild" exploits were found

*   2022-01-31: <https://www.securityweek.com/north-korean-hackers-abuse-windows-update-client-attacks-defense-industry>
    *   high impact because of target, but it's a Word macro thing, so out of scope

