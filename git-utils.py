# -*- coding: utf-8 -*-
import fire

from sh import git


class GitUtils(object):

    def commit_to(self, to_branch, message, push=False, new_branch=False, rebase=False):
        current_branch = git('rev-parse', '--abbrev-ref', 'HEAD').strip()
        print(u'📐\tCommitting changes in {} to {}'.format(current_branch, to_branch))

        git('commit', m=message)
        commit_hash = git('rev-parse', 'HEAD').strip()
        print(u'📝\tSuccessfully created commit with hash "{}"'.format(commit_hash))

        modified_files = git('status', '-s', '-uno').strip()

        if modified_files:
            git('stash')
            print(u'👈\tStashed uncommited changes')

        if new_branch:
            git('checkout', b=to_branch)
        else:
            git('checkout', to_branch)
        print(u'🏃\tMoved to branch "{}"'.format(to_branch))

        git('cherry-pick', commit_hash)
        print(u'🍒\tCherry-picked commit with hash "{}"'.format(commit_hash))

        if push:
            git('push')
            print(u'🙌\tPushed "{}"'.format(to_branch))

        git('checkout', current_branch)
        print(u'🏃\tMoved back to "{}"'.format(current_branch))

        if modified_files:
            git('stash', 'pop')
            print(u'👉\tPut back unstashed changes')

        git('reset', '--hard', 'HEAD~1')
        print(u'🗑\tRemoved new commit from "{}"'.format(current_branch))

        if (rebase):
            git('rebase', to_branch)
            print(u'🚜\tRebased commits from "{}" to the current branch "{}"'.format(
                to_branch,
                current_branch,
            ))

        print(u'🦄\tFinished without errors')


if __name__ == '__main__':
    fire.Fire(GitUtils)
