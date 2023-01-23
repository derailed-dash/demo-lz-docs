#!/usr/bin/env bash

set -oeuE pipefail

function delete_old_app_engine_versions() {
  echo "project name is $1"
  echo "service name is $2"
  for version in $(gcloud app versions list --project=$1 --service=$2 --filter="traffic_split!=1.0" --format="csv(id)" | sed '1d')
  do
        eval $(gcloud app versions delete --service=$2 --project=$1 $version --quiet)
  done

}

function assert_variables_set() {
  local error=0
  local varname
  for varname in "$@"; do
    if [[ -z "${!varname-}" ]]; then
      echo "${varname} must be set" >&2
      error=1
    fi
  done
  if [[ ${error} = 1 ]]; then
    exit 1
  fi
}

function console_msg() {
  local msg=${1}
  local level=${2:-}
  local ts=${3:-}
  if [[ -z ${level} ]]; then level=INFO; fi
  if [[ -n ${ts} ]]; then ts=" [$(date +"%Y-%m-%d %H:%M")]"; fi

  echo ""
  if [[ ${level} == "ERROR" ]] || [[ ${level} == "CRIT" ]] || [[ ${level} == "FATAL" ]]; then
    (echo 2>&1)
    (echo >&2 "-> [${level}]${ts} ${msg}")
  else 
    (echo "-> [${level}]${ts} ${msg}")
  fi
}

function commit_and_push() {
    
    # set up deploy key for SSH access 
    mkdir -p ~/.ssh
    echo "${REPO_DEPLOY_KEY}" | tr -d '\r' > ~/.ssh/id_rsa
    chmod 600 ~/.ssh/id_rsa
    ssh-keyscan -H 'gitlab.com' >> ~/.ssh/known_hosts 2>/dev/null

    git add ${MD_FILE}
    git -c user.name="gitlab-ci" -c user.email="gitlab-ci@gitlab.com" commit --author="gitlab-ci <gitlab-ci@gitlab.com>" -m "Auto-generated Platform Tenants doc triggered by CI. Repo: ${CI_PROJECT_NAME}, job: ${CI_JOB_NAME}"

    git push ${REPO_URL} HEAD:master
}
