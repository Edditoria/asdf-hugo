#!/usr/bin/env bash

shellcheck --shell=bash --external-sources \
	bin/* --source-path=template/lib/ \
	lib/* \
	scripts/*

# TODO: Already set switch_case_indent in editorconfig.
shfmt --language-dialect bash --diff \
	--case-indent \
	./**/*
