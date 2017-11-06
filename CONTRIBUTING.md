# Contributing

Contributing is a great way to add features to our project, but we need some following steps here. Please make sure that you've read our [code of conduct](https://github.com/MAD-Club/web/blob/master/CODE_OF_CONDUCT.md). By contributing, you are agreeing to our code of conduct.

Some things that will help get your pull request accepted:

- Writing Tests (we can talk about TDD)
- Following our Style Guide
- Writing thorough commit messages
- Commenting!!

## Style Guide

The Swift Styleguide is pretty much straight forward, however there are some key-features that we'd like to input:

* Use 2-Tabs. This is recommended by Apple, and many communities from Swift.
* Thorough comments! We want newcomers to be able to understand what we're doing.
* Have thorough method naming. This means do not call something like `func do`. It must be descriptive.
* When using closures, try to use `weak` or `unowned` to deallocate the variables inside. This is a must to avoid memory leak issues.
