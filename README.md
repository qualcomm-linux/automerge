# Introduction


automerge is a set of scripts used to manage continuous integration of a
set of branches being developed against mainline. Functionally, it aspires
to do what linux-next does.

ci-merge: The script that actually merges the branches together based on a
    config file listing the various branches.
ci-report: Reports any warnings/errors resulting from the build
ci-test: Run some tests on the new build


ci-blame: Helper script used to report the commit ID that introduced a new
    warning/error in the build
ci-config: Helper script that returns the configuration for the branches to
     be used
ci.conf.sample: Sample configuration file

## Quick Start

$ Setup a config file.

  You can do this by creating you own from ci.conf.sample, e.g. in
  $HOME/.automerge/config, or point to an existing with using --config/-f
  option

  Alternatively, pass a YAML file with --yaml-config. The baseline and topics
  are fetched from their configured branches but merged at the pinned sha
  instead of the branch tip:

  baseline:
    repo: "https://github.com/qualcomm-linux/kernel.git"
    branch: qcom-next-staging
    sha: 93f51579e7df248780214094418f205253383cc5

  topics:
    - name: tech/bsp/clk
      repo: "https://github.com/qualcomm-linux/kernel-topics.git"
      branch: tech/bsp/clk
      sha: b6621533052784e753ea37738f720695d47222de

$ export LOCAL_LINUX_REPO=~/work/sources/linux-ci.git
$ export RR_CACHE=ssh://git@git.linaro.org/landing-teams/working/qualcomm/automerge-rrcache.git

(Interactive run)
$ ci-merge -l $LOCAL_LINUX_REPO -c $RR_CACHE -f ~/.automerge/automerge-ci.conf -n
$ ci-merge -l $LOCAL_LINUX_REPO -c $RR_CACHE --yaml-config ~/.automerge/topics.yml -n

## Conflict Resolution and sharing a rerere cache within a team

The following example is used by the Qualcomm Landing Team to update their
shared rerere cache:

1. Make sure you have a local linux repo (LOCAL_LINUX_REPO)

2. If needed, add any new branches to the config file pointed to by -f or
autodetected by ci-config. The Qualcomm Landing Team configs live here[1]

3. Run automerge locally with any new branch or branch modifications
   $ cd <LOCAL_LINUX_REPO>
   $ export RR_CACHE=ssh://git@git.linaro.org/landing-teams/working/qualcomm/automerge-rrcache.git
   $ ci-merge -c $RR_CACHE -f ~/.automerge/automerge-ci.conf -n

   Resolve the merge conflicts till ci-merge runs successfully

4. Commit the rr-cache from .git/rr-cache and then push to git.linaro.org
   $ git commit
   $ git push

   (You might need to setup a pushurl for the rr-cache git repo for git
   push to work)

5. Push your changes to automerge configs or branches to glo[1]

6. Rerun step 3 again. There should be no conflict now, since the resolution was pushed in step 4.

[1] https://git.linaro.org/landing-teams/working/qualcomm/configs.git

## License
automerge is licensed under the GNU General Public License v2.0. See [LICENSE](LICENSE) for the full license text.
 
