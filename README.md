snakevil/gitolite
===

基于 [snakevil/base][base] 构建地 [gitolite][] 超简版本。仅实现 `ssh+git` 工作模式。如有需要，请自行定制。

[base]: https://github.com/snakevil/base
[gitolite]: http://gitolite.com

EXPOSE
---

* 22

VOLUME
---

* `/mnt/git`

    版本库目录的外挂卷。

导入资源
---

* `/mnt/git/docker.key`

    *可选。* 现有版本库目录的管理员证书私钥。


导出资源
---

* `/mnt/git/docker.key`

    容器初始化版本库目录时所使用的管理员证书私钥。
