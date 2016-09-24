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

### 5. 实例 root 帐号私钥文件自动备份

该文件会在新实例初始化完成时复制到 `/var/git` 的本地卷中保存，文件名为 `docker.key` 。

注意：`/var/git/projects.list` 文件会作为是否为新实例的标志特征，其不存在时会重新执行初始化逻辑。

### 6. 实例 root 帐号私钥自动还原

如 `/var/git/docker.key` 存在，那么实例会将其作为正确的私钥文件使用，以保障镜像地平滑更新不会影响到服务的稳定性。
