#!/bin/bash

# DevOps Central - Workflow Validation Script
# This script validates all workflows for syntax and common issues

set -e

echo "🔍 DevOps Central Workflow Validation"
echo "======================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Counters
TOTAL_FILES=0
VALID_FILES=0
ERROR_FILES=0

# Function to validate YAML syntax
validate_yaml() {
    local file="$1"
    echo -n "Validating $file... "
    
    if command -v yq >/dev/null 2>&1; then
        if yq eval '.' "$file" >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Valid${NC}"
            return 0
        else
            echo -e "${RED}❌ Invalid YAML${NC}"
            return 1
        fi
    elif command -v yamllint >/dev/null 2>&1; then
        if yamllint "$file" >/dev/null 2>&1; then
            echo -e "${GREEN}✅ Valid${NC}"
            return 0
        else
            echo -e "${RED}❌ Invalid YAML${NC}"
            return 1
        fi
    else
        echo -e "${YELLOW}⚠️ No YAML validator found${NC}"
        return 0
    fi
}

# Function to check GitHub Actions workflow syntax
validate_workflow() {
    local file="$1"
    local filename=$(basename "$file")
    
    # Check for required fields in workflow files
    if [[ "$file" == *"/workflows/"* ]]; then
        if ! grep -q "^name:" "$file"; then
            echo -e "${RED}❌ Missing 'name' field in $filename${NC}"
            return 1
        fi
        
        if ! grep -q "^on:" "$file"; then
            echo -e "${RED}❌ Missing 'on' field in $filename${NC}"
            return 1
        fi
        
        if ! grep -q "^jobs:" "$file"; then
            echo -e "${RED}❌ Missing 'jobs' field in $filename${NC}"
            return 1
        fi
    fi
    
    # Check for required fields in action files
    if [[ "$file" == *"/actions/"* ]] && [[ "$filename" == "action.yml" ]]; then
        if ! grep -q "^name:" "$file"; then
            echo -e "${RED}❌ Missing 'name' field in action $file${NC}"
            return 1
        fi
        
        if ! grep -q "^runs:" "$file"; then
            echo -e "${RED}❌ Missing 'runs' field in action $file${NC}"
            return 1
        fi
    fi
    
    return 0
}

# Function to check for common issues
check_common_issues() {
    local file="$1"
    local filename=$(basename "$file")
    local issues=0
    
    # Check for hardcoded versions
    if grep -q "node.*version.*['\"]1[6-9]['\"]" "$file"; then
        echo -e "${YELLOW}⚠️ Hardcoded Node.js version found in $filename${NC}"
        issues=$((issues + 1))
    fi
    
    # Check for missing error handling
    if [[ "$file" == *"/workflows/"* ]] && ! grep -q "if.*failure" "$file"; then
        echo -e "${YELLOW}⚠️ No error handling found in $filename${NC}"
        issues=$((issues + 1))
    fi
    
    # Check for security issues
    if grep -q "\${{.*secrets\." "$file" && ! grep -q "env:" "$file"; then
        echo -e "${YELLOW}⚠️ Secrets used without env context in $filename${NC}"
        issues=$((issues + 1))
    fi
    
    return $issues
}

# Main validation function
validate_file() {
    local file="$1"
    local filename=$(basename "$file")
    
    TOTAL_FILES=$((TOTAL_FILES + 1))
    
    echo -e "\n${BLUE}📋 Validating: $filename${NC}"
    echo "----------------------------------------"
    
    local valid=true
    
    # Validate YAML syntax
    if ! validate_yaml "$file"; then
        valid=false
    fi
    
    # Validate workflow/action structure
    if ! validate_workflow "$file"; then
        valid=false
    fi
    
    # Check for common issues
    if ! check_common_issues "$file"; then
        echo -e "${YELLOW}⚠️ Found warnings in $filename${NC}"
    fi
    
    if $valid; then
        VALID_FILES=$((VALID_FILES + 1))
        echo -e "${GREEN}✅ $filename is valid${NC}"
    else
        ERROR_FILES=$((ERROR_FILES + 1))
        echo -e "${RED}❌ $filename has errors${NC}"
    fi
}

# Find and validate all YAML files
echo -e "\n${BLUE}🔍 Finding workflow and action files...${NC}"

# Validate workflows
if [ -d ".github/workflows" ]; then
    find .github/workflows -name "*.yml" -o -name "*.yaml" | while read -r file; do
        validate_file "$file"
    done
fi

# Validate actions
if [ -d ".github/actions" ]; then
    find .github/actions -name "action.yml" -o -name "action.yaml" | while read -r file; do
        validate_file "$file"
    done
fi

# Validate config files
if [ -d "config" ]; then
    find config -name "*.yml" -o -name "*.yaml" | while read -r file; do
        validate_file "$file"
    done
fi

# Summary
echo -e "\n${BLUE}📊 Validation Summary${NC}"
echo "=================================="
echo -e "Total files: ${BLUE}$TOTAL_FILES${NC}"
echo -e "Valid files: ${GREEN}$VALID_FILES${NC}"
echo -e "Files with errors: ${RED}$ERROR_FILES${NC}"

if [ $ERROR_FILES -eq 0 ]; then
    echo -e "\n${GREEN}🎉 All files are valid!${NC}"
    exit 0
else
    echo -e "\n${RED}⚠️ Found $ERROR_FILES files with errors${NC}"
    exit 1
fi
