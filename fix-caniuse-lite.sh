#!/bin/bash

# Fix script for caniuse-lite missing statuses.js error
# Run this in your local project directory

echo "=== Fixing caniuse-lite error ==="

# Navigate to the web app directory
cd "$(dirname "$0")/apps/web" || exit 1

echo "1. Cleaning node_modules and lock files..."
rm -rf node_modules package-lock.json

echo "2. Cleaning npm cache..."
npm cache clean --force

echo "3. Reinstalling dependencies..."
npm install

echo "4. Verifying caniuse-lite installation..."
if [ -f "node_modules/caniuse-lite/dist/lib/statuses.js" ]; then
    echo "✓ statuses.js found"
    cat node_modules/caniuse-lite/dist/lib/statuses.js
else
    echo "✗ statuses.js NOT found - creating manually..."
    mkdir -p node_modules/caniuse-lite/dist/lib
    echo "module.exports = { 1: 'ls', 2: 'rec', 3: 'pr', 4: 'cr', 5: 'wd', 6: 'other', 7: 'unoff' };" > node_modules/caniuse-lite/dist/lib/statuses.js
    echo "✓ Created statuses.js manually"
fi

echo "5. Verifying other required files..."
for file in "node_modules/caniuse-lite/dist/lib/supported.js" \
            "node_modules/caniuse-lite/dist/unpacker/feature.js" \
            "node_modules/caniuse-lite/dist/unpacker/browsers.js"; do
    if [ -f "$file" ]; then
        echo "✓ $(basename $file) exists"
    else
        echo "✗ $(basename $file) MISSING"
    fi
done

echo "6. Testing build..."
npm run build

echo "=== Fix complete ==="
echo ""
echo "Now run: npm run dev"
