# Podman

It is good to have a recent version of podman.
In my (Elmer) experience, the ubuntu 22.04 podman version is ancient and contains bugs that can waste a lot of your time.
So, manually install podman and relevant dependencies: 

## Requirements


	sudo apt-get install \
	  btrfs-progs \
	  crun \
	  git \
	  golang-go \
	  go-md2man \
	  iptables \
	  libassuan-dev \
	  libbtrfs-dev \
	  libc6-dev \
	  libdevmapper-dev \
	  libglib2.0-dev \
	  libgpgme-dev \
	  libgpg-error-dev \
	  libprotobuf-dev \
	  libprotobuf-c-dev \
	  libseccomp-dev \
	  libselinux1-dev \
	  libsystemd-dev \
	  pkg-config \
	  uidmap

	sudo apt install conmon buildah slirp4netns protobuf-compiler catatonit

	# Install Rustup/Cargo (insecure, better install in a different way. We're using this in throw-away containers/VM's only)
	curl https://sh.rustup.rs -sSf | sh

## Installation
Install the latest version of podman (from source). Also install aardvark and netavark.

	git clone https://github.com/containers/podman/
	git clone https://github.com/containers/netavark.git
	git clone https://github.com/containers/aardvark-dns
	git clone git://passt.top/passt

> [!TIP]
> The versions below are probably old by now. Check and adjust as needed. Additionally, use podman 4.9.2 for Ubuntu 22.04 (later versions will give you a headache).

Now, obtain correct versions and build and install all.

	cd passt
	git checkout 2023_12_30.f091893
	cd ..
	cd aardvark-dns
	git checkout v1.10.0
	cd ..
	cd netavark
	git checkout v1.10.3
	cd ..
	cd podman
	git checkout v5.0.2
	cd ..



	cd passt
	make
	sudo make install
	cd ..

	cd aardvark-dns
	make
	sudo make install
	cd ..

	cd netavark
	make
	sudo make install
	cd ..

	cd podman
	make
	sudo make install
	cd ..

## Running as user

If you are going to run rootless containers, they will get killed several minutes after logging out.
To prevent this from happening, please run the following command for your username. 

	sudo loginctl enable-linger $USER

