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
	install -m644 -D iocontrol.conf $${DESTDIR:-/}/etc/siddio/iocontrol.conf
	install -m644 -D iocontrol.conf $${DESTDIR:-/}/usr/share/doc/siddio-iocontrol/iocontrol.conf
	install -m644 -D iocontrol.service $${DESTDIR:-/}/lib/systemd/system/iocontrol.service
	install -D src/iocontrol.py $${DESTDIR:-/}/usr/sbin/siddio-iocontrol
