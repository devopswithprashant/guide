# Cleaning of raw secret & password from files in git repo.
> This process will clean the secrets/password from git history too. In that git history will going to re-write. Only git SHA id will get change.

## 0. Revoke/rotate the leaked token(s)
Do this in GitLab first. Then fix your pipeline to read the token from a CI secret/variable.


## 1. Make a mirror clone (this creates the directory you’ll work in) f
```sh
git clone --mirror git@github.com:devopswithprashant/dwp-blog-service.git
cd dwp-blog-service.git   # IMPORTANT: run all following commands inside this mirror repo dir
```

You should now be in a folder literally named dwp-blog-service.git (a bare/mirror repo).



## 2. Create a replace rules file (regex to catch all token variants)

```sh
cat > replacements.txt <<'EOF'
# Replace any -Dpassword="glpat-...anything until next quote"
regex:-Dpassword\s*=\s*"glpat-[^"]+"==>-Dpassword=***REMOVED***

# Also handle single quotes: -Dpassword='glpat-...'
regex:-Dpassword\s*=\s*'glpat-[^']+'==>-Dpassword=***REMOVED***

# Also handle no quotes: -Dpassword=glpat-...
regex:-Dpassword\s*=\s*glpat-[^\s"]+==>-Dpassword=***REMOVED***

# (Optional) generic catch-all if someone used other prefixes; comment out if too broad:
# regex:-Dpassword\s*=\s*["'][^"']+["']==>-Dpassword=***REMOVED***
EOF
```



## 3. Rewrite the entire history

```sh
# If not installed: pip install git-filter-repo
git filter-repo --replace-text replacements.txt
```

This scans every blob/commit and replaces matches with -Dpassword=***REMOVED***.



## 4. Garbage-collect old refs and push rewritten history

```sh
# Clean up leftover refs from the rewrite
git for-each-ref --format='delete %(refname)' refs/original | git update-ref --stdin || true
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Force-push *everything* (branches, tags, PR/MR refs) back to GitHub
git push --force --mirror
```

If branch protection blocks force-push on main, temporarily allow it, push, then re-enable protection.



## 5. Verify the secret is gone (history search)

```sh
# Look for any lingering -Dpassword or glpat across history
git rev-list --all | xargs -I{} git grep -n -e '-Dpassword' -e 'glpat-' {} || true
```

No output = good.



## 6. Tell collaborators what to do
Ask teammates to delete their local clones and re-clone:

```sh
rm -rf dwp-blog-service
git clone git@github.com:devopswithprashant/dwp-blog-service.git
```



## Notes & tips
1. We replaced with -Dpassword=***REMOVED*** (no quotes), exactly as you wanted.
2. The regex rules above cover double-quoted, single-quoted, and unquoted tokens, and only target values starting with glpat-. If you also had non-glpat- passwords, uncomment the “generic catch-all” rule to nuke everything assigned to -Dpassword=....
3. After this, move credentials into CI variables (GitHub Actions Secrets / GitLab CI variables) and reference them in your CI scripts, not in the repo.

