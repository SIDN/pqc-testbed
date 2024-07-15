# Post-quantum Algorithm Testing and Analysis for the DNS

This repository contains information to run a testbed using our PQC-ready [resolver](https://github.com/SIDN/pqc-resolver-powerdns) and [authoritative](https://github.com/SIDN/pqc-auth-powerdns) DNS servers.

More information about this project can be found in our blogs ([introduction blog](https://www.sidnlabs.nl/en/news-and-blogs/a-quantum-safe-cryptography-dnssec-testbed), and [the follow-up blog](#) about this testbed) and on the [website](https://patad.sidnlabs.nl/) of the PATAD project.

> [!CAUTION]
> This software is experimental and not meant to be used in production. Use this software at your own risk.

## Container images

We use the prebuild container images from Github.
You could also manually build things each image, if you prefer that.

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

## Running a testbed

An example testbed based is located in `example`.

## Documentation

Until this readme is expanded, please check the docs/ directory for relevant documentation.
