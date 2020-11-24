# HOWtO run this project localy

## Requirements

* multipass
* kubectl
* helm version 3

Required packages could be installed in MacOS with brew:

```shell
brew cask install multipass
brew install kubectl helm
```

## How to run environment

To start dummy k8s cluster, build containers and deploy applications into cluster please run:

```shell
bash ./manage.sh start
```

To stop machine and destroy it:

```shell
bash ./manage.sh stop
```

## Tests

Tests were performed with [bombardier](https://github.com/codesenberg/bombardier/).

```shell
└─[0] <> bombardier -c 100 -l -n 1000000 http://192.168.64.3:30050/calc\?vf\=200\&vi\=5\&t\=123
Bombarding http://192.168.64.3:30050/calc?vf=200&vi=5&t=123 with 1000000 request(s) using 100 connection(s)
 4060 / 1000000 [=========================================================================================================================================================================================================================================================] 100.00% 1693/s 9m50s
Done!
Statistics        Avg      Stdev        Max
  Reqs/sec       629.64     243.82    3456.62
  Latency      158.91ms    90.98ms      3.32s
  Latency Distribution
     50%   152.27ms
     75%   171.39ms
     90%   192.89ms
     95%   210.01ms
     99%   270.90ms
  HTTP codes:
    1xx - 0, 2xx - 348782, 3xx - 0, 4xx - 0, 5xx - 22806
    others - 0
  Throughput:   161.69KB/s
```

```shell
Bombarding http://192.168.64.3:30050/calc?vf=200&vi=5&t=123 with 1000000 request(s) using 100 connection(s)
 56668 / 1000000 [========================================================================================================================================================================================================================================================] 100.00% 10420/s 1m35s
Done!
Statistics        Avg      Stdev        Max
  Reqs/sec       592.26     248.93    2155.11
  Latency      168.81ms    66.77ms      2.23s
  Latency Distribution
     50%   159.63ms
     75%   183.15ms
     90%   211.22ms
     95%   235.65ms
     99%   325.48ms
  HTTP codes:
    1xx - 0, 2xx - 55697, 3xx - 0, 4xx - 0, 5xx - 1098
    others - 0
  Throughput:   152.11KB/s
```

## Potential hacks to improve response

Since we know that our application stops working after specific period of time, we could add logic to kill pods randomly before one of the pods fails. This could be done for example with [pod-reaper](https://github.com/ptagr/pod-reaper).
