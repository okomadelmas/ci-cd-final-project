[1mdiff --git a/.tekton/tasks.yml b/.tekton/tasks.yml[m
[1mindex e69de29..bb5e2f8 100644[m
[1m--- a/.tekton/tasks.yml[m
[1m+++ b/.tekton/tasks.yml[m
[36m@@ -0,0 +1,57 @@[m
[32m+[m[32mapiVersion: tekton.dev/v1beta1[m
[32m+[m[32mkind: Task[m
[32m+[m[32mmetadata:[m
[32m+[m[32m  name: cleanup[m
[32m+[m[32mspec:[m
[32m+[m[32m  description: This task will clean up a workspace by deleting all of the files.[m
[32m+[m[32m  workspaces:[m
[32m+[m[32m    - name: source[m
[32m+[m[32m  steps:[m
[32m+[m[32m    - name: remove[m
[32m+[m[32m      image: alpine:3[m
[32m+[m[32m      env:[m
[32m+[m[32m        - name: WORKSPACE_SOURCE_PATH[m
[32m+[m[32m          value: $(workspaces.source.path)[m
[32m+[m[32m      workingDir: $(workspaces.source.path)[m
[32m+[m[32m      securityContext:[m
[32m+[m[32m        runAsNonRoot: false[m
[32m+[m[32m        runAsUser: 0[m
[32m+[m[32m      script: |[m
[32m+[m[32m        #!/usr/bin/env sh[m
[32m+[m[32m        set -eu[m
[32m+[m[32m        echo "Removing all files from ${WORKSPACE_SOURCE_PATH} ..."[m
[32m+[m[32m        # Delete any existing contents of the directory if it exists.[m
[32m+[m[32m        #[m
[32m+[m[32m        # We don't just "rm -rf ${WORKSPACE_SOURCE_PATH}" because ${WORKSPACE_SOURCE_PATH} might be "/"[m
[32m+[m[32m        # or the root of a mounted volume.[m
[32m+[m[32m        if [ -d "${WORKSPACE_SOURCE_PATH}" ] ; then[m
[32m+[m[32m          # Delete non-hidden files and directories[m
[32m+[m[32m          rm -rf "${WORKSPACE_SOURCE_PATH:?}"/*[m
[32m+[m[32m          # Delete files and directories starting with . but excluding ..[m
[32m+[m[32m          rm -rf "${WORKSPACE_SOURCE_PATH}"/.[!.]*[m
[32m+[m[32m          # Delete files and directories starting with .. plus any other character[m
[32m+[m[32m          rm -rf "${WORKSPACE_SOURCE_PATH}"/..?*[m
[32m+[m[32m        fi[m
[32m+[m[32m---[m
[32m+[m[32mapiVersion: tekton.dev/v1beta1[m
[32m+[m[32mkind: Task[m
[32m+[m[32mmetadata:[m
[32m+[m[32m  name: nose[m
[32m+[m[32mspec:[m
[32m+[m[32m  workspaces:[m
[32m+[m[32m    - name: source[m
[32m+[m[32m  params:[m
[32m+[m[32m    - name: args[m
[32m+[m[32m      description: Arguments to pass to nose[m
[32m+[m[32m      type: string[m
[32m+[m[32m      default: "-v"[m
[32m+[m[32m  steps:[m
[32m+[m[32m    - name: nosetests[m
[32m+[m[32m      image: python:3.9-slim[m
[32m+[m[32m      workingDir: $(workspaces.source.path)[m
[32m+[m[32m      script: |[m
[32m+[m[32m        #!/bin/bash[m
[32m+[m[32m        set -e[m
[32m+[m[32m        python -m pip install --upgrade pip wheel[m
[32m+[m[32m        pip install -r requirements.txt[m
[32m+[m[32m        nosetests $(params.args)[m
\ No newline at end of file[m
