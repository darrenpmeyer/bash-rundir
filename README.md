# bash-rundir

`rundir.sh` runs all executable files in a directory, recursively and in sorted order. Kinda like run-parts on Debian

```
./rundir.sh DIR args
```

Finds executables in or underneath `DIR` and executes them in the order of `sort`, passing each of them `args`
