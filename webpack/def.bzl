
def get_transitive_files(ctx):
  s = set()
  for dep in ctx.attr.deps:
    s += dep.transitive_files
  s += ctx.files.srcs
  return s


def webpack_library_impl(ctx):
  return struct(
      files=set(),
      transitive_files=get_transitive_files(ctx))


def webpack_binary_impl(ctx):
  files = list(get_transitive_files(ctx))

  ctx.action(
      inputs=files + ctx.files.node_modules + [ctx.file.cfg],
      outputs=[ctx.outputs.out, ctx.outputs.sourcemap],
      executable=ctx.executable.webpack_,
      env={
          "WEBPACK_CFG": ctx.file.cfg.path,
          # Can't set NODE_PATH, because the node binary overrides
          # it. Instead, I'll append to that later.
          "EXTRA_NODE_PATH": './' + ctx.bin_dir.path + ":./" + ctx.genfiles_dir.path,
          "GEN_DIR": ctx.outputs.out.root.path,
      },
  )


webpack_library = rule(
  implementation = webpack_library_impl,
  attrs = {
      "srcs": attr.label_list(allow_files=True),
      "deps": attr.label_list(allow_files=False),
  },
)


webpack_binary = rule(
    implementation = webpack_binary_impl,
    attrs = {
        "webpack_": attr.label(
            cfg = "host",
            default=Label("//webpack:pack"),
            allow_files=True,
            executable=True),
        "cfg": attr.label(allow_files=True, single_file=True),
        "deps": attr.label_list(allow_files=True),
        "srcs": attr.label_list(allow_files=True),
        "node_modules": attr.label(single_file=True),
    },
    outputs = {
        "out": "%{name}.js",
        "sourcemap": "%{name}.js.map",
    },
)
