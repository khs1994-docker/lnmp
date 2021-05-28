```bash
/etc/containers/certs.d/    <- Certificate directory
└── my-registry.com:5000    <- Hostname:port
   ├── client.cert          <- Client certificate
   ├── client.key           <- Client key
   └── ca.crt               <- Certificate authority that signed the registry certificate
```
