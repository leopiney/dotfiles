use Getopt::Long;
use Pod::Usage;

#
# Adds options to help command
#
my $help = 0;

GetOptions('help|?' => \$help) or pod2usage(2);
pod2usage(1) if $help;

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

my %args;

my $target_branch;
my $message;
my $push;
my $new_branch;
my $rebase;

GetOptions(
  "target-branch=s" => \$target_branch,
  "message=s" => \$message,
  "push+" => \$push,
  "new-branch+" => \$new_branch,
  "rebase+" => \$rebase,
) or die "Invalid arguments!";

$target_branch = ($target_branch or $ARGV[0]);
$message = ($message or $ARGV[1]);

die "Missing target branch!" unless $target_branch;
die "Missing commit message!" unless $message;

#
# Get working branch name
#
my $working_branch = trim(qx/git rev-parse --abbrev-ref HEAD/);
print "📐  Committing changes in $working_branch to $target_branch\n";

#
# Commit the stashed changes
#
qx/git commit -m "$message"/;

my $commit_hash = trim(qx/git rev-parse HEAD/);
print "📝  Successfully created commit with hash $commit_hash\n";

#
# If there are pending changes, we stash them so as to not have
# problems when switching branches
#
my $modified_files = trim(qx/git status -s -uno/);
if ($modified_files) {
  qx/git stash/;
  print "👈  Stashed uncommited changes\n";
}

#
# Start a new branch if necessary
#
if ($new_branch) {
  qx/git checkout -b $target_branch/;
} else {
  qx/git checkout $target_branch/;
}
print "🏃  Moved to branch $target_branch\n";

#
# Cherry pick the commit we created in the working branch
#
qx/git cherry-pick $commit_hash/;
print "🍒  Cherry-picked commit with hash $commit_hash\n";

#
# If push was required, we first pull and rebase the target branch
# and then we push the commit
#
if ($push) {
  qx/git pull --rebase origin $target_branch/;
  qx/git push/;
  print "🙌  Pushed $target_branch to remote\n";
}

#
# Go back to the original branch and stash pop the previous changes
#
qx/git checkout $working_branch/;
print "🏃  Moved back to $working_branch\n";

if ($modified_files) {
  qx/git stash pop/;
  print "👉  Put back unstashed changes\n"
}

#
# Remove the original commit from the current branch
#
qx/git reset --hard HEAD~1/;
print "🗑  Removed new commit from $working_branch\n";

#
# Perform rebase if requested
#
if ($rebase) {
  qx/git rebase $target_branch/;
  print "🚜  Rebased commits from $target_branch to branch $working_branch\n";
}

print "🦄 Finished without errors\n"

__END__
=head1 NAME

git-commit-to - Commit from your branch to another one with ease

=head1 SYNOPSIS

git-commit-to branch message [options]

  Options:
    --help            Displays this message
    --t[arget-branch]     Target branch.
    --m[essage]       The commit message.
    --p[push]         After adding the commit to the target branch, it rebases the branch and pushes.
    --n[ew-branch]    The target branch is a new branch.
    --r[ebase]        Performs a rebase from the target branch to the current branch after the commit is added.


=cut
