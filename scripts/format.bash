#!/usr/bin/env bash

# TODO: Already set switch_case_indent in editorconfig.
shfmt --language-dialect bash --write \
	--case-indent \
	./**/*
