# .github

Default [community health files](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file)
for every repository owned by [Lightbridge-KS](https://github.com/Lightbridge-KS). GitHub applies a
file from here to any repository that has none of its own of that type.

## What is here

| File | Applies as |
| --- | --- |
| `.github/ISSUE_TEMPLATE/1-bug.yml` | "Bug report" form — labels the issue `bug` |
| `.github/ISSUE_TEMPLATE/2-feature.yml` | "Feature request" form — labels the issue `enhancement` |
| `.github/pull_request_template.md` | Default PR description |
| `.github/CONTRIBUTING.md` | Default contributing guide |

## How the defaults behave

- **`main` is production.** A push takes effect at once in every repository that falls back to
  these files. Change through a PR; CI schema-checks the forms.
- **Override is total per type.** A repository with anything in its own `.github/ISSUE_TEMPLATE/`
  gets *none* of the default issue forms. The PR template and `CONTRIBUTING.md` are each replaced
  by a repository's own file of the same kind.
- **Defaults are invisible.** They never appear in a repository's file tree or in a clone — only
  in the GitHub web UI, and through the API of *this* repository.
- **Labels must already exist.** The forms apply `bug` and `enhancement`, GitHub's stock labels. A
  label missing from a repository is skipped.
- **Blank issues stay enabled** — GitHub's default, so there is no `config.yml`.
- **CLI and API clients bypass templates.** `gh issue create` cannot use an issue form, and
  `gh pr create --body` applies no PR template. A tool that wants this structure has to ask
  for it, and the two kinds resolve differently:

  - **PR template** — ask GitHub about the *target* repository, not this one. GraphQL
    `repository.pullRequestTemplates { filename body }` returns whichever template applies —
    the target's own, else this default — with the body included. For a fork, query upstream:
    a fork answers with its own owner's defaults. Worked example: the
    [`commit-push-pr`](https://github.com/Lightbridge-KS/agent-stuff/blob/main/plugins/coding/skills/commit-push-pr/SKILL.md)
    skill.
  - **Issue forms** — the API does not expose forms, so read the YAML from this repository,
    unless the target has anything in its own `.github/ISSUE_TEMPLATE/`, which replaces these
    defaults entirely:

    ```sh
    gh api 'repos/Lightbridge-KS/.github/git/trees/HEAD?recursive=1' --jq '.tree[].path'
    gh api 'repos/Lightbridge-KS/.github/contents/.github/ISSUE_TEMPLATE/1-bug.yml' \
      -H 'Accept: application/vnd.github.raw+json'
    ```

    Each field `label` becomes a `###` heading — the same Markdown GitHub renders from a
    submitted form. Unlike the web form, `gh issue create --label` fails on a label the
    repository lacks.

## Editing

```sh
just validate   # schema-check every issue form; needs uv
```

An invalid form never reaches the issue chooser, so validate before merging. Keep descriptions and
placeholders generic: these files serve repositories in several languages.
