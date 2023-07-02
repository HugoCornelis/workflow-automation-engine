# this file should be copied to /usr/share/grc/
#
# Colors available for configuration are:
#
#    Black
#    Red
#    Green
#    Yellow
#    Blue
#    Magenta
#    Cyan
#    White
#
# add this at the top of /etc/grc.conf
#
#
# # neurospaces workflow
# (^|[/\w\.]+/)workflow
# conf.workflow
#
#
# targets
# regexp=ccr(?!-workflow)
# colours=green bold
# -
# regexp=all
# colours=green bold
# -
# regexp=ip_routing
# colours=green bold
# -
# commands
regexp=(\S+) --dry
colours=yellow bold
-
regexp= --dry
colours=white
-
# specific IP addresses
regexp=^.*192\.168\.[45]\..*$
colours=green bold
-
# MAC addresses
regexp=(([a-zA-Z0-9][a-zA-Z0-9]:){5}[a-zA-Z0-9][a-zA-Z0-9])
colours=blue
-
# vlans
regexp=(vlan_id: [0-9]{1,4})
colours=cyan bold
-
# interfaces
regexp=(enp[03456]\w*)
colours=white underline
-
regexp=(eth[012]\w*)
colours=white underline
-
regexp=(lan[1234]\w*)
colours=white underline
-
regexp=(enx............)
colours=white underline
-
regexp=wlp1s0
colours=white underline
-
regexp=wlo1
colours=white underline


