$ORIGIN sidnlabs.nl.
$TTL 3600
@	IN	SOA	ns1.sidnlabs.nl. hostmaster.sidnlabs.nl. (
			1; serial
			14400; refresh
			3600; retry
			604800; expire
			300; minimum
			)
	IN	NS	ns2.sidnlabs.nl.
	IN	A	127.0.0.1
	IN	AAAA	::1
	IN	TXT	"This is the sidnlabs.nl zone"
ns2	IN	A	10.0.1.4
ns2	IN	AAAA	fc01::4
www	IN	A	127.0.0.1
www	IN	AAAA	::1
