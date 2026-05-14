# gentoo-overlay-tubo

个人 overlay（约 42 个 ebuild，跨 22 个分类）。`portage/` 通过 bind mount 同时作为 `/etc/portage` 使用——对该目录的修改会立即影响正在运行的系统。

## 首次设置

```bash
./install.sh   # 将 scripts/{post-merge,pre-commit} 符号链接到 .git/hooks，然后运行 post-merge
```

## 提交需要 sudo

`pre-commit` hook 将 `portage/` bind mount 到 `/etc/portage`（如果已挂载则跳过），然后执行 `generate-kernel-config.sh`，该脚本将 `/boot/config-*` 备份到 `profiles/kernel.conf.d/`（过滤掉工具链版本相关行），并 `git add` 这些文件加上 `portage/` 目录树。

## 关键脚本

| 运行方式        | 脚本                          | 作用                                                                                                                                         |
|-----------------|-------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| post-merge 自动 | `scripts/post-merge`          | 生成 `portage/binrepos.conf/gentoobinhost.conf`（自动检测 x86-64 或 x86-64-v3）和 `portage/package.use/00cpu-flags`（通过 `cpuid2cpuflags`） |
| 手动            | `scripts/cleanup_manifest.sh` | 对所有 `*.ebuild` 执行 `ebuild <file> digest`                                                                                                |
| 手动            | `scripts/gentoo-chroot <dir>` | 挂载 proc/sys/dev/run 然后 `chroot <dir>`（挂载路径硬编码为 `/mnt/gentoo`，仅 chroot 目标使用 `$1`）                                         |

## 常用命令

```bash
# 重新生成所有 ebuild 的 Manifest
./scripts/cleanup_manifest.sh

# 测试/安装单个 ebuild
ebuild <path/to/pkg.ebuild> digest
ebuild <path/to/pkg.ebuild> clean merge

# 重新生成 metadata 缓存
egencache --update --repo=gentoo-overlay-tubo --jobs=$(nproc)
```

## 生成的文件（`.gitignore` 已忽略，切勿提交）

- `metadata/md5-cache/`
- `portage/binrepos.conf/`
- `portage/package.use/00cpu-flags`
- `portage/package.use/00video`
- `portage/savedconfig/`

## 编译器环境覆盖

在 `portage/package.env/env` 中设置，定义存放在 `portage/env/` 中：

| 环境                  | 效果                                                      |
|-----------------------|-----------------------------------------------------------|
| `gcc`                 | `CC=gcc`, `AR=ar`                                         |
| `clang`               | `CC=clang`, `AR=llvm-ar`                                  |
| `compiler-pure-clang` | clang + `-stdlib=libc++`                                  |
| `debug`               | `-ggdb3`, `splitdebug`, `compressdebug`, `installsources` |

## Shell 脚本

使用 `#!/usr/bin/env bash` 或 `#!/bin/bash`。`.shellcheckrc` 禁用了 SC2034、SC2154、SC2164。无测试。

## Profiles / 布局

- `metadata/layout.conf`: `masters = gentoo`, `profile-formats = portage-2`
- `profiles/profiles.desc`: `amd64 no-multilib-desktop dev`
- `profiles/no-multilib-desktop/parent`: 继承 `gentoo:default/linux/amd64/23.0/desktop/systemd` + `gentoo:arch/amd64/no-multilib`
- `profiles/kernel.conf.d/`: 自动生成的内核配置备份
- `portage/aria2.conf`: 使用代理 `127.0.0.1:7890`

## 二进制包镜像

优先级：`mirrors.163.com` → `mirrors.tuna.tsinghua.edu.cn` → `mirrors.neusoft.edu.cn`。以二进制包形式获取的大包列在 `portage/package.binpkg/binpkg` 中。
