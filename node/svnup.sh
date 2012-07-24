#!/bin/sh
update() {
 /usr/bin/svn cleanup /usr/deploy$1
 /usr/bin/svn up /usr/deploy$1
}

update $1
