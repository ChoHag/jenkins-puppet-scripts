#!/bin/bash
#
# Runs a syntax check on the modified files of a puppet tree only
# Variables to be set: PUPPET_SYNTAX_THREADS, PUPPET_BIN, ERB_BIN, RUBY_BIN
#
# scripts_job_name: Name of the jenkins job which is used to pull this repo into your jenkins environment

[ "$EXTRA_PATH" ] && export PATH="$EXTRA_PATH:$PATH";
scripts_job_name="jenkins-scripts"

# Catch the modified .pp manifests, puts them in an array and use that array to peform the puppet-syntax checks
declare -a files

for FILE in $(git log -1 --name-only --pretty=oneline | sed 1d | grep ".pp$");
do
        files=("${files[@]}" $FILE)
done

if [ ${#files[@]} -eq 0 ];then
        echo "No modified manifests to check"
else
        for i in ${files[@]};
        do
                echo "Syntax check on manifest $i:";
		bash -e /var/lib/jenkins/jobs/$scripts_job_name/check_puppet_syntax/check_puppet_syntax.sh $i
        done
fi

# Catch the modified modules, puts them in an array and use that array to peform the puppet-style checks
declare -a modules

for MODULE in $(git log -1 --name-only --pretty=oneline | sed 1d | grep "^modules/");
do
        modules=("${modules[@]}" $MODULE)
done

if [ ${#modules[@]} -eq 0 ];then
        echo "No modified modules to check"
else
        for i in ${modules[@]};
        do
                echo "Syntax check on module $i:";
		bash -e /var/lib/jenkins/jobs/$scripts_job_name/check_puppet_syntax/check_puppet_syntax.sh $i
        done
fi
