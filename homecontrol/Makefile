#!/usr/bin/python3
# Siddio
# Copyright (C) 2017 Salvo "LtWorf" Tomaselli
#
# Siddio is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# author Salvo "LtWorf" Tomaselli <tiposchi@tiscali.it>

all:
	echo nothing to do

install:
	python3 setup.py install --root=$${DESTDIR:-/};
	rm -rf build;
	install -D bin/homecontrol $${DESTDIR:-/}/usr/bin/siddio-homecontrol
	install -D -m644 homecontrol.service $${DESTDIR:-/}/lib/systemd/system/homecontrol.service
	install -D -m644 profiles.conf $${DESTDIR:-/}/usr/share/doc/siddio-homecontrol/profiles.conf
	install -D -m644 profiles.conf $${DESTDIR:-/}/etc/siddio/profiles.conf
	install -D -m644 homecontrol.conf $${DESTDIR:-/}/etc/siddio/homecontrol.conf
#         install -D relational_gui.py $${DESTDIR:-/}/usr/bin/relational-cli
#         install -D relational-cli.1 $${DESTDIR:-/}/usr/share/man/man1/relational-cli.1
