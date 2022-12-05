import std/[
  algorithm,
  sequtils,
  strformat,
  sugar,
  os,
]

when isMainModule:
  let files = walkDir(getCurrentDir() / "tests").
    toSeq().
    sorted((a, b) => cmp(a.path, b.path))

  var failures = 0
  for file in files:
    let (_, name, ext) = file.path.splitFile()
    if ext == ".nim" and name[0] == 't' and file.kind in {pcFile, pcLinkToFile}:
      let code = execShellCmd fmt"nim c --outDir:bin --verbosity:0 -r {file.path}"
      if code != 0:
        failures += 1

  echo "Failures: " & $failures
  quit failures
