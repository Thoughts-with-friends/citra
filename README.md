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

- Tasks

[ ] CI build tests

[ ]

[ ] Replace GUI (if possible)
