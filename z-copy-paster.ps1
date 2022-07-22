while (1) {
	(Measure-Command {
		$sock = new-object System.Net.Sockets.TcpClient("34.218.42.114", 11020)
		(new-object System.IO.StreamReader($sock.GetStream())).Read([char[]]::new(4), 0, 4) | Out-Null
		$sock.Close()
	}).Milliseconds
	Sleep 5
}
