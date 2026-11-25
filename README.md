# GraveLauncher

> Forked from [Pandora Launcher](https://github.com/Moulberry/PandoraLauncher) by Moulberry, licensed under the MIT License (see [LICENSE](LICENSE)). GraveLauncher is an independent fork and is not affiliated with or endorsed by Moulberry.

Work in progress

## Features
- (Optional) sandboxing, to prevent mods from harming your system
- Cross-instance file syncing (options, saves, etc.) (https://youtu.be/wb5EY2VsMKg)
- Mod deduplication when installed through launcher (using reflinks or hard links)
- Secure account credential management using platform keyrings
- Uncapped live game log output
- Content browser providing mods from Modrinth and CurseForge
- Unique approach to modpack management (https://youtu.be/cdRVqd7b2BQ)
- Native application (no Electron/Tauri)
- No third-party metadata servers (no downtime, no delay when MC updates)
- Automatic redaction of sensitive information (i.e. access tokens) in logs

## FAQ

### Where can I suggest a feature/report a bug?

Please use [GitHub issues](https://github.com/amardeeplakshkar/PandoraLauncher/issues) on this repository.

### Why should I use GraveLauncher over other launchers?

1. If you like one of the features above
2. If you like the general design/ux of the launcher, personally I find it very easy to use
3. The launcher is designed to be performant, from storage space to cpu and memory usage

### Will GraveLauncher be monetized?

Unlikely, for a few reasons:
- I believe that it is wrong for launchers to be monetized without distributing revenue back to mod creators that give the launcher value in the first place. Since I don't have the infrastructure to be able to redistribute revenue to mod creators, this is a big barrier.
- Dealing with monetization takes a lot of (ongoing) work, probably more work than creating the launcher itself.
- I personally dislike advertisements.

## Instance Page
![Instance Page](https://raw.githubusercontent.com/amardeeplakshkar/PandoraLauncher/refs/heads/master/screenshots/instance.png)

## Credits

GraveLauncher is forked from [Pandora Launcher](https://github.com/Moulberry/PandoraLauncher) by Moulberry. The original MIT license and copyright notice are retained in [LICENSE](LICENSE).
