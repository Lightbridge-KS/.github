# Issue forms are numbered `N-name.yml`; the glob skips a future `config.yml`, which has its own schema.
forms := ".github/ISSUE_TEMPLATE/[0-9]*.yml"

# Schema-check every issue form — an invalid form never reaches the issue chooser.
validate:
    uvx check-jsonschema --schemafile https://json.schemastore.org/github-issue-forms.json {{forms}}
    uvx check-jsonschema --builtin-schema vendor.github-workflows .github/workflows/*.yml
