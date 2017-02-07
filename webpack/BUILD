package(default_visibility=["//visibility:public"])

load("@org_pubref_rules_node//node:rules.bzl", "node_binary")

node_binary(
    name = "pack",
    main = "pack.js",
    modules = [
        # This is hardcoded. This means users MUST have npm_repositories
        # named "npm_modules" and "npm_dev_modules" that will
        # be used by this BUILD rule.
        #
        # Technically, it would be nice to have this included by this
        # repo in one way or another, with a fixed version of webpack.
        # The problem is that each user will want various webpack plugins
        # or other things, and I'm not sure how to deal with that.
        #
        # I also suspect it should be possible to split those two, and
        # use the dev_modules only for webpack, compiler, etc, and use the
        # other for actually building the project.
        "@npm_modules//:modules",
        "@npm_dev_modules//:modules",
    ],
)
