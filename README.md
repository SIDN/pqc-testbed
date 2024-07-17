# Post-quantum Algorithm Testing and Analysis for the DNS

This repository contains information to run a testbed using our PQC-ready [resolver](https://github.com/SIDN/pqc-resolver-powerdns) and [authoritative](https://github.com/SIDN/pqc-auth-powerdns) DNS servers.

More information about this project can be found in our blogs ([introduction blog](https://www.sidnlabs.nl/en/news-and-blogs/a-quantum-safe-cryptography-dnssec-testbed), and [the follow-up blog](https://www.sidnlabs.nl/en/news-and-blogs/set-up-your-own-pqc-testbed-for-dnssec-with-the-patad-open-source-software) about this testbed) and on the [website](https://patad.sidnlabs.nl/) of the PATAD project.

> [!CAUTION]
> This software is experimental and not meant to be used in production. Use this software at your own risk.

## Running a testbed

First, install podman and podman-compose (or docker and docker-compose, just replace `podman` with `docker` in all commands below).
Then, use the following commands to run a testbed.

    git clone https://github.com/SIDN/pqc-testbed.git pqc-testbed
    cd pqc-testbed/example
    ./generate-testbed.sh

    # Now, test whether things work by asking the resolver for a pqc-signed record.
    # This will do a full-stack dnssec validation, from root to sidnlabs.nl.
    dig +dnssec sidnlabs.nl txt -p 5311 @::1

This example testbed is located in `example`.
You may look at the `generate-testbed.sh` scripts to see the steps that are needed to set it up.

## Container images

We use the prebuild container images from Github.
You could also manually build each image, if you prefer that.

You can pull both the auth and resolver images from these locations:

     podman pull ghcr.io/sidn/pqc-auth-powerdns:latest
     podman pull ghcr.io/sidn/pqc-resolver-powerdns:latest

## New DNSSEC algorithms

We implemented several PQC algorithms in DNSSEC.
Since there are no standards yet, we use custom algorithm numbers, following the table below.
We chose to use 'high' numbers to avoid collisions on the short term.
Basically, we are going from 251 downwards.
These numbers are only valid within our testbed and will, for sure, not be long term.

| Number               | Algorithm     |
| ------------------   | ------------- |
| 251                  | Falcon-512    |
| 250                  | SQIsign1      |
| 249                  | Mayo2         |
