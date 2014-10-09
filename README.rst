=============
Docker images
=============

Docker images to build a Loads cluster. Everything is driven by a Makefile.

Build the Docker images::

    $ make build_influx
    $ make build_broker

Install Circus and the Loads client::

    $ make build

Run everything::

    $ export AWS_SECRET_ACCESS_KEY=xxx
    $ export AWS_SECRET_ACCESS_KEY=xxx
    $ make run

Once the containers are started, the Loads broker is available on the local port
8080 port and the InfluxDB dashboard on the port 8083.

Check out http://localhost:8083 and set the host port to 8086, and make sure
you can connect with root/root.

You can then interact with the broker using the loads client.

    $ bin/loads info
    {"runs": [], "status": 200, "version": "0.1", "success": true}
