# Experiment PowerDNS Falcon/SQIsign

Running a full (root, TLD, domain) DNS setup with the Falcon and SQIsign algorithm.

> [!CAUTION]
> This is experimental software and is in no way meant for production usage. Use this software at your own risk.

## Description

This experiment contains the following hosts

| Zone                 | Host                   | IPv4      |  IPv6    |
| ------------         | ---------------------- | --------- | -------- |
| .                    | s.root-servers.net.    | 10.0.1.2  | fc01::2  |
| nl.                  | ns1.example.nl.        | 10.0.1.3  | fc01::3  |
| sidnlabs.nl.         | ns1.sidnlabs.nl.       | 10.0.1.4  | fc01::4  |
| resolver             | -                      | 10.0.1.10 | fc01::10 |
| resolver (dnssec)    | -                      | 10.0.1.11 | fc01::11 |

example.nl is an empty non-terminal in this experiment.

## Running the containers automatically

To run the entire testbed, use the `generate-testbed.sh` script to set up everything:

    ./generate-testbed.sh

This script will start the testbed using podman compose, and setup DNSSEC using a nice mix of SQIsign (root), Mayo (sidnlabs.nl) and Falcon (for .nl).
In this example, we use SQIsign, which is rather slow.
Since PowerDNS computes signatures on-the-fly, let's do an AXFR to force PowerDNS to calculate all signatures for the root.
This will take a while, but saves time for the remaining queries.

## Querying the testbed

You can run some queries to see whether things worked:

    # Start with a full vertical test: ask our resolver to pass all nameservers
    # This should return a TXT record, with RRSIG algorithm number '251', and the 'ad' flag set to indicate success.
    dig +dnssec +nocrypto sidnlabs.nl txt -p 5311 @::1

    # Check NS records of the root
    # You should see it's signed with algorithm 250 (SQIsign)
    dig +dnssec +nocrypto . ns -p 5302 @::1
    
    # Query nameservers of .nl
    # Should return a signature with algorithm 249 (Mayo2)
    dig +dnssec +nocrypto nl ns -p 5303 @::1

## Cleanup

To clean up, run the following commands to stop and remove all containers.

    podman-compose down
    rm root.dnskey

## Building manually

Using the standard docker-compose.yml, you do not need to build anything.
If you prefer to build containers yourself, you may do so.
Use the instructions from the `auth-powerdns` and `resolver-powerdns` repositories to build the images.
Then, change the docker-compose.yml file with the following commands:

    # run some docker/podman build lines here.
    mv docker-compose.yml docker-compose.dist.yml
    sed 's#gitlab.sidnlabs.nl:5009/nfix/pqc/dnssec-testbed/auth-powerdns/##' docker-compose.dist.yml > docker-compose.yml
    ./generate-testbed.sh
