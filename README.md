# Note

## Q & A

- If Git Permission Denied

```Power Shell
Get-ChildItem -Recurse -Filter *.sh | ForEach-Object {git update-index --add --chmod=+x "$($_.FullName)" }
```

- Deps Libs

```Power Shell
git submodule update --init --recursive
```

## Tasks

- [x] CI build tests

- [ ] Reading Source Code

  - [ ] core
  - [ ] common
  - [ ] citra
  - [ ] citra-qt
  - [ ] ...

- [ ] Replace Qt GUI with Web-View
