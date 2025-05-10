# extract-Scheme-Name-and-Asset-Value

I've created a shell script to extract the Scheme Name and Asset Value from the AMFI NAV data and save it as TSV and JSON both.

The script I created downloads the data from the AMFI website, extracts the Scheme Name and NAV (Asset Value) fields, and saves them in a tab-separated values (TSV) file. This approach works well for a quick extraction.

## Should the data be in JSON instead?

**Yes, JSON would be better for several reasons:**

1. **Structured data representation**: JSON provides a clear hierarchical structure that makes the relationship between data elements explicit.

2. **Universal compatibility**: JSON is widely supported across programming languages and platforms, making it easier to consume the data in various applications.

3. **Data typing**: JSON naturally preserves data types (like numbers vs. strings), whereas TSV treats everything as strings unless manually converted.

4. **Analysis-ready**: Many data analysis tools and libraries can directly import JSON data with proper structure.

5. **Additional metadata**: JSON allows for adding metadata fields without disrupting the core data structure.
