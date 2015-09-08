# docker-ambassador

This docker image is a mashup of [ctlc/ambassador](https://github.com/CenturyLinkLabs/ctlc-docker-ambassador) and [suutari/ambassador](https://github.com/suutari/docker-ambassador). It was made for the [OpenSTF](https://github.com/openstf/stf) example deployment when we realized `ctlc/ambassador` was pretty much completely broken.

While there are practically endless existing ambassador images out there, having our own ambassador image allows us more flexibility.

1. No one will suddenly decide to change the image in a way that breaks it.
2. It's way, way smaller (~6.5MB vs `ctlc/ambassador`'s ~185MB) while still being an automated build.
3. Doesn't do stupid things like `watch ls` or `top` to keep the background jobs alive. The `wait` shell built-in is perfect and doesn't waste resources.
4. Unlike most other ambassador implementations, dies if the underlying `socat` dies, allowing your supervisor of choice (e.g. [systemd](http://www.freedesktop.org/wiki/Software/systemd/)) to take over and possibly restart the socket. Make sure to read [Caveats](#caveats), though.
5. Attempts to shut down cleanly.

Also, note that we are NOT claiming that this old-school ambassador pattern is the best way to go today. It's simply one way to do things.

## Usage

The "[Link via an ambassador container](https://docs.docker.com/articles/ambassador_pattern_linking/)" article on the Docker website explains the ambassador pattern and potential usage quite clearly. Just replace `svendowideit/ambassador` with `openstf/ambassador` where required.

## Caveats

If the internal `socat` somehow manages to die, it won't get restarted. Instead, the container dies with it. We recommend using a proper [systemd Service unit](http://www.freedesktop.org/software/systemd/man/systemd.service.html) for automatically restarting it.

However, if your ambassador handles more than one link, then even if all links except one die, the ambassador will happily stay alive waiting for the last link to die too, which means that systemd won't notice a thing and has no chance to restart the unit to reopen sockets. Most if not all traditional ambassador pattern implementations suffer from this problem as well, many of them even if you're only using a single link.

## License

See [LICENSE](LICENSE).

Copyright © Simo Kinnunen. All Rights Reserved.
