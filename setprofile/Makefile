all:
	echo "Nothing to do"

install:
	install -D setprofile $${DESTDIR:-/}/usr/bin/setprofile
	install -D -m644 setprofile.bash $${DESTDIR:-/}/usr/share/bash-completion/completions/setprofile
	install -D -m644 setprofile.conf $${DESTDIR:-/}/etc/siddio/setprofile.conf
	install -D -m644 setprofile.1 $${DESTDIR:-/}/usr/share/man/man1/setprofile.1
	install -D -m644 setprofile.conf.5 $${DESTDIR:-/}/usr/share/man/man5/setprofile.conf.5
