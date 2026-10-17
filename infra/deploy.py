#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.9"
# dependencies = ["boto3>=1.34"]
# ///
from __future__ import annotations

import os
import sys
import time

import boto3

TIMEOUT = 900


def say(msg: str) -> None:
    print(f"[deploy] {msg}", flush=True)


def fail(msg: str) -> None:
    print(f"[deploy] error: {msg}", file=sys.stderr, flush=True)
    sys.exit(1)


def env(name: str) -> str:
    value = os.environ.get(name, "").strip()
    if not value:
        fail(f"{name} is not set")
    return value


def release(client, app_id: str, branch: str, commit: str) -> None:
    job = client.start_job(appId=app_id, branchName=branch, jobType="RELEASE", commitId=commit)
    job_id = job["jobSummary"]["jobId"]
    say(f"amplify job {job_id} for {commit[:7]}")
    deadline = time.time() + TIMEOUT
    while time.time() < deadline:
        status = client.get_job(appId=app_id, branchName=branch, jobId=job_id)["job"]["summary"]["status"]
        say(f"status: {status}")
        if status == "SUCCEED":
            return
        if status in ("FAILED", "CANCELLED"):
            fail(f"amplify job {job_id} {status}")
        time.sleep(15)
    fail(f"amplify job {job_id} still running after {TIMEOUT}s")


def main() -> None:
    app_id = env("AMPLIFY_APP_ID")
    branch = env("DEPLOY_BRANCH")
    commit = env("GITHUB_SHA")
    region = os.environ.get("AWS_REGION", "us-east-1")
    client = boto3.session.Session(region_name=region).client("amplify")
    try:
        release(client, app_id, branch, commit)
    except Exception as error:
        fail(f"release failed ({type(error).__name__})")
    say("deployed")


if __name__ == "__main__":
    main()
