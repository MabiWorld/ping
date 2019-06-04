# Maibnogi Ping #
These are scripts that allow you to ping Mabinogi servers and services, despite ICMP ping being disabled.

The primary file of interest is **Mabi-Ping.ps1**  
It is self-contained so to download it you can click it and then on the Raw button: right-click -> **Save link as...**

Please note that the first ping may be higher than subsequent pings. Additionally, these are not traditional pings, and may be slightly higher than your actual latency in general. For mabi servers it should be quite accurate, but for websites (other than MWW) it shows the timing for downloading the target page, rather than simply connecting. All timings are in milliseconds.

## Usage ##
To run the script after downloading, right-click the file and select **Run with PowerShell**

After running, you will be prompted to select the server (or other services) and then the channel (or specific service). Type the number or letter left of the parenthesis to select it. For example:

	Choose a server:
	1) Alexina
	2) Nao
	3) Other services

	Input your server name:

If you want to select Alexina, type **1**

If you wish to end the program at any time, use Ctrl+C

## Advanced Usage ##
The script also accepts command-line arguments so that you can make a shortcut for you server that you can simply double-click.

1. Right-click the script file and select **Create shortcut**
2. Right-click the new shortcut file and select **Properties**
3. In the **Target** field (under **Shortcut**, which should be the default tab), after the **.ps1** add a space followed by your server name, then another space followed by the channel name (you do not have to add a channel name if you don't want to). For example: **alexina ch1** (hch is the housing channel)
4. In order to double click to run the script, go to the beginning of the **Target** field, and add **powershell** followed by a space.

In order to quickly move from the first screen to a ping, you may type the service name directly or a server name + channel.

The shortest commands available are:

* a 1 -> Alexina Channel 1
* n h -> Nao Housing Channel
* a -> Nexon API
* l -> Login server
* c -> Chat server
* web -> Official Mabinogi website
* w -> Mabinogi World Wiki

Other formations are available (such as the full names) and it attempts to correct for spelling and accepts various shorthand. All of these combinations are also accepted on the command line.
