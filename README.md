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
