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
	rm -rf rel

	mkdir rel
}

_compileTypescript() {
	tsc --project .
}

_runStaticAnalysis() {
	tslint --project .
}

_unitTests() {
	node tests.js
}

_makeZip() {
	zip -q "rel/${BINARY_NAME}.zip" *.js
}

_uploadBuildArtefactsToBintray() {
	if [ ! "${PUBLISH_ARTEFACTS:-}" = "true" ]; then
		echo "publish not requested"
		return
	fi

	if [ "${BINTRAY_PROJECT:-}" = "" ]; then
		echo "BINTRAY_PROJECT not set; skipping uploadBuildArtefactsToBintray"
		return
	fi

	# Bintray creds in format "username:apikey"
	if [[ "${BINTRAY_CREDS:-}" =~ ^([^:]+):(.+) ]]; then
		local bintrayUser="${BASH_REMATCH[1]}"
		local bintrayApikey="${BASH_REMATCH[2]}"
	else
		echo "error: BINTRAY_CREDS not defined"
		exit 1
	fi

	# the CLI breaks automation unless opt-out..
	export JFROG_CLI_OFFER_CONFIG=false

	jfrog-cli bt upload \
		"--user=$bintrayUser" \
		"--key=$bintrayApikey" \
		--publish=true \
		'rel/*' \
		"$BINTRAY_PROJECT/main/$FRIENDLY_REV_ID" \
		"$FRIENDLY_REV_ID/"
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

	buildstep unitTests

	buildstep makeZip

	buildstep uploadBuildArtefactsToBintray

	buildstep cleanupHacks
}
