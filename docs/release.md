# Release Checklist

This guide documents the steps to prepare a release of Task Manager.

## Pre-Release

1. Ensure `./scripts/verify.sh` passes locally.
2. Review open issues and pull requests.
3. Update `README.md` and docs if behavior changed.
4. Confirm that CI is green on `main`.

## Versioning

The project does not currently publish gem versions, but if you decide to package it:

- Follow semantic versioning: `MAJOR.MINOR.PATCH`.
- Increment:
  - **MAJOR** for breaking CLI changes.
  - **MINOR** for new features.
  - **PATCH** for bug fixes.

## Release Steps

1. Create a release branch: `release/x.y.z`.
2. Update changelog (if introduced).
3. Run verification:

```bash
./scripts/verify.sh
```

4. Tag the release:

```bash
git tag -a vX.Y.Z -m "Release vX.Y.Z"
```

5. Push tags:

```bash
git push origin vX.Y.Z
```

6. Create GitHub release notes.

## Post-Release

- Monitor CI for any regressions.
- Address urgent issues quickly.
- Communicate release notes to users.

## Backporting Fixes

If critical fixes are needed:

1. Create a hotfix branch from the release tag.
2. Apply the fix.
3. Run `./scripts/verify.sh`.
4. Tag a patch release.

## Checklist Summary

- [ ] Tests pass locally.
- [ ] Docs updated.
- [ ] Version tagged.
- [ ] CI green.
- [ ] Release notes published.

## Optional Packaging

If you decide to publish this as a gem, add:

- `task_manager.gemspec`
- A `lib/task_manager/version.rb` file
- A `CHANGELOG.md`

Ensure any build scripts run successfully before publishing.
