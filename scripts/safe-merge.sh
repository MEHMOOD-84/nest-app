#!/bin/bash

# ==============================
# SAFE FEATURE MERGE SCRIPT
# ==============================

set -e  # Stop script immediately if any command fails

FEATURE_BRANCH=$1
TEST_BRANCH="test"
DEVELOP_BRANCH="develop"
TEMP_BRANCH="temp-merge-$(date +%s)"

if [ -z "$FEATURE_BRANCH" ]; then
  echo "❌ Please provide feature branch name."
  echo "Usage: ./safe-merge.sh feature-branch-name"
  exit 1
fi

echo "🔄 Switching to develop branch..."
git checkout $DEVELOP_BRANCH
git pull origin $DEVELOP_BRANCH

echo "🌱 Creating temporary branch: $TEMP_BRANCH"
git checkout -b $TEMP_BRANCH

echo "🔀 Merging feature branch into temp..."
git merge $FEATURE_BRANCH

echo "🔀 Merging test branch into temp..."
git merge $TEST_BRANCH

echo "🧪 Running tests..."
npm run test

echo "✅ Tests Passed!"

echo "🗑 Deleting temporary branch..."
git checkout $DEVELOP_BRANCH
git branch -D $TEMP_BRANCH

echo "🚀 Merging feature branch into develop..."
git merge $FEATURE_BRANCH

echo "🗑 Deleting feature branch..."
git branch -d $FEATURE_BRANCH

echo "🎉 Feature successfully merged into develop!"