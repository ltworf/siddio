all:
	echo nothing to do

install:
	install -m644 -D iocontrol.conf $${DESTDIR:-/}/etc/siddio/iocontrol.conf
	install -m644 -D iocontrol.conf $${DESTDIR:-/}/usr/share/doc/siddio-iocontrol/iocontrol.conf
	install -m644 -D iocontrol.service $${DESTDIR:-/}/lib/systemd/system/iocontrol.service
	install -D src/iocontrol.py $${DESTDIR:-/}/usr/sbin/siddio-iocontrol
