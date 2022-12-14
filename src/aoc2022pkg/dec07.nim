import std/[
  options,
  os,
  sets,
  strutils,
]

const THRESHOLD = 100000

type FsKind = enum
  fsFile,
  fsDir,

type NodeIdx = distinct int
const ROOT = NodeIdx(-1)
template `==`(a, b: NodeIdx): bool = a.int == b.int

type FsNode = object
  name: string
  parent: NodeIdx
  size: uint64
  case kind: FsKind
  of fsDir:
    children: seq[NodeIdx]
  else: discard

type FsTree = object
  fs: seq[FsNode]
  smallest: HashSet[NodeIdx]

proc newFsTree(): FsTree = FsTree(fs: @[], smallest: initHashSet[NodeIdx](10))

proc addFile(t: var FsTree, name: string, size: uint64, parent: NodeIdx): NodeIdx =
  result = NodeIdx(t.fs.len)
  t.fs.add FsNode(
    name: name,
    kind: fsFile,
    size: size,
    parent: parent,
  )

  t.fs[parent.int].children.add result

proc computeDirSizes(t: var FsTree) =
  var stack = newSeqOfCap[NodeIdx](t.fs.len)
  stack.add(NodeIdx(0))
  while stack.len > 0:
    let idx = stack.pop()
    for child in t.fs[idx.int].children:
      if t.fs[child.int].kind == fsDir:
        stack.add(child)
      else:
        t.fs[idx.int].size += t.fs[child.int].size
    var current = t.fs[idx.int].parent
    while current != ROOT:
      t.fs[current.int].size += t.fs[idx.int].size
      current = t.fs[current.int].parent

proc computeSmallest(t: var FsTree) =
  for nodeIdx in 0 ..< t.fs.len:
    let node = t.fs[nodeIdx]
    if node.kind == fsDir and node.size < THRESHOLD:
      t.smallest.incl nodeIdx.NodeIdx

proc addDir(t: var FsTree, name: string, parent: NodeIdx): NodeIdx =
  result = NodeIdx(t.fs.len)
  t.fs.add FsNode(
    name: name,
    kind: fsDir,
    children: @[],
    size: 0,
    parent: parent,
  )
  if parent != ROOT:
    t.fs[parent.int].children.add result

proc findChild(t: FsTree, parent: NodeIdx, name: string): Option[NodeIdx] =
  for child in t.fs[parent.int].children:
    if t.fs[child.int].name == name:
      return some(child)
  return none(NodeIdx)

proc parseFs(input: string): FsTree =
  result = newFsTree()
  let rootDir = result.addDir("<root>", ROOT)
  var cwd = rootDir
  let lines = input.splitLines
  var i = 0
  proc consumeLine(): string =
    result = lines[i]
    inc i
  proc unconsumeLine() =
    dec i
  while i < lines.len:
    var line = consumeLine()
    assert line.startsWith "$ "
    case line[2]
    of 'c':
      # cd <dir>
      var targetPath = line[5 .. ^1].split('/')
      if targetPath[0].isEmptyOrWhitespace:
        cwd = rootDir
        targetPath = targetPath[1 .. ^1]
      for elem in targetPath:
        if elem.isEmptyOrWhitespace:
          continue
        if elem == "..":
          cwd = result.fs[cwd.int].parent
          continue
        let existingDir = result.findChild(cwd, elem)
        cwd = if existingDir.isSome:
          existingDir.get
        else:
          result.addDir(elem, cwd)
    of 'l':
      # ls
      while true:
        let line = consumeLine()
        if line.isEmptyOrWhitespace:
          break
        if line[0] == '$':
          unconsumeLine()
          break
        let parts = line.splitWhitespace()
        assert parts.len == 2
        let size = parts[0]
        let name = parts[1]
        if size == "dir":
          let existingDir = result.findChild(cwd, name)
          if existingDir.isNone:
            discard result.addDir(name, cwd)
        else:
          discard result.addFile(name, parseBiggestUInt(size), cwd)
    else:
      raiseAssert "Unknown command: " & line[2 .. ^1]

proc run*(input: string, part: int): string =
  var tree = parseFs(input)
  tree.computeDirSizes()
  tree.computeSmallest()
  # tree should be full
  assert tree.fs[0].size > 0
  if part == 1:
    var total = 0.uint64
    for s in tree.smallest:
      total += tree.fs[s.int].size
    $total
  else:
    var avail = 70000000.uint64 - tree.fs[0].size
    const goal = 30000000.uint64
    var candidate = 0
    for (i, ent) in tree.fs.pairs:
      if (
        ent.kind == fsDir and
        ent.size + avail >= goal and
        ent.size < tree.fs[candidate].size
      ):
        candidate = i
    $tree.fs[candidate].size
