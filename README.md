基于 [alpine](http://alpinelinux.org):[3.4](https://dev.aliyun.com/detail.html?repoId=1192) 制作的 [gitolite][] 超简版本。仅实现 `ssh+git` 工作模式。如有需要，请[自行定制](https://github.com/snakevil-docker/gitolite)。

[gitolite]: http://gitolite.com

运行参数
---

### EXPOSE `22`

### VOLUME `/var/git`

### ENTRYPOINT [`/srv/up`](https://github.com/snakevil-docker/gitolite/blob/master/src/srv/up)

制作流程
---

### 1. 更新 [gitolite][]

```
cd share/gitolite.git
git pull
cd ../..
```

### 2. 制作镜像

```
make
```

### 3. 镜像更名

```
docker tag gitolite <NEW_TAG>
```


功能特性
---

### 1. 自定义入口程序

```
docker run -it --rm snakevil/gitolite /bin/sh
```

### 2. 自动添加帐号

将要添加的帐号公钥文件 `<USER>.pub` 存入 `/var/git` 的本地卷，重启实例即可。

### 3. 自动添加管理员

将要添加的管理员公钥文件命名为 `@<USER>.pub` 后存入 `/var/git` 的本地卷，重启实例即可。

### 4. 简要运行日志

实例启动后，会在 `/var/git` 的本地卷中创建名为 `docker.log` 的日志文件。
