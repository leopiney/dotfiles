import fire

from sh import git


class GitUtils(object):

    def commit_to(self, to_branch, message, new_branch=False, rebase=False):
        current_branch = git("rev-parse", "--abbrev-ref", "HEAD").strip()
        print('Committing changes in {} to {}'.format(current_branch, to_branch))

        git("commit", m=message)
        commit_hash = git("rev-parse", "HEAD").strip()
        print('Successfully created commit with hash', commit_hash)

        if (new_branch):
            git("checkout", b=to_branch)
        else:
            git("checkout", to_branch)
        print('Moved to branch', to_branch)

        git("cherry-pick", commit_hash)
        print('Cherry-picked commit with hash', commit_hash)

        git("checkout", current_branch)
        print('Moved back to', current_branch)

        git("reset", "--hard", "HEAD~1")

        if (rebase):
            git("rebase", to_branch)
            print('Removed new commit from {} and rebased commits from {}'.format(
                current_branch,
                to_branch
            ))


if __name__ == '__main__':
    fire.Fire(GitUtils)
