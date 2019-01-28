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

_checkFormatting() {
	local offenders=$(prettier --list-different --config /etc/prettier-config.json '*.ts')

	if [ ! -z "$offenders" ]; then
		>&2 echo "formatting errors: $offenders"
		exit 1
	fi
}

_setupReleaseDirectory() {
	mkdir -p rel/
}

_compileTypescript() {
	tsc --project .
}

_runStaticAnalysis() {
	tslint --project .
}

_tests() {
	npm test --no-update-notifier
}

standardBuildProcess() {
	local profile="$1"

	buildstep copyTsConfigAndTslint "$profile"

	buildstep setupReleaseDirectory

	buildstep compileTypescript

	buildstep runStaticAnalysis

	buildstep checkFormatting

	buildstep tests
}
