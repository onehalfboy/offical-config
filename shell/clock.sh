#!/bin/bash
*/5 * * * * /usr/sbin/ntpdate monitor.50bang.org && /sbin/hwclock -w
