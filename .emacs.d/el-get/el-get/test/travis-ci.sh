# source me
# Define the following functions here to keep .travis.yml nice and tidy
#   - prereqs()
#   - byte-compile()
#   - check-recipes()
#   - check-whitespace()
#   - ert-tests()

if [ "$EMACS" = 'emacs-snapshot' ]; then
    # If we have only changes to recipe files, there is no need to run
    # with more than 1 emacs version.
    git diff --name-only "$TRAVIS_COMMIT_RANGE" | grep -Fvq recipes/ || exit 0

    prereqs() {
        sudo add-apt-repository -y ppa:cassou/emacs || exit $?;
        sudo apt-get update -qq || exit $?;
        sudo apt-get install -qq --force-yes emacs-snapshot-nox || exit $?;
    }
    # Only need to run these for 1 version, so make them nops here
    check-recipes() { :; }
    check-whitespace() { :; }
else
    prereqs() {
        pkg_compat23=https://raw.githubusercontent.com/mirrors/emacs/ba08b24186711eaeb3748f3d1f23e2c2d9ed0d09
        ert_compat=https://raw.githubusercontent.com/ohler/ert/c619b56c5bc6a866e33787489545b87d79973205
        (mkdir -p pkg && cd pkg &&
                curl --silent --show-error --location \
                     --remote-name $pkg_compat23/lisp/emacs-lisp/package.el \
                     --remote-name $ert_compat/lisp/emacs-lisp/ert.el --remote-name $ert_compat/lisp/emacs-lisp/ert-x.el)
    }
    check-recipes() {
        "$EMACS" -Q -L . -batch -l el-get-check -f el-get-check-recipe-batch \
            -Wno-features -Wno-github -Wno-autoloads \
            recipes/
    }
    check-whitespace() {
        git --no-pager -c core.whitespace=tab-in-indent diff --check "$TRAVIS_COMMIT_RANGE"
    }
fi

folded_call() {
    travis_fold start $1
    $1
    ret=$?
    travis_fold end $1
    return $ret
}

ert-tests() {
    "$EMACS" -batch -Q -L pkg/ -L . -l test/el-get-tests.el -f ert-run-tests-batch-and-exit
}

byte-compile() {
    "$EMACS" -Q -L pkg/ -L . -L methods/ -batch --eval '(setq byte-compile-error-on-warn t)' \
        -f batch-byte-compile *.el methods/*.el
}

# show definitions for log
declare -f prereqs byte-compile ert-tests check-recipes check-whitespace
