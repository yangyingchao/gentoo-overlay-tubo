# gentoo-overlay-tubo

个人 Gentoo overlay（~42 ebuild，22 分类）。`portage/` bind mount 到 `/etc/portage`。

## 构建 / Lint / 测试

```bash
ebuild <path/to/pkg.ebuild> digest && ebuild <path/to/pkg.ebuild> clean merge  # 单 ebuild
./scripts/cleanup_manifest.sh    # 批量 digest
egencache --update --repo=gentoo-overlay-tubo --jobs=$(nproc)  # metadata 缓存
shellcheck scripts/*.sh          # .shellcheckrc 禁用 SC2034 SC2154 SC2164
```

## Ebuild 规范

- EAPI=8，Copyright `# Copyright 1999-2026 Gentoo Authors`，License `GPL-3+`（或看情况）
- Tab 缩进，KEYWORDS="amd64"；live ebuild（9999）inherit `git-r3`
- DEPEND/RDEPEND/BDEPEND 分开；`src_configure` 用 `$(meson_feature ...)` / `$(usev ...)` 风格
- `sed ... || die` 必须有 `|| die`，不要静默失败

## Shell 脚本规范

- Shebang `#!/usr/bin/env bash`，repo 根有 `.shellcheckrc`
- `die()` 自行定义，不依赖外部库；`pushd`/`popd` 替代 `cd`；`$(git rev-parse --show-toplevel)` 定位 root
- `${VAR}` 引用格式；SC2154 豁免仅限外部注入变量

## 生成文件（勿提交）

`metadata/md5-cache/` `portage/binrepos.conf/` `portage/package.use/00cpu-flags` `portage/package.use/00video` `portage/savedconfig/`

## 提交

`pre-commit` hook 会 bind mount `portage/`→`/etc/portage`，备份内核配置到 `profiles/kernel.conf.d/`，`git add portage/`。需要 sudo。
