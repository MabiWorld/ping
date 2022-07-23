$addrs = @{
	"service" = @{
		"api" = @("https://api.nexon.io", "GET");
		"login" = @("35.162.171.43", 11000);
		"chat" = @("54.214.176.167", 8002);
		"website" = @("http://mabinogi.nexon.net/API/Service/Maintenance", "POST");
		"wiki" = @("wiki.mabi.world", "ping");
	};
	"erinn" = @{
		"ch1" = @("34.218.42.114", 11020);
		"ch2" = @("34.218.42.114", 11021);
		"ch3" = @("50.112.234.180", 11022);
		"ch4" = @("50.112.234.180", 11020);
		"ch5" = @("52.32.149.152", 11021);
		"ch6" = @("52.32.149.152", 11022);
		"ch7" = @("52.34.200.191", 11023);
		"ch8" = @("52.34.200.191", 11020);
		"ch9" = @("52.41.162.90", 11021);
		"ch10" = @("52.41.162.90", 11022);
		"hch" = @("52.41.162.90", 11023);
	};
}

$names = @{
	# Identities.
	"erinn" = "erinn";
	"other" = "service";
	"service" = "service";
	"services" = "service";

	# Numerical indexes.
	"1" = "erinn";
	"2" = "service";

	# Internal names.
	"mabius6" = "erinn";

	# Shorthand.
	"e" = "erinn";
	"na" = "erinn";
	"game" = "erinn";
}

$serviceNames = @{
	# Identities.
	"api" = "api";
	"login" = "login";
	"chat" = "chat";
	"website" = "website";
	"wiki" = "wiki";

	# Numerical indexes.
	"1" = "api";
	"2" = "login";
	"3" = "chat";
	"4" = "website";
	"5" = "wiki";

	# Aliases and shorthand.
	"a" = "api";
	"l" = "login";
	"c" = "chat";
	"web" = "website";
	"site" = "website";
	"w" = "wiki";
	"mww" = "wiki";
}

$backNames = @(
	"q", "quit",
	"b", "back",
	"x", "exit"
)

function Extended-Choice {
	param( [string]$Choice, [string]$Prompt )

	$letters = $Choice -replace "[^a-z]",""
	$Choice = $Choice -replace "[a-z]",""
	$len = $Choice.length

	Write-Host ($Prompt + ": ") -NoNewline
	$Choice += "abcdefghijklmnopqrstuvwxyz"

	Choice /c $Choice /n | Out-Null

	$decision = $LastExitCode

	if ($decision -eq 0) {
		exit 0
	}
	else {
		$decisionChar = $Choice[$decision - 1]
		if ($letters.contains($decisionChar) -or $decision -le $len) {
			# Expected numerical choice, easy.
			Write-Host $decisionChar
			[string]$decisionChar
		}
		else {
			# Some other letter, let the user type.
			Write-Host $decisionChar -NoNewline
			$decisionChar + (Read-Host)
		}
	}
}

$server = 0
if ($args.length) {
	$server = $args[0]
	if ($args.length -ge 2) {
		$server += " " + $args[1]
	}
}

$running = 1
while($running) {
	if (-not $server) {
		"Choose a server:"
		"1) Erinn"
		"2) Other services"
		""

		$server = Extended-Choice -Choice "12" -Prompt "Input your server name"
	}

	$server = $server.toLower()

	$service = 0
	$channel = 0
	if ($server -notmatch "^\d$") {
		if ($serviceNames.ContainsKey($server)) {
			$service = $server
			$server = "service"
		}
		elseif ($server.contains(" ")) {
			$server, $channel = $server.split(" ", 2)

			if (-not $names.ContainsKey($server)) {
				$channel, $server = @($server, $channel)
			}
		}
	}

	if ($names.ContainsKey($server)) {
		$server = $names.$server

		$channeling = 1
		while($channeling) {
			$pinging = 0
			if ($server -eq "service") {
				if (-not $service) {
					"1) Nexon API (Nexon Launcher)"
					"2) Mabinogi login server"
					"3) Mabinogi chat server"
					"4) Official Mabinogi website"
					"5) Mabinogi World Wiki"
					"Q) Go back"
					""

					$service = Extended-Choice -Choice "12345q" -Prompt "Input service"
					$service = $service.toLower()
				}

				if ($serviceNames.ContainsKey($service)) {
					$service = $channel = $serviceNames.$service
					$pinging = 1
				}
				else {
					$channel = $service
				}
			}
			else {
				if (-not $channel) {
					"1~9) Channel #"
					"0) Channel 10"
					"H) Housing channel"
					"Q) Go back"
					""

					$channel = Extended-Choice -Choice "1234567890hq" -Prompt "Input channel"
					$channel = $channel.toLower()
				}

				$channel = $channel.replace("channel", "").replace("ch", "")

				if ($channel -like "h*") {
					$channel = "hch"
					$pinging = 1
				}
				elseif ($channel -eq "0") {
					$channel = "ch10"
					$pinging = 1
				}
				elseif ($channel -match "^[1-9]$") {
					$channel = "ch" + $channel
					$pinging = 1
				}
			}

			if ($backNames.Contains($channel)) {
				$channeling = 0
				$pinging = 0
			}
			else {
				$ip, $port = $addrs.$server.$channel
				cls
				"Press q to go back."
			}

			while ($pinging) {
				if ($ip -like "http*://*") {
					(Measure-Command {
						try {
							Invoke-WebRequest -URI $ip -method $port -DisableKeepAlive | Out-Null
						}
						catch {}
					}).milliseconds
				}
				elseif ($port -eq "ping") {
					(Test-Connection $ip -Count 1).responseTime
				}
				else {
					(Measure-Command {
						$sock = new-object System.Net.Sockets.TcpClient($ip, $port)
						(new-object System.IO.StreamReader($sock.getStream())).read([char[]]::new(4), 0, 4) | Out-Null
						$sock.close()
					}).milliseconds
				}

				Choice /t 5 /d c /c cbxq /n | Out-Null

				if ($LastExitCode -ne 1) {
					$pinging = 0
					cls
					$server
				}
			}
			
			$channel = 0
			$service = 0
		}
	}
	else {
		"Invalid server."
	}

	$server = 0
}
