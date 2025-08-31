#!/usr/bin/env zsh

source .env
true_hugo_version=$(hugo version | grep -E -o 'v([0-9.]+)' | grep -E -o '([0-9.]+)')
if [[ "$HUGO_VERSION" != "$true_hugo_version" ]]
then
  print -P '%F{red}Hugo Version Mismatch\n%F{reset}'
fi

hugo version
pre-commit run --all-files
markdownlint-cli2 --config .markdownlint-cli2.jsonc 'content/**/**.md'
# https://gohugo.io/troubleshooting/audit/
HUGO_MINIFY_TDEWOLFF_HTML_KEEPCOMMENTS=true HUGO_ENABLEMISSINGTRANSLATIONPLACEHOLDERS=true hugo && grep -inorE "<\!-- raw HTML omitted -->|ZgotmplZ|\[i18n\]|\(<nil>\)|(&lt;nil&gt;)|hahahugo" public/
grep -ir '"XXX"' content && (echo "FAILED"; exit 1)
