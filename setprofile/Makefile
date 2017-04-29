all:
	echo "Nothing to do"

install:
	install -D setprofile $${DESTDIR:-/}/usr/bin/setprofile
	install -D -m644 setprofile.bash $${DESTDIR:-/}/usr/share/bash-completion/completions/setprofile
	install -D -m644 setprofile.conf $${DESTDIR:-/}/etc/siddio/setprofile.conf
