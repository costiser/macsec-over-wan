# MACsec over WAN or Internet

MACsec over WAN or Internet is a leftover from [MACsec on Linux](/2016/08/01/macsec-implementation-on-linux/) that I first tested in 2016 when support for MACsec was just included in the kernel. MACsec adds protection such as integrity, origin authentication and optionally encryption, at Layer 2, between host and access switch, between two access switches or between hosts. This article presents a different scenario when MACsec is used together with a Layer 2 GRE tunnel to protect the traffic between two remote sites, over WAN or Internet, like a site-to-site VPN  at Layer 2.

