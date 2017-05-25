# siddio
I'm collecting here the various parts of my home automation project.

It is based on profiles, defined using relational algebra.

Every controlled device can have some user defined properties, for example you
can have:

  * Location
  * Type

And then you can define a profile to turn the lamps on in the kitchen, but keep
the oven on.


homecontrol
===========

The main daemon. It needs to be configured to control some iocontrol daemons.

Its configuration defines profiles.

iocontrol
=========

A daemon for RaspberryPi. It reads a device configuration and uses some pins to
control the devices.

It is meant to be controlled by an homecontrol daemon.

panel
=====

A Qt app (with UI meant for a phone, but runs fine on desktop too) to show
weather forecast, västtrafik time table and set homecontrol profiles.

setprofile
==========

Shell utility to set the profiles in use by homecontrol.

It supports bash completion!

plasma-vasttrafikboard
======================

It's a plasma widget to show the incoming public transport, using the
västtrafik API.

Since the code was there for panel, made sense to reuse it in a plasmoid.
