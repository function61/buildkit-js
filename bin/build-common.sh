#!/bin/bash -eu

buildstep() {
	local fn="$1"

	echo "# $fn"

	shift
	"_$fn" "$@"
}

_copyTsConfigAndTslint() {
	local profile="$1"

	if [ ! -f tsconfig.json ]; then
		cp "/etc/tsconfigs/tsconfig-${profile}.json" tsconfig.json
	fi

	if [ ! -f tslint.json ]; then
		cp /etc/tslint.json .
	fi
}

_setupReleaseDirectory() {
	mkdir -p rel/
}

_fetchDependencies() {
	yarn install
}

_tscCompile() {
	tsc --project .
}

_webpackCompile() {
	webpack --mode production
}

_runStaticAnalysis() {
	# code formatting (prettier.io) is also checked here
	tslint --project .
}

_tests() {
	npm test --no-update-notifier
}

# FASTBUILD ENV skips steps that aren't usually strictly necessary when doing minor modifications.
# however, if you encounter a bug, remember to run full build for static analysis etc., tests etc.
standardBuildProcess() {
	local profile="$1"

	buildstep copyTsConfigAndTslint "$profile"

	buildstep setupReleaseDirectory

	if [ ! -n "${FASTBUILD:-}" ]; then
		buildstep fetchDependencies
	fi

	# for frontend profiles, use Webpack to bundle the code,
	# for other targets (like Node.js / Lambda, just use TypeScript directly)
	if [ "$profile" = "frontend" ]; then
		buildstep webpackCompile
	else
		buildstep tscCompile
	fi

	if [ ! -n "${FASTBUILD:-}" ]; then
		buildstep runStaticAnalysis

		buildstep tests
	fi
}
