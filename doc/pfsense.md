## pfSense

pfSense is a firewall/router computer software distribution based on FreeBSD.

- [Dynamic Routing Protocol Basics](https://docs.netgate.com/pfsense/en/latest/recipes/dynamic-routing-basics.html)

- [Disable the Firewall](https://docs.netgate.com/pfsense/en/latest/troubleshooting/locked-out.html)

```bash
pfctl -d
```

That command will disable the firewall, including all NAT functions. Access to the GUI is now possible from anywhere, at least for a few minutes or until a process on the firewall causes the ruleset to be reloaded (which is almost every page save or Apply Changes action). Once the administrator has adjusted the rules and regained the necessary access, turn the firewall back on by typing:

```
pfctl -e
```