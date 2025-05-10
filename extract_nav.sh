#!/bin/bash

# Script to extract Scheme Name and NAV value from AMFI data and save as JSON
# Usage: ./extract_amfi_nav_json.sh

# Set the output file name
OUTPUT_FILE="amfi_nav_data.json"

# URL for the data
AMFI_URL="https://www.amfiindia.com/spages/NAVAll.txt"

echo "Downloading data from AMFI website..."
# Download the data
curl -s "$AMFI_URL" > amfi_raw_data.txt

echo "Extracting Scheme Name and NAV values..."

# Start the JSON array
echo "{" > "$OUTPUT_FILE"
echo "  \"extraction_date\": \"$(date -u +"%Y-%m-%dT%H:%M:%SZ")\"," >> "$OUTPUT_FILE"
echo "  \"source\": \"$AMFI_URL\"," >> "$OUTPUT_FILE"
echo "  \"schemes\": [" >> "$OUTPUT_FILE"

# Process the data and convert to JSON format
awk -F';' '
    BEGIN {
        first_record = 1
    }
    # Skip header lines, process only lines with semicolons and non-empty field 4 (Scheme Name)
    NF >= 5 && $4 != "" {
        # Clean the data
        scheme_name = $4
        nav_value = $5
        
        # Replace double quotes with escaped quotes for JSON compatibility
        gsub(/"/, "\\\"", scheme_name)
        
        # JSON record
        json_record = "    "
        if (first_record == 0) {
            json_record = json_record ","
        } else {
            first_record = 0
        }
        
        json_record = json_record "{\n"
        json_record = json_record "      \"scheme_name\": \"" scheme_name "\",\n"
        json_record = json_record "      \"nav\": \"" nav_value "\"\n"
        json_record = json_record "    }"
        
        print json_record
    }
' amfi_raw_data.txt >> "$OUTPUT_FILE"

# Close the JSON structure
echo "  ]" >> "$OUTPUT_FILE"
echo "}" >> "$OUTPUT_FILE"

# Clean up temporary file
rm amfi_raw_data.txt

echo "Data extraction complete. Results saved to $OUTPUT_FILE"

# Count the number of records (schemes) in the JSON file
RECORD_COUNT=$(grep -c "\"scheme_name\":" "$OUTPUT_FILE")
echo "Total records extracted: $RECORD_COUNT schemes"

# Validate JSON (if jq is installed)
if command -v jq >/dev/null 2>&1; then
    echo "Validating JSON format..."
    if jq empty "$OUTPUT_FILE" >/dev/null 2>&1; then
        echo "JSON validation successful"
    else
        echo "WARNING: JSON validation failed"
    fi
else
    echo "Note: Install 'jq' for JSON validation capabilities"
fi
