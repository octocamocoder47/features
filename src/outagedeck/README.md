# OutageDeck CLI (via GitHub Releases) (outagedeck)

Check the live status of 170+ cloud and SaaS providers from a terminal or CI
script. OutageDeck normalizes each vendor's official status feed; it does not
replace synthetic monitoring.

## Example usage

```json
"features": {
    "ghcr.io/devcontainers-extra/features/outagedeck:1": {}
}
```

Then query one or more provider slugs:

```bash
outagedeck status aws cloudflare github openai
```

For structured CI output and a nonzero exit code when a provider is down:

```bash
outagedeck status --json --fail-on=outage aws github openai
```

Find more examples in the [OutageDeck CLI repository](https://github.com/outagedeck/cli)
or review the [API documentation](https://outagedeck.com/developers/api?utm_source=devcontainers-extra&utm_medium=feature&utm_campaign=devcontainer_feature).

## Options

| Options Id | Description                                  | Type   | Default Value |
|------------|----------------------------------------------|--------|---------------|
| version    | Select the OutageDeck CLI version to install. | string | latest        |
