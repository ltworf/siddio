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
import socket
import struct

SETSTATE = b's'
GETSTATE = b'g'
GETCOUNT = b'c'
GETNAME = b'n'
GETDESCR = b'd'
GETTAGS = b't'



class Device():
    def __init__(self, name: str, description: str, tags: set, state: bool, host: str, port: int, dev_id: bytes):
        self.name = name
        self.description = description
        self.tags = tags
        self.state = state
        self.host = host
        self.port = port
        self.dev_id = dev_id

    def switch(self, new_state: bool):
        if new_state == self.state:
            return
        self.state = new_state

        state = b'\1' if new_state else b'\0'
        s = socket.socket(socket.AF_INET)
        s.connect((self.host, self.port))
        s.send(SETSTATE + self.dev_id + state)
        s.close()


def devices(host: str, port: int):
    r = []
    s = socket.socket(socket.AF_INET)
    s.connect((host, port))

    s.send(GETCOUNT)
    fmt = '!B'
    count = struct.unpack(fmt,s.recv(1))[0]
    for i in range(count):
        dev_id = struct.pack(fmt, i)
        s.send(GETSTATE + dev_id +
               GETNAME + dev_id +
               GETDESCR + dev_id +
               GETTAGS + dev_id)

        #Read the state
        state_data = s.recv(1)
        state = state_data == b'\x01'

        # Read until the required data is over
        data = b''
        while len(data.split(b'\0')) != 4:
            data += s.recv(2048)
        name, descr, tags, _ = (i.decode('utf8') for i in data.split(b'\0'))
        tags = set(tags.split(','))
        r.append(Device(name, descr, tags, state, host, port, dev_id))
    s.close()
    return r


if __name__ == '__main__':
    for device in devices('10.9', 4141):
        device.switch(False)
