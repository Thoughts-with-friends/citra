# Development Note

## Local Build

```Power Shell
./build.ps1 -init
```

## Q & A

- If Git permission denied:

```Power Shell
Get-ChildItem -Recurse -Filter *.sh | ForEach-Object {git update-index --add --chmod=+x "$($_.FullName)" }
```

- Dependencies

```Power Shell
git submodule update --init --recursive
```

## Tasks

- [x] 1. CI build tests

- [x] 2. Qt Emulation tests

- [ ] 3. Reading source codes

  - [ ] android
    - app settings for android
  - [ ] audio_core
    - PCM audio codec and dsp interfaces
  - [ ] citra
    - UI backend
  - [ ] citra-qt
    - UI settings and graphics monitor
  - [ ] common
    - CPU detection, timer, logging and threading, ...
  - [ ] core
    - cheats, file system, hardware, app loader, texture dumping...
  - [ ] dedicated_room
    - room settings for multiplayer (only 1 file)
  - [ ] input_common
    - configure controller mapping, UDP protocol, initialize sdl
  - [ ] network
    - network connection: network.cpp, room.cpp
  - [ ] tests
    - core and common function tests
  - [ ] video_core
    - shader, texture, renderer, and GPU reg to r/w
  - [ ] web_service
    - verify user for room login and web backend

- [ ] Replace Qt GUI with Web-View (Optional)

## References

- Citra: [docs](https://deepwiki.com/weihuoya/citra), [src](https://github.com/weihuoya/citra)
