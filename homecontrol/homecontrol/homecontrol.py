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
import asyncore
import socket
import struct
import sys
from syslog import *

from configobj import ConfigObj
from setproctitle import setproctitle

from homecontrol import profiles


PROFILE_ACTIVATE = b'a'
PROFILE_LIST = b'l'


class AsyncConnection(asyncore.dispatcher_with_send):
    def __init__(self, pair) -> None:
        asyncore.dispatcher_with_send.__init__(self, pair[0])
        addr = pair[1]
        self.logid = '%s:%d' % addr

    def handle_read(self):
        command = self.recv(1)
        syslog(LOG_DEBUG, '%s command: 0x%s' % (self.logid, command.hex()))
        if command == PROFILE_ACTIVATE:
            pname = self.recv(1024).decode('utf8')
            profile = profiles.get_profile(pname)
            if not profile:
                syslog(LOG_NOTICE, 'Profile %s does not exist' % pname)
            else:
                syslog(LOG_INFO, 'Activating profile: %s' % pname)
                profile.activate()
        elif command == PROFILE_LIST:
            pnames = (pname.encode('utf8') for pname in profiles.get_profiles())
            self.send(b'\n'.join(pnames))
        else:
            syslog(LOG_ERR, '%s invalid command: 0x%s' % (self.logid, command.hex()))
        self.close()

class AsyncServer(asyncore.dispatcher):

    def __init__(self, host: str, port: int) -> None:
        asyncore.dispatcher.__init__(self)
        self.create_socket(socket.AF_INET, socket.SOCK_STREAM)
        try:
            self.set_reuse_addr()
            self.bind((host, port))
            self.listen(5)
        except OSError as e:
            syslog(LOG_ERR, 'Unable to bind socket %s:%d' % (host, port))
            sys.exit(1)

    def handle_accept(self) -> None:
        pair = self.accept()
        if pair:
            sock, addr = pair
            connection = AsyncConnection(pair)


def main():
    setproctitle('homecontrol')
    openlog('homecontrol')
    syslog(LOG_INFO,'Starting siddio-homecontrol')
    profiles.load_profiles('/etc/siddio/profiles.conf')

    conf = ConfigObj('/etc/siddio/homecontrol.conf')
    port = int(conf.get('Server', {}).get('port', 4040))
    address = conf.get('Server', {}.get('address', '0.0.0.0')
    server = AsyncServer(address, port)
    asyncore.loop()


if __name__ == '__main__':
    main()
