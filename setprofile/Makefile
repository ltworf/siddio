all:
	echo "Nothing to do"

install:
	install -D setprofile $${DESTDIR:-/}/usr/bin/setprofile
	install -D -m644 setprofile.bash $${DESTDIR:-/}/etc/bash_completion.d/setprofile
	install -D -m644 setprofile.conf $${DESTDIR:-/}/etc/siddio/setprofile.conf
