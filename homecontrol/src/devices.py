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
import collections
import socket
import struct

SETSTATE = b's'
GETSTATE = b'g'
GETCOUNT = b'c'
GETNAME = b'n'
GETDESCR = b'd'
GETTAGS = b't'


class Device(collections.namedtuple('device', ('name', 'description', 'tags', 'host', 'port', 'dev_id'))):
    '''
    A device on an iocontrol daemon

    It can query it for state and change it

    The other properties are set statically when probing the iocontrol for
    devices.

    The properties dictionary contains the extra properties defined
    by the user in the configuration file. They are extracted from the
    tags.
    '''
    def __new__(cls, *args, **kwargs):
            self = super(Device, cls).__new__(cls, *args, **kwargs)

            # Set keyword properties
            self.properties = {}
            for tag in self.tags:
                components = tag.split(':', 1)
                if len(components) == 2:
                    self.properties[components[0]] = components[1]
            return self

    def get_state(self):
        '''
        returns the state of the device.

        caches the last known state, doesn't communicate with the device
        '''
        if not hasattr(self, '_state'):
            self.update()
        return self._state

    def update(self):
        '''
        Queries the iocontrol to obtain the state of the device
        '''
        s = socket.socket(socket.AF_INET)
        s.connect((self.host, self.port))
        s.send(GETSTATE + self.dev_id)
        self._state = s.recv(1) == b'\x01'
        s.close()

    def switch(self, new_state: bool):
        if new_state == self.get_state():
            return
        self._state = new_state

        state = b'\1' if new_state else b'\0'
        s = socket.socket(socket.AF_INET)
        s.connect((self.host, self.port))
        s.send(SETSTATE + self.dev_id + state)
        s.close()


def _devices(host: str, port: int):
    r = []
    s = socket.socket(socket.AF_INET)
    s.connect((host, port))

    s.send(GETCOUNT)
    fmt = '!B'
    count = struct.unpack(fmt,s.recv(1))[0]
    for i in range(count):
        dev_id = struct.pack(fmt, i)
        s.send(GETNAME + dev_id +
               GETDESCR + dev_id +
               GETTAGS + dev_id)

        # Read until the required data is over
        data = b''
        while len(data.split(b'\0')) != 4:
            data += s.recv(2048)
        name, descr, tags, _ = (i.decode('utf8') for i in data.split(b'\0'))
        tags = set(tags.split(','))
        r.append(Device(name, descr, tags, host, port, dev_id))
    s.close()
    return r


def devices():
    r = []
    #TODO read hosts from configuration file
    hosts = (('10.9', 4141),)
    for host, port in hosts:
        r += _devices(host, port)
    return r
