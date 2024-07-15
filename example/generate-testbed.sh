#!/bin/bash
#
# Copyright (c) 2024 SIDN Labs
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# 3. Neither the name of the copyright holder nor the names of its
#    contributors may be used to endorse or promote products derived from
#    this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# Experiment PowerDNS Falcon and SQIsign

# We first start the authoritative containers (default without DNSSEC)
podman-compose up   exp1-root -d
podman-compose up   exp1-nl -d
podman-compose up   exp1-sidnlabs -d

# Let's set up DNSSEC on the root server first
echo "setting up dnssec on root server"
podman exec example_exp1-root_1 pdnsutil add-zone-key . KSK inactive sqisign1
podman exec example_exp1-root_1 pdnsutil add-zone-key . ZSK inactive sqisign1
podman exec example_exp1-root_1 pdnsutil activate-zone-key . 1
podman exec example_exp1-root_1 pdnsutil activate-zone-key . 2

# Just to be sure, explicitly clear trust anchor from any previous experiments
if test -f root.dnskey; then
    rm -f root.dnskey
fi

# Obtain trust anchor
echo "exporting trust anchor"
podman exec example_exp1-root_1 pdnsutil export-zone-dnskey . 1 > root.dnskey

echo "setting up trust between root and nl"
podman exec example_exp1-nl_1 pdnsutil add-zone-key nl ZSK active mayo2
podman exec example_exp1-nl_1 pdnsutil export-zone-ds nl | podman exec -i example_exp1-root_1 tee --append /var/lib/powerdns/zones/zone-root
podman exec example_exp1-root_1 pdns_control --socket-dir=/ bind-reload-now .

echo "setting up trust between nl and sidnlabs"
podman exec example_exp1-sidnlabs_1 pdnsutil add-zone-key sidnlabs.nl ZSK active falcon512
podman exec example_exp1-sidnlabs_1 pdnsutil export-zone-ds sidnlabs.nl | podman exec -i example_exp1-nl_1 tee --append /var/lib/powerdns/zones/zone-nl
podman exec example_exp1-nl_1 pdns_control --socket-dir=/ bind-reload-now nl

# Now, we force signing for all SQIsign-enabled servers in this setup: root and sidnlabs.nl
# PROBLEM: if nameserver is not started, this is an endless loop. Check before that nameservers are running...

echo "Forcing root to sign all records"

until dig +retry=0 . axfr -p 5302 @::1 &>/dev/null
do
    echo " ... waiting for nameserver"
    sleep 1
done
echo "Finished signing root"

# In this example, .nl runs Falcon and therefore no action is required.

echo "Forcing sidnlabs.nl to sign all records"
until dig +retry=0 sidnlabs.nl axfr -p 5304 @::1 &>/dev/null
do
    echo " ... waiting for nameserver"
    sleep 1
done
echo "Finished signing sidnlabs.nl"

podman-compose up exp1-resolver-dnssec -d
