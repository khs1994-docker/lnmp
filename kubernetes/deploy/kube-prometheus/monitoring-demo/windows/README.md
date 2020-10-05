* https://github.com/prometheus-community/windows_exporter

## 启动 windows metrics

```powershell
# $ .\wmi_exporter-0.11.0-amd64.exe --help

$ .\wmi_exporter-0.11.0-amd64.exe --collectors.enabled="cpu,cs,logical_disk,net,os,system,textfile"
```

监听 `9182` 端口

## 部署监控

```bash
$ kubectl apply -k .
```

## grafana

10467
