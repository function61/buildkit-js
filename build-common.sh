#!/bin/bash -eu

buildstep() {
	local fn="$1"

	echo "# $fn"

	"_$fn"
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
	# TODO: "$ npm test" would probably be more idiomatic?
	node tests.js
}

_cleanupHacks() {
	rm -rf tsconfig.json tslint.json
}

standardBuildProcess() {
	buildstep configure

	buildstep setupReleaseDirectory

	buildstep compileTypescript

	buildstep runStaticAnalysis

	buildstep checkFormatting

	buildstep tests

	buildstep cleanupHacks
}
