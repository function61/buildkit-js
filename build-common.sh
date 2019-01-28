#!/bin/bash -eu

buildstep() {
	local fn="$1"

	echo "# $fn"

	shift
	"_$fn" "$@"
}

_configure() {
	cp /etc/tsconfig.json .
	cp /etc/tslint.json .
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
	buildstep configure

	buildstep setupReleaseDirectory

	buildstep compileTypescript

	buildstep runStaticAnalysis

	buildstep checkFormatting

	buildstep tests
}
