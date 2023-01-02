# Contributing

<!--
    Short overview, rules, general guidelines, notes about pull requests and
    style should go here.
-->

## Code of Conduct

Please see the [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) document.

## Getting started

First of all, please create a new branch and checkout the branch with `git branch -b <branch_name> master`. Branch names should be a few-word
summary of the feature of the branch, separated by dashes. For example, a branch fixing a bug relating to "upvoting" could be named "upvoting-bugfix".
You could then commit your changes in that branch. 

If you wish to create a pull request, please ensure your branch is up-to-date with the `master` branch by pulling the latest master branch and
merging it into your branch, resolving any merge conflicts.

Also make sure to format the project with `clang-format` following the rules in the `.clang-format` file in the root directory, and making sure
the tests are not failing. See [`HACKING.md`](HACKING.md) for more details.

```sh
git checkout master
git pull
git checkout <your-branch>
git merge master
```


Helpful notes for developers can be found in the [`HACKING.md`](HACKING.md)
document.

In addition to he above, if you use the presets file as instructed, then you
should NOT check it into source control, just as the CMake documentation
suggests.
