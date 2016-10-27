snakevil/gitolite
===

基于 [snakevil/base][base] 构建地 [gitolite][] 超简版本。仅实现 `ssh+git` 工作模式。如有需要，请自行定制。

[base]: https://github.com/snakevil-docker/base
[gitolite]: http://gitolite.com

EXPOSE
---

* 22

VOLUME
---

* `/mnt/git`

    版本库目录的挂载卷。

导入资源
---

* `/mnt/_/id_rsa` 和 `/mnt/_/id_rsa.pub`

    *可选。* 现有版本库目录的管理员证书公私钥文件。

    **警告：**文件不存在时，容器无法对既有版本库进行管理。因此，容器会将挂载卷中的既有文件备份至 `/mnt/git/-backup-<DATETIME>` 目录，然后重新初始化 [gitolite][]。

导出资源
---

* `/mnt/_/id_rsa` 和 `/mnt/_/id_rsa.pub`

    容器初始化版本库目录时所使用的管理员证书公私钥文件。

    **警告：**除非确定要重新初始化 [gitolite][]，否则请保留文件以便容器自行导入。
